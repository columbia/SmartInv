1 // SPDX-License-Identifier: UNLICENSED
2 
3 /*
4 
5 https://t.me/soyjakcommunity
6 https://twitter.com/SoyjakCommunity
7 
8 www.soyjak.wtf
9 
10 */
11 
12 pragma solidity 0.8.16;
13 
14 library SafeMath {
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 }
31 
32 interface ERC20 {
33     function getOwner() external view returns (address);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address _owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 abstract contract Auth {
44     address internal owner;
45     mapping (address => bool) internal authorizations;
46 
47     constructor(address _owner) {
48         owner = _owner;
49         authorizations[_owner] = true;
50     }
51 
52     modifier onlyOwner() {
53         require(isOwner(msg.sender), "!OWNER"); _;
54     }
55 
56     modifier authorized() {
57         require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
58     }
59 
60     function authorize(address adr) public onlyOwner {
61         authorizations[adr] = true;
62     }
63 
64     function unauthorize(address adr) external onlyOwner {
65         require(adr != owner, "OWNER cant be unauthorized");
66         authorizations[adr] = false;
67     }
68 
69     function isOwner(address account) public view returns (bool) {
70         return account == owner;
71     }
72 
73     function isAuthorized(address adr) public view returns (bool) {
74         return authorizations[adr];
75     }
76 
77     function renounceOwnership() external onlyOwner {
78         authorizations[owner] = false;
79         owner = address(0);
80     }
81 }
82 
83 interface IDEXFactory {
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85 }
86 
87 interface IDEXRouter {
88     function factory() external pure returns (address);
89     function WETH() external pure returns (address);
90 
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98 }
99 
100 contract ERC20SOYJAKTOKEN is ERC20, Auth {
101     using SafeMath for uint256;
102 
103     address immutable WETH;
104     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
105     address constant ZERO = 0x0000000000000000000000000000000000000000;
106 
107     string public constant name = "Soyjak Coin";
108     string public constant symbol = "SOYJAK";
109     uint8 public constant decimals = 9;
110 
111     uint256 public constant totalSupply = 69420 * 10**6 * 10**decimals;
112 
113     uint256 public _maxTxAmount = totalSupply / 100;
114     uint256 public _maxWalletToken = totalSupply / 100;
115 
116     mapping (address => uint256) public balanceOf;
117     mapping (address => mapping (address => uint256)) _allowances;
118 
119     mapping (address => bool) public isFeeExempt;
120     mapping (address => bool) public isTxLimitExempt;
121     mapping (address => bool) public isWalletLimitExempt;
122 
123     uint256 public totalFee = 10;
124     uint256 public constant feeDenominator = 100;
125     
126     uint256 buyMultiplier = 900;
127     uint256 sellMultiplier = 990;
128     uint256 transferMultiplier = 900;
129 
130     address marketingFeeReceiver;
131 
132     IDEXRouter public router;
133     address public immutable pair;
134 
135     bool swapEnabled = true;
136     uint256 swapThreshold = totalSupply / 200;
137     bool inSwap;
138     modifier swapping() { inSwap = true; _; inSwap = false; }
139 
140     constructor () Auth(msg.sender) {
141         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
142         WETH = router.WETH();
143 
144         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
145         _allowances[address(this)][address(router)] = type(uint256).max;
146 
147         marketingFeeReceiver = 0x8c5e43fa6C3941F8A8B8913c7EDDD97D70bd7aA5;
148 
149         isFeeExempt[msg.sender] = true;
150 
151         isTxLimitExempt[msg.sender] = true;
152         isTxLimitExempt[DEAD] = true;
153         isTxLimitExempt[ZERO] = true;
154 
155         isWalletLimitExempt[msg.sender] = true;
156         isWalletLimitExempt[address(this)] = true;
157         isWalletLimitExempt[DEAD] = true;
158 
159         balanceOf[msg.sender] = totalSupply;
160         emit Transfer(address(0), msg.sender, totalSupply);
161     }
162 
163     receive() external payable { }
164 
165     function getOwner() external view override returns (address) { return owner; }
166     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
167     function getCirculatingSupply() public view returns (uint256) {
168         return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
169     }
170 
171     function approve(address spender, uint256 amount) public override returns (bool) {
172         _allowances[msg.sender][spender] = amount;
173         emit Approval(msg.sender, spender, amount);
174         return true;
175     }
176 
177     function approveMax(address spender) external returns (bool) {
178         return approve(spender, type(uint256).max);
179     }
180 
181     function transfer(address recipient, uint256 amount) external override returns (bool) {
182         return _transferFrom(msg.sender, recipient, amount);
183     }
184 
185     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
186         if(_allowances[sender][msg.sender] != type(uint256).max){
187             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
188         }
189 
190         return _transferFrom(sender, recipient, amount);
191     }
192 
193     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
194         if(inSwap){ return _basicTransfer(sender, recipient, amount); }
195 
196         if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
197             require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
198         }
199     
200         require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");
201 
202         if(shouldSwapBack()){ swapBack(); }
203 
204         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
205 
206         uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient] || totalFee == 0) ? amount : takeFee(sender, amount, recipient);
207 
208         balanceOf[recipient] = balanceOf[recipient].add(amountReceived);
209 
210         emit Transfer(sender, recipient, amountReceived);
211         return true;
212     }
213     
214     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
215         balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
216         balanceOf[recipient] = balanceOf[recipient].add(amount);
217         emit Transfer(sender, recipient, amount);
218         return true;
219     }
220 
221     function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
222         if(amount == 0 || totalFee == 0){
223             return amount;
224         }
225 
226         uint256 multiplier = transferMultiplier;
227 
228         if(recipient == pair) {
229             multiplier = sellMultiplier;
230         } else if(sender == pair) {
231             multiplier = buyMultiplier;
232         }
233 
234         uint256 feeAmount = (amount * totalFee * multiplier) / (feeDenominator * 100);
235 
236         if(feeAmount > 0){
237             balanceOf[address(this)] = balanceOf[address(this)].add(feeAmount);
238             emit Transfer(sender, address(this), feeAmount);
239         }
240 
241         return amount.sub(feeAmount);
242     }
243 
244     function shouldSwapBack() internal view returns (bool) {
245         return msg.sender != pair
246         && !inSwap
247         && swapEnabled
248         && balanceOf[address(this)] >= swapThreshold;
249     }
250 
251     function swapBack() internal swapping {
252 
253         address[] memory path = new address[](2);
254         path[0] = address(this);
255         path[1] = WETH;
256 
257         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
258             swapThreshold,
259             0,
260             path,
261             address(this),
262             block.timestamp
263         );
264 
265         uint256 amountETH = address(this).balance;
266         (bool tmpSuccess,) = payable(marketingFeeReceiver).call{value: amountETH}("");
267         tmpSuccess = false;
268     }
269 
270     function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
271         sellMultiplier = _sell;
272         buyMultiplier = _buy;
273         transferMultiplier = _trans;
274     }
275 
276     function setFees(uint256 _marketingFee) external onlyOwner {
277         totalFee = _marketingFee;
278     }
279 
280     function setSwapBackSettings(bool _enabled, uint256 _denominator) external onlyOwner {
281         swapEnabled = _enabled;
282         swapThreshold = totalSupply / _denominator;
283     }
284 
285     function setMaxWalletPercent(uint256 maxWallPercent) external onlyOwner {
286         _maxWalletToken = (totalSupply * maxWallPercent ) / 1000;
287     }
288 
289     function setMaxTxPercent(uint256 maxTXPercentage) external onlyOwner {
290         _maxTxAmount = (totalSupply * maxTXPercentage ) / 1000;
291     }
292 
293     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
294         uint256 amountETH = address(this).balance;
295         uint256 amountToClear = ( amountETH * amountPercentage ) / 100;
296         payable(msg.sender).transfer(amountToClear);
297     }
298 
299     function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
300         if(tokens == 0){
301             tokens = ERC20(tokenAddress).balanceOf(address(this));
302         }
303         return ERC20(tokenAddress).transfer(msg.sender, tokens);
304     }
305 }