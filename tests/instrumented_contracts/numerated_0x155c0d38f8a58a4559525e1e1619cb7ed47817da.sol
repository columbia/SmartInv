1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.17;
8 
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
15     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
16     
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
19 
20     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
22 
23     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
25         if(c / a != b) return(false, 0); return(true, c);}}
26 
27     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
28         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
29 
30     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         unchecked{require(b <= a, errorMessage); return a - b;}}
35 
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         unchecked{require(b > 0, errorMessage); return a / b;}}
38 
39     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         unchecked{require(b > 0, errorMessage); return a % b;}}}
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function circulatingSupply() external view returns (uint256);
45     function decimals() external view returns (uint8);
46     function symbol() external view returns (string memory);
47     function name() external view returns (string memory);
48     function getOwner() external view returns (address);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address _owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);}
56 
57 abstract contract Ownable {
58     address internal owner;
59     constructor(address _owner) {owner = _owner;}
60     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
61     function isOwner(address account) public view returns (bool) {return account == owner;}
62     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
63     event OwnershipTransferred(address owner);
64 }
65 
66 interface IFactory{
67         function createPair(address tokenA, address tokenB) external returns (address pair);
68         function getPair(address tokenA, address tokenB) external view returns (address pair);
69 }
70 
71 interface IRouter {
72     function factory() external pure returns (address);
73     function WETH() external pure returns (address);
74     function addLiquidityETH(
75         address token,
76         uint amountTokenDesired,
77         uint amountTokenMin,
78         uint amountETHMin,
79         address to,
80         uint deadline
81     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
82 
83     function removeLiquidityWithPermit(
84         address tokenA,
85         address tokenB,
86         uint liquidity,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline,
91         bool approveMax, uint8 v, bytes32 r, bytes32 s
92     ) external returns (uint amountA, uint amountB);
93 
94     function swapExactETHForTokensSupportingFeeOnTransferTokens(
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external payable;
100 
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline) external;
107 }
108 
109 contract AiShiba is IERC20, Ownable {
110     using SafeMath for uint256;
111     string private constant _name = 'AISHIBA';
112     string private constant _symbol = 'AISHIB';
113     uint8 private constant _decimals = 9;
114     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
115     uint256 private _maxTxAmount = ( _totalSupply * 100 ) / 10000;
116     uint256 private _maxSellAmount = ( _totalSupply * 100 ) / 10000;
117     uint256 private _maxWalletToken = ( _totalSupply * 300 ) / 10000;
118     mapping (address => uint256) _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) public isFeeExempt;
121     mapping (address => bool) public isDividendExempt;
122     mapping (address => bool) private isBot;
123     IRouter router;
124     address public pair;
125     bool private tradingAllowed = false;
126     uint256 private liquidityFee = 0;
127     uint256 private marketingFee = 200;
128     uint256 private rewardsFee = 300;
129     uint256 private developmentFee = 200;
130     uint256 private burnFee = 0;
131     uint256 private totalFee = 700;
132     uint256 private sellFee = 700;
133     uint256 private transferFee = 0;
134     uint256 private denominator = 10000;
135     bool private swapEnabled = true;
136     uint256 private swapTimes;
137     bool private swapping; 
138     uint256 private swapThreshold = ( _totalSupply * 500 ) / 100000;
139     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
140     modifier lockTheSwap {swapping = true; _; swapping = false;}
141     address public reward = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE;
142     uint256 public totalShares;
143     uint256 public totalDividends;
144     uint256 public totalDistributed;
145     uint256 internal dividendsPerShare;
146     uint256 internal dividendsPerShareAccuracyFactor = 10 ** 36;
147     address[] shareholders;
148     mapping (address => uint256) shareholderIndexes;
149     mapping (address => uint256) shareholderClaims;
150     struct Share {uint256 amount; uint256 totalExcluded; uint256 totalRealised; }
151     mapping (address => Share) public shares;
152     uint256 internal currentIndex;
153     uint256 public minPeriod = 60 minutes;
154     uint256 public minDistribution = 1 * (10 ** 16);
155     uint256 public distributorGas = 1;
156     function _claimDividend() external {distributeDividend(msg.sender);}
157 
158     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
159     address internal constant development_receiver = 0xed2F150737C9dd5299F67F25C444ED0ACE6FD49A; 
160     address internal constant marketing_receiver = 0x4309E7FedB27577FeD05786f324409bC07d273Df;
161     address internal constant liquidity_receiver = 0x42ef30c8D00c3017a86e8667Ba4F131fF2CB4de3;
162 
163     constructor() Ownable(msg.sender) {
164         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
165         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
166         router = _router;
167         pair = _pair;
168         isFeeExempt[address(this)] = true;
169         isFeeExempt[liquidity_receiver] = true;
170         isFeeExempt[marketing_receiver] = true;
171         isFeeExempt[msg.sender] = true;
172         isDividendExempt[address(pair)] = true;
173         isDividendExempt[address(msg.sender)] = false;        
174         isDividendExempt[address(this)] = true;
175         isDividendExempt[address(DEAD)] = true;
176         isDividendExempt[address(0)] = true;
177         _balances[msg.sender] = _totalSupply;
178         emit Transfer(address(0), msg.sender, _totalSupply);
179     }
180 
181     receive() external payable {}
182     function name() public pure returns (string memory) {return _name;}
183     function symbol() public pure returns (string memory) {return _symbol;}
184     function decimals() public pure returns (uint8) {return _decimals;}
185     function startTrading() external onlyOwner {tradingAllowed = true;}
186     function getOwner() external view override returns (address) { return owner; }
187     function totalSupply() public view override returns (uint256) {return _totalSupply;}
188     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
189     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
190     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
191     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
192     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
193     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
194     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
195 
196     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
197         require(sender != address(0), "ERC20: transfer from the zero address");
198         require(recipient != address(0), "ERC20: transfer to the zero address");
199         require(amount > uint256(0), "Transfer amount must be greater than zero");
200         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
201     }
202 
203     function _transfer(address sender, address recipient, uint256 amount) private {
204         preTxCheck(sender, recipient, amount);
205         checkTradingAllowed(sender, recipient);
206         checkMaxWallet(sender, recipient, amount); 
207         swapbackCounters(sender, recipient);
208         checkTxLimit(sender, recipient, amount); 
209         swapBack(sender, recipient, amount);
210         _balances[sender] = _balances[sender].sub(amount);
211         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
212         _balances[recipient] = _balances[recipient].add(amountReceived);
213         emit Transfer(sender, recipient, amountReceived);
214         if(!isDividendExempt[sender]){setShare(sender, balanceOf(sender));}
215         if(!isDividendExempt[recipient]){setShare(recipient, balanceOf(recipient));}
216         if(shares[recipient].amount > 0){distributeDividend(recipient);}
217         process(distributorGas);
218     }
219 
220     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _rewards, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
221         liquidityFee = _liquidity;
222         marketingFee = _marketing;
223         burnFee = _burn;
224         rewardsFee = _rewards;
225         developmentFee = _development;
226         totalFee = _total;
227         sellFee = _sell;
228         transferFee = _trans;
229         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5) && transferFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
230     }
231 
232     function setisBot(address _address, bool _enabled) external onlyOwner {
233         require(_address != address(pair) && _address != address(router) && _address != address(this), "Ineligible Address");
234         isBot[_address] = _enabled;
235     }
236 
237     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
238         uint256 newTx = (totalSupply() * _buy) / 10000;
239         uint256 newTransfer = (totalSupply() * _trans) / 10000;
240         uint256 newWallet = (totalSupply() * _wallet) / 10000;
241         _maxTxAmount = newTx;
242         _maxSellAmount = newTransfer;
243         _maxWalletToken = newWallet;
244         uint256 limit = totalSupply().mul(5).div(1000);
245         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
246     }
247 
248     function checkTradingAllowed(address sender, address recipient) internal view {
249         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
250     }
251     
252     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
253         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
254             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
255     }
256 
257     function swapbackCounters(address sender, address recipient) internal {
258         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
259     }
260 
261     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
262         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
263         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
264     }
265 
266     function swapAndLiquify(uint256 tokens) private lockTheSwap {
267         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee).add(rewardsFee)).mul(2);
268         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
269         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
270         uint256 initialBalance = address(this).balance;
271         swapTokensForETH(toSwap);
272         uint256 deltaBalance = address(this).balance.sub(initialBalance);
273         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
274         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
275         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
276         uint256 marketingAmount = unitBalance.mul(2).mul(marketingFee);
277         if(marketingAmount > 0){payable(marketing_receiver).transfer(marketingAmount);}
278         uint256 rewardsAmount = unitBalance.mul(2).mul(rewardsFee);
279         if(rewardsAmount > 0){deposit(rewardsAmount);}
280         if(address(this).balance > uint256(0)){payable(development_receiver).transfer(address(this).balance);}
281     }
282 
283     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
284         _approve(address(this), address(router), tokenAmount);
285         router.addLiquidityETH{value: ETHAmount}(
286             address(this),
287             tokenAmount,
288             0,
289             0,
290             liquidity_receiver,
291             block.timestamp);
292     }
293 
294     function swapTokensForETH(uint256 tokenAmount) private {
295         address[] memory path = new address[](2);
296         path[0] = address(this);
297         path[1] = router.WETH();
298         _approve(address(this), address(router), tokenAmount);
299         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
300             tokenAmount,
301             0,
302             path,
303             address(this),
304             block.timestamp);
305     }
306 
307     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
308         bool aboveMin = amount >= _minTokenAmount;
309         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
310         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
311     }
312 
313     function swapBack(address sender, address recipient, uint256 amount) internal {
314         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
315     }
316 
317     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
318         return !isFeeExempt[sender] && !isFeeExempt[recipient];
319     }
320 
321     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
322         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
323         if(recipient == pair){return sellFee;}
324         if(sender == pair){return totalFee;}
325         return transferFee;
326     }
327 
328     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
329         if(getTotalFee(sender, recipient) > 0){
330         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
331         _balances[address(this)] = _balances[address(this)].add(feeAmount);
332         emit Transfer(sender, address(this), feeAmount);
333         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
334         return amount.sub(feeAmount);} return amount;
335     }
336 
337     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
338         _transfer(sender, recipient, amount);
339         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
340         return true;
341     }
342 
343     function _approve(address owner, address spender, uint256 amount) private {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346         _allowances[owner][spender] = amount;
347         emit Approval(owner, spender, amount);
348     }
349 
350     function setisDividendExempt(address holder, bool exempt) external onlyOwner {
351         isDividendExempt[holder] = exempt;
352         if(exempt){setShare(holder, 0);}
353         else{setShare(holder, balanceOf(holder)); }
354     }
355 
356     function setShare(address shareholder, uint256 amount) internal {
357         if(amount > 0 && shares[shareholder].amount == 0){addShareholder(shareholder);}
358         else if(amount == 0 && shares[shareholder].amount > 0){removeShareholder(shareholder); }
359         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
360         shares[shareholder].amount = amount;
361         shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
362     }
363 
364     function deposit(uint256 amountETH) internal {
365         uint256 balanceBefore = IERC20(reward).balanceOf(address(this));
366         address[] memory path = new address[](2);
367         path[0] = router.WETH();
368         path[1] = address(reward);
369         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountETH}(
370             0,
371             path,
372             address(this),
373             block.timestamp);
374         uint256 amount = IERC20(reward).balanceOf(address(this)).sub(balanceBefore);
375         totalDividends = totalDividends.add(amount);
376         dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
377     }
378 
379     function process(uint256 gas) internal {
380         uint256 shareholderCount = shareholders.length;
381         if(shareholderCount == 0) { return; }
382         uint256 gasUsed = 0;
383         uint256 gasLeft = gasleft();
384         uint256 iterations = 0;
385         while(gasUsed < gas && iterations < shareholderCount) {
386             if(currentIndex >= shareholderCount){currentIndex = 0;}
387             if(shouldDistribute(shareholders[currentIndex])){
388                 distributeDividend(shareholders[currentIndex]);}
389             gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
390             gasLeft = gasleft();
391             currentIndex++;
392             iterations++;
393         }
394     }
395 
396     function rescueERC20(address _address, uint256 _amount) external onlyOwner {
397         IERC20(_address).transfer(msg.sender, _amount);
398     }
399     
400     function shouldDistribute(address shareholder) internal view returns (bool) {
401         return shareholderClaims[shareholder] + minPeriod < block.timestamp
402                 && getUnpaidEarnings(shareholder) > minDistribution;
403     }
404 
405     function totalRewardsDistributed(address _wallet) external view returns (uint256) {
406         address shareholder = _wallet;
407         return uint256(shares[shareholder].totalRealised);
408     }
409 
410     function distributeDividend(address shareholder) internal {
411         if(shares[shareholder].amount == 0){ return; }
412         uint256 amount = getUnpaidEarnings(shareholder);
413         if(amount > 0){
414             totalDistributed = totalDistributed.add(amount);
415             IERC20(reward).transfer(shareholder, amount);
416             shareholderClaims[shareholder] = block.timestamp;
417             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
418             shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);}
419     }
420 
421     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
422         if(shares[shareholder].amount == 0){ return 0; }
423         uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
424         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
425         if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
426         return shareholderTotalDividends.sub(shareholderTotalExcluded);
427     }
428 
429     function getCumulativeDividends(uint256 share) internal view returns (uint256) {
430         return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
431     }
432 
433     function addShareholder(address shareholder) internal {
434         shareholderIndexes[shareholder] = shareholders.length;
435         shareholders.push(shareholder);
436     }
437 
438     function removeShareholder(address shareholder) internal {
439         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
440         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
441         shareholders.pop();
442     }
443 
444     function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution, uint256 _distributorGas) external onlyOwner {
445         minPeriod = _minPeriod;
446         minDistribution = _minDistribution;
447         distributorGas = _distributorGas;
448     }
449 }