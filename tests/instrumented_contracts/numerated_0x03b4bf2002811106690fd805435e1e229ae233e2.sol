1 //“First-Ever” Shibarium-Mainnet Sniper bot!
2 
3 //https://t.me/shibtechportal
4 //Web: Shib.technology
5 //https://twitter.com/ShibTech
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.17;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105     function addLiquidityETH(
106         address token,
107         uint amountTokenDesired,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
113 }
114 contract SHIBTECH is Context , IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping (address => bool) private bots;
120     mapping(address => uint256) private _holderLastTransferTimestamp;
121     bool public transferDelayEnabled = true;
122     address payable private _taxWallet;
123     uint256 private _initialBuyTax=20;
124     uint256 private _initialSellTax=45;
125     uint256 private _finalBuyTax=5;
126     uint256 private _finalSellTax=5;
127     uint256 private _reduceBuyTaxAt=15;
128     uint256 private _reduceSellTaxAt=20; 
129     uint256 private _preventSwapBefore=30;
130     uint256 private _buyCount=0;
131 
132     uint8 private constant _decimals = 9;
133     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
134     string private constant _name = "Shibarium Technology";
135     string private constant _symbol = "SHIBTECH";
136     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
137     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
138     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
139     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146 
147     event MaxTxAmountUpdated(uint _maxTxAmount);
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153 
154     constructor () {
155         _taxWallet = payable(_msgSender());
156         _balances[_msgSender()] = _tTotal;
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_taxWallet] = true;
160 
161         emit Transfer(address(0), _msgSender(), _tTotal);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balances[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) public override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address owner, address spender, uint256 amount) private {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) private {
212         require(from != address(0), "ERC20: transfer from the zero address");
213         require(to != address(0), "ERC20: transfer to the zero address");
214         require(amount > 0, "Transfer amount must be greater than zero");
215         uint256 taxAmount=0;
216         if (from != owner() && to != owner()) {
217             require(!bots[from] && !bots[to]);
218             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
219 
220             if (transferDelayEnabled) {
221                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
222                       require(
223                           _holderLastTransferTimestamp[tx.origin] <
224                               block.number,
225                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
226                       );
227                       _holderLastTransferTimestamp[tx.origin] = block.number;
228                   }
229               }
230               if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
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