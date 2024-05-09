1 /**
2                @@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3                @@@@@@@&/                         ,@@@                         .@@&@,                           @@@@@
4                @@@@@@@          ,%@@@@@@@@@@@@@@@@@,      /@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@       @@@@@@@
5                @@@@@@@@@@@@@(.                ,@@@@.                           @&                         @@@@@@@@@@
6                @@@@@@  @@@@@@@@@@@@@@@@%       @&       @@@@@@@@@@@@@       @@@       %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7       @@@@@@@@@@@@,                          &@@                          .@@        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8       @@@@/                           (@@@.                        @@@#                        %,@@#                        %@@
9       @@@@       @@@@@@@@@@@@@@&  (@@@,      (@@@@@@@@@@@@&       @.      %@@@@@@@@@@@@/      ,@       &@@@@@@@@@@@@(      *@@@
10       @(#                          /@                  /@.      %@       @@@@@@@@@@@@@       @@       @@@@@@@@@@@@@       @@@@@
11       @       @@@@@@@@@@@@@*      ,@@@@@@@@@@@@@@@@@@@@@       @/      ,@@@@@@@@@@@@@       @/      ,@@@@@@@@@@@@@       @@@@@@
12       @                          /@@%                         .@                           @@                           @@@@&@@
13       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 S&P 6900 (SPX)
15 Telegram: https://t.me/+BgknlP2VHjwwYjIx
16 Website: https://www.thestockmarketcoin.com/
17 Twitter: https://twitter.com/SPX6900
18 **/
19 
20 // SPDX-License-Identifier: NONE
21 
22 pragma solidity 0.8.19;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         return c;
75     }
76 
77 }
78 
79 contract Ownable is Context {
80     address private _owner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103 }
104 
105 interface IUniswapV2Factory {
106     function createPair(address tokenA, address tokenB) external returns (address pair);
107 }
108 
109 interface IUniswapV2Router02 {
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 }
128 
129 contract SPX is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131     mapping (address => uint256) private _balances;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => bool) private bots;
135     mapping(address => uint256) private _holderLastTransferTimestamp;
136     bool public transferDelayEnabled = false;
137     address payable private _taxWallet;
138 
139     uint256 private _initialBuyTax=15;
140     uint256 private _initialSellTax=70;
141     uint256 private _finalBuyTax=0;
142     uint256 private _finalSellTax=0;
143     uint256 public _reduceBuyTaxAt=69;
144     uint256 public _reduceSellTaxAt=420;
145     uint256 private _preventSwapBefore=30;
146     uint256 private _buyCount=0;
147 
148     uint8 private constant _decimals = 8;
149     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
150     string private constant _name = unicode"SPX6900";
151     string private constant _symbol = unicode"SPX";
152     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
153     uint256 public _maxWalletSize = 30000000 * 10**_decimals;
154     uint256 public _taxSwapThreshold=6000000 * 10**_decimals;
155     uint256 public _maxTaxSwap=6000000 * 10**_decimals;
156 
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private inSwap = false;
161     bool private swapEnabled = false;
162 
163     event MaxTxAmountUpdated(uint _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     constructor () {
171         _taxWallet = payable(_msgSender());
172         _balances[_msgSender()] = _tTotal;
173         _isExcludedFromFee[owner()] = true;
174         _isExcludedFromFee[address(this)] = true;
175         _isExcludedFromFee[_taxWallet] = true;
176 
177         emit Transfer(address(0), _msgSender(), _tTotal);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     function _transfer(address from, address to, uint256 amount) private {
228         require(from != address(0), "ERC20: transfer from the zero address");
229         require(to != address(0), "ERC20: transfer to the zero address");
230         require(amount > 0, "Transfer amount must be greater than zero");
231         uint256 taxAmount=0;
232         if (from != owner() && to != owner()) {
233             require(!bots[from] && !bots[to]);
234 
235             if (transferDelayEnabled) {
236                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
237                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
238                   _holderLastTransferTimestamp[tx.origin] = block.number;
239                 }
240             }
241 
242             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
243                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
244                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
245                 _buyCount++;
246             }
247 
248 
249             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
250             if(to == uniswapV2Pair && from!= address(this) ){
251                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
252             }
253 
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
256                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
257                 uint256 contractETHBalance = address(this).balance;
258                 if(contractETHBalance > 0) {
259                     sendETHToFee(address(this).balance);
260                 }
261             }
262         }
263 
264         if(taxAmount>0){
265           _balances[address(this)]=_balances[address(this)].add(taxAmount);
266           emit Transfer(from, address(this),taxAmount);
267         }
268         _balances[from]=_balances[from].sub(amount);
269         _balances[to]=_balances[to].add(amount.sub(taxAmount));
270         emit Transfer(from, to, amount.sub(taxAmount));
271     }
272 
273 
274     function min(uint256 a, uint256 b) private pure returns (uint256){
275       return (a>b)?b:a;
276     }
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         if(tokenAmount==0){return;}
280         if(!tradingOpen){return;}
281         address[] memory path = new address[](2);
282         path[0] = address(this);
283         path[1] = uniswapV2Router.WETH();
284         _approve(address(this), address(uniswapV2Router), tokenAmount);
285         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
286             tokenAmount,
287             0,
288             path,
289             address(this),
290             block.timestamp
291         );
292     }
293 
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize=_tTotal;
297         transferDelayEnabled=false;
298         _reduceSellTaxAt=20;
299         _reduceBuyTaxAt=20;
300         emit MaxTxAmountUpdated(_tTotal);
301     }
302 
303     function sendETHToFee(uint256 amount) private {
304         _taxWallet.transfer(amount);
305     }
306 
307     function isBot(address a) public view returns (bool){
308       return bots[a];
309     }
310 
311     function runitturbo() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         _approve(address(this), address(uniswapV2Router), _tTotal);
315         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
316         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
317         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
318         swapEnabled = true;
319         tradingOpen = true;
320     }
321 
322     receive() external payable {}
323 
324     function manualSwap() external {
325         require(_msgSender()==_taxWallet);
326         uint256 tokenBalance=balanceOf(address(this));
327         if(tokenBalance>0){
328           swapTokensForEth(tokenBalance);
329         }
330         uint256 ethBalance=address(this).balance;
331         if(ethBalance>0){
332           sendETHToFee(ethBalance);
333         }
334     }
335     
336     function addBots(address[] memory bots_) public onlyOwner {
337         for (uint i = 0; i < bots_.length; i++) {
338             bots[bots_[i]] = true;
339         }
340     }
341 
342     function delBots(address[] memory notbot) public onlyOwner {
343       for (uint i = 0; i < notbot.length; i++) {
344           bots[notbot[i]] = false;
345       }
346     }
347     
348 }