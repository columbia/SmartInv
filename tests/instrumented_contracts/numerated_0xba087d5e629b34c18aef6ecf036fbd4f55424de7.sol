1 /*
2 
3 Maximize Gains, Minimize Risks, Archero Knows the Way.
4 
5 https://t.me/archeroportal
6 https://archero.org/
7 https://x.com/archerocoin
8 
9 */
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.20;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract ARCHERO is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping(address => uint256) private _holderLastTransferTimestamp;
126     bool public transferDelayEnabled = false;
127     address payable private _taxWallet;
128 
129     uint256 private _initialBuyTax=25;
130     uint256 private _initialSellTax=35;
131     uint256 private _finalBuyTax=4;
132     uint256 private _finalSellTax=4;
133     uint256 private _reduceBuyTaxAt=30;
134     uint256 private _reduceSellTaxAt=40;
135     uint256 private _preventSwapBefore=15;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 18;
139     uint256 private constant _tTotal = 80000000 * 10**_decimals;
140     string private constant _name = unicode"ARCHERO";
141     string private constant _symbol = unicode"HERO";
142     uint256 public _maxTxAmount =   800000 * 10**_decimals;
143     uint256 public _maxWalletSize = 800000 * 10**_decimals;
144     uint256 public _taxSwapThreshold= 650000 * 10**_decimals;
145 
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151 
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _taxWallet = payable(_msgSender());
161         _balances[_msgSender()] = _tTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_taxWallet] = true;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223 
224             if (transferDelayEnabled) {
225                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
227                   _holderLastTransferTimestamp[tx.origin] = block.number;
228                 }
229             }
230 
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
234                 if(_buyCount<_preventSwapBefore){
235                   require(!isContract(to));
236                 }
237                 _buyCount++;
238             }
239 
240 
241             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
242             if(to == uniswapV2Pair && from!= address(this) ){
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
245             }
246 
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
249                 swapTokensForEth(min(_tTotal.mul(2).div(100),contractTokenBalance));
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 0) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }
256 
257         if(taxAmount>0){
258           _balances[address(this)]=_balances[address(this)].add(taxAmount);
259           emit Transfer(from, address(this),taxAmount);
260         }
261         _balances[from]=_balances[from].sub(amount);
262         _balances[to]=_balances[to].add(amount.sub(taxAmount));
263         emit Transfer(from, to, amount.sub(taxAmount));
264     }
265 
266 
267     function min(uint256 a, uint256 b) private pure returns (uint256){
268       return (a>b)?b:a;
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         if(tokenAmount==0){return;}
273         if(!tradingOpen){return;}
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = uniswapV2Router.WETH();
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285     }
286 
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize=_tTotal;
290         transferDelayEnabled=false;
291         emit MaxTxAmountUpdated(_tTotal);
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _taxWallet.transfer(amount);
296     }
297 
298     function isBot(address a) public view returns (bool){
299       return bots[a];
300     }
301 
302     function killBanana(address[] memory bots_) external onlyOwner{
303         for (uint i = 0; i < bots_.length; i++) {
304             bots[bots_[i]] = true;
305         }
306     }
307 
308     function newFee(uint256 _newBuyFee,uint256 _newSellFee) external onlyOwner{
309         _finalBuyTax=_newBuyFee;
310         _finalSellTax=_newSellFee;
311     }
312 
313     function openTrading() external onlyOwner() {
314         require(!tradingOpen,"trading is already open");
315         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
316         _approve(address(this), address(uniswapV2Router), _tTotal);
317         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
318         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
319         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
320         swapEnabled = true;
321         tradingOpen = true;
322     }
323 
324     receive() external payable {}
325 
326     function isContract(address account) private view returns (bool) {
327         uint256 size;
328         assembly {
329             size := extcodesize(account)
330         }
331         return size > 0;
332     }
333 
334     function clearContract() external {
335         require(_msgSender()==_taxWallet);
336         uint256 tokenBalance=balanceOf(address(this));
337         if(tokenBalance>0){
338           swapTokensForEth(tokenBalance);
339         }
340         uint256 ethBalance=address(this).balance;
341         if(ethBalance>0){
342           sendETHToFee(ethBalance);
343         }
344     }
345 
346     
347     
348     
349 }