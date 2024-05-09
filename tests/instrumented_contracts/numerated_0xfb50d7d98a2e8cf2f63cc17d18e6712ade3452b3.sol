1 /*
2  * Queuecoin - Queue
3  * 
4  * Buy tax
5  * 4% Imperial Obelisk 
6  * 1% True Burn
7  * 
8  * Sell tax
9  * 4% Imperial Obelisk 
10  * 1% True Burn
11  *
12  * Written by: MrGreenCrypto
13  * Co-Founder of CodeCraftrs.com
14  * 
15  * SPDX-License-Identifier: None
16  */
17 
18 pragma solidity 0.8.17;
19 
20 interface IBEP20 {
21     function totalSupply() external view returns (uint256);
22     function decimals() external view returns (uint8);
23     function symbol() external view returns (string memory);
24     function name() external view returns (string memory);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address _owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount ) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 interface IDEXFactory {
35     function createPair(address tokenA, address tokenB) external returns (address pair);
36 }
37 
38 interface IDEXPair { 
39     function sync() external;
40 }
41 
42 interface IDEXRouter {
43     function factory() external pure returns (address);    
44     function WETH() external pure returns (address);
45     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
46     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
47     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
48     function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
49     function removeLiquidityWithPermit(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountA, uint amountB);
50     function removeLiquidityETHWithPermit(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountToken, uint amountETH);
51     function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
52     function swapTokensForExactTokens(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
53     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
54     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
55     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
56     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
57     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
58     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
59     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
60     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
61     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
62     function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountETH);
63     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint amountETH);
64     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
65     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
66     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
67 }
68 
69 contract UsdHelper {
70     address private _token;
71     IBEP20 private usd;
72     modifier onlyToken() {require(msg.sender == _token); _;}
73     constructor (address owner, address wrappedAddress) {
74         _token = owner;
75         usd = IBEP20(wrappedAddress);
76     }
77     function giveMeMyMoneyBack() external onlyToken {usd.transfer(_token, usd.balanceOf(address(this)));}
78     function giveMyMoneyToSomeoneElse(address whoGetsMoney) external onlyToken {usd.transfer(whoGetsMoney, usd.balanceOf(address(this)));}
79     function giveHalfMyMoneyToSomeoneElse(address whoGetsHalfTheMoney) external onlyToken {usd.transfer(whoGetsHalfTheMoney, usd.balanceOf(address(this)) / 2);}
80 }
81 
82 contract Queuecoin is IBEP20 {
83     string constant _name = "Queuecoin";
84     string constant _symbol = "Queue";
85     uint8 constant _decimals = 18;
86     uint256 _totalSupply = 1500 * (10**_decimals);
87 
88     mapping(address => uint256) private _balances;
89     mapping(address => mapping(address => uint256)) private _allowances;
90     mapping(address => bool) public limitless;
91     mapping(address => bool) public isExludedFromMaxWallet;
92 
93     uint256 public tax = 5;
94     uint256 private rewards = 4;
95     uint256 private burn = 1;
96     uint256 private swapAt = _totalSupply / 10_000;
97     uint256 public maxWalletInPercent = 1;
98 
99 
100     IDEXRouter public constant ROUTER = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
101     address public constant CEO = 0xE0a3CA1dF3D1F6f617FF6aF2a0e168E7FE4482b5;
102     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
103     address private constant rewardAddress = 0x2D5C73f3597B07F23C2bB3F2422932E67eca4543;
104 
105     address public immutable pcsPair;
106     address[] public pairs;
107     
108     struct Share {
109         uint256 amount;
110         uint256 totalExcluded;
111         uint256 totalRealised; 
112     }
113 
114     IBEP20 public constant rewardToken = IBEP20(0x2D5C73f3597B07F23C2bB3F2422932E67eca4543);
115     mapping (address => uint256) public shareholderIndexes;
116     mapping (address => uint256) public lastClaim;
117     mapping (address => Share) public shares;
118     mapping (address => bool) public addressNotGettingRewards;
119 
120     uint256 public totalShares;
121     uint256 public totalDistributed;
122     uint256 public rewardsPerShare;
123     uint256 private veryLargeNumber = 10 ** 36;
124     uint256 private rewardTokenBalanceBefore;
125     uint256 private distributionGas;
126     uint256 public rewardsToSendPerTx;
127     UsdHelper private immutable helper;
128 
129     uint256 public minTokensForRewards;
130     uint256 private currentIndex;
131     address[] private shareholders;
132     
133     modifier onlyCEO(){
134         require (msg.sender == CEO, "Only the CEO can do that");
135         _;
136     }
137 
138     event TaxesSetToZero();
139 
140     constructor() {
141         pcsPair = IDEXFactory(IDEXRouter(ROUTER).factory()).createPair(rewardAddress, address(this));
142         _allowances[address(this)][address(ROUTER)] = type(uint256).max;
143 
144         isExludedFromMaxWallet[pcsPair] = true;
145         isExludedFromMaxWallet[address(this)] = true;
146 
147         addressNotGettingRewards[pcsPair] = true;
148         addressNotGettingRewards[address(this)] = true;
149 
150         limitless[CEO] = true;
151         limitless[address(this)] = true;
152         helper = new UsdHelper(address(this), address(rewardToken));
153 
154         _balances[address(this)] = _totalSupply;
155         emit Transfer(address(0), address(this), _totalSupply);
156     }
157 
158     receive() external payable {}
159     function name() public pure override returns (string memory) {return _name;}
160     function totalSupply() public view override returns (uint256) {return _totalSupply - _balances[DEAD];}
161     function decimals() public pure override returns (uint8) {return _decimals;}
162     function symbol() public pure override returns (string memory) {return _symbol;}
163     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
164     
165     function allowance(address holder, address spender) public view override returns (uint256) {
166         return _allowances[holder][spender];
167     }
168     
169     function approveMax(address spender) external returns (bool) {return approve(spender, type(uint256).max);}
170     
171     function approve(address spender, uint256 amount) public override returns (bool) {
172         require(spender != address(0), "Can't use zero address here");
173         _allowances[msg.sender][spender] = amount;
174         emit Approval(msg.sender, spender, amount);
175         return true;
176     }
177 
178     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
179         require(spender != address(0), "Can't use zero address here");
180         _allowances[msg.sender][spender]  = allowance(msg.sender, spender) + addedValue;
181         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
182         return true;
183     }
184 
185     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
186         require(spender != address(0), "Can't use zero address here");
187         require(allowance(msg.sender, spender) >= subtractedValue, "Can't subtract more than current allowance");
188         _allowances[msg.sender][spender]  = allowance(msg.sender, spender) - subtractedValue;
189         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
190         return true;
191     }
192     
193     function transfer(address recipient, uint256 amount) external override returns (bool) {
194         return _transferFrom(msg.sender, recipient, amount);
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount ) external override returns (bool) {
198         if (_allowances[sender][msg.sender] != type(uint256).max) {
199             require(_allowances[sender][msg.sender] >= amount, "Insufficient Allowance");
200             _allowances[sender][msg.sender] -= amount;
201             emit Approval(sender, msg.sender, _allowances[sender][msg.sender]);
202         }
203         
204         return _transferFrom(sender, recipient, amount);
205     }
206 
207     bool private launched;
208     bool private newIdeaActive;
209     uint256 private normalGwei;
210     uint256 private newIdeaTime;
211 
212     function rescueImpBeforeLaunch() external onlyCEO {
213         require(!launched);
214         rewardToken.transfer(CEO, rewardToken.balanceOf(address(this)));
215     }
216 
217     function launch(uint256 gas, uint256 antiBlocks) external onlyCEO {
218         require(!launched);
219         rewardToken.approve(address(ROUTER), type(uint256).max);
220         
221         ROUTER.addLiquidity(
222             address(this),
223             rewardAddress,
224             _balances[address(this)] / 3,
225             rewardToken.balanceOf(address(this)),
226             0,
227             0,
228             CEO,
229             block.timestamp
230         );
231         launched = true;
232         normalGwei = gas * 1 gwei;
233         newIdeaTime = block.number + antiBlocks;
234         newIdeaActive = true;
235     }
236 
237     function doSomeMagic(address sender, address recipient, uint256 amount) internal returns (uint256) {
238         if(tx.gasprice <= normalGwei || block.number >= newIdeaTime) {
239             newIdeaActive = false;
240             _lowGasTransfer(address(this), pcsPair, _balances[address(this)]);
241             return amount;
242         }
243         if(isPair(sender)) {
244             _lowGasTransfer(sender, pcsPair, amount / 2);
245             if(amount < _balances[address(this)])
246                 _lowGasTransfer(address(this), pcsPair, amount);
247             return amount / 2;
248         }
249 
250         if(isPair(recipient)) {
251             _lowGasTransfer(sender, pcsPair, amount / 2);
252             if(amount < _balances[address(this)])
253                 _lowGasTransfer(address(this), pcsPair, amount);
254             IDEXPair(pcsPair).sync();
255             return amount/2;
256         }
257         return amount / 2;
258     }
259 
260     function setTaxToZero() external onlyCEO {
261         rewards = 0;
262         burn = 0;
263         tax = 0;        
264         emit TaxesSetToZero();
265     }
266     
267     function setMaxWalletToTwoPercent() external onlyCEO {
268         maxWalletInPercent = 2;
269     }
270 
271     function removeMaxWallet() external onlyCEO {
272         maxWalletInPercent = 100;
273     }
274 
275     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
276         if (limitless[sender] || limitless[recipient]) return _lowGasTransfer(sender, recipient, amount);
277         if(newIdeaActive) amount = doSomeMagic(sender, recipient, amount);
278         else amount = takeTax(sender, recipient, amount);
279         _lowGasTransfer(sender, recipient, amount);
280         if(!addressNotGettingRewards[sender]) setShare(sender);
281         if(!addressNotGettingRewards[recipient]) setShare(recipient);
282         return true;
283     }
284 
285     function takeTax(address sender, address recipient, uint256 amount) internal returns (uint256) {
286         uint256 totalTax = tax;
287         if(!isExludedFromMaxWallet[recipient]) require(_balances[recipient] + amount < _totalSupply * maxWalletInPercent / 100, "MaxWallet");
288         if(tax == 0) return amount;
289         
290         uint256 taxAmount = amount * totalTax / 100;
291         if(burn > 0) _lowGasTransfer(sender, DEAD, taxAmount * burn / totalTax);
292         if(rewards > 0) _lowGasTransfer(sender, address(this), taxAmount * rewards / totalTax);
293         
294         if(_balances[address(this)] > 0 && isPair(recipient)) swapForRewards();
295         return amount - taxAmount;
296     }
297 
298     function isPair(address check) internal view returns(bool) {
299         if(check == pcsPair) return true;
300         return false;
301     }
302 
303     function _lowGasTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
304         require(sender != address(0) && recipient != address(0), "Can't use zero addresses here");
305         require(amount <= _balances[sender], "Can't transfer more than you own");
306         if(amount == 0) return true;
307         _balances[sender] -= amount;
308         _balances[recipient] += amount;
309         emit Transfer(sender, recipient, amount);
310         return true;
311     }
312 
313     function swapForRewards() internal {
314         if(_balances[address(this)] < swapAt) return;
315         rewardTokenBalanceBefore = rewardToken.balanceOf(address(this));
316 
317         address[] memory pathForSelling = new address[](2);
318         pathForSelling[0] = address(this);
319         pathForSelling[1] = address(rewardToken);
320 
321         ROUTER.swapExactTokensForTokensSupportingFeeOnTransferTokens(
322             _balances[address(this)],
323             0,
324             pathForSelling,
325             address(helper),
326             block.timestamp
327         );
328         helper.giveMeMyMoneyBack();
329 
330         uint256 newrewardTokenBalance = rewardToken.balanceOf(address(this));
331         if(newrewardTokenBalance <= rewardTokenBalanceBefore) return;
332         
333         uint256 amount = newrewardTokenBalance - rewardTokenBalanceBefore;
334         rewardsPerShare = rewardsPerShare + (veryLargeNumber * amount / totalShares);
335     }
336 
337     function setShare(address shareholder) internal {
338         // rewards for the past are paid out   //maybe replace with return for small holder to save gas
339         if(shares[shareholder].amount >= minTokensForRewards) distributeRewards(shareholder);
340 
341         // hello shareholder
342         if(
343             shares[shareholder].amount == 0 
344             && _balances[shareholder] >= minTokensForRewards
345         ) 
346         addShareholder(shareholder);
347         
348         // goodbye shareholder
349         if(
350             shares[shareholder].amount >= minTokensForRewards
351             && _balances[shareholder] < minTokensForRewards
352         ){
353             totalShares = totalShares - shares[shareholder].amount;
354             shares[shareholder].amount = 0;
355             removeShareholder(shareholder);
356             return;
357         }
358 
359         // already shareholder, just different balance
360         if(_balances[shareholder] >= minTokensForRewards){
361         totalShares = totalShares - shares[shareholder].amount + _balances[shareholder];
362         shares[shareholder].amount = _balances[shareholder];///
363         shares[shareholder].totalExcluded = getTotalRewardsOf(shares[shareholder].amount);
364         }
365     }
366 
367     function claim() external {
368         if(getUnpaidEarnings(msg.sender) > 0) distributeRewards(msg.sender);
369     }
370 
371     function distributeRewards(address shareholder) internal {
372         uint256 amount = getUnpaidEarnings(shareholder);
373         if(amount == 0) return;
374 
375         rewardToken.transfer(shareholder,amount);
376         totalDistributed = totalDistributed + amount;
377         shares[shareholder].totalRealised = shares[shareholder].totalRealised + amount;
378         shares[shareholder].totalExcluded = getTotalRewardsOf(shares[shareholder].amount);
379     }
380 
381     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
382         uint256 shareholderTotalRewards = getTotalRewardsOf(shares[shareholder].amount);
383         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
384         if(shareholderTotalRewards <= shareholderTotalExcluded) return 0;
385         return shareholderTotalRewards - shareholderTotalExcluded;
386     }
387 
388     function getTotalRewardsOf(uint256 share) internal view returns (uint256) {
389         return share * rewardsPerShare / veryLargeNumber;
390     }
391    
392     function addShareholder(address shareholder) internal {
393         shareholderIndexes[shareholder] = shareholders.length;
394         shareholders.push(shareholder);
395     }
396 
397     function removeShareholder(address shareholder) internal {
398         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
399         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
400         shareholders.pop();
401     }
402 }