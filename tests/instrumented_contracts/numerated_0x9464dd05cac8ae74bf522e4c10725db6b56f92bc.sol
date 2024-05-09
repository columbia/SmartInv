1 // SPDX-License-Identifier: Unlicensed
2 /**
3     Proof of Anon: A toolkit that enhances anonymity and reimagines the boundaries of degens' digital interactions in DeFi.
4 
5         The contract has a unique dynamic burn tax that changes based on volume. 
6         It starts at 3/3 and increases by 0.5% if volume is higher. 
7         The maximum tax is 5/5, with 3% for marketing and 2% for burn.
8         If volume is lower, tax decreases by 0.5% and can go as low as 3/3 after four consecutive hours.
9 
10     Socials:
11     https://twitter.com/proofofanon
12     https://t.me/proofofanon
13     https://0xproof.io/
14     https://medium.com/@theproofproject0
15 **/
16 pragma solidity ^0.8.18;
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26 
27     function balanceOf(address account) external view returns (uint256);
28 
29     function transfer(address recipient, uint256 amount)
30         external
31         returns (bool);
32 
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
37 
38     function approve(address spender, uint256 amount) external returns (bool);
39 
40     function transferFrom(
41         address sender,
42         address recipient,
43         uint256 amount
44     ) external returns (bool);
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52 }
53 
54 interface IUniswapV2Factory {
55     function createPair(address tokenA, address tokenB)
56         external
57         returns (address pair);
58 }
59 
60 interface IUniswapV2Router02 {
61     function swapExactTokensForETHSupportingFeeOnTransferTokens(
62         uint256 amountIn,
63         uint256 amountOutMin,
64         address[] calldata path,
65         address to,
66         uint256 deadline
67     ) external;
68 
69     function factory() external pure returns (address);
70 
71     function WETH() external pure returns (address);
72 }
73 
74 contract ProofOfAnon is Context, IERC20 {
75     IUniswapV2Router02 immutable uniswapV2Router;
76     address immutable uniswapV2Pair;
77     address immutable WETH;
78     address payable immutable marketingWallet;
79 
80     address public _owner = msg.sender;
81     uint8 private launch;
82     uint8 private inSwapAndLiquify;
83 
84     uint256 private _totalSupply        = 10_000_000e18;
85     uint256 public maxTxAmount = 200_000e18;
86     uint256 private constant onePercent =   100_000e18;
87     uint256 private constant minSwap    =     50_000e18;
88 
89     uint256 public buyTax;
90     uint256 public sellTax;
91     uint256 public burnRate = 100;
92 
93     uint256 private launchBlock;
94   
95     uint256 public _transactionVolumeCurrent;
96     uint256 public _transactionVolumePrevious;
97     uint256 public _lastBucketTime = block.timestamp;
98     uint256 private constant _bucketDuration = 60 minutes;
99 
100     mapping(address => uint256) private _balance;
101     mapping(address => mapping(address => uint256)) private _allowances;
102     mapping(address => bool) private _isExcludedFromFeeWallet;
103 
104     function onlyOwner() internal view {
105         require(_owner == msg.sender);
106     }
107 
108     constructor() {
109         uniswapV2Router = IUniswapV2Router02(
110             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
111         );
112         WETH = uniswapV2Router.WETH();
113         buyTax = 300;
114         sellTax = 300;
115 
116         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
117             address(this),
118             WETH
119         );
120 
121         marketingWallet = payable(0xc8a32b4D0602e8e624Fcf128B58F75e307898cf6);
122         _balance[msg.sender] = _totalSupply;
123 
124         _isExcludedFromFeeWallet[marketingWallet] = true;
125         _isExcludedFromFeeWallet[msg.sender] = true;
126         _isExcludedFromFeeWallet[address(this)] = true;
127         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
128             .max;
129         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
130         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
131             .max;
132 
133         emit Transfer(address(0), _msgSender(), _totalSupply);
134     }
135 
136     function name() public pure returns (string memory) {
137         return "Proof of Anon";
138     }
139 
140     function symbol() public pure returns (string memory) {
141         return "0xProof";
142     }
143 
144     function decimals() public pure returns (uint8) {
145         return 18;
146     }
147 
148     function totalSupply() public view override returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address account) public view override returns (uint256) {
153         return _balance[account];
154     }
155 
156     function transfer(address recipient, uint256 amount)
157         public
158         override
159         returns (bool)
160     {
161         _transfer(_msgSender(), recipient, amount);
162         return true;
163     }
164 
165     function allowance(address owner, address spender)
166         public
167         view
168         override
169         returns (uint256)
170     {
171         return _allowances[owner][spender];
172     }
173 
174     function approve(address spender, uint256 amount)
175         public
176         override
177         returns (bool)
178     {
179         _approve(_msgSender(), spender, amount);
180         return true;
181     }
182 
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) public override returns (bool) {
188         _transfer(sender, recipient, amount);
189         _approve(
190             sender,
191             _msgSender(),
192             _allowances[sender][_msgSender()] - amount
193         );
194         return true;
195     }
196 
197     function _approve(
198         address owner,
199         address spender,
200         uint256 amount
201     ) private {
202         require(owner != address(0), "ERC20: approve from the zero address");
203         require(spender != address(0), "ERC20: approve to the zero address");
204         _allowances[owner][spender] = amount;
205         emit Approval(owner, spender, amount);
206     }
207 
208     function openTrading() external  {
209         onlyOwner();
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