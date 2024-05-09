1 // SPDX-License-Identifier: UNLICENSED
2 
3 
4 pragma solidity 0.8.7;
5 
6 library SafeMath {
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         return sub(a, b, "SafeMath: subtraction overflow");
15     }
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41 
42 interface ERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address payable) {
59         return payable(address(msg.sender));
60     }
61 
62     function _msgData() internal view virtual returns (bytes memory) {
63         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
64         return msg.data;
65     }
66 }
67 
68 contract Ownable is Context {
69     address private _owner;
70     address private _previousOwner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }  
94 
95 
96 interface IDEXFactory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IDEXRouter {
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103 
104     function addLiquidity(
105         address tokenA,
106         address tokenB,
107         uint amountADesired,
108         uint amountBDesired,
109         uint amountAMin,
110         uint amountBMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountA, uint amountB, uint liquidity);
114 
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 
124     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131 
132     function swapExactETHForTokensSupportingFeeOnTransferTokens(
133         uint amountOutMin,
134         address[] calldata path,
135         address to,
136         uint deadline
137     ) external payable;
138 
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146 }
147 
148 interface InterfaceLP {
149     function sync() external;
150 }
151 
152 contract Falcon is ERC20, Ownable {
153     using SafeMath for uint256;
154 
155     uint256 private protection = 1; 
156     uint256 public launchBlock;
157     uint256 private protectionBlock;
158 
159     address private WETH;
160     address private DEAD = 0x000000000000000000000000000000000000dEaD;
161     address private ZERO = 0x0000000000000000000000000000000000000000;
162 
163     string constant private _name = "Falcon";
164     string constant private _symbol = "$Rocket";
165     uint8 constant private _decimals = 18;
166 
167     uint256 private _totalSupply = 100000000* 10**_decimals;
168 
169     uint256 public _maxWalletAmount = _totalSupply / 100;
170 
171     mapping (address => uint256) private _balances;
172     mapping (address => mapping (address => uint256)) private _allowances;
173 
174     address[] public _markerPairs;
175     mapping (address => bool) public automatedMarketMakerPairs;
176     mapping (address => bool) public isFeeExempt;
177     mapping (address => bool) public isMaxWalletExempt;
178 
179     uint256 private wlTime = 10 minutes; 
180     uint256 private launchTimestamp; 
181     mapping (address => bool) private isWL; 
182 
183     //Fees
184     uint256 private constant transferFee = 0;
185 
186     uint256 private constant totalBuyFee = 2;
187     uint256 private constant totalSellFee = 2;
188 
189     uint256 private constant feeDenominator  = 100;
190 
191     address private marketingFeeReceiver = 0x4f226c2fdC354d99FB6FC930D694d76E76566579;
192 
193     IDEXRouter public router;
194     address public pair;
195 
196     bool public tradingEnabled = false;
197     bool public swapEnabled = true;
198     uint256 public swapThreshold = _totalSupply * 1 / 5000;
199 
200     bool private inSwap;
201     modifier swapping() { inSwap = true; _; inSwap = false; }
202 
203     constructor () {
204         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
205         WETH = router.WETH();
206         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
207 
208         setAutomatedMarketMakerPair(pair, true);
209 
210         _allowances[address(this)][address(router)] = type(uint256).max;
211 
212         isFeeExempt[msg.sender] = true;
213         isMaxWalletExempt[msg.sender] = true;
214 
215                
216         isFeeExempt[address(this)] = true; 
217         isMaxWalletExempt[address(this)] = true;
218 
219         isMaxWalletExempt[pair] = true;
220 
221 
222         _balances[msg.sender] = _totalSupply;
223         emit Transfer(address(0), msg.sender, _totalSupply);
224     }
225 
226     receive() external payable { }
227 
228     function totalSupply() external view override returns (uint256) { return _totalSupply; }
229     function decimals() external pure override returns (uint8) { return _decimals; }
230     function symbol() external pure override returns (string memory) { return _symbol; }
231     function name() external pure override returns (string memory) { return _name; }
232     function getOwner() external view override returns (address) { return owner(); }
233     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
234     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
235 
236     function approve(address spender, uint256 amount) public override returns (bool) {
237         _allowances[msg.sender][spender] = amount;
238         emit Approval(msg.sender, spender, amount);
239         return true;
240     }
241 
242     function approveMax(address spender) external returns (bool) {
243         return approve(spender, type(uint256).max);
244     }
245 
246     function transfer(address recipient, uint256 amount) external override returns (bool) {
247         return _transferFrom(msg.sender, recipient, amount);
248     }
249 
250     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
251         if(_allowances[sender][msg.sender] != type(uint256).max){
252             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
253         }
254 
255         return _transferFrom(sender, recipient, amount);
256     }
257 
258     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
259         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
260 
261         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){
262             require(tradingEnabled,"Trading not open yet");
263         }
264 
265         if(shouldSwapBack()){ swapBack(); }
266 
267         uint256 amountReceived = amount; 
268 
269         if(automatedMarketMakerPairs[sender]) { //buy
270             if(!isFeeExempt[recipient]) {
271                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
272                 if(block.timestamp <= launchTimestamp.add(wlTime)) {require (isWL[recipient], "can't buy, yet");}
273                 amountReceived = takeBuyFee(sender, amount);
274             }
275 
276         } else if(automatedMarketMakerPairs[recipient]) { //sell
277             if(!isFeeExempt[sender]) {
278                 amountReceived = takeSellFee(sender, amount);
279 
280             }
281         } else {	
282             if (!isFeeExempt[sender]) {	
283                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
284                 amountReceived = takeTransferFee(sender, amount);
285 
286             }
287         }
288 
289         _balances[sender] = _balances[sender].sub(amount);
290         _balances[recipient] = _balances[recipient].add(amountReceived);
291         
292 
293         emit Transfer(sender, recipient, amountReceived);
294         return true;
295     }
296     
297     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
298         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
299         _balances[recipient] = _balances[recipient].add(amount);
300         emit Transfer(sender, recipient, amount);
301         return true;
302     }
303 
304     // Fees
305     function takeBuyFee(address sender, uint256 amount) internal returns (uint256){
306         uint256 _realFee = totalBuyFee;
307         if (block.number < protectionBlock) {
308                 _realFee = 99;
309             }
310 
311         uint256 feeAmount = amount.mul(_realFee).div(feeDenominator);
312 
313         _balances[address(this)] = _balances[address(this)].add(feeAmount);
314         emit Transfer(sender, address(this), feeAmount);
315 
316         return amount.sub(feeAmount);
317     }
318 
319     function takeSellFee(address sender, uint256 amount) internal returns (uint256){
320 
321         uint256 feeAmount = amount.mul(totalSellFee).div(feeDenominator);
322 
323         _balances[address(this)] = _balances[address(this)].add(feeAmount);
324         emit Transfer(sender, address(this), feeAmount);
325 
326         return amount.sub(feeAmount);
327             
328     }
329 
330     function takeTransferFee(address sender, uint256 amount) internal returns (uint256){
331         uint256 feeAmount = amount.mul(transferFee).div(feeDenominator);
332         
333         if (feeAmount > 0) {
334             _balances[address(this)] = _balances[address(this)].add(feeAmount);	
335             emit Transfer(sender, address(this), feeAmount); 
336         }
337             	
338         return amount.sub(feeAmount);	
339     }    
340 
341     function shouldSwapBack() internal view returns (bool) {
342         return
343         !automatedMarketMakerPairs[msg.sender]
344         && !inSwap
345         && swapEnabled
346         && _balances[address(this)] >= swapThreshold;
347     }
348 
349     // switch Trading
350     function enableTrading() external onlyOwner {
351         tradingEnabled = true;
352         launchBlock = block.number;
353         launchTimestamp = block.timestamp; 
354         protectionBlock = block.number.add(protection);
355     }
356 
357     function swapBack() internal swapping {
358         address[] memory path = new address[](2);
359         path[0] = address(this);
360         path[1] = WETH;
361 
362         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
363             _balances[address(this)],
364             0,
365             path,
366             marketingFeeReceiver,
367             block.timestamp
368         );
369     }
370 
371 
372     // Admin Functions
373     function setAutomatedMarketMakerPair(address _pair, bool _value) internal {
374             require(automatedMarketMakerPairs[_pair] != _value, "Value already set");
375 
376             automatedMarketMakerPairs[_pair] = _value;
377 
378             if(_value){
379                 _markerPairs.push(_pair);
380             }else{
381                 require(_markerPairs.length > 1, "Required 1 pair");
382                 for (uint256 i = 0; i < _markerPairs.length; i++) {
383                     if (_markerPairs[i] == _pair) {
384                         _markerPairs[i] = _markerPairs[_markerPairs.length - 1];
385                         _markerPairs.pop();
386                         break;
387                     }
388                 }
389             }
390         }
391 
392     function getCirculatingSupply() public view returns (uint256) {
393         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
394     }
395 
396     function letsChangeIt (uint256 _number) external onlyOwner {
397         require(_number < 15, "Can't go that high");
398         protection = _number;
399         
400     }
401 
402     function setWallet(address _address, bool _bool) external onlyOwner {
403         isWL[_address]=_bool;
404     }
405 
406 
407 }