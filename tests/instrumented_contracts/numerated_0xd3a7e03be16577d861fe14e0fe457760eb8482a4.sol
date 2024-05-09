1 // https://twitter.com/CHAOS_ERC
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.20;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address who) external view returns (uint256);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function transfer(address to, uint256 value) external returns (bool);
12     function approve(address spender, uint256 value) external returns (bool);
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 interface InterfaceLP {
19     function sync() external;
20     function mint(address to) external returns (uint liquidity);
21 }
22 
23 abstract contract ERC20Detailed is IERC20 {
24     string private _name;
25     string private _symbol;
26     uint8 private _decimals;
27 
28     constructor(
29         string memory _tokenName,
30         string memory _tokenSymbol,
31         uint8 _tokenDecimals
32     ) {
33         _name = _tokenName;
34         _symbol = _tokenSymbol;
35         _decimals = _tokenDecimals;
36     }
37 
38     function name() public view returns (string memory) {
39         return _name;
40     }
41 
42     function symbol() public view returns (string memory) {
43         return _symbol;
44     }
45 
46     function decimals() public view returns (uint8) {
47         return _decimals;
48     }
49 }
50 
51 interface IDEXRouter {
52     function factory() external pure returns (address);
53     function WETH() external pure returns (address);
54 }
55 
56 interface IDEXFactory {
57     function createPair(address tokenA, address tokenB)
58     external
59     returns (address pair);
60 }
61 
62 contract Ownable {
63     address private _owner;
64 
65     event OwnershipRenounced(address indexed previousOwner);
66 
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71 
72     constructor() {
73         _owner = msg.sender;
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(msg.sender == _owner, "Not owner");
82         _;
83     }
84 
85     function renounceOwnership() public onlyOwner {
86         emit OwnershipRenounced(_owner);
87         _owner = address(0);
88     }
89 
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     function _transferOwnership(address newOwner) internal {
95         require(newOwner != address(0));
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 interface IWETH {
102     function deposit() external payable;
103 }
104 
105 contract Chaos is ERC20Detailed, Ownable {
106 
107     uint256 public rateNumerator = 1914882956;
108     uint256 public rateDenominator = 100000000000;
109 
110     uint256 public riftFrequency = 3 hours;
111     uint256 public nextRift;
112     bool public autoRift = true;
113 
114     uint256 public maxTxnAmount;
115     uint256 public maxWallet;
116 
117     uint256 public percentForSingularity = 50;
118     bool public singularityEnabled = true;
119     uint256 public singularityFrequency = 3 hours;
120     uint256 public nextSingularity;
121 
122     uint256 private constant DECIMALS = 18;
123     uint256 private constant INITIAL_TOKENS_SUPPLY = 8_888_888 * 10**DECIMALS;
124     uint256 private constant TOTAL_PARTS = type(uint256).max - (type(uint256).max % INITIAL_TOKENS_SUPPLY);
125     uint256 private constant MIN_SUPPLY = 8 * 10**DECIMALS;
126 
127     event Rift(uint256 indexed time, uint256 totalSupply);
128     event RemovedLimits();
129     event Singularity(uint256 indexed amount);
130 
131     IWETH public immutable weth;
132 
133     IDEXRouter public immutable router;
134     address public immutable pair;
135     
136     bool public limitsInEffect = true;
137     bool public lpAdded = false;
138     
139     uint256 private _totalSupply;
140     uint256 private _partsPerToken;
141 
142     mapping(address => uint256) private _partBalances;
143     mapping(address => mapping(address => uint256)) private _allowedTokens;
144 
145     modifier validRecipient(address to) {
146         require(to != address(0x0));
147         _;
148     }
149 
150     constructor() ERC20Detailed(block.chainid==1 ? "Harbinger" : "HTEST", block.chainid==1 ? "CHAOS" : "HTEST", 18) {
151         address dexAddress;
152         if(block.chainid == 1){
153             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
154         } else if(block.chainid == 5){
155             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
156         } else if (block.chainid == 97){
157             dexAddress = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
158         } else {
159             revert("Chain not configured");
160         }
161 
162         router = IDEXRouter(dexAddress);
163 
164         _totalSupply = INITIAL_TOKENS_SUPPLY;
165         _partBalances[address(this)] = TOTAL_PARTS;
166         _partsPerToken = TOTAL_PARTS/(_totalSupply);
167 
168         maxTxnAmount = _totalSupply * 1 / 100;
169         maxWallet = _totalSupply * 1 / 100;
170 
171         weth = IWETH(router.WETH());
172         pair = IDEXFactory(router.factory()).createPair(address(this), router.WETH());
173 
174         emit Transfer(address(0x0), address(this), balanceOf(address(this)));
175     }
176 
177     function totalSupply() external view override returns (uint256) {
178         return _totalSupply;
179     }
180 
181     function allowance(address owner_, address spender) external view override returns (uint256){
182         return _allowedTokens[owner_][spender];
183     }
184 
185     function balanceOf(address who) public view override returns (uint256) {
186         return _partBalances[who]/(_partsPerToken);
187     }
188 
189     function shouldRift() public view returns (bool) {
190         return nextRift <= block.timestamp;
191     }
192 
193     function shouldSingularity() public view returns (bool) {
194         return nextSingularity <= block.timestamp;
195     }
196 
197     function lpSync() internal {
198         InterfaceLP _pair = InterfaceLP(pair);
199         _pair.sync();
200     }
201 
202     function transfer(address to, uint256 value) external override validRecipient(to) returns (bool){
203         _transferFrom(msg.sender, to, value);
204         return true;
205     }
206 
207     function removeLimits() external onlyOwner {
208         require(limitsInEffect, "Limits already removed");
209         limitsInEffect = false;
210         emit RemovedLimits();
211     }
212 
213     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
214         if(limitsInEffect){
215             if (sender == pair || recipient == pair){
216                 require(amount <= maxTxnAmount, "Max Tx Exceeded");
217             }
218             if (recipient != pair){
219                 require(balanceOf(recipient) + amount <= maxWallet, "Max Wallet Exceeded");
220             }
221         }
222 
223         if(recipient == pair){
224             if(autoRift && shouldRift()){
225                 rift();
226             }
227             if (shouldSingularity()) {
228                 autoSingularity();
229             }
230         }
231 
232         uint256 partAmount = amount*(_partsPerToken);
233 
234         _partBalances[sender] = _partBalances[sender]-(partAmount);
235         _partBalances[recipient] = _partBalances[recipient]+(partAmount);
236 
237         emit Transfer(sender, recipient, partAmount/(_partsPerToken));
238 
239         return true;
240     }
241 
242     function transferFrom(address from, address to,  uint256 value) external override validRecipient(to) returns (bool) {
243         if (_allowedTokens[from][msg.sender] != type(uint256).max) {
244             require(_allowedTokens[from][msg.sender] >= value,"Insufficient Allowance");
245             _allowedTokens[from][msg.sender] = _allowedTokens[from][msg.sender]-(value);
246         }
247         _transferFrom(from, to, value);
248         return true;
249     }
250 
251     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool){
252         uint256 oldValue = _allowedTokens[msg.sender][spender];
253         if (subtractedValue >= oldValue) {
254             _allowedTokens[msg.sender][spender] = 0;
255         } else {
256             _allowedTokens[msg.sender][spender] = oldValue-(
257                 subtractedValue
258             );
259         }
260         emit Approval(
261             msg.sender,
262             spender,
263             _allowedTokens[msg.sender][spender]
264         );
265         return true;
266     }
267 
268     function increaseAllowance(address spender, uint256 addedValue) external returns (bool){
269         _allowedTokens[msg.sender][spender] = _allowedTokens[msg.sender][
270         spender
271         ]+(addedValue);
272         emit Approval(
273             msg.sender,
274             spender,
275             _allowedTokens[msg.sender][spender]
276         );
277         return true;
278     }
279 
280     function approve(address spender, uint256 value) public override returns (bool){
281         _allowedTokens[msg.sender][spender] = value;
282         emit Approval(msg.sender, spender, value);
283         return true;
284     }
285 
286     function getSupplyDeltaOnNextRift() external view returns (uint256){
287         return (_totalSupply*rateNumerator)/rateDenominator;
288     }
289 
290     function rift() private returns (uint256) {
291         uint256 time = block.timestamp;
292 
293         uint256 supplyDelta = (_totalSupply*rateNumerator)/rateDenominator;
294         
295         nextRift += riftFrequency;
296 
297         if (supplyDelta == 0) {
298             emit Rift(time, _totalSupply);
299             return _totalSupply;
300         }
301 
302         _totalSupply = _totalSupply-supplyDelta;
303 
304         if (_totalSupply < MIN_SUPPLY) {
305             _totalSupply = MIN_SUPPLY;
306             autoRift = false;
307         }
308 
309         _partsPerToken = TOTAL_PARTS/(_totalSupply);
310 
311         lpSync();
312 
313         emit Rift(time, _totalSupply);
314         return _totalSupply;
315     }
316 
317     function manualRift() external {
318         require(shouldRift(), "Not in time");
319         rift();
320     }
321 
322     function autoSingularity() internal {
323         nextSingularity = block.timestamp + singularityFrequency;
324 
325         uint256 liquidityPairBalance = balanceOf(pair);
326 
327         uint256 amountToBurn = liquidityPairBalance * percentForSingularity / 10000;
328 
329         if (amountToBurn > 0) {
330             uint256 partAmountToBurn = amountToBurn*(_partsPerToken);
331             _partBalances[pair] -= partAmountToBurn;
332             _partBalances[address(0xdead)] += partAmountToBurn;
333             emit Transfer(pair, address(0xdead), amountToBurn);
334         }
335 
336         InterfaceLP _pair = InterfaceLP(pair);
337         _pair.sync();
338         emit Singularity(amountToBurn);
339     }
340 
341     function manualSingularity() external {
342         require(shouldSingularity(), "Must wait for cooldown to finish");
343 
344         nextSingularity = block.timestamp + singularityFrequency;
345 
346         uint256 liquidityPairBalance = balanceOf(pair);
347 
348         uint256 amountToBurn = liquidityPairBalance * percentForSingularity / 10000;
349 
350         if (amountToBurn > 0) {
351             uint256 partAmountToBurn = amountToBurn*(_partsPerToken);
352             _partBalances[pair] -= partAmountToBurn;
353             _partBalances[address(0xdead)] += partAmountToBurn;
354             emit Transfer(pair, address(0xdead), amountToBurn);
355         }
356 
357         InterfaceLP _pair = InterfaceLP(pair);
358         _pair.sync();
359         emit Singularity(amountToBurn);
360     }
361 
362     function initiate(address _to) external payable {
363         require(!lpAdded, "LP already added");
364         
365         require(address(this).balance > 0 && balanceOf(address(this)) > 0);
366 
367         weth.deposit{value: address(this).balance}();
368 
369         _partBalances[pair] += _partBalances[address(this)];
370         _partBalances[address(this)] = 0;
371         emit Transfer(address(this), pair, _partBalances[pair]/(_partsPerToken));
372 
373         IERC20(address(weth)).transfer(address(pair), IERC20(address(weth)).balanceOf(address(this)));
374         
375         InterfaceLP(pair).mint(_to);
376         lpAdded = true;
377 
378         nextRift = block.timestamp + riftFrequency;
379         nextSingularity = block.timestamp + singularityFrequency;
380     }
381 }