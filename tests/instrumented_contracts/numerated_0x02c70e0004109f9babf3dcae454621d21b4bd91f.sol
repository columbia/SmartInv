1 /**
2 
3  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄       ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄    ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄ 
4 ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌
5 ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀      ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌     ▐░▌▐░▌ ▐░▌ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌
6 ▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌               ▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌▐░▌    ▐░▌▐░▌▐░▌  ▐░▌          ▐░▌       ▐░▌
7 ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌ ▄▄▄▄▄▄▄▄      ▐░▌     ▐░▌               ▐░▌ ▐░▐░▌ ▐░▌▐░▌       ▐░▌▐░▌ ▐░▌   ▐░▌▐░▌░▌   ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌
8 ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌▐░░░░░░░░▌     ▐░▌     ▐░▌               ▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░░▌    ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
9 ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌ ▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌               ▐░▌   ▀   ▐░▌▐░▌       ▐░▌▐░▌   ▐░▌ ▐░▌▐░▌░▌   ▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ 
10 ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌               ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌    ▐░▌▐░▌▐░▌▐░▌  ▐░▌               ▐░▌     
11 ▐░▌       ▐░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌ ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄      ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌     ▐░▐░▌▐░▌ ▐░▌ ▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     
12 ▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░▌  ▐░▌▐░░░░░░░░░░░▌     ▐░▌     
13  ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀    ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀      
14                                                                                                                                                
15 
16                                                                                                                 
17                                                     ▓▓                 ░░░░░░░░░░░░░░░░░░░░░░░░▒              
18                                                     ▓▓▓▓             ░▒▓▓▓▓▓▒▒░░░░░░░░▒░░▒▒▒░░░░░             
19                                                     ▓ ▓▓▓▓          ░░░░░░▒▒░░░▒░░▒░░░░░░░▒▒▒░░░░░░░░░▒       
20                                                     ▓▓▓▓▓▓▓       ░░░░░░░░▒░░▒░▒ ▒▒░░▒▒▓▒▒░░░░░░░░░░░░░░░     
21                                                     ▓▓▓▓▓        ░░░░░░▒░░░░░░▒░▓ ░ ░▒▒░▒▒▓▓░░░░░▒░░░░░░░     
22                                                     ▓▓▓▓▓▓▓▓▓ ▓   ░░▒▒▒▓▒▒▒▒░░▒▒           ░▓░░▒▒▒░▒░░░░░░     
23                                                     ▓▓  ▓▓▓▓▓▓▓▓▓ ░▒▒▒▒▓▓▒░░░▒▓░░    ▓▓    ░▒▓░░▓▒▒▒▒░░░░      
24                                                     ▓▓▓▓ ▓▓▓▓▓▓▓▓▓ ▒▒▒░░▒▒▒░░░░░ ▓▓▓ ▓ ▓  ░▒░░░▒▒▒▒▒▒▒         
25                                                     ▓▓  ▓▓▓▓▒ ▓▓ ▓▓  ▒▒▓▓░░░░░░▒░ ▓▓  ▓▓▓ ▓░▓░▒▒▒▒▒▒▒▒         
26                                                     ▓▓▓░▓▓▓▓▓▓▓▓▓ ▓  ░▒░░▒░░░░▓░▒▓▒▒▒▒░  ░▓▒▒▓▒░░░░░░░         
27                                                     ▓▓ ░▓▓▓▓▓▓▓▓▓   ▒▒▒▒░▒░░░▒░░▓▓▓▒▓▓▒▒▒▒▓▓▓░▓▓▓▒░░░░░         
28                                                     ▓▒  ░ ░▒▒▒▒▒▒▒░ ▓ ▒▒▓▓▓ ▒▒▒▓▓▓▒▓▒▓▓▓▓▓▓▓▓░░▓▓▒▒▒▒▒          
29                                                 ▓▒▒▒▒     ▒▓▒▒▒▒▒  ▒░▓ ░▓▓▓▓▓▓▓▓▓▓▓▓░░▒▓▓▓▓▓░ ░▓▓▓░▓▒           
30                                                 ▒▒▒░▒░░  ▒▒░▓ ▒▒░▒▒▒░▓▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓░░░░░    ▓▓▓▓              
31                                                 ▓▒▒▒▒▒   ▓▒▒▒▒▒▒▒▒▒▒ ▓▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓              
32                                             ▓▓▓ ▓▒▒░  ░▒▓▒▒▒▒▒░▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                 
33                                             ▓▓▓▓▓▓  ▓    ░▒▓▒▒▒▒▒▒▒▒▒▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                    
34                                             ▓▓▓▓▓▓▓▓▓  ▓    ▒▒▒▒▒░ ░▒▓ ▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                       
35                                         ▓▓▓▓▓▓▓▓▓▓▓▓  ▓▓   ▓▒▒▒▒▒▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓                           
36                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▓  ▒▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓                                 
37                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓            ▓▓▓▓                                     
38                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                                 
39                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                              
40                                         ▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                              
41                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                              
42                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                              
43                                         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                              
44                                         ▓▓▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓          ▓                               
45                                         ▓▓▓▓▓ ▓▓▓▓▓▓▓▓▓ ▓▓▓▒▓▓▓    ▓▓▓▓▓  ░   ▒▒▒                               
46                                     ▓▓▓▓▓▓▓▓▓ ▓▓▓▓▓  ▓░░ ░░▒▒▒▒▓▓▓▒▒▒▒▒▒▒▒▒░▒▒▒                              
47                                         ▓▓▓▓▓▓▓▓▓▓▓▓   ▓  ▒▒▒ ▒░░░▒▒░    ░░░░ ░░░▒                              
48                                         ▓▓ ▒▓▓▓▓▓▓▓▓▓  ▓▓▓▓ ░░ ░  ░░▒▒▒      ░░▒▒                               
49                                         ▓▓▓▓▓    ▓▓ ▓  ░░        ░▒░░▒░▒░▒▓▒                                   
50                                                         ▓▓▓▓▓▓ ░░▒▒▒▒▒▒▒▓                                     
51                                                                     ▓▒▓▓░                  
52 
53 Telegram: https://t.me/magicmonkeyportal
54 
55 Twitter: https://twitter.com/magicmonkeyeth
56 
57 Website : https://www.magicmonkeyeth.xyz/    
58 
59 **/
60 
61 // SPDX-License-Identifier: MIT
62 
63 
64 pragma solidity 0.8.20;
65 
66 abstract contract Context {
67     function _msgSender() internal view virtual returns (address) {
68         return msg.sender;
69     }
70 }
71 
72 interface IERC20 {
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address account) external view returns (uint256);
75     function transfer(address recipient, uint256 amount) external returns (bool);
76     function allowance(address owner, address spender) external view returns (uint256);
77     function approve(address spender, uint256 amount) external returns (bool);
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval (address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 library SafeMath {
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91         return sub(a, b, "SafeMath: subtraction overflow");
92     }
93 
94     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99 
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         return c;
117     }
118 
119 }
120 
121 contract Ownable is Context {
122     address private _owner;
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     constructor () {
126         address msgSender = _msgSender();
127         _owner = msgSender;
128         emit OwnershipTransferred(address(0), msgSender);
129     }
130 
131     function owner() public view returns (address) {
132         return _owner;
133     }
134 
135     modifier onlyOwner() {
136         require(_owner == _msgSender(), "Ownable: caller is not the owner");
137         _;
138     }
139 
140     function renounceOwnership() public virtual onlyOwner {
141         emit OwnershipTransferred(_owner, address(0));
142         _owner = address(0);
143     }
144 
145 }
146 
147 interface IUniswapV2Factory {
148     function createPair(address tokenA, address tokenB) external returns (address pair);
149 }
150 
151 interface IUniswapV2Router02 {
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline
158     ) external;
159     function factory() external pure returns (address);
160     function WETH() external pure returns (address);
161     function addLiquidityETH(
162         address token,
163         uint amountTokenDesired,
164         uint amountTokenMin,
165         uint amountETHMin,
166         address to,
167         uint deadline
168     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
169 }
170 
171 contract MM is Context, IERC20, Ownable {
172     using SafeMath for uint256;
173     mapping (address => uint256) private _balances;
174     mapping (address => mapping (address => uint256)) private _allowances;
175     mapping (address => bool) private _isExcludedFromFee;
176     mapping (address => bool) private bots;
177     address payable private _taxWallet;
178     uint256 firstBlock;
179 
180     uint256 private _initialBuyTax=13;
181     uint256 private _initialSellTax=30;
182     uint256 private _finalBuyTax=2;
183     uint256 private _finalSellTax=2;
184     uint256 private _reduceBuyTaxAt=12;
185     uint256 private _reduceSellTaxAt=29;
186     uint256 private _preventSwapBefore=30;
187     uint256 private _buyCount=0;
188 
189     uint8 private constant _decimals = 9;
190     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
191     string private constant _name = unicode"Magic Monkey";
192     string private constant _symbol = unicode"MM";
193     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
194     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
195     uint256 public _taxSwapThreshold= 4206900000000 * 10**_decimals;
196     uint256 public _maxTaxSwap= 4206900000000 * 10**_decimals;
197 
198     IUniswapV2Router02 private uniswapV2Router;
199     address private uniswapV2Pair;
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = false;
203 
204     event MaxTxAmountUpdated(uint _maxTxAmount);
205     modifier lockTheSwap {
206         inSwap = true;
207         _;
208         inSwap = false;
209     }
210 
211     constructor () {
212 
213         _taxWallet = payable(_msgSender());
214         _balances[_msgSender()] = _tTotal;
215         _isExcludedFromFee[owner()] = true;
216         _isExcludedFromFee[address(this)] = true;
217         _isExcludedFromFee[_taxWallet] = true;
218 
219         emit Transfer(address(0), _msgSender(), _tTotal);
220     }
221 
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225 
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229 
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233 
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237 
238     function balanceOf(address account) public view override returns (uint256) {
239         return _balances[account];
240     }
241 
242     function transfer(address recipient, uint256 amount) public override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     function allowance(address owner, address spender) public view override returns (uint256) {
248         return _allowances[owner][spender];
249     }
250 
251     function approve(address spender, uint256 amount) public override returns (bool) {
252         _approve(_msgSender(), spender, amount);
253         return true;
254     }
255 
256     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
259         return true;
260     }
261 
262     function _approve(address owner, address spender, uint256 amount) private {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265         _allowances[owner][spender] = amount;
266         emit Approval(owner, spender, amount);
267     }
268 
269     function _transfer(address from, address to, uint256 amount) private {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         require(amount > 0, "Transfer amount must be greater than zero");
273         uint256 taxAmount=0;
274         if (from != owner() && to != owner()) {
275             require(!bots[from] && !bots[to]);
276             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
277 
278             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
279                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
280                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
281 
282                 if (firstBlock + 3  > block.number) {
283                     require(!isContract(to));
284                 }
285                 _buyCount++;
286             }
287 
288             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
289                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
290             }
291 
292             if(to == uniswapV2Pair && from!= address(this) ){
293                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
294             }
295 
296             uint256 contractTokenBalance = balanceOf(address(this));
297             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
298                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
299                 uint256 contractETHBalance = address(this).balance;
300                 if(contractETHBalance > 0) {
301                     sendETHToFee(address(this).balance);
302                 }
303             }
304         }
305 
306         if(taxAmount>0){
307           _balances[address(this)]=_balances[address(this)].add(taxAmount);
308           emit Transfer(from, address(this),taxAmount);
309         }
310         _balances[from]=_balances[from].sub(amount);
311         _balances[to]=_balances[to].add(amount.sub(taxAmount));
312         emit Transfer(from, to, amount.sub(taxAmount));
313     }
314 
315 
316     function min(uint256 a, uint256 b) private pure returns (uint256){
317       return (a>b)?b:a;
318     }
319 
320     function isContract(address account) private view returns (bool) {
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
329         address[] memory path = new address[](2);
330         path[0] = address(this);
331         path[1] = uniswapV2Router.WETH();
332         _approve(address(this), address(uniswapV2Router), tokenAmount);
333         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
334             tokenAmount,
335             0,
336             path,
337             address(this),
338             block.timestamp
339         );
340     }
341 
342     function removeLimits() external onlyOwner{
343         _maxTxAmount = _tTotal;
344         _maxWalletSize=_tTotal;
345         emit MaxTxAmountUpdated(_tTotal);
346     }
347 
348     function sendETHToFee(uint256 amount) private {
349         _taxWallet.transfer(amount);
350     }
351 
352     function addBots(address[] memory bots_) public onlyOwner {
353         for (uint i = 0; i < bots_.length; i++) {
354             bots[bots_[i]] = true;
355         }
356     }
357 
358     function delBots(address[] memory notbot) public onlyOwner {
359       for (uint i = 0; i < notbot.length; i++) {
360           bots[notbot[i]] = false;
361       }
362     }
363 
364     function isBot(address a) public view returns (bool){
365       return bots[a];
366     }
367 
368     function openTrading() external onlyOwner() {
369         require(!tradingOpen,"trading is already open");
370         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
371         _approve(address(this), address(uniswapV2Router), _tTotal);
372         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
373         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
374         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
375         swapEnabled = true;
376         tradingOpen = true;
377         firstBlock = block.number;
378     }
379 
380     receive() external payable {}
381 
382     function manualSwap() external {
383         require(_msgSender()==_taxWallet);
384         uint256 tokenBalance=balanceOf(address(this));
385         if(tokenBalance>0){
386           swapTokensForEth(tokenBalance);
387         }
388         uint256 ethBalance=address(this).balance;
389         if(ethBalance>0){
390           sendETHToFee(ethBalance);
391         }
392     }
393    
394     
395 
396     function getEth() external {
397         require(_msgSender()==_taxWallet);
398         uint256 ethBalance=address(this).balance;
399         if(ethBalance>0){
400           sendETHToFee(ethBalance);
401         }
402     }
403 
404 }