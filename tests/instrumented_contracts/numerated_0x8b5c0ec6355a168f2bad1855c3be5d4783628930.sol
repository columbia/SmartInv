1 /*
2 
3 Paying homage to Yotsuba Koiwai, the mascot of 4chan.
4 
5 You can find Yotsuba everywhere on 4chan and she is commonly known as the 404 girl as you can find her cute images on 4chan’s 404 error page.
6 
7 https://knowyourmeme.com/memes/yotsuba-koiwai-404-girl 
8 
9 Yotsuba loves you!
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.20;
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
72 
73 contract Ownable is Context {
74     address private _owner;
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }
98 
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
124 
125 contract Yotsuba is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping (address => bool) private bots;
131     mapping(address => uint256) private _holderLastTransferTimestamp;
132     bool public transferDelayEnabled = false;
133     address payable private _taxWallet;
134 
135     uint256 private _initialBuyTax=15;
136     uint256 private _initialSellTax=25;
137     uint256 private _finalBuyTax=2;
138     uint256 private _finalSellTax=2;
139     uint256 private _reduceBuyTaxAt=15;
140     uint256 private _reduceSellTaxAt=25;
141     uint256 private _preventSwapBefore=25;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 10;
145     uint256 private constant _tTotal = 444444444444444 * 10**_decimals;
146     string private constant _name = unicode"Yotsuba Koiwai";
147     string private constant _symbol = unicode"YOTSUBA";
148     uint256 public _maxTxAmount = 13333333333333 * 10**_decimals;
149     uint256 public _maxWalletSize = 13333333333333 * 10**_decimals;
150     uint256 public _taxSwapThreshold= 4444444444444 * 10**_decimals;
151     uint256 public _maxTaxSwap= 4444444444444 * 10**_decimals;
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
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
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230         uint256 taxAmount=0;
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233 
234             if (transferDelayEnabled) {
235                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
236                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
237                   _holderLastTransferTimestamp[tx.origin] = block.number;
238                 }
239             }
240 
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 if(_buyCount<_preventSwapBefore){
245                   require(!isContract(to));
246                 }
247                 _buyCount++;
248             }
249 
250 
251             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
252             if(to == uniswapV2Pair && from!= address(this) ){
253                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
254                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
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
334     function manualSwap() external {
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