1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 Shibo Inu - The Son of Shib
6 
7 Website: https://shiboinu.com
8 
9 Twitter: https://twitter.com/shiboinuerc
10 
11 Telegram: https://t.me/shiboinuofficial                                                                                  
12 
13 */
14 
15 pragma solidity 0.8.20;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120 }
121 
122 contract SHIBO is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) public marketPair;
128     address payable private _taxWallet;
129     uint256 firstBlock;
130 
131     uint256 private _initialBuyTax=25;
132     uint256 private _initialSellTax=25;
133     uint256 private _finalBuyTax=1;
134     uint256 private _finalSellTax=1;
135     uint256 private _reduceBuyTaxAt=25;
136     uint256 private _reduceSellTaxAt=25;
137     uint256 private _preventSwapBefore=40;
138     uint256 private _buyCount=0;
139 
140     uint8 private constant _decimals = 9;
141     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
142     string private constant _name = unicode"Shibo Inu";
143     string private constant _symbol = unicode"SHIBO";
144     uint256 public _maxTxAmount =   10000000 * 10**_decimals;
145     uint256 public _maxWalletSize = 10000000 * 10**_decimals;
146     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
147     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address public uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154 
155     event MaxTxAmountUpdated(uint _maxTxAmount);
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161 
162     constructor () {
163 
164         _taxWallet = payable(_msgSender());
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169         
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return _balances[account];
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function setMarketPair(address addr) public onlyOwner {
221         marketPair[addr] = true;
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
231 
232             if (marketPair[from] && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235 
236                 if (firstBlock + 3  > block.number) {
237                     require(!isContract(to));
238                 }
239                 _buyCount++;
240             }
241 
242             if (!marketPair[to] && ! _isExcludedFromFee[to]) {
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244             }
245 
246             if(marketPair[to] && from!= address(this) ){
247                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && marketPair[to] && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
252                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
253                 uint256 contractETHBalance = address(this).balance;
254                 if(contractETHBalance > 0) {
255                     sendETHToFee(address(this).balance);
256                 }
257             }
258         }
259 
260         if(taxAmount>0){
261           _balances[address(this)]=_balances[address(this)].add(taxAmount);
262           emit Transfer(from, address(this),taxAmount);
263         }
264         _balances[from]=_balances[from].sub(amount);
265         _balances[to]=_balances[to].add(amount.sub(taxAmount));
266         emit Transfer(from, to, amount.sub(taxAmount));
267     }
268 
269 
270     function min(uint256 a, uint256 b) private pure returns (uint256){
271       return (a>b)?b:a;
272     }
273 
274     function isContract(address account) private view returns (bool) {
275         uint256 size;
276         assembly {
277             size := extcodesize(account)
278         }
279         return size > 0;
280     }
281 
282     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = uniswapV2Router.WETH();
286         _approve(address(this), address(uniswapV2Router), tokenAmount);
287         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
288             tokenAmount,
289             0,
290             path,
291             address(this),
292             block.timestamp
293         );
294     }
295 
296     function clearStuckEth() public {
297         require(_msgSender() == _taxWallet);
298         payable(msg.sender).transfer(address(this).balance);
299     }
300 
301     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public {
302         require(_msgSender() == _taxWallet);
303         IERC20(_tokenAddr).transfer(_to, _amount);
304     }
305 
306     function manualSwap() external {
307         require(_msgSender()==_taxWallet);
308         uint256 tokenBalance=balanceOf(address(this));
309         if(tokenBalance>0){
310           swapTokensForEth(tokenBalance);
311         }
312         uint256 ethBalance=address(this).balance;
313         if(ethBalance>0){
314           sendETHToFee(ethBalance);
315         }
316     }
317 
318     function removeLimits() external onlyOwner{
319         _maxTxAmount = _tTotal;
320         _maxWalletSize=_tTotal;
321         emit MaxTxAmountUpdated(_tTotal);
322     }
323 
324     function sendETHToFee(uint256 amount) private {
325         _taxWallet.transfer(amount);
326     }
327 
328     function openTrading() external onlyOwner() {
329         require(!tradingOpen,"trading is already open");
330         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
331         _approve(address(this), address(uniswapV2Router), _tTotal);
332         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
333         marketPair[address(uniswapV2Pair)] = true;
334         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
335         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
336         swapEnabled = true;
337         tradingOpen = true;
338         firstBlock = block.number;
339     }
340 
341     receive() external payable {}
342 }