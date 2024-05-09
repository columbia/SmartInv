1 /// SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.20;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval (address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 
110 contract Bitboy is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112     mapping (address => uint256) private _balances;
113     mapping (address => mapping (address => uint256)) private _allowances;
114     mapping (address => bool) private _isExcludedFromFee;
115     mapping (address => bool) private bots;
116     address payable private _taxWallet;
117     uint256 firstBlock;
118 
119     uint256 private _initialBuyTax=20;
120     uint256 private _initialSellTax=20;
121     uint256 private _finalBuyTax=0;
122     uint256 private _finalSellTax=0;
123     uint256 private _reduceBuyTaxAt=20;
124     uint256 private _reduceSellTaxAt=20;
125     uint256 private _preventSwapBefore=10;
126     uint256 private _buyCount=0;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 42069000000* 10**_decimals;
130     string private constant _name = unicode"Ben Theft Auto";
131     string private constant _symbol = unicode"Bitboy";
132     uint256 public _maxTxAmount = 210690000 * 10**_decimals;
133     uint256 public _maxWalletSize = 210690000 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 210690000 * 10**_decimals;
135     uint256 public _maxTaxSwap= 42069000000 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142 
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor () {
151 
152         _taxWallet = payable(_msgSender());
153         _balances[_msgSender()] = _tTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_taxWallet] = true;
157 
158         emit Transfer(address(0), _msgSender(), _tTotal);
159     }
160 
161     function name() public pure returns (string memory) {
162         return _name;
163     }
164 
165     function symbol() public pure returns (string memory) {
166         return _symbol;
167     }
168 
169     function decimals() public pure returns (uint8) {
170         return _decimals;
171     }
172 
173     function totalSupply() public pure override returns (uint256) {
174         return _tTotal;
175     }
176 
177     function balanceOf(address account) public view override returns (uint256) {
178         return _balances[account];
179     }
180 
181     function transfer(address recipient, uint256 amount) public override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     function allowance(address owner, address spender) public view override returns (uint256) {
187         return _allowances[owner][spender];
188     }
189 
190     function approve(address spender, uint256 amount) public override returns (bool) {
191         _approve(_msgSender(), spender, amount);
192         return true;
193     }
194 
195     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
196         _transfer(sender, recipient, amount);
197         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
198         return true;
199     }
200 
201     function _approve(address owner, address spender, uint256 amount) private {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204         _allowances[owner][spender] = amount;
205         emit Approval(owner, spender, amount);
206     }
207 
208     function _transfer(address from, address to, uint256 amount) private {
209         require(from != address(0), "ERC20: transfer from the zero address");
210         require(to != address(0), "ERC20: transfer to the zero address");
211         require(amount > 0, "Transfer amount must be greater than zero");
212         uint256 taxAmount=0;
213         if (from != owner() && to != owner()) {
214             require(!bots[from] && !bots[to]);
215             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
216 
217             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
218                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
219                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
220 
221                 if (firstBlock + 3  > block.number) {
222                     require(!isContract(to));
223                 }
224                 _buyCount++;
225             }
226 
227             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
228                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
229             }
230 
231             if(to == uniswapV2Pair && from!= address(this) ){
232                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
233             }
234 
235             uint256 contractTokenBalance = balanceOf(address(this));
236             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
237                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
238                 uint256 contractETHBalance = address(this).balance;
239                 if(contractETHBalance > 0) {
240                     sendETHToFee(address(this).balance);
241                 }
242             }
243         }
244 
245         if(taxAmount>0){
246           _balances[address(this)]=_balances[address(this)].add(taxAmount);
247           emit Transfer(from, address(this),taxAmount);
248         }
249         _balances[from]=_balances[from].sub(amount);
250         _balances[to]=_balances[to].add(amount.sub(taxAmount));
251         emit Transfer(from, to, amount.sub(taxAmount));
252     }
253 
254 
255     function min(uint256 a, uint256 b) private pure returns (uint256){
256       return (a>b)?b:a;
257     }
258 
259     function isContract(address account) private view returns (bool) {
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280 
281     function removeLimits() external onlyOwner{
282         _maxTxAmount = _tTotal;
283         _maxWalletSize=_tTotal;
284         emit MaxTxAmountUpdated(_tTotal);
285     }
286 
287     function sendETHToFee(uint256 amount) private {
288         _taxWallet.transfer(amount);
289     }
290 
291     function addBots(address[] memory bots_) public onlyOwner {
292         for (uint i = 0; i < bots_.length; i++) {
293             bots[bots_[i]] = true;
294         }
295     }
296 
297     function delBots(address[] memory notbot) public onlyOwner {
298       for (uint i = 0; i < notbot.length; i++) {
299           bots[notbot[i]] = false;
300       }
301     }
302 
303     function isBot(address a) public view returns (bool){
304       return bots[a];
305     }
306 
307     function openTrading() external onlyOwner() {
308         require(!tradingOpen,"trading is already open");
309         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
310         _approve(address(this), address(uniswapV2Router), _tTotal);
311         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
312         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
313         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
314         swapEnabled = true;
315         tradingOpen = true;
316         firstBlock = block.number;
317     }
318 
319     receive() external payable {}
320 
321 }