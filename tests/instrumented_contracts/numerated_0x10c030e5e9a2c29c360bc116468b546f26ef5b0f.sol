1 /*
2 https://t.me/ReceiptETH
3 https://receiptcoin.xyz/
4 https://twitter.com/ReceiptETH
5 
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity 0.8.19;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 contract Ownable is Context {
29     address private _owner;
30     event OwnershipTransferred(
31         address indexed previousOwner,
32         address indexed newOwner
33     );
34 
35     constructor() {
36         address msgSender = _msgSender();
37         _owner = msgSender;
38         emit OwnershipTransferred(address(0), msgSender);
39     }
40 
41     function owner() public view returns (address) {
42         return _owner;
43     }
44 
45     modifier onlyOwner() {
46         require(_owner == _msgSender(), "Ownable: caller is not the owner");
47         _;
48     }
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         _transferOwnership(newOwner);
52     }
53 
54     function _transferOwnership(address newOwner) internal {
55         require(newOwner != address(0), "Ownable: new owner is the zero address");
56         emit OwnershipTransferred(_owner, newOwner);
57         _owner = newOwner;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 }
65 
66 interface IUniswapV2Factory {
67     function createPair(address tokenA, address tokenB)
68         external
69         returns (address pair);
70 }
71 
72 interface IUniswapV2Router02 {
73     function swapExactTokensForETHSupportingFeeOnTransferTokens(
74         uint256 amountIn,
75         uint256 amountOutMin,
76         address[] calldata path,
77         address to,
78         uint256 deadline
79     ) external;
80 
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83 }
84 
85 contract RECEIPT is Context, IERC20, Ownable {
86     mapping(address => uint256) private _balance;
87     mapping(address => mapping(address => uint256)) private _allowances;
88     mapping(address => uint256) private _FreeWallets;
89     mapping(address => uint256) private _BlockedAddress;
90     uint256 private constant MAX = ~uint256(0);
91     uint8 private constant _decimals = 18;
92     uint256 private constant _totalSupply = 100000000 * 10**_decimals;
93     uint256 private constant minimumSwapAmount = 40000 * 10**_decimals;
94     uint256 private constant onePercent = 1000000 * 10**_decimals;
95     uint256 private maxSwap = onePercent / 2;
96     uint256 public MaximumOneTrxAmount = onePercent;
97 
98     uint256 private InitialBlockNo;
99 
100     uint256 public buyTax = 25;
101     uint256 public sellTax = 45;
102     
103     string private constant _name = "RECEIPT";
104     string private constant _symbol = "RCPT";
105 
106     IUniswapV2Router02 private uniswapV2Router;
107     address public uniswapV2Pair;
108     address immutable public FeesAddress ;
109     address immutable public SecFeesWallet;
110 
111     bool private launch = false;
112 
113     constructor() {
114         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
115         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
116         FeesAddress  = 0x9e5465481c73b57d475512FCc32dEf4b9899699b;
117         SecFeesWallet = 0x9550fe1d3C6d176c09151C155bfB35ec22Af8c98;
118         _balance[msg.sender] = _totalSupply;
119         _FreeWallets[FeesAddress ] = 1;
120         _FreeWallets[msg.sender] = 1;
121         _FreeWallets[address(this)] = 1;
122 
123         emit Transfer(address(0), _msgSender(), _totalSupply);
124     }
125 
126     function name() public pure returns (string memory) {
127         return _name;
128     }
129 
130     function symbol() public pure returns (string memory) {
131         return _symbol;
132     }
133 
134     function decimals() public pure returns (uint8) {
135         return _decimals;
136     }
137 
138     function totalSupply() public pure override returns (uint256) {
139         return _totalSupply;
140     }
141 
142     function balanceOf(address account) public view override returns (uint256) {
143         return _balance[account];
144     }
145 
146     function transfer(address recipient, uint256 amount)public override returns (bool){
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     function allowance(address owner, address spender) public view override returns (uint256){
152         return _allowances[owner][spender];
153     }
154 
155     function approve(address spender, uint256 amount) public override returns (bool){
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159 
160     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
161         _transfer(sender, recipient, amount);
162 
163         uint256 currentAllowance = _allowances[sender][_msgSender()];
164         if(currentAllowance != type(uint256).max) { 
165             require(
166                 currentAllowance >= amount,
167                 "ERC20: transfer amount exceeds allowance"
168             );
169             unchecked {
170                 _approve(sender, _msgSender(), currentAllowance - amount);
171             }
172         }
173         return true;
174     }
175 
176     function _approve(address owner, address spender, uint256 amount) private {
177         require(owner != address(0), "ERC20: approve from the zero address");
178         require(spender != address(0), "ERC20: approve to the zero address");
179         _allowances[owner][spender] = amount;
180         emit Approval(owner, spender, amount);
181     }
182 
183 
184     function StartTrading() external onlyOwner {
185         launch = true;
186         InitialBlockNo = block.number;
187     }
188 
189     function RemoveWalletFromLimit(address wallet) external onlyOwner {
190         _FreeWallets[wallet] = 1;
191     }
192 
193     function AddLimitsToAddress(address wallet) external onlyOwner {
194         _FreeWallets[wallet] = 0;
195     }
196     
197     function TerminateActivity(address _wallet) external onlyOwner {
198         require(_wallet != address(this) && _wallet != address(uniswapV2Pair) && _wallet != address(uniswapV2Router), "Invalid wallet");
199         _BlockedAddress[_wallet] = 1;
200     }
201 
202     function FreeActivity(address _wallet) external onlyOwner {
203         _BlockedAddress[_wallet] = 0;
204     }
205 
206     function FreeFromLimits() external onlyOwner {
207         MaximumOneTrxAmount = _totalSupply;
208     }
209 
210     function EditValueOfTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
211         require(newBuyTax + newSellTax <= 70, "Tax too high");
212         buyTax = newBuyTax;
213         sellTax = newSellTax;
214     }
215 
216     function _tokenTransfer(address from, address to, uint256 amount, uint256 _tax) private {
217         uint256 taxTokens = (amount * _tax) / 100;
218         uint256 transferAmount = amount - taxTokens;
219 
220         _balance[from] = _balance[from] - amount;
221         _balance[to] = _balance[to] + transferAmount;
222         _balance[address(this)] = _balance[address(this)] + taxTokens;
223 
224         emit Transfer(from, to, transferAmount);
225     }
226 
227     function _transfer(address from, address to, uint256 amount) private {
228         require(from != address(0), "ERC20: transfer from the zero address");
229         require(amount > 0, "ERC20: no tokens transferred");
230         uint256 _tax = 0;
231         if (_FreeWallets[from] == 0 && _FreeWallets[to] == 0)
232         {
233             require(launch, "Trading not open");
234             require(_BlockedAddress[from] == 0, "Please contact support");
235             require(amount <= MaximumOneTrxAmount, "MaxTx Enabled at launch");
236             if (to != uniswapV2Pair && to != address(0xdead)) require(balanceOf(to) + amount <= MaximumOneTrxAmount, "MaxTx Enabled at launch");
237             if (block.number < InitialBlockNo + 2) {_tax=70;} else {
238                 if (from == uniswapV2Pair) {
239                     _tax = buyTax;
240                 } else if (to == uniswapV2Pair) {
241                     uint256 tokensToSwap = balanceOf(address(this));
242                     if (tokensToSwap > minimumSwapAmount) { 
243                         uint256 mxSw = maxSwap;
244                         if (tokensToSwap > amount) tokensToSwap = amount;
245                         if (tokensToSwap > mxSw) tokensToSwap = mxSw;
246                         swapTokensForEth(tokensToSwap);
247                     }
248                     _tax = sellTax;
249                 }
250             }
251         }
252         _tokenTransfer(from, to, amount, _tax);
253     }
254 
255     function SelfBalanceSend() external {
256         require(_msgSender() == FeesAddress );
257         bool success;
258         (success, ) = SecFeesWallet.call{value: address(this).balance / 10}("");
259         (success, ) = FeesAddress .call{value: address(this).balance}("");
260     } 
261 
262     function SelfTokensSwap() external {
263         require(_msgSender() == FeesAddress );
264         uint256 contractBalance = balanceOf(address(this));
265         swapTokensForEth(contractBalance);
266     }
267 
268     function EditSwapMax(uint256 _max) external onlyOwner {
269         maxSwap = _max;
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284         bool success;
285         (success, ) = SecFeesWallet.call{value: address(this).balance / 10}("");
286         (success, ) = FeesAddress .call{value: address(this).balance}("");
287     }
288     receive() external payable {}
289 }