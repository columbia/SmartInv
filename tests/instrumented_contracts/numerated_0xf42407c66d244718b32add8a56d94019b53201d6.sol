1 /**
2 
3 https://smokey-erc.cloud/
4 https://t.me/Smokeycoin
5 https://twitter.com/SmokeyErc
6 
7 **/
8 
9 // SPDX-License-Identifier: MIT
10 
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
28     event Approval (address indexed owner, address indexed spender, uint256 value);
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
119 contract Smokey is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     address payable private _taxWallet;
126     uint256 firstBlock;
127 
128     uint256 private _initialBuyTax=14;
129     uint256 private _initialSellTax=14;
130     uint256 private _finalBuyTax=1;
131     uint256 private _finalSellTax=1;
132     uint256 private _reduceBuyTaxAt=11;
133     uint256 private _reduceSellTaxAt=11;
134     uint256 private _preventSwapBefore=30;
135     uint256 private _buyCount=0;
136 
137     uint8 private constant _decimals = 9;
138     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
139     string private constant _name = unicode"Smokey";
140     string private constant _symbol = unicode"SMOKEY";
141     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
142     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
143     uint256 public _taxSwapThreshold= 4206900000000 * 10**_decimals;
144     uint256 public _maxTaxSwap= 4206900000000 * 10**_decimals;
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
160 
161         _taxWallet = payable(_msgSender());
162         _balances[_msgSender()] = _tTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_taxWallet] = true;
166 
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return _balances[account];
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) private {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         uint256 taxAmount=0;
222         if (from != owner() && to != owner()) {
223             require(!bots[from] && !bots[to]);
224             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
225 
226             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
227                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
229 
230                 if (firstBlock + 3  > block.number) {
231                     require(!isContract(to));
232                 }
233                 _buyCount++;
234             }
235 
236             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
237                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
238             }
239 
240             if(to == uniswapV2Pair && from!= address(this) ){
241                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
242             }
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
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
263 
264     function min(uint256 a, uint256 b) private pure returns (uint256){
265       return (a>b)?b:a;
266     }
267 
268     function isContract(address account) private view returns (bool) {
269         uint256 size;
270         assembly {
271             size := extcodesize(account)
272         }
273         return size > 0;
274     }
275 
276     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289 
290     function removeLimits() external onlyOwner{
291         _maxTxAmount = _tTotal;
292         _maxWalletSize=_tTotal;
293         emit MaxTxAmountUpdated(_tTotal);
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _taxWallet.transfer(amount);
298     }
299 
300     function addBots(address[] memory bots_) public onlyOwner {
301         for (uint i = 0; i < bots_.length; i++) {
302             bots[bots_[i]] = true;
303         }
304     }
305 
306     function delBots(address[] memory notbot) public onlyOwner {
307       for (uint i = 0; i < notbot.length; i++) {
308           bots[notbot[i]] = false;
309       }
310     }
311 
312     function isBot(address a) public view returns (bool){
313       return bots[a];
314     }
315 
316     function openTrading() external onlyOwner() {
317         require(!tradingOpen,"trading is already open");
318         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
319         _approve(address(this), address(uniswapV2Router), _tTotal);
320         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
321         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323         swapEnabled = true;
324         tradingOpen = true;
325         firstBlock = block.number;
326     }
327 
328     receive() external payable {}
329 
330 }