1 // SPDX-License-Identifier: Unlicensed
2 /**
3     Proof of Anon: A toolkit that enhances anonymity and reimagines the boundaries of degens' digital interactions in DeFi.
4 
5     dApp: https://hashless.org/
6 
7     Socials:
8     https://twitter.com/proofofanon
9     https://t.me/proofofanon
10     https://proofofanon.com/
11     https://medium.com/@theproofproject0
12 **/
13 pragma solidity ^0.8.18;
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
51 interface IUniswapV2Factory {
52     function createPair(address tokenA, address tokenB)
53         external
54         returns (address pair);
55 }
56 
57 interface IUniswapV2Router02 {
58     function swapExactTokensForETHSupportingFeeOnTransferTokens(
59         uint256 amountIn,
60         uint256 amountOutMin,
61         address[] calldata path,
62         address to,
63         uint256 deadline
64     ) external;
65 
66     function factory() external pure returns (address);
67 
68     function WETH() external pure returns (address);
69 }
70 
71 contract ProofOfAnon is Context, IERC20 {
72     IUniswapV2Router02 immutable uniswapV2Router;
73     address immutable uniswapV2Pair;
74     address immutable WETH;
75     address payable immutable marketingWallet;
76 
77     address public _owner = msg.sender;
78     address public GOVERNANCE;
79     uint8 private launch;
80     uint8 private inSwapAndLiquify;
81 
82     uint256 private _totalSupply        = 10_000_000e18;
83     uint256 public maxTxAmount = 200_000e18;
84     uint256 private constant onePercent =   200_000e18;
85     uint256 private constant minSwap    =     20_000e18;
86 
87     uint256 public buyTax;
88     uint256 public sellTax;
89     uint256 public burnRate = 0;
90 
91     uint256 private launchBlock;
92   
93     uint256 public _transactionVolumeCurrent;
94     uint256 public _transactionVolumePrevious;
95     uint256 public _lastBucketTime = block.timestamp;
96     uint256 private constant _bucketDuration = 60 minutes;
97 
98     mapping(address => uint256) private _balance;
99     mapping(address => mapping(address => uint256)) private _allowances;
100     mapping(address => bool) private _isExcludedFromFeeWallet;
101 
102     function onlyOwner() internal view {
103         require(_owner == msg.sender || msg.sender == GOVERNANCE);
104     }
105 
106     constructor(address GOVERNANCE_ADDRESS) {
107         GOVERNANCE = GOVERNANCE_ADDRESS;
108         uniswapV2Router = IUniswapV2Router02(
109             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
110         );
111         WETH = uniswapV2Router.WETH();
112         buyTax = 100;
113         sellTax = 100;
114 
115         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
116             address(this),
117             WETH
118         );
119 
120         marketingWallet = payable(0xceEE064D6C2F3669dC0ad4cA253f8BED89741425);
121         _balance[msg.sender] = _totalSupply;
122 
123         _isExcludedFromFeeWallet[marketingWallet] = true;
124         _isExcludedFromFeeWallet[msg.sender] = true;
125         _isExcludedFromFeeWallet[address(this)] = true;
126         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
127             .max;
128         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
129         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
130             .max;
131 
132         emit Transfer(address(0), _msgSender(), _totalSupply);
133     }
134 
135     function name() public pure returns (string memory) {
136         return "Proof of Anon";
137     }
138 
139     function symbol() public pure returns (string memory) {
140         return "PRF";
141     }
142 
143     function decimals() public pure returns (uint8) {
144         return 18;
145     }
146 
147     function totalSupply() public view override returns (uint256) {
148         return _totalSupply;
149     }
150 
151     function balanceOf(address account) public view override returns (uint256) {
152         return _balance[account];
153     }
154 
155     function transfer(address recipient, uint256 amount)
156         public
157         override
158         returns (bool)
159     {
160         _transfer(_msgSender(), recipient, amount);
161         return true;
162     }
163 
164     function allowance(address owner, address spender)
165         public
166         view
167         override
168         returns (uint256)
169     {
170         return _allowances[owner][spender];
171     }
172 
173     function approve(address spender, uint256 amount)
174         public
175         override
176         returns (bool)
177     {
178         _approve(_msgSender(), spender, amount);
179         return true;
180     }
181 
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) public override returns (bool) {
187         _transfer(sender, recipient, amount);
188         _approve(
189             sender,
190             _msgSender(),
191             _allowances[sender][_msgSender()] - amount
192         );
193         return true;
194     }
195 
196     function _approve(
197         address owner,
198         address spender,
199         uint256 amount
200     ) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function openTrading() external  {
208         onlyOwner();
209         require(launch != 1);
210         launch = 1;
211         launchBlock = block.number;
212     }
213 
214     function addExcludedWallet(address wallet) external {
215         onlyOwner();
216         _isExcludedFromFeeWallet[wallet] = true;
217     }
218 
219     function removeLimits() external  {
220         onlyOwner();
221         maxTxAmount = _totalSupply;
222     }
223 
224     function changeTax(uint256 newBuyTax, uint256 newSellTax, uint256 newBurnRate)
225         external
226         
227     {
228         onlyOwner();
229         require(newBuyTax + newSellTax + newBurnRate <= 20, "Taxes more than 20%");
230         buyTax = newBuyTax * 100;
231         sellTax = newSellTax * 100;
232         burnRate = newBurnRate * 100;
233     }
234 
235     function burn(uint256 amount) external {
236         _burn(msg.sender, amount);
237     }
238 
239     function _burn(address account, uint256 amount) internal virtual {
240         require(account != address(0), "ERC20: burn from the zero address");
241 
242         uint256 accountBalance = _balance[account];
243         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
244         unchecked {
245             _balance[account] = accountBalance - amount;
246         }
247         _totalSupply -= amount;
248 
249         emit Transfer(account, address(0), amount);
250     }
251 
252     function _transfer(
253         address from,
254         address to,
255         uint256 amount
256     ) private {
257         require(from != address(0), "ERC20: transfer from the zero address");
258         require(amount > 1e9, "Min transfer amt");
259         //Update current _burnRate
260 
261         unchecked {
262 	    _transactionVolumeCurrent += amount;
263             if (block.timestamp >= _lastBucketTime + _bucketDuration) {
264                 //If current > previous
265                 if (_transactionVolumeCurrent > _transactionVolumePrevious) {
266                     if (burnRate + 50 <= 200) {
267                         //Add 0.25% to _burnRate
268                         burnRate += 50;
269                     }
270                     //else remain at 0 until volume decreases
271                 } else {
272 		    //If previous > current or previous == current
273 		    if (burnRate >= 50) {
274                         //Remove 0.5% from _burnRate
275                         burnRate -= 50;
276                     }
277                     
278                 }
279                 _transactionVolumePrevious = _transactionVolumeCurrent;
280                 _transactionVolumeCurrent = 0;
281                 _lastBucketTime = block.timestamp;
282             }
283         }
284 	
285         uint256 _tax;
286         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
287             _tax = 0;
288         } else {
289             require(
290                 launch != 0 && amount <= maxTxAmount,
291                 "Launch / Max TxAmount 1% at launch"
292             );
293 
294             if (inSwapAndLiquify == 1) {
295                 //No tax transfer
296                 _balance[from] -= amount;
297                 _balance[to] += amount;
298                 emit Transfer(from, to, amount);
299                 return;
300             }
301 
302             if (from == uniswapV2Pair) {
303                 _tax = buyTax;
304             } else if (to == uniswapV2Pair) {
305                 uint256 tokensToSwap = _balance[address(this)];
306                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
307                     if (tokensToSwap > onePercent) {
308                         tokensToSwap = onePercent;
309                     }
310                     inSwapAndLiquify = 1;
311                     address[] memory path = new address[](2);
312                     path[0] = address(this);
313                     path[1] = WETH;
314                     uniswapV2Router
315                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
316                             tokensToSwap,
317                             0,
318                             path,
319                             marketingWallet,
320                             block.timestamp
321                         );
322                     inSwapAndLiquify = 0;
323                 }
324                 _tax = sellTax;
325             } else {
326                 _tax = 0;
327             }
328         }
329 
330 
331         if (_tax != 0) {
332             uint256 burnTokens = amount * burnRate / 10000;
333             uint256 taxTokens = amount * _tax / 10000;
334             uint256 transferAmount = amount - (burnTokens + taxTokens);
335 
336             _balance[from] -= amount;
337             _balance[to] += transferAmount;
338             _balance[address(this)] += taxTokens;
339             _totalSupply -= burnTokens;
340             emit Transfer(from, address(0), burnTokens);
341             emit Transfer(from, address(this), taxTokens);
342             emit Transfer(from, to, transferAmount);
343         } else {
344             //No tax transfer
345             _balance[from] -= amount;
346             _balance[to] += amount;
347 
348             emit Transfer(from, to, amount);
349         }
350     }
351 
352     receive() external payable {}
353 }