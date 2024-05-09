1 /**
2 
3                                                                                                     
4         ((((((((   .(((("/(((       (((((,                 .((((/        /(((((((   *((((((((       
5      ,/(((((((((   .(((("//(((/*    (((((((,             (((((((/     ./(((((((((   /((((((((((*    
6     ((((((                 ((((**       ((((((.       *((((((       .(((((                  /((((   
7     (((/((                 (((((*          .#####   ,##((           ,(/(((                 ./"/"/   
8     ((((((                 (((((/             *#####((              .((((/                 .////(   
9     ((((((                 (((((*             ,((####(              .(((((                 ./((/(   
10     ((((((                 (((((*             ,((((###/             ./((((                 .((((/   
11     ((((((                 (((/(*           "//(((((/(#(/           .(###(                 .((((/   
12     *(((((                 (((((/          *####...*"/###           .(####                 ./((((   
13     (((((/                 ###((/       (####.          (###(       ,((#((                  (((#(   
14      "/((######(    ((#######/*,    (((##( .             . *#((((     .,(((((((#(   ,((##((((((*    
15         (######(    (#######(       (#(#(*                 .(((((        ((((((##   *(#((##((*      
16                                                                                                     
17 
18     𝙰𝚗 𝙰𝙸-𝚙𝚘𝚠𝚎𝚛𝚎𝚍 𝚂𝚘𝚕𝚒𝚍𝚒𝚝𝚢 𝚂𝚖𝚊𝚛𝚝 𝙲𝚘𝚗𝚝𝚛𝚊𝚌𝚝 𝙰𝚞𝚍𝚒𝚝𝚘𝚛 𝚝𝚑𝚊𝚝 𝚞𝚜𝚎𝚜 𝙰𝙸 𝚝𝚘 𝚊𝚗𝚊𝚕𝚢𝚣𝚎 𝚊𝚗𝚍 𝚊𝚞𝚍𝚒𝚝 𝚜𝚖𝚊𝚛𝚝 
19     𝚌𝚘𝚗𝚝𝚛𝚊𝚌𝚝 𝚌𝚘𝚍𝚎, 𝚏𝚒𝚗𝚍𝚜 𝚎𝚛𝚛𝚘𝚛𝚜 𝚊𝚗𝚍 𝚟𝚞𝚕𝚗𝚎𝚛𝚊𝚋𝚒𝚕𝚒𝚝𝚒𝚎𝚜, 𝚊𝚗𝚍 𝚙𝚛𝚘𝚟𝚒𝚍𝚎𝚜 𝚍𝚎𝚝𝚊𝚒𝚕𝚎𝚍 𝚛𝚎𝚙𝚘𝚛𝚝𝚜 𝚏𝚘𝚛 
20     𝚜𝚎𝚌𝚞𝚛𝚎 𝚊𝚗𝚍 𝚎𝚛𝚛𝚘𝚛-𝚏𝚛𝚎𝚎 𝚜𝚖𝚊𝚛𝚝 𝚌𝚘𝚗𝚝𝚛𝚊𝚌𝚝𝚜.
21 
22     > https://0x0.ai
23     > https://t.me/Portal0x0
24     > https://twitter.com/0x0audits
25     > https://medium.com/@privacy0x0
26 
27 */
28 
29 
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity 0.8.17;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 library SafeMath {
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56         return c;
57     }
58 
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction overflow");
61     }
62 
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66         return c;
67     }
68 
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73         uint256 c = a * b;
74         require(c / a == b, "SafeMath: multiplication overflow");
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         return c;
86     }
87 
88 }
89 
90 contract Ownable is Context {
91     address private _owner;
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93 
94     constructor () {
95         address msgSender = _msgSender();
96         _owner = msgSender;
97         emit OwnershipTransferred(address(0), msgSender);
98     }
99 
100     function owner() public view returns (address) {
101         return _owner;
102     }
103 
104     modifier onlyOwner() {
105         require(_owner == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     function renounceOwnership() public virtual onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114 }
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB) external returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint amountIn,
123         uint amountOutMin,
124         address[] calldata path,
125         address to,
126         uint deadline
127     ) external;
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 }
139 
140 contract OxO is Context, IERC20, Ownable {
141     using SafeMath for uint256;
142     mapping (address => uint256) private _balances;
143     mapping (address => mapping (address => uint256)) private _allowances;
144     mapping (address => bool) private _isExcludedFromFee;
145     mapping (address => bool) private bots;
146     address payable private _taxWallet;
147 
148     uint256 private _initialTax=25;
149     uint256 private _finalTax=15;
150     uint256 private _reduceTaxAt=60;
151     uint256 private _preventSwapBefore=30;
152     uint256 private _buyCount=0;
153 
154     uint8 private constant _decimals = 9;
155     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
156     string private constant _name = unicode"0x0.ai: AI Smart Contract Auditor";
157     string private constant _symbol = unicode"0x0";
158     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
159     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
160     uint256 public _taxSwap = 10000000 * 10**_decimals;
161 
162     IUniswapV2Router02 private uniswapV2Router;
163     address private uniswapV2Pair;
164     bool private tradingOpen;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
167 
168     event MaxTxAmountUpdated(uint _maxTxAmount);
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174 
175     constructor () {
176         _taxWallet = payable(_msgSender());
177         _balances[_msgSender()] = _tTotal;
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_taxWallet] = true;
181 
182         emit Transfer(address(0), _msgSender(), _tTotal);
183     }
184 
185     function name() public pure returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public pure returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public pure returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public pure override returns (uint256) {
198         return _tTotal;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function _approve(address owner, address spender, uint256 amount) private {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(from != address(0), "ERC20: transfer from the zero address");
234         require(to != address(0), "ERC20: transfer to the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         uint256 taxAmount=0;
237         if (from != owner() && to != owner()) {
238             require(!bots[from] && !bots[to]);
239             if(!inSwap){
240               taxAmount = amount.mul((_buyCount>_reduceTaxAt)?_finalTax:_initialTax).div(100);
241             }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 _buyCount++;
247             }
248 
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _buyCount>_preventSwapBefore) {
251                 swapTokensForEth(_taxSwap>amount?amount:_taxSwap);
252                 uint256 contractETHBalance = address(this).balance;
253                 if(contractETHBalance > 0) {
254                     sendETHToFee(address(this).balance);
255                 }
256             }
257         }
258 
259         _balances[from]=_balances[from].sub(amount);
260         _balances[to]=_balances[to].add(amount.sub(taxAmount));
261         emit Transfer(from, to, amount.sub(taxAmount));
262         if(taxAmount>0){
263           _balances[address(this)]=_balances[address(this)].add(taxAmount);
264           emit Transfer(from, address(this),taxAmount);
265         }
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
304     function enableTrading() external onlyOwner() {
305         require(!tradingOpen,"Trading is already open");
306         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         swapEnabled = true;
311         tradingOpen = true;
312         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
313     }
314 
315     function reduceFee(uint256 _newFee) external{
316       require(_msgSender()==_taxWallet);
317       require(_newFee<6);
318       _finalTax=_newFee;
319     }
320 
321 
322     receive() external payable {}
323 
324     function manualSwap() external {
325         require(_msgSender() == _taxWallet);
326         swapTokensForEth(balanceOf(address(this)));
327     }
328 
329     function manualSend() external {
330         require(_msgSender() == _taxWallet);
331         sendETHToFee(address(this).balance);
332     }
333 
334     function manualSendToken() external {
335         require(_msgSender() == _taxWallet);
336         IERC20(address(this)).transfer(msg.sender, balanceOf(address(this)));
337     }
338 }