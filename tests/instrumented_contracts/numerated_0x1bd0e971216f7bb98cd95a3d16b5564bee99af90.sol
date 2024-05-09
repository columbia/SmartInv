1 //Eagle Sniper/Trade bot 
2 //Marketing Wallet: 0x00bE2293E8a6B0166D08900Abd84C28A976B6833
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.8.20;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval (address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract Eagle is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private bots;
117     address payable private _taxWallet;
118     address payable private _developmentWallet;
119     uint256 firstBlock;
120     uint256 private _initialBuyTax=20;
121     uint256 private _initialSellTax=90;
122     uint256 private _finalBuyTax=3;
123     uint256 private _finalSellTax=3;
124     uint256 private _reduceBuyTaxAt=20;
125     uint256 private _reduceSellTaxAt=40;
126     uint256 private _preventSwapBefore=35;
127     uint256 private _buyCount=0;
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 1000000 * 10**_decimals;
130     string private constant _name = unicode"Eagle";
131     string private constant _symbol = unicode"EAGLE";
132     uint256 public _maxTxAmount = 20000 * 10**_decimals;
133     uint256 public _maxWalletSize = 20000 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 10000 * 10**_decimals;
135     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
136     IUniswapV2Router02 private uniswapV2Router;
137     address public uniswapV2Pair;
138     bool public tradingOpen;
139     bool private inSwap = false;
140     bool private swapEnabled = false;
141     event MaxTxAmountUpdated(uint _maxTxAmount);
142 
143     modifier lockTheSwap {
144         inSwap = true;
145         _;
146         inSwap = false;
147     }
148 
149     constructor () {
150         _taxWallet = payable(0x00bE2293E8a6B0166D08900Abd84C28A976B6833);
151         _developmentWallet = payable(msg.sender);
152         _balances[_msgSender()] = _tTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_taxWallet] = true;
156         emit Transfer(address(0), _msgSender(), _tTotal);       
157     }
158 
159     function name() public pure returns (string memory) {
160         return _name;
161     }
162 
163     function symbol() public pure returns (string memory) {
164         return _symbol;
165     }
166 
167     function decimals() public pure returns (uint8) {
168         return _decimals;
169     }
170 
171     function totalSupply() public pure override returns (uint256) {
172         return _tTotal;
173     }
174 
175     function balanceOf(address account) public view override returns (uint256) {
176         return _balances[account];
177     }
178 
179     function transfer(address recipient, uint256 amount) public override returns (bool) {
180         _transfer(_msgSender(), recipient, amount);
181         return true;
182     }
183 
184     function allowance(address owner, address spender) public view override returns (uint256) {
185         return _allowances[owner][spender];
186     }
187 
188     function approve(address spender, uint256 amount) public override returns (bool) {
189         _approve(_msgSender(), spender, amount);
190         return true;
191     }
192 
193     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
194         _transfer(sender, recipient, amount);
195         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
196         return true;
197     }
198 
199     function _approve(address owner, address spender, uint256 amount) private {
200         require(owner != address(0), "ERC20: approve from the zero address");
201         require(spender != address(0), "ERC20: approve to the zero address");
202         _allowances[owner][spender] = amount;
203         emit Approval(owner, spender, amount);
204     }
205 
206     function _transfer(address from, address to, uint256 amount) private {
207         require(from != address(0), "ERC20: transfer from the zero address");
208         require(to != address(0), "ERC20: transfer to the zero address");
209         require(amount > 0, "Transfer amount must be greater than zero");
210         uint256 taxAmount=0;
211         if (from != owner() && to != owner()) {
212             require(!bots[from] && !bots[to]);
213             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
214 
215             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
216                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
217                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
218 
219                 if (firstBlock + 3  > block.number) {
220                     require(!isContract(to) && msg.sender == tx.origin, "No bots allowed");
221                 }
222                 _buyCount++;
223             }
224 
225             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
226                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
227             }
228 
229             if(to == uniswapV2Pair && from!= address(this) ){
230                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
231             }
232 
233             uint256 contractTokenBalance = balanceOf(address(this));
234             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
235                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
236                 uint256 contractETHBalance = address(this).balance;
237                 if(contractETHBalance > 0) {
238                     sendETHToFee(address(this).balance);
239                 }
240             }
241         }
242         if(taxAmount>0){
243           _balances[address(this)]=_balances[address(this)].add(taxAmount);
244           emit Transfer(from, address(this),taxAmount);
245         }
246         _balances[from]=_balances[from].sub(amount);
247         _balances[to]=_balances[to].add(amount.sub(taxAmount));
248         emit Transfer(from, to, amount.sub(taxAmount));
249     }
250 
251 
252 
253     function min(uint256 a, uint256 b) private pure returns (uint256){
254       return (a>b)?b:a;
255     }
256 
257     function isContract(address account) private view returns (bool) {
258         bool c = account.code.length == 0 ? false : true;
259         return c;
260     }
261 
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = uniswapV2Router.WETH();
266         _approve(address(this), address(uniswapV2Router), tokenAmount);
267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274     }
275 
276     function ForceCoolDownTaX() external onlyOwner{
277            _initialBuyTax=20;
278            _initialSellTax=20;
279     }
280 
281   
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize=_tTotal;
285         emit MaxTxAmountUpdated(_tTotal);
286     }
287 
288     function sendETHToFee(uint256 amount) private {
289         uint256 developmentFee;
290         uint256 taxFee;
291         developmentFee = amount * 15/100;
292         taxFee = amount * 85/100;
293         _developmentWallet.transfer(developmentFee);
294         _taxWallet.transfer(taxFee);
295     }
296 
297     function addBots(address[] memory bots_) public onlyOwner {
298         for (uint i = 0; i < bots_.length; i++) {
299             bots[bots_[i]] = true;
300         }
301     }
302 
303     function delBots(address[] memory notbot) public onlyOwner {
304       for (uint i = 0; i < notbot.length; i++) {
305           bots[notbot[i]] = false;
306       }
307     }
308 
309     function isBot(address a) public view returns (bool){
310       return bots[a];
311     }
312 
313     function openTrading() external onlyOwner() {
314         require(!tradingOpen,"trading is already open");
315         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
316         _approve(address(this), address(uniswapV2Router), _tTotal);
317         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
318         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
319         swapEnabled = true;
320         tradingOpen = true;
321         firstBlock = block.number;
322     }
323 
324     receive() external payable {}
325 }