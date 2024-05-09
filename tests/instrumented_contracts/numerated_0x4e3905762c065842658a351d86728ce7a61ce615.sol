1 // SPDX-License-Identifier: MIT
2 /**
3 
4 🪬 Oracle AI - Empowering Creators With AI Technology
5 
6 https://t.me/oracleaierc
7 https://twitter.com/oracleaierc
8 https://www.oracle-ai.cc
9 Bot - @Theoracleaibot
10 
11 **/
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
119 contract ORACLEAI is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private _buyerMap;
125     mapping (address => bool) private bots;
126     mapping(address => uint256) private _holderLastTransferTimestamp;
127     bool public transferDelayEnabled = false;
128     address payable private _taxWallet;
129 
130     uint256 private _initialBuyTax=20;
131     uint256 private _initialSellTax=35;
132     uint256 private _finalBuyTax=5;
133     uint256 private _finalSellTax=5;
134     uint256 private _reduceBuyTaxAt=20;
135     uint256 private _reduceSellTaxAt=20;
136     uint256 private _preventSwapBefore=20;
137     uint256 private _buyCount=0;
138 
139     uint8 private constant _decimals = 8;
140     uint256 private constant _tTotal = 4000000 * 10**_decimals;
141     string private constant _name = unicode"ORACLE AI";
142     string private constant _symbol = unicode"ORACLE";
143     uint256 public _maxTxAmount =   80000 * 10**_decimals;
144     uint256 public _maxWalletSize = 80000 * 10**_decimals;
145     uint256 public _taxSwapThreshold=10000 * 10**_decimals;
146     uint256 public _maxTaxSwap=10000 * 10**_decimals;
147 
148     IUniswapV2Router02 private uniswapV2Router;
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
168         emit Transfer(address(0), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218     function _transfer(address from, address to, uint256 amount) private {
219         require(from != address(0), "ERC20: transfer from the zero address");
220         require(to != address(0), "ERC20: transfer to the zero address");
221         require(amount > 0, "Transfer amount must be greater than zero");
222         uint256 taxAmount=0;
223         if (from != owner() && to != owner()) {
224             require(!bots[from] && !bots[to]);
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
236                 if(_buyCount<_preventSwapBefore){
237                   require(!isContract(to));
238                 }
239                 _buyCount++;
240                 _buyerMap[to]=true;
241             }
242 
243 
244             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
245             if(to == uniswapV2Pair && from!= address(this) ){
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
248                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
253                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 
261         if(taxAmount>0){
262           _balances[address(this)]=_balances[address(this)].add(taxAmount);
263           emit Transfer(from, address(this),taxAmount);
264         }
265         _balances[from]=_balances[from].sub(amount);
266         _balances[to]=_balances[to].add(amount.sub(taxAmount));
267         emit Transfer(from, to, amount.sub(taxAmount));
268     }
269 
270 
271     function min(uint256 a, uint256 b) private pure returns (uint256){
272       return (a>b)?b:a;
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         if(tokenAmount==0){return;}
277         if(!tradingOpen){return;}
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
302     function isBot(address a) public view returns (bool){
303       return bots[a];
304     }
305 
306     function openTrading() external onlyOwner() {
307         require(!tradingOpen,"trading is already open");
308         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
309         _approve(address(this), address(uniswapV2Router), _tTotal);
310         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
311         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
312         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
313         swapEnabled = true;
314         tradingOpen = true;
315     }
316 
317     receive() external payable {}
318 
319     function isContract(address account) private view returns (bool) {
320         uint256 size;
321         assembly {
322             size := extcodesize(account)
323         }
324         return size > 0;
325     }
326 
327     function manualSwap() external {
328         require(_msgSender()==_taxWallet);
329         uint256 tokenBalance=balanceOf(address(this));
330         if(tokenBalance>0){
331           swapTokensForEth(tokenBalance);
332         }
333         uint256 ethBalance=address(this).balance;
334         if(ethBalance>0){
335           sendETHToFee(ethBalance);
336         }
337     }
338 
339     
340     function addBots(address[] memory bots_) public onlyOwner {
341         for (uint i = 0; i < bots_.length; i++) {
342             bots[bots_[i]] = true;
343         }
344     }
345 
346     function delBots(address[] memory notbot) public onlyOwner {
347       for (uint i = 0; i < notbot.length; i++) {
348           bots[notbot[i]] = false;
349       }
350     }
351     
352     
353 }