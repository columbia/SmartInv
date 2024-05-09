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
152 contract BERT is ERC20, Ownable {
153     using SafeMath for uint256;
154 
155     uint256 public launchBlock;
156 
157     address private WETH;
158     address private DEAD = 0x000000000000000000000000000000000000dEaD;
159     address private ZERO = 0x0000000000000000000000000000000000000000;
160 
161     string constant private _name = "BERT";
162     string constant private _symbol = "$BERT";
163     uint8 constant private _decimals = 18;
164 
165     uint256 private _totalSupply = 100000000* 10**_decimals;
166 
167     uint256 public _maxWalletAmount = _totalSupply / 100;
168 
169     mapping (address => uint256) private _balances;
170     mapping (address => mapping (address => uint256)) private _allowances;
171 
172     address[] public _markerPairs;
173     mapping (address => bool) public automatedMarketMakerPairs;
174     mapping (address => bool) public isFeeExempt;
175     mapping (address => bool) public isMaxWalletExempt;
176 
177     bool private wlActive = true; 
178     uint256 private launchTimestamp; 
179     mapping (address => bool) private isWL; 
180 
181     //Fees
182     uint256 private constant transferFee = 0;
183 
184     uint256 public constant totalBuyFee = 0;
185     uint256 public totalSellFee = 10;
186 
187     uint256 private constant feeDenominator  = 100;
188 
189     address private marketingFeeReceiver = 0x0E64003cb5581aA37678c7C5044Bd5cF95f911b9;
190 
191     IDEXRouter public router;
192     address public pair;
193 
194     bool public tradingEnabled = false;
195     bool public swapEnabled = true;
196     uint256 public swapThreshold = _totalSupply * 1 / 5000;
197 
198     bool private inSwap;
199     modifier swapping() { inSwap = true; _; inSwap = false; }
200 
201     constructor () {
202         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
203         WETH = router.WETH();
204         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
205 
206         setAutomatedMarketMakerPair(pair, true);
207 
208         _allowances[address(this)][address(router)] = type(uint256).max;
209 
210         isFeeExempt[msg.sender] = true;
211         isMaxWalletExempt[msg.sender] = true;
212 
213                
214         isFeeExempt[address(this)] = true; 
215         isMaxWalletExempt[address(this)] = true;
216 
217         isMaxWalletExempt[pair] = true;
218 
219 
220         _balances[msg.sender] = _totalSupply;
221         emit Transfer(address(0), msg.sender, _totalSupply);
222     }
223 
224     receive() external payable { }
225 
226     function totalSupply() external view override returns (uint256) { return _totalSupply; }
227     function decimals() external pure override returns (uint8) { return _decimals; }
228     function symbol() external pure override returns (string memory) { return _symbol; }
229     function name() external pure override returns (string memory) { return _name; }
230     function getOwner() external view override returns (address) { return owner(); }
231     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
232     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
233 
234     function approve(address spender, uint256 amount) public override returns (bool) {
235         _allowances[msg.sender][spender] = amount;
236         emit Approval(msg.sender, spender, amount);
237         return true;
238     }
239 
240     function approveMax(address spender) external returns (bool) {
241         return approve(spender, type(uint256).max);
242     }
243 
244     function transfer(address recipient, uint256 amount) external override returns (bool) {
245         return _transferFrom(msg.sender, recipient, amount);
246     }
247 
248     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
249         if(_allowances[sender][msg.sender] != type(uint256).max){
250             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
251         }
252 
253         return _transferFrom(sender, recipient, amount);
254     }
255 
256     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
257         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
258 
259         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){
260             require(tradingEnabled,"Trading not open yet");
261         }
262 
263         if(shouldSwapBack()){ swapBack(); }
264 
265         uint256 amountReceived = amount; 
266 
267         if(automatedMarketMakerPairs[sender]) { //buy
268             if(!isFeeExempt[recipient]) {
269                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
270                 if(wlActive) {require (isWL[recipient], "can't buy, yet");}
271                 amountReceived = takeBuyFee(sender, amount);
272             }
273 
274         } else if(automatedMarketMakerPairs[recipient]) { //sell
275             if(!isFeeExempt[sender]) {
276                 amountReceived = takeSellFee(sender, amount);
277 
278             }
279         } else {	
280             if (!isFeeExempt[sender]) {	
281                 require(_balances[recipient].add(amount) <= _maxWalletAmount || isMaxWalletExempt[recipient], "Max Wallet Limit Limit Exceeded");
282                 amountReceived = takeTransferFee(sender, amount);
283 
284             }
285         }
286 
287         _balances[sender] = _balances[sender].sub(amount);
288         _balances[recipient] = _balances[recipient].add(amountReceived);
289         
290 
291         emit Transfer(sender, recipient, amountReceived);
292         return true;
293     }
294     
295     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
296         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
297         _balances[recipient] = _balances[recipient].add(amount);
298         emit Transfer(sender, recipient, amount);
299         return true;
300     }
301 
302     // Fees
303     function takeBuyFee(address sender, uint256 amount) internal returns (uint256){
304         uint256 _realFee = totalBuyFee;
305 
306         uint256 feeAmount = amount.mul(_realFee).div(feeDenominator);
307 
308         _balances[address(this)] = _balances[address(this)].add(feeAmount);
309         emit Transfer(sender, address(this), feeAmount);
310 
311         return amount.sub(feeAmount);
312     }
313 
314     function takeSellFee(address sender, uint256 amount) internal returns (uint256){
315 
316         uint256 feeAmount = amount.mul(totalSellFee).div(feeDenominator);
317 
318         _balances[address(this)] = _balances[address(this)].add(feeAmount);
319         emit Transfer(sender, address(this), feeAmount);
320 
321         return amount.sub(feeAmount);
322             
323     }
324 
325     function takeTransferFee(address sender, uint256 amount) internal returns (uint256){
326         uint256 feeAmount = amount.mul(transferFee).div(feeDenominator);
327         
328         if (feeAmount > 0) {
329             _balances[address(this)] = _balances[address(this)].add(feeAmount);	
330             emit Transfer(sender, address(this), feeAmount); 
331         }
332             	
333         return amount.sub(feeAmount);	
334     }    
335 
336     function shouldSwapBack() internal view returns (bool) {
337         return
338         !automatedMarketMakerPairs[msg.sender]
339         && !inSwap
340         && swapEnabled
341         && _balances[address(this)] >= swapThreshold;
342     }
343 
344     // switch Trading
345     function enableTrading() external onlyOwner {
346         tradingEnabled = true;
347         launchBlock = block.number;
348         launchTimestamp = block.timestamp; 
349     }
350 
351     function swapBack() internal swapping {
352         address[] memory path = new address[](2);
353         path[0] = address(this);
354         path[1] = WETH;
355 
356         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
357             _balances[address(this)],
358             0,
359             path,
360             marketingFeeReceiver,
361             block.timestamp
362         );
363     }
364 
365 
366     // Admin Functions
367     function setAutomatedMarketMakerPair(address _pair, bool _value) internal {
368             require(automatedMarketMakerPairs[_pair] != _value, "Value already set");
369 
370             automatedMarketMakerPairs[_pair] = _value;
371 
372             if(_value){
373                 _markerPairs.push(_pair);
374             }else{
375                 require(_markerPairs.length > 1, "Required 1 pair");
376                 for (uint256 i = 0; i < _markerPairs.length; i++) {
377                     if (_markerPairs[i] == _pair) {
378                         _markerPairs[i] = _markerPairs[_markerPairs.length - 1];
379                         _markerPairs.pop();
380                         break;
381                     }
382                 }
383             }
384         }
385 
386     function getCirculatingSupply() public view returns (uint256) {
387         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
388     }
389 
390 
391     function setWallet(address _address, bool _bool) external onlyOwner {
392         isWL[_address]=_bool;
393     }
394 
395     function setMultiple(address[] memory _address, bool _bool) external onlyOwner {
396         uint256 count = _address.length;
397         for (uint256 i = 0; i < count; i++)
398         {
399             isWL[_address[i]] = _bool;
400         }
401         
402     }
403 
404     function setSellTax(uint256 _sellFee) external onlyOwner {
405         require(_sellFee == 0, "Can only set tax to 0");
406         totalSellFee = _sellFee;
407     }
408 
409     function disableWL() external onlyOwner {
410         wlActive = false; 
411     }
412 
413 }