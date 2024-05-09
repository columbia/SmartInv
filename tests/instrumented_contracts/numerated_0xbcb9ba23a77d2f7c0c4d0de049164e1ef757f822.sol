1 // SPDX-License-Identifier: MIT
2 /**
3 
4 
5 the best stock of all time
6 
7 tesla
8 
9 https://t.me/TESLATOKENETH
10 
11 
12 **/
13 
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
122 contract Tesla is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping(address => uint256) private _holderLastTransferTimestamp;
129     bool public transferDelayEnabled = true;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=15;
133     uint256 private _initialSellTax=25;
134     uint256 private _finalBuyTax=0;
135     uint256 private _finalSellTax=0;
136     uint256 private _reduceBuyTaxAt=15;
137     uint256 private _reduceSellTaxAt=20;
138     uint256 private _preventSwapBefore=20;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 1000000 * 10**_decimals;
143     string private constant _name = unicode"Tesla";
144     string private constant _symbol = unicode"Tesla";
145     uint256 public _maxTxAmount = 20000 * 10**_decimals;
146     uint256 public _maxWalletSize = 20000 * 10**_decimals;
147     uint256 public _taxSwapThreshold= 20000 * 10**_decimals;
148     uint256 public _maxTaxSwap= 20000 * 10**_decimals;
149 
150     IUniswapV2Router02 private uniswapV2Router;
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
225         if (from != owner() && to != owner()) {
226             require(!bots[from] && !bots[to]);
227             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
228 
229             if (transferDelayEnabled) {
230                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
231                       require(
232                           _holderLastTransferTimestamp[tx.origin] <
233                               block.number,
234                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
235                       );
236                       _holderLastTransferTimestamp[tx.origin] = block.number;
237                   }
238               }
239 
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
243                 _buyCount++;
244             }
245 
246             if(to == uniswapV2Pair && from!= address(this) ){
247                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
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
274     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = uniswapV2Router.WETH();
278         _approve(address(this), address(uniswapV2Router), tokenAmount);
279         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
280             tokenAmount,
281             0,
282             path,
283             address(this),
284             block.timestamp
285         );
286     }
287 
288     function removeLimits() external onlyOwner{
289         _maxTxAmount = _tTotal;
290         _maxWalletSize=_tTotal;
291         transferDelayEnabled=false;
292         emit MaxTxAmountUpdated(_tTotal);
293     }
294 
295     function sendETHToFee(uint256 amount) private {
296         _taxWallet.transfer(amount);
297     }
298 
299     function addBots(address[] memory bots_) public onlyOwner {
300         for (uint i = 0; i < bots_.length; i++) {
301             bots[bots_[i]] = true;
302         }
303     }
304 
305     function delBots(address[] memory notbot) public onlyOwner {
306       for (uint i = 0; i < notbot.length; i++) {
307           bots[notbot[i]] = false;
308       }
309     }
310 
311     function isBot(address a) public view returns (bool){
312       return bots[a];
313     }
314 
315     function openTrading() external onlyOwner() {
316         require(!tradingOpen,"trading is already open");
317         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
318         _approve(address(this), address(uniswapV2Router), _tTotal);
319         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
320         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
321         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
322         swapEnabled = true;
323         tradingOpen = true;
324     }
325 
326     
327     function reduceFee(uint256 _newFee) external{
328       require(_msgSender()==_taxWallet);
329       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
330       _finalBuyTax=_newFee;
331       _finalSellTax=_newFee;
332     }
333 
334     receive() external payable {}
335 
336     function manualSwap() external {
337         require(_msgSender()==_taxWallet);
338         uint256 tokenBalance=balanceOf(address(this));
339         if(tokenBalance>0){
340           swapTokensForEth(tokenBalance);
341         }
342         uint256 ethBalance=address(this).balance;
343         if(ethBalance>0){
344           sendETHToFee(ethBalance);
345         }
346     }
347 }