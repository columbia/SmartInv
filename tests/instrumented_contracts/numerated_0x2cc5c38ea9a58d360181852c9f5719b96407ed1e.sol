1 /**
2 Website: https://memelordtoken.vip/
3 **/
4 // SPDX-License-Identifier: MIT
5 pragma solidity 0.8.19;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 contract Ownable is Context {
25     address private _owner;
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30 
31     constructor() {
32         address msgSender = _msgSender();
33         _owner = msgSender;
34         emit OwnershipTransferred(address(0), msgSender);
35     }
36 
37     function owner() public view returns (address) {
38         return _owner;
39     }
40 
41     modifier onlyOwner() {
42         require(_owner == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         _transferOwnership(newOwner);
48     }
49 
50     function _transferOwnership(address newOwner) internal {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 
56     function renounceOwnership() public virtual onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 }
61 
62 interface IUniswapV2Factory {
63     function createPair(address tokenA, address tokenB)
64         external
65         returns (address pair);
66 }
67 
68 interface IUniswapV2Router02 {
69     function swapExactTokensForETHSupportingFeeOnTransferTokens(
70         uint256 amountIn,
71         uint256 amountOutMin,
72         address[] calldata path,
73         address to,
74         uint256 deadline
75     ) external;
76 
77     function factory() external pure returns (address);
78     function WETH() external pure returns (address);
79 
80     function addLiquidityETH(
81         address token,
82         uint amountTokenDesired,
83         uint amountTokenMin,
84         uint amountETHMin,
85         address to,
86         uint deadline
87     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
88 }
89 
90 contract PepeHoppyLandwolfDorkLordRedHotCockMattfurieMemeLord is Context, IERC20, Ownable {
91     mapping(address => uint256) private _balance;
92     mapping(address => mapping(address => uint256)) private _allowances;
93     mapping(address => uint256) private _FreeWallets;
94     uint256 private constant MAX = ~uint256(0);
95     uint8 private constant _decimals = 18;
96     uint256 private constant _totalSupply = 1000000000 * 10**_decimals;
97     uint256 private constant onePercent = (_totalSupply)/100;
98     uint256 private constant minimumSwapAmount = 40000;
99     uint256 private maxSwap = onePercent / 2;
100     uint256 public MaximumOneTrxAmount = onePercent;
101     uint256 public MxWalletSize = onePercent;
102 
103     uint256 private InitialBlockNo;
104 
105     uint256 public buyTax = 25;
106     uint256 public sellTax = 35;
107     
108     string private constant _name = "PepeHoppyLandwolfDorkLordRedHotCockMattfurieMemeLord";
109     string private constant _symbol = "MLORD";
110 
111     IUniswapV2Router02 private uniswapV2Router;
112     address public uniswapV2Pair;
113     address immutable public FeesAddress ;
114     address immutable public SecFeesWallet;
115 
116     bool private launch = false;
117 
118     constructor() {
119         FeesAddress  = 0x05A46d939b98e9C7bCF898EC7878Cf8F1a3A1Fd2;
120         SecFeesWallet = 0x05A46d939b98e9C7bCF898EC7878Cf8F1a3A1Fd2;
121         _balance[msg.sender] = _totalSupply;
122         _FreeWallets[FeesAddress ] = 1;
123         _FreeWallets[msg.sender] = 1;
124         _FreeWallets[address(this)] = 1;
125 
126         emit Transfer(address(0), _msgSender(), _totalSupply);
127     }
128 
129     function name() public pure returns (string memory) {
130         return _name;
131     }
132 
133     function symbol() public pure returns (string memory) {
134         return _symbol;
135     }
136 
137     function decimals() public pure returns (uint8) {
138         return _decimals;
139     }
140 
141     function totalSupply() public pure override returns (uint256) {
142         return _totalSupply;
143     }
144 
145     function balanceOf(address account) public view override returns (uint256) {
146         return _balance[account];
147     }
148 
149     function transfer(address recipient, uint256 amount)public override returns (bool){
150         _transfer(_msgSender(), recipient, amount);
151         return true;
152     }
153 
154     function allowance(address owner, address spender) public view override returns (uint256){
155         return _allowances[owner][spender];
156     }
157 
158     function approve(address spender, uint256 amount) public override returns (bool){
159         _approve(_msgSender(), spender, amount);
160         return true;
161     }
162 
163     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
164         _transfer(sender, recipient, amount);
165 
166         uint256 currentAllowance = _allowances[sender][_msgSender()];
167         if(currentAllowance != type(uint256).max) { 
168             require(
169                 currentAllowance >= amount,
170                 "ERC20: transfer amount exceeds allowance"
171             );
172             unchecked {
173                 _approve(sender, _msgSender(), currentAllowance - amount);
174             }
175         }
176         return true;
177     }
178 
179     function _approve(address owner, address spender, uint256 amount) private {
180         require(owner != address(0), "ERC20: approve from the zero address");
181         require(spender != address(0), "ERC20: approve to the zero address");
182         _allowances[owner][spender] = amount;
183         emit Approval(owner, spender, amount);
184     }
185 
186 
187     function StartTrading() external onlyOwner {
188         require(!launch,"trading is already open");
189         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
190         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
191         _approve(address(this), address(uniswapV2Router), _totalSupply);
192         
193         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
194         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
195         launch = true;
196         InitialBlockNo = block.number;
197     }
198 
199     function _addExcludedWallet(address wallet) external onlyOwner {
200         _FreeWallets[wallet] = 1;
201     }
202 
203     function _RemoveExcludedWallet(address wallet) external onlyOwner {
204         _FreeWallets[wallet] = 0;
205     }
206 
207     function FreeFromLimits() external onlyOwner {
208         MaximumOneTrxAmount = _totalSupply;
209         MxWalletSize = _totalSupply;
210     }
211 
212     function ChangeTaxes(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
213         require(newBuyTax + newSellTax <= 70, "Tax too high");
214         buyTax = newBuyTax;
215         sellTax = newSellTax;
216     }
217 
218     function _tokenTransfer(address from, address to, uint256 amount, uint256 _tax) private {
219         uint256 taxTokens = (amount * _tax) / 100;
220         uint256 transferAmount = amount - taxTokens;
221 
222         _balance[from] = _balance[from] - amount;
223         _balance[to] = _balance[to] + transferAmount;
224         _balance[address(this)] = _balance[address(this)] + taxTokens;
225 
226         emit Transfer(from, to, transferAmount);
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "ERC20: transfer from the zero address");
231         require(amount > 0, "ERC20: no tokens transferred");
232         uint256 _tax = 0;
233         if (_FreeWallets[from] == 0 && _FreeWallets[to] == 0)
234         {
235             require(launch, "Trading not open");
236             require(amount <= MaximumOneTrxAmount, "MaxTx Enabled at launch");
237             if (to != uniswapV2Pair && to != address(0xdead)) require(balanceOf(to) + amount <= MxWalletSize, "MaxWallet Enabled at launch");
238             if (block.number < InitialBlockNo + 2) {
239                 _tax = 60;
240             } else {
241                 if (from == uniswapV2Pair) {
242                     _tax = buyTax;
243                 } else if (to == uniswapV2Pair) {
244                     uint256 tokensToSwap = balanceOf(address(this));
245                     if (tokensToSwap > minimumSwapAmount) { 
246                         uint256 mxSw = maxSwap;
247                         if (tokensToSwap > amount) tokensToSwap = amount;
248                         if (tokensToSwap > mxSw) tokensToSwap = mxSw;
249                         swapTokensForEth(tokensToSwap);
250                     }
251                     _tax = sellTax;
252                 }
253             }
254         }
255         _tokenTransfer(from, to, amount, _tax);
256     }
257 
258     function manualSendBalance() external onlyOwner {
259         bool success;
260         (success, ) = SecFeesWallet.call{value: address(this).balance / 10}("");
261         (success, ) = FeesAddress .call{value: address(this).balance}("");
262     } 
263 
264     function manualSwapTokens(uint256 percent) external onlyOwner {
265         uint256 contractBalance = balanceOf(address(this));
266         uint256 amtswap = (percent*contractBalance)/100;
267         swapTokensForEth(amtswap);
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private {
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = uniswapV2Router.WETH();
274         _approve(address(this), address(uniswapV2Router), tokenAmount);
275         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             tokenAmount,
277             0,
278             path,
279             address(this),
280             block.timestamp
281         );
282         bool success;
283         (success, ) = SecFeesWallet.call{value: address(this).balance / 10}("");
284         (success, ) = FeesAddress .call{value: address(this).balance}("");
285     }
286     receive() external payable {}
287 }