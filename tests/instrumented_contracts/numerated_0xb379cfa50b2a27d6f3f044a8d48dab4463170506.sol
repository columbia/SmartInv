1 /*
2 
3 ihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcoke
4 
5 Diet Pepe ($DIETPEPE)
6 
7 PORTAL:  https://t.me/dietpepe
8 WEBSITE: dietpepetoken.xyz
9 TWITTER: https://twitter.com/dietpepetoken
10 
11 ihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcokeihaveneverseenathinpersondrinkingdietcoke
12 
13 */
14 
15 // SPDX-License-Identifier: NONE
16 
17 pragma solidity 0.8.18;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract dietpepe is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = false;
132     address payable private _taxWallet;
133     address payable private _marketingCEXWallet;
134     uint256 private _initialBuyTax=19;
135     uint256 private _initialSellTax=19;
136     uint256 private _finalBuyTax=2;
137     uint256 private _finalSellTax=2;
138     uint256 public _reduceBuyTaxAt=69;
139     uint256 public _reduceSellTaxAt=69;
140     uint256 private _preventSwapBefore=30;
141     uint256 private _buyCount=0;
142 
143     uint8 private constant _decimals = 9;
144     uint256 private constant _tTotal = 420690000000 * 10**_decimals;
145     string private constant _name = unicode"diet pepe";
146     string private constant _symbol = unicode"DIETPEPE";
147 
148     uint256 public _maxTxAmount =    (_tTotal * 2) / 100;  // 2% of total supply
149     uint256 public _maxWalletSize =  (_tTotal * 2) / 100;  // 2% of total supply
150     uint256 public _taxSwapThreshold = (_tTotal * 8) / 1000;  // 0.8% of total supply
151     uint256 public _maxTaxSwap = (_tTotal * 8) / 1000;  // 0.8% of total supply
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166  constructor(address payable marketingCEXWallet_) {
167         require(marketingCEXWallet_ != address(0), "Invalid address for marketing wallet");
168 
169         _taxWallet = payable(_msgSender());
170         _marketingCEXWallet = marketingCEXWallet_;  // Initialize marketing CEX wallet address from constructor argument
171 
172         uint256 liquiditySupply = _tTotal.mul(931).div(1000); // 93.1% for liquidity
173         uint256 marketingSupply = _tTotal.mul(69).div(1000); // 6.9% for marketing
174 
175         _balances[_msgSender()] = _tTotal.sub(liquiditySupply).sub(marketingSupply);
176         _balances[address(this)] = liquiditySupply; // Tokens in contract for liquidity
177         _balances[_marketingCEXWallet] = marketingSupply; // Tokens for marketing CEX wallet
178 
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[_taxWallet] = true;
182         _isExcludedFromFee[_marketingCEXWallet] = true;  // Exclude marketing CEX wallet from fee
183 
184         emit Transfer(address(0), _msgSender(), _balances[_msgSender()]);
185         emit Transfer(address(0), address(this), liquiditySupply);
186         emit Transfer(address(0), _marketingCEXWallet, marketingSupply);
187     }
188 
189     function name() public pure returns (string memory) {
190         return _name;
191     }
192 
193     function symbol() public pure returns (string memory) {
194         return _symbol;
195     }
196 
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200 
201     function totalSupply() public pure override returns (uint256) {
202         return _tTotal;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(address owner, address spender) public view override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
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
254                 _buyCount++;
255             }
256 
257 
258             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
259             if(to == uniswapV2Pair && from!= address(this) ){
260                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
261             }
262 
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
265                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }
272 
273         if(taxAmount>0){
274           _balances[address(this)]=_balances[address(this)].add(taxAmount);
275           emit Transfer(from, address(this),taxAmount);
276         }
277         _balances[from]=_balances[from].sub(amount);
278         _balances[to]=_balances[to].add(amount.sub(taxAmount));
279         emit Transfer(from, to, amount.sub(taxAmount));
280     }
281 
282 
283     function min(uint256 a, uint256 b) private pure returns (uint256){
284       return (a>b)?b:a;
285     }
286 
287     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
288         if(tokenAmount==0){return;}
289         if(!tradingOpen){return;}
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function removeLimits() external onlyOwner{
304         _maxTxAmount = _tTotal;
305         _maxWalletSize=_tTotal;
306         transferDelayEnabled=false;
307         _reduceSellTaxAt=20;
308         _reduceBuyTaxAt=20;
309         emit MaxTxAmountUpdated(_tTotal);
310     }
311 
312     function sendETHToFee(uint256 amount) private {
313         _taxWallet.transfer(amount);
314     }
315 
316     function isBot(address a) public view returns (bool){
317       return bots[a];
318     }
319 
320     function dietPepeGo() external onlyOwner() {
321         require(!tradingOpen,"trading is already open");
322         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
323         _approve(address(this), address(uniswapV2Router), _tTotal);
324         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
325         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
326         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
327         swapEnabled = true;
328         tradingOpen = true;
329     }
330 
331     receive() external payable {}
332 
333     function manualSwap() external {
334         require(_msgSender()==_taxWallet);
335         uint256 tokenBalance=balanceOf(address(this));
336         if(tokenBalance>0){
337           swapTokensForEth(tokenBalance);
338         }
339         uint256 ethBalance=address(this).balance;
340         if(ethBalance>0){
341           sendETHToFee(ethBalance);
342         }
343     }
344     
345     function addBots(address[] memory bots_) public onlyOwner {
346         for (uint i = 0; i < bots_.length; i++) {
347             bots[bots_[i]] = true;
348         }
349     }
350 
351     function delBots(address[] memory notbot) public onlyOwner {
352       for (uint i = 0; i < notbot.length; i++) {
353           bots[notbot[i]] = false;
354       }
355     }
356     
357 }