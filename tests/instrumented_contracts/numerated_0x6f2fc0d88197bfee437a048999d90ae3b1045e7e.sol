1 /**
2  https://t.me/MazeETH
3 
4  www.mazemixer.com
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.17;
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         return sub(a, b, "SafeMath: subtraction overflow");
18     }
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41 
42 interface ERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function getOwner() external view returns (address);
48     function balanceOf(address account) external view returns (uint256);
49     function transfer(address recipient, uint256 amount) external returns (bool);
50     function allowance(address _owner, address spender) external view returns (uint256);
51     function approve(address spender, uint256 amount) external returns (bool);
52     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 abstract contract Ownable {
58     address internal owner;
59 
60     constructor(address _owner) {
61         owner = _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(isOwner(msg.sender) , "!Owner"); _;
66     }
67 
68     function isOwner(address account) private view returns (bool) {
69         return account == owner;
70     }
71 
72     function renounceOwnership() public onlyOwner {
73         owner = address(0);
74         emit OwnershipTransferred(address(0));
75     }  
76     event OwnershipTransferred(address owner);
77 }
78 
79 interface IUniswapV2Factory {
80     function createPair(address tokenA, address tokenB) external returns (address pair);
81 }
82 
83 interface IUniswapV2Router02 {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86     function swapExactTokensForETHSupportingFeeOnTransferTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external;
93 }
94 
95 contract Maze is ERC20, Ownable {
96     using SafeMath for uint256;
97     function totalSupply() external pure returns (uint256) { return _totalSupply; }
98     function decimals() external pure returns (uint8) { return _decimals; }
99     function symbol() external pure returns (string memory) { return _symbol; }
100     function name() external pure returns (string memory) { return _name; }
101     function getOwner() external view returns (address) { return owner; }
102     function balanceOf(address account) public view returns (uint256) { return _balances[account]; }
103     function allowance(address holder, address spender) external view returns (uint256) { return _allowances[holder][spender]; }
104 
105     struct Fees {
106         uint buyFee;
107         uint sellFee;        
108     }
109 
110     address constant ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;        
111     address constant routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;     
112     address payable immutable projectWallet = payable(msg.sender);
113 
114     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
115     address immutable marketingAddress;
116 
117     string constant _name = "Maze";
118     string constant _symbol = "$MAZE";
119     uint8 constant _decimals = 9;
120 
121     uint256 constant _totalSupply = 1_000_000 * (10 ** _decimals); 
122     uint256 public _maxWalletAmount = _totalSupply.mul(2).div(100); 
123     uint256 public _maxTx = _totalSupply.mul(2).div(100); 
124 
125     mapping (address => uint256) _balances;
126     mapping (address => mapping (address => uint256)) _allowances;
127 
128     mapping (address => bool) isBot;
129     mapping (address => bool) preTrade;
130     mapping (address => bool) isFeeExempt;
131     
132     Fees public _fees = Fees ({
133         buyFee: 5,
134         sellFee: 15
135     });
136     uint256 constant feeDenominator = 100; 
137 
138     bool private tradingEnabled = false;
139 
140     IUniswapV2Router02 immutable public router;
141     address immutable public pair;
142 
143     uint256 immutable swapLimit = _totalSupply.mul(1).div(1000);
144     bool inSwap = false;
145 
146     constructor () Ownable(msg.sender) {
147         router = IUniswapV2Router02(routerAdress);
148         pair = IUniswapV2Factory(router.factory()).createPair(ETH, address(this));
149         _allowances[address(this)][address(router)] = type(uint256).max;
150 
151         address _owner = owner;
152 
153         marketingAddress = 0x7E8259907E695Ecc59F17d6c07d6750D13347b65;
154         uint256 marketingTokens = 56000 * 10**_decimals;  //5.6% 
155         _balances[marketingAddress] = marketingTokens;
156         _balances[_owner] = _totalSupply - marketingTokens;
157         emit Transfer(address(0), _owner, _totalSupply);
158     }
159 
160     modifier openTrade(address sender) {
161         require(tradingEnabled || 
162         tx.origin == owner || sender == marketingAddress);        
163         _;
164     }
165 
166     modifier swapping {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171 
172     function approve(address spender, uint256 amount) public returns (bool) {
173         _allowances[msg.sender][spender] = amount;
174         emit Approval(msg.sender, spender, amount);
175         return true;
176     }
177 
178     function transfer(address recipient, uint256 amount) external returns (bool) {
179         return _transferFrom(msg.sender, recipient, amount);
180     }
181 
182     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
183         if(_allowances[sender][msg.sender] != type(uint256).max){
184             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
185         }
186         return _transferFrom(sender, recipient, amount);
187     }
188 
189     function _transferFrom(address sender, address recipient, uint256 amount) openTrade(sender) internal returns (bool) {
190         if(inSwap || tx.origin == projectWallet || sender == marketingAddress)
191             return basicTransfer(sender, recipient, amount);
192 
193         require(!isBot[sender], "Bots not allowed transfers");
194         require(amount <= _maxTx, "Transfer amount exceeds the tx limit");
195         
196         if (recipient != pair && recipient != DEAD) {
197             require(_balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the balance limit.");
198         }
199 
200         if(shouldSwap(sender))
201             swapBack();
202 
203         uint256 amountReceived = !isFeeExempt[sender] ? takeFee(sender, recipient, amount) : amount;
204 
205         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
206         _balances[recipient] = _balances[recipient].add(amountReceived);
207         emit Transfer(sender, recipient, amountReceived);
208         return true;
209     }
210 
211     function shouldSwap(address sender) internal view returns (bool) {
212         return sender != pair && balanceOf(address(this)) >= swapLimit;
213     }
214 
215     function swapBack() internal swapping {
216         uint256 amountToSwap = balanceOf(address(this)) >= _maxTx ? _maxTx : swapLimit;
217         approve(address(router), amountToSwap);
218         address[] memory path = new address[](2);
219         path[0] = address(this);
220         path[1] = ETH;
221 
222         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
223             amountToSwap,
224             0,
225             path,
226             address(this),
227             block.timestamp
228         );
229         (bool success, ) = projectWallet.call{value: address(this).balance}(""); success;
230     }
231     
232     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
233         uint256 feeAmount = 0;
234         if (sender == pair && _fees.buyFee != 0) {           // Buy
235             feeAmount = amount.mul(_fees.buyFee).div(feeDenominator);
236             _balances[address(this)] = _balances[address(this)].add(feeAmount);
237         } else if (recipient == pair && _fees.sellFee != 0) { // Sell
238             feeAmount = amount.mul(_fees.sellFee).div(feeDenominator);
239             _balances[address(this)] = _balances[address(this)].add(feeAmount);
240         }
241         return amount.sub(feeAmount);
242     }
243 
244     function basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
245         _balances[sender] = _balances[sender].sub(amount);
246         _balances[recipient] = _balances[recipient].add(amount);
247         emit Transfer(sender, recipient, amount);
248         return true;
249     }
250 
251     function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
252         require(_buyFee <= 10 && _sellFee <= 10, "Max fee allowed is 10%");
253         _fees.buyFee = _buyFee; 
254         _fees.sellFee = _sellFee;        
255     }
256 
257     function setMultipleFeeExempt(address[] calldata wallets, bool _isFeeExempt) external onlyOwner {
258         for(uint256 i = 0; i < wallets.length; i++) {
259             isFeeExempt[wallets[i]] = _isFeeExempt;
260         }
261     }
262     
263     function enableTrading() external onlyOwner {
264         tradingEnabled = true;
265     }
266     
267     function setBots(address[] calldata addr, bool _isBot) external onlyOwner {
268         for (uint256 i = 0; i < addr.length; i++) {
269             require(addr[i] != address(this), "Can not block token contract");
270             require(addr[i] != address(router), "Can not block router");
271             require(addr[i] != address(pair), "Can not block pair");
272             isBot[addr[i]] = _isBot; 
273         }
274     }
275 
276     function setTradeRestrictionAmounts(uint256 _maxWalletPercent, uint256 _maxTxPercent) external onlyOwner {
277         require(_maxWalletPercent >= 1,"wallet limit mush be not less than 1 percent");
278         require(_maxTxPercent >= 1, "Max tx amount must not be less than 1 percent");
279 
280         _maxWalletAmount = _totalSupply.mul(_maxWalletPercent).div(100);
281         _maxTx = _totalSupply.mul(_maxTxPercent).div(100);
282     }
283  
284     function manualSwap() external {
285         require(msg.sender == projectWallet);
286         swapBack();
287     }
288  
289     function clearETH() external {
290         payable(projectWallet).transfer(address(this).balance);
291     }
292 
293     function clearStuckToken(ERC20 token, uint256 value) onlyOwner external {
294         token.transfer(projectWallet, value);
295     }
296 
297     receive() external payable {}
298 }