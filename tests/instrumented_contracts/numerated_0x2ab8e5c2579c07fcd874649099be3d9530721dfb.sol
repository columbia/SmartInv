1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Telegram: https://t.me/twiseai
6 
7 Twitter: https://twitter.com/TwiseAI
8 
9 Website: https://thetwiseproject.com/
10 
11 whitepaper: https://thetwiseproject.com/Twise_whitepaper.pdf
12 
13 **/
14 
15 pragma solidity 0.8.17;
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
122 contract TwiseAi is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping(address => uint256) private _holderLastTransferTimestamp;
129     bool public transferDelayEnabled = true;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=0;
133     uint256 private _initialSellTax=0;
134     uint256 private _finalTax=0;
135     uint256 private _reduceBuyTaxAt=300;
136     uint256 private _reduceSellTaxAt=300;
137     uint256 private _preventSwapBefore=30;
138     uint256 private _buyCount=0;
139 
140     uint8 private constant _decimals = 8;
141     uint256 private constant _tTotal = 100000000 * 10**_decimals;
142     string private constant _name = unicode"Twise AI";
143     string private constant _symbol = unicode"TWAI";
144     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
145     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
146     uint256 public _taxSwapThreshold=500000 * 10**_decimals;
147     uint256 public _maxTaxSwap=1500000 * 10**_decimals;
148 
149     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
150 
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169 
170         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
171 
172         emit Transfer(address(0), _msgSender(), _tTotal);
173     }
174 
175     function name() public pure returns (string memory) {
176         return _name;
177     }
178 
179     function symbol() public pure returns (string memory) {
180         return _symbol;
181     }
182 
183     function decimals() public pure returns (uint8) {
184         return _decimals;
185     }
186 
187     function totalSupply() public pure override returns (uint256) {
188         return _tTotal;
189     }
190 
191     function balanceOf(address account) public view override returns (uint256) {
192         return _balances[account];
193     }
194 
195     function transfer(address recipient, uint256 amount) public override returns (bool) {
196         _transfer(_msgSender(), recipient, amount);
197         return true;
198     }
199 
200     function allowance(address owner, address spender) public view override returns (uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount) public override returns (bool) {
205         _approve(_msgSender(), spender, amount);
206         return true;
207     }
208 
209     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
210         _transfer(sender, recipient, amount);
211         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
212         return true;
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226         uint256 taxAmount=0;
227         
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalTax:_initialBuyTax).div(100);
231 
232             if (transferDelayEnabled) {
233                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
234                       require(
235                           _holderLastTransferTimestamp[tx.origin] <
236                               block.number,
237                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
238                       );
239                       _holderLastTransferTimestamp[tx.origin] = block.number;
240                   }
241               }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249             if(to == uniswapV2Pair && from!= address(this) ){
250                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalTax:_initialSellTax).div(100);
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
258                     sendETHToFee(address(this).balance);
259                 }
260             }
261         }
262 
263         _balances[from]=_balances[from].sub(amount);
264         _balances[to]=_balances[to].add(amount.sub(taxAmount));
265         emit Transfer(from, to, amount.sub(taxAmount));
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270     }
271 
272 
273     function min(uint256 a, uint256 b) private pure returns (uint256){
274       return (a>b)?b:a;
275     }
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290 
291     function removeLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize=_tTotal;
294         transferDelayEnabled=false;
295         emit MaxTxAmountUpdated(_tTotal);
296     }
297 
298     function sendETHToFee(uint256 amount) private {
299         _taxWallet.transfer(amount);
300     }
301 
302     function addBots(address[] memory bots_) public onlyOwner {
303         for (uint i = 0; i < bots_.length; i++) {
304             require(bots_[i] != uniswapV2Pair && 
305                     bots_[i] != address(uniswapV2Router) &&
306                     bots_[i] != address(this) &&
307                     bots_[i] != _taxWallet);
308             bots[bots_[i]] = true;
309         }
310     }
311 
312     function delBots(address[] memory notbot) public onlyOwner {
313       for (uint i = 0; i < notbot.length; i++) {
314           bots[notbot[i]] = false;
315       }
316     }
317 
318     function isBot(address a) public view returns (bool){
319       return bots[a];
320     }
321 
322     function openTrading(uint256 _tempBuyTax, uint256 _tempSellTax, uint256 _finalFee) external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         _approve(address(this), address(uniswapV2Router), _tTotal);
325         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
326         swapEnabled = true;
327         tradingOpen = true;
328         _initialBuyTax=_tempBuyTax;
329         _initialSellTax=_tempSellTax;
330         _finalTax=_finalFee;
331         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
332     }
333     
334     function reduceFee(uint256 _newFinalFee, uint256 _newBuyFee, uint256 _newSellFee) external{
335       require(_msgSender()==owner(), "you are not the owner");
336       _initialBuyTax=_newBuyFee;
337       _initialSellTax=_newSellFee;
338       _finalTax=_newFinalFee;
339     }
340 
341     function returnPairAddress() external view returns (address) {
342         return uniswapV2Pair;
343     }
344 
345     receive() external payable {}
346 
347     function manualSwap() external {
348         uint256 tokenBalance=balanceOf(address(this));
349         if(tokenBalance>0){
350           swapTokensForEth(tokenBalance);
351         }
352         uint256 ethBalance=address(this).balance;
353         if(ethBalance>0){
354           sendETHToFee(ethBalance);
355         }
356     }
357 }