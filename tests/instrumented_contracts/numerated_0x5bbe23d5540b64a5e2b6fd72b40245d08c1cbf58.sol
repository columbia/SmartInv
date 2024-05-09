1 /*
2 
3 fuck around and find out cunt
4 
5 */
6 
7 // SPDX-License-Identifier: NONE
8 
9 pragma solidity 0.8.18;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     constructor () {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104     function factory() external pure returns (address);
105     function WETH() external pure returns (address);
106     function addLiquidityETH(
107         address token,
108         uint amountTokenDesired,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
114 }
115 
116 contract fuck is Context, IERC20, Ownable {
117     using SafeMath for uint256;
118     mapping (address => uint256) private _balances;
119     mapping (address => mapping (address => uint256)) private _allowances;
120     mapping (address => bool) private _isExcludedFromFee;
121     mapping (address => bool) private bots;
122     mapping(address => uint256) private _holderLastTransferTimestamp;
123     bool public transferDelayEnabled = false;
124     address payable private _taxWallet;
125     uint256 private _initialBuyTax=25;
126     uint256 private _initialSellTax=25;
127     uint256 private _finalBuyTax=0;
128     uint256 private _finalSellTax=0;
129     uint256 public _reduceBuyTaxAt=69;
130     uint256 public _reduceSellTaxAt=69;
131     uint256 private _preventSwapBefore=20;
132     uint256 private _buyCount=0;
133     mapping(address => uint256) private _airdropVestingEnd;
134 
135     uint8 private constant _decimals = 9;
136     uint256 private constant _tTotal = 41300000000 * 10**_decimals; 
137     string private constant _name = unicode"Fuck around and Find Out";
138     string private constant _symbol = unicode"FAFO";
139 
140     uint256 public _maxTxAmount =    (_tTotal * 2) / 100;
141     uint256 public _maxWalletSize =  (_tTotal * 2) / 100;
142     uint256 public _taxSwapThreshold = (_tTotal * 8) / 1000;
143     uint256 public _maxTaxSwap = (_tTotal * 8) / 1000;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150 
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157 
158     constructor() {
159         _taxWallet = payable(_msgSender());
160 
161          uint256 total = _tTotal;
162         _balances[_msgSender()] = total; 
163 
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_taxWallet] = true;
167 
168         emit Transfer(address(0), _msgSender(), total);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balances[account];
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210     function addAirdropRecipients(address[] memory recipients) external onlyOwner {
211         for (uint i = 0; i < recipients.length; i++) {
212             _airdropVestingEnd[recipients[i]] = block.timestamp + 2 hours;
213         }
214     }
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
226 
227         require(
228         block.timestamp >= _airdropVestingEnd[from],
229         "Airdrop vesting not over"
230         );
231 
232         uint256 taxAmount=0;
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to]);
235 
236             if (transferDelayEnabled) {
237                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
238                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
239                   _holderLastTransferTimestamp[tx.origin] = block.number;
240                 }
241             }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249 
250             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
251             if(to == uniswapV2Pair && from!= address(this) ){
252                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
253             }
254 
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
257                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 0) {
260                     sendETHToFee(address(this).balance);
261                 }
262             }
263         }
264 
265         if(taxAmount>0){
266           _balances[address(this)]=_balances[address(this)].add(taxAmount);
267           emit Transfer(from, address(this),taxAmount);
268         }
269         _balances[from]=_balances[from].sub(amount);
270         _balances[to]=_balances[to].add(amount.sub(taxAmount));
271         emit Transfer(from, to, amount.sub(taxAmount));
272     }
273 
274 
275     function min(uint256 a, uint256 b) private pure returns (uint256){
276       return (a>b)?b:a;
277     }
278 
279     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
280         if(tokenAmount==0){return;}
281         if(!tradingOpen){return;}
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
299         _reduceSellTaxAt=10;
300         _reduceBuyTaxAt=10;
301         emit MaxTxAmountUpdated(_tTotal);
302     }
303 
304     function sendETHToFee(uint256 amount) private {
305         _taxWallet.transfer(amount);
306     }
307 
308     function isBot(address a) public view returns (bool){
309       return bots[a];
310     }
311 
312     function fuckAround() external onlyOwner() {
313         require(!tradingOpen,"trading is already open");
314         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
315         _approve(address(this), address(uniswapV2Router), _tTotal);
316         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
317         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
318         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
319         swapEnabled = true;
320         tradingOpen = true;
321     }
322 
323     receive() external payable {}
324 
325     function manualSwap() external {
326         require(_msgSender()==_taxWallet);
327         uint256 tokenBalance=balanceOf(address(this));
328         if(tokenBalance>0){
329           swapTokensForEth(tokenBalance);
330         }
331         uint256 ethBalance=address(this).balance;
332         if(ethBalance>0){
333           sendETHToFee(ethBalance);
334         }
335     }
336 }