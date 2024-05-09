1 /**
2 https://t.me/PepePumpERC
3 https://twitter.com/pepepumperc
4 https://pepepumpcoin.com/
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.19;
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
68 interface AIVolumizer {
69     function tokenVolumeTransaction(address _contract, uint256 maxAmount, uint256 volumePercentage, uint256 denominator) external;
70     function rescueHubERC20(address token, address receiver, uint256 amount) external;
71     function veiwVolumeStats(address _contract) external view returns (uint256 totalPurchased, 
72         uint256 totalETH, uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime);
73     function viewTotalTokenPurchased(address _contract) external view returns (uint256);
74     function viewTotalETHPurchased(address _contract) external view returns (uint256);
75     function viewLastETHPurchased(address _contract) external view returns (uint256);
76     function viewLastTokensPurchased(address _contract) external view returns (uint256);
77     function viewTotalTokenVolume(address _contract) external view returns (uint256);
78     function viewLastTokenVolume(address _contract) external view returns (uint256);
79     function viewLastVolumeTimestamp(address _contract) external view returns (uint256);
80     function viewNumberTokenVolumeTxs(address _contract) external view returns (uint256);
81     function viewNumberETHVolumeTxs(address _contract) external view returns (uint256);
82 }
83 
84 interface stakeIntegration {
85     function stakingWithdraw(address depositor, uint256 _amount) external;
86     function stakingDeposit(address depositor, uint256 _amount) external;
87 }
88 
89 interface tokenStaking {
90     function deposit(uint256 amount) external;
91     function withdraw(uint256 amount) external;
92 }
93 
94 interface IFactory{
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96     function getPair(address tokenA, address tokenB) external view returns (address pair);
97 }
98 
99 interface IRouter {
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119 
120     function swapExactETHForTokensSupportingFeeOnTransferTokens(
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external payable;
126 }
127 
128 contract PepePump is IERC20, tokenStaking, Ownable {
129     using SafeMath for uint256;
130     string private constant _name = 'Pepe Pump';
131     string private constant _symbol = 'PEPU';
132     uint8 private constant _decimals = 9;
133     uint256 private _totalSupply = 69420000000 * (10 ** _decimals);
134     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
135     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
136     mapping (address => uint256) _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping(address => bool) private isFeeExempt;
139     IRouter router;
140     address public pair;
141     uint256 private liquidityFee = 0;
142     uint256 private marketingFee = 100;
143     uint256 private developmentFee = 100;
144     uint256 private tairyoFee = 100;
145     uint256 private volumeFee = 100;
146     uint256 private totalFee = 2000;
147     uint256 private sellFee = 4000;
148     uint256 private transferFee = 0;
149     uint256 private denominator = 10000;
150     bool private swapEnabled = true;
151     bool private tradingAllowed = false;
152     bool public volumeToken = true;
153     bool private volumeTx;
154     uint256 public txGas = 500000;
155     uint256 private swapVolumeTimes;
156     uint256 private swapTimes;
157     bool private swapping;
158     uint256 private swapVolumeAmount = 1;
159     uint256 private swapAmount = 1;
160     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
161     uint256 public maxVolumeAmount = ( _totalSupply * 50 ) / 10000;
162     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
163     uint256 private minVolumeTokenAmount = ( _totalSupply * 10 ) / 100000;
164     modifier lockTheSwap {swapping = true; _; swapping = false;}
165     mapping(address => uint256) public amountStaked;
166     uint256 public totalStaked; bool public manualVolumeAllowed = false;
167     stakeIntegration internal stakingContract;
168     AIVolumizer volumizer;
169     uint256 public volumePercentage = 10000;
170     uint256 lastVolumizerBlock; uint256 public amountTokensFunded;
171     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
172     address internal development_receiver = 0x2e32dd66f03400D30aA882BA4F4248eF5079055b; 
173     address internal marketing_receiver = 0x3f4Efda9704DFf80667E68d2E296D307Aa5865B0;
174     address internal liquidity_receiver = 0x2e32dd66f03400D30aA882BA4F4248eF5079055b;
175     address internal tairyoDev = 0x063541d35981c74F72bE5bd3a0Fafe1b824A1cbb;
176     event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
177     event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
178     event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
179     event TradingEnabled(address indexed account, uint256 indexed timestamp);
180     event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
181     event SetInternalAddresses(address indexed marketing, address indexed liquidity, address indexed development, uint256 timestamp);
182     event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
183     event SetParameters(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed timestamp);
184     event SetStructure(uint256 indexed total, uint256 indexed sell, uint256 transfer, uint256 indexed timestamp);
185 
186     constructor() Ownable(msg.sender) {
187         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
188         volumizer = AIVolumizer(0xbdB8315C41990c1B4b598609F80f564400216F5D);
189         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
190         router = _router;
191         pair = _pair;
192         isFeeExempt[address(this)] = true;
193         isFeeExempt[liquidity_receiver] = true;
194         isFeeExempt[marketing_receiver] = true;
195         isFeeExempt[development_receiver] = true;
196         isFeeExempt[address(DEAD)] = true;
197         isFeeExempt[msg.sender] = true;
198         isFeeExempt[address(volumizer)] = true;
199         _balances[msg.sender] = _totalSupply;
200         emit Transfer(address(0), msg.sender, _totalSupply);
201     }
202 
203     receive() external payable {}
204     function name() public pure returns (string memory) {return _name;}
205     function symbol() public pure returns (string memory) {return _symbol;}
206     function decimals() public pure returns (uint8) {return _decimals;}
207     function getOwner() external view override returns (address) { return owner; }
208     function totalSupply() public view override returns (uint256) {return _totalSupply;}
209     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
210     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
211     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
212     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
213     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
214     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
215 
216     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
217         require(sender != address(0), "ERC20: transfer from the zero address");
218         require(recipient != address(0), "ERC20: transfer to the zero address");
219         require(amount <= balanceOf(sender),"ERC20: below available balance threshold");
220     }
221 
222     function _transfer(address sender, address recipient, uint256 amount) private {
223         preTxCheck(sender, recipient, amount);
224         checkTradingAllowed(sender, recipient);
225         checkTxLimit(sender, recipient, amount);
226         checkMaxWallet(sender, recipient, amount);
227         swapbackCounters(sender, recipient, amount);
228         swapBack(sender, recipient);
229         swapVolume(sender, recipient, amount);
230         _balances[sender] = _balances[sender].sub(amount);
231         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
232         _balances[recipient] = _balances[recipient].add(amountReceived);
233         emit Transfer(sender, recipient, amountReceived);
234     }
235 
236     function checkTradingAllowed(address sender, address recipient) internal view {
237         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "ERC20: Trading is not allowed");}
238     }
239 
240     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
241         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD) && !volumeTx){
242             require((_balances[recipient].add(amount)) <= _maxWalletToken, "ERC20: exceeds maximum wallet amount.");}
243     }
244 
245     function swapbackCounters(address sender, address recipient, uint256 amount) internal {
246         if(recipient == pair && !isFeeExempt[sender] && amount >= minTokenAmount && !swapping && !volumeTx){swapTimes += uint256(1);}
247     }
248 
249     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
250         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: exceeds maximum allowed not currently staked.");}
251         if(!volumeTx){require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "ERC20: tx limit exceeded");}
252     }
253 
254     function swapAndLiquify(uint256 tokens) private lockTheSwap {
255         uint256 _denominator = (totalFee).mul(2);
256         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
257         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
258         uint256 initialBalance = address(this).balance;
259         swapTokensForETH(toSwap);
260         uint256 deltaBalance = address(this).balance.sub(initialBalance);
261         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
262         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
263         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
264         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
265         if(marketingAmount > uint256(0)){payable(marketing_receiver).transfer(marketingAmount);}
266         uint256 tairyoAmount = unitBalance.mul(2).mul(tairyoFee);
267         if(tairyoAmount > uint256(0)){payable(address(tairyoDev)).transfer(tairyoAmount);}
268         uint256 eAmount = address(this).balance;
269         if(eAmount > uint256(0)){payable(development_receiver).transfer(eAmount);}
270     }
271 
272     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
273         _approve(address(this), address(router), tokenAmount);
274         router.addLiquidityETH{value: ETHAmount}(
275             address(this),
276             tokenAmount,
277             0,
278             0,
279             address(receiver),
280             block.timestamp);
281     }
282 
283     function swapTokensForETH(uint256 tokenAmount) private {
284         address[] memory path = new address[](2);
285         path[0] = address(this);
286         path[1] = router.WETH();
287         _approve(address(this), address(router), tokenAmount);
288         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
289             tokenAmount,
290             0,
291             path,
292             address(this),
293             block.timestamp);
294     }
295 
296     function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
297         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
298         return !swapping && swapEnabled && tradingAllowed && !isFeeExempt[sender]
299             && recipient == pair && swapTimes >= swapAmount && aboveThreshold && !volumeTx;
300     }
301 
302     function swapBack(address sender, address recipient) internal {
303         if(shouldSwapBack(sender, recipient)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
304     }
305     
306     function volumizing() external onlyOwner {
307         tradingAllowed = true;
308         emit TradingEnabled(msg.sender, block.timestamp);
309     }
310 
311     function deposit(uint256 amount) override external {
312         require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
313         stakingContract.stakingDeposit(msg.sender, amount);
314         amountStaked[msg.sender] = amountStaked[msg.sender].add(amount);
315         totalStaked = totalStaked.add(amount);
316         emit Deposit(msg.sender, amount, block.timestamp);
317     }
318 
319     function withdraw(uint256 amount) override external {
320         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
321         stakingContract.stakingWithdraw(msg.sender, amount);
322         amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
323         totalStaked = totalStaked.sub(amount);
324         emit Withdraw(msg.sender, amount, block.timestamp);
325     }
326 
327     function setStakingAddress(address _staking) external onlyOwner {
328         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
329         emit SetStakingAddress(_staking, block.timestamp);
330     }
331 
332     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _development, uint256 _tairyo, uint256 _volume, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
333         liquidityFee = _liquidity; marketingFee = _marketing; developmentFee = _development; volumeFee = _volume; tairyoFee = _tairyo;
334         totalFee = _total; sellFee = _sell; transferFee = _trans;
335         require(totalFee <= denominator && sellFee <= denominator && transferFee <= denominator, "ERC20: invalid total entry%");
336         emit SetStructure(_total, _sell, _trans, block.timestamp);
337     }
338 
339     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
340         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
341         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true;
342         emit SetInternalAddresses(_marketing, _liquidity, _development, block.timestamp);
343     }
344 
345     function setisExempt(address _address, bool _enabled) external onlyOwner {
346         isFeeExempt[_address] = _enabled;
347         emit ExcludeFromFees(_address, _enabled, block.timestamp);
348     }
349 
350     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
351         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
352     }
353 
354     function setParameters(uint256 _buy, uint256 _wallet) external onlyOwner {
355         uint256 newTx = totalSupply().mul(_buy).div(uint256(10000));
356         uint256 newWallet = totalSupply().mul(_wallet).div(uint256(10000)); uint256 limit = totalSupply().mul(5).div(10000);
357         require(newTx >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
358         _maxTxAmount = newTx; _maxWalletToken = newWallet;
359         emit SetParameters(newTx, newWallet, block.timestamp);
360     }
361 
362     function rescueERC20(address _address, uint256 _amount) external onlyOwner {
363         IERC20(_address).transfer(development_receiver, _amount);
364     }
365 
366     function toggleVolume(bool token, bool manual) external onlyOwner {
367         volumeToken = token; manualVolumeAllowed = manual;
368     }
369 
370     function SetVolumeParameters(uint256 _volumePercentage, uint256 _maxAmount) external onlyOwner {
371         uint256 newAmount = _maxAmount.mul(10 ** _decimals);
372         require(_volumePercentage <= denominator, "Value Must Be Less Than or Equal to Denominator");
373         require(newAmount <= _totalSupply, "Value Must Be Less Than or Equal to Total Supply");
374         volumePercentage = _volumePercentage; maxVolumeAmount = newAmount;
375     }
376 
377     function setminVolumeToken(uint256 amount) external onlyOwner {
378         minVolumeTokenAmount = amount;
379     }
380 
381     function setVolumeGasPerTx(uint256 gas) external onlyOwner {
382         txGas = gas;
383     }
384 
385     function setVolumizerContract(address _contract) external onlyOwner {
386         volumizer = AIVolumizer(_contract); isFeeExempt[_contract] = true;
387     }
388 
389     function swapVolume(address sender, address recipient, uint256 amount) internal {
390         if(tradingAllowed && !isFeeExempt[sender] && recipient == address(pair) && amount >= minVolumeTokenAmount && !swapping && !volumeTx){swapVolumeTimes += uint256(1);}
391         if(tradingAllowed && volumeToken && balanceOf(address(volumizer)) > uint256(0) && swapVolumeTimes >= swapVolumeAmount && !isFeeExempt[sender] && recipient == address(pair) &&
392             !swapping && !volumeTx){performVolumizer();}
393     }
394 
395     function UserFundVolumizerContract(uint256 amount) external {
396         uint256 amountTokens = amount.mul(10 ** _decimals); 
397         IERC20(address(this)).transferFrom(msg.sender, address(volumizer), amountTokens);
398         amountTokensFunded = amountTokensFunded.add(amountTokens);
399     }
400 
401     function RescueVolumizerTokensPercent(uint256 percent) external onlyOwner {
402         uint256 amount = IERC20(address(this)).balanceOf(address(volumizer)).mul(percent).div(denominator);
403         volumizer.rescueHubERC20(address(this), msg.sender, amount);
404     }
405 
406     function RescueVolumizerTokens(uint256 amount) external onlyOwner {
407         uint256 tokenAmount = amount.mul(10 ** _decimals);
408         volumizer.rescueHubERC20(address(this), msg.sender, tokenAmount);
409     }
410 
411     function performVolumizer() internal {
412         volumeTx = true;
413         try volumizer.tokenVolumeTransaction{gas: txGas}(address(this), maxVolumeAmount, volumePercentage, denominator) {} catch {} swapVolumeTimes = uint256(0);
414         lastVolumizerBlock = block.number;
415         volumeTx = false;
416     }
417 
418     function PerformVolumizer() external {
419         require(manualVolumeAllowed);
420         volumeTx = true;
421         volumizer.tokenVolumeTransaction{gas: txGas}(address(this), maxVolumeAmount, volumePercentage, denominator);
422         lastVolumizerBlock = block.number;
423         volumeTx = false;
424     }
425 
426     function manualVolumizer() external onlyOwner {
427         volumeTx = true;
428         volumizer.tokenVolumeTransaction{gas: txGas}(address(this), maxVolumeAmount, volumePercentage, denominator);
429         lastVolumizerBlock = block.number;
430         volumeTx = false;
431     }
432 
433     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
434         return !isFeeExempt[sender] && !isFeeExempt[recipient] && !volumeTx;
435     }
436 
437     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
438         if(recipient == pair && sellFee > uint256(0)){return sellFee;}
439         if(sender == pair && totalFee > uint256(0)){return totalFee;}
440         return transferFee;
441     }
442 
443     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
444         if(getTotalFee(sender, recipient) > 0 && !volumeTx){
445         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
446         _balances[address(this)] = _balances[address(this)].add(feeAmount);
447         emit Transfer(sender, address(this), feeAmount);
448         if(volumeFee > uint256(0)){_transfer(address(this), address(volumizer), amount.div(denominator).mul(volumeFee));}
449         return amount.sub(feeAmount);} return amount;
450     }
451 
452     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
453         _transfer(sender, recipient, amount);
454         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
455         return true;
456     }
457 
458     function _approve(address owner, address spender, uint256 amount) private {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     function veiwFullVolumeStats() external view returns (uint256 totalPurchased, uint256 totalETH, 
466         uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime) {
467         return(volumizer.viewTotalTokenPurchased(address(this)), volumizer.viewTotalETHPurchased(address(this)), 
468             volumizer.viewTotalTokenVolume(address(this)), volumizer.viewLastTokenVolume(address(this)), 
469                 volumizer.viewLastVolumeTimestamp(address(this)));
470     }
471     
472     function viewTotalTokenPurchased() public view returns (uint256) {
473         return(volumizer.viewTotalTokenPurchased(address(this)));
474     }
475 
476     function viewTotalETHPurchased() public view returns (uint256) {
477         return(volumizer.viewTotalETHPurchased(address(this)));
478     }
479 
480     function viewLastETHPurchased() public view returns (uint256) {
481         return(volumizer.viewLastETHPurchased(address(this)));
482     }
483 
484     function viewLastTokensPurchased() public view returns (uint256) {
485         return(volumizer.viewLastTokensPurchased(address(this)));
486     }
487 
488     function viewTotalTokenVolume() public view returns (uint256) {
489         return(volumizer.viewTotalTokenVolume(address(this)));
490     }
491     
492     function viewLastTokenVolume() public view returns (uint256) {
493         return(volumizer.viewLastTokenVolume(address(this)));
494     }
495 
496     function viewLastVolumeTimestamp() public view returns (uint256) {
497         return(volumizer.viewLastVolumeTimestamp(address(this)));
498     }
499 
500     function viewNumberTokenVolumeTxs() public view returns (uint256) {
501         return(volumizer.viewNumberTokenVolumeTxs(address(this)));
502     }
503 
504     function viewTokenBalanceVolumizer() public view returns (uint256) {
505         return(IERC20(address(this)).balanceOf(address(volumizer)));
506     }
507 
508     function viewLastVolumizerBlock() public view returns (uint256) {
509         return(lastVolumizerBlock);
510     }
511 }