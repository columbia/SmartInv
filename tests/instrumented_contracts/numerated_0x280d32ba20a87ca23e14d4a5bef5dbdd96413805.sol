1 //https://t.me/BabyDorkLord
2 // SPDX-License-Identifier: MIT
3 
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
111 contract BabyDork is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _balances;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private bots;
117     address payable private _taxWallet;
118     uint256 firstBlock;
119 
120     uint256 private _initialBuyTax=20;
121     uint256 private _initialSellTax=20;
122     uint256 private _finalBuyTax=0;
123     uint256 private _finalSellTax=0;
124     uint256 private _reduceBuyTaxAt=10;
125     uint256 private _reduceSellTaxAt=20;
126     uint256 private _preventSwapBefore=20;
127     uint256 private _buyCount=0;
128 
129     uint8 private constant _decimals = 9;
130     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
131     string private constant _name = unicode"BABY ᗪOᖇK ᒪOᖇᗪ";
132     string private constant _symbol = unicode"BABYᗪOᖇKᒪ";
133     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
134     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
135     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
136     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143 
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152 
153         _taxWallet = payable(_msgSender());
154         _balances[_msgSender()] = _tTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_taxWallet] = true;
158 
159         emit Transfer(address(0), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _balances[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function _approve(address owner, address spender, uint256 amount) private {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _transfer(address from, address to, uint256 amount) private {
210         require(from != address(0), "ERC20: transfer from the zero address");
211         require(to != address(0), "ERC20: transfer to the zero address");
212         require(amount > 0, "Transfer amount must be greater than zero");
213         uint256 taxAmount=0;
214         if (from != owner() && to != owner()) {
215             require(!bots[from] && !bots[to]);
216             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
217 
218             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
219                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
220                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
221 
222                 if (firstBlock + 3  > block.number) {
223                     require(!isContract(to));
224                 }
225                 _buyCount++;
226             }
227 
228             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230             }
231 
232             if(to == uniswapV2Pair && from!= address(this) ){
233                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
234             }
235 
236             uint256 contractTokenBalance = balanceOf(address(this));
237             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
238                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
239                 uint256 contractETHBalance = address(this).balance;
240                 if(contractETHBalance > 0) {
241                     sendETHToFee(address(this).balance);
242                 }
243             }
244         }
245 
246         if(taxAmount>0){
247           _balances[address(this)]=_balances[address(this)].add(taxAmount);
248           emit Transfer(from, address(this),taxAmount);
249         }
250         _balances[from]=_balances[from].sub(amount);
251         _balances[to]=_balances[to].add(amount.sub(taxAmount));
252         emit Transfer(from, to, amount.sub(taxAmount));
253     }
254 
255 
256     function min(uint256 a, uint256 b) private pure returns (uint256){
257       return (a>b)?b:a;
258     }
259 
260     function isContract(address account) private view returns (bool) {
261         uint256 size;
262         assembly {
263             size := extcodesize(account)
264         }
265         return size > 0;
266     }
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281 
282     function removeLimits() external onlyOwner{
283         _maxTxAmount = _tTotal;
284         _maxWalletSize=_tTotal;
285         emit MaxTxAmountUpdated(_tTotal);
286     }
287 
288     function sendETHToFee(uint256 amount) private {
289         _taxWallet.transfer(amount);
290     }
291 
292     function addBots(address[] memory bots_) public onlyOwner {
293         for (uint i = 0; i < bots_.length; i++) {
294             bots[bots_[i]] = true;
295         }
296     }
297 
298     function delBots(address[] memory notbot) public onlyOwner {
299       for (uint i = 0; i < notbot.length; i++) {
300           bots[notbot[i]] = false;
301       }
302     }
303 
304     function isBot(address a) public view returns (bool){
305       return bots[a];
306     }
307 
308     function openTrading() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
311         _approve(address(this), address(uniswapV2Router), _tTotal);
312         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
313         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315         swapEnabled = true;
316         tradingOpen = true;
317         firstBlock = block.number;
318     }
319 
320     receive() external payable {}
321 
322 }