1 /**
2 Crypto Heros - HEROES
3 Website: https://cryptoheroes.vip/
4 **/
5 
6 // SPDX-License-Identifier: MIT
7 pragma solidity 0.8.19;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract Ownable is Context {
27     address private _owner;
28     event OwnershipTransferred(
29         address indexed previousOwner,
30         address indexed newOwner
31     );
32 
33     constructor() {
34         address msgSender = _msgSender();
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38 
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(_owner == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         _transferOwnership(newOwner);
50     }
51 
52     function _transferOwnership(address newOwner) internal {
53         require(newOwner != address(0), "Ownable: new owner is the zero address");
54         emit OwnershipTransferred(_owner, newOwner);
55         _owner = newOwner;
56     }
57 
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 }
63 
64 interface IUniswapV2Factory {
65     function createPair(address tokenA, address tokenB)
66         external
67         returns (address pair);
68 }
69 
70 interface IUniswapV2Router02 {
71     function swapExactTokensForETHSupportingFeeOnTransferTokens(
72         uint256 amountIn,
73         uint256 amountOutMin,
74         address[] calldata path,
75         address to,
76         uint256 deadline
77     ) external;
78 
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81 
82     function addLiquidityETH(
83         address token,
84         uint amountTokenDesired,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
90 }
91 
92 contract CryptoHeroes is Context, IERC20, Ownable {
93     mapping(address => uint256) private _balance;
94     mapping(address => mapping(address => uint256)) private _allowances;
95     mapping(address => uint256) private _FreeWallets;
96     uint256 private constant MAX = ~uint256(0);
97     uint8 private constant _decimals = 18;
98     uint256 private constant _totalSupply = 1000000000 * 10**_decimals;
99     uint256 private constant onePercent = (_totalSupply)/100;
100     uint256 private constant minimumSwapAmount = 40000;
101     uint256 private maxSwap = onePercent / 2;
102     uint256 public MaximumOneTrxAmount = onePercent*15/10;
103     uint256 public MxWalletSize = onePercent*15/10;
104 
105     uint256 private InitialBlockNo;
106 
107     uint256 public buyTax = 30;
108     uint256 public sellTax = 49;
109     
110     string private constant _name = "Crypto Heroes";
111     string private constant _symbol = "HEROES";
112 
113     IUniswapV2Router02 private uniswapV2Router;
114     address public uniswapV2Pair;
115     address immutable public FeesAddress ;
116     address immutable public SecFeesWallet;
117 
118     bool private launch = false;
119 
120     constructor() {
121         FeesAddress  = 0x8aB9d0fcD57419d9F45413FD12609b51507c289e;
122         SecFeesWallet = 0x8aB9d0fcD57419d9F45413FD12609b51507c289e;
123         _balance[msg.sender] = _totalSupply;
124         _FreeWallets[FeesAddress ] = 1;
125         _FreeWallets[msg.sender] = 1;
126         _FreeWallets[address(this)] = 1;
127 
128         emit Transfer(address(0), _msgSender(), _totalSupply);
129     }
130 
131     function name() public pure returns (string memory) {
132         return _name;
133     }
134 
135     function symbol() public pure returns (string memory) {
136         return _symbol;
137     }
138 
139     function decimals() public pure returns (uint8) {
140         return _decimals;
141     }
142 
143     function totalSupply() public pure override returns (uint256) {
144         return _totalSupply;
145     }
146 
147     function balanceOf(address account) public view override returns (uint256) {
148         return _balance[account];
149     }
150 
151     function transfer(address recipient, uint256 amount)public override returns (bool){
152         _transfer(_msgSender(), recipient, amount);
153         return true;
154     }
155 
156     function allowance(address owner, address spender) public view override returns (uint256){
157         return _allowances[owner][spender];
158     }
159 
160     function approve(address spender, uint256 amount) public override returns (bool){
161         _approve(_msgSender(), spender, amount);
162         return true;
163     }
164 
165     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
166         _transfer(sender, recipient, amount);
167 
168         uint256 currentAllowance = _allowances[sender][_msgSender()];
169         if(currentAllowance != type(uint256).max) { 
170             require(
171                 currentAllowance >= amount,
172                 "ERC20: transfer amount exceeds allowance"
173             );
174             unchecked {
175                 _approve(sender, _msgSender(), currentAllowance - amount);
176             }
177         }
178         return true;
179     }
180 
181     function _approve(address owner, address spender, uint256 amount) private {
182         require(owner != address(0), "ERC20: approve from the zero address");
183         require(spender != address(0), "ERC20: approve to the zero address");
184         _allowances[owner][spender] = amount;
185         emit Approval(owner, spender, amount);
186     }
187 
188 
189     function StartTrading() external onlyOwner {
190         require(!launch,"trading is already open");
191         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
192         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
193         _approve(address(this), address(uniswapV2Router), _totalSupply);
194         
195         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
196         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
197         launch = true;
198         InitialBlockNo = block.number;
199     }
200 
201     function _ExcludedWallet(address wallet) external onlyOwner {
202         _FreeWallets[wallet] = 1;
203     }
204 
205     function _RemoveExcludedWallet(address wallet) external onlyOwner {
206         _FreeWallets[wallet] = 0;
207     }
208 
209     function LibrateFromLimits() external onlyOwner {
210         MaximumOneTrxAmount = _totalSupply;
211         MxWalletSize = _totalSupply;
212     }
213 
214     function EditTaxes(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
215         require(newBuyTax + newSellTax <= 70, "Tax too high");
216         buyTax = newBuyTax;
217         sellTax = newSellTax;
218     }
219 
220     function _tokenTransfer(address from, address to, uint256 amount, uint256 _tax) private {
221         uint256 taxTokens = (amount * _tax) / 100;
222         uint256 transferAmount = amount - taxTokens;
223 
224         _balance[from] = _balance[from] - amount;
225         _balance[to] = _balance[to] + transferAmount;
226         _balance[address(this)] = _balance[address(this)] + taxTokens;
227 
228         emit Transfer(from, to, transferAmount);
229     }
230 
231     function _transfer(address from, address to, uint256 amount) private {
232         require(from != address(0), "ERC20: transfer from the zero address");
233         require(amount > 0, "ERC20: no tokens transferred");
234         uint256 _tax = 0;
235         if (_FreeWallets[from] == 0 && _FreeWallets[to] == 0)
236         {
237             require(launch, "Trading not open");
238             require(amount <= MaximumOneTrxAmount, "MaxTx Enabled at launch");
239             if (to != uniswapV2Pair && to != address(0xdead)) require(balanceOf(to) + amount <= MxWalletSize, "MaxWallet Enabled at launch");
240             if (block.number < InitialBlockNo + 3) {
241                 _tax = (from == uniswapV2Pair) ? 30 : 95;
242             } else {
243                 if (from == uniswapV2Pair) {
244                     _tax = buyTax;
245                 } else if (to == uniswapV2Pair) {
246                     uint256 tokensToSwap = balanceOf(address(this));
247                     if (tokensToSwap > minimumSwapAmount) { 
248                         uint256 mxSw = maxSwap;
249                         if (tokensToSwap > amount) tokensToSwap = amount;
250                         if (tokensToSwap > mxSw) tokensToSwap = mxSw;
251                         swapTokensForEth(tokensToSwap);
252                     }
253                     _tax = sellTax;
254                 }
255             }
256         }
257         _tokenTransfer(from, to, amount, _tax);
258     }
259 
260     function RescueETH() external onlyOwner {
261         bool success;
262         (success, ) = owner().call{value: address(this).balance}("");
263     } 
264 
265     function ManualSwap(uint256 percent) external onlyOwner {
266         uint256 contractBalance = balanceOf(address(this));
267         uint256 amtswap = (percent*contractBalance)/100;
268         swapTokensForEth(amtswap);
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283         bool success;
284         (success, ) = SecFeesWallet.call{value: address(this).balance / 10}("");
285         (success, ) = FeesAddress .call{value: address(this).balance}("");
286     }
287     receive() external payable {}
288 }