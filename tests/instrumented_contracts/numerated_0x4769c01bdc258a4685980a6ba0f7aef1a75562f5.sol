1 /**
2  
3 */
4 
5 /**
6  
7 */
8 
9 /*
10 
11                               _,add8ba,
12                             ,d888888888b,
13                            d8888888888888b                        _,ad8ba,_
14                           d888888888888888)                     ,d888888888b,
15                           I8888888888888888 _________          ,8888888888888b
16                 __________`Y88888888888888P"""""""""""biao,__ ,888888888888888,
17             ,adP"""""""""""9888888888P""^                 ^""Y8888888888888888I
18          ,a8"^           ,d888P"888P^                           ^"Y8888888888P'
19        ,a8^            ,d8888'                                     ^Y8888888P'
20       a88'           ,d8888P'                                        I88P"^
21     ,d88'           d88888P'                  Biaocoin                "b,
22    ,d88'           d888888'                     Бяо                    `b,
23   ,d88'           d888888I                                              `b,,
24  ,888'           d8888888          ,d88888b,              ____            `b,
25  d888           ,8888888I         d88888888b,           ,d8888b,           `b
26 ,8888           I8888888I        d8        8I          ,88888888b           8,
27 I8888           88888888b       d88888888888'          88       8b          8I
28 d8886           888888888       Y888888888P'           Y8888888888,        ,8b
29 88888b          I88888888b      `Y8888888^             `Y888888888I        d88,
30 Y88888b         `888888888b,      `""""^                `Y8888888P'       d888I
31 `888888b         88888888888b,                           `Y8888P^        d88888
32  Y888888b       ,8888888888888ba,_          _______        `""^        ,d888888
33  I8888888b,    ,888888888888888888ba,_     d88888888b               ,ad8888888I
34  `888888888b,  I8888888888888888888888b,    ^"Y888P"^      ____.,ad88888888888I
35   88888888888b,`888888888888888888888888b,     ""      ad888888888888888888888'
36   8888888888888698888888888888888888888888b_,ad88ba,_,d88888888888888888888888
37   88888888888Wu8888888888888888888888888888b,`"""^ d8888888888888888888888888I
38   8888888888888Biao88888888888888888888888888baaad888888888888888888888888888'
39   Y8888888888888888Clan88888888888888888888888888888888888888888888888888888P
40   I888888888888888888888Aint88888888888888888888P^  ^Y8888888888888888888888'
41   `Y88888888888888888P888888Nothing8888888888888'     ^88888888888888888888I
42    `Y8888888888888888 `888888888888to88888888888       8888888888888888888P'
43     `Y888888888888888  `8888888888888Fuck8888888,     ,888888888888888888P'
44      `Y88888888888888b  `8888888888888888With888I     I888888888888888888''
45          "Y8888888888P   `888888888888888888888b8     d88888888888888888'
46            """""""""^      `Y88888888888888888888,    88888888888888P'
47                               `Y888888888888888888b   `Y8888888P"^
48                                 "Y8888888888888888P     `""""^
49                                   `"YY88888888888P'
50 ⠀
51 Biaocoin 
52 https://biao.global
53 https://t.me/biaoglobal
54 https://twitter.com/Biaocoin_ETH
55 
56 */
57 
58 // SPDX-License-Identifier: MIT
59 
60 pragma solidity 0.8.20;
61 
62 abstract contract Context {
63     function _msgSender() internal view virtual returns (address) {
64         return msg.sender;
65     }
66 }
67 
68 interface IERC20 {
69     function totalSupply() external view returns (uint256);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool);
72     function allowance(address owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval (address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93         return c;
94     }
95 
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         if (a == 0) {
98             return 0;
99         }
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102         return c;
103     }
104 
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 
115 }
116 
117 contract Ownable is Context {
118     address private _owner;
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     constructor () {
122         address msgSender = _msgSender();
123         _owner = msgSender;
124         emit OwnershipTransferred(address(0), msgSender);
125     }
126 
127     function owner() public view returns (address) {
128         return _owner;
129     }
130 
131     modifier onlyOwner() {
132         require(_owner == _msgSender(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     function renounceOwnership() public virtual onlyOwner {
137         emit OwnershipTransferred(_owner, address(0));
138         _owner = address(0);
139     }
140 
141 }
142 
143 interface IUniswapV2Factory {
144     function createPair(address tokenA, address tokenB) external returns (address pair);
145 }
146 
147 interface IUniswapV2Router02 {
148     function swapExactTokensForETHSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155     function factory() external pure returns (address);
156     function WETH() external pure returns (address);
157     function addLiquidityETH(
158         address token,
159         uint amountTokenDesired,
160         uint amountTokenMin,
161         uint amountETHMin,
162         address to,
163         uint deadline
164     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
165 }
166 
167 contract Biaocoin is Context, IERC20, Ownable {
168     using SafeMath for uint256;
169     mapping (address => uint256) private _balances;
170     mapping (address => mapping (address => uint256)) private _allowances;
171     mapping (address => bool) private _isExcludedFromFee;
172     mapping (address => bool) private bots;
173     address payable private _taxWallet;
174     uint256 firstBlock;
175 
176     uint256 private _initialBuyTax=35;
177     uint256 private _initialSellTax=40;
178     uint256 private _finalBuyTax=2;
179     uint256 private _finalSellTax=2;
180     uint256 private _reduceBuyTaxAt=31;
181     uint256 private _reduceSellTaxAt=40;
182     uint256 private _preventSwapBefore=25;
183     uint256 private _buyCount=0;
184 
185     uint8 private constant _decimals = 9;
186     uint256 private constant _tTotal = 1000000 * 10**_decimals;
187     string private constant _name = unicode"Biaocoin";
188     string private constant _symbol = unicode"Бяо";
189     uint256 public _maxTxAmount =   20000 * 10**_decimals;
190     uint256 public _maxWalletSize = 20000 * 10**_decimals;
191     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
192     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
193 
194     IUniswapV2Router02 private uniswapV2Router;
195     address private uniswapV2Pair;
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = false;
199 
200     event MaxTxAmountUpdated(uint _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207     constructor () {
208 
209         _taxWallet = payable(_msgSender());
210         _balances[_msgSender()] = _tTotal;
211         _isExcludedFromFee[owner()] = true;
212         _isExcludedFromFee[address(this)] = true;
213         _isExcludedFromFee[_taxWallet] = true;
214 
215         emit Transfer(address(0), _msgSender(), _tTotal);
216     }
217 
218     function name() public pure returns (string memory) {
219         return _name;
220     }
221 
222     function symbol() public pure returns (string memory) {
223         return _symbol;
224     }
225 
226     function decimals() public pure returns (uint8) {
227         return _decimals;
228     }
229 
230     function totalSupply() public pure override returns (uint256) {
231         return _tTotal;
232     }
233 
234     function balanceOf(address account) public view override returns (uint256) {
235         return _balances[account];
236     }
237 
238     function transfer(address recipient, uint256 amount) public override returns (bool) {
239         _transfer(_msgSender(), recipient, amount);
240         return true;
241     }
242 
243     function allowance(address owner, address spender) public view override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     function approve(address spender, uint256 amount) public override returns (bool) {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
253         _transfer(sender, recipient, amount);
254         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
255         return true;
256     }
257 
258     function _approve(address owner, address spender, uint256 amount) private {
259         require(owner != address(0), "ERC20: approve from the zero address");
260         require(spender != address(0), "ERC20: approve to the zero address");
261         _allowances[owner][spender] = amount;
262         emit Approval(owner, spender, amount);
263     }
264 
265     function _transfer(address from, address to, uint256 amount) private {
266         require(from != address(0), "ERC20: transfer from the zero address");
267         require(to != address(0), "ERC20: transfer to the zero address");
268         require(amount > 0, "Transfer amount must be greater than zero");
269         uint256 taxAmount=0;
270         if (from != owner() && to != owner()) {
271             require(!bots[from] && !bots[to]);
272             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
273 
274             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
275                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
276                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
277 
278                 if (firstBlock + 3  > block.number) {
279                     require(!isContract(to));
280                 }
281                 _buyCount++;
282             }
283 
284             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
285                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
286             }
287 
288             if(to == uniswapV2Pair && from!= address(this) ){
289                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
290             }
291 
292             uint256 contractTokenBalance = balanceOf(address(this));
293             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
294                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
295                 uint256 contractETHBalance = address(this).balance;
296                 if(contractETHBalance > 0) {
297                     sendETHToFee(address(this).balance);
298                 }
299             }
300         }
301 
302         if(taxAmount>0){
303           _balances[address(this)]=_balances[address(this)].add(taxAmount);
304           emit Transfer(from, address(this),taxAmount);
305         }
306         _balances[from]=_balances[from].sub(amount);
307         _balances[to]=_balances[to].add(amount.sub(taxAmount));
308         emit Transfer(from, to, amount.sub(taxAmount));
309     }
310 
311 
312     function min(uint256 a, uint256 b) private pure returns (uint256){
313       return (a>b)?b:a;
314     }
315 
316     function isContract(address account) private view returns (bool) {
317         uint256 size;
318         assembly {
319             size := extcodesize(account)
320         }
321         return size > 0;
322     }
323 
324     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
325         address[] memory path = new address[](2);
326         path[0] = address(this);
327         path[1] = uniswapV2Router.WETH();
328         _approve(address(this), address(uniswapV2Router), tokenAmount);
329         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
330             tokenAmount,
331             0,
332             path,
333             address(this),
334             block.timestamp
335         );
336     }
337 
338     function removeLimits() external onlyOwner{
339         _maxTxAmount = _tTotal;
340         _maxWalletSize=_tTotal;
341         emit MaxTxAmountUpdated(_tTotal);
342     }
343 
344     function sendETHToFee(uint256 amount) private {
345         _taxWallet.transfer(amount);
346     }
347 
348     function addBots(address[] memory bots_) public onlyOwner {
349         for (uint i = 0; i < bots_.length; i++) {
350             bots[bots_[i]] = true;
351         }
352     }
353 
354     function delBots(address[] memory notbot) public onlyOwner {
355       for (uint i = 0; i < notbot.length; i++) {
356           bots[notbot[i]] = false;
357       }
358     }
359 
360     function isBot(address a) public view returns (bool){
361       return bots[a];
362     }
363 
364     function openTrading() external onlyOwner() {
365         require(!tradingOpen,"trading is already open");
366         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
367         _approve(address(this), address(uniswapV2Router), _tTotal);
368         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
369         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
370         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
371         swapEnabled = true;
372         tradingOpen = true;
373         firstBlock = block.number;
374     }
375 
376     receive() external payable {}
377 
378 }