1 // SPDX-License-Identifier: UNLICENSED
2 
3 /**
4  * http://sonicthefrog.vip
5  * https://t.me/sonicthefrog
6 **/
7 
8 pragma solidity 0.8.20;
9 
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14 
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         return sub(a, b, "SafeMath: subtraction overflow");
19     }
20     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30 
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33 
34         return c;
35     }
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         return div(a, b, "SafeMath: division by zero");
38     }
39     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b > 0, errorMessage);
41         uint256 c = a / b;
42         return c;
43     }
44 }
45 
46 interface ERC20 {
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
57 abstract contract Auth {
58     address internal owner;
59 
60     constructor(address _owner) {
61         owner = _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(isOwner(msg.sender), "!OWNER"); _;
66     }
67 
68     function isOwner(address account) public view returns (bool) {
69         return account == owner;
70     }
71 
72     function renounceOwnership() external onlyOwner {
73         owner = address(0);
74     }
75 
76 }
77 
78 interface IDEXFactory {
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 }
81 
82 interface IDEXRouter {
83     function factory() external pure returns (address);
84     function WETH() external pure returns (address);
85 
86     function swapExactTokensForETHSupportingFeeOnTransferTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external;
93 }
94 
95 contract ERC20SonicTheFrog  is ERC20, Auth {
96     using SafeMath for uint256;
97 
98     address immutable WETH;
99     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
100     address constant ZERO = 0x0000000000000000000000000000000000000000;
101 
102     string public constant name = "Sonic The Frog ";
103     string public constant symbol = "$SOFRO";
104     uint8 public constant decimals = 18;
105     
106     uint256 public constant totalSupply = 1991236 * 10**decimals;
107 
108     uint256 public _maxWalletToken = totalSupply / 100;
109 
110     mapping (address => uint256) public balanceOf;
111     mapping (address => mapping (address => uint256)) _allowances;
112 
113     mapping (address => bool) public _isFeeExempt;
114     mapping (address => bool) public _walletLmtExmpt;
115 
116     uint256 public totalFee = 10;
117     uint256 public constant feeDenominator = 100;
118     bool public tradingOpen = false;
119     
120     uint256 buyMultiplier = 300;
121     uint256 sellMultiplier = 700;
122     uint256 transferMultiplier = 999;
123 
124     address public marketingWallet;
125 
126     IDEXRouter public router;
127     address public pair;
128 
129     bool public swapEnabled = false;
130     uint256 swapThreshold = totalSupply / 100;
131     bool inSwap;
132     modifier swapping() { inSwap = true; _; inSwap = false; }
133 
134     constructor () Auth(msg.sender) {
135         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
136         _allowances[address(this)][address(router)] = type(uint256).max;
137         WETH = router.WETH();
138 
139         marketingWallet = 0xcb54e634A5E07C1487eBe237AD6200b4e668bB03;
140 
141         _isFeeExempt[msg.sender] = true;
142         _isFeeExempt[marketingWallet] = true;
143 
144         _walletLmtExmpt[msg.sender] = true;
145         _walletLmtExmpt[marketingWallet] = true;
146         _walletLmtExmpt[address(this)] = true;
147         _walletLmtExmpt[DEAD] = true;
148 
149         balanceOf[msg.sender] = totalSupply;
150         emit Transfer(address(0), msg.sender, totalSupply);
151     }
152 
153     function setPair(address _pair) external onlyOwner {
154         pair = _pair;
155     }
156 
157     function tradingLive() external onlyOwner{
158         tradingOpen = true;
159         swapEnabled = true;
160     }
161 
162     receive() external payable { }
163 
164     function getOwner() external view override returns (address) { return owner; }
165     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
166 
167     function approve(address spender, uint256 amount) public override returns (bool) {
168         _allowances[msg.sender][spender] = amount;
169         emit Approval(msg.sender, spender, amount);
170         return true;
171     }
172 
173     function approveMax(address spender) external returns (bool) {
174         return approve(spender, type(uint256).max);
175     }
176 
177     function transfer(address recipient, uint256 amount) external override returns (bool) {
178         return _transferFrom(msg.sender, recipient, amount);
179     }
180 
181     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
182         if(_allowances[sender][msg.sender] != type(uint256).max){
183             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
184         }
185 
186         return _transferFrom(sender, recipient, amount);
187     }
188 
189     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
190         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
191 
192         if(!_isFeeExempt[sender]){
193             require(tradingOpen, "Trading not open yet");
194         }
195 
196         if (!_walletLmtExmpt[sender] && !_walletLmtExmpt[recipient] && recipient != pair) {
197             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
198         }
199     
200         if(shouldSwapBack()){ swapBack(); }
201 
202         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
203 
204         uint256 amountReceived = (_isFeeExempt[sender] || _isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
205 
206         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
207 
208         emit Transfer(sender, recipient, amountReceived);
209         return true;
210     }
211     
212     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
213         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
214         balanceOf[recipient] = balanceOf[recipient].add(amount);
215         emit Transfer(sender, recipient, amount);
216         return true;
217     }
218 
219     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
220         if(amount == 0 || totalFee == 0){
221             return amount;
222         }
223 
224         uint256 multiplier = transferMultiplier;
225 
226         if(recipient == pair) {
227             multiplier = sellMultiplier;
228         } else if(sender == pair) {
229             multiplier = buyMultiplier;
230         }
231 
232         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
233 
234         if(feeAmount > 0){
235             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
236             emit Transfer(sender, address(this), feeAmount);
237         }
238 
239         return amount.sub(feeAmount);
240     }
241 
242     function shouldSwapBack() internal view returns (bool) {
243         return msg.sender != pair
244         && !inSwap
245         && swapEnabled
246         && balanceOf[address(this)] >= swapThreshold;
247     }
248 
249     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
250         uint256 amountETH = address(this).balance;
251         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
252         payable(msg.sender).transfer(amountToClear);
253     }
254 
255     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
256         if(tokens == 0){
257             tokens = ERC20(tokenAddress).balanceOf(address(this));
258         }
259         return ERC20(tokenAddress).transfer(msg.sender, tokens);
260     }
261 
262     function swapBack() internal swapping {
263 
264         address[] memory path = new address[](2);
265         path[0] = address(this);
266         path[1] = WETH;
267 
268         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             swapThreshold,
270             0,
271             path,
272             marketingWallet,
273             block.timestamp
274         );
275     }
276 
277     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
278         sellMultiplier = _sell;
279         buyMultiplier = _buy;
280         transferMultiplier = _trans;
281     }
282 
283     function setMaxWallet(uint256 maxWallPercent) external onlyOwner {
284         require(maxWallPercent >= 1,"Cannot set max wallet less than 1%");
285         _maxWalletToken = (totalSupply * maxWallPercent ) / 100;
286     }
287 
288     function manage_FeeExempt(address[] calldata addresses, bool status) external onlyOwner {
289         for (uint256 i=0; i < addresses.length; ++i) {
290             _isFeeExempt[addresses[i]] = status;
291         }
292     }
293 
294     function manage_WalletLimitExempt(address[] calldata addresses, bool status) external onlyOwner {
295         for (uint256 i=0; i < addresses.length; ++i) {
296             _walletLmtExmpt[addresses[i]] = status;
297         }
298     }
299 
300     function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {
301         require(_denominator > 0,"Cannot be zero");
302         swapEnabled = _enabled;
303         swapThreshold = totalSupply / _denominator;
304     }
305 
306     function getCirculatingSupply() public view returns (uint256) {
307         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
308     }
309 }