1 /**
2 */
3 
4 /*                                                                       
5                                                            @@@                  
6                                                           @@@@@@@@@             
7                      @@@@@@@@                                  @@@@@@@@%        
8                 @@@@@@@@@@@@                                         @@@@@      
9             @@@@@@,                                                      @@@    
10           @@@@                                                             @@   
11        /@@@@                                                  @@@@@@@@@@@@      
12      @@@@                                                  @@  @@@@@@@@@@@      
13     @@@              .@@@@@@@                               @@@@   @@@@@@@@@    
14     @         @@@@@                                        @@@@@   @@@@@@ @@@   
15            @@  @@@@@@@@@@@@@                              @@@@@@@ @@@@@@@ @&@@  
16            @@@     @@@@@@@@@@@                            @@ @@@@@@@@@@@@ @     
17         @@@@@@@@   @@@@@@@@@@@@@                         @@@ @@@@@@@@@@@  @     
18       @@@@  %@@@@@@@@@@@@@@@@@@@%                         @@  @@@@@@@@@@ @%     
19       @@  @  #@@@@@@@@@@@@@@@@ @@                         @@   @@@@@@@@  @      
20      @@   @@   @@@@@@@@@@@@@@  @@                          @@    @@@   @@       
21      @    @@@   @@@@@@@@@@@@   @@                            @@        @        
22             @@     @@@@@@     @@@                               @@@@@@ @@       
23              (@@            @@@                                                 
24                  @@@        @                                                   
25                 @@@@@@@@@/                                             
26 
27 Portal: https://t.me/remiliacorpport
28 
29 Website: https://remilia.site/
30 
31 Twitter: https://twitter.com/Remilia_erc20
32 
33 $REM                                 
34 */
35 
36 // SPDX-License-Identifier: MIT
37 pragma solidity 0.8.19;
38 
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 }
44 
45 interface IERC20 {
46     function totalSupply() external view returns (uint256);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor () {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 
118 }
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external;
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134     function addLiquidityETH(
135         address token,
136         uint amountTokenDesired,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline
141     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
142 }
143 
144 contract REM is Context, IERC20, Ownable {
145     using SafeMath for uint256;
146     mapping (address => uint256) private _balances;
147     mapping (address => mapping (address => uint256)) private _allowances;
148     mapping (address => bool) private _isExcludedFromFee;
149     address payable private _taxWallet;
150     uint256 firstBlock;
151 
152     uint256 private _initialBuyTax=20;
153     uint256 private _initialSellTax=20;
154     uint256 private _finalBuyTax=1;
155     uint256 private _finalSellTax=1;
156     uint256 private _reduceBuyTaxAt=50;
157     uint256 private _reduceSellTaxAt=50;
158     uint256 private _preventSwapBefore=30;
159     uint256 private _buyCount=0;
160 
161     uint8 private constant _decimals = 9;
162     uint256 private constant _tTotal = 9_988_776_655 * 10**_decimals;
163     string private constant _name = unicode"REMILIA";
164     string private constant _symbol = unicode"REM";
165     uint256 public _maxTxAmount =   49943883 * 10**_decimals;
166     uint256 public _maxWalletSize = 99887766 * 10**_decimals;
167     uint256 public _taxSwapThreshold= 0 * 10**_decimals;
168     uint256 public _maxTaxSwap= 99887766 * 10**_decimals;
169 
170     IUniswapV2Router02 private uniswapV2Router;
171     address private uniswapV2Pair;
172     bool private tradingOpen;
173     bool private inSwap = false;
174     bool private swapEnabled = false;
175 
176     event MaxTxAmountUpdated(uint _maxTxAmount);
177     modifier lockTheSwap {
178         inSwap = true;
179         _;
180         inSwap = false;
181     }
182 
183     constructor () {
184 
185         _taxWallet = payable(_msgSender());
186         _balances[_msgSender()] = _tTotal;
187         _isExcludedFromFee[owner()] = true;
188         _isExcludedFromFee[address(this)] = true;
189         _isExcludedFromFee[_taxWallet] = true;
190         
191         emit Transfer(address(0), _msgSender(), _tTotal);
192     }
193 
194     function name() public pure returns (string memory) {
195         return _name;
196     }
197 
198     function symbol() public pure returns (string memory) {
199         return _symbol;
200     }
201 
202     function decimals() public pure returns (uint8) {
203         return _decimals;
204     }
205 
206     function totalSupply() public pure override returns (uint256) {
207         return _tTotal;
208     }
209 
210     function balanceOf(address account) public view override returns (uint256) {
211         return _balances[account];
212     }
213 
214     function transfer(address recipient, uint256 amount) public override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     function allowance(address owner, address spender) public view override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     function approve(address spender, uint256 amount) public override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     function _approve(address owner, address spender, uint256 amount) private {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _transfer(address from, address to, uint256 amount) private {
242         require(from != address(0), "ERC20: transfer from the zero address");
243         require(to != address(0), "ERC20: transfer to the zero address");
244         require(amount > 0, "Transfer amount must be greater than zero");
245         uint256 taxAmount=0;
246         if (from != owner() && to != owner()) {
247             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
248 
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
250                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252 
253                 if (firstBlock + 3  > block.number) {
254                     require(!isContract(to));
255                 }
256                 _buyCount++;
257             }
258 
259             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
260                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
261             }
262 
263             if(to == uniswapV2Pair && from!= address(this) ){
264                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
265             }
266 
267             uint256 contractTokenBalance = balanceOf(address(this));
268             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
269                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
270                 uint256 contractETHBalance = address(this).balance;
271                 if(contractETHBalance > 0) {
272                     sendETHToFee(address(this).balance);
273                 }
274             }
275         }
276 
277         if(taxAmount>0){
278           _balances[address(this)]=_balances[address(this)].add(taxAmount);
279           emit Transfer(from, address(this),taxAmount);
280         }
281         _balances[from]=_balances[from].sub(amount);
282         _balances[to]=_balances[to].add(amount.sub(taxAmount));
283         emit Transfer(from, to, amount.sub(taxAmount));
284     }
285 
286 
287     function min(uint256 a, uint256 b) private pure returns (uint256){
288       return (a>b)?b:a;
289     }
290 
291     function isContract(address account) private view returns (bool) {
292         uint256 size;
293         assembly {
294             size := extcodesize(account)
295         }
296         return size > 0;
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
316         emit MaxTxAmountUpdated(_tTotal);
317     }
318 
319     function sendETHToFee(uint256 amount) private {
320         _taxWallet.transfer(amount);
321     }
322 
323     function openTrading() external onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         _approve(address(this), address(uniswapV2Router), _tTotal);
327         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
328         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330         swapEnabled = true;
331         tradingOpen = true;
332         firstBlock = block.number;
333     }
334 
335     receive() external payable {}
336 }