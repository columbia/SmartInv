1 /*
2 
3 
4                                       .:^:.              .^^:                                       
5                                     ^JPGPGPJ^         .!5GGPG57.                                    
6                                   .JGGY^.^YGGJ.      ~PGG7:.~PGP!                                   
7                                  :5GGJ     JGGP:    7GGG~    :PGG?                                  
8                                 .5GG5       5GGP:  7GGG7      ~GGG?                                 
9                                 YGGG~       ~GGG5 ~GGG5        JGGG!                                
10                                7GGGY         YGGGJ5GGG!        ^GGGP:                               
11                               :PGGG!         !GGGGGGGP.         YGGGJ                               
12                               ?GGGP:         .PGGGGGGJ          7GGGG:                              
13                              .PGGGY           YGGGGGG!          :GGGG?                              
14                              ~GGGG?           7GGGGGG:          .PGGGP.                             
15                              JGGGG~           ~GGGGGP.           YGGGG~                             
16                             .PGGGG:           :GGGGGY            ?GGGG?                             
17                             :GGGGP.           .PGGGGJ            !GGGGY                             
18                             ~GGGG5            .PGGGG?            ~GGGGP.                            
19                             7GGGG5             5GGGG7            ^GGGGP:                            
20                             ?GGGGY             YPPPG!            :GGGGG:                            
21                             ?GGGGY             .....             :GGGGG^                            
22                             :^^^^:                                ^^^^^.                            
23                                                                                                     
24 
25   
26   
27   
28 
29 Welcome to McD Coin!! We are Hiring! 
30 
31 0% Tax | Renounced
32 
33 https://mcdcoin.vip/
34 https://twitter.com/mcdcoin_eth
35 https://t.me/mcdcoin_eth
36 
37 
38 
39 */
40 // SPDX-License-Identifier: MIT
41 pragma solidity 0.8.17;
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 }
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         return c;
94     }
95 
96 }
97 
98 contract Ownable is Context {
99     address private _owner;
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     constructor () {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 }
147 contract McDCoin is Context , IERC20, Ownable {
148     using SafeMath for uint256;
149     mapping (address => uint256) private _balances;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     mapping (address => bool) private _isExcludedFromFee;
152     mapping (address => bool) private bots;
153     mapping(address => uint256) private _holderLastTransferTimestamp;
154     bool public transferDelayEnabled = true;
155     address payable private _taxWallet;
156 
157     uint256 private _initialBuyTax=20;
158     uint256 private _initialSellTax=40;
159     uint256 private _finalBuyTax=0;
160     uint256 private _finalSellTax=0;
161     uint256 private _reduceBuyTaxAt=20;
162     uint256 private _reduceSellTaxAt=40;
163     uint256 private _preventSwapBefore=30;
164     uint256 private _buyCount=0;
165 
166     uint8 private constant _decimals = 9;
167     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
168     string private constant _name = unicode"Just Gonna Work At McD";
169     string private constant _symbol = unicode"McD";
170     uint256 public _maxTxAmount = 4206900000000 * 10**_decimals;
171     uint256 public _maxWalletSize = 4206900000000 * 10**_decimals;
172     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
173     uint256 public _maxTaxSwap= 4206900000000 * 10**_decimals;
174 
175     IUniswapV2Router02 private uniswapV2Router;
176     address private uniswapV2Pair;
177     bool private tradingOpen;
178     bool private inSwap = false;
179     bool private swapEnabled = false;
180 
181     event MaxTxAmountUpdated(uint _maxTxAmount);
182     modifier lockTheSwap {
183         inSwap = true;
184         _;
185         inSwap = false;
186     }
187 
188     constructor () {
189         _taxWallet = payable(_msgSender());
190         _balances[_msgSender()] = _tTotal;
191         _isExcludedFromFee[owner()] = true;
192         _isExcludedFromFee[address(this)] = true;
193         _isExcludedFromFee[_taxWallet] = true;
194 
195         emit Transfer(address(0), _msgSender(), _tTotal);
196     }
197 
198     function name() public pure returns (string memory) {
199         return _name;
200     }
201 
202     function symbol() public pure returns (string memory) {
203         return _symbol;
204     }
205 
206     function decimals() public pure returns (uint8) {
207         return _decimals;
208     }
209 
210     function totalSupply() public pure override returns (uint256) {
211         return _tTotal;
212     }
213 
214     function balanceOf(address account) public view override returns (uint256) {
215         return _balances[account];
216     }
217 
218     function transfer(address recipient, uint256 amount) public override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     function allowance(address owner, address spender) public view override returns (uint256) {
224         return _allowances[owner][spender];
225     }
226 
227     function approve(address spender, uint256 amount) public override returns (bool) {
228         _approve(_msgSender(), spender, amount);
229         return true;
230     }
231 
232     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
233         _transfer(sender, recipient, amount);
234         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
235         return true;
236     }
237 
238     function _approve(address owner, address spender, uint256 amount) private {
239         require(owner != address(0), "ERC20: approve from the zero address");
240         require(spender != address(0), "ERC20: approve to the zero address");
241         _allowances[owner][spender] = amount;
242         emit Approval(owner, spender, amount);
243     }
244 
245     function _transfer(address from, address to, uint256 amount) private {
246         require(from != address(0), "ERC20: transfer from the zero address");
247         require(to != address(0), "ERC20: transfer to the zero address");
248         require(amount > 0, "Transfer amount must be greater than zero");
249         uint256 taxAmount=0;
250         if (from != owner() && to != owner()) {
251             require(!bots[from] && !bots[to]);
252             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
253 
254             if (transferDelayEnabled) {
255                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
256                       require(
257                           _holderLastTransferTimestamp[tx.origin] <
258                               block.number,
259                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
260                       );
261                       _holderLastTransferTimestamp[tx.origin] = block.number;
262                   }
263               }
264 
265             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
266                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
267                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
268                 _buyCount++;
269             }
270 
271             if(to == uniswapV2Pair && from!= address(this) ){
272                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
273             }
274 
275             uint256 contractTokenBalance = balanceOf(address(this));
276             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
277                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
278                 uint256 contractETHBalance = address(this).balance;
279                 if(contractETHBalance > 0) {
280                     sendETHToFee(address(this).balance);
281                 }
282             }
283         }
284 
285         if(taxAmount>0){
286           _balances[address(this)]=_balances[address(this)].add(taxAmount);
287           emit Transfer(from, address(this),taxAmount);
288         }
289         _balances[from]=_balances[from].sub(amount);
290         _balances[to]=_balances[to].add(amount.sub(taxAmount));
291         emit Transfer(from, to, amount.sub(taxAmount));
292     }
293 
294 
295     function min(uint256 a, uint256 b) private pure returns (uint256){
296       return (a>b)?b:a;
297     }
298 
299     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
300         address[] memory path = new address[](2);
301         path[0] = address(this);
302         path[1] = uniswapV2Router.WETH();
303         _approve(address(this), address(uniswapV2Router), tokenAmount);
304         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
305             tokenAmount,
306             0,
307             path,
308             address(this),
309             block.timestamp
310         );
311     }
312 
313     function removeLimits() external onlyOwner{
314         _maxTxAmount = _tTotal;
315         _maxWalletSize=_tTotal;
316         transferDelayEnabled=false;
317         emit MaxTxAmountUpdated(_tTotal);
318     }
319 
320     function sendETHToFee(uint256 amount) private {
321         _taxWallet.transfer(amount);
322     }
323 
324     function addBots(address[] memory bots_) public onlyOwner {
325         for (uint i = 0; i < bots_.length; i++) {
326             bots[bots_[i]] = true;
327         }
328     }
329 
330     function delBots(address[] memory notbot) public onlyOwner {
331       for (uint i = 0; i < notbot.length; i++) {
332           bots[notbot[i]] = false;
333       }
334     }
335 
336     function isBot(address a) public view returns (bool){
337       return bots[a];
338     }
339 
340     function openTrading() external onlyOwner() {
341         require(!tradingOpen,"trading is already open");
342         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
343         _approve(address(this), address(uniswapV2Router), _tTotal);
344         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
345         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
346         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
347         swapEnabled = true;
348         tradingOpen = true;
349     }
350 
351     
352     function reduceFee(uint256 _newFee) external{
353       require(_msgSender()==_taxWallet);
354       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
355       _finalBuyTax=_newFee;
356       _finalSellTax=_newFee;
357     }
358 
359     receive() external payable {}
360 
361     function manualSwap() external {
362         require(_msgSender()==_taxWallet);
363         uint256 tokenBalance=balanceOf(address(this));
364         if(tokenBalance>0){
365           swapTokensForEth(tokenBalance);
366         }
367         uint256 ethBalance=address(this).balance;
368         if(ethBalance>0){
369           sendETHToFee(ethBalance);
370         }
371     }
372 }