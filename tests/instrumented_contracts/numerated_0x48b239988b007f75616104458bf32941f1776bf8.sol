1 /**
2 Bibble is one of the main characters in the Barbie: Fairytopia series.
3 Bibble is community driven token made by based dev for jeets. 
4 Bibble is here to make autism great again, ticker is $BIBBLE, 1/1 TAX, LP AND OWNERSHIP BURNED
5 
6 Website: http://bibble.vip/
7 Twitter: https://twitter.com/BibbleETH
8 Telegram: @BibblePortal
9 
10 **/
11 
12 // SPDX-License-Identifier: NONE
13 
14 pragma solidity 0.8.21;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract BIBBLE is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = false;
128     address payable private _taxWallet;
129 
130     uint256 private _initialBuyTax=15;
131     uint256 private _initialSellTax=25;
132     uint256 private _finalBuyTax=1;
133     uint256 private _finalSellTax=1;
134     uint256 public _reduceBuyTaxAt=30;
135     uint256 public _reduceSellTaxAt=30;
136     uint256 private _preventSwapBefore=20;
137     uint256 private _buyCount=0;
138 
139     uint8 private constant _decimals = 8;
140     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
141     string private constant _name = unicode"Bibble";
142     string private constant _symbol = unicode"BIBBLE";
143     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
144     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
145     uint256 public _taxSwapThreshold=6000000 * 10**_decimals;
146     uint256 public _maxTaxSwap=6000000 * 10**_decimals;
147 
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
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
163         _taxWallet = payable(_msgSender());
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_taxWallet] = true;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return _balances[account];
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         uint256 taxAmount=0;
224         if (from != owner() && to != owner()) {
225 
226             if (transferDelayEnabled) {
227                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
228                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
229                   _holderLastTransferTimestamp[tx.origin] = block.number;
230                 }
231             }
232 
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236                 _buyCount++;
237             }
238 
239             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
240             if(to == uniswapV2Pair && from!= address(this) ){
241                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
242             }
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
246                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
247                 uint256 contractETHBalance = address(this).balance;
248                 if(contractETHBalance > 0) {
249                     sendETHToFee(address(this).balance);
250                 }
251             }
252         }
253 
254         if(taxAmount>0){
255           _balances[address(this)]=_balances[address(this)].add(taxAmount);
256           emit Transfer(from, address(this),taxAmount);
257         }
258         _balances[from]=_balances[from].sub(amount);
259         _balances[to]=_balances[to].add(amount.sub(taxAmount));
260         emit Transfer(from, to, amount.sub(taxAmount));
261     }
262 
263     function min(uint256 a, uint256 b) private pure returns (uint256){
264       return (a>b)?b:a;
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         if(tokenAmount==0){return;}
269         if(!tradingOpen){return;}
270         address[] memory path = new address[](2);
271         path[0] = address(this);
272         path[1] = uniswapV2Router.WETH();
273         _approve(address(this), address(uniswapV2Router), tokenAmount);
274         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
275             tokenAmount,
276             0,
277             path,
278             address(this),
279             block.timestamp
280         );
281     }
282 
283     function removeLimits() external onlyOwner{
284         _maxTxAmount = _tTotal;
285         _maxWalletSize=_tTotal;
286         transferDelayEnabled=false;
287         _reduceSellTaxAt=20;
288         _reduceBuyTaxAt=20;
289         emit MaxTxAmountUpdated(_tTotal);
290     }
291 
292     function sendETHToFee(uint256 amount) private {
293         _taxWallet.transfer(amount);
294     }
295 
296     function openTrading() external onlyOwner() {
297         require(!tradingOpen,"trading is already open");
298         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
299         _approve(address(this), address(uniswapV2Router), _tTotal);
300         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
301         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
302         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
303         swapEnabled = true;
304         tradingOpen = true;
305     }
306 
307     receive() external payable {}
308 
309     function manualSwap() external {	
310         require(_msgSender()==_taxWallet);	
311         uint256 tokenBalance=balanceOf(address(this));	
312         if(tokenBalance>0){	
313           swapTokensForEth(tokenBalance);	
314         }	
315     }	
316     
317     function manualSend() external {	
318         uint256 ethBalance=address(this).balance;	
319         if(ethBalance>0){	
320           sendETHToFee(ethBalance);	
321         }	
322     }
323     
324     
325 }