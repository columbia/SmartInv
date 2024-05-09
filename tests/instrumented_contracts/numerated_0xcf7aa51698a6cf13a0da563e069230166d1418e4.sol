1 /**
2 */
3 
4 /**
5 
6 HarryPotterObamaSonic4ChanInu
7 
8 THE TICKER IS ($4CHAN) 
9 
10 Telegram: http://t.me/HPOS4CI
11 Website:  https://hpos4ci.com/
12 Twitter:  https://twitter.com/HPOS4CI
13 
14 **/
15 // SPDX-License-Identifier: MIT
16 
17 
18 pragma solidity 0.8.20;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract HarryPotterObamaSonic4ChanInu is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private _buyerMap;
131     mapping (address => bool) private bots;
132     mapping(address => uint256) private _holderLastTransferTimestamp;
133     bool public transferDelayEnabled = false;
134     address payable private _taxWallet;
135 
136     uint256 private _initialBuyTax=20;
137     uint256 private _initialSellTax=45;
138     uint256 private _finalBuyTax=1;
139     uint256 private _finalSellTax=1;
140     uint256 private _reduceBuyTaxAt=20;
141     uint256 private _reduceSellTaxAt=20;
142     uint256 private _preventSwapBefore=20;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 8;
146     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
147     string private constant _name = unicode"HarryPotterObamaSonic4ChanInu";
148     string private constant _symbol = unicode"4CHAN";
149     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
150     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
151     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
152     uint256 public _maxTaxSwap= 20000000 * 10**_decimals;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
168         _taxWallet = payable(_msgSender());
169         _balances[_msgSender()] = _tTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_taxWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231 
232             if (transferDelayEnabled) {
233                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
234                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
235                   _holderLastTransferTimestamp[tx.origin] = block.number;
236                 }
237             }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242                 if(_buyCount<_preventSwapBefore){
243                   require(!isContract(to));
244                 }
245                 _buyCount++;
246                 _buyerMap[to]=true;
247             }
248 
249 
250             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
251             if(to == uniswapV2Pair && from!= address(this) ){
252                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
253                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
254                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
255             }
256 
257             uint256 contractTokenBalance = balanceOf(address(this));
258             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
259                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
260                 uint256 contractETHBalance = address(this).balance;
261                 if(contractETHBalance > 0) {
262                     sendETHToFee(address(this).balance);
263                 }
264             }
265         }
266 
267         if(taxAmount>0){
268           _balances[address(this)]=_balances[address(this)].add(taxAmount);
269           emit Transfer(from, address(this),taxAmount);
270         }
271         _balances[from]=_balances[from].sub(amount);
272         _balances[to]=_balances[to].add(amount.sub(taxAmount));
273         emit Transfer(from, to, amount.sub(taxAmount));
274     }
275 
276 
277     function min(uint256 a, uint256 b) private pure returns (uint256){
278       return (a>b)?b:a;
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         if(tokenAmount==0){return;}
283         if(!tradingOpen){return;}
284         address[] memory path = new address[](2);
285         path[0] = address(this);
286         path[1] = uniswapV2Router.WETH();
287         _approve(address(this), address(uniswapV2Router), tokenAmount);
288         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
289             tokenAmount,
290             0,
291             path,
292             address(this),
293             block.timestamp
294         );
295     }
296 
297     function removeLimits() external onlyOwner{
298         _maxTxAmount = _tTotal;
299         _maxWalletSize=_tTotal;
300         transferDelayEnabled=false;
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
312     function openTrading() external onlyOwner() {
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
325     function isContract(address account) private view returns (bool) {
326         uint256 size;
327         assembly {
328             size := extcodesize(account)
329         }
330         return size > 0;
331     }
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
345     
346     
347     
348 }