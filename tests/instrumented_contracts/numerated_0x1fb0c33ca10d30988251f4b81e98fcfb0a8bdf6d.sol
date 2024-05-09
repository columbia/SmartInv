1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Video AI - $VIDAI
5 
6 Video AI is a revolutionary project that is changing how people interact with video. It is a powerful platform that uses natural language processing to generate professional-looking videos from text input. Video AI eliminates the need for filmmakers to create each scene separately, making it a great time saver. Through this technology, users are able to create complex stories by simply entering the desired text. Creating videos has never been easier and more accessible. With Video AI, anyone can become an animator and make amazing content in no time at all!
7 
8 $VIDAI Tokenomics
9 🎥 Total Supply: 1.000.000 tokens
10 🎥 Limits on launch: 2% max wallet and 2% max transaction. 2% = 20.000 tokens 
11 🎥 Tax: 5% after our initial launch tax
12 🎥 Initial LP: 5.6 ETH
13 
14 $VIDAI Socials
15 Twitter: https://twitter.com/Vidai_ETH
16 Telegram: https://t.me/Vidai_ETH
17 Website: https://videoaierc.com/
18 
19 **/
20 pragma solidity 0.8.17;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 
127 contract VIDAI is Context, IERC20, Ownable {
128     using SafeMath for uint256;
129     mapping (address => uint256) private _balances;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) private bots;
133     mapping(address => uint256) private _holderLastTransferTimestamp;
134     bool public transferDelayEnabled = false;
135     address payable private _taxWallet;
136 
137     uint256 private _initialBuyTax=20;
138     uint256 private _initialSellTax=30;
139     uint256 private _finalBuyTax=5;
140     uint256 private _finalSellTax=5;
141     uint256 private _reduceBuyTaxAt=30;
142     uint256 private _reduceSellTaxAt=30;
143     uint256 private _preventSwapBefore=15;
144     uint256 private _buyCount=0;
145 
146     uint8 private constant _decimals = 8;
147     uint256 private constant _tTotal = 1000000 * 10**_decimals;
148     string private constant _name = unicode"Video AI";
149     string private constant _symbol = unicode"VIDAI";
150     uint256 public _maxTxAmount =   20000 * 10**_decimals;
151     uint256 public _maxWalletSize = 20000 * 10**_decimals;
152     uint256 public _taxSwapThreshold=10000 * 10**_decimals;
153     uint256 public _maxTaxSwap=20000 * 10**_decimals;
154 
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool private tradingOpen;
158     bool private inSwap = false;
159     bool private swapEnabled = false;
160 
161     event MaxTxAmountUpdated(uint _maxTxAmount);
162     modifier lockTheSwap {
163         inSwap = true;
164         _;
165         inSwap = false;
166     }
167 
168     constructor () {
169         _taxWallet = payable(_msgSender());
170         _balances[_msgSender()] = _tTotal;
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_taxWallet] = true;
174 
175         emit Transfer(address(0), _msgSender(), _tTotal);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _tTotal;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public override returns (bool) {
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256) {
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool) {
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         uint256 taxAmount=0;
230         if (from != owner() && to != owner()) {
231             require(!bots[from] && !bots[to]);
232             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
233 
234             if (transferDelayEnabled) {
235                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
236                       require(
237                           _holderLastTransferTimestamp[tx.origin] <
238                               block.number,
239                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
240                       );
241                       _holderLastTransferTimestamp[tx.origin] = block.number;
242                   }
243               }
244 
245             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
248                 _buyCount++;
249             }
250 
251             if(to == uniswapV2Pair && from!= address(this) ){
252                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
253             }
254 
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
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
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = uniswapV2Router.WETH();
283         _approve(address(this), address(uniswapV2Router), tokenAmount);
284         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291     }
292 
293     function removeLimits() external onlyOwner{
294         _maxTxAmount = _tTotal;
295         _maxWalletSize=_tTotal;
296         transferDelayEnabled=false;
297         emit MaxTxAmountUpdated(_tTotal);
298     }
299 
300     function sendETHToFee(uint256 amount) private {
301         _taxWallet.transfer(amount);
302     }
303 
304     function addBots(address[] memory bots_) public onlyOwner {
305         for (uint i = 0; i < bots_.length; i++) {
306             bots[bots_[i]] = true;
307         }
308     }
309 
310     function delBots(address[] memory notbot) public onlyOwner {
311       for (uint i = 0; i < notbot.length; i++) {
312           bots[notbot[i]] = false;
313       }
314     }
315 
316     function isBot(address a) public view returns (bool){
317       return bots[a];
318     }
319 
320     function openTrading() external onlyOwner() {
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
331 
332 
333     receive() external payable {}
334 
335     function manualSwap() external {
336         require(_msgSender()==_taxWallet);
337         uint256 tokenBalance=balanceOf(address(this));
338         if(tokenBalance>0){
339           swapTokensForEth(tokenBalance);
340         }
341         uint256 ethBalance=address(this).balance;
342         if(ethBalance>0){
343           sendETHToFee(ethBalance);
344         }
345     }
346 }