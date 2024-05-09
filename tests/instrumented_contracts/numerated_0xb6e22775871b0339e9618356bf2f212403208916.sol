1 // SPDX-License-Identifier: MIT
2 /*
3 
4 
5 ████████╗██╗ ██████╗ ███████╗██████╗     ██╗  ██╗██╗███╗   ██╗ ██████╗     ██████╗     ██████╗ 
6 ╚══██╔══╝██║██╔════╝ ██╔════╝██╔══██╗    ██║ ██╔╝██║████╗  ██║██╔════╝     ╚════██╗   ██╔═████╗
7    ██║   ██║██║  ███╗█████╗  ██████╔╝    █████╔╝ ██║██╔██╗ ██║██║  ███╗     █████╔╝   ██║██╔██║
8    ██║   ██║██║   ██║██╔══╝  ██╔══██╗    ██╔═██╗ ██║██║╚██╗██║██║   ██║    ██╔═══╝    ████╔╝██║
9    ██║   ██║╚██████╔╝███████╗██║  ██║    ██║  ██╗██║██║ ╚████║╚██████╔╝    ███████╗██╗╚██████╔╝
10    ╚═╝   ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝╚═╝ ╚═════╝ 
11                                                                                                
12                                                   
13 WEB : tking2.io
14 TG  : https://t.me/TKING_2
15 TW  : https://twitter.com/TKING2_0 
16 
17 */
18 
19 pragma solidity ^0.8.17;
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34 
35         return c;
36     }
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44 
45         return c;
46     }
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b > 0, errorMessage);
52         uint256 c = a / b;
53         return c;
54     }
55 }
56 
57 interface ERC20 {
58     function totalSupply() external view returns (uint256);
59     function decimals() external view returns (uint8);
60     function symbol() external view returns (string memory);
61     function name() external view returns (string memory);
62     function getOwner() external view returns (address);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address _owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 abstract contract Context {
73     
74     function _msgSender() internal view virtual returns (address payable) {
75         return payable(msg.sender);
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this;
80         return msg.data;
81     }
82 }
83 
84 contract Ownable is Context {
85     address public _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor () {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         authorizations[_owner] = true;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95     mapping (address => bool) internal authorizations;
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 }
117 
118 interface IDEXFactory {
119     function createPair(address tokenA, address tokenB) external returns (address pair);
120 }
121 
122 interface IDEXRouter {
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125 
126     function addLiquidity(
127         address tokenA,
128         address tokenB,
129         uint amountADesired,
130         uint amountBDesired,
131         uint amountAMin,
132         uint amountBMin,
133         address to,
134         uint deadline
135     ) external returns (uint amountA, uint amountB, uint liquidity);
136 
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
145 
146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153 
154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external payable;
160 
161     function swapExactTokensForETHSupportingFeeOnTransferTokens(
162         uint amountIn,
163         uint amountOutMin,
164         address[] calldata path,
165         address to,
166         uint deadline
167     ) external;
168 }
169 
170 interface InterfaceLP {
171     function sync() external;
172 }
173 
174 contract TigerKing2 is Ownable, ERC20 {
175     using SafeMath for uint256;
176 
177     address WETH;
178     address DEAD = 0x000000000000000000000000000000000000dEaD;
179     address ZERO = 0x0000000000000000000000000000000000000000;
180     
181 
182     string constant _name = "TigerKing 2.0";
183     string constant _symbol = "TKING2.0";
184     uint8 constant _decimals = 18; 
185   
186 
187     uint256 _totalSupply = 450 * 10**9 * 10**_decimals;
188 
189     mapping (address => uint256) _balances;
190     mapping (address => mapping (address => uint256)) _allowances;
191 
192     
193     mapping (address => bool) isFeeExempt;
194 
195 
196     uint256 public totalFee         = 10;
197     uint256 private feeDenominator  = 100;
198 
199     uint256 sellMultiplier = 20;
200     uint256 buyMultiplier = 20;
201 
202     address private marketingFeeReceiver;
203 
204 
205     IDEXRouter public router;
206     InterfaceLP private pairContract;
207     address public pair;
208 
209     bool public swapEnabled = true;
210     uint256 public swapThreshold = _totalSupply * 100 / 10000; 
211     bool inSwap;
212 
213     bool private antiMEV = false;
214     mapping (address => bool) private isContractExempt;
215 
216     bool public tradingEnabled = false;
217 
218     uint256 public maxWalletToken = ( _totalSupply * 100 ) / 10000;
219     uint256 public maxTxAmount = ( _totalSupply * 100 ) / 10000;
220 
221 
222     modifier swapping() { inSwap = true; _; inSwap = false; }
223     
224     constructor () {
225 
226         address router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
227         
228         router = IDEXRouter(router_address);
229 
230         WETH = router.WETH();
231         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
232         pairContract = InterfaceLP(pair);
233 
234        
235         
236         _allowances[address(this)][address(router)] = type(uint256).max;
237 
238         marketingFeeReceiver = 0x00d9EDe2A1C0533E956987189861d6548645474e;
239 
240         isFeeExempt[msg.sender] = true;
241         isFeeExempt[marketingFeeReceiver] = true;
242         isFeeExempt[address(this)] = true;
243 
244         isContractExempt[address(router)] = true;
245         isContractExempt[address(pair)] = true;
246 
247         _balances[msg.sender] = _totalSupply;
248         emit Transfer(address(0), msg.sender, _totalSupply);
249 
250     }
251 
252     receive() external payable { }
253 
254     function totalSupply() external view override returns (uint256) { return _totalSupply; }
255     function decimals() external pure override returns (uint8) { return _decimals; }
256     function symbol() external pure override returns (string memory) { return _symbol; }
257     function name() external pure override returns (string memory) { return _name; }
258     function getOwner() external view override returns (address) {return owner();}
259     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
260     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
261 
262     function approve(address spender, uint256 amount) public override returns (bool) {
263         _allowances[msg.sender][spender] = amount;
264         emit Approval(msg.sender, spender, amount);
265         return true;
266     }
267 
268     function approveAll(address spender) external returns (bool) {
269         return approve(spender, type(uint256).max);
270     }
271 
272     function transfer(address recipient, uint256 amount) external override returns (bool) {
273         return _transferFrom(msg.sender, recipient, amount);
274     }
275 
276     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
277         if(_allowances[sender][msg.sender] != type(uint256).max){
278             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
279         }
280 
281         return _transferFrom(sender, recipient, amount);
282     }
283 
284 
285    
286   
287     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
288         
289         require(tradingEnabled || sender == owner() || recipient == owner(), "Trading not yet enabled!");
290 
291         if (recipient != address(pair) && recipient != address(ZERO) && recipient != address(DEAD)) {
292           require((_balances[recipient].add(amount)) <= maxWalletToken || isFeeExempt[sender] || isFeeExempt[recipient], "Exceeds maximum wallet amount.");
293         }
294         
295         if(sender != address(pair)) {
296             require(amount <= maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
297         }
298         // Anti MEV
299         if(antiMEV && !isContractExempt[sender] && !isContractExempt[recipient]){
300             require(!isContract(recipient) || !isContract(sender), "Anti MEV");
301         }
302     
303         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
304 
305         if(shouldSwapBack()){ swapBack(); }
306         
307          _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
308 
309 
310 
311         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
312         _balances[recipient] = _balances[recipient].add(amountReceived);
313 
314         emit Transfer(sender, recipient, amountReceived);
315         return true;
316     }
317     
318     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
319         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
320         _balances[recipient] = _balances[recipient].add(amount);
321         emit Transfer(sender, recipient, amount);
322         return true;
323     }
324 
325     function isContract(address account) private view returns (bool) {
326         uint256 size;
327         assembly {
328             size := extcodesize(account)
329         }
330         
331         return size > 0;
332     }
333 
334     
335 
336     function excemptContract(address ctr_ady) external onlyOwner {
337         isContractExempt[ctr_ady] = true;
338     }
339 
340     function enableTrading() external onlyOwner{
341         require(!tradingEnabled, "Trading already enabled.");
342         tradingEnabled = true;
343     }
344 
345     function toggleAntiMEV(bool toggle) external onlyOwner {
346         antiMEV = toggle;
347     }
348 
349     function setMarketingFeeReceiver(address _feeReceiver) external onlyOwner {
350         marketingFeeReceiver = _feeReceiver;
351     }
352 
353    
354     function shouldTakeFee(address sender) internal view returns (bool) {
355         return !isFeeExempt[sender];
356     }
357 
358     function setParams(uint256 _sellMultiplier, uint256 _buyMultiplier, uint256 _maxWalletToken, uint256 _maxTxAmount) external onlyOwner {
359         sellMultiplier = _sellMultiplier;
360         buyMultiplier = _buyMultiplier;
361         maxWalletToken = _maxWalletToken;
362         maxTxAmount = _maxTxAmount;
363     }
364 
365     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
366         
367         uint256 multiplier = 0;
368 
369         if(recipient == address(pair)) {
370             multiplier = sellMultiplier;
371         } else if (sender == address(pair)) {
372             multiplier = buyMultiplier;
373         }
374 
375         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
376 
377         uint256 contractTokens = feeAmount;
378         _balances[address(this)] = _balances[address(this)].add(contractTokens);
379         emit Transfer(sender, address(this), contractTokens);
380 
381         return amount.sub(feeAmount);
382     }
383 
384     function shouldSwapBack() internal view returns (bool) {
385         return msg.sender != address(pair)
386         && !inSwap
387         && swapEnabled
388         && _balances[address(this)] >= swapThreshold;
389     }
390 
391     function clearStuckETH(uint256 amountPercentage) external onlyOwner {
392         uint256 amountETH = address(this).balance;
393         payable(marketingFeeReceiver).transfer(amountETH * amountPercentage / 100);
394     }
395 
396      function swapback() external onlyOwner {
397            swapBack();
398     
399     }
400 
401 
402     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool) {
403         if(tokens == 0){
404             tokens = ERC20(tokenAddress).balanceOf(address(this));
405         }
406         return ERC20(tokenAddress).transfer(msg.sender, tokens);
407     }
408 
409         
410     function swapBack() internal swapping {
411 
412         uint256 amountToSwap = swapThreshold;
413 
414         address[] memory path = new address[](2);
415         path[0] = address(this);
416         path[1] = WETH;
417 
418         uint256 balanceBefore = address(this).balance;
419 
420         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
421             amountToSwap,
422             0,
423             path,
424             address(this),
425             block.timestamp
426         );
427 
428         uint256 amountETH = address(this).balance.sub(balanceBefore);
429 
430         
431         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETH}("");
432         
433         tmpSuccess = false;
434 
435         
436     }
437 
438     function editSwapbackSettings(bool _enabled, uint256 _amount) external onlyOwner {
439         swapEnabled = _enabled;
440         swapThreshold = _amount;
441     }
442 
443     
444     function getCirculatingSupply() public view returns (uint256) {
445         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
446     }
447 
448 
449 }