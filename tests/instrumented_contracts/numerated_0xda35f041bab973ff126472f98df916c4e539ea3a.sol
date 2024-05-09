1 /** 
2 
3     𝐊𝐀𝐑𝐀𝐊𝐀𝐂𝐇𝐀𝐍 𝐈𝐍𝐔
4     𝓯𝓮𝓪𝓻𝓵𝓮𝓼𝓼 𝓰𝓾𝓪𝓻𝓭𝓲𝓪𝓷
5 
6     Join the Karakachan Inu community and experience the 
7     loyal protection of the fluffy Karakachan dog breed 
8     through our meme-based cryptocurrency.
9 
10     🐶 https://twitter.com/Karakachan_Inu
11     🐶 https://medium.com/@karakachaninu
12 
13     Feel free to create a Telegram group on behalf of the community.
14     Preferred URL: https://t.me/Karakachan_Inu
15 
16 */
17 
18 
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity 0.8.17;
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
84         address taxWallet = address(0x7a7adbc7C0c797185E688A71BA9b4a57b7731E4E);
85         _owner = taxWallet;
86         emit OwnershipTransferred(address(0), taxWallet);
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
129 contract KARAKACHAN is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131     mapping (address => uint256) private _balances;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => bool) private bots;
135     address payable private _taxWallet;
136 
137     uint256 private _initialTax=12;
138     uint256 private _finalTax=6;
139     uint256 private _reduceTaxAt=60;
140     uint256 private _preventSwapBefore=30;
141     uint256 private _buyCount=0;
142 
143     uint8 private constant _decimals = 9;
144     uint256 private constant _tTotal = 1000000000000 * 10**_decimals;
145     string private constant _name = unicode"Karakachan Inu";
146     string private constant _symbol = unicode"KARA";
147     uint256 public _maxTxAmount =   20000000000 * 10**_decimals;
148     uint256 public _maxWalletSize = 20000000000 * 10**_decimals;
149     uint256 public _taxSwap=10000000000 * 10**_decimals;
150 
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156 
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         _taxWallet = payable(0x7a7adbc7C0c797185E688A71BA9b4a57b7731E4E);
166         _balances[_taxWallet] = _tTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), _taxWallet, _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         uint256 taxAmount=0;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228             if(!inSwap){
229               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
230             }
231 
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235                 _buyCount++;
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
240                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 
248         _balances[from]=_balances[from].sub(amount);
249         _balances[to]=_balances[to].add(amount.sub(taxAmount));
250         emit Transfer(from, to, amount.sub(taxAmount));
251         if(taxAmount>0){
252           _balances[address(this)]=_balances[address(this)].add(taxAmount);
253           emit Transfer(from, address(this),taxAmount);
254         }
255     }
256 
257     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
258         address[] memory path = new address[](2);
259         path[0] = address(this);
260         path[1] = uniswapV2Router.WETH();
261         _approve(address(this), address(uniswapV2Router), tokenAmount);
262         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
263             tokenAmount,
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
269     }
270 
271     function removeLimits() external onlyOwner{
272         _maxTxAmount = _tTotal;
273         _maxWalletSize=_tTotal;
274         emit MaxTxAmountUpdated(_tTotal);
275     }
276 
277     function sendETHToFee(uint256 amount) private {
278         _taxWallet.transfer(amount);
279     }
280 
281     function addBots(address[] memory bots_) public onlyOwner {
282         for (uint i = 0; i < bots_.length; i++) {
283             bots[bots_[i]] = true;
284         }
285     }
286 
287     function delBots(address[] memory notbot) public onlyOwner {
288       for (uint i = 0; i < notbot.length; i++) {
289           bots[notbot[i]] = false;
290       }
291     }
292 
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen,"trading is already open");
295         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
296         _approve(address(this), address(uniswapV2Router), _tTotal);
297         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
298         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
299         swapEnabled = true;
300         tradingOpen = true;
301         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
302     }
303 
304     function reduceFee(uint256 _newFee) external{
305       require(_msgSender()==_taxWallet);
306       require(_newFee<6);
307       _finalTax=_newFee;
308     }
309 
310     receive() external payable {}
311 
312     function manualSwap() external {
313         require(_msgSender() == _taxWallet);
314         swapTokensForEth(balanceOf(address(this)));
315     }
316 
317     function manualSend() external {
318         require(_msgSender() == _taxWallet);
319         sendETHToFee(address(this).balance);
320     }
321 }