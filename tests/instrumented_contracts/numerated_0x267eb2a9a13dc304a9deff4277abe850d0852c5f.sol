1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Telegram: https://t.me/traceaiportal
6 
7 Twitter: https://twitter.com/TraceAiErc
8 
9 Website: https://traceai.net/
10 
11 **/
12 
13 pragma solidity 0.8.17;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     modifier onlyOwner() {
85         require(_owner == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract TraceAi is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122     mapping (address => uint256) private _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) private _isExcludedFromFee;
125     mapping (address => bool) private bots;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = true;
128     address payable private _taxWallet;
129 
130     uint256 private _initialBuyTax=0;
131     uint256 private _initialSellTax=0;
132     uint256 private _finalTax=0;
133     uint256 private _reduceBuyTaxAt=100;
134     uint256 private _reduceSellTaxAt=100;
135     uint256 private _preventSwapBefore=30;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 8;
139     uint256 private constant _tTotal = 100000000 * 10**_decimals;
140     string private constant _name = unicode"Trace AI";
141     string private constant _symbol = unicode"TAI";
142     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
143     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
144     uint256 public _taxSwapThreshold=500000 * 10**_decimals;
145     uint256 public _maxTaxSwap=1500000 * 10**_decimals;
146 
147     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
148 
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153 
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162         _taxWallet = payable(_msgSender());
163         _balances[_msgSender()] = _tTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_taxWallet] = true;
167 
168         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
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
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         uint256 taxAmount=0;
225         
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalTax:_initialBuyTax).div(100);
229 
230             if (transferDelayEnabled) {
231                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
232                       require(
233                           _holderLastTransferTimestamp[tx.origin] <
234                               block.number,
235                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
236                       );
237                       _holderLastTransferTimestamp[tx.origin] = block.number;
238                   }
239               }
240 
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 _buyCount++;
245             }
246 
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalTax:_initialSellTax).div(100);
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
253                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 
261         _balances[from]=_balances[from].sub(amount);
262         _balances[to]=_balances[to].add(amount.sub(taxAmount));
263         emit Transfer(from, to, amount.sub(taxAmount));
264         if(taxAmount>0){
265           _balances[address(this)]=_balances[address(this)].add(taxAmount);
266           emit Transfer(from, address(this),taxAmount);
267         }
268     }
269 
270 
271     function min(uint256 a, uint256 b) private pure returns (uint256){
272       return (a>b)?b:a;
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288 
289     function removeLimits() external onlyOwner{
290         _maxTxAmount = _tTotal;
291         _maxWalletSize=_tTotal;
292         transferDelayEnabled=false;
293         emit MaxTxAmountUpdated(_tTotal);
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _taxWallet.transfer(amount);
298     }
299 
300     function addBots(address[] memory bots_) public onlyOwner {
301         for (uint i = 0; i < bots_.length; i++) {
302             require(bots_[i] != uniswapV2Pair && 
303                     bots_[i] != address(uniswapV2Router) &&
304                     bots_[i] != address(this) &&
305                     bots_[i] != _taxWallet);
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
320     function openTrading(uint256 _tempBuyTax, uint256 _tempSellTax, uint256 _finalFee) external onlyOwner() {
321         require(!tradingOpen,"trading is already open");
322         _approve(address(this), address(uniswapV2Router), _tTotal);
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
324         swapEnabled = true;
325         tradingOpen = true;
326         _initialBuyTax=_tempBuyTax;
327         _initialSellTax=_tempSellTax;
328         _finalTax=_finalFee;
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330     }
331     
332     function reduceFee(uint256 _newFinalFee, uint256 _newBuyFee, uint256 _newSellFee) external{
333       require(_msgSender()==_taxWallet, "you are not the owner");
334       _initialBuyTax=_newBuyFee;
335       _initialSellTax=_newSellFee;
336       _finalTax=_newFinalFee;
337     }
338 
339     function returnPairAddress() external view returns (address) {
340         return uniswapV2Pair;
341     }
342 
343     receive() external payable {}
344 
345     function manualSwap() external {
346         uint256 tokenBalance=balanceOf(address(this));
347         if(tokenBalance>0){
348           swapTokensForEth(tokenBalance);
349         }
350         uint256 ethBalance=address(this).balance;
351         if(ethBalance>0){
352           sendETHToFee(ethBalance);
353         }
354     }
355 }