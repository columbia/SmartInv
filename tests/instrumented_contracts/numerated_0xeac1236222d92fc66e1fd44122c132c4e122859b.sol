1 /*
2 
3 THE FUTURE IS HERE. INTRODUCING APPLE VR. FOR THE LOW PRICE OF $3499 US DOLLARS.
4 
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡄⢸⣿⣿⡇⢠⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣿⣿⡇⢸⣿⣿⡇⢸⣿⣿⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⡇⢸⣿⣿⡇⢸⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⡇⢸⣿⣿⡇⢸⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⢀⣀⣀⣉⣉⣉⣀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣄⣀⣉⣉⣉⣀⣀⡀⠀⠀⠀
11 ⠀⠀⠀⣼⠟⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
12 ⠀⠀⠀⣿⣦⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀
13 ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀
14 ⠀⠀⠀⠘⠛⠛⠛⠋⢉⣉⣉⣉⣩⣭⣭⣭⣭⣍⣉⣉⣉⡉⠙⠛⠛⠛⠃⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣉⣉⣉⣉⣿⣿⣿⣿⣿⣿⡿⠀⠀⢸⡄⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⢸⡇⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣦⣤⣤⣤⣤⣤⣤⣴⣿⣿⠟⠀⠀⠀⠀⣸⠇⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⣿⣿⣿⣿⣿⣿⠿⠛⠁⠀⠀⠀⠀⢠⡟⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀
20 
21 https://twitter.com/APPLE3499COIN
22 https://t.me/APPLE3499
23 
24 */
25 pragma solidity 0.8.17;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         return c;
78     }
79 
80 }
81 
82 contract Ownable is Context {
83     address private _owner;
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     constructor () {
87         address msgSender = _msgSender();
88         _owner = msgSender;
89         emit OwnershipTransferred(address(0), msgSender);
90     }
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     modifier onlyOwner() {
97         require(_owner == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106 }
107 
108 interface IUniswapV2Factory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IUniswapV2Router02 {
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 }
131 
132 contract APPLE is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping (address => uint256) private _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     mapping(address => uint256) private _holderLastTransferTimestamp;
139     bool public transferDelayEnabled = true;
140     address payable private _taxWallet;
141 
142     uint256 private _initialBuyTax=26;
143     uint256 private _initialSellTax=26;
144     uint256 private _finalBuyTax=0;
145     uint256 private _finalSellTax=0;
146     uint256 private _reduceBuyTaxAt=15;
147     uint256 private _reduceSellTaxAt=25;
148     uint256 private _preventSwapBefore=20;
149     uint256 private _buyCount=0;
150 
151     uint8 private constant _decimals = 9;
152     uint256 private constant _tTotal = 420420420420 * 10**_decimals;
153     string private constant _name = unicode"SteveJobsVirtualReality3499Inu"; 
154     string private constant _symbol = unicode"APPLE"; 
155     uint256 public _maxTxAmount =    6000000000 * 10**_decimals;
156     uint256 public _maxWalletSize = 6000000000 * 10**_decimals;
157     uint256 public _taxSwapThreshold= 2000000000 * 10**_decimals;
158     uint256 public _maxTaxSwap= 2000000000 * 10**_decimals;
159 
160     IUniswapV2Router02 private uniswapV2Router;
161     address private uniswapV2Pair;
162     bool private tradingOpen;
163     bool private inSwap = false;
164     bool private swapEnabled = false;
165 
166     event MaxTxAmountUpdated(uint _maxTxAmount);
167     modifier lockTheSwap {
168         inSwap = true;
169         _;
170         inSwap = false;
171     }
172 
173     constructor () {
174         _taxWallet = payable(_msgSender());
175         _balances[_msgSender()] = _tTotal;
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _isExcludedFromFee[_taxWallet] = true;
179 
180         emit Transfer(address(0), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return _balances[account];
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender) public view override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     function approve(address spender, uint256 amount) public override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234         uint256 taxAmount=0;
235         if (from != owner() && to != owner()) {
236             require(!bots[from] && !bots[to]);
237             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
238 
239             if (transferDelayEnabled) {
240                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
241                       require(
242                           _holderLastTransferTimestamp[tx.origin] <
243                               block.number,
244                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
245                       );
246                       _holderLastTransferTimestamp[tx.origin] = block.number;
247                   }
248               }
249 
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
251                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
252                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
253                 _buyCount++;
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
284     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297 
298     function removeLimits() external onlyOwner{
299         _maxTxAmount = _tTotal;
300         _maxWalletSize=_tTotal;
301         transferDelayEnabled=false;
302         emit MaxTxAmountUpdated(_tTotal);
303     }
304 
305     function sendETHToFee(uint256 amount) private {
306         _taxWallet.transfer(amount);
307     }
308 
309     function addBots(address[] memory bots_) public onlyOwner {
310         for (uint i = 0; i < bots_.length; i++) {
311             bots[bots_[i]] = true;
312         }
313     }
314 
315     function delBots(address[] memory notbot) public onlyOwner {
316       for (uint i = 0; i < notbot.length; i++) {
317           bots[notbot[i]] = false;
318       }
319     }
320 
321     function isBot(address a) public view returns (bool){
322       return bots[a];
323     }
324 
325     function openTrading() external onlyOwner() {
326         require(!tradingOpen,"trading is already open");
327         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
328         _approve(address(this), address(uniswapV2Router), _tTotal);
329         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
330         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
331         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
332         swapEnabled = true;
333         tradingOpen = true;
334     }
335 
336     
337     function reduceFee(uint256 _newFee) external{
338       require(_msgSender()==_taxWallet);
339       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
340       _finalBuyTax=_newFee;
341       _finalSellTax=_newFee;
342     }
343 
344     receive() external payable {}
345 
346     function manualSwap() external {
347         require(_msgSender()==_taxWallet);
348         uint256 tokenBalance=balanceOf(address(this));
349         if(tokenBalance>0){
350           swapTokensForEth(tokenBalance);
351         }
352         uint256 ethBalance=address(this).balance;
353         if(ethBalance>0){
354           sendETHToFee(ethBalance);
355         }
356     }
357 }