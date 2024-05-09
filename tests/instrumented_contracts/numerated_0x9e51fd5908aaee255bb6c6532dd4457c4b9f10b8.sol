1 /*                                                                       
2                                                            @@@                  
3                                                           @@@@@@@@@             
4                      @@@@@@@@                                  @@@@@@@@%        
5                 @@@@@@@@@@@@                                         @@@@@      
6             @@@@@@,                                                      @@@    
7           @@@@                                                             @@   
8        /@@@@                                                  @@@@@@@@@@@@      
9      @@@@                                                  @@  @@@@@@@@@@@      
10     @@@              .@@@@@@@                               @@@@   @@@@@@@@@    
11     @         @@@@@                                        @@@@@   @@@@@@ @@@   
12            @@  @@@@@@@@@@@@@                              @@@@@@@ @@@@@@@ @&@@  
13            @@@     @@@@@@@@@@@                            @@ @@@@@@@@@@@@ @     
14         @@@@@@@@   @@@@@@@@@@@@@                         @@@ @@@@@@@@@@@  @     
15       @@@@  %@@@@@@@@@@@@@@@@@@@%                         @@  @@@@@@@@@@ @%     
16       @@  @  #@@@@@@@@@@@@@@@@ @@                         @@   @@@@@@@@  @      
17      @@   @@   @@@@@@@@@@@@@@  @@                          @@    @@@   @@       
18      @    @@@   @@@@@@@@@@@@   @@                            @@        @        
19             @@     @@@@@@     @@@                               @@@@@@ @@       
20              (@@            @@@                                                 
21                  @@@        @                                                   
22                 @@@@@@@@@/                                             
23 
24 █▀▀ █▀▀ █▀▀█ ▀▀█▀▀ █▀▀ █▀▀█ ░▀░ █▀▀                                www.esot.me
25 █▀▀ ▀▀█ █░░█ ░░█░░ █▀▀ █▄▄▀ ▀█▀ █░░                        t.me/EsotericPortal
26 ▀▀▀ ▀▀▀ ▀▀▀▀ ░░▀░░ ▀▀▀ ▀░▀▀ ▀▀▀ ▀▀▀                  twitter.com/EsotericToken                                         
27 */
28 
29 // SPDX-License-Identifier: MIT
30 pragma solidity 0.8.19;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor () {
92         address msgSender = _msgSender();
93         _owner = msgSender;
94         emit OwnershipTransferred(address(0), msgSender);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111 }
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IUniswapV2Router02 {
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 }
136 
137 contract ESOT is Context, IERC20, Ownable {
138     using SafeMath for uint256;
139     mapping (address => uint256) private _balances;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) private _isExcludedFromFee;
142     address payable private _taxWallet;
143     uint256 firstBlock;
144 
145     uint256 private _initialBuyTax=20;
146     uint256 private _initialSellTax=30;
147     uint256 private _finalBuyTax=0;
148     uint256 private _finalSellTax=0;
149     uint256 private _reduceBuyTaxAt=30;
150     uint256 private _reduceSellTaxAt=30;
151     uint256 private _preventSwapBefore=20;
152     uint256 private _buyCount=0;
153 
154     uint8 private constant _decimals = 9;
155     uint256 private constant _tTotal = 9_988_776_655 * 10**_decimals;
156     string private constant _name = unicode"ESOTERIC";
157     string private constant _symbol = unicode"ESOT";
158     uint256 public _maxTxAmount =   99887766 * 10**_decimals;
159     uint256 public _maxWalletSize = 99887766 * 10**_decimals;
160     uint256 public _taxSwapThreshold= 0 * 10**_decimals;
161     uint256 public _maxTaxSwap= 99887766 * 10**_decimals;
162 
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168 
169     event MaxTxAmountUpdated(uint _maxTxAmount);
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175 
176     constructor () {
177 
178         _taxWallet = payable(_msgSender());
179         _balances[_msgSender()] = _tTotal;
180         _isExcludedFromFee[owner()] = true;
181         _isExcludedFromFee[address(this)] = true;
182         _isExcludedFromFee[_taxWallet] = true;
183         
184         emit Transfer(address(0), _msgSender(), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203     function balanceOf(address account) public view override returns (uint256) {
204         return _balances[account];
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
224         return true;
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _transfer(address from, address to, uint256 amount) private {
235         require(from != address(0), "ERC20: transfer from the zero address");
236         require(to != address(0), "ERC20: transfer to the zero address");
237         require(amount > 0, "Transfer amount must be greater than zero");
238         uint256 taxAmount=0;
239         if (from != owner() && to != owner()) {
240             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
241 
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245 
246                 if (firstBlock + 3  > block.number) {
247                     require(!isContract(to));
248                 }
249                 _buyCount++;
250             }
251 
252             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
253                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
254             }
255 
256             if(to == uniswapV2Pair && from!= address(this) ){
257                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
258             }
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
262                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 0) {
265                     sendETHToFee(address(this).balance);
266                 }
267             }
268         }
269 
270         if(taxAmount>0){
271           _balances[address(this)]=_balances[address(this)].add(taxAmount);
272           emit Transfer(from, address(this),taxAmount);
273         }
274         _balances[from]=_balances[from].sub(amount);
275         _balances[to]=_balances[to].add(amount.sub(taxAmount));
276         emit Transfer(from, to, amount.sub(taxAmount));
277     }
278 
279 
280     function min(uint256 a, uint256 b) private pure returns (uint256){
281       return (a>b)?b:a;
282     }
283 
284     function isContract(address account) private view returns (bool) {
285         uint256 size;
286         assembly {
287             size := extcodesize(account)
288         }
289         return size > 0;
290     }
291 
292     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = uniswapV2Router.WETH();
296         _approve(address(this), address(uniswapV2Router), tokenAmount);
297         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304     }
305 
306     function removeLimits() external onlyOwner{
307         _maxTxAmount = _tTotal;
308         _maxWalletSize=_tTotal;
309         emit MaxTxAmountUpdated(_tTotal);
310     }
311 
312     function sendETHToFee(uint256 amount) private {
313         _taxWallet.transfer(amount);
314     }
315 
316     function openTrading() external onlyOwner() {
317         require(!tradingOpen,"trading is already open");
318         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
319         _approve(address(this), address(uniswapV2Router), _tTotal);
320         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
321         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323         swapEnabled = true;
324         tradingOpen = true;
325         firstBlock = block.number;
326     }
327 
328     receive() external payable {}
329 }