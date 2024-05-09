1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.20;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval (address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83 }
84 
85 interface IUniswapV2Factory {
86     function createPair(address tokenA, address tokenB) external returns (address pair);
87 }
88 
89 interface IUniswapV2Router02 {
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97     function factory() external pure returns (address);
98     function WETH() external pure returns (address);
99     function addLiquidityETH(
100         address token,
101         uint amountTokenDesired,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
107 }
108 
109 contract pepe is Context, IERC20, Ownable {
110     using SafeMath for uint256;
111     mapping (address => uint256) private _balances;
112     mapping (address => mapping (address => uint256)) private _allowances;
113     mapping (address => bool) private _isExcludedFromFee;
114     mapping (address => bool) private bots;
115     address payable private _taxWallet;
116     uint256 firstBlock;
117 
118     uint256 private _initialBuyTax=20;
119     uint256 private _initialSellTax=20;
120     uint256 private _finalBuyTax=0;
121     uint256 private _finalSellTax=0;
122     uint256 private _reduceBuyTaxAt=20;
123     uint256 private _reduceSellTaxAt=20;
124     uint256 private _preventSwapBefore=10;
125     uint256 private _buyCount=0;
126 
127     uint8 private constant _decimals = 9;
128     uint256 private constant _tTotal = 4206900000000* 10**_decimals;
129     string private constant _name = unicode"pepe²";
130     string private constant _symbol = unicode"pepe²";
131     uint256 public _maxTxAmount = 21069000000 * 10**_decimals;
132     uint256 public _maxWalletSize = 21069000000 * 10**_decimals;
133     uint256 public _taxSwapThreshold= 21069000000 * 10**_decimals;
134     uint256 public _maxTaxSwap= 4206900000000 * 10**_decimals;
135 
136     IUniswapV2Router02 private uniswapV2Router;
137     address private uniswapV2Pair;
138     bool private tradingOpen;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141 
142     event MaxTxAmountUpdated(uint _maxTxAmount);
143     modifier lockTheSwap {
144         inSwap = true;
145         _;
146         inSwap = false;
147     }
148 
149     constructor () {
150 
151         _taxWallet = payable(_msgSender());
152         _balances[_msgSender()] = _tTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_taxWallet] = true;
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address owner, address spender, uint256 amount) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function _transfer(address from, address to, uint256 amount) private {
208         require(from != address(0), "ERC20: transfer from the zero address");
209         require(to != address(0), "ERC20: transfer to the zero address");
210         require(amount > 0, "Transfer amount must be greater than zero");
211         uint256 taxAmount=0;
212         if (from != owner() && to != owner()) {
213             require(!bots[from] && !bots[to]);
214             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
215 
216             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
217                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
218                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
219 
220                 if (firstBlock + 3  > block.number) {
221                     require(!isContract(to));
222                 }
223                 _buyCount++;
224             }
225 
226             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
227                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
228             }
229 
230             if(to == uniswapV2Pair && from!= address(this) ){
231                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
232             }
233 
234             uint256 contractTokenBalance = balanceOf(address(this));
235             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
236                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
237                 uint256 contractETHBalance = address(this).balance;
238                 if(contractETHBalance > 0) {
239                     sendETHToFee(address(this).balance);
240                 }
241             }
242         }
243 
244         if(taxAmount>0){
245           _balances[address(this)]=_balances[address(this)].add(taxAmount);
246           emit Transfer(from, address(this),taxAmount);
247         }
248         _balances[from]=_balances[from].sub(amount);
249         _balances[to]=_balances[to].add(amount.sub(taxAmount));
250         emit Transfer(from, to, amount.sub(taxAmount));
251     }
252 
253 
254     function min(uint256 a, uint256 b) private pure returns (uint256){
255       return (a>b)?b:a;
256     }
257 
258     function isContract(address account) private view returns (bool) {
259         uint256 size;
260         assembly {
261             size := extcodesize(account)
262         }
263         return size > 0;
264     }
265 
266     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = uniswapV2Router.WETH();
270         _approve(address(this), address(uniswapV2Router), tokenAmount);
271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             tokenAmount,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278     }
279 
280     function removeLimits() external onlyOwner{
281         _maxTxAmount = _tTotal;
282         _maxWalletSize=_tTotal;
283         emit MaxTxAmountUpdated(_tTotal);
284     }
285 
286     function sendETHToFee(uint256 amount) private {
287         _taxWallet.transfer(amount);
288     }
289 
290     function addBots(address[] memory bots_) public onlyOwner {
291         for (uint i = 0; i < bots_.length; i++) {
292             bots[bots_[i]] = true;
293         }
294     }
295 
296     function delBots(address[] memory notbot) public onlyOwner {
297       for (uint i = 0; i < notbot.length; i++) {
298           bots[notbot[i]] = false;
299       }
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
315         firstBlock = block.number;
316     }
317 
318     receive() external payable {}
319 
320 }