1 /**
2 
3 Schipperke Inu $SCHIPS is an innovative new ERC-20 meme token on the Ethereum Network 
4 striving to create the same inspirational journey many before us have gone through. 
5 He provides a safe home for his community members during one of the biggest and scariest 
6 bear markets in recent times. The $SCHIPS community will be known as a strong, supportive, 
7 and positive community in the crypto space as everyone works together to crush 0's and reach success.
8 
9 Holding your $SCHIPS is rewarding, literally! With every transaction, 2% will be used to buy and distribute 
10 Shiba $BONE rewards to all holders automatically every 8 hours! 
11 
12 https://www.facebook.com/groups/schipperkeinu
13 https://www.facebook.com/SchipperkeInuOfficial
14 http://schipperkeinu.com/
15 https://twitter.com/SchipperkeInu
16 https://t.me/SchipperkeInu
17 
18 */
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity 0.8.17;
23 
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
30     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
31     
32     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
34 
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
37 
38     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
40         if(c / a != b) return(false, 0); return(true, c);}}
41 
42     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
44 
45     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         unchecked{require(b <= a, errorMessage); return a - b;}}
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         unchecked{require(b > 0, errorMessage); return a / b;}}
53 
54     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         unchecked{require(b > 0, errorMessage); return a % b;}}}
56 
57 interface IERC20 {
58     function totalSupply() external view returns (uint256);
59     function circulatingSupply() external view returns (uint256);
60     function decimals() external view returns (uint8);
61     function symbol() external view returns (string memory);
62     function name() external view returns (string memory);
63     function getOwner() external view returns (address);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address _owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);}
71 
72 abstract contract Ownable {
73     address internal owner;
74     constructor(address _owner) {owner = _owner;}
75     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
76     function isOwner(address account) public view returns (bool) {return account == owner;}
77     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
78     event OwnershipTransferred(address owner);
79 }
80 
81 interface IFactory{
82         function createPair(address tokenA, address tokenB) external returns (address pair);
83         function getPair(address tokenA, address tokenB) external view returns (address pair);
84 }
85 
86 interface IRouter {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89     function addLiquidityETH(
90         address token,
91         uint amountTokenDesired,
92         uint amountTokenMin,
93         uint amountETHMin,
94         address to,
95         uint deadline
96     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
97 
98     function removeLiquidityWithPermit(
99         address tokenA,
100         address tokenB,
101         uint liquidity,
102         uint amountAMin,
103         uint amountBMin,
104         address to,
105         uint deadline,
106         bool approveMax, uint8 v, bytes32 r, bytes32 s
107     ) external returns (uint amountA, uint amountB);
108 
109     function swapExactETHForTokensSupportingFeeOnTransferTokens(
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external payable;
115 
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline) external;
122 }
123 
124 contract SchipperkeInu is IERC20, Ownable {
125     using SafeMath for uint256;
126     string private constant _name = 'Schipperke Inu';
127     string private constant _symbol = 'SCHIPS';
128     uint8 private constant _decimals = 9;
129     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
130     uint256 private _maxTxAmount = ( _totalSupply * 100 ) / 10000;
131     uint256 private _maxSellAmount = ( _totalSupply * 100 ) / 10000;
132     uint256 private _maxWalletToken = ( _totalSupply * 100 ) / 10000;
133     mapping (address => uint256) _balances;
134     mapping (address => mapping (address => uint256)) private _allowances;
135     mapping (address => bool) public isFeeExempt;
136     mapping (address => bool) public isDividendExempt;
137     mapping (address => bool) private isBot;
138     IRouter router;
139     address public pair;
140     bool private tradingAllowed = false;
141     uint256 private liquidityFee = 0;
142     uint256 private marketingFee = 200;
143     uint256 private rewardsFee = 200;
144     uint256 private developmentFee = 200;
145     uint256 private burnFee = 0;
146     uint256 private totalFee = 2000;
147     uint256 private sellFee = 4500;
148     uint256 private transferFee = 4500;
149     uint256 private denominator = 10000;
150     bool private swapEnabled = true;
151     uint256 private swapTimes;
152     bool private swapping; 
153     uint256 private swapThreshold = ( _totalSupply * 250 ) / 100000;
154     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
155     modifier lockTheSwap {swapping = true; _; swapping = false;}
156     address public reward = 0x9813037ee2218799597d83D4a5B6F3b6778218d9;
157     uint256 public totalShares;
158     uint256 public totalDividends;
159     uint256 public totalDistributed;
160     uint256 internal dividendsPerShare;
161     uint256 internal dividendsPerShareAccuracyFactor = 10 ** 36;
162     address[] shareholders;
163     mapping (address => uint256) shareholderIndexes;
164     mapping (address => uint256) shareholderClaims;
165     struct Share {uint256 amount; uint256 totalExcluded; uint256 totalRealised; }
166     mapping (address => Share) public shares;
167     uint256 internal currentIndex;
168     uint256 public minPeriod = 480 minutes;
169     uint256 public minDistribution = 1 * (10 ** 16);
170     uint256 public distributorGas = 500000;
171     function _claimDividend() external {distributeDividend(msg.sender);}
172 
173     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
174     address internal constant development_receiver = 0x81B627401F7E8A557405080446fCB2Db72e5d242; 
175     address internal constant marketing_receiver = 0x3FcC39Fce78Cec54cC4ee9F654480dC16cB494f1;
176     address internal constant liquidity_receiver = 0x81B627401F7E8A557405080446fCB2Db72e5d242;
177 
178     constructor() Ownable(msg.sender) {
179         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
180         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
181         router = _router;
182         pair = _pair;
183         isFeeExempt[address(this)] = true;
184         isFeeExempt[liquidity_receiver] = true;
185         isFeeExempt[marketing_receiver] = true;
186         isFeeExempt[msg.sender] = true;
187         isDividendExempt[address(pair)] = true;
188         isDividendExempt[address(msg.sender)] = true;        
189         isDividendExempt[address(this)] = true;
190         isDividendExempt[address(DEAD)] = true;
191         isDividendExempt[address(0)] = true;
192         _balances[msg.sender] = _totalSupply;
193         emit Transfer(address(0), msg.sender, _totalSupply);
194     }
195 
196     receive() external payable {}
197     function name() public pure returns (string memory) {return _name;}
198     function symbol() public pure returns (string memory) {return _symbol;}
199     function decimals() public pure returns (uint8) {return _decimals;}
200     function startTrading() external onlyOwner {tradingAllowed = true;}
201     function getOwner() external view override returns (address) { return owner; }
202     function totalSupply() public view override returns (uint256) {return _totalSupply;}
203     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
204     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
205     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
206     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
207     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
208     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
209     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
210 
211     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
212         require(sender != address(0), "ERC20: transfer from the zero address");
213         require(recipient != address(0), "ERC20: transfer to the zero address");
214         require(amount > uint256(0), "Transfer amount must be greater than zero");
215         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
216     }
217 
218     function _transfer(address sender, address recipient, uint256 amount) private {
219         preTxCheck(sender, recipient, amount);
220         checkTradingAllowed(sender, recipient);
221         checkMaxWallet(sender, recipient, amount); 
222         swapbackCounters(sender, recipient);
223         checkTxLimit(sender, recipient, amount); 
224         swapBack(sender, recipient, amount);
225         _balances[sender] = _balances[sender].sub(amount);
226         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
227         _balances[recipient] = _balances[recipient].add(amountReceived);
228         emit Transfer(sender, recipient, amountReceived);
229         if(!isDividendExempt[sender]){setShare(sender, balanceOf(sender));}
230         if(!isDividendExempt[recipient]){setShare(recipient, balanceOf(recipient));}
231         if(shares[recipient].amount > 0){distributeDividend(recipient);}
232         process(distributorGas);
233     }
234 
235     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _rewards, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
236         liquidityFee = _liquidity;
237         marketingFee = _marketing;
238         burnFee = _burn;
239         rewardsFee = _rewards;
240         developmentFee = _development;
241         totalFee = _total;
242         sellFee = _sell;
243         transferFee = _trans;
244         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5) && transferFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
245     }
246 
247     function setisBot(address _address, bool _enabled) external onlyOwner {
248         require(_address != address(pair) && _address != address(router) && _address != address(this), "Ineligible Address");
249         isBot[_address] = _enabled;
250     }
251 
252     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
253         uint256 newTx = (totalSupply() * _buy) / 10000;
254         uint256 newTransfer = (totalSupply() * _trans) / 10000;
255         uint256 newWallet = (totalSupply() * _wallet) / 10000;
256         _maxTxAmount = newTx;
257         _maxSellAmount = newTransfer;
258         _maxWalletToken = newWallet;
259         uint256 limit = totalSupply().mul(5).div(1000);
260         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
261     }
262 
263     function checkTradingAllowed(address sender, address recipient) internal view {
264         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
265     }
266     
267     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
268         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
269             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
270     }
271 
272     function swapbackCounters(address sender, address recipient) internal {
273         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
274     }
275 
276     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
277         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
278         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
279     }
280 
281     function swapAndLiquify(uint256 tokens) private lockTheSwap {
282         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee).add(rewardsFee)).mul(2);
283         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
284         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
285         uint256 initialBalance = address(this).balance;
286         swapTokensForETH(toSwap);
287         uint256 deltaBalance = address(this).balance.sub(initialBalance);
288         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
289         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
290         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
291         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
292         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
293         uint256 rewardsAmount = unitBalance.mul(2).mul(rewardsFee);
294         if(rewardsAmount > 0){deposit(rewardsAmount);}
295         if(address(this).balance > uint256(0)){payable(development_receiver).transfer(address(this).balance);}
296     }
297 
298     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
299         _approve(address(this), address(router), tokenAmount);
300         router.addLiquidityETH{value: ETHAmount}(
301             address(this),
302             tokenAmount,
303             0,
304             0,
305             liquidity_receiver,
306             block.timestamp);
307     }
308 
309     function swapTokensForETH(uint256 tokenAmount) private {
310         address[] memory path = new address[](2);
311         path[0] = address(this);
312         path[1] = router.WETH();
313         _approve(address(this), address(router), tokenAmount);
314         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
315             tokenAmount,
316             0,
317             path,
318             address(this),
319             block.timestamp);
320     }
321 
322     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
323         bool aboveMin = amount >= _minTokenAmount;
324         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
325         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
326     }
327 
328     function swapBack(address sender, address recipient, uint256 amount) internal {
329         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
330     }
331 
332     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
333         return !isFeeExempt[sender] && !isFeeExempt[recipient];
334     }
335 
336     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
337         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
338         if(recipient == pair){return sellFee;}
339         if(sender == pair){return totalFee;}
340         return transferFee;
341     }
342 
343     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
344         if(getTotalFee(sender, recipient) > 0){
345         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
346         _balances[address(this)] = _balances[address(this)].add(feeAmount);
347         emit Transfer(sender, address(this), feeAmount);
348         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
349         return amount.sub(feeAmount);} return amount;
350     }
351 
352     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
353         _transfer(sender, recipient, amount);
354         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
355         return true;
356     }
357 
358     function _approve(address owner, address spender, uint256 amount) private {
359         require(owner != address(0), "ERC20: approve from the zero address");
360         require(spender != address(0), "ERC20: approve to the zero address");
361         _allowances[owner][spender] = amount;
362         emit Approval(owner, spender, amount);
363     }
364 
365     function setisDividendExempt(address holder, bool exempt) external onlyOwner {
366         isDividendExempt[holder] = exempt;
367         if(exempt){setShare(holder, 0);}
368         else{setShare(holder, balanceOf(holder)); }
369     }
370 
371     function setShare(address shareholder, uint256 amount) internal {
372         if(amount > 0 && shares[shareholder].amount == 0){addShareholder(shareholder);}
373         else if(amount == 0 && shares[shareholder].amount > 0){removeShareholder(shareholder); }
374         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
375         shares[shareholder].amount = amount;
376         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
377     }
378 
379     function deposit(uint256 amountETH) internal {
380         uint256 balanceBefore = IERC20(reward).balanceOf(address(this));
381         address[] memory path = new address[](2);
382         path[0] = router.WETH();
383         path[1] = address(reward);
384         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountETH}(
385             0,
386             path,
387             address(this),
388             block.timestamp);
389         uint256 amount = IERC20(reward).balanceOf(address(this)).sub(balanceBefore);
390         totalDividends = totalDividends.add(amount);
391         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
392     }
393 
394     function process(uint256 gas) internal {
395         uint256 shareholderCount = shareholders.length;
396         if(shareholderCount == 0) { return; }
397         uint256 gasUsed = 0;
398         uint256 gasLeft = gasleft();
399         uint256 iterations = 0;
400         while(gasUsed < gas && iterations < shareholderCount) {
401             if(currentIndex >= shareholderCount){currentIndex = 0;}
402             if(shouldDistribute(shareholders[currentIndex])){
403                 distributeDividend(shareholders[currentIndex]);}
404             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
405             gasLeft = gasleft();
406             currentIndex++;
407             iterations++;
408         }
409     }
410 
411     function rescueERC20(address _address, uint256 _amount) external onlyOwner {
412         IERC20(_address).transfer(msg.sender, _amount);
413     }
414     
415     function shouldDistribute(address shareholder) internal view returns (bool) {
416         return shareholderClaims[shareholder] + minPeriod < block.timestamp
417                 && getUnpaidEarnings(shareholder) > minDistribution;
418     }
419 
420     function totalRewardsDistributed(address _wallet) external view returns (uint256) {
421         address shareholder = _wallet;
422         return uint256(shares[shareholder].totalRealised);
423     }
424 
425     function distributeDividend(address shareholder) internal {
426         if(shares[shareholder].amount == 0){ return; }
427         uint256 amount = getUnpaidEarnings(shareholder);
428         if(amount > 0){
429             totalDistributed = totalDistributed.add(amount);
430             IERC20(reward).transfer(shareholder, amount);
431             shareholderClaims[shareholder] = block.timestamp;
432             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
433             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);}
434     }
435 
436     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
437         if(shares[shareholder].amount == 0){ return 0; }
438         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
439         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
440         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
441         return shareholderTotalDividends.sub(shareholderTotalExcluded);
442     }
443 
444     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
445         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
446     }
447 
448     function addShareholder(address shareholder) internal {
449         shareholderIndexes[shareholder] = shareholders.length;
450         shareholders.push(shareholder);
451     }
452 
453     function removeShareholder(address shareholder) internal {
454         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
455         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
456         shareholders.pop();
457     }
458 
459     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _distributorGas) external onlyOwner {
460         minPeriod = _minPeriod;
461         minDistribution = _minDistribution;
462         distributorGas = _distributorGas;
463     }
464 }