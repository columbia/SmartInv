1 /**
2 
3 TWITTER: https://twitter.com/ASTROLcoin
4 TELEGRAM: https://t.me/ASTROLPORTAL
5 
6 ELON REPLIED TO THIS TWEET: https://twitter.com/stclairashley/status/1659997215643914243?s=20
7 "Shit coins are like astrology for men"
8 https://twitter.com/elonmusk/status/1660012919344513024?s=20
9 
10 @@ Signs of the Zodiac @@  11/96  (c)jgs
11 
12    .-.   .-.
13   (_  \ /  _)    Aries-  The Ram
14        |
15        |
16 
17     .     .
18     '.___.'
19 
20     .'   `.      Taurus-  The Bull
21    :       :
22    :       :
23     `.___.'
24 
25     ._____.
26       | |        Gemini-  The Twins
27       | |
28      _|_|_
29     '     '
30 
31       .--.
32      /   _`.     Cancer-  The Crab
33     (_) ( )
34    '.    /
35      `--'
36 
37       .--.
38      (    )       Leo-  The Lion
39     (_)  /
40         (_,
41 
42    _
43   ' `:--.--.
44      |  |  |_     Virgo-  The Virgin
45      |  |  | )
46      |  |  |/
47           (J
48 
49         __
50    ___.'  '.___   Libra-  The Balance
51    ____________
52 
53 
54    _
55   ' `:--.--.
56      |  |  |      Scorpius-  The Scorpion
57      |  |  |
58      |  |  |  ..,
59            `---':
60 
61           ...
62           .':     Sagittarius-  The Archer
63         .'
64     `..'
65     .'`.
66 
67             _
68     \      /_)    Capricorn-  The Goat
69      \    /`.
70       \  /   ;
71        \/ __.'
72 
73 
74 
75  .-"-._.-"-._.-   Aquarius-  The Water Bearer
76  .-"-._.-"-._.-
77 
78 
79 
80      `-.    .-'   Pisces-  The Fishes
81         :  :
82       --:--:--
83         :  :
84      .-'    `-.
85 **/
86 
87 pragma solidity 0.8.17;
88 
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 }
94 
95 interface IERC20 {
96     function totalSupply() external view returns (uint256);
97     function balanceOf(address account) external view returns (uint256);
98     function transfer(address recipient, uint256 amount) external returns (bool);
99     function allowance(address owner, address spender) external view returns (uint256);
100     function approve(address spender, uint256 amount) external returns (bool);
101     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 library SafeMath {
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110         return c;
111     }
112 
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return sub(a, b, "SafeMath: subtraction overflow");
115     }
116 
117     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120         return c;
121     }
122 
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         if (a == 0) {
125             return 0;
126         }
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129         return c;
130     }
131 
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         uint256 c = a / b;
139         return c;
140     }
141 
142 }
143 
144 contract Ownable is Context {
145     address private _owner;
146     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
147 
148     constructor () {
149         address msgSender = _msgSender();
150         _owner = msgSender;
151         emit OwnershipTransferred(address(0), msgSender);
152     }
153 
154     function owner() public view returns (address) {
155         return _owner;
156     }
157 
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     function renounceOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));
165         _owner = address(0);
166     }
167 
168 }
169 
170 interface IUniswapV2Factory {
171     function createPair(address tokenA, address tokenB) external returns (address pair);
172 }
173 
174 interface IUniswapV2Router02 {
175     function swapExactTokensForETHSupportingFeeOnTransferTokens(
176         uint amountIn,
177         uint amountOutMin,
178         address[] calldata path,
179         address to,
180         uint deadline
181     ) external;
182     function factory() external pure returns (address);
183     function WETH() external pure returns (address);
184     function addLiquidityETH(
185         address token,
186         uint amountTokenDesired,
187         uint amountTokenMin,
188         uint amountETHMin,
189         address to,
190         uint deadline
191     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
192 }
193 
194 contract ASTROL is Context, IERC20, Ownable {
195     using SafeMath for uint256;
196     mapping (address => uint256) private _balances;
197     mapping (address => mapping (address => uint256)) private _allowances;
198     mapping (address => bool) private _isExcludedFromFee;
199     mapping (address => bool) private bots;
200     mapping(address => uint256) private _holderLastTransferTimestamp;
201     bool public transferDelayEnabled = true;
202     address payable private _taxWallet;
203 
204     uint256 private _initialBuyTax=20;
205     uint256 private _initialSellTax=20;
206     uint256 private _finalBuyTax=0;
207     uint256 private _finalSellTax=0;
208     uint256 private _reduceBuyTaxAt=15;
209     uint256 private _reduceSellTaxAt=25;
210     uint256 private _preventSwapBefore=20;
211     uint256 private _buyCount=0;
212 
213     uint8 private constant _decimals = 9;
214     uint256 private constant _tTotal = 420690000000 * 10**_decimals;
215     string private constant _name = unicode"ASTROLOGY"; 
216     string private constant _symbol = unicode"ASTROL"; 
217     uint256 public _maxTxAmount =   8400000000 * 10**_decimals;
218     uint256 public _maxWalletSize = 8400000000 * 10**_decimals;
219     uint256 public _taxSwapThreshold= 4200000000 * 10**_decimals;
220     uint256 public _maxTaxSwap= 4200000000 * 10**_decimals;
221 
222     IUniswapV2Router02 private uniswapV2Router;
223     address private uniswapV2Pair;
224     bool private tradingOpen;
225     bool private inSwap = false;
226     bool private swapEnabled = false;
227 
228     event MaxTxAmountUpdated(uint _maxTxAmount);
229     modifier lockTheSwap {
230         inSwap = true;
231         _;
232         inSwap = false;
233     }
234 
235     constructor () {
236         _taxWallet = payable(_msgSender());
237         _balances[_msgSender()] = _tTotal;
238         _isExcludedFromFee[owner()] = true;
239         _isExcludedFromFee[address(this)] = true;
240         _isExcludedFromFee[_taxWallet] = true;
241 
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244 
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256 
257     function totalSupply() public pure override returns (uint256) {
258         return _tTotal;
259     }
260 
261     function balanceOf(address account) public view override returns (uint256) {
262         return _balances[account];
263     }
264 
265     function transfer(address recipient, uint256 amount) public override returns (bool) {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     function allowance(address owner, address spender) public view override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     function approve(address spender, uint256 amount) public override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
280         _transfer(sender, recipient, amount);
281         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
282         return true;
283     }
284 
285     function _approve(address owner, address spender, uint256 amount) private {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288         _allowances[owner][spender] = amount;
289         emit Approval(owner, spender, amount);
290     }
291 
292     function _transfer(address from, address to, uint256 amount) private {
293         require(from != address(0), "ERC20: transfer from the zero address");
294         require(to != address(0), "ERC20: transfer to the zero address");
295         require(amount > 0, "Transfer amount must be greater than zero");
296         uint256 taxAmount=0;
297         if (from != owner() && to != owner()) {
298             require(!bots[from] && !bots[to]);
299             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
300 
301             if (transferDelayEnabled) {
302                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
303                       require(
304                           _holderLastTransferTimestamp[tx.origin] <
305                               block.number,
306                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
307                       );
308                       _holderLastTransferTimestamp[tx.origin] = block.number;
309                   }
310               }
311 
312             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
313                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
314                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
315                 _buyCount++;
316             }
317 
318             if(to == uniswapV2Pair && from!= address(this) ){
319                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
320             }
321 
322             uint256 contractTokenBalance = balanceOf(address(this));
323             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
324                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
325                 uint256 contractETHBalance = address(this).balance;
326                 if(contractETHBalance > 0) {
327                     sendETHToFee(address(this).balance);
328                 }
329             }
330         }
331 
332         if(taxAmount>0){
333           _balances[address(this)]=_balances[address(this)].add(taxAmount);
334           emit Transfer(from, address(this),taxAmount);
335         }
336         _balances[from]=_balances[from].sub(amount);
337         _balances[to]=_balances[to].add(amount.sub(taxAmount));
338         emit Transfer(from, to, amount.sub(taxAmount));
339     }
340 
341 
342     function min(uint256 a, uint256 b) private pure returns (uint256){
343       return (a>b)?b:a;
344     }
345 
346     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
347         address[] memory path = new address[](2);
348         path[0] = address(this);
349         path[1] = uniswapV2Router.WETH();
350         _approve(address(this), address(uniswapV2Router), tokenAmount);
351         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
352             tokenAmount,
353             0,
354             path,
355             address(this),
356             block.timestamp
357         );
358     }
359 
360     function removeLimits() external onlyOwner{
361         _maxTxAmount = _tTotal;
362         _maxWalletSize=_tTotal;
363         transferDelayEnabled=false;
364         emit MaxTxAmountUpdated(_tTotal);
365     }
366 
367     function sendETHToFee(uint256 amount) private {
368         _taxWallet.transfer(amount);
369     }
370 
371     function addBots(address[] memory bots_) public onlyOwner {
372         for (uint i = 0; i < bots_.length; i++) {
373             bots[bots_[i]] = true;
374         }
375     }
376 
377     function delBots(address[] memory notbot) public onlyOwner {
378       for (uint i = 0; i < notbot.length; i++) {
379           bots[notbot[i]] = false;
380       }
381     }
382 
383     function isBot(address a) public view returns (bool){
384       return bots[a];
385     }
386 
387     function openTrading() external onlyOwner() {
388         require(!tradingOpen,"trading is already open");
389         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390         _approve(address(this), address(uniswapV2Router), _tTotal);
391         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
392         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
393         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
394         swapEnabled = true;
395         tradingOpen = true;
396     }
397 
398     
399     function reduceFee(uint256 _newFee) external{
400       require(_msgSender()==_taxWallet);
401       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
402       _finalBuyTax=_newFee;
403       _finalSellTax=_newFee;
404     }
405 
406     receive() external payable {}
407 
408     function manualSwap() external {
409         require(_msgSender()==_taxWallet);
410         uint256 tokenBalance=balanceOf(address(this));
411         if(tokenBalance>0){
412           swapTokensForEth(tokenBalance);
413         }
414         uint256 ethBalance=address(this).balance;
415         if(ethBalance>0){
416           sendETHToFee(ethBalance);
417         }
418     }
419 }