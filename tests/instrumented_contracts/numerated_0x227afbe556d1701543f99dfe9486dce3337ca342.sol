1 /**
2 https://t.me/Shibawards
3 
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.17;
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
68 interface IFactory{
69         function createPair(address tokenA, address tokenB) external returns (address pair);
70         function getPair(address tokenA, address tokenB) external view returns (address pair);
71 }
72 
73 interface IRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76     function addLiquidityETH(
77         address token,
78         uint amountTokenDesired,
79         uint amountTokenMin,
80         uint amountETHMin,
81         address to,
82         uint deadline
83     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
84 
85     function removeLiquidityWithPermit(
86         address tokenA,
87         address tokenB,
88         uint liquidity,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline,
93         bool approveMax, uint8 v, bytes32 r, bytes32 s
94     ) external returns (uint amountA, uint amountB);
95 
96     function swapExactETHForTokensSupportingFeeOnTransferTokens(
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external payable;
102 
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline) external;
109 }
110 
111 contract Shibawards is IERC20, Ownable {
112     using SafeMath for uint256;
113     string private constant _name = 'Shibawards';
114     string private constant _symbol = 'Shibawards';
115     uint8 private constant _decimals = 9;
116     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
117     uint256 private _maxTxAmount = ( _totalSupply * 100 ) / 10000;
118     uint256 private _maxSellAmount = ( _totalSupply * 100 ) / 10000;
119     uint256 private _maxWalletToken = ( _totalSupply * 300 ) / 10000;
120     mapping (address => uint256) _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) public isFeeExempt;
123     mapping (address => bool) public isDividendExempt;
124     mapping (address => bool) private isBot;
125     IRouter router;
126     address public pair;
127     bool private tradingAllowed = false;
128     uint256 private liquidityFee = 0;
129     uint256 private marketingFee = 200;
130     uint256 private rewardsFee = 500;
131     uint256 private developmentFee = 200;
132     uint256 private burnFee = 0;
133     uint256 private totalFee = 900;
134     uint256 private sellFee = 900;
135     uint256 private transferFee = 4500;
136     uint256 private denominator = 10000;
137     bool private swapEnabled = true;
138     uint256 private swapTimes;
139     bool private swapping; 
140     uint256 private swapThreshold = ( _totalSupply * 500 ) / 100000;
141     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
142     modifier lockTheSwap {swapping = true; _; swapping = false;}
143     address public reward = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE;
144     uint256 public totalShares;
145     uint256 public totalDividends;
146     uint256 public totalDistributed;
147     uint256 internal dividendsPerShare;
148     uint256 internal dividendsPerShareAccuracyFactor = 10 ** 36;
149     address[] shareholders;
150     mapping (address => uint256) shareholderIndexes;
151     mapping (address => uint256) shareholderClaims;
152     struct Share {uint256 amount; uint256 totalExcluded; uint256 totalRealised; }
153     mapping (address => Share) public shares;
154     uint256 internal currentIndex;
155     uint256 public minPeriod = 60 minutes;
156     uint256 public minDistribution = 1 * (10 ** 16);
157     uint256 public distributorGas = 500000;
158     function _claimDividend() external {distributeDividend(msg.sender);}
159 
160     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
161     address internal constant development_receiver = 0x72d72d1512d801ceA6316e0Bf2AD9C4895385aC3; 
162     address internal constant marketing_receiver = 0xfece5111b71d9bFc2CDC89F9c6FA68694990a0D4;
163     address internal constant liquidity_receiver = 0x72d72d1512d801ceA6316e0Bf2AD9C4895385aC3;
164 
165     constructor() Ownable(msg.sender) {
166         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
167         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
168         router = _router;
169         pair = _pair;
170         isFeeExempt[address(this)] = true;
171         isFeeExempt[liquidity_receiver] = true;
172         isFeeExempt[marketing_receiver] = true;
173         isFeeExempt[msg.sender] = true;
174         isDividendExempt[address(pair)] = true;
175         isDividendExempt[address(msg.sender)] = true;        
176         isDividendExempt[address(this)] = true;
177         isDividendExempt[address(DEAD)] = true;
178         isDividendExempt[address(0)] = true;
179         _balances[msg.sender] = _totalSupply;
180         emit Transfer(address(0), msg.sender, _totalSupply);
181     }
182 
183     receive() external payable {}
184     function name() public pure returns (string memory) {return _name;}
185     function symbol() public pure returns (string memory) {return _symbol;}
186     function decimals() public pure returns (uint8) {return _decimals;}
187     function startTrading() external onlyOwner {tradingAllowed = true;}
188     function getOwner() external view override returns (address) { return owner; }
189     function totalSupply() public view override returns (uint256) {return _totalSupply;}
190     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
191     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
192     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
193     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
194     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
195     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
196     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
197 
198     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
199         require(sender != address(0), "ERC20: transfer from the zero address");
200         require(recipient != address(0), "ERC20: transfer to the zero address");
201         require(amount > uint256(0), "Transfer amount must be greater than zero");
202         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
203     }
204 
205     function _transfer(address sender, address recipient, uint256 amount) private {
206         preTxCheck(sender, recipient, amount);
207         checkTradingAllowed(sender, recipient);
208         checkMaxWallet(sender, recipient, amount); 
209         swapbackCounters(sender, recipient);
210         checkTxLimit(sender, recipient, amount); 
211         swapBack(sender, recipient, amount);
212         _balances[sender] = _balances[sender].sub(amount);
213         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
214         _balances[recipient] = _balances[recipient].add(amountReceived);
215         emit Transfer(sender, recipient, amountReceived);
216         if(!isDividendExempt[sender]){setShare(sender, balanceOf(sender));}
217         if(!isDividendExempt[recipient]){setShare(recipient, balanceOf(recipient));}
218         if(shares[recipient].amount > 0){distributeDividend(recipient);}
219         process(distributorGas);
220     }
221 
222     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _rewards, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
223         liquidityFee = _liquidity;
224         marketingFee = _marketing;
225         burnFee = _burn;
226         rewardsFee = _rewards;
227         developmentFee = _development;
228         totalFee = _total;
229         sellFee = _sell;
230         transferFee = _trans;
231         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5) && transferFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
232     }
233 
234     function setisBot(address _address, bool _enabled) external onlyOwner {
235         require(_address != address(pair) && _address != address(router) && _address != address(this), "Ineligible Address");
236         isBot[_address] = _enabled;
237     }
238 
239     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
240         uint256 newTx = (totalSupply() * _buy) / 10000;
241         uint256 newTransfer = (totalSupply() * _trans) / 10000;
242         uint256 newWallet = (totalSupply() * _wallet) / 10000;
243         _maxTxAmount = newTx;
244         _maxSellAmount = newTransfer;
245         _maxWalletToken = newWallet;
246         uint256 limit = totalSupply().mul(5).div(1000);
247         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
248     }
249 
250     function checkTradingAllowed(address sender, address recipient) internal view {
251         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
252     }
253     
254     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
255         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
256             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
257     }
258 
259     function swapbackCounters(address sender, address recipient) internal {
260         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
261     }
262 
263     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
264         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
265         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
266     }
267 
268     function swapAndLiquify(uint256 tokens) private lockTheSwap {
269         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee).add(rewardsFee)).mul(2);
270         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
271         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
272         uint256 initialBalance = address(this).balance;
273         swapTokensForETH(toSwap);
274         uint256 deltaBalance = address(this).balance.sub(initialBalance);
275         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
276         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
277         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
278         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
279         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
280         uint256 rewardsAmount = unitBalance.mul(2).mul(rewardsFee);
281         if(rewardsAmount > 0){deposit(rewardsAmount);}
282         if(address(this).balance > uint256(0)){payable(development_receiver).transfer(address(this).balance);}
283     }
284 
285     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
286         _approve(address(this), address(router), tokenAmount);
287         router.addLiquidityETH{value: ETHAmount}(
288             address(this),
289             tokenAmount,
290             0,
291             0,
292             liquidity_receiver,
293             block.timestamp);
294     }
295 
296     function swapTokensForETH(uint256 tokenAmount) private {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = router.WETH();
300         _approve(address(this), address(router), tokenAmount);
301         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp);
307     }
308 
309     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
310         bool aboveMin = amount >= _minTokenAmount;
311         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
312         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
313     }
314 
315     function swapBack(address sender, address recipient, uint256 amount) internal {
316         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
317     }
318 
319     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
320         return !isFeeExempt[sender] && !isFeeExempt[recipient];
321     }
322 
323     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
324         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
325         if(recipient == pair){return sellFee;}
326         if(sender == pair){return totalFee;}
327         return transferFee;
328     }
329 
330     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
331         if(getTotalFee(sender, recipient) > 0){
332         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
333         _balances[address(this)] = _balances[address(this)].add(feeAmount);
334         emit Transfer(sender, address(this), feeAmount);
335         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
336         return amount.sub(feeAmount);} return amount;
337     }
338 
339     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
340         _transfer(sender, recipient, amount);
341         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
342         return true;
343     }
344 
345     function _approve(address owner, address spender, uint256 amount) private {
346         require(owner != address(0), "ERC20: approve from the zero address");
347         require(spender != address(0), "ERC20: approve to the zero address");
348         _allowances[owner][spender] = amount;
349         emit Approval(owner, spender, amount);
350     }
351 
352     function setisDividendExempt(address holder, bool exempt) external onlyOwner {
353         isDividendExempt[holder] = exempt;
354         if(exempt){setShare(holder, 0);}
355         else{setShare(holder, balanceOf(holder)); }
356     }
357 
358     function setShare(address shareholder, uint256 amount) internal {
359         if(amount > 0 && shares[shareholder].amount == 0){addShareholder(shareholder);}
360         else if(amount == 0 && shares[shareholder].amount > 0){removeShareholder(shareholder); }
361         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
362         shares[shareholder].amount = amount;
363         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
364     }
365 
366     function deposit(uint256 amountETH) internal {
367         uint256 balanceBefore = IERC20(reward).balanceOf(address(this));
368         address[] memory path = new address[](2);
369         path[0] = router.WETH();
370         path[1] = address(reward);
371         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountETH}(
372             0,
373             path,
374             address(this),
375             block.timestamp);
376         uint256 amount = IERC20(reward).balanceOf(address(this)).sub(balanceBefore);
377         totalDividends = totalDividends.add(amount);
378         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
379     }
380 
381     function process(uint256 gas) internal {
382         uint256 shareholderCount = shareholders.length;
383         if(shareholderCount == 0) { return; }
384         uint256 gasUsed = 0;
385         uint256 gasLeft = gasleft();
386         uint256 iterations = 0;
387         while(gasUsed < gas && iterations < shareholderCount) {
388             if(currentIndex >= shareholderCount){currentIndex = 0;}
389             if(shouldDistribute(shareholders[currentIndex])){
390                 distributeDividend(shareholders[currentIndex]);}
391             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
392             gasLeft = gasleft();
393             currentIndex++;
394             iterations++;
395         }
396     }
397 
398     function rescueERC20(address _address, uint256 _amount) external onlyOwner {
399         IERC20(_address).transfer(msg.sender, _amount);
400     }
401     
402     function shouldDistribute(address shareholder) internal view returns (bool) {
403         return shareholderClaims[shareholder] + minPeriod < block.timestamp
404                 && getUnpaidEarnings(shareholder) > minDistribution;
405     }
406 
407     function totalRewardsDistributed(address _wallet) external view returns (uint256) {
408         address shareholder = _wallet;
409         return uint256(shares[shareholder].totalRealised);
410     }
411 
412     function distributeDividend(address shareholder) internal {
413         if(shares[shareholder].amount == 0){ return; }
414         uint256 amount = getUnpaidEarnings(shareholder);
415         if(amount > 0){
416             totalDistributed = totalDistributed.add(amount);
417             IERC20(reward).transfer(shareholder, amount);
418             shareholderClaims[shareholder] = block.timestamp;
419             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
420             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);}
421     }
422 
423     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
424         if(shares[shareholder].amount == 0){ return 0; }
425         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
426         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
427         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
428         return shareholderTotalDividends.sub(shareholderTotalExcluded);
429     }
430 
431     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
432         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
433     }
434 
435     function addShareholder(address shareholder) internal {
436         shareholderIndexes[shareholder] = shareholders.length;
437         shareholders.push(shareholder);
438     }
439 
440     function removeShareholder(address shareholder) internal {
441         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
442         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
443         shareholders.pop();
444     }
445 
446     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _distributorGas) external onlyOwner {
447         minPeriod = _minPeriod;
448         minDistribution = _minDistribution;
449         distributorGas = _distributorGas;
450     }
451 }