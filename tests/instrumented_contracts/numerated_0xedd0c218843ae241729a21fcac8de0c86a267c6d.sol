1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5      _____                      ___           ___     
6     /  /::\       ___          /__/\         /  /\    
7    /  /:/\:\     /  /\        |  |::\       /  /::\   
8   /  /:/  \:\   /  /:/        |  |:|:\     /  /:/\:\  
9  /__/:/ \__\:| /__/::\      __|__|:|\:\   /  /:/~/::\ 
10  \  \:\ /  /:/ \__\/\:\__  /__/::::| \:\ /__/:/ /:/\:\
11   \  \:\  /:/     \  \:\/\ \  \:\~~\__\/ \  \:\/:/__\/
12    \  \:\/:/       \__\::/  \  \:\        \  \::/     
13     \  \::/        /__/:/    \  \:\        \  \:\     
14      \__\/         \__\/      \  \:\        \  \:\    
15                                \__\/         \__\/    
16 
17 Meet Dima, the father of Ethereum's creator: Vitalik Buterin. 
18 
19 */
20 
21 // Website: https://dimatoken.com
22 // Telegram: https://t.me/dima_token
23 // Twitter: https://twitter.com/dimatoken
24 
25 pragma solidity 0.8.20;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         return c;
78     }
79 
80 }
81 
82 
83 contract Ownable is Context {
84     address private _owner;
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     modifier onlyOwner() {
98         require(_owner == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     function renounceOwnership() public virtual onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107 }
108 
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132 }
133 
134 
135 contract Dima is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowances;
139     mapping (address => bool) private _isExcludedFromFee;
140     mapping (address => bool) private bots;
141     mapping(address => uint256) private _holderLastTransferTimestamp;
142     bool public transferDelayEnabled = false;
143     address payable private _taxWallet;
144 
145     uint256 private _initialBuyTax=20;
146     uint256 private _initialSellTax=20;
147     uint256 private _finalBuyTax=1;
148     uint256 private _finalSellTax=1;
149     uint256 private _reduceBuyTaxAt=20;
150     uint256 private _reduceSellTaxAt=20;
151     uint256 private _preventSwapBefore=30;
152     uint256 private _buyCount=0;
153 
154     uint8 private constant _decimals = 8;
155     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
156     string private constant _name = unicode"Dima";
157     string private constant _symbol = unicode"DIMA";
158     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
159     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
160     uint256 public _taxSwapThreshold=0 * 10**_decimals;
161     uint256 public _maxTaxSwap=3365520000000 * 10**_decimals;
162 
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168 
169     event MaxTxAmountUpdated(uint _maxTxAmount);
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175 
176 
177     constructor () {
178         _taxWallet = payable(_msgSender());
179         _balances[_msgSender()] = _tTotal;
180         _isExcludedFromFee[owner()] = true;
181         _isExcludedFromFee[address(this)] = true;
182         _isExcludedFromFee[_taxWallet] = true;
183 
184         emit Transfer(address(0), _msgSender(), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203 
204     function balanceOf(address account) public view override returns (uint256) {
205         return _balances[account];
206     }
207 
208     function transfer(address recipient, uint256 amount) public override returns (bool) {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212 
213     function allowance(address owner, address spender) public view override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240         uint256 taxAmount=0;
241         if (from != owner() && to != owner()) {
242             require(!bots[from] && !bots[to]);
243 
244             if (transferDelayEnabled) {
245                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
246                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
247                   _holderLastTransferTimestamp[tx.origin] = block.number;
248                 }
249             }
250 
251             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
252                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
253                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
254                 if(_buyCount<_preventSwapBefore){
255                   require(!isContract(to));
256                 }
257                 _buyCount++;
258             }
259 
260 
261             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
262             if(to == uniswapV2Pair && from!= address(this) ){
263                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
264                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
265             }
266 
267             uint256 contractTokenBalance = balanceOf(address(this));
268             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
269                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
270                 uint256 contractETHBalance = address(this).balance;
271                 if(contractETHBalance > 0) {
272                     sendETHToFee(address(this).balance);
273                 }
274             }
275         }
276 
277         if(taxAmount>0){
278           _balances[address(this)]=_balances[address(this)].add(taxAmount);
279           emit Transfer(from, address(this),taxAmount);
280         }
281         _balances[from]=_balances[from].sub(amount);
282         _balances[to]=_balances[to].add(amount.sub(taxAmount));
283         emit Transfer(from, to, amount.sub(taxAmount));
284     }
285 
286 
287     function min(uint256 a, uint256 b) private pure returns (uint256){
288       return (a>b)?b:a;
289     }
290 
291     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
292         if(tokenAmount==0){return;}
293         if(!tradingOpen){return;}
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = uniswapV2Router.WETH();
297         _approve(address(this), address(uniswapV2Router), tokenAmount);
298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp
304         );
305     }
306 
307     function removeLimits() external onlyOwner{
308         _maxTxAmount = _tTotal;
309         _maxWalletSize=_tTotal;
310         transferDelayEnabled=false;
311         emit MaxTxAmountUpdated(_tTotal);
312     }
313 
314     function sendETHToFee(uint256 amount) private {
315         _taxWallet.transfer(amount);
316     }
317 
318     function isBot(address a) public view returns (bool){
319       return bots[a];
320     }
321 
322     function openTrading() external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         _approve(address(this), address(uniswapV2Router), _tTotal);
326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
328         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
329         swapEnabled = true;
330         tradingOpen = true;
331     }
332 
333 
334     receive() external payable {}
335 
336     function isContract(address account) private view returns (bool) {
337         uint256 size;
338         assembly {
339             size := extcodesize(account)
340         }
341         return size > 0;
342     }
343 
344     function manualSwap() external {
345         require(_msgSender()==_taxWallet);
346         uint256 tokenBalance=balanceOf(address(this));
347         if(tokenBalance>0){
348           swapTokensForEth(tokenBalance);
349         }
350         uint256 ethBalance=address(this).balance;
351         if(ethBalance>0){
352           sendETHToFee(ethBalance);
353         }
354     }
355 
356     
357     
358     
359 }