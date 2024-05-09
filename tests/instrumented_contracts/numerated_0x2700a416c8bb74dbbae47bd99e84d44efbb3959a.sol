1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * Website : https://minidoge.world/
5  * Telegram : https://t.me/MiniDoge_ETH
6  * Twitter : https://twitter.com/minidogetoken
7  * WhitePaper : https://minidoge.world/MiniDoge.whitepaper.pdf
8 */
9 
10 pragma solidity ^0.8.0;
11 
12 interface IERC20 {
13     function decimals() external view returns (uint8);
14     function symbol() external view returns (string memory);
15     function name() external view returns (string memory);
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 interface IUniswapRouter {
27     function factory() external pure returns (address);
28 
29     function WETH() external pure returns (address);
30 
31     function swapExactTokensForETHSupportingFeeOnTransferTokens(
32         uint amountIn,
33         uint amountOutMin,
34         address[] calldata path,
35         address to,
36         uint deadline
37     ) external;
38 }
39 
40 interface IUniswapFactory {
41     function createPair(address tokenA, address tokenB) external returns (address pair);
42 }
43 
44 abstract contract Ownable {
45     address internal _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     constructor () {
50         address msgSender = msg.sender;
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     modifier onlyOwner() {
60         require(_owner == msg.sender, "you are not owner");
61         _;
62     }
63 
64     function renounceOwnership() public virtual onlyOwner {
65         emit OwnershipTransferred(_owner, address(0));
66         _owner = address(0);
67     }
68 
69     function transferOwnership(address newOwner) public virtual onlyOwner {
70         require(newOwner != address(0), "new is 0");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 contract ERC20 is IERC20, Ownable {
77     mapping(address => uint256) private _balances;
78     mapping(address => mapping(address => uint256)) private _allowances;
79 
80     address public fundAddress;
81 
82     string private _name;
83     string private _symbol;
84     uint8 private _decimals;
85 
86     mapping(address => bool) public _isExcludeFromFee;
87     
88     uint256 private _totalSupply;
89 
90     IUniswapRouter public _uniswapRouter;
91 
92     mapping(address => bool) public isMarketPair;
93     bool private inSwap;
94 
95     uint256 private constant MAX = ~uint256(0);
96 
97     uint256 public _buyFundFee = 0;
98     uint256 public _sellFundFee = 0;
99 
100     address public _uniswapPair;
101 
102     modifier lockTheSwap {
103         inSwap = true;
104         _;
105         inSwap = false;
106     }
107 
108     constructor (){
109         _name = "MiniDoge";
110         _symbol = "MiniDoge";
111         _decimals = 9;
112         uint256 Supply = 1000000000000000;
113 
114         IUniswapRouter swapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
115 
116         _uniswapRouter = swapRouter;
117         _allowances[address(this)][address(swapRouter)] = MAX;
118 
119         IUniswapFactory swapFactory = IUniswapFactory(swapRouter.factory());
120         address swapPair = swapFactory.createPair(address(this), swapRouter.WETH());
121         _uniswapPair = swapPair;
122         isMarketPair[swapPair] = true;
123 
124         _totalSupply = Supply * 10 ** _decimals;
125 
126         address receiveAddr = msg.sender;
127         _balances[receiveAddr] = _totalSupply;
128         emit Transfer(address(0), receiveAddr, _totalSupply);
129 
130         fundAddress = receiveAddr;
131 
132         _isExcludeFromFee[address(this)] = true;
133         _isExcludeFromFee[address(swapRouter)] = true;
134         // _isExcludeFromFee[msg.sender] = true;
135         _isExcludeFromFee[receiveAddr] = true;
136         _isExcludeFromFee[fundAddress] = true;
137     }
138 
139     function setFundAddr(address newAddr) public onlyOwner{
140         fundAddress = newAddr;
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
156         return _totalSupply;
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
177     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
178         _transfer(sender, recipient, amount);
179         if (_allowances[sender][msg.sender] != MAX) {
180             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
181         }
182         return true;
183     }
184 
185     function DesignBuy(uint256 newFundFee) public onlyOwner{
186         _buyFundFee = newFundFee;
187         require(_buyFundFee <= 25,"too high");
188     }
189 
190     function DesignSell(uint256 newFundFee) public onlyOwner{
191         _sellFundFee = newFundFee;
192         require(_sellFundFee <= 25,"too high");
193     }
194 
195     function _approve(address owner, address spender, uint256 amount) private {
196         _allowances[owner][spender] = amount;
197         emit Approval(owner, spender, amount);
198     }
199 
200     function _transfer(
201         address from,
202         address to,
203         uint256 amount
204     ) private {
205         uint256 balance = balanceOf(from);
206         require(balance >= amount, "balanceNotEnough");
207 
208         bool takeFee;
209         bool sellFlag;
210 
211         if (isMarketPair[to] && !inSwap && !_isExcludeFromFee[from] && !_isExcludeFromFee[to]) {
212             uint256 contractTokenBalance = balanceOf(address(this));
213             if (contractTokenBalance > 0) {
214                 uint256 numTokensSellToFund = amount;
215                 numTokensSellToFund = numTokensSellToFund > contractTokenBalance ? 
216                                                             contractTokenBalance:numTokensSellToFund;
217                 swapTokenForETH(numTokensSellToFund);
218             }
219         }
220 
221         if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) {
222             takeFee = true;
223         }
224 
225         if (isMarketPair[to]) { sellFlag = true; }
226 
227         _transferToken(from, to, amount, takeFee, sellFlag);
228     }
229 
230     function _transferToken(
231         address sender,
232         address recipient,
233         uint256 tAmount,
234         bool takeFee,
235         bool sellFlag
236     ) private {
237         _balances[sender] = _balances[sender] - tAmount;
238         uint256 feeAmount;
239 
240         if (takeFee) {
241             
242             uint256 taxFee;
243 
244             if (sellFlag) {
245                 taxFee = _sellFundFee;
246             } else {
247                 taxFee = _buyFundFee;
248             }
249             uint256 swapAmount = tAmount * taxFee / 100;
250             if (swapAmount > 0) {
251                 feeAmount += swapAmount;
252                 _balances[address(this)] = _balances[address(this)] + swapAmount;
253                 emit Transfer(sender, address(this), swapAmount);
254             }
255         }
256 
257         _balances[recipient] = _balances[recipient] + (tAmount - feeAmount);
258         emit Transfer(sender, recipient, tAmount - feeAmount);
259 
260     }
261 
262     event catchEvent(uint8);
263 
264     function swapTokenForETH(uint256 tokenAmount) private lockTheSwap {
265         address[] memory path = new address[](2);
266         path[0] = address(this);
267         path[1] = _uniswapRouter.WETH();
268         try _uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             tokenAmount,
270             0,
271             path,
272             address(fundAddress),
273             block.timestamp
274         ) {} catch { emit catchEvent(0); }
275 
276     }
277 
278     function setIsExcludeFromFees(address account, bool value) public onlyOwner{
279         _isExcludeFromFee[account] = value;
280     }
281 
282     receive() external payable {}
283 }