1 /**
2 8888888b.  8888888888 8888888b.  8888888888       .d8888b.       .d8888b.  
3 888   Y88b 888        888   Y88b 888             d88P  Y88b     d88P  Y88b 
4 888    888 888        888    888 888                    888     888    888 
5 888   d88P 8888888    888   d88P 8888888              .d88P     888    888 
6 8888888P"  888        8888888P"  888              .od888P"      888    888 
7 888        888        888        888             d88P"          888    888 
8 888        888        888        888             888"       d8b Y88b  d88P 
9 888        8888888888 888        8888888888      888888888  Y8P  "Y8888P"  
10                                                                                                                                      
11 Pepe2.0 (PEPE2.0)
12 https://t.me/PepeTwo
13 https://twitter.com/PepeTwoETH
14 https://pepetwo.com/
15 **/
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.19;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract PepeTwo is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     mapping(address => uint256) private _holderLastTransferTimestamp;
133     bool public transferDelayEnabled = false;
134     address payable private _taxWallet;
135 
136     uint256 private _initialBuyTax=15;
137     uint256 private _initialSellTax=70;
138     uint256 private _finalBuyTax=0;
139     uint256 private _finalSellTax=0;
140     uint256 private _reduceBuyTaxAt=25;
141     uint256 public _reduceSellTaxAt=70;
142     uint256 private _preventSwapBefore=30;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 8;
146     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
147     string private constant _name = unicode"Pepe2.0";
148     string private constant _symbol = unicode"PEPE2.0";
149     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
150     uint256 public _maxWalletSize = 30000000 * 10**_decimals;
151     uint256 public _taxSwapThreshold=6000000 * 10**_decimals;
152     uint256 public _maxTaxSwap=6000000 * 10**_decimals;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
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
231 
232             if (transferDelayEnabled) {
233                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
234                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
235                   _holderLastTransferTimestamp[tx.origin] = block.number;
236                 }
237             }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242                 _buyCount++;
243             }
244 
245 
246             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
247             if(to == uniswapV2Pair && from!= address(this) ){
248                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
249             }
250 
251             uint256 contractTokenBalance = balanceOf(address(this));
252             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
253                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                 uint256 contractETHBalance = address(this).balance;
255                 if(contractETHBalance > 0) {
256                     sendETHToFee(address(this).balance);
257                 }
258             }
259         }
260 
261         if(taxAmount>0){
262           _balances[address(this)]=_balances[address(this)].add(taxAmount);
263           emit Transfer(from, address(this),taxAmount);
264         }
265         _balances[from]=_balances[from].sub(amount);
266         _balances[to]=_balances[to].add(amount.sub(taxAmount));
267         emit Transfer(from, to, amount.sub(taxAmount));
268     }
269 
270 
271     function min(uint256 a, uint256 b) private pure returns (uint256){
272       return (a>b)?b:a;
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         if(tokenAmount==0){return;}
277         if(!tradingOpen){return;}
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290 
291     function removeLimits() external onlyOwner{
292         _maxTxAmount = _tTotal;
293         _maxWalletSize=_tTotal;
294         transferDelayEnabled=false;
295         _reduceSellTaxAt=20;
296         emit MaxTxAmountUpdated(_tTotal);
297     }
298 
299     function sendETHToFee(uint256 amount) private {
300         _taxWallet.transfer(amount);
301     }
302 
303     function isBot(address a) public view returns (bool){
304       return bots[a];
305     }
306 
307     function wenMoon() external onlyOwner() {
308         require(!tradingOpen,"trading is already open");
309         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
310         _approve(address(this), address(uniswapV2Router), _tTotal);
311         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
312         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
313         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
314         swapEnabled = true;
315         tradingOpen = true;
316     }
317 
318     receive() external payable {}
319 
320     function manualSwap() external {
321         require(_msgSender()==_taxWallet);
322         uint256 tokenBalance=balanceOf(address(this));
323         if(tokenBalance>0){
324           swapTokensForEth(tokenBalance);
325         }
326         uint256 ethBalance=address(this).balance;
327         if(ethBalance>0){
328           sendETHToFee(ethBalance);
329         }
330     }
331     
332     function addBots(address[] memory bots_) public onlyOwner {
333         for (uint i = 0; i < bots_.length; i++) {
334             bots[bots_[i]] = true;
335         }
336     }
337 
338     function delBots(address[] memory notbot) public onlyOwner {
339       for (uint i = 0; i < notbot.length; i++) {
340           bots[notbot[i]] = false;
341       }
342     }
343     
344 }