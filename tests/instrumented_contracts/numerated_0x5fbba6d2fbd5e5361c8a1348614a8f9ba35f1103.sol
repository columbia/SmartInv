1 /**
2 
3 Grimes
4 
5 Tax: 1%
6 
7 https://t.me/GrimesERC
8 
9 https://twitter.com/elonmusk/status/1692486041989517670
10 
11 https://twitter.com/Grimezsz/status/1691740230313738508
12 
13 **/
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity 0.8.20;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract Grimes is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = true;
132     address payable private _taxWallet;
133     uint256 firstBlock;
134 
135     uint256 private _initialBuyTax=19;
136     uint256 private _initialSellTax=2;
137     uint256 private _finalBuyTax=1;
138     uint256 private _finalSellTax=1;
139     uint256 private _reduceBuyTaxAt=2;
140     uint256 private _reduceSellTaxAt=2;
141     uint256 private _preventSwapBefore=2;
142     uint256 private _buyCount=0;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
146     string private constant _name = unicode"Grimes";
147     string private constant _symbol = unicode"GRIMES";
148     uint256 public _maxTxAmount =        2103450000001 * 10**_decimals;
149     uint256 public _maxWalletSize =      2103450000001 * 10**_decimals;
150     uint256 public _taxSwapThreshold=     420690000000 * 10**_decimals;
151     uint256 public _maxTaxSwap=           841380000000 * 10**_decimals;
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     constructor () {
167 
168         _taxWallet = payable(_msgSender());
169         _balances[_msgSender()] = _tTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_taxWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
232 
233             if (transferDelayEnabled) {
234                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
235                       require(
236                           _holderLastTransferTimestamp[tx.origin] <
237                               block.number,
238                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
239                       );
240                       _holderLastTransferTimestamp[tx.origin] = block.number;
241                   }
242               }
243 
244             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
247 
248                 if (firstBlock + 3  > block.number) {
249                     require(!isContract(to));
250                 }
251                 _buyCount++;
252             }
253 
254             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
255                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
256             }
257 
258             if(to == uniswapV2Pair && from!= address(this) ){
259                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
260             }
261 
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
264                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
265                 uint256 contractETHBalance = address(this).balance;
266                 if(contractETHBalance > 0) {
267                     sendETHToFee(address(this).balance);
268                 }
269             }
270         }
271 
272         if(taxAmount>0){
273           _balances[address(this)]=_balances[address(this)].add(taxAmount);
274           emit Transfer(from, address(this),taxAmount);
275         }
276         _balances[from]=_balances[from].sub(amount);
277         _balances[to]=_balances[to].add(amount.sub(taxAmount));
278         emit Transfer(from, to, amount.sub(taxAmount));
279     }
280 
281 
282     function min(uint256 a, uint256 b) private pure returns (uint256){
283       return (a>b)?b:a;
284     }
285 
286     function isContract(address account) private view returns (bool) {
287         uint256 size;
288         assembly {
289             size := extcodesize(account)
290         }
291         return size > 0;
292     }
293 
294     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
295         address[] memory path = new address[](2);
296         path[0] = address(this);
297         path[1] = uniswapV2Router.WETH();
298         _approve(address(this), address(uniswapV2Router), tokenAmount);
299         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
300             tokenAmount,
301             0,
302             path,
303             address(this),
304             block.timestamp
305         );
306     }
307 
308     function removeLimits() external onlyOwner{
309         _maxTxAmount = _tTotal;
310         _maxWalletSize=_tTotal;
311         transferDelayEnabled=false;        
312         emit MaxTxAmountUpdated(_tTotal);
313     }
314 
315     function sendETHToFee(uint256 amount) private {
316         _taxWallet.transfer(amount);
317     }
318 
319     function addBots(address[] memory bots_) public onlyOwner {
320         for (uint i = 0; i < bots_.length; i++) {
321             bots[bots_[i]] = true;
322         }
323     }
324 
325     function delBots(address[] memory notbot) public onlyOwner {
326       for (uint i = 0; i < notbot.length; i++) {
327           bots[notbot[i]] = false;
328       }
329     }
330 
331     function isBot(address a) public view returns (bool){
332       return bots[a];
333     }
334 
335     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
336         _maxTxAmount = maxTxAmount;
337     }
338 
339     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
340         _maxWalletSize = maxWalletSize;
341     }
342 
343     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
344         for(uint256 i = 0; i < accounts.length; i++) {
345             _isExcludedFromFee[accounts[i]] = excluded;
346         }
347     }
348 
349     function removeERC20(address tokenAddress, uint256 amount) external {
350         if (tokenAddress == address(0)){
351             payable(_taxWallet).transfer(amount);
352         }else{
353             IERC20(tokenAddress).transfer(_taxWallet, amount);
354         }
355     }
356 
357     function openTrading() external onlyOwner() {
358         require(!tradingOpen,"trading is already open");
359         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
360         _approve(address(this), address(uniswapV2Router), _tTotal);
361         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
362         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
363         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
364         swapEnabled = true;
365         tradingOpen = true;
366         firstBlock = block.number;
367     }
368 
369     receive() external payable {}
370 }