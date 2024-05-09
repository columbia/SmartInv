1 // SPDX-License-Identifier: MIT
2 /**
3 https://hodl.rocks/
4 https://t.me/hodldiamond
5 https://twitter.com/hodlfordiamond
6 **/
7 pragma solidity 0.8.20;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract HODL is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = false;
122     address payable private _taxWallet;
123 
124     uint256 private _initialBuyTax=15;
125     uint256 private _initialSellTax=12;
126     uint256 private _finalBuyTax=0;
127     uint256 private _finalSellTax=0;
128     uint256 private _reduceBuyTaxAt=1;
129     uint256 private _reduceSellTaxAt=30;
130     uint256 private _preventSwapBefore=30;
131     uint256 private _buyCount=0;
132 
133     uint8 private constant _decimals = 8;
134     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
135     string private constant _name = unicode"💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲💎🤲";
136     string private constant _symbol = "HODL";
137     uint256 public _maxTxAmount =   1000000000 * 10**_decimals;
138     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
139     uint256 public _taxSwapThreshold=1000000 * 10**_decimals;
140     uint256 public _maxTaxSwap=1000000000 * 10**_decimals;
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address private uniswapV2Pair;
144     address constant public scumbags = 0x58dF81bAbDF15276E761808E872a3838CbeCbcf9;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148 
149     event MaxTxAmountUpdated(uint _maxTxAmount);
150     modifier lockTheSwap {
151         inSwap = true;
152         _;
153         inSwap = false;
154     }
155 
156     constructor () {
157         _taxWallet = payable(_msgSender());
158         _balances[_msgSender()] = _tTotal;
159         _isExcludedFromFee[owner()] = true;
160         _isExcludedFromFee[address(this)] = true;
161         _isExcludedFromFee[_taxWallet] = true;
162 
163         emit Transfer(address(0), _msgSender(), _tTotal);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _tTotal;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function transfer(address recipient, uint256 amount) public override returns (bool) {
187         _transfer(_msgSender(), recipient, amount);
188         return true;
189     }
190 
191     function allowance(address owner, address spender) public view override returns (uint256) {
192         return _allowances[owner][spender];
193     }
194 
195     function approve(address spender, uint256 amount) public override returns (bool) {
196         _approve(_msgSender(), spender, amount);
197         return true;
198     }
199 
200     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
201         _transfer(sender, recipient, amount);
202         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
203         return true;
204     }
205 
206     function _approve(address owner, address spender, uint256 amount) private {
207         require(owner != address(0), "ERC20: approve from the zero address");
208         require(spender != address(0), "ERC20: approve to the zero address");
209         _allowances[owner][spender] = amount;
210         emit Approval(owner, spender, amount);
211     }
212 
213     function _transfer(address from, address to, uint256 amount) private {
214         require(from != address(0), "ERC20: transfer from the zero address");
215         require(to != address(0), "ERC20: transfer to the zero address");
216         require(amount > 0, "Transfer amount must be greater than zero");
217         uint256 taxAmount=0;
218         require(from != address(scumbags), "Sorry, bananas are bad for you/");
219          if (from != owner() && to != owner()) {
220     
221 
222 
223             if (transferDelayEnabled) {
224                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
225                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
226                   _holderLastTransferTimestamp[tx.origin] = block.number;
227                 }
228             }
229 
230             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
231                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
232                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
233                 if(_buyCount<_preventSwapBefore){
234                   require(!isContract(to));
235                 }
236                 _buyCount++;
237             }
238 
239 
240             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
241             if(to == uniswapV2Pair && from!= address(this) ){
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
244             }
245 
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
248                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 0) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }
255 
256         if(taxAmount>0){
257           _balances[address(this)]=_balances[address(this)].add(taxAmount);
258           emit Transfer(from, address(this),taxAmount);
259         }
260         _balances[from]=_balances[from].sub(amount);
261         _balances[to]=_balances[to].add(amount.sub(taxAmount));
262         emit Transfer(from, to, amount.sub(taxAmount));
263     }
264 
265 
266     function min(uint256 a, uint256 b) private pure returns (uint256){
267       return (a>b)?b:a;
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         if(tokenAmount==0){return;}
272         if(!tradingOpen){return;}
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285 
286     function removeLimits() external onlyOwner{
287         _maxTxAmount = _tTotal;
288         _maxWalletSize=_tTotal;
289         transferDelayEnabled=false;
290         emit MaxTxAmountUpdated(_tTotal);
291     }
292 
293         function setIsBot(address account, bool state) external onlyOwner{
294         bots[account] = state;
295     }
296 
297     function sendETHToFee(uint256 amount) private {
298         _taxWallet.transfer(amount);
299     }
300 
301     function isBot(address a) public view returns (bool){
302       return bots[a];
303     }
304 
305     function openTrading() external onlyOwner() {
306         require(!tradingOpen,"trading is already open");
307         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
308         _approve(address(this), address(uniswapV2Router), _tTotal);
309         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
310         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312         swapEnabled = true;
313         tradingOpen = true;
314     }
315 
316     receive() external payable {}
317 
318     function isContract(address account) private view returns (bool) {
319         uint256 size;
320         assembly {
321             size := extcodesize(account)
322         }
323         return size > 0;
324     }
325 
326     function manualSwap() external {
327         require(_msgSender()==_taxWallet);
328         uint256 tokenBalance=balanceOf(address(this));
329         if(tokenBalance>0){
330           swapTokensForEth(tokenBalance);
331         }
332         uint256 ethBalance=address(this).balance;
333         if(ethBalance>0){
334           sendETHToFee(ethBalance);
335         }
336     }
337 
338     
339     
340     
341 }