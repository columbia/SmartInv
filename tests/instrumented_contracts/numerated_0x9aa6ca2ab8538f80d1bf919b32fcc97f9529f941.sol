1 // SPDX-License-Identifier: MIT
2 /**
3 
4 PRESIDENT JOE BIDEN | $JOE
5 
6 #AMERICAISBACK
7 
8 Together, we can.
9 Finish the job for the American people.
10 
11 TG - https://t.me/JOE_TOKEN
12 TWITTER - https://twitter.com/JOE_ERC20
13 WEBSITE - http://presidentjoebiden.xyz
14 
15 
16 **/
17 pragma solidity 0.8.19;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27     function balanceOf(address account) external view returns (uint256);
28     function transfer(address recipient, uint256 amount) external returns (bool);
29     function allowance(address owner, address spender) external view returns (uint256);
30     function approve(address spender, uint256 amount) external returns (bool);
31     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42 
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50         return c;
51     }
52 
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61 
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65 
66     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b > 0, errorMessage);
68         uint256 c = a / b;
69         return c;
70     }
71 
72 }
73 
74 contract Ownable is Context {
75     address private _owner;
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () {
79         address msgSender = _msgSender();
80         _owner = msgSender;
81         emit OwnershipTransferred(address(0), msgSender);
82     }
83 
84     function owner() public view returns (address) {
85         return _owner;
86     }
87 
88     modifier onlyOwner() {
89         require(_owner == _msgSender(), "Ownable: caller is not the owner");
90         _;
91     }
92 
93     function renounceOwnership() public virtual onlyOwner {
94         emit OwnershipTransferred(_owner, address(0));
95         _owner = address(0);
96     }
97 
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 contract JOE is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _balances;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = true;
132     address payable private _taxWallet;
133 
134     uint256 private _initialBuyTax=25;
135     uint256 private _initialSellTax=25;
136     uint256 private _finalTax=0;
137     uint256 private _burnTax=0;
138     uint256 private _reduceBuyTaxAt=13;
139     uint256 private _reduceSellTaxAt=13;
140     uint256 private _preventSwapBefore=30;
141     uint256 private _buyCount=0;
142 
143     uint8 private constant _decimals = 8;
144     uint256 private constant _tTotal = 1000000 * 10**_decimals;
145     string private constant _name = unicode"PRESIDENT JOE BIDEN";
146     string private constant _symbol = unicode"JOE";
147     uint256 public _maxTxAmount = 20000 * 10**_decimals;
148     uint256 public _maxWalletSize = 20000 * 10**_decimals;
149     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
150     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
151 
152     IUniswapV2Router02 private uniswapV2Router;
153     address private uniswapV2Pair;
154     bool private tradingOpen;
155     bool private inSwap = false;
156     bool private swapEnabled = false;
157 
158     event MaxTxAmountUpdated(uint _maxTxAmount);
159     modifier lockTheSwap {
160         inSwap = true;
161         _;
162         inSwap = false;
163     }
164 
165     constructor () {
166         _taxWallet = payable(_msgSender());
167         _balances[_msgSender()] = _tTotal;
168         _isExcludedFromFee[owner()] = true;
169         _isExcludedFromFee[address(this)] = true;
170         _isExcludedFromFee[_taxWallet] = true;
171 
172         emit Transfer(address(0), _msgSender(), _tTotal);
173     }
174 
175     function name() public pure returns (string memory) {
176         return _name;
177     }
178 
179     function symbol() public pure returns (string memory) {
180         return _symbol;
181     }
182 
183     function decimals() public pure returns (uint8) {
184         return _decimals;
185     }
186 
187     function totalSupply() public pure override returns (uint256) {
188         return _tTotal;
189     }
190 
191     function balanceOf(address account) public view override returns (uint256) {
192         return _balances[account];
193     }
194 
195     function transfer(address recipient, uint256 amount) public override returns (bool) {
196         _transfer(_msgSender(), recipient, amount);
197         return true;
198     }
199 
200     function allowance(address owner, address spender) public view override returns (uint256) {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount) public override returns (bool) {
205         _approve(_msgSender(), spender, amount);
206         return true;
207     }
208 
209     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
210         _transfer(sender, recipient, amount);
211         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
212         return true;
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0), "ERC20: approve from the zero address");
217         require(spender != address(0), "ERC20: approve to the zero address");
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226         uint256 taxAmount=0;
227         uint256 burnAmount=amount.mul(_burnTax).div(100);
228         if (from != owner() && to != owner()) {
229             require(!bots[from] && !bots[to]);
230             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalTax:_initialBuyTax).div(100);
231 
232             if (transferDelayEnabled) {
233                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
234                       require(
235                           _holderLastTransferTimestamp[tx.origin] <
236                               block.number,
237                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
238                       );
239                       _holderLastTransferTimestamp[tx.origin] = block.number;
240                   }
241               }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249             if(to == uniswapV2Pair && from!= address(this) ){
250                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalTax:_initialSellTax).div(100);
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
258                     sendETHToFee(address(this).balance);
259                 }
260             }
261         }
262 
263         _balances[from]=_balances[from].sub(amount);
264         _balances[to]=_balances[to].add(amount.sub(taxAmount).sub(burnAmount));
265         emit Transfer(from, to, amount.sub(taxAmount).sub(burnAmount));
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270         if(burnAmount>0){
271           _balances[address(0x0)]=_balances[address(0x0)].add(burnAmount);
272           emit Transfer(from, address(0x0),burnAmount);
273         }
274     }
275 
276 
277     function min(uint256 a, uint256 b) private pure returns (uint256){
278       return (a>b)?b:a;
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294 
295     function removeLimits() external onlyOwner{
296         _maxTxAmount = _tTotal;
297         _maxWalletSize=_tTotal;
298         transferDelayEnabled=false;
299         emit MaxTxAmountUpdated(_tTotal);
300     }
301 
302     function sendETHToFee(uint256 amount) private {
303         _taxWallet.transfer(amount);
304     }
305 
306     function addBots(address[] memory bots_) public onlyOwner {
307         for (uint i = 0; i < bots_.length; i++) {
308             bots[bots_[i]] = true;
309         }
310     }
311 
312     function delBots(address[] memory notbot) public onlyOwner {
313       for (uint i = 0; i < notbot.length; i++) {
314           bots[notbot[i]] = false;
315       }
316     }
317 
318     function isBot(address a) public view returns (bool){
319       return bots[a];
320     }
321 
322     function openTrading() external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         _approve(address(this), address(uniswapV2Router), _tTotal);
326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
328         swapEnabled = true;
329         tradingOpen = true;
330         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
331     }
332 
333     
334     function reduceFee(uint256 _newFee) external{
335       require(_msgSender()==_taxWallet);
336       require(_newFee<=_finalTax);
337       _finalTax=_newFee;
338     }
339 
340     receive() external payable {}
341 
342     function manualSwap() external {
343         require(_msgSender()==_taxWallet);
344         uint256 tokenBalance=balanceOf(address(this));
345         if(tokenBalance>0){
346           swapTokensForEth(tokenBalance);
347         }
348         uint256 ethBalance=address(this).balance;
349         if(ethBalance>0){
350           sendETHToFee(ethBalance);
351         }
352     }
353 }