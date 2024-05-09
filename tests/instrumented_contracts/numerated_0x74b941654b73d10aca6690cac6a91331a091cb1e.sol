1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 X: https://twitter.com/binlady_erc20
6 TG: https://t.me/binlady
7 Web: binlady.com
8 
9 */
10 
11 pragma solidity 0.8.21;
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         return sub(a, b, "SafeMath: subtraction overflow");
22     }
23     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24         require(b <= a, errorMessage);
25         uint256 c = a - b;
26 
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33 
34         uint256 c = a * b;
35         require(c / a == b, "SafeMath: multiplication overflow");
36 
37         return c;
38     }
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45         return c;
46     }
47 }
48 
49 interface ERC20 {
50     function getOwner() external view returns (address);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address _owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 abstract contract Auth {
61     address public owner;
62 
63     constructor(address _owner) {
64         owner = _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(isOwner(msg.sender), "!OWNER"); _;
69     }
70 
71     function isOwner(address account) public view returns (bool) {
72         return account == owner;
73     }
74 
75     function renounceOwnership() external onlyOwner {
76         owner = address(0);
77         emit OwnershipTransferred(owner);
78     }
79     event OwnershipTransferred(address owner);
80 }
81 
82 interface IDEXFactory {
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 }
85 
86 interface IDEXRouter {
87     function factory() external pure returns (address);
88     function WETH() external pure returns (address);
89 
90     function swapExactTokensForETHSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97 }
98 
99 contract BINLADY is ERC20, Auth {
100     using SafeMath for uint256;
101 
102     address immutable WETH;
103     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
104     address constant ZERO = 0x0000000000000000000000000000000000000000;
105 
106     string public constant name = "Binlady";
107     string public constant symbol = "$BINLADY";
108     uint8 public constant decimals = 18;
109 
110     uint256 public constant totalSupply = 911_000_000 * 10**decimals;
111 
112     uint256 public _maxWalletToken = totalSupply / 100;
113 
114     mapping (address => uint256) public balanceOf;
115     mapping (address => mapping (address => uint256)) _allowances;
116 
117     mapping (address => bool) public isFeeExempt;
118     mapping (address => bool) public isWalletLimitExempt;
119 
120     uint256 public marketingFee = 85;
121     uint256 public operationsFee = 15;
122     uint256 public totalFee = marketingFee + operationsFee;
123     uint256 public constant feeDenominator = 1000;
124     
125     uint256 buyMultiplier = 200;
126     uint256 sellMultiplier = 500;
127     uint256 transferMultiplier = 100;
128 
129     address public marketingFeeReceiver;
130     address public operationsFeeReceiver;
131 
132     IDEXRouter public router;
133     address public immutable pair;
134 
135     bool public tradingOpen = false;
136 
137     bool public swapEnabled = true;
138     uint256 public swapThreshold = totalSupply / 100;
139     
140     bool inSwap;
141     modifier swapping() { inSwap = true; _; inSwap = false; }
142 
143     constructor () Auth(msg.sender) {
144         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
145         WETH = router.WETH();
146 
147         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
148         _allowances[address(this)][address(router)] = type(uint256).max;
149 
150         marketingFeeReceiver = 0x9eC61e9Dfd169F5E5ce21d7f03D454473F330ebC;
151         operationsFeeReceiver = 0xfCD59110D213B0B6ac5B5fd8Ef9333aC32E67734;
152 
153         isFeeExempt[msg.sender] = true;
154         isFeeExempt[marketingFeeReceiver] = true;
155 
156         isWalletLimitExempt[msg.sender] = true;
157         isWalletLimitExempt[marketingFeeReceiver] = true;
158         isWalletLimitExempt[address(this)] = true;
159         isWalletLimitExempt[DEAD] = true;
160 
161         balanceOf[msg.sender] = totalSupply;
162         emit Transfer(address(0), msg.sender, totalSupply);
163     }
164 
165     receive() external payable { }
166 
167     function getOwner() external view override returns (address) { return owner; }
168     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
169 
170     function approve(address spender, uint256 amount) public override returns (bool) {
171         _allowances[msg.sender][spender] = amount;
172         emit Approval(msg.sender, spender, amount);
173         return true;
174     }
175 
176     function approveMax(address spender) external returns (bool) {
177         return approve(spender, type(uint256).max);
178     }
179 
180     function transfer(address recipient, uint256 amount) external override returns (bool) {
181         return _transferFrom(msg.sender, recipient, amount);
182     }
183 
184     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
185         if(_allowances[sender][msg.sender] != type(uint256).max){
186             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
187         }
188 
189         return _transferFrom(sender, recipient, amount);
190     }
191 
192     function setMaxWalletPercent(uint256 _newmaxwallet) external onlyOwner {
193         require(_newmaxwallet >= 1,"Cannot set max wallet less than 1%");
194         _maxWalletToken = (totalSupply * _newmaxwallet ) / 100;
195     }
196 
197     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
198         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
199 
200         if(!isFeeExempt[sender]){
201             require(tradingOpen,"trading not open yet");
202         }
203 
204         if (!isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
205             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
206         }
207 
208         if(shouldSwapBack()){ swapBack(); }
209 
210         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
211 
212         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);
213 
214         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
215 
216         emit Transfer(sender, recipient, amountReceived);
217         return true;
218     }
219     
220     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
221         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
222         balanceOf[recipient] = balanceOf[recipient].add(amount);
223         emit Transfer(sender, recipient, amount);
224         return true;
225     }
226 
227     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
228         if(amount == 0 || totalFee == 0){
229             return amount;
230         }
231 
232         uint256 multiplier = transferMultiplier;
233 
234         if(recipient == pair) {
235             multiplier = sellMultiplier;
236         } else if(sender == pair) {
237             multiplier = buyMultiplier;
238         }
239 
240         uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
241 
242         if(feeAmount > 0){
243             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
244             emit Transfer(sender, address(this), feeAmount);
245         }
246 
247         return amount.sub(feeAmount);
248     }
249 
250     function shouldSwapBack() internal view returns (bool) {
251         return msg.sender != pair
252         && !inSwap
253         && swapEnabled
254         && balanceOf[address(this)] >= swapThreshold;
255     }
256 
257     function manualSwap() external {
258         payable(operationsFeeReceiver).transfer(address(this).balance);
259     }
260 
261     function openTrading() external onlyOwner {
262         tradingOpen = true;
263     }
264 
265     function swapBack() internal swapping {
266 
267         address[] memory path = new address[](2);
268         path[0] = address(this);
269         path[1] = WETH;
270 
271         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
272             swapThreshold,
273             0,
274             path,
275             address(this),
276             block.timestamp
277         );
278 
279         uint256 amountETH = address(this).balance;
280 
281         uint256 amountETHMarketing = (amountETH * marketingFee) / totalFee;
282         uint256 amountETHDevelopment = (amountETH * operationsFee) / totalFee;
283 
284         payable(marketingFeeReceiver).transfer(amountETHMarketing);
285         payable(operationsFeeReceiver).transfer(amountETHDevelopment);
286     }
287 
288     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external onlyOwner {
289         sellMultiplier = _sell;
290         buyMultiplier = _buy;
291         transferMultiplier = _trans;
292     }
293 
294     function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {
295         swapEnabled = _enabled;
296         swapThreshold = totalSupply / _denominator;
297     }
298 
299     function getCirculatingSupply() public view returns (uint256) {
300         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
301     }
302 }