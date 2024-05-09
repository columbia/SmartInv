1 /**
2 
3 https://t.me/BobcatAI
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.18;
10 
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
17     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
18     
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
21 
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
24 
25     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
27         if(c / a != b) return(false, 0); return(true, c);}}
28 
29     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
31 
32     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         unchecked{require(b <= a, errorMessage); return a - b;}}
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b > 0, errorMessage); return a / b;}}
40 
41     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b > 0, errorMessage); return a % b;}}}
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function circulatingSupply() external view returns (uint256);
47     function decimals() external view returns (uint8);
48     function symbol() external view returns (string memory);
49     function name() external view returns (string memory);
50     function getOwner() external view returns (address);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address _owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);}
58 
59 abstract contract Ownable {
60     address internal owner;
61     constructor(address _owner) {owner = _owner;}
62     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
63     function isOwner(address account) public view returns (bool) {return account == owner;}
64     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
65     event OwnershipTransferred(address owner);
66 }
67 
68 interface stakeIntegration {
69     function stakingWithdraw(address depositor, uint256 _amount) external;
70     function stakingDeposit(address depositor, uint256 _amount) external;
71 }
72 
73 interface tokenStaking {
74     function deposit(uint256 amount) external;
75     function withdraw(uint256 amount) external;
76 }
77 
78 interface IFactory{
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81 }
82 
83 interface IRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86     
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95 
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline) external;
102 }
103 
104 contract BobcatAI is IERC20, tokenStaking, Ownable {
105     using SafeMath for uint256;
106     string private constant _name = 'Bobcat AI';
107     string private constant _symbol = 'BOBCAT';
108     uint8 private constant _decimals = 9;
109     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
110     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
111     uint256 public _maxSellAmount = ( _totalSupply * 100 ) / 10000;
112     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
113     mapping (address => uint256) _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     struct UserStats{bool whitelist; bool isBot; bool feeExempt;}
116     mapping(address => UserStats) private isFeeExempt;
117     IRouter router;
118     address public pair;
119     uint256 private liquidityFee = 0;
120     uint256 private marketingFee = 200;
121     uint256 private developmentFee = 100;
122     uint256 private stakingFee = 0;
123     uint256 private tokenFee = 0;
124     uint256 private totalFee = 2000;
125     uint256 private sellFee = 2000;
126     uint256 private transferFee = 2000;
127     uint256 private denominator = 10000;
128     bool private swapEnabled = true;
129     bool private whitelistAllowed = false;
130     bool private tradingAllowed = false;
131     mapping(address => uint256) private lastTransferTimestamp;
132     bool public transferDelayEnabled = true;
133     uint256 private swapTimes;
134     bool private swapping;
135     bool private liquidityAdd;
136     modifier liquidityCreation {liquidityAdd = true; _; liquidityAdd = false;}
137     uint256 private swapAmount = 2;
138     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
139     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
140     modifier lockTheSwap {swapping = true; _; swapping = false;}
141     mapping(address => uint256) public amountStaked;
142     uint256 public totalStaked;
143     stakeIntegration internal stakingContract;
144     
145     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
146     address internal development_receiver = 0x6b3E4261576d6Dd0c6EDa6714ab9E390F76978D8; 
147     address internal marketing_receiver = 0xe810E5C054D2D52E8148759BaA5fF3494Df466Db;
148     address internal liquidity_receiver = 0x6b3E4261576d6Dd0c6EDa6714ab9E390F76978D8;
149     address internal staking_receiver = 0x6b3E4261576d6Dd0c6EDa6714ab9E390F76978D8;
150     address internal token_receiver = 0x000000000000000000000000000000000000dEaD;
151     
152     event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
153     event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
154     event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
155     event SetisBot(address indexed account, bool indexed isBot, uint256 indexed timestamp);
156     event TradingEnabled(address indexed account, uint256 indexed timestamp);
157     event isWhitelisted(address indexed account, bool indexed isWhitelisted, uint256 indexed timestamp);
158     event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
159     event SetDividendExempt(address indexed account, bool indexed isExempt, uint256 indexed timestamp);
160     event Launch(uint256 indexed whitelistTime, bool indexed whitelistAllowed, uint256 indexed timestamp);
161     event SetInternalAddresses(address indexed marketing, address indexed liquidity, address indexed development, uint256 timestamp);
162     event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
163     event SetDistributionCriteria(uint256 indexed minPeriod, uint256 indexed minDistribution, uint256 indexed distributorGas, uint256 timestamp);
164     event SetParameters(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed maxTransfer, uint256 timestamp);
165     event SetStructure(uint256 indexed total, uint256 indexed sell, uint256 transfer, uint256 indexed timestamp);
166     event CreateLiquidity(uint256 indexed tokenAmount, uint256 indexed ETHAmount, address indexed wallet, uint256 timestamp);
167 
168     constructor() Ownable(msg.sender) {
169         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
170         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
171         router = _router;
172         pair = _pair;
173         isFeeExempt[address(this)].whitelist = true;
174         isFeeExempt[msg.sender].whitelist = true;
175         isFeeExempt[address(this)].feeExempt = true;
176         isFeeExempt[liquidity_receiver].feeExempt = true;
177         isFeeExempt[marketing_receiver].feeExempt = true;
178         isFeeExempt[development_receiver].feeExempt = true;
179         isFeeExempt[address(DEAD)].feeExempt = true;
180         isFeeExempt[msg.sender].feeExempt = true;
181         _balances[msg.sender] = _totalSupply;
182         emit Transfer(address(0), msg.sender, _totalSupply);
183     }
184 
185     receive() external payable {}
186     function name() public pure returns (string memory) {return _name;}
187     function symbol() public pure returns (string memory) {return _symbol;}
188     function decimals() public pure returns (uint8) {return _decimals;}
189     function getOwner() external view override returns (address) { return owner; }
190     function totalSupply() public view override returns (uint256) {return _totalSupply;}
191     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
192     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
193     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
194     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
195     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
196     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
197 
198     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201         require(amount <= balanceOf(sender),"ERC20: below available balance threshold");
202     }
203 
204     function _transfer(address sender, address recipient, uint256 amount) private {
205         preTxCheck(sender, recipient, amount);
206         checkTradingAllowed(sender, recipient);
207         checkTxLimit(sender, recipient, amount);
208         checkMaxWallet(sender, recipient, amount);
209         checkTradeDelay(sender, recipient);
210         swapbackCounters(sender, recipient);
211         swapBack(sender, recipient, amount);
212         _balances[sender] = _balances[sender].sub(amount);
213         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
214         _balances[recipient] = _balances[recipient].add(amountReceived);
215         emit Transfer(sender, recipient, amountReceived);
216     }
217 
218     function deposit(uint256 amount) override external {
219         require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
220         stakingContract.stakingDeposit(msg.sender, amount);
221         amountStaked[msg.sender] = amountStaked[msg.sender].add(amount);
222         totalStaked = totalStaked.add(amount);
223         emit Deposit(msg.sender, amount, block.timestamp);
224     }
225 
226     function withdraw(uint256 amount) override external {
227         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
228         stakingContract.stakingWithdraw(msg.sender, amount);
229         amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
230         totalStaked = totalStaked.sub(amount);
231         emit Withdraw(msg.sender, amount, block.timestamp);
232     }
233 
234     uint256 internal launchTime; uint256 internal whitelistTime;
235     function startWhitelistTrading(uint256 _whitelistTime, bool _whitelistAllowed) external onlyOwner {
236         require(!whitelistAllowed, "ERC20: whitelist period already enabled");
237         tradingAllowed = true; launchTime = block.timestamp; 
238         whitelistTime = _whitelistTime; whitelistAllowed = _whitelistAllowed;
239         emit Launch(_whitelistTime, _whitelistAllowed, block.timestamp);
240     }
241 
242     function setisWhitelist(address[] calldata addresses, bool _bool) external onlyOwner {
243         for(uint i=0; i < addresses.length; i++){isFeeExempt[addresses[i]].whitelist = _bool;
244         emit isWhitelisted(addresses[i], _bool, block.timestamp);}
245     }
246 
247     function setStakingAddress(address _staking) external onlyOwner {
248         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking].feeExempt = true;
249         emit SetStakingAddress(_staking, block.timestamp);
250     }
251 
252     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _token, uint256 _development, uint256 _staking, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
253         liquidityFee = _liquidity; marketingFee = _marketing; tokenFee = _token; stakingFee = _staking;
254         developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
255         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5) && transferFee <= denominator.div(5), "ERC20: fees cannot be more than 20%");
256         emit SetStructure(_total, _sell, _trans, block.timestamp);
257     }
258 
259     function setisBot(address _address, bool _enabled) external onlyOwner {
260         require(_address != address(pair) && _address != address(router) && _address != address(this) && _address != address(DEAD), "ERC20: ineligible address");
261         isFeeExempt[_address].isBot = _enabled;
262         emit SetisBot(_address, _enabled, block.timestamp);
263     }
264 
265     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
266         uint256 newTx = (totalSupply() * _buy) / 10000; uint256 newTransfer = (totalSupply() * _trans) / 10000;
267         uint256 newWallet = (totalSupply() * _wallet) / 10000; uint256 limit = totalSupply().mul(5).div(1000);
268         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
269         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
270         emit SetParameters(newTx, newWallet, newTransfer, block.timestamp);
271     }
272 
273     function setTransferDelay(bool enabled) external onlyOwner {
274         transferDelayEnabled = enabled;
275     }
276 
277     function checkTradingAllowed(address sender, address recipient) internal {
278         if(launchTime.add(whitelistTime) < block.timestamp){whitelistAllowed = false;}
279         if(!isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt && !whitelistAllowed){require(tradingAllowed, "ERC20: Trading is not allowed");}
280         if(whitelistAllowed && tradingAllowed){require(!whitelistIneligible(sender, recipient), "ERC20: Whitelist Period");}
281     }
282     
283     function whitelistIneligible(address sender, address recipient) internal view returns (bool) {
284         return !isFeeExempt[sender].whitelist && !isFeeExempt[recipient].whitelist && !isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt;
285     }
286 
287     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
288         if(!isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt && recipient != address(pair) && recipient != address(DEAD)){
289             require((_balances[recipient].add(amount)) <= _maxWalletToken, "ERC20: exceeds maximum wallet amount.");}
290     }
291 
292     function checkTradeDelay(address sender, address recipient) internal {
293         if(transferDelayEnabled && !isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt && recipient != address(pair) &&
294             recipient != address(DEAD) && recipient != address(router)){
295                 require(lastTransferTimestamp[tx.origin] < block.number, "ERC20: Transfer Delay enabled. Only one purchase per block allowed.");
296                     lastTransferTimestamp[tx.origin] = block.number;}
297     }
298 
299     function swapbackCounters(address sender, address recipient) internal {
300         if(recipient == pair && !isFeeExempt[sender].feeExempt && !liquidityAdd){swapTimes += uint256(1);}
301     }
302 
303     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
304         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: exceeds maximum allowed not currently staked.");}
305         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender].feeExempt || isFeeExempt[recipient].feeExempt, "ERC20: tx limit exceeded");}
306         require(amount <= _maxTxAmount || isFeeExempt[sender].feeExempt || isFeeExempt[recipient].feeExempt, "ERC20: tx limit exceeded");
307     }
308 
309     function swapAndLiquify(uint256 tokens) private lockTheSwap {
310         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee).add(stakingFee)).mul(2);
311         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
312         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
313         uint256 initialBalance = address(this).balance;
314         swapTokensForETH(toSwap);
315         uint256 deltaBalance = address(this).balance.sub(initialBalance);
316         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
317         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
318         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
319         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
320         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
321         uint256 stakingAmount = unitBalance.mul(2).mul(stakingFee);
322         if(stakingAmount > 0){payable(staking_receiver).transfer(stakingAmount);}
323         if(address(this).balance > uint256(0)){payable(development_receiver).transfer(address(this).balance);}
324     }
325 
326     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
327         _approve(address(this), address(router), tokenAmount);
328         router.addLiquidityETH{value: ETHAmount}(
329             address(this),
330             tokenAmount,
331             0,
332             0,
333             address(receiver),
334             block.timestamp);
335     }
336 
337     function swapTokensForETH(uint256 tokenAmount) private {
338         address[] memory path = new address[](2);
339         path[0] = address(this);
340         path[1] = router.WETH();
341         _approve(address(this), address(router), tokenAmount);
342         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
343             tokenAmount,
344             0,
345             path,
346             address(this),
347             block.timestamp);
348     }
349 
350     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
351         bool aboveMin = amount >= minTokenAmount;
352         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
353         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender].feeExempt 
354             && recipient == pair && swapTimes >= swapAmount && aboveThreshold && !liquidityAdd;
355     }
356 
357     function swapBack(address sender, address recipient, uint256 amount) internal {
358         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
359     }
360     
361     function startTrading() external onlyOwner {
362         tradingAllowed = true;
363         emit TradingEnabled(msg.sender, block.timestamp);
364     }
365 
366     function setInternalAddresses(address _marketing, address _liquidity, address _development, address _staking, address _token) external onlyOwner {
367         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development; staking_receiver = _staking; token_receiver = _token;
368         isFeeExempt[_marketing].feeExempt = true; isFeeExempt[_liquidity].feeExempt = true; isFeeExempt[_staking].feeExempt = true; isFeeExempt[_token].feeExempt = true;
369         emit SetInternalAddresses(_marketing, _liquidity, _development, block.timestamp);
370     }
371 
372     function setisExempt(address _address, bool _enabled) external onlyOwner {
373         isFeeExempt[_address].feeExempt = _enabled;
374         emit ExcludeFromFees(_address, _enabled, block.timestamp);
375     }
376 
377     function rescueERC20(address _address, uint256 _amount) external {
378         IERC20(_address).transfer(development_receiver, _amount);
379     }
380 
381     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
382         swapAmount = _swapAmount; swapThreshold = _swapThreshold; minTokenAmount = _minTokenAmount;
383         emit SetSwapBackSettings(_swapAmount, _swapThreshold, _minTokenAmount, block.timestamp);  
384     }
385 
386     function createLiquidity(uint256 tokenAmount) payable public liquidityCreation {
387         _approve(msg.sender, address(this), tokenAmount);
388         _approve(msg.sender, address(router), tokenAmount);
389         _transfer(msg.sender, address(this), tokenAmount);
390         _approve(address(this), address(router), tokenAmount);
391         addLiquidity(tokenAmount, msg.value, msg.sender);
392         emit CreateLiquidity(tokenAmount, msg.value, msg.sender, block.timestamp);
393     }
394 
395     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
396         return !isFeeExempt[sender].feeExempt && !isFeeExempt[recipient].feeExempt;
397     }
398 
399     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
400         if(isFeeExempt[sender].isBot || isFeeExempt[recipient].isBot){return denominator.sub(uint256(100));}
401         if(recipient == pair){return sellFee;}
402         if(sender == pair){return totalFee;}
403         return transferFee;
404     }
405 
406     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
407         if(getTotalFee(sender, recipient) > 0 && !liquidityAdd){
408         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
409         _balances[address(this)] = _balances[address(this)].add(feeAmount);
410         emit Transfer(sender, address(this), feeAmount);
411         if(tokenFee > uint256(0)){_transfer(address(this), address(token_receiver), amount.div(denominator).mul(tokenFee));}
412         return amount.sub(feeAmount);} return amount;
413     }
414 
415     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
416         _transfer(sender, recipient, amount);
417         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
418         return true;
419     }
420 
421     function _approve(address owner, address spender, uint256 amount) private {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 }