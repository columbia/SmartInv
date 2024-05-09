1 /**
2    
3     Telegram : https://t.me/PepeClassicERC20
4 
5     Twitter  : https://twitter.com/eth_pepeclassic
6    
7 **/
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity 0.8.18;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount)
24         external
25         returns (bool);
26 
27     function allowance(address owner, address spender)
28         external
29         view
30         returns (uint256);
31 
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     function transferFrom(
35         address sender,
36         address recipient,
37         uint256 amount
38     ) external returns (bool);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(
42         address indexed owner,
43         address indexed spender,
44         uint256 value
45     );
46 }
47 
48 contract Ownable is Context {
49     address private _owner;
50     address private _previousOwner;
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     constructor() {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     modifier onlyOwner() {
67         require(_owner == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     function transferOwnership(address newOwner) public onlyOwner {
72         _transferOwnership(newOwner);
73     }
74 
75     function _transferOwnership(address newOwner) internal {
76         require(
77             newOwner != address(0),
78             "Ownable: new owner is the zero address"
79         );
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB)
92         external
93         returns (address pair);
94 }
95 
96 interface IUniswapV2Router02 {
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint256 amountIn,
99         uint256 amountOutMin,
100         address[] calldata path,
101         address to,
102         uint256 deadline
103     ) external;
104 
105     function factory() external pure returns (address);
106 
107     function WETH() external pure returns (address);
108 }
109 
110 contract PepeClassic is Context, IERC20, Ownable {
111     uint256 private constant _totalSupply = 420_690_000e18;
112     uint256 private constant onePercent = 8_413_800e18;
113     uint256 private constant minSwap = 250_000e18;
114     uint8 private constant _decimals = 18;
115 
116     IUniswapV2Router02 immutable uniswapV2Router;
117     address immutable uniswapV2Pair;
118     address immutable WETH;
119     address payable immutable marketingWallet;
120 
121     uint256 public buyTax;
122     uint256 public sellTax;
123 
124     uint8 private launch;
125     uint8 private inSwapAndLiquify;
126 
127     uint256 private launchBlock;
128     uint256 public maxTxAmount = onePercent; //max Tx for first mins after launch
129 
130     string private constant _name = "Pepe Classic";
131     string private constant _symbol = "PC";
132 
133     mapping(address => uint256) private _balance;
134     mapping(address => mapping(address => uint256)) private _allowances;
135     mapping(address => bool) private _isExcludedFromFeeWallet;
136 
137     constructor() {
138         uniswapV2Router = IUniswapV2Router02(
139             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
140         );
141         WETH = uniswapV2Router.WETH();
142         buyTax = 20;
143         sellTax = 30;
144 
145         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
146             address(this),
147             WETH
148         );
149 
150         marketingWallet = payable(0xa7c8131D2feE27C6431Bf62816f3De02902745eE);
151         _balance[msg.sender] = _totalSupply;
152         _isExcludedFromFeeWallet[marketingWallet] = true;
153         _isExcludedFromFeeWallet[msg.sender] = true;
154         _isExcludedFromFeeWallet[address(this)] = true;
155         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
156             .max;
157         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
158         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
159             .max;
160 
161         emit Transfer(address(0), _msgSender(), _totalSupply);
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
177         return _totalSupply;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balance[account];
182     }
183 
184     function transfer(address recipient, uint256 amount)
185         public
186         override
187         returns (bool)
188     {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender)
194         public
195         view
196         override
197         returns (uint256)
198     {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount)
203         public
204         override
205         returns (bool)
206     {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(
212         address sender,
213         address recipient,
214         uint256 amount
215     ) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(
218             sender,
219             _msgSender(),
220             _allowances[sender][_msgSender()] - amount
221         );
222         return true;
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function openTrading() external onlyOwner {
237         launch = 1;
238         launchBlock = block.number;
239     }
240 
241     function addExcludedWallet(address wallet) external onlyOwner {
242         _isExcludedFromFeeWallet[wallet] = true;
243     }
244 
245     function removeLimits() external onlyOwner {
246         maxTxAmount = _totalSupply;
247     }
248 
249     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
250         buyTax = newBuyTax;
251         sellTax = newSellTax;
252     }
253 
254     function _transfer(
255         address from,
256         address to,
257         uint256 amount
258     ) private {
259         require(from != address(0), "ERC20: transfer from the zero address");
260         require(amount > 1e9, "Min transfer amt");
261 
262         uint256 _tax;
263         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
264             _tax = 0;
265         } else {
266             require(
267                 launch != 0 && amount <= maxTxAmount,
268                 "Launch / Max TxAmount 1% at launch"
269             );
270 
271             if (inSwapAndLiquify == 1) {
272                 //No tax transfer
273                 _balance[from] -= amount;
274                 _balance[to] += amount;
275 
276                 emit Transfer(from, to, amount);
277                 return;
278             }
279 
280             if (from == uniswapV2Pair) {
281                 _tax = buyTax;
282             } else if (to == uniswapV2Pair) {
283                 uint256 tokensToSwap = _balance[address(this)];
284                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
285                     if (tokensToSwap > onePercent) {
286                         tokensToSwap = onePercent;
287                     }
288                     inSwapAndLiquify = 1;
289                     address[] memory path = new address[](2);
290                     path[0] = address(this);
291                     path[1] = WETH;
292                     uniswapV2Router
293                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
294                             tokensToSwap,
295                             0,
296                             path,
297                             marketingWallet,
298                             block.timestamp
299                         );
300                     inSwapAndLiquify = 0;
301                 }
302                 _tax = sellTax;
303             } else {
304                 _tax = 0;
305             }
306         }
307 
308         //Is there tax for sender|receiver?
309         if (_tax != 0) {
310             //Tax transfer
311             uint256 taxTokens = (amount * _tax) / 100;
312             uint256 transferAmount = amount - taxTokens;
313 
314             _balance[from] -= amount;
315             _balance[to] += transferAmount;
316             _balance[address(this)] += taxTokens;
317             emit Transfer(from, address(this), taxTokens);
318             emit Transfer(from, to, transferAmount);
319         } else {
320             //No tax transfer
321             _balance[from] -= amount;
322             _balance[to] += amount;
323 
324             emit Transfer(from, to, amount);
325         }
326     }
327 
328     receive() external payable {}
329 }