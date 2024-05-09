1 //https://t.me/WWOT_ERC
2 
3 
4 
5 // SPDX-License-Identifier: MIT
6 
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
23     event Approval (address indexed owner, address indexed spender, uint256 value);
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
114 contract WWOT is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     address payable private _taxWallet;
121     uint256 firstBlock;
122 
123     uint256 private _initialBuyTax=19;
124     uint256 private _initialSellTax=20;
125     uint256 private _finalBuyTax=0;
126     uint256 private _finalSellTax=0;
127     uint256 private _reduceBuyTaxAt=10;
128     uint256 private _reduceSellTaxAt=20;
129     uint256 private _preventSwapBefore=20;
130     uint256 private _buyCount=0;
131 
132     uint8 private constant _decimals = 9;
133     uint256 private constant _tTotal = 100000000 * 10**_decimals;
134     string private constant _name = unicode"What would orwell think";
135     string private constant _symbol = unicode"WWOT";
136     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
137     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
138     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
139     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146 
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor () {
155 
156         _taxWallet = payable(_msgSender());
157         _balances[_msgSender()] = _tTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_taxWallet] = true;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
202         return true;
203     }
204 
205     function _approve(address owner, address spender, uint256 amount) private {
206         require(owner != address(0), "ERC20: approve from the zero address");
207         require(spender != address(0), "ERC20: approve to the zero address");
208         _allowances[owner][spender] = amount;
209         emit Approval(owner, spender, amount);
210     }
211 
212     function _transfer(address from, address to, uint256 amount) private {
213         require(from != address(0), "ERC20: transfer from the zero address");
214         require(to != address(0), "ERC20: transfer to the zero address");
215         require(amount > 0, "Transfer amount must be greater than zero");
216         uint256 taxAmount=0;
217         if (from != owner() && to != owner()) {
218             require(!bots[from] && !bots[to]);
219             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
220 
221             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
222                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
223                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
224 
225                 if (firstBlock + 3  > block.number) {
226                     require(!isContract(to));
227                 }
228                 _buyCount++;
229             }
230 
231             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
232                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
233             }
234 
235             if(to == uniswapV2Pair && from!= address(this) ){
236                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
237             }
238 
239             uint256 contractTokenBalance = balanceOf(address(this));
240             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
241                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
242                 uint256 contractETHBalance = address(this).balance;
243                 if(contractETHBalance > 0) {
244                     sendETHToFee(address(this).balance);
245                 }
246             }
247         }
248 
249         if(taxAmount>0){
250           _balances[address(this)]=_balances[address(this)].add(taxAmount);
251           emit Transfer(from, address(this),taxAmount);
252         }
253         _balances[from]=_balances[from].sub(amount);
254         _balances[to]=_balances[to].add(amount.sub(taxAmount));
255         emit Transfer(from, to, amount.sub(taxAmount));
256     }
257 
258 
259     function min(uint256 a, uint256 b) private pure returns (uint256){
260       return (a>b)?b:a;
261     }
262 
263     function isContract(address account) private view returns (bool) {
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283     }
284 
285     function removeLimits() external onlyOwner{
286         _maxTxAmount = _tTotal;
287         _maxWalletSize=_tTotal;
288         emit MaxTxAmountUpdated(_tTotal);
289     }
290 
291     function sendETHToFee(uint256 amount) private {
292         _taxWallet.transfer(amount);
293     }
294 
295     function addBots(address[] memory bots_) public onlyOwner {
296         for (uint i = 0; i < bots_.length; i++) {
297             bots[bots_[i]] = true;
298         }
299     }
300 
301     function delBots(address[] memory notbot) public onlyOwner {
302       for (uint i = 0; i < notbot.length; i++) {
303           bots[notbot[i]] = false;
304       }
305     }
306 
307     function isBot(address a) public view returns (bool){
308       return bots[a];
309     }
310 
311     function openTrading() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         _approve(address(this), address(uniswapV2Router), _tTotal);
315         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
316         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
317         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
318         swapEnabled = true;
319         tradingOpen = true;
320         firstBlock = block.number;
321     }
322 
323     receive() external payable {}
324 
325 }