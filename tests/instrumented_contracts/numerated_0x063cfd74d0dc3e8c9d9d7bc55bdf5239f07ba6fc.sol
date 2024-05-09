1 /****
2 
3 Yotsuba Koiwai, the mascot of 4chan! 🍀
4 
5 4chan is also known as “Yotsuba Channel” in Japanese.
6 
7 Yotsuba has a clover shaped hairstyle similar to 4chan’s signature clover logo.
8 
9 You can spot Yotsuba everywhere on 4chan, especially on 404 error pages: https://knowyourmeme.com/memes/yotsuba-koiwai-404-girl
10 
11 She is actually woven into the history of 4chan, as the software that 4chan runs on was lovingly code-named "Yotsuba"
12 
13 https://yotsuba4chan.com
14 https://twitter.com/yotsubatoken
15 https://t.me/yotsubatoken 
16 
17 ****/
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity 0.8.20;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 
79 contract Ownable is Context {
80     address private _owner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103 }
104 
105 
106 interface IUniswapV2Factory {
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 }
109 
110 interface IUniswapV2Router02 {
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 }
129 
130 
131 contract YotsubaKoiwai is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _balances;
134     mapping (address => mapping (address => uint256)) private _allowances;
135     mapping (address => bool) private _isExcludedFromFee;
136     mapping (address => bool) private bots;
137     mapping(address => uint256) private _holderLastTransferTimestamp;
138     bool public transferDelayEnabled = false;
139     address payable private _taxWallet;
140 
141     uint256 private _initialBuyTax=10;
142     uint256 private _initialSellTax=30;
143     uint256 private _finalBuyTax=1;
144     uint256 private _finalSellTax=1;
145     uint256 private _reduceBuyTaxAt=10;
146     uint256 private _reduceSellTaxAt=20;
147     uint256 private _preventSwapBefore=20;
148     uint256 private _buyCount=0;
149 
150     uint8 private constant _decimals = 9;
151     uint256 private constant _tTotal = 444444444444444 * 10**_decimals;
152     string private constant _name = unicode"Yotsuba Koiwai of 4chan";
153     string private constant _symbol = unicode"YOTSUBA";
154     uint256 public _maxTxAmount = 8888888888888 * 10**_decimals;
155     uint256 public _maxWalletSize = 8888888888888 * 10**_decimals;
156     uint256 public _taxSwapThreshold= 2222222222222 * 10**_decimals;
157     uint256 public _maxTaxSwap= 4444444444444 * 10**_decimals;
158 
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private inSwap = false;
163     bool private swapEnabled = false;
164 
165     event MaxTxAmountUpdated(uint _maxTxAmount);
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171 
172 
173     constructor () {
174         _taxWallet = payable(_msgSender());
175         _balances[_msgSender()] = _tTotal;
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _isExcludedFromFee[_taxWallet] = true;
179 
180         emit Transfer(address(0), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return _balances[account];
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(from != address(0), "ERC20: transfer from the zero address");
234         require(to != address(0), "ERC20: transfer to the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         uint256 taxAmount=0;
237         if (from != owner() && to != owner()) {
238             require(!bots[from] && !bots[to]);
239 
240             if (transferDelayEnabled) {
241                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
242                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
243                   _holderLastTransferTimestamp[tx.origin] = block.number;
244                 }
245             }
246 
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250                 if(_buyCount<_preventSwapBefore){
251                   require(!isContract(to));
252                 }
253                 _buyCount++;
254             }
255 
256 
257             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
258             if(to == uniswapV2Pair && from!= address(this) ){
259                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
260                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
261             }
262 
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
265                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }
272 
273         if(taxAmount>0){
274           _balances[address(this)]=_balances[address(this)].add(taxAmount);
275           emit Transfer(from, address(this),taxAmount);
276         }
277         _balances[from]=_balances[from].sub(amount);
278         _balances[to]=_balances[to].add(amount.sub(taxAmount));
279         emit Transfer(from, to, amount.sub(taxAmount));
280     }
281 
282 
283     function min(uint256 a, uint256 b) private pure returns (uint256){
284       return (a>b)?b:a;
285     }
286 
287     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
288         if(tokenAmount==0){return;}
289         if(!tradingOpen){return;}
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function removeLimits() external onlyOwner{
304         _maxTxAmount = _tTotal;
305         _maxWalletSize=_tTotal;
306         transferDelayEnabled=false;
307         emit MaxTxAmountUpdated(_tTotal);
308     }
309 
310     function sendETHToFee(uint256 amount) private {
311         _taxWallet.transfer(amount);
312     }
313 
314     function isBot(address a) public view returns (bool){
315       return bots[a];
316     }
317 
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         _approve(address(this), address(uniswapV2Router), _tTotal);
322         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
324         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
325         swapEnabled = true;
326         tradingOpen = true;
327     }
328 
329 
330     receive() external payable {}
331 
332     function isContract(address account) private view returns (bool) {
333         uint256 size;
334         assembly {
335             size := extcodesize(account)
336         }
337         return size > 0;
338     }
339 
340     function manualSwap() external {
341         require(_msgSender()==_taxWallet);
342         uint256 tokenBalance=balanceOf(address(this));
343         if(tokenBalance>0){
344           swapTokensForEth(tokenBalance);
345         }
346         uint256 ethBalance=address(this).balance;
347         if(ethBalance>0){
348           sendETHToFee(ethBalance);
349         }
350     }
351 
352     
353     
354     
355 }