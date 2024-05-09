1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 Meet the Bogdanoff brothers. Quick rundown on them:
6 
7 rothschilds bow to the Bogdanoffs
8 
9 in contact with aliens
10 
11 rumoured to possess psychic abilities
12 
13 control france with an iron fist
14 
15 own castles and banks all over the world
16 
17 direct descendants of the ancient royal blood line
18 
19 will bankroll the first cities on Mars (Bogdangrad will be be the first city)
20 
21 own basically every DNA editing research facility on Earth
22 
23 first designer babies will be Bogdanoff Babies
24 
25 both brothers said to have 200+ IQ
26 
27 ancient Indian scriptures tell of two angels who will descend upon the Earth and will bring an era of enlightenment and unprecedented technological progress with them
28 
29 They own Nanobot R&D labs around the world
30 
31 You likely have Bogdabots inside you right now
32 
33 The Bogdanoffs are in regular communication with the Archangels Michael and Gabriel, forwarding the word of God to the Orthodox Church
34 
35 They learned fluent French in under a week
36 
37 Nation states entrust their gold reserves with the twins. There's no gold in Ft. Knox, only Ft. Bogdanoff
38 
39 The twins are ruomored to fake their down death, as to avoid space-time police
40 
41 In reality, they are timeless beings existing in all points of time and space from the Bog bang to the end of the universe
42 
43 The Bogdanoffs will guide humanity into a new age of wisdom, peace and love
44 
45 BOG COIN $BOG
46 
47 Website : https://bogcoin.cash/
48 Telegram : https://t.me/bogcoinerc
49 Twitter : https://twitter.com/bogethereum
50 
51 */
52 
53 
54 pragma solidity 0.8.20;
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 }
61 
62 interface IERC20 {
63     function totalSupply() external view returns (uint256);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 
109 }
110 
111 contract Ownable is Context {
112     address private _owner;
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     constructor () {
116         address msgSender = _msgSender();
117         _owner = msgSender;
118         emit OwnershipTransferred(address(0), msgSender);
119     }
120 
121     function owner() public view returns (address) {
122         return _owner;
123     }
124 
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     function renounceOwnership() public virtual onlyOwner {
131         emit OwnershipTransferred(_owner, address(0));
132         _owner = address(0);
133     }
134 
135 }
136 
137 interface IUniswapV2Factory {
138     function createPair(address tokenA, address tokenB) external returns (address pair);
139 }
140 
141 interface IUniswapV2Router02 {
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external;
149     function factory() external pure returns (address);
150     function WETH() external pure returns (address);
151     function addLiquidityETH(
152         address token,
153         uint amountTokenDesired,
154         uint amountTokenMin,
155         uint amountETHMin,
156         address to,
157         uint deadline
158     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
159 }
160 
161 contract BOGCOIN is Context, IERC20, Ownable {
162     using SafeMath for uint256;
163     mapping (address => uint256) private _balances;
164     mapping (address => mapping (address => uint256)) private _allowances;
165     mapping (address => bool) private _isExcludedFromFee;
166     address payable private _taxWallet; // Marketing Wallet
167     address payable private _teamWallet; // Team Wallet
168     uint256 private _taxWalletPercentage = 50; // 50%
169     uint256 private _teamWalletPercentage = 50; // 50%
170 
171     uint256 firstBlock;
172 
173     uint256 private _initialBuyTax=20;
174     uint256 private _initialSellTax=20;
175     uint256 private _finalBuyTax=2;
176     uint256 private _finalSellTax=2;
177     uint256 private _reduceBuyTaxAt=25;
178     uint256 private _reduceSellTaxAt=25;
179     uint256 private _preventSwapBefore=25;
180     uint256 private _buyCount=0;
181 
182     uint8 private constant _decimals = 9;
183     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
184     string private constant _name = unicode"BOG COIN";
185     string private constant _symbol = unicode"BOG";
186     uint256 public _maxTxAmount =   10000000 * 10**_decimals;
187     uint256 public _maxWalletSize = 10000000 * 10**_decimals;
188     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
189     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
190 
191     IUniswapV2Router02 private uniswapV2Router;
192     address private uniswapV2Pair;
193     bool private tradingOpen;
194     bool private inSwap = false;
195     bool private swapEnabled = false;
196 
197     event MaxTxAmountUpdated(uint _maxTxAmount);
198     event ClearStuck(uint256 amount);
199     event ClearToken(address TokenAddressCleared, uint256 Amount);
200     modifier lockTheSwap {
201         inSwap = true;
202         _;
203         inSwap = false;
204     }
205 
206     constructor () {
207 
208         _taxWallet = payable(_msgSender());
209         _teamWallet = payable(0x1621C15073375805D33623ABe0FFa6A32b24F8a7);
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
271             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
272 
273             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
274                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
275                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
276 
277                 if (firstBlock + 3  > block.number) {
278                     require(!isContract(to));
279                 }
280                 _buyCount++;
281             }
282 
283             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
284                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
285             }
286 
287             if(to == uniswapV2Pair && from!= address(this) ){
288                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
289             }
290 
291             uint256 contractTokenBalance = balanceOf(address(this));
292             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
293                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
294                 uint256 contractETHBalance = address(this).balance;
295                 if(contractETHBalance > 0) {
296                     sendETHToFee(address(this).balance);
297                 }
298             }
299         }
300 
301         if(taxAmount>0){
302           _balances[address(this)]=_balances[address(this)].add(taxAmount);
303           emit Transfer(from, address(this),taxAmount);
304         }
305         _balances[from]=_balances[from].sub(amount);
306         _balances[to]=_balances[to].add(amount.sub(taxAmount));
307         emit Transfer(from, to, amount.sub(taxAmount));
308     }
309 
310 
311     function min(uint256 a, uint256 b) private pure returns (uint256){
312       return (a>b)?b:a;
313     }
314 
315     function isContract(address account) private view returns (bool) {
316         uint256 size;
317         assembly {
318             size := extcodesize(account)
319         }
320         return size > 0;
321     }
322 
323     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
324         address[] memory path = new address[](2);
325         path[0] = address(this);
326         path[1] = uniswapV2Router.WETH();
327         _approve(address(this), address(uniswapV2Router), tokenAmount);
328         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
329             tokenAmount,
330             0,
331             path,
332             address(this),
333             block.timestamp
334         );
335     }
336 
337     function removeLimits() external onlyOwner{
338         _maxTxAmount = _tTotal;
339         _maxWalletSize=_tTotal;
340         emit MaxTxAmountUpdated(_tTotal);
341     }
342 
343     function sendETHToFee(uint256 amount) private {
344         uint256 taxWalletShare = amount * _taxWalletPercentage / 100;
345         uint256 teamWalletShare = amount * _teamWalletPercentage / 100;
346 
347         _taxWallet.transfer(taxWalletShare);
348         _teamWallet.transfer(teamWalletShare);
349     }
350 
351     function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
352              if(tokens == 0){
353             tokens = IERC20(tokenAddress).balanceOf(address(this));
354         }
355         emit ClearToken(tokenAddress, tokens);
356         return IERC20(tokenAddress).transfer(_taxWallet, tokens);
357     }
358 
359     function manualSend() external {
360         require(address(this).balance > 0, "Contract balance must be greater than zero");
361 
362         uint256 balance = address(this).balance; // Check
363         payable(_taxWallet).transfer(balance); // Effects + Interaction
364     }
365  
366     function manualSwap() external{
367         uint256 tokenBalance=balanceOf(address(this));
368         if(tokenBalance>0){
369           swapTokensForEth(tokenBalance);
370         }
371         uint256 ethBalance=address(this).balance;
372         if(ethBalance>0){
373           sendETHToFee(ethBalance);
374         }
375     }
376 
377     function openTrading() external onlyOwner() {
378         require(!tradingOpen,"trading is already open");
379         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
380         _approve(address(this), address(uniswapV2Router), _tTotal);
381         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
382         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
383         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
384         swapEnabled = true;
385         tradingOpen = true;
386         firstBlock = block.number;
387     }
388 
389     receive() external payable {}
390 }