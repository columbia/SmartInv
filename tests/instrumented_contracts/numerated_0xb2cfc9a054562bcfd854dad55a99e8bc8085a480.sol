1 /**
2 
3  █████  ██    ██ ██████ ███████ ██   ██
4 ██   ███  ██ ██  ██   ██         ██ ██
5 ██ ██ ██    ██   ██   ██ █████     ██
6 ███   ██  ██ ██  ██   ██         ██ ██
7  █████  ██    ██ █████  ███████ ██   ██
8 
9 0xDΞX is a media-centric Defi investment workflow + portfolio manager.
10 
11 website   https://www.0xdex.ai/
12 tg        https://t.me/0xDexPORTAL
13 twitter   https://twitter.com/0xdexai
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.19;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract Ownable is Context {
39     address private _owner;
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor () {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(_owner == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 }
62 
63 
64 interface IUniswapV2Router02 {
65     function swapExactTokensForETHSupportingFeeOnTransferTokens(
66         uint amountIn,
67         uint amountOutMin,
68         address[] calldata path,
69         address to,
70         uint deadline
71     ) external;
72     function factory() external pure returns (address);
73     function WETH() external pure returns (address);
74 }
75 
76 interface IUniswapV2Factory {
77     function createPair(address tokenA, address tokenB) external returns (address UNISWAP_V2_PAIR);
78 }
79 
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86 
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90 
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96 
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105 
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 }
116 
117 
118 contract ZeroXDex is IERC20, Ownable {
119     using SafeMath for uint256;
120 
121     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
122     address constant ZERO = 0x0000000000000000000000000000000000000000;
123 
124     IUniswapV2Router02 public constant UNISWAP_V2_ROUTER =
125         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
126     address public immutable UNISWAP_V2_PAIR;
127     IUniswapV2Factory private UNISWAP_V2_FACTORY;
128 
129     string _name = "0xDex";
130     string _symbol = "0XDEX";
131     uint8 private constant _decimals = 18;
132     uint256 public _totalSupply = 1000000000 * 10**_decimals;
133     uint256 public _maxTxAmount = _totalSupply * 2 / 100;
134     uint256 public _maxWalletSize = _totalSupply* 2 / 100;
135     uint256 public _taxSwap = 5000000 * 10**_decimals;
136 
137     mapping(address => uint256) private _balances;
138     mapping(address => mapping(address => uint256)) _allowances;
139 
140     mapping(address => bool) isFeeExempt;
141     mapping(address => bool) isTxLimitExempt;
142 
143     address payable private _teamWallet;
144 
145     bool public limitsEnabled = true;
146     uint256 private _initialTax=25;
147     uint256 private _finalTax=15;
148     uint256 private _reduceTaxAt=60;
149     uint256 private _preventSwapBefore=30;
150     uint256 private _buyCount=0;
151 
152     bool private _tradingOpen = false;
153     bool private inSwap = false;
154 
155     modifier lockTheSwap() {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor() {
162 
163         address _uniswapPair =
164             IUniswapV2Factory(UNISWAP_V2_ROUTER.factory()).createPair(address(this), UNISWAP_V2_ROUTER.WETH());
165         UNISWAP_V2_PAIR = _uniswapPair;
166 
167         _teamWallet = payable(0xc26d9A610C6c4e912FDeD64F0766Bd9de6D28Be5);
168 
169         _balances[tx.origin] = _totalSupply.mul(9).div(10);
170         _balances[_teamWallet] = _totalSupply.mul(1).div(10);
171 
172         _allowances[address(this)][address(UNISWAP_V2_ROUTER)] = type(uint256).max;
173         _allowances[address(this)][tx.origin] = type(uint256).max;
174         _allowances[address(this)][_teamWallet] = type(uint256).max;
175 
176         isTxLimitExempt[address(this)] = true;
177         isTxLimitExempt[address(UNISWAP_V2_ROUTER)] = true;
178         isTxLimitExempt[UNISWAP_V2_PAIR] = true;
179         isTxLimitExempt[tx.origin] = true;
180         isTxLimitExempt[_teamWallet] = true;
181         isFeeExempt[tx.origin] = true;
182         isFeeExempt[address(this)] = true;
183         isFeeExempt[_teamWallet] = true;
184 
185         emit Transfer(address(0), tx.origin, _totalSupply.mul(9).div(10));
186         emit Transfer(address(0), _teamWallet, _totalSupply.mul(1).div(10));
187     }
188 
189     /* -------------------------------------------------------------------------- */
190     /*                                    ERC20                                   */
191     /* -------------------------------------------------------------------------- */
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         require(spender != address(0), "ERC20: approve to the zero address");
194         _allowances[msg.sender][spender] = amount;
195         emit Approval(msg.sender, spender, amount);
196         return true;
197     }
198 
199     function approveMax(address spender) external returns (bool) {
200         return approve(spender, type(uint256).max);
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214 
215     function name() external view returns (string memory) {
216         return _name;
217     }
218 
219     function symbol() external view returns (string memory) {
220         return _symbol;
221     }
222 
223     function decimals() external pure returns (uint8) {
224         return 18;
225     }
226 
227     function totalSupply() external view override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     function balanceOf(address account) public view override returns (uint256) {
232         return _balances[account];
233     }
234 
235     function allowance(address holder, address spender) external view override returns (uint256) {
236         return _allowances[holder][spender];
237     }
238 
239     function getCirculatingSupply() public view returns (uint256) {
240         return _totalSupply - balanceOf(DEAD) - balanceOf(ZERO);
241     }
242 
243     /* -------------------------------------------------------------------------- */
244     /*                                   owners                                   */
245     /* -------------------------------------------------------------------------- */
246 
247     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
248         isFeeExempt[holder] = exempt;
249     }
250 
251     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
252         isTxLimitExempt[holder] = exempt;
253     }
254 
255     function setMaxTxBasisPoint(uint256 p_) external onlyOwner {
256         _maxTxAmount = _totalSupply * p_ / 10000;
257     }
258 
259     function setLimitsEnabled(bool e_) external onlyOwner {
260         limitsEnabled = e_;
261     }
262 
263 
264     /* -------------------------------------------------------------------------- */
265     /*                                   private                                  */
266     /* -------------------------------------------------------------------------- */
267 
268     function _approve(address owner, address spender, uint256 amount) private {
269         require(owner != address(0), "ERC20: approve from the zero address");
270         require(spender != address(0), "ERC20: approve to the zero address");
271         _allowances[owner][spender] = amount;
272         emit Approval(owner, spender, amount);
273     }
274 
275 
276     function _transfer(address from, address to, uint256 amount) private {
277 
278         require(from != address(0), "ERC20: transfer from the zero address");
279         require(to != address(0), "ERC20: transfer to the zero address");
280         require(amount > 0, "Transfer amount must be greater than zero");
281 
282         uint256 taxAmount=0;
283 
284         if (limitsEnabled && !isTxLimitExempt[from] && !isTxLimitExempt[to]) {
285             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
286         }
287 
288         if (from != owner() && to != owner()) {
289 
290             require(_tradingOpen, "Trading not open.");
291 
292             if(!inSwap){
293                 taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
294             }
295 
296             if (from == UNISWAP_V2_PAIR && to != address(UNISWAP_V2_ROUTER) && ! isFeeExempt[to] ) {
297                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
298                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
299                 _buyCount++;
300             }
301 
302             uint256 contractTokenBalance = balanceOf(address(this));
303             if (!inSwap && from != UNISWAP_V2_PAIR && _tradingOpen && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore ) {
304                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
305                 uint256 contractETHBalance = address(this).balance;
306                 if(contractETHBalance > 0) {
307                     sendETHToFee(address(this).balance);
308                 }
309             }
310         }
311 
312         _balances[from]=_balances[from].sub(amount);
313         _balances[to]=_balances[to].add(amount.sub(taxAmount));
314         emit Transfer(from, to, amount.sub(taxAmount));
315 
316         if(taxAmount>0){
317             _balances[address(this)]=_balances[address(this)].add(taxAmount);
318             emit Transfer(from, address(this),taxAmount);
319         }
320 
321     }
322 
323     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
324         address[] memory path = new address[](2);
325         path[0] = address(this);
326         path[1] = UNISWAP_V2_ROUTER.WETH();
327         approve(address(this), tokenAmount);
328         UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
329             tokenAmount,
330             0,
331             path,
332             address(this),
333             block.timestamp
334         );
335     }
336 
337     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
338         require(_balances[sender] >= amount, "Insufficient Balance");
339         _balances[sender] = _balances[sender] - amount;
340         _balances[recipient] = _balances[recipient] + amount;
341         emit Transfer(sender, recipient, amount);
342         return true;
343     }
344 
345     function _shouldTakeFee(address sender, address recipient) internal view returns (bool) {
346         return !isFeeExempt[sender] && !isFeeExempt[recipient];
347     }
348 
349     function enableTrading() external onlyOwner() {
350         require(!_tradingOpen,"Trading is already open");
351         _tradingOpen = true;
352     }
353 
354     function disableTrading() external onlyOwner() {
355         require(_tradingOpen,"Trading is already disabled");
356         _tradingOpen = false;
357     }
358 
359     function getTradingOpen() external view returns (bool tp) {
360         return _tradingOpen;
361     }
362 
363     function sendETHToFee(uint256 amount) private {
364         _teamWallet.transfer(amount);
365     }
366 
367     receive() external payable {}
368 
369     function reduceFee(uint256 _newFee) external{
370       require(_msgSender()==_teamWallet);
371       require(_newFee<6);
372       _finalTax=_newFee;
373     }
374 
375     function manualSwap() external {
376         require(_msgSender() == _teamWallet);
377         swapTokensForEth(balanceOf(address(this)));
378     }
379 
380     function manualSend() external {
381         require(_msgSender() == _teamWallet);
382         sendETHToFee(address(this).balance);
383     }
384 
385     function manualSendToken() external {
386         require(_msgSender() == _teamWallet);
387         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
388     }
389 
390 }