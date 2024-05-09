1 /*
2 
3                                                                     
4                               ░░░░▒▒▒▒░░                            
5                           ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒                          
6                         ▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒                      
7                       ▒▒░░░░░░░░░░░░▒▒▒▒▒▒▓▓▓▓▒▒                    
8                     ▒▒▒▒░░░░░░░░░░░░▒▒▒▒▒▒▓▓▓▓▓▓▒▒                  
9                   ░░▒▒░░░░░░░░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓░░                
10                   ▓▓▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓                
11                 ▒▒▒▒░░░░░░░░░░░░▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░              
12                 ▓▓▒▒░░░░░░░░░░▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██              
13               ▒▒▒▒▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██░░            
14               ▓▓▒▒░░░░░░░░▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████            
15             ░░▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████            
16             ▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒▒          
17             ▓▓▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████          
18             ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████          
19           ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████░░        
20           ▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▒▒        
21           ▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓████▒▒        
22           ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓▓▓████▓▓        
23           ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓▓▓████▓▓        
24           ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████▓▓        
25           ▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████▒▒        
26           ▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████░░        
27           ░░▓▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████          
28             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████          
29             ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████████▒▒          
30               ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████            
31               ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████░░            
32                 ▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████████░░              
33                   ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████████████                  
34                       ▒▒██████████████████████▒▒                    
35                             ▒▒▓▓██████▓▓▒▒                          
36                                                                     
37 
38 
39                      https://t.me/EggEntry
40 
41                       http://eggerc.vip/
42 
43                  https://twitter.com/EGG_Coin_
44 
45 */
46 // SPDX-License-Identifier: MIT
47 
48 pragma solidity 0.8.20;
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 }
55 
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58     function balanceOf(address account) external view returns (uint256);
59     function transfer(address recipient, uint256 amount) external returns (bool);
60     function allowance(address owner, address spender) external view returns (uint256);
61     function approve(address spender, uint256 amount) external returns (bool);
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval (address indexed owner, address indexed spender, uint256 value);
65 }
66 
67 library SafeMath {
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71         return c;
72     }
73 
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77 
78     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b <= a, errorMessage);
80         uint256 c = a - b;
81         return c;
82     }
83 
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         if (a == 0) {
86             return 0;
87         }
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90         return c;
91     }
92 
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return div(a, b, "SafeMath: division by zero");
95     }
96 
97     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         require(b > 0, errorMessage);
99         uint256 c = a / b;
100         return c;
101     }
102 
103 }
104 
105 contract Ownable is Context {
106     address private _owner;
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     constructor () {
110         address msgSender = _msgSender();
111         _owner = msgSender;
112         emit OwnershipTransferred(address(0), msgSender);
113     }
114 
115     function owner() public view returns (address) {
116         return _owner;
117     }
118 
119     modifier onlyOwner() {
120         require(_owner == _msgSender(), "Ownable: caller is not the owner");
121         _;
122     }
123 
124     function renounceOwnership() public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, address(0));
126         _owner = address(0);
127     }
128 
129 }
130 
131 interface IUniswapV2Factory {
132     function createPair(address tokenA, address tokenB) external returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143     function factory() external pure returns (address);
144     function WETH() external pure returns (address);
145     function addLiquidityETH(
146         address token,
147         uint amountTokenDesired,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline
152     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
153 }
154 
155 contract EGG is Context, IERC20, Ownable {
156     using SafeMath for uint256;
157     mapping (address => uint256) private _balances;
158     mapping (address => mapping (address => uint256)) private _allowances;
159     mapping (address => bool) private _isExcludedFromFee;
160     mapping (address => bool) private bots;
161     address payable private _taxWallet;
162     uint256 firstBlock;
163 
164     uint256 private _initialBuyTax=20;
165     uint256 private _initialSellTax=20;
166     uint256 private _finalBuyTax=2;
167     uint256 private _finalSellTax=2;
168     uint256 private _reduceBuyTaxAt=15;
169     uint256 private _reduceSellTaxAt=20;
170     uint256 private _preventSwapBefore=20;
171     uint256 private _buyCount=0;
172 
173     uint8 private constant _decimals = 9;
174     uint256 private constant _tTotal = 42069000000 * 10**_decimals;
175     string private constant _name = unicode"EGG";
176     string private constant _symbol = unicode"EGG";
177     uint256 public _maxTxAmount = 841380000 * 10**_decimals;
178     uint256 public _maxWalletSize = 841380000 * 10**_decimals;
179     uint256 public _taxSwapThreshold= 420690000 * 10**_decimals;
180     uint256 public _maxTaxSwap= 420690000 * 10**_decimals;
181 
182     IUniswapV2Router02 private uniswapV2Router;
183     address private uniswapV2Pair;
184     bool private tradingOpen;
185     bool private inSwap = false;
186     bool private swapEnabled = false;
187 
188     event MaxTxAmountUpdated(uint _maxTxAmount);
189     modifier lockTheSwap {
190         inSwap = true;
191         _;
192         inSwap = false;
193     }
194 
195     constructor () {
196 
197         _taxWallet = payable(_msgSender());
198         _balances[_msgSender()] = _tTotal;
199         _isExcludedFromFee[owner()] = true;
200         _isExcludedFromFee[address(this)] = true;
201         _isExcludedFromFee[_taxWallet] = true;
202 
203         emit Transfer(address(0), _msgSender(), _tTotal);
204     }
205 
206     function name() public pure returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public pure returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public pure returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public pure override returns (uint256) {
219         return _tTotal;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         return _balances[account];
224     }
225 
226     function transfer(address recipient, uint256 amount) public override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function allowance(address owner, address spender) public view override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     function approve(address spender, uint256 amount) public override returns (bool) {
236         _approve(_msgSender(), spender, amount);
237         return true;
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
241         _transfer(sender, recipient, amount);
242         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
243         return true;
244     }
245 
246     function _approve(address owner, address spender, uint256 amount) private {
247         require(owner != address(0), "ERC20: approve from the zero address");
248         require(spender != address(0), "ERC20: approve to the zero address");
249         _allowances[owner][spender] = amount;
250         emit Approval(owner, spender, amount);
251     }
252 
253     function _transfer(address from, address to, uint256 amount) private {
254         require(from != address(0), "ERC20: transfer from the zero address");
255         require(to != address(0), "ERC20: transfer to the zero address");
256         require(amount > 0, "Transfer amount must be greater than zero");
257         uint256 taxAmount=0;
258         if (from != owner() && to != owner()) {
259             require(!bots[from] && !bots[to]);
260             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
261 
262             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
263                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
264                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
265 
266                 if (firstBlock + 3  > block.number) {
267                     require(!isContract(to));
268                 }
269                 _buyCount++;
270             }
271 
272             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
273                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
274             }
275 
276             if(to == uniswapV2Pair && from!= address(this) ){
277                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
278             }
279 
280             uint256 contractTokenBalance = balanceOf(address(this));
281             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
282                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
283                 uint256 contractETHBalance = address(this).balance;
284                 if(contractETHBalance > 0) {
285                     sendETHToFee(address(this).balance);
286                 }
287             }
288         }
289 
290         if(taxAmount>0){
291           _balances[address(this)]=_balances[address(this)].add(taxAmount);
292           emit Transfer(from, address(this),taxAmount);
293         }
294         _balances[from]=_balances[from].sub(amount);
295         _balances[to]=_balances[to].add(amount.sub(taxAmount));
296         emit Transfer(from, to, amount.sub(taxAmount));
297     }
298 
299 
300     function min(uint256 a, uint256 b) private pure returns (uint256){
301       return (a>b)?b:a;
302     }
303 
304     function isContract(address account) private view returns (bool) {
305         uint256 size;
306         assembly {
307             size := extcodesize(account)
308         }
309         return size > 0;
310     }
311 
312     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
313         address[] memory path = new address[](2);
314         path[0] = address(this);
315         path[1] = uniswapV2Router.WETH();
316         _approve(address(this), address(uniswapV2Router), tokenAmount);
317         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
318             tokenAmount,
319             0,
320             path,
321             address(this),
322             block.timestamp
323         );
324     }
325 
326     function removeLimits() external onlyOwner{
327         _maxTxAmount = _tTotal;
328         _maxWalletSize=_tTotal;
329         emit MaxTxAmountUpdated(_tTotal);
330     }
331 
332     function sendETHToFee(uint256 amount) private {
333         _taxWallet.transfer(amount);
334     }
335 
336     function addBots(address[] memory bots_) public onlyOwner {
337         for (uint i = 0; i < bots_.length; i++) {
338             bots[bots_[i]] = true;
339         }
340     }
341 
342     function delBots(address[] memory notbot) public onlyOwner {
343       for (uint i = 0; i < notbot.length; i++) {
344           bots[notbot[i]] = false;
345       }
346     }
347 
348     function isBot(address a) public view returns (bool){
349       return bots[a];
350     }
351 
352     function openTrading() external onlyOwner() {
353         require(!tradingOpen,"trading is already open");
354         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
355         _approve(address(this), address(uniswapV2Router), _tTotal);
356         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
357         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
358         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
359         swapEnabled = true;
360         tradingOpen = true;
361         firstBlock = block.number;
362     }
363 
364     receive() external payable {}
365 
366 }