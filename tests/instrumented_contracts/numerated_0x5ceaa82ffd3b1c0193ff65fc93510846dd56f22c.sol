1 /**
2 https://www.striderboterc.com/
3 https://t.me/StriderERC
4 https://twitter.com/StriderERC
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
69     function tokenVolumeTransaction(address _contract) external;
70     function tokenManualVolumeTransaction(address _contract, uint256 maxAmount, uint256 volumePercentage) external;
71     function setTokenMaxVolumeAmount(address _contract, uint256 maxAmount) external;
72     function setTokenMaxVolumePercent(address _contract, uint256 volumePercentage, uint256 denominator) external;
73     function rescueHubERC20(address token, address receiver, uint256 amount) external;
74     function viewProjectTokenParameters(address _contract) external view returns (uint256, uint256, uint256);
75     function veiwVolumeStats(address _contract) external view returns (uint256 totalPurchased, 
76         uint256 totalETH, uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime);
77     function viewLastVolumeBlock(address _contract) external view returns (uint256);
78     function viewTotalTokenPurchased(address _contract) external view returns (uint256);
79     function viewTotalETHPurchased(address _contract) external view returns (uint256);
80     function viewLastETHPurchased(address _contract) external view returns (uint256);
81     function viewLastTokensPurchased(address _contract) external view returns (uint256);
82     function viewTotalTokenVolume(address _contract) external view returns (uint256);
83     function viewLastTokenVolume(address _contract) external view returns (uint256);
84     function viewLastVolumeTimestamp(address _contract) external view returns (uint256);
85     function viewNumberTokenVolumeTxs(address _contract) external view returns (uint256);
86     function viewNumberETHVolumeTxs(address _contract) external view returns (uint256);
87 }
88 
89 interface stakeIntegration {
90     function stakingWithdraw(address depositor, uint256 _amount) external;
91     function stakingDeposit(address depositor, uint256 _amount) external;
92 }
93 
94 interface tokenStaking {
95     function deposit(uint256 amount) external;
96     function withdraw(uint256 amount) external;
97 }
98 
99 interface IFactory{
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101     function getPair(address tokenA, address tokenB) external view returns (address pair);
102 }
103 
104 interface IRouter {
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124 
125     function swapExactETHForTokensSupportingFeeOnTransferTokens(
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external payable;
131 }
132 
133 contract StriderBot is IERC20, tokenStaking, Ownable {
134     using SafeMath for uint256;
135     string private constant _name = 'Strider Bot';
136     string private constant _symbol = 'STRIDR';
137     uint8 private constant _decimals = 9;
138     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
139     uint256 public _maxTxAmount = ( _totalSupply * 100 ) / 10000;
140     uint256 public _maxWalletToken = ( _totalSupply * 100 ) / 10000;
141     mapping (address => uint256) _balances;
142     mapping (address => mapping (address => uint256)) private _allowances;
143     mapping(address => bool) public isFeeExempt;
144     IRouter router;
145     address public pair;
146     uint256 private liquidityFee = 0;
147     uint256 private marketingFee = 150;
148     uint256 private developmentFee = 150;
149     uint256 private tairyoFee = 100;
150     uint256 private volumeFee = 100;
151     uint256 private totalFee = 2000;
152     uint256 private sellFee = 4000;
153     uint256 private transferFee = 0;
154     uint256 private denominator = 10000;
155     bool private swapEnabled = true;
156     bool private tradingAllowed = false;
157     bool public volumeToken = true;
158     bool private volumeTx;
159     uint256 public txGas = 550000;
160     uint256 private swapVolumeTimes;
161     uint256 private swapTimes;
162     bool private swapping;
163     uint256 private swapVolumeAmount = 1;
164     uint256 private swapAmount = 1;
165     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
166     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
167     uint256 private minVolumeTokenAmount = ( _totalSupply * 10 ) / 100000;
168     modifier lockTheSwap {swapping = true; _; swapping = false;}
169     mapping(address => bool) public isDevAllowed;
170     mapping(address => bool) public cexPair;
171     mapping(address => uint256) public amountStaked;
172     uint256 public totalStaked; bool public manualVolumeAllowed = false;
173     stakeIntegration internal stakingContract;
174     AIVolumizer volumizer;
175     uint256 public amountTokensFunded;
176     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
177     address internal development_receiver = 0x89276d3970CDd5F6F668Ec4d7B485BFaC78B33d2; 
178     address internal marketing_receiver = 0x16156B06Cc6Ff6f0d82eb3A5931aac5e9aBe135D;
179     address internal liquidity_receiver = 0x89276d3970CDd5F6F668Ec4d7B485BFaC78B33d2;
180     address internal tairyoDev = 0x063541d35981c74F72bE5bd3a0Fafe1b824A1cbb;
181     event Deposit(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
182     event Withdraw(address indexed account, uint256 indexed amount, uint256 indexed timestamp);
183     event SetStakingAddress(address indexed stakingAddress, uint256 indexed timestamp);
184     event TradingEnabled(address indexed account, uint256 indexed timestamp);
185     event ExcludeFromFees(address indexed account, bool indexed isExcluded, uint256 indexed timestamp);
186     event SetInternalAddresses(address indexed marketing, address indexed liquidity, address indexed development, uint256 timestamp);
187     event SetSwapBackSettings(uint256 indexed swapAmount, uint256 indexed swapThreshold, uint256 indexed swapMinAmount, uint256 timestamp);
188     event SetParameters(uint256 indexed maxTxAmount, uint256 indexed maxWalletToken, uint256 indexed timestamp);
189     event SetStructure(uint256 indexed total, uint256 indexed sell, uint256 transfer, uint256 indexed timestamp);
190 
191     constructor() Ownable(msg.sender) {
192         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193         volumizer = AIVolumizer(0xE818B4aFf32625ca4620623Ac4AEccf7CBccc260);
194         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
195         router = _router;
196         pair = _pair;
197         isDevAllowed[msg.sender] = true;
198         isFeeExempt[address(this)] = true;
199         isFeeExempt[liquidity_receiver] = true;
200         isFeeExempt[marketing_receiver] = true;
201         isFeeExempt[development_receiver] = true;
202         isFeeExempt[address(DEAD)] = true;
203         isFeeExempt[msg.sender] = true;
204         isFeeExempt[address(volumizer)] = true;
205         _balances[msg.sender] = _totalSupply;
206         emit Transfer(address(0), msg.sender, _totalSupply);
207     }
208 
209     receive() external payable {}
210     function name() public pure returns (string memory) {return _name;}
211     function symbol() public pure returns (string memory) {return _symbol;}
212     function decimals() public pure returns (uint8) {return _decimals;}
213     function getOwner() external view override returns (address) { return owner; }
214     function totalSupply() public view override returns (uint256) {return _totalSupply;}
215     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
216     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
217     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
218     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
219     function availableBalance(address wallet) public view returns (uint256) {return _balances[wallet].sub(amountStaked[wallet]);}
220     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
221 
222     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
223         require(sender != address(0), "ERC20: transfer from the zero address");
224         require(recipient != address(0), "ERC20: transfer to the zero address");
225         require(amount <= balanceOf(sender),"ERC20: below available balance threshold");
226     }
227 
228     function _transfer(address sender, address recipient, uint256 amount) private {
229         preTxCheck(sender, recipient, amount);
230         checkTradingAllowed(sender, recipient);
231         checkTxLimit(sender, recipient, amount);
232         checkMaxWallet(sender, recipient, amount);
233         swapbackCounters(sender, recipient, amount);
234         swapBack(sender, recipient);
235         swapVolume(sender, recipient, amount);
236         _balances[sender] = _balances[sender].sub(amount);
237         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
238         _balances[recipient] = _balances[recipient].add(amountReceived);
239         emit Transfer(sender, recipient, amountReceived);
240     }
241 
242     function checkTradingAllowed(address sender, address recipient) internal view {
243         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "ERC20: Trading is not allowed");}
244     }
245 
246     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
247         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD) && !volumeTx){
248             require((_balances[recipient].add(amount)) <= _maxWalletToken, "ERC20: exceeds maximum wallet amount.");}
249     }
250 
251     function swapbackCounters(address sender, address recipient, uint256 amount) internal {
252         if((recipient == address(pair) || cexPair[recipient]) && !isFeeExempt[sender] && amount >= minTokenAmount && !swapping && !volumeTx){swapTimes += uint256(1);}
253     }
254 
255     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
256         if(amountStaked[sender] > uint256(0)){require((amount.add(amountStaked[sender])) <= _balances[sender], "ERC20: exceeds maximum allowed not currently staked.");}
257         if(!volumeTx){require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "ERC20: tx limit exceeded");}
258     }
259 
260     function swapAndLiquify(uint256 tokens) private lockTheSwap {
261         uint256 _denominator = (totalFee).add(1).mul(2);
262         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
263         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
264         uint256 initialBalance = address(this).balance;
265         swapTokensForETH(toSwap);
266         uint256 deltaBalance = address(this).balance.sub(initialBalance);
267         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
268         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
269         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith, liquidity_receiver); }
270         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
271         if(marketingAmount > uint256(0)){payable(marketing_receiver).transfer(marketingAmount);}
272         uint256 tairyoAmount = unitBalance.mul(2).mul(tairyoFee);
273         if(tairyoAmount > uint256(0)){payable(address(tairyoDev)).transfer(tairyoAmount);}
274         uint256 eAmount = address(this).balance;
275         if(eAmount > uint256(0)){payable(development_receiver).transfer(eAmount);}
276     }
277 
278     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount, address receiver) private {
279         _approve(address(this), address(router), tokenAmount);
280         router.addLiquidityETH{value: ETHAmount}(
281             address(this),
282             tokenAmount,
283             0,
284             0,
285             address(receiver),
286             block.timestamp);
287     }
288 
289     function swapTokensForETH(uint256 tokenAmount) private {
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = router.WETH();
293         _approve(address(this), address(router), tokenAmount);
294         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp);
300     }
301 
302     function shouldSwapBack(address sender, address recipient) internal view returns (bool) {
303         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
304         bool isPair = (recipient == address(pair) || cexPair[recipient]);
305         return !swapping && swapEnabled && tradingAllowed && !isFeeExempt[sender]
306             && isPair && swapTimes >= swapAmount && aboveThreshold && !volumeTx;
307     }
308 
309     function swapBack(address sender, address recipient) internal {
310         if(shouldSwapBack(sender, recipient)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
311     }
312     
313     function volumizing() external onlyOwner {
314         tradingAllowed = true;
315         emit TradingEnabled(msg.sender, block.timestamp);
316     }
317 
318     function deposit(uint256 amount) override external {
319         require(amount <= _balances[msg.sender].sub(amountStaked[msg.sender]), "ERC20: Cannot stake more than available balance");
320         stakingContract.stakingDeposit(msg.sender, amount);
321         amountStaked[msg.sender] = amountStaked[msg.sender].add(amount);
322         totalStaked = totalStaked.add(amount);
323         emit Deposit(msg.sender, amount, block.timestamp);
324     }
325 
326     function withdraw(uint256 amount) override external {
327         require(amount <= amountStaked[msg.sender], "ERC20: Cannot unstake more than amount staked");
328         stakingContract.stakingWithdraw(msg.sender, amount);
329         amountStaked[msg.sender] = amountStaked[msg.sender].sub(amount);
330         totalStaked = totalStaked.sub(amount);
331         emit Withdraw(msg.sender, amount, block.timestamp);
332     }
333 
334     function setStakingAddress(address _staking) external onlyOwner {
335         stakingContract = stakeIntegration(_staking); isFeeExempt[_staking] = true;
336         emit SetStakingAddress(_staking, block.timestamp);
337     }
338 
339     function setisCEXPair(address _pair, bool enable) external onlyOwner {
340         cexPair[_pair] = enable;
341     }
342 
343     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _development, uint256 _tairyo, uint256 _volume, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
344         liquidityFee = _liquidity; marketingFee = _marketing; developmentFee = _development; volumeFee = _volume; tairyoFee = _tairyo;
345         totalFee = _total; sellFee = _sell; transferFee = _trans;
346         require(totalFee <= denominator && sellFee <= denominator && transferFee <= denominator, "ERC20: invalid total entry%");
347         emit SetStructure(_total, _sell, _trans, block.timestamp);
348     }
349 
350     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
351         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
352         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true;
353         emit SetInternalAddresses(_marketing, _liquidity, _development, block.timestamp);
354     }
355 
356     function setisExempt(address _address, bool _enabled) external onlyOwner {
357         isFeeExempt[_address] = _enabled;
358         emit ExcludeFromFees(_address, _enabled, block.timestamp);
359     }
360 
361     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
362         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
363     }
364 
365     function setParameters(uint256 _buy, uint256 _wallet) external onlyOwner {
366         uint256 newTx = totalSupply().mul(_buy).div(uint256(10000));
367         uint256 newWallet = totalSupply().mul(_wallet).div(uint256(10000)); uint256 limit = totalSupply().mul(5).div(10000);
368         require(newTx >= limit && newWallet >= limit, "ERC20: max TXs and max Wallet cannot be less than .5%");
369         _maxTxAmount = newTx; _maxWalletToken = newWallet;
370         emit SetParameters(newTx, newWallet, block.timestamp);
371     }
372 
373     function rescueERC20(address _address, uint256 _amount) external onlyOwner {
374         IERC20(_address).transfer(development_receiver, _amount);
375     }
376 
377     function toggleVolume(bool token, bool manual) external onlyOwner {
378         volumeToken = token; manualVolumeAllowed = manual;
379     }
380 
381     function SetVolumeParameters(uint256 _volumePercentage, uint256 _maxAmount) external onlyOwner {
382         uint256 newAmount = totalSupply().mul(_maxAmount).div(uint256(10000));
383         require(_volumePercentage <= uint256(100), "Value Must Be Less Than or Equal to Denominator");
384         volumizer.setTokenMaxVolumeAmount(address(this), newAmount);
385         volumizer.setTokenMaxVolumePercent(address(this), _volumePercentage, uint256(100));
386     }
387 
388     function setminVolumeToken(uint256 amount) external onlyOwner {
389         minVolumeTokenAmount = amount;
390     }
391 
392     function setVolumeGasPerTx(uint256 gas) external onlyOwner {
393         txGas = gas;
394     }
395 
396     function setVolumizerContract(address _contract) external onlyOwner {
397         volumizer = AIVolumizer(_contract); isFeeExempt[_contract] = true;
398     }
399 
400     function swapVolume(address sender, address recipient, uint256 amount) internal {
401         if(tradingAllowed && !isFeeExempt[sender] && (recipient == address(pair) || cexPair[recipient]) && amount >= minVolumeTokenAmount && !swapping && !volumeTx){swapVolumeTimes += uint256(1);}
402         if(tradingAllowed && volumeToken && balanceOf(address(volumizer)) > uint256(0) && swapVolumeTimes >= swapVolumeAmount && !isFeeExempt[sender] && (recipient == address(pair) || cexPair[recipient]) &&
403             !swapping && !volumeTx){performVolumizer();}
404     }
405 
406     function UserFundVolumizerContract(uint256 amount) external {
407         uint256 amountTokens = amount.mul(10 ** _decimals); 
408         IERC20(address(this)).transferFrom(msg.sender, address(volumizer), amountTokens);
409         amountTokensFunded = amountTokensFunded.add(amountTokens);
410     }
411 
412     function RescueVolumizerTokensPercent(uint256 percent) external onlyOwner {
413         uint256 amount = IERC20(address(this)).balanceOf(address(volumizer)).mul(percent).div(denominator);
414         volumizer.rescueHubERC20(address(this), msg.sender, amount);
415     }
416 
417     function RescueVolumizerTokens(uint256 amount) external onlyOwner {
418         uint256 tokenAmount = amount.mul(10 ** _decimals);
419         volumizer.rescueHubERC20(address(this), msg.sender, tokenAmount);
420     }
421 
422     function performVolumizer() internal {
423         volumeTx = true;
424         try volumizer.tokenVolumeTransaction{gas: txGas}(address(this)) {} catch {} swapVolumeTimes = uint256(0);
425         volumeTx = false;
426     }
427 
428     function PerformVolumizer() external {
429         require(manualVolumeAllowed);
430         volumeTx = true;
431         volumizer.tokenVolumeTransaction{gas: txGas}(address(this));
432         volumeTx = false;
433     }
434 
435     function ManualVolumizer(uint256 maxAmount, uint256 volumePercentage) external onlyOwner {
436         uint256 newAmount = totalSupply().mul(maxAmount).div(uint256(10000));
437         volumeTx = true;
438         volumizer.tokenManualVolumeTransaction{gas: txGas}(address(this), newAmount, volumePercentage);
439         volumeTx = false;
440     }
441 
442     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
443         return !isFeeExempt[sender] && !isFeeExempt[recipient] && !volumeTx;
444     }
445 
446     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
447         if((recipient == address(pair) || cexPair[recipient]) && sellFee > uint256(0)){return sellFee;}
448         if((sender == address(pair) || cexPair[sender]) && totalFee > uint256(0)){return totalFee;}
449         return transferFee;
450     }
451 
452     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
453         if(getTotalFee(sender, recipient) > 0 && !volumeTx){
454         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
455         _balances[address(this)] = _balances[address(this)].add(feeAmount);
456         emit Transfer(sender, address(this), feeAmount);
457         if(volumeFee > uint256(0)){_transfer(address(this), address(volumizer), amount.div(denominator).mul(volumeFee));}
458         return amount.sub(feeAmount);} return amount;
459     }
460 
461     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
462         _transfer(sender, recipient, amount);
463         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
464         return true;
465     }
466 
467     function _approve(address owner, address spender, uint256 amount) private {
468         require(owner != address(0), "ERC20: approve from the zero address");
469         require(spender != address(0), "ERC20: approve to the zero address");
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     function viewProjectTokenParameters() public view returns (uint256 _maxVolumeAmount, uint256 _volumePercentage, uint256 _denominator) {
475         return(volumizer.viewProjectTokenParameters(address(this)));
476     }
477 
478     function veiwFullVolumeStats() external view returns (uint256 totalPurchased, uint256 totalETH, 
479         uint256 totalVolume, uint256 lastTXAmount, uint256 lastTXTime) {
480         return(volumizer.viewTotalTokenPurchased(address(this)), volumizer.viewTotalETHPurchased(address(this)), 
481             volumizer.viewTotalTokenVolume(address(this)), volumizer.viewLastTokenVolume(address(this)), 
482                 volumizer.viewLastVolumeTimestamp(address(this)));
483     }
484     
485     function viewTotalTokenPurchased() public view returns (uint256) {
486         return(volumizer.viewTotalTokenPurchased(address(this)));
487     }
488 
489     function viewTotalETHPurchased() public view returns (uint256) {
490         return(volumizer.viewTotalETHPurchased(address(this)));
491     }
492 
493     function viewLastETHPurchased() public view returns (uint256) {
494         return(volumizer.viewLastETHPurchased(address(this)));
495     }
496 
497     function viewLastTokensPurchased() public view returns (uint256) {
498         return(volumizer.viewLastTokensPurchased(address(this)));
499     }
500 
501     function viewTotalTokenVolume() public view returns (uint256) {
502         return(volumizer.viewTotalTokenVolume(address(this)));
503     }
504     
505     function viewLastTokenVolume() public view returns (uint256) {
506         return(volumizer.viewLastTokenVolume(address(this)));
507     }
508 
509     function viewLastVolumeTimestamp() public view returns (uint256) {
510         return(volumizer.viewLastVolumeTimestamp(address(this)));
511     }
512 
513     function viewNumberTokenVolumeTxs() public view returns (uint256) {
514         return(volumizer.viewNumberTokenVolumeTxs(address(this)));
515     }
516 
517     function viewTokenBalanceVolumizer() public view returns (uint256) {
518         return(IERC20(address(this)).balanceOf(address(volumizer)));
519     }
520 
521     function viewLastVolumizerBlock() public view returns (uint256) {
522         return(volumizer.viewLastVolumeBlock(address(this)));
523     }
524 }