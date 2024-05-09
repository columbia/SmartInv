1 /**
2                             ##############################                         
3                             ,##############################                         
4                             ,############### ,( (##########                         
5         &.################################.##*(################                   
6         &.################################.##*(################                   
7         &.#####################################################                   
8                     #......&&&&&&.............(################                   
9                     #......&&&&&&.............(################                   
10         & .................&&&&&&..................######......######&            
11         & .................&&&&&&..................######......######&            
12     & .................&&&&&&.................*############......######&            
13     & .................&&&&&&.................*############......######&            
14     & .................&&&&&&.................*############......######&            
15         &,&&&&&&&&&&&&&&&&&&&&&&&........................######                   
16         &,&&&&&&&&&&&&&&&&&&&&&&&........................######                   
17         &&&&&&&&&&&#.................................... &&&&&(                  
18                     #....................................                         
19                 &################################################                   
20                 &################################################                   
21         &,,,,,,################################################ ,,,,,&            
22         &.################&&&&&&&####################################&            
23     ,,,,&.############&&&&&&&&&&&&&&&#######################&#  ..... .&&         
24     & #################&&&&&&&&&&&&&&&&&&#################&  ...........,,,,.*&     
25     & ################&&&&&&&  &  &&&  &&&#############&／    .*／／,,,,,,,／／.,,*, &   
26     & ...........#####&&       &  &&&  &&&#####／.....#&    **,,,,／.／..／,,,**／*,,,／& 
27     & ...........#####&&       &       &&######／.....& ...**,,,....**,...／****.,,,／&
28     & ...........######&&&&&&&&&&&&&&&&&#######／.....#...*／,,,,,／..／,,*.*／*****,,, (
29     & .................##&&&&&&&&&&&&&################...**,,***／..／／／／..／*****,,,.／
30     & .................##############################&....／,****／.,／**／..／****.,..／&
31     & ...........######################################,,,,／***／／／.／*,／／*****....／(／
32     & ...........######################################& ,,,,／************* ....／&  
33     ／            ##################            ／#########&／,,,,,,,.....,,....,／&.   
34                 &##################(          &／############&／／,,,,,.....**／&#      
35         #(／／／／／##################(          &／#################*&&&&&&            
36         &.#################                       &##################&            
37         &.#################                       &##################&            
38     & #######################                       &#######################&       
39     & #######################                       &#######################&       
40     ／                       &                      &                       &
41 
42     GandalfTrumpMario86Pepe ($COSMOS)
43 
44     Website:  https://gtm86p.com
45     Twitter:  https://twitter.com/gtm86p
46     Telegram: http://t.me/gtm86p
47 
48     GTM86P is an innovative ERC20 token project originating from a community, aiming to revolutionize the blockchain system by breaking decentralization barriers. 
49 Inspired by the courage of Gandalf, the business acumen of Trump, the determination of Mario, and the wisdom of PEPE, 
50 GTM86P is committed to enhancing transaction speeds and unlocking infinite potential.
51 Our heroes symbolize our dedication to technological advancement, improvement of user experience, and overcoming challenges. 
52 The emergence of '86' marks a new era filled with upgraded technology and unbounded potential.
53 Join our GTM86P community, a world full of passion, fiery innovation, and a shared bright future.
54 
55 **/
56 
57 // SPDX-License-Identifier: MIT
58 
59 pragma solidity ^0.8.15;
60 
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
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
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
115 
116 }
117 
118 contract Ownable is Context {
119     address private _owner;
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121     constructor () {
122         address msgSender = _msgSender();
123         _owner = msgSender;
124         emit OwnershipTransferred(address(0), msgSender);
125     }
126     function owner() public view returns (address) {
127         return _owner;
128     }
129     modifier onlyOwner() {
130         require(_owner == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133     function renounceOwnership() public virtual onlyOwner {
134         emit OwnershipTransferred(_owner, address(0));
135         _owner = address(0);
136     }
137 
138 }
139 
140 interface IUniFactory {
141     function createPair(address tokenA, address tokenB) external returns (address pair);
142     function getPair(address tokenA, address tokenB) external returns (address pair);
143 }
144 
145 interface IUniRouter {
146     function factoryV2() external pure returns (address);
147     function factory() external pure returns (address);
148     function WETH() external pure returns (address);
149     
150     function swapExactTokensForTokens(
151         uint amountIn,
152         uint amountOutMin,
153         address[] calldata path,
154         address to
155     ) external;
156     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163     function swapExactETHForTokensSupportingFeeOnTransferTokens(
164         uint256 amountOutMin,
165         address[] calldata path,
166         address to,
167         uint256 deadline
168     ) external payable;
169     function swapExactTokensForETHSupportingFeeOnTransferTokens(
170         uint amountIn,
171         uint amountOutMin,
172         address[] calldata path,
173         address to,
174         uint deadline
175     ) external;
176 
177     function addLiquidity(
178         address tokenA,
179         address tokenB,
180         uint amountADesired,
181         uint amountBDesired,
182         uint amountAMin,
183         uint amountBMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountA, uint amountB, uint liquidity);
187     function addLiquidityETH(
188         address token,
189         uint amountTokenDesired,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline
194     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
195 }
196 
197 contract Gtm86p is Context, IERC20, Ownable {
198 
199     using SafeMath for uint256;
200 
201     mapping (address => uint256) private _balances;
202     mapping (address => mapping (address => uint256)) private _allowances;
203     mapping (address => bool) private _isExcludedFromFee;
204     mapping(address => uint256) private _holderLastTransferTimestamp;
205 
206     IUniRouter private _uniRouter;
207     address private _uniPair;
208     address payable private _taxWallet;
209 
210     bool public transferDelayEnabled = true;
211     uint256 public finalBuyTax = 1;
212     uint256 public finalSellTax = 1;
213     uint256 private _initialBuyTax = 15;
214     uint256 private _initialSellTax = 30;
215     uint256 private _reduceBuyTaxAt = 30;
216     uint256 private _reduceSellTaxAt = 86;
217     uint256 private _preventSwapBefore = 30;
218     uint256 private _buyCount = 0;
219 
220     string private constant _name = "GandalfTrumpMario86Pepe";
221     string private constant _symbol = "COSMOS";
222     uint8 private constant _decimals = 18;
223     uint256 private constant _tTotal = 860_000_000_000_000 * 10 ** _decimals;
224 
225     bool private _tradingOpen;
226     uint256 public maxWalletSize = _tTotal * 2 / 100;
227     uint256 public maxTxAmount = _tTotal * 2 / 100;
228     uint256 private _taxSwapThreshold = _tTotal * 5 / 1000;
229     uint256 private _maxTaxSwap = _tTotal * 5 / 1000;
230     bool private _inSwap = false;
231     bool private _swapEnabled = false;
232 
233     modifier lockTheSwap {
234         _inSwap = true;
235         _;
236         _inSwap = false;
237     }
238 
239     constructor () {
240         _taxWallet = payable(_msgSender());
241         _balances[address(this)] = _tTotal;
242         _isExcludedFromFee[owner()] = true;
243         _isExcludedFromFee[address(this)] = true;
244         _uniRouter = IUniRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
245         _approve(address(this), address(_uniRouter), type(uint256).max);
246         _approve(address(this), address(this), type(uint256).max);
247         _uniPair = IUniFactory(_uniRouter.factory()).createPair(address(this), _uniRouter.WETH());
248         emit Transfer(address(0), address(this), _tTotal);
249     }
250 
251     function name() public pure returns (string memory) {
252         return _name;
253     }
254 
255     function symbol() public pure returns (string memory) {
256         return _symbol;
257     }
258 
259     function decimals() public pure returns (uint8) {
260         return _decimals;
261     }
262 
263     function totalSupply() public pure override returns (uint256) {
264         return _tTotal;
265     }
266 
267     function balanceOf(address account) public view override returns (uint256) {
268         return _balances[account];
269     }
270 
271     function transfer(address recipient, uint256 amount) public override returns (bool) {
272         _transfer(_msgSender(), recipient, amount);
273         return true;
274     }
275 
276     function allowance(address owner, address spender) public view override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     function approve(address spender, uint256 amount) public override returns (bool) {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
286         _transfer(sender, recipient, amount);
287         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
288         return true;
289     }
290 
291     function _approve(address owner, address spender, uint256 amount) private {
292         require(owner != address(0), "ERC20: approve from the zero address");
293         require(spender != address(0), "ERC20: approve to the zero address");
294         _allowances[owner][spender] = amount;
295         emit Approval(owner, spender, amount);
296     }
297 
298     function _transfer(address from, address to, uint256 amount) private {
299         require(from != address(0), "ERC20: transfer from the zero address");
300         require(to != address(0), "ERC20: transfer to the zero address");
301         require(amount > 0, "Transfer amount must be greater than zero");
302 
303         uint256 taxAmount = 0;
304 
305         if (from != owner() && to != owner()) {
306 
307             if (transferDelayEnabled) {
308                 if (to != address(_uniRouter) && to != address(_uniPair)) {
309                   require(_holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed.");
310                   _holderLastTransferTimestamp[tx.origin] = block.number;
311                 }
312             }
313 
314             if (from == _uniPair && to != address(_uniRouter) && !_isExcludedFromFee[to] ) {
315                 require(_tradingOpen, "not open pls wait");
316                 require(amount <= maxTxAmount, "Exceeds the maxTxAmount.");
317                 require(balanceOf(to) + amount <= maxWalletSize, "Exceeds the maxWalletSize.");
318                 _buyCount++;
319             }
320 
321             taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? finalBuyTax : _initialBuyTax).div(100);
322             if (to == _uniPair && from != address(this) ){
323                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt) ? finalSellTax : _initialSellTax).div(100);
324             }
325 
326             uint256 contractTokenBalance = balanceOf(address(this));
327             if (!_inSwap && to == _uniPair && _swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
328                 _swapTokensForEth(_min(amount, _min(contractTokenBalance, _maxTaxSwap)));
329                 uint256 contractETHBalance = address(this).balance;
330                 if (contractETHBalance > 0) {
331                     _sendETHToFee(address(this).balance);
332                 }
333             }
334         }
335 
336         if (taxAmount > 0) {
337           _balances[address(this)] = _balances[address(this)].add(taxAmount);
338           emit Transfer(from, address(this), taxAmount);
339         }
340 
341         _balances[from] = _balances[from].sub(amount);
342         _balances[to] = _balances[to].add(amount.sub(taxAmount));
343         emit Transfer(from, to, amount.sub(taxAmount));
344     }
345 
346     function _min(uint256 a, uint256 b) private pure returns (uint256){
347         return (a>b)?b:a;
348     }
349 
350     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
351         if (tokenAmount == 0) {return;}
352         if (!_tradingOpen) {return;}
353         address[] memory path = new address[](2);
354         path[0] = address(this);
355         path[1] = _uniRouter.WETH();
356         _approve(address(this), address(_uniRouter), tokenAmount);
357         _uniRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
358             tokenAmount,
359             0,
360             path,
361             address(this),
362             block.timestamp
363         );
364     }
365 
366     function _sendETHToFee(uint256 amount) private {
367         _taxWallet.transfer(amount);
368     }
369 
370     function removeLimits() public onlyOwner{
371         maxTxAmount = _tTotal;
372         maxWalletSize = _tTotal;
373         transferDelayEnabled = false;
374         _reduceSellTaxAt = 1;
375         _reduceBuyTaxAt = 1;
376     }
377 
378     function letsAGo() external onlyOwner() {
379         require(!_tradingOpen, "Already open");
380         _uniRouter.addLiquidityETH{value: 1 ether}(address(this), balanceOf(address(this)), 0, 0, _msgSender(), block.timestamp);
381         _swapEnabled = true;
382         _tradingOpen = true;
383     }
384 
385     receive() external payable {}
386 
387     function manualSwap() external {
388         require(_msgSender() == _taxWallet);
389         uint256 tokenBalance = balanceOf(address(this));
390         if (tokenBalance > 0){
391             _swapTokensForEth(tokenBalance);
392         }
393         uint256 ethBalance = address(this).balance;
394         if (ethBalance > 0){
395             _sendETHToFee(ethBalance);
396         }
397     }
398 }