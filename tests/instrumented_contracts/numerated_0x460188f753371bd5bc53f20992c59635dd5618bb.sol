1 /*
2 
3 elfbarsarecoolright?
4 
5 Elfbar ($ELFBAR)
6 
7 PORTAL:  https://t.me/ELFBARonETH
8 WEBSITE: https://elfbaroneth.xyz/
9 TWITTER: https://twitter.com/elfbaroneth
10 
11 elfbarsarecoolright
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
124 contract elfbar is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = false;
132     address payable private _taxWallet;
133     uint256 private _initialBuyTax=25;
134     uint256 private _initialSellTax=25;
135     uint256 private _finalBuyTax=1;
136     uint256 private _finalSellTax=1;
137     uint256 public _reduceBuyTaxAt=69;
138     uint256 public _reduceSellTaxAt=69;
139     uint256 private _preventSwapBefore=20;
140     uint256 private _buyCount=0;
141 
142     uint8 private constant _decimals = 9;
143     uint256 private constant _tTotal = 69000000000 * 10**_decimals;  // Changed total supply to 69 billion
144     string private constant _name = unicode"ELFBAR";
145     string private constant _symbol = unicode"ELFBAR";
146 
147     uint256 public _maxTxAmount =    (_tTotal * 2) / 100;  // 2% of total supply
148     uint256 public _maxWalletSize =  (_tTotal * 2) / 100;  // 2% of total supply
149     uint256 public _taxSwapThreshold = (_tTotal * 8) / 1000;  // 0.8% of total supply
150     uint256 public _maxTaxSwap = (_tTotal * 8) / 1000;  // 0.8% of total supply
151 
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = false;
157 
158     event MaxTxAmountUpdated(uint _maxTxAmount);
159     modifier lockTheSwap {
160         inSwap = true;
161         _;
162         inSwap = false;
163     }
164 
165   constructor() { 
166         _taxWallet = payable(_msgSender());
167 
168         uint256 liquiditySupply = _tTotal;
169 
170         _balances[_msgSender()] = 0;  
171         _balances[address(this)] = liquiditySupply;
172 
173         _isExcludedFromFee[owner()] = true;
174         _isExcludedFromFee[address(this)] = true;
175         _isExcludedFromFee[_taxWallet] = true;
176 
177         emit Transfer(address(0), _msgSender(), _balances[_msgSender()]);
178         emit Transfer(address(0), address(this), liquiditySupply);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         uint256 taxAmount=0;
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to]);
235 
236             if (transferDelayEnabled) {
237                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
238                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
239                   _holderLastTransferTimestamp[tx.origin] = block.number;
240                 }
241             }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249 
250             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
251             if(to == uniswapV2Pair && from!= address(this) ){
252                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
253             }
254 
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
257                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 0) {
260                     sendETHToFee(address(this).balance);
261                 }
262             }
263         }
264 
265         if(taxAmount>0){
266           _balances[address(this)]=_balances[address(this)].add(taxAmount);
267           emit Transfer(from, address(this),taxAmount);
268         }
269         _balances[from]=_balances[from].sub(amount);
270         _balances[to]=_balances[to].add(amount.sub(taxAmount));
271         emit Transfer(from, to, amount.sub(taxAmount));
272     }
273 
274 
275     function min(uint256 a, uint256 b) private pure returns (uint256){
276       return (a>b)?b:a;
277     }
278 
279     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
280         if(tokenAmount==0){return;}
281         if(!tradingOpen){return;}
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294 
295     function removeLimits() external onlyOwner{
296         _maxTxAmount = _tTotal;
297         _maxWalletSize=_tTotal;
298         transferDelayEnabled=false;
299         _reduceSellTaxAt=10;
300         _reduceBuyTaxAt=10;
301         emit MaxTxAmountUpdated(_tTotal);
302     }
303 
304     function sendETHToFee(uint256 amount) private {
305         _taxWallet.transfer(amount);
306     }
307 
308     function isBot(address a) public view returns (bool){
309       return bots[a];
310     }
311 
312     function elfbarGo() external onlyOwner() {
313         require(!tradingOpen,"trading is already open");
314         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315         _approve(address(this), address(uniswapV2Router), _tTotal);
316         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
317         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
318         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
319         swapEnabled = true;
320         tradingOpen = true;
321     }
322 
323     receive() external payable {}
324 
325     function manualSwap() external {
326         require(_msgSender()==_taxWallet);
327         uint256 tokenBalance=balanceOf(address(this));
328         if(tokenBalance>0){
329           swapTokensForEth(tokenBalance);
330         }
331         uint256 ethBalance=address(this).balance;
332         if(ethBalance>0){
333           sendETHToFee(ethBalance);
334         }
335     }
336     function setBuySellTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner() {
337         _initialBuyTax = newBuyTax;
338         _initialSellTax = newSellTax;
339     }
340 
341     function setMaxWalletSize(uint256 newMaxWalletSize) external onlyOwner() {
342         _maxWalletSize = newMaxWalletSize;
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