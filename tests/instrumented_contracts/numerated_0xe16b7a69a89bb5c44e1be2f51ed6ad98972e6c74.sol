1 //https://t.me/Turbo2Coin
2 
3 //https://twitter.com/Turbo2Coin
4 
5 pragma solidity 0.8.17;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 }
111 
112 contract TURBO20 is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping(address => uint256) private _holderLastTransferTimestamp;
119     bool public transferDelayEnabled = true;
120     address payable private _taxWallet;
121 
122     uint256 private _initialBuyTax=20;  
123     uint256 private _initialSellTax=20;
124     uint256 private _finalBuyTax=1;
125     uint256 private _finalSellTax=1;
126     uint256 private _reduceBuyTaxAt=22;
127     uint256 private _reduceSellTaxAt=30;
128     uint256 private _preventSwapBefore=20;
129     uint256 private _buyCount=0;
130 
131     uint8 private constant _decimals = 9;
132     uint256 private constant _tTotal = 69000000000 * 10**_decimals;
133     string private constant _name = unicode"Turbo 2.0"; 
134     string private constant _symbol = unicode"TURBO2.0"; 
135     uint256 public _maxTxAmount =   1000000000 * 10**_decimals;
136     uint256 public _maxWalletSize = 1000000000 * 10**_decimals;
137     uint256 public _taxSwapThreshold= 200000000 * 10**_decimals;
138     uint256 public _maxTaxSwap= 200000000 * 10**_decimals;
139 
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145 
146     event MaxTxAmountUpdated(uint _maxTxAmount);
147     modifier lockTheSwap {
148         inSwap = true;
149         _;
150         inSwap = false;
151     }
152 
153     constructor () {
154         _taxWallet = payable(_msgSender());
155         _balances[_msgSender()] = _tTotal;
156         _isExcludedFromFee[owner()] = true;
157         _isExcludedFromFee[address(this)] = true;
158         _isExcludedFromFee[_taxWallet] = true;
159 
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return _balances[account];
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function _approve(address owner, address spender, uint256 amount) private {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _transfer(address from, address to, uint256 amount) private {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213         require(amount > 0, "Transfer amount must be greater than zero");
214         uint256 taxAmount=0;
215         if (from != owner() && to != owner()) {
216             require(!bots[from] && !bots[to]);
217             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
218 
219             if (transferDelayEnabled) {
220                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
221                       require(
222                           _holderLastTransferTimestamp[tx.origin] <
223                               block.number,
224                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
225                       );
226                       _holderLastTransferTimestamp[tx.origin] = block.number;
227                   }
228               }
229 
230             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
231                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
232                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
233                 _buyCount++;
234             }
235 
236             if(to == uniswapV2Pair && from!= address(this) ){
237                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
238             }
239 
240             uint256 contractTokenBalance = balanceOf(address(this));
241             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
242                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
243                 uint256 contractETHBalance = address(this).balance;
244                 if(contractETHBalance > 0) {
245                     sendETHToFee(address(this).balance);
246                 }
247             }
248         }
249 
250         if(taxAmount>0){
251           _balances[address(this)]=_balances[address(this)].add(taxAmount);
252           emit Transfer(from, address(this),taxAmount);
253         }
254         _balances[from]=_balances[from].sub(amount);
255         _balances[to]=_balances[to].add(amount.sub(taxAmount));
256         emit Transfer(from, to, amount.sub(taxAmount));
257     }
258 
259 
260     function min(uint256 a, uint256 b) private pure returns (uint256){
261       return (a>b)?b:a;
262     }
263 
264     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = uniswapV2Router.WETH();
268         _approve(address(this), address(uniswapV2Router), tokenAmount);
269         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
270             tokenAmount,
271             0,
272             path,
273             address(this),
274             block.timestamp
275         );
276     }
277 
278     function removeLimits() external onlyOwner{
279         _maxTxAmount = _tTotal;
280         _maxWalletSize=_tTotal;
281         transferDelayEnabled=false;
282         emit MaxTxAmountUpdated(_tTotal);
283     }
284 
285     function sendETHToFee(uint256 amount) private {
286         _taxWallet.transfer(amount);
287     }
288 
289     function addBots(address[] memory bots_) public onlyOwner {
290         for (uint i = 0; i < bots_.length; i++) {
291             bots[bots_[i]] = true;
292         }
293     }
294 
295     function delBots(address[] memory notbot) public onlyOwner {
296       for (uint i = 0; i < notbot.length; i++) {
297           bots[notbot[i]] = false;
298       }
299     }
300 
301     function isBot(address a) public view returns (bool){
302       return bots[a];
303     }
304 
305     function openTrading() external onlyOwner() {
306         require(!tradingOpen,"trading is already open");
307         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
308         _approve(address(this), address(uniswapV2Router), _tTotal);
309         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
310         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312         swapEnabled = true;
313         tradingOpen = true;
314     }
315 
316     
317     function reduceFee(uint256 _newFee) external{
318       require(_msgSender()==_taxWallet);
319       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
320       _finalBuyTax=_newFee;
321       _finalSellTax=_newFee;
322     }
323 
324     receive() external payable {}
325 
326     function manualSwap() external {
327         require(_msgSender()==_taxWallet);
328         uint256 tokenBalance=balanceOf(address(this));
329         if(tokenBalance>0){
330           swapTokensForEth(tokenBalance);
331         }
332         uint256 ethBalance=address(this).balance;
333         if(ethBalance>0){
334           sendETHToFee(ethBalance);
335         }
336     }
337 }