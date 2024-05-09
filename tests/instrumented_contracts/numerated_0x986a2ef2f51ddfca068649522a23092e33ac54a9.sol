1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5                               ██████████████████████████████████████████
6                               ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
7                               ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
8                               ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
9                               ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
10                               ██████████░░░░░░░░░░░░████████░░░░░░░░░░██
11                               ██▒▒▒▒▒▒▒▒██░░░░░░████▒▒▒▒▒▒▒▒████░░░░░░██
12                             ██▒▒▒▒▒▒▒▒▒▒▒▒██░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██░░░░██
13                           ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██░░██
14                           ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██░░██
15                         ██▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒██░░██
16                         ██▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒██░░██
17                         ██▒▒▒▒▒▒▒▒░░░░░░░░▒▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒██░░██
18                         ██▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒██░░██
19                         ██▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒██▒▒░░██
20                           ██▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒██░░██  
21                           ██▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒██░░░░██  
22                             ██▒▒▒▒▒▒▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒████░░░░██  
23                             ████▒▒▒▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒██  ██░░░░██  
24                             ██░░██▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒████    ██░░░░██  
25                             ██░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██        ██░░░░██  
26                             ██░░░░██▒▒▒▒▒▒▒▒▒▒▒▒████          ██░░░░██  
27                           ████████████▒▒▒▒▒▒▒▒██              ██░░░░██  
28                   ████████          ██▒▒▒▒████  ██████████████████████  
29           ████████  ░░▒▒░░          ▒▒████          ▒▒░░░░░░░░░░░░░░  ██
30   ████████░░                                                    ░░░░░░██
31 ██                                                        ░░░░░░██████  
32 ██░░░░░░░░░░░░░░░░░░░░░░░░░░                        ░░░░░░██████░░██    
33   ██████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░██████  ██░░░░██    
34       ██░░░░████████▒▒▒▒▒▒▒▒████████████████████████      ██████░░██    
35       ██░░░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒██        ██▒▒░░██  ██████▒▒▒▒██░░██    
36       ██░░░░██████████████████░░██        ██░░░░████▒▒▒▒▒▒▒▒▒▒██░░██    
37       ██░░░░░░░░░░░░░░░░░░░░████████████████░░░░██▒▒▒▒▒▒▒▒▒▒▒▒██░░██    
38       ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██▒▒▒▒▒▒▒▒████▓▓░░██    
39       ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██▒▒██████  ██░░░░██    
40       ██░░░░██████████████░░░░░░░░░░░░░░░░░░░░░░████        ██░░░░██    
41       ██░░░░██            ██████████████████░░░░██          ██░░░░██    
42       ██░░░░██            ██░░░░██        ██░░░░██          ██░░░░██    
43       ██░░░░██            ██░░░░██        ██░░░░██          ██░░░░██    
44       ██░░░░██            ██░░░░██        ██░░░░██          ██░░░░██    
45       ██░░░░██            ██░░░░██        ██░░░░██          ██░░░░██    
46       ██░░░░██              ████          ██░░░░██          ██░░░░██    
47       ██░░░░██                            ██░░░░██            ████      
48       ██░░░░██                            ██░░░░██            ▒▒▒▒      
49       ██░░░░██                            ██░░░░██                      
50       ██░░░░██                            ██░░░░██                      
51         ████                              ██░░░░██                      
52                                             ▓▓▓▓                        
53 
54 Chair Has Legs
55 
56 Web : https://chair.capital/
57 Twitter : https://twitter.com/ChairErc20
58 Tg : https://t.me/ChairERC20
59 */
60 
61 
62 pragma solidity 0.8.20;
63 
64 abstract contract Context {
65     function _msgSender() internal view virtual returns (address) {
66         return msg.sender;
67     }
68 }
69 
70 interface IERC20 {
71     function totalSupply() external view returns (uint256);
72     function balanceOf(address account) external view returns (uint256);
73     function transfer(address recipient, uint256 amount) external returns (bool);
74     function allowance(address owner, address spender) external view returns (uint256);
75     function approve(address spender, uint256 amount) external returns (bool);
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 library SafeMath {
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85         return c;
86     }
87 
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         return sub(a, b, "SafeMath: subtraction overflow");
90     }
91 
92     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95         return c;
96     }
97 
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104         return c;
105     }
106 
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b > 0, errorMessage);
113         uint256 c = a / b;
114         return c;
115     }
116 
117 }
118 
119 contract Ownable is Context {
120     address private _owner;
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     constructor () {
124         address msgSender = _msgSender();
125         _owner = msgSender;
126         emit OwnershipTransferred(address(0), msgSender);
127     }
128 
129     function owner() public view returns (address) {
130         return _owner;
131     }
132 
133     modifier onlyOwner() {
134         require(_owner == _msgSender(), "Ownable: caller is not the owner");
135         _;
136     }
137 
138     function renounceOwnership() public virtual onlyOwner {
139         emit OwnershipTransferred(_owner, address(0));
140         _owner = address(0);
141     }
142 
143 }
144 
145 interface IUniswapV2Factory {
146     function createPair(address tokenA, address tokenB) external returns (address pair);
147 }
148 
149 interface IUniswapV2Router02 {
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to,
155         uint deadline
156     ) external;
157     function factory() external pure returns (address);
158     function WETH() external pure returns (address);
159     function addLiquidityETH(
160         address token,
161         uint amountTokenDesired,
162         uint amountTokenMin,
163         uint amountETHMin,
164         address to,
165         uint deadline
166     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
167 }
168 
169 contract CHAIR is Context, IERC20, Ownable {
170     using SafeMath for uint256;
171     mapping (address => uint256) private _balances;
172     mapping (address => mapping (address => uint256)) private _allowances;
173     mapping (address => bool) private _isExcludedFromFee;
174     address payable private _taxWallet; // Marketing Wallet
175     address payable private _teamWallet; // Team Wallet
176     uint256 private _taxWalletPercentage = 50; // 50%
177     uint256 private _teamWalletPercentage = 50; // 50%
178 
179     uint256 firstBlock;
180 
181     uint256 private _initialBuyTax=20;
182     uint256 private _initialSellTax=25;
183     uint256 private _finalBuyTax=1;
184     uint256 private _finalSellTax=1;
185     uint256 private _reduceBuyTaxAt=20;
186     uint256 private _reduceSellTaxAt=30;
187     uint256 private _preventSwapBefore=25;
188     uint256 private _buyCount=0;
189 
190     uint8 private constant _decimals = 9;
191     uint256 private constant _tTotal = 100000000000 * 10**_decimals;
192     string private constant _name = unicode"🪑";
193     string private constant _symbol = unicode"CHAIR";
194     uint256 public _maxTxAmount =  _tTotal / 100;
195     uint256 public _maxWalletSize =   _tTotal / 100;
196     uint256 public _taxSwapThreshold=  _tTotal / 100;
197     uint256 public _maxTaxSwap=   _tTotal / 100;
198 
199     IUniswapV2Router02 private uniswapV2Router;
200     address private uniswapV2Pair;
201     bool private tradingOpen;
202     bool private inSwap = false;
203     bool private swapEnabled = false;
204 
205     event MaxTxAmountUpdated(uint _maxTxAmount);
206     event ClearStuck(uint256 amount);
207     event ClearToken(address TokenAddressCleared, uint256 Amount);
208     modifier lockTheSwap {
209         inSwap = true;
210         _;
211         inSwap = false;
212     }
213 
214     constructor () {
215 
216         _taxWallet = payable(_msgSender());
217         _teamWallet = payable(0xc54cCb7CACa7C2282b3c06a5922Dc5c4c051c64F);
218         _balances[_msgSender()] = _tTotal;
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[_taxWallet] = true;
222         
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225 
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229 
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233 
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237 
238     function totalSupply() public pure override returns (uint256) {
239         return _tTotal;
240     }
241 
242     function balanceOf(address account) public view override returns (uint256) {
243         return _balances[account];
244     }
245 
246     function transfer(address recipient, uint256 amount) public override returns (bool) {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     function allowance(address owner, address spender) public view override returns (uint256) {
252         return _allowances[owner][spender];
253     }
254 
255     function approve(address spender, uint256 amount) public override returns (bool) {
256         _approve(_msgSender(), spender, amount);
257         return true;
258     }
259 
260     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
261         _transfer(sender, recipient, amount);
262         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
263         return true;
264     }
265 
266     function _approve(address owner, address spender, uint256 amount) private {
267         require(owner != address(0), "ERC20: approve from the zero address");
268         require(spender != address(0), "ERC20: approve to the zero address");
269         _allowances[owner][spender] = amount;
270         emit Approval(owner, spender, amount);
271     }
272 
273     function _transfer(address from, address to, uint256 amount) private {
274         require(from != address(0), "ERC20: transfer from the zero address");
275         require(to != address(0), "ERC20: transfer to the zero address");
276         require(amount > 0, "Transfer amount must be greater than zero");
277         uint256 taxAmount=0;
278 
279         if (from != owner() && to != owner()) {
280             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
281 
282             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
283                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
284                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
285 
286                 if (firstBlock + 3  > block.number) {
287                     require(!isContract(to));
288                 }
289                 _buyCount++;
290             }
291 
292             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
293                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
294             }
295 
296             if(to == uniswapV2Pair && from!= address(this) ){
297                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
298             }
299 
300             uint256 contractTokenBalance = balanceOf(address(this));
301             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
302                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
303                 uint256 contractETHBalance = address(this).balance;
304                 if(contractETHBalance > 0) {
305                     sendETHToFee(address(this).balance);
306                 }
307             }
308         }
309 
310         if(taxAmount>0){
311           _balances[address(this)]=_balances[address(this)].add(taxAmount);
312           emit Transfer(from, address(this),taxAmount);
313         }
314         _balances[from]=_balances[from].sub(amount);
315         _balances[to]=_balances[to].add(amount.sub(taxAmount));
316         emit Transfer(from, to, amount.sub(taxAmount));
317     }
318 
319 
320     function min(uint256 a, uint256 b) private pure returns (uint256){
321       return (a>b)?b:a;
322     }
323 
324     function isContract(address account) private view returns (bool) {
325         uint256 size;
326         assembly {
327             size := extcodesize(account)
328         }
329         return size > 0;
330     }
331 
332     function isExcludedFromFee(address account) public view returns (bool) {
333         return _isExcludedFromFee[account];
334     }
335 
336     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
337         address[] memory path = new address[](2);
338         path[0] = address(this);
339         path[1] = uniswapV2Router.WETH();
340         _approve(address(this), address(uniswapV2Router), tokenAmount);
341         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
342             tokenAmount,
343             0,
344             path,
345             address(this),
346             block.timestamp
347         );
348     }
349 
350     function removeLimits() external onlyOwner{
351         _maxTxAmount = _tTotal;
352         _maxWalletSize=_tTotal;
353         emit MaxTxAmountUpdated(_tTotal);
354     }
355 
356     function sendETHToFee(uint256 amount) private {
357         uint256 taxWalletShare = amount * _taxWalletPercentage / 100;
358         uint256 teamWalletShare = amount * _teamWalletPercentage / 100;
359 
360         _taxWallet.transfer(taxWalletShare);
361         _teamWallet.transfer(teamWalletShare);
362     }
363 
364     function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
365              if(tokens == 0){
366             tokens = IERC20(tokenAddress).balanceOf(address(this));
367         }
368         emit ClearToken(tokenAddress, tokens);
369         return IERC20(tokenAddress).transfer(_taxWallet, tokens);
370     }
371 
372     function manualSend() external {
373         require(address(this).balance > 0, "Contract balance must be greater than zero");
374 
375         uint256 balance = address(this).balance; // Check
376         payable(_taxWallet).transfer(balance); // Effects + Interaction
377     }
378  
379     function manualSwap() external{
380         uint256 tokenBalance=balanceOf(address(this));
381         if(tokenBalance>0){
382           swapTokensForEth(tokenBalance);
383         }
384         uint256 ethBalance=address(this).balance;
385         if(ethBalance>0){
386           sendETHToFee(ethBalance);
387         }
388     }
389 
390     function sitDown() external onlyOwner() {
391         require(!tradingOpen,"trading is already open");
392 
393         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
394         _approve(address(this), address(uniswapV2Router), _tTotal);
395         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
396 
397         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
398         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
399 
400         swapEnabled = true;
401         tradingOpen = true;
402         firstBlock = block.number;
403     }
404 
405 
406     receive() external payable {}
407 }