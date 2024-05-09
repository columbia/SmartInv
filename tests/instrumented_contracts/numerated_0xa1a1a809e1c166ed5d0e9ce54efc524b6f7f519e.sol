1 //https://t.me/PayPalCoinERC
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 pragma solidity 0.8.20;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval (address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 
113 contract PayPalCoin is Context, IERC20, Ownable {
114     using SafeMath for uint256;
115     mapping (address => uint256) private _balances;
116     mapping (address => mapping (address => uint256)) private _allowances;
117     mapping (address => bool) private _isExcludedFromFee;
118     mapping (address => bool) private bots;
119     address payable private _taxWallet;
120     uint256 firstBlock;
121 
122     uint256 private _initialBuyTax=14;
123     uint256 private _initialSellTax=15;
124     uint256 private _finalBuyTax=1;
125     uint256 private _finalSellTax=1;
126     uint256 private _reduceBuyTaxAt=14;
127     uint256 private _reduceSellTaxAt=15;
128     uint256 private _preventSwapBefore=30;
129     uint256 private _buyCount=0;
130 
131     uint8 private constant _decimals = 9;
132     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
133     string private constant _name = unicode"PayPal Coin";
134     string private constant _symbol = unicode"PayPal";
135     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
136     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
137     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
138     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154 
155         _taxWallet = payable(_msgSender());
156         _balances[_msgSender()] = _tTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_taxWallet] = true;
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address owner, address spender, uint256 amount) private {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) private {
212         require(from != address(0), "ERC20: transfer from the zero address");
213         require(to != address(0), "ERC20: transfer to the zero address");
214         require(amount > 0, "Transfer amount must be greater than zero");
215         uint256 taxAmount=0;
216         if (from != owner() && to != owner()) {
217             require(!bots[from] && !bots[to]);
218             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
219 
220             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
221                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
222                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
223 
224                 if (firstBlock + 3  > block.number) {
225                     require(!isContract(to));
226                 }
227                 _buyCount++;
228             }
229 
230             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
231                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
232             }
233 
234             if(to == uniswapV2Pair && from!= address(this) ){
235                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
240                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 
248         if(taxAmount>0){
249           _balances[address(this)]=_balances[address(this)].add(taxAmount);
250           emit Transfer(from, address(this),taxAmount);
251         }
252         _balances[from]=_balances[from].sub(amount);
253         _balances[to]=_balances[to].add(amount.sub(taxAmount));
254         emit Transfer(from, to, amount.sub(taxAmount));
255     }
256 
257 
258     function min(uint256 a, uint256 b) private pure returns (uint256){
259       return (a>b)?b:a;
260     }
261 
262     function isContract(address account) private view returns (bool) {
263         uint256 size;
264         assembly {
265             size := extcodesize(account)
266         }
267         return size > 0;
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = uniswapV2Router.WETH();
274         _approve(address(this), address(uniswapV2Router), tokenAmount);
275         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             tokenAmount,
277             0,
278             path,
279             address(this),
280             block.timestamp
281         );
282     }
283 
284     function removeLimits() external onlyOwner{
285         _maxTxAmount = _tTotal;
286         _maxWalletSize=_tTotal;
287         emit MaxTxAmountUpdated(_tTotal);
288     }
289 
290     function sendETHToFee(uint256 amount) private {
291         _taxWallet.transfer(amount);
292     }
293 
294     function addBots(address[] memory bots_) public onlyOwner {
295         for (uint i = 0; i < bots_.length; i++) {
296             bots[bots_[i]] = true;
297         }
298     }
299 
300     function delBots(address[] memory notbot) public onlyOwner {
301       for (uint i = 0; i < notbot.length; i++) {
302           bots[notbot[i]] = false;
303       }
304     }
305 
306     function isBot(address a) public view returns (bool){
307       return bots[a];
308     }
309 
310     function openTrading() external onlyOwner() {
311         require(!tradingOpen,"trading is already open");
312         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317         swapEnabled = true;
318         tradingOpen = true;
319         firstBlock = block.number;
320     }
321 
322     receive() external payable {}
323 
324 }