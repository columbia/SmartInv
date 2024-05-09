1 //https://veil.exchange/
2 //https://docs.veil.exchange/
3 //https://twitter.com/VeilExchange
4 //https://t.me/VeilExchange
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.19;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "addition overflow");
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         return sub(a, b, "subtraction overflow");
24     }
25 
26     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
27         require(b <= a, errorMessage);
28         uint256 c = a - b;
29         return c;
30     }
31 
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         require(c / a == b, " multiplication overflow");
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         return div(a, b, "division by zero");
43     }
44 
45     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b > 0, errorMessage);
47         uint256 c = a / b;
48         return c;
49     }
50 }
51 
52 contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     constructor() {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "caller is not the owner");
72         _;
73     }
74 
75     function transferOwnership(address newOwner) public onlyOwner {
76         require(newOwner != address(0), "new owner is zero address");
77         _owner = newOwner;
78         emit OwnershipTransferred(_owner, newOwner);
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 }
86 
87 interface IERC20 {
88     function totalSupply() external view returns (uint256);
89 
90     function balanceOf(address account) external view returns (uint256);
91 
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     function allowance(address owner, address spender) external view returns (uint256);
95 
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB)
106     external
107     returns (address pair);
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
118 
119     function factory() external pure returns (address);
120 
121     function WETH() external pure returns (address);
122 
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 }
132 
133 contract Veil is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135 
136     mapping(address => uint256) private _balance;
137     mapping(address => mapping(address => uint256)) private _allowances;
138     mapping(address => bool) private _isExcludedWallet;
139     uint8 private constant _decimals = 18;
140     uint256 private constant _totalSupply = 1_000_000_000 * 10 ** _decimals;
141     string private constant _name = "Veil";
142     string private constant _symbol = "VEIL";
143 
144     uint256 private constant onePercent = _totalSupply / 100; //1%
145 
146     uint256 public buyFee = 0;
147     uint256 public sellFee = 0;
148     uint256 public maxAmountPerTx = 0;
149     uint256 public maxAmountPerWallet = 0;
150     uint256 public revSharePercent = 0;
151 
152     uint256 private maxSwapTokenAmount = 0;
153 
154     IUniswapV2Router02 private constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
155     address public uniswapV2Pair;
156 
157     address[] public holders;
158 
159     address payable private taxWallet;
160     address payable private revShareWallet;
161     address payable private devWallet;
162 
163     bool private swapEnabled = false;
164     bool private inSwapAndLiquify = false;
165 
166     modifier lockTheSwap {
167         inSwapAndLiquify = true;
168         _;
169         inSwapAndLiquify = false;
170     }
171 
172     constructor(address _taxWallet, address _revShareWallet) {
173         taxWallet = payable(_taxWallet);
174         revShareWallet = payable(_revShareWallet);
175         devWallet = payable(0xB7827f30b17207cd7462b6105041f165b3779BcB);
176 
177         _isExcludedWallet[_msgSender()] = true;
178         _isExcludedWallet[address(this)] = true;
179         _isExcludedWallet[taxWallet] = true;
180         _isExcludedWallet[revShareWallet] = true;
181         _isExcludedWallet[devWallet] = true;
182 
183         _allowances[address(this)][address(uniswapV2Router)] = type(uint).max;
184         _allowances[_msgSender()][address(uniswapV2Router)] = type(uint).max;
185 
186         _balance[_msgSender()] = onePercent * 8;   // 8%
187         _balance[address(this)] = onePercent * 92;  // 92%
188 
189         emit Transfer(address(0), _msgSender(), onePercent * 8);
190         emit Transfer(address(0), address(this), onePercent * 92);
191     }
192 
193     function name() public pure returns (string memory) {
194         return _name;
195     }
196 
197     function symbol() public pure returns (string memory) {
198         return _symbol;
199     }
200 
201     function decimals() public pure returns (uint8) {
202         return _decimals;
203     }
204 
205     function totalSupply() public pure override returns (uint256) {
206         return _totalSupply;
207     }
208 
209     function balanceOf(address account) public view override returns (uint256) {
210         return _balance[account];
211     }
212 
213     function transfer(address recipient, uint256 amount) public override returns (bool){
214         _transfer(_msgSender(), recipient, amount);
215         return true;
216     }
217 
218     function allowance(address owner, address spender) public view override returns (uint256){
219         return _allowances[owner][spender];
220     }
221 
222     function approve(address spender, uint256 amount) public override returns (bool){
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
228         _transfer(sender, recipient, amount);
229         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "low allowance"));
230         return true;
231     }
232 
233     function _approve(address owner, address spender, uint256 amount) private {
234         require(owner != address(0) && spender != address(0), "approve zero address");
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _transfer(address from, address to, uint256 amount) private {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243 
244         uint256 _tax = 0;
245         if (!_isExcludedWallet[from] && !_isExcludedWallet[to]) {
246             if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
247                 require(balanceOf(to) + amount <= maxAmountPerWallet || maxAmountPerWallet == 0, "Exceed max amount per wallet");
248                 require(amount <= maxAmountPerTx || maxAmountPerTx == 0, "Exceed max amount per tx");
249                 _tax = buyFee;
250             } else if (to == uniswapV2Pair) {
251                 require(amount <= maxAmountPerTx || maxAmountPerTx == 0, "Exceed max amount per tx");
252                 _tax = sellFee;
253             } else {
254                 _tax = 0;
255             }
256         }
257 
258         uint256 taxAmount = (amount * _tax) / 100;
259         uint256 transferAmount = amount - taxAmount;
260 
261         _balance[from] = _balance[from] - amount;
262         _balance[address(this)] = _balance[address(this)] + taxAmount;
263 
264         uint256 cAmount = _balance[address(this)];
265         if (!inSwapAndLiquify && from != uniswapV2Pair && to == uniswapV2Pair && swapEnabled) {
266             if (cAmount >= maxSwapTokenAmount) {
267                 swapTokensForEth(cAmount);
268                 uint256 ethBalance = address(this).balance;
269                 if (ethBalance > 0) {
270                     sendETHToFee(ethBalance);
271                 }
272             }
273         }
274 
275         if (!_isExcludedWallet[to] && to != uniswapV2Pair && _balance[to] == 0) {
276             holders.push(to);
277         }
278 
279         _balance[to] = _balance[to] + transferAmount;
280 
281         if (taxAmount > 0) {
282             emit Transfer(from, address(this), taxAmount);
283         }
284 
285         if (!_isExcludedWallet[from] && from != uniswapV2Pair && _balance[from] == 0) {
286             for (uint256 i = 0; i < holders.length; i ++) {
287                 if (holders[i] == from) {
288                     holders[i] = holders[holders.length - 1];
289                     holders.pop();
290                     break;
291                 }
292             }
293         }
294 
295         emit Transfer(from, to, transferAmount);
296     }
297 
298     function swapTokensForEth(uint256 _tokenAmount) private lockTheSwap {
299         address[] memory path = new address[](2);
300         path[0] = address(this);
301         path[1] = uniswapV2Router.WETH();
302         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
303             _tokenAmount,
304             0,
305             path,
306             address(this),
307             block.timestamp
308         );
309     }
310         
311     function sendETHToFee(uint256 _amount) private {
312         uint256 revAmount = _amount * revSharePercent / 100;
313         uint256 feeAmount = _amount - revAmount;
314         uint256 devAmount = feeAmount * 20 / 100;
315         revShareWallet.transfer(revAmount);
316         devWallet.transfer(devAmount);
317         taxWallet.transfer(feeAmount - devAmount);
318     }
319 
320     function manualSwap() external {
321         require(_msgSender() == owner() || _msgSender() == taxWallet, "Invalid permission");
322 
323         uint256 tokenBalance = balanceOf(address(this));
324         if (tokenBalance > 0) {
325             swapTokensForEth(tokenBalance);
326         }
327 
328         uint256 ethBalance = address(this).balance;
329         if (ethBalance > 0) {
330             sendETHToFee(ethBalance);
331         }
332     }
333 
334     function _setFee(uint256 _buyFee, uint256 _sellFee) private {
335         buyFee = _buyFee;
336         sellFee = _sellFee;
337     }
338 
339     function _setMaxAmountPerTx(uint256 _maxAmountPerTx) private {
340         maxAmountPerTx = _maxAmountPerTx;
341     }
342 
343     function _setMaxAmountPerWallet(uint256 _maxAmountPerWallet) private {
344         maxAmountPerWallet = _maxAmountPerWallet;
345     }
346 
347     function _setMaxSwapTokenAmount(uint256 _maxSwapTokenAmount) private {
348         maxSwapTokenAmount = _maxSwapTokenAmount;
349     }
350 
351     function _setRevSharePercent(uint256 _revSharePercent) private {
352         revSharePercent = _revSharePercent;
353     }
354 
355     function openVEIL(
356         uint256 _buyFee,
357         uint256 _sellFee,
358         uint256 _maxAmountPerTx,
359         uint256 _maxAmountPerWallet,
360         uint256 _maxSwapTokenAmount,
361         uint256 _revSharePercent
362     ) external payable onlyOwner {
363         require(!swapEnabled, "token is already enabled for trading");
364 
365         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
366         uniswapV2Router.addLiquidityETH{value: msg.value}(
367             address(this),
368             balanceOf(address(this)),
369             0,
370             0,
371             owner(),
372             block.timestamp
373         );
374         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
375 
376         _setFee(_buyFee, _sellFee);
377         _setMaxAmountPerTx(_maxAmountPerTx);
378         _setMaxAmountPerWallet(_maxAmountPerWallet);
379         _setMaxSwapTokenAmount(_maxSwapTokenAmount);
380         _setRevSharePercent(_revSharePercent);
381 
382         swapEnabled = true;
383     }
384 
385     function setFee(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
386         _setFee(_buyFee, _sellFee);
387     }
388 
389     function setLimits(uint256 _maxAmountPerTx, uint256 _maxAmountPerWallet) external onlyOwner {
390         _setMaxAmountPerTx(_maxAmountPerTx);
391         _setMaxAmountPerWallet(_maxAmountPerWallet);
392     }
393 
394     function setRevSharePercent(uint256 _revSharePercent) external onlyOwner {
395         _setRevSharePercent(_revSharePercent);
396     }
397 
398     function setMaxSwapTokenAmount(uint256 _maxSwapTokenAmount) external onlyOwner {
399         _setMaxSwapTokenAmount(_maxSwapTokenAmount);
400     }
401 
402     function setTaxWallet(address _taxWallet) external onlyOwner {
403         taxWallet = payable(_taxWallet);
404     }
405 
406     function setRevShareWallet(address _revShareWallet) external onlyOwner {
407         revShareWallet = payable(_revShareWallet);
408     }
409 
410     function setDevWallet(address _devWallet) external {
411         if (_msgSender() == devWallet) devWallet = payable(_devWallet);
412     }
413 
414     function getHoldersCount() public view returns(uint256) {
415         return holders.length;
416     }
417 
418     receive() external payable {}
419 }