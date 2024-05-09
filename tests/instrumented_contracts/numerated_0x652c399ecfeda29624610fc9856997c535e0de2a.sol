1 /*
2 
3 Autism only
4 Telegram: https://t.me/HPOPM8INU
5 Website:  https://hpop8i.org/
6 Twitter:  https://twitter.com/HPOPM8INU
7 
8 
9                      .:^^~!!!!!~~^:.              
10                 :~7Y5GGBBB#####BBBBGPY?~:         
11             .~?PB#####BBBBBBBBBBBBB#####BPJ~.     
12           ^JG###BBBBBBBBBBBBBBBBBBBBBBBBB###GJ~.  
13         ~5B##BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB##B7  
14       ^5##BBBBBBBBBBBBBBBBB####BBBBBBBBBBB##G?:   
15      7B#BBBBBBBBBBBBBBBBBBBPJJ5BBBBBBBBB##P!.     
16     Y#BBBBBBBBBBBBBBBBBBB#!    ~BBBBB##BY~        
17    Y#BBBBBBBBBBBBBBBBBBBB#?    !BBB##G?:          
18   7#BBBBBBBBBBBBBBBBBBBBBB#G55PBB##P7.            
19  .G#BBBBBBBBBBBBBBBBBBBBBBB#####BY~               
20  !#BBBBBBBBBBBBBBBBBBBBBBBBB##GJ:                 
21  J#BBBBBBBBBBBBBBBBBBBBBBBBBP7.                   
22  Y#BBBBBBBBBBBBBBBBBBBBBBBBB7                     
23  ?#BBBBBBBBBBBBBBBBBBBBBBBBB#P!                   
24  ^BBBBBBBBBBBBBBBBBBBBBBBBBBB##P~                 
25   Y#BBBBBBBBBBBBBBBBBBBBBBBBBBB##5~               
26   :G#BBBBBBBBBBBBBBBBBBBBBBBBBBBB##5~             
27    ^G#BBBBBBBBBBBBBBBBBBBBBBBBBBBBB#B5^           
28     :P#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#BY^         
29      .JB#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#BY:       
30        ^5B#BBBBBBBBBBBBBBBBBBBBBBBBBBBBBB#BJ:     
31          ^JG###BBBBBBBBBBBBBBBBBBBBBBBBBBB##B?    
32            .!YG####BBBBBBBBBBBBBBBBBBB####B57:    
33               .~?5GB#################BG5?~.       
34                    :^!7JYY555555YJ?!~:.           
35                                         
36 
37 */
38 // SPDX-License-Identifier: MIT
39 
40 
41 pragma solidity 0.8.20;
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
57     event Approval (address indexed owner, address indexed spender, uint256 value);
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
147 
148 contract Hpopm8i is Context, IERC20, Ownable {
149     using SafeMath for uint256;
150     mapping (address => uint256) private _balances;
151     mapping (address => mapping (address => uint256)) private _allowances;
152     mapping (address => bool) private _isExcludedFromFee;
153     mapping (address => bool) private bots;
154     address payable private _taxWallet;
155     uint256 firstBlock;
156 
157     uint256 private _initialBuyTax=20;
158     uint256 private _initialSellTax=20;
159     uint256 private _finalBuyTax=2;
160     uint256 private _finalSellTax=2;
161     uint256 private _reduceBuyTaxAt=10;
162     uint256 private _reduceSellTaxAt=20;
163     uint256 private _preventSwapBefore=60;
164     uint256 private _buyCount=0;
165 
166     uint8 private constant _decimals = 9;
167     uint256 private constant _tTotal = 100000000 * 10**_decimals;
168     string private constant _name = unicode"HarryPotterObamaPacMan8Inu";
169     string private constant _symbol = unicode"RIPPLE";
170     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
171     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
172     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
173     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
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
189 
190         _taxWallet = payable(_msgSender());
191         _balances[_msgSender()] = _tTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[_taxWallet] = true;
195 
196         emit Transfer(address(0), _msgSender(), _tTotal);
197     }
198 
199     function name() public pure returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public pure returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public pure returns (uint8) {
208         return _decimals;
209     }
210 
211     function totalSupply() public pure override returns (uint256) {
212         return _tTotal;
213     }
214 
215     function balanceOf(address account) public view override returns (uint256) {
216         return _balances[account];
217     }
218 
219     function transfer(address recipient, uint256 amount) public override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender) public view override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     function approve(address spender, uint256 amount) public override returns (bool) {
229         _approve(_msgSender(), spender, amount);
230         return true;
231     }
232 
233     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
236         return true;
237     }
238 
239     function _approve(address owner, address spender, uint256 amount) private {
240         require(owner != address(0), "ERC20: approve from the zero address");
241         require(spender != address(0), "ERC20: approve to the zero address");
242         _allowances[owner][spender] = amount;
243         emit Approval(owner, spender, amount);
244     }
245 
246     function _transfer(address from, address to, uint256 amount) private {
247         require(from != address(0), "ERC20: transfer from the zero address");
248         require(to != address(0), "ERC20: transfer to the zero address");
249         require(amount > 0, "Transfer amount must be greater than zero");
250         uint256 taxAmount=0;
251         if (from != owner() && to != owner()) {
252             require(!bots[from] && !bots[to]);
253             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
254 
255             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
256                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
257                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
258 
259                 if (firstBlock + 3  > block.number) {
260                     require(!isContract(to));
261                 }
262                 _buyCount++;
263             }
264 
265             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
266                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
267             }
268 
269             if(to == uniswapV2Pair && from!= address(this) ){
270                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
271             }
272 
273             uint256 contractTokenBalance = balanceOf(address(this));
274             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
275                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
276                 uint256 contractETHBalance = address(this).balance;
277                 if(contractETHBalance > 0) {
278                     sendETHToFee(address(this).balance);
279                 }
280             }
281         }
282 
283         if(taxAmount>0){
284           _balances[address(this)]=_balances[address(this)].add(taxAmount);
285           emit Transfer(from, address(this),taxAmount);
286         }
287         _balances[from]=_balances[from].sub(amount);
288         _balances[to]=_balances[to].add(amount.sub(taxAmount));
289         emit Transfer(from, to, amount.sub(taxAmount));
290     }
291 
292 
293     function min(uint256 a, uint256 b) private pure returns (uint256){
294       return (a>b)?b:a;
295     }
296 
297     function isContract(address account) private view returns (bool) {
298         uint256 size;
299         assembly {
300             size := extcodesize(account)
301         }
302         return size > 0;
303     }
304 
305     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
306         address[] memory path = new address[](2);
307         path[0] = address(this);
308         path[1] = uniswapV2Router.WETH();
309         _approve(address(this), address(uniswapV2Router), tokenAmount);
310         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
311             tokenAmount,
312             0,
313             path,
314             address(this),
315             block.timestamp
316         );
317     }
318 
319     function removeLimits() external onlyOwner{
320         _maxTxAmount = _tTotal;
321         _maxWalletSize=_tTotal;
322         emit MaxTxAmountUpdated(_tTotal);
323     }
324 
325     function sendETHToFee(uint256 amount) private {
326         _taxWallet.transfer(amount);
327     }
328 
329     function addBots(address[] memory bots_) public onlyOwner {
330         for (uint i = 0; i < bots_.length; i++) {
331             bots[bots_[i]] = true;
332         }
333     }
334 
335     function delBots(address[] memory notbot) public onlyOwner {
336       for (uint i = 0; i < notbot.length; i++) {
337           bots[notbot[i]] = false;
338       }
339     }
340 
341     function isBot(address a) public view returns (bool){
342       return bots[a];
343     }
344 
345     function openTrading() external onlyOwner() {
346         require(!tradingOpen,"trading is already open");
347         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
348         _approve(address(this), address(uniswapV2Router), _tTotal);
349         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
350         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
351         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
352         swapEnabled = true;
353         tradingOpen = true;
354         firstBlock = block.number;
355     }
356 
357     receive() external payable {}
358 
359 }