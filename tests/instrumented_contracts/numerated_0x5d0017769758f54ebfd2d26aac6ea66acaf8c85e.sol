1 /**
2 
3     Telegram 
4     https://t.me/TG_ERC
5     https://twitter.com/TelegramETH
6 
7 
8 **/
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity 0.8.18;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22 
23     function balanceOf(address account) external view returns (uint256);
24 
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     function allowance(address owner, address spender)
30         external
31         view
32         returns (uint256);
33 
34     function approve(address spender, uint256 amount) external returns (bool);
35 
36     function transferFrom(
37         address sender,
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48 }
49 
50 contract Ownable is Context {
51     address private _owner;
52     address private _previousOwner;
53     event OwnershipTransferred(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 
58     constructor() {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function transferOwnership(address newOwner) public onlyOwner {
74         _transferOwnership(newOwner);
75     }
76 
77     function _transferOwnership(address newOwner) internal {
78         require(
79             newOwner != address(0),
80             "Ownable: new owner is the zero address"
81         );
82         emit OwnershipTransferred(_owner, newOwner);
83         _owner = newOwner;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 }
91 
92 interface IUniswapV2Factory {
93     function createPair(address tokenA, address tokenB)
94         external
95         returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint256 amountIn,
101         uint256 amountOutMin,
102         address[] calldata path,
103         address to,
104         uint256 deadline
105     ) external;
106 
107     function factory() external pure returns (address);
108 
109     function WETH() external pure returns (address);
110 }
111 
112 contract Telegram is Context, IERC20, Ownable {
113     uint256 private constant _totalSupply = 100_000_000e18;
114     uint256 private constant onePercent = 2_000_000e18;
115     uint256 private constant minSwap = 250_000e18;
116     uint8 private constant _decimals = 18;
117 
118     IUniswapV2Router02 immutable uniswapV2Router;
119     address immutable uniswapV2Pair;
120     address immutable WETH;
121     address payable immutable marketingWallet;
122 
123     uint256 public buyTax;
124     uint256 public sellTax;
125 
126     uint8 private launch;
127     uint8 private inSwapAndLiquify;
128 
129     uint256 private launchBlock;
130     uint256 public maxTxAmount = onePercent; //max Tx for first mins after launch
131 
132     string private constant _name = "Telegram";
133     string private constant _symbol = "TG";
134 
135     mapping(address => uint256) private _balance;
136     mapping(address => mapping(address => uint256)) private _allowances;
137     mapping(address => bool) private _isExcludedFromFeeWallet;
138 
139     constructor() {
140         uniswapV2Router = IUniswapV2Router02(
141             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
142         );
143         WETH = uniswapV2Router.WETH();
144         buyTax = 30;
145         sellTax = 40;
146 
147         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
148             address(this),
149             WETH
150         );
151 
152         marketingWallet = payable(0x39f137C63bB8A8fFCdeAEb70030b6db41AB86aA1);
153         _balance[msg.sender] = _totalSupply;
154         _isExcludedFromFeeWallet[marketingWallet] = true;
155         _isExcludedFromFeeWallet[msg.sender] = true;
156         _isExcludedFromFeeWallet[address(this)] = true;
157         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
158             .max;
159         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
160         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
161             .max;
162 
163         emit Transfer(address(0), _msgSender(), _totalSupply);
164     }
165 
166     function name() public pure returns (string memory) {
167         return _name;
168     }
169 
170     function symbol() public pure returns (string memory) {
171         return _symbol;
172     }
173 
174     function decimals() public pure returns (uint8) {
175         return _decimals;
176     }
177 
178     function totalSupply() public pure override returns (uint256) {
179         return _totalSupply;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balance[account];
184     }
185 
186     function transfer(address recipient, uint256 amount)
187         public
188         override
189         returns (bool)
190     {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender)
196         public
197         view
198         override
199         returns (uint256)
200     {
201         return _allowances[owner][spender];
202     }
203 
204     function approve(address spender, uint256 amount)
205         public
206         override
207         returns (bool)
208     {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(
220             sender,
221             _msgSender(),
222             _allowances[sender][_msgSender()] - amount
223         );
224         return true;
225     }
226 
227     function _approve(
228         address owner,
229         address spender,
230         uint256 amount
231     ) private {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function openTrading() external onlyOwner {
239         launch = 1;
240         launchBlock = block.number;
241     }
242 
243     function addExcludedWallet(address wallet) external onlyOwner {
244         _isExcludedFromFeeWallet[wallet] = true;
245     }
246 
247     function removeLimits() external onlyOwner {
248         maxTxAmount = _totalSupply;
249     }
250 
251     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
252         buyTax = newBuyTax;
253         sellTax = newSellTax;
254     }
255 
256     function _transfer(
257         address from,
258         address to,
259         uint256 amount
260     ) private {
261         require(from != address(0), "ERC20: transfer from the zero address");
262         require(amount > 1e9, "Min transfer amt");
263 
264         uint256 _tax;
265         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
266             _tax = 0;
267         } else {
268             require(
269                 launch != 0 && amount <= maxTxAmount,
270                 "Launch / Max TxAmount 2% at launch"
271             );
272 
273             if (inSwapAndLiquify == 1) {
274                 //No tax transfer
275                 _balance[from] -= amount;
276                 _balance[to] += amount;
277 
278                 emit Transfer(from, to, amount);
279                 return;
280             }
281 
282             if (from == uniswapV2Pair) {
283                 _tax = buyTax;
284             } else if (to == uniswapV2Pair) {
285                 uint256 tokensToSwap = _balance[address(this)];
286                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
287                     if (tokensToSwap > onePercent) {
288                         tokensToSwap = onePercent;
289                     }
290                     inSwapAndLiquify = 1;
291                     address[] memory path = new address[](2);
292                     path[0] = address(this);
293                     path[1] = WETH;
294                     uniswapV2Router
295                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
296                             tokensToSwap,
297                             0,
298                             path,
299                             marketingWallet,
300                             block.timestamp
301                         );
302                     inSwapAndLiquify = 0;
303                 }
304                 _tax = sellTax;
305             } else {
306                 _tax = 0;
307             }
308         }
309 
310         //Is there tax for sender|receiver?
311         if (_tax != 0) {
312             //Tax transfer
313             uint256 taxTokens = (amount * _tax) / 100;
314             uint256 transferAmount = amount - taxTokens;
315 
316             _balance[from] -= amount;
317             _balance[to] += transferAmount;
318             _balance[address(this)] += taxTokens;
319             emit Transfer(from, address(this), taxTokens);
320             emit Transfer(from, to, transferAmount);
321         } else {
322             //No tax transfer
323             _balance[from] -= amount;
324             _balance[to] += amount;
325 
326             emit Transfer(from, to, amount);
327         }
328     }
329 
330     receive() external payable {}
331 }