1 /**
2     $ƎNIℲ | Inverted Fine
3 
4     https://twitter.com/InvertedFine 
5 
6     https://t.me/invertedfine
7 
8     https://invertedfine.site/ 
9     
10 **/
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity 0.8.18;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23 
24     function balanceOf(address account) external view returns (uint256);
25 
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     function allowance(address owner, address spender)
31         external
32         view
33         returns (uint256);
34 
35     function approve(address spender, uint256 amount) external returns (bool);
36 
37     function transferFrom(
38         address sender,
39         address recipient,
40         uint256 amount
41     ) external returns (bool);
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(
45         address indexed owner,
46         address indexed spender,
47         uint256 value
48     );
49 }
50 
51 contract Ownable is Context {
52     address private _owner;
53     address private _previousOwner;
54     event OwnershipTransferred(
55         address indexed previousOwner,
56         address indexed newOwner
57     );
58 
59     constructor() {
60         address msgSender = _msgSender();
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     function transferOwnership(address newOwner) public onlyOwner {
75         _transferOwnership(newOwner);
76     }
77 
78     function _transferOwnership(address newOwner) internal {
79         require(
80             newOwner != address(0),
81             "Ownable: new owner is the zero address"
82         );
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB)
95         external
96         returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint256 amountIn,
102         uint256 amountOutMin,
103         address[] calldata path,
104         address to,
105         uint256 deadline
106     ) external;
107 
108     function factory() external pure returns (address);
109 
110     function WETH() external pure returns (address);
111 }
112 
113 contract FINE is Context, IERC20, Ownable {
114     uint256 private constant _totalSupply = 10_000_000e18;
115     uint256 private constant onePercent = 100_000e18;
116     uint256 private constant minSwap = 25_000e18;
117     uint8 private constant _decimals = 18;
118 
119     IUniswapV2Router02 immutable uniswapV2Router;
120     address immutable uniswapV2Pair;
121     address immutable WETH;
122     address payable immutable marketingWallet;
123 
124     uint256 public buyTax;
125     uint256 public sellTax;
126 
127     uint8 private launch;
128     uint8 private inSwapAndLiquify;
129 
130     uint256 private launchBlock;
131     uint256 public maxTxAmount = onePercent * 2; //max Tx for first mins after launch
132 
133     string private constant _name = unicode"ƎNIℲ";
134     string private constant _symbol = unicode"ƎNIℲ";
135 
136     mapping(address => uint256) private _balance;
137     mapping(address => mapping(address => uint256)) private _allowances;
138     mapping(address => bool) private _isExcludedFromFeeWallet;
139 
140     constructor() {
141         uniswapV2Router = IUniswapV2Router02(
142             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
143         );
144         WETH = uniswapV2Router.WETH();
145         buyTax = 25;
146         sellTax = 40;
147 
148         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
149             address(this),
150             WETH
151         );
152 
153         marketingWallet = payable(0x99Dcd9542F0605F105028CC03A001fae2FC8c148);
154         _balance[msg.sender] = _totalSupply;
155         _isExcludedFromFeeWallet[marketingWallet] = true;
156         _isExcludedFromFeeWallet[msg.sender] = true;
157         _isExcludedFromFeeWallet[address(this)] = true;
158         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
159             .max;
160         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
161         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
162             .max;
163 
164         emit Transfer(address(0), _msgSender(), _totalSupply);
165     }
166 
167     function name() public pure returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public pure returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public pure returns (uint8) {
176         return _decimals;
177     }
178 
179     function totalSupply() public pure override returns (uint256) {
180         return _totalSupply;
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return _balance[account];
185     }
186 
187     function transfer(address recipient, uint256 amount)
188         public
189         override
190         returns (bool)
191     {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender)
197         public
198         view
199         override
200         returns (uint256)
201     {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount)
206         public
207         override
208         returns (bool)
209     {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(
215         address sender,
216         address recipient,
217         uint256 amount
218     ) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(
221             sender,
222             _msgSender(),
223             _allowances[sender][_msgSender()] - amount
224         );
225         return true;
226     }
227 
228     function _approve(
229         address owner,
230         address spender,
231         uint256 amount
232     ) private {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function openTrading() external onlyOwner {
240         launch = 1;
241         launchBlock = block.number;
242     }
243 
244     function addExcludedWallet(address wallet) external onlyOwner {
245         _isExcludedFromFeeWallet[wallet] = true;
246     }
247 
248     function removeLimits() external onlyOwner {
249         maxTxAmount = _totalSupply;
250     }
251 
252     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
253         require(newBuyTax < 26, "Cannot set buy tax greater than 60%");
254         require(newSellTax < 41, "Cannot set sell tax greater than 60%");
255         buyTax = newBuyTax;
256         sellTax = newSellTax;
257     }
258 
259     function _transfer(
260         address from,
261         address to,
262         uint256 amount
263     ) private {
264         require(from != address(0), "ERC20: transfer from the zero address");
265         require(amount > 1e9, "Min transfer amt");
266 
267         uint256 _tax;
268         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
269             _tax = 0;
270         } else {
271             require(
272                 launch != 0 && amount <= maxTxAmount,
273                 "Launch / Max TxAmount 1% at launch"
274             );
275 
276             if (inSwapAndLiquify == 1) {
277                 //No tax transfer
278                 _balance[from] -= amount;
279                 _balance[to] += amount;
280 
281                 emit Transfer(from, to, amount);
282                 return;
283             }
284 
285             if (from == uniswapV2Pair) {
286                 _tax = buyTax;
287             } else if (to == uniswapV2Pair) {
288                 uint256 tokensToSwap = _balance[address(this)];
289                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
290                     if (tokensToSwap > onePercent) {
291                         tokensToSwap = onePercent;
292                     }
293                     inSwapAndLiquify = 1;
294                     address[] memory path = new address[](2);
295                     path[0] = address(this);
296                     path[1] = WETH;
297                     uniswapV2Router
298                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
299                             tokensToSwap,
300                             0,
301                             path,
302                             marketingWallet,
303                             block.timestamp
304                         );
305                     inSwapAndLiquify = 0;
306                 }
307                 _tax = sellTax;
308             } else {
309                 _tax = 0;
310             }
311         }
312 
313         //Is there tax for sender|receiver?
314         if (_tax != 0) {
315             //Tax transfer
316             uint256 taxTokens = (amount * _tax) / 100;
317             uint256 transferAmount = amount - taxTokens;
318 
319             _balance[from] -= amount;
320             _balance[to] += transferAmount;
321             _balance[address(this)] += taxTokens;
322             emit Transfer(from, address(this), taxTokens);
323             emit Transfer(from, to, transferAmount);
324         } else {
325             //No tax transfer
326             _balance[from] -= amount;
327             _balance[to] += amount;
328 
329             emit Transfer(from, to, amount);
330         }
331     }
332 
333     receive() external payable {}
334 }