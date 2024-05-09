1 /**
2 
3 http://t.me/AmplifiedAI
4 twitter.com/Amplified_Ai
5 amplifiedai.tech/
6 
7 $AMPAI Is an auto-learning, auto-upgrading, ultra-realistic, AI generator 
8 bot accessible through the website app and Telegram with a new ground breaking 
9 AI technology, AI Generated Character Training Model.
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.16;
16 
17 
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
23     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
24     
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
27 
28     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
30 
31     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
33         if(c / a != b) return(false, 0); return(true, c);}}
34 
35     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
37 
38     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b <= a, errorMessage); return a - b;}}
43 
44     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         unchecked{require(b > 0, errorMessage); return a / b;}}
46 
47     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         unchecked{require(b > 0, errorMessage); return a % b;}}}
49 
50 interface IERC20 {
51     function totalSupply() external view returns (uint256);
52     function decimals() external view returns (uint8);
53     function symbol() external view returns (string memory);
54     function name() external view returns (string memory);
55     function getOwner() external view returns (address);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address _owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);}
63 
64 abstract contract Ownable {
65     address internal owner;
66     constructor(address _owner) {owner = _owner;}
67     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
68     function isOwner(address account) public view returns (bool) {return account == owner;}
69     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
70     event OwnershipTransferred(address owner);
71 }
72 
73 interface IFactory{
74         function createPair(address tokenA, address tokenB) external returns (address pair);
75         function getPair(address tokenA, address tokenB) external view returns (address pair);
76 }
77 
78 interface IRouter {
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81     function addLiquidityETH(
82         address token,
83         uint amountTokenDesired,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
89 
90     function removeLiquidityWithPermit(
91         address tokenA,
92         address tokenB,
93         uint liquidity,
94         uint amountAMin,
95         uint amountBMin,
96         address to,
97         uint deadline,
98         bool approveMax, uint8 v, bytes32 r, bytes32 s
99     ) external returns (uint amountA, uint amountB);
100 
101     function swapExactETHForTokensSupportingFeeOnTransferTokens(
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external payable;
107 
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline) external;
114 }
115 
116 contract AmplifiedAI is IERC20, Ownable {
117     using SafeMath for uint256;
118     string private constant _name = 'Amplified AI';
119     string private constant _symbol = 'AMPAI';
120     uint8 private constant _decimals = 9;
121     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
122     uint256 private _maxTxAmountPercent = 100; // 10000;
123     uint256 private _maxTransferPercent = 100;
124     uint256 private _maxWalletPercent = 100;
125     mapping (address => uint256) _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) public isFeeExempt;
128     mapping (address => bool) private isBot;
129     IRouter router;
130     address public pair;
131     bool private tradingAllowed = false;
132     uint256 private liquidityFee = 0;
133     uint256 private marketingFee = 1000;
134     uint256 private developmentFee = 1000;
135     uint256 private burnFee = 0;
136     uint256 private totalFee = 2000;
137     uint256 private sellFee = 4000;
138     uint256 private transferFee = 4000;
139     uint256 private denominator = 10000;
140     bool private swapEnabled = true;
141     uint256 private swapTimes;
142     bool private swapping; 
143     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
144     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
145     modifier lockTheSwap {swapping = true; _; swapping = false;}
146 
147     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
148     address internal constant development_receiver = 0xFd0f77a172fAaFb42F9D2a1c04f113Edb7D88f04; 
149     address internal constant marketing_receiver = 0xA5798865706D53d645f020b0142e99E269c168aD;
150     address internal constant liquidity_receiver = 0xFd0f77a172fAaFb42F9D2a1c04f113Edb7D88f04;
151 
152     constructor() Ownable(msg.sender) {
153         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
154         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
155         router = _router;
156         pair = _pair;
157         isFeeExempt[address(this)] = true;
158         isFeeExempt[liquidity_receiver] = true;
159         isFeeExempt[marketing_receiver] = true;
160         isFeeExempt[msg.sender] = true;
161         _balances[msg.sender] = _totalSupply;
162         emit Transfer(address(0), msg.sender, _totalSupply);
163     }
164 
165     receive() external payable {}
166     function name() public pure returns (string memory) {return _name;}
167     function symbol() public pure returns (string memory) {return _symbol;}
168     function decimals() public pure returns (uint8) {return _decimals;}
169     function startTrading() external onlyOwner {tradingAllowed = true;}
170     function getOwner() external view override returns (address) { return owner; }
171     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
172     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
173     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
174     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
175     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
176     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
177     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
178     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
179     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
180     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
181     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
182 
183     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
184         require(sender != address(0), "ERC20: transfer from the zero address");
185         require(recipient != address(0), "ERC20: transfer to the zero address");
186         require(amount > uint256(0), "Transfer amount must be greater than zero");
187         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
188     }
189 
190     function _transfer(address sender, address recipient, uint256 amount) private {
191         preTxCheck(sender, recipient, amount);
192         checkTradingAllowed(sender, recipient);
193         checkMaxWallet(sender, recipient, amount); 
194         swapbackCounters(sender, recipient);
195         checkTxLimit(sender, recipient, amount); 
196         swapBack(sender, recipient, amount);
197         _balances[sender] = _balances[sender].sub(amount);
198         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
199         _balances[recipient] = _balances[recipient].add(amountReceived);
200         emit Transfer(sender, recipient, amountReceived);
201     }
202 
203     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
204         liquidityFee = _liquidity;
205         marketingFee = _marketing;
206         burnFee = _burn;
207         developmentFee = _development;
208         totalFee = _total;
209         sellFee = _sell;
210         transferFee = _trans;
211         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
212     }
213 
214     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
215         uint256 newTx = (totalSupply() * _buy) / 10000;
216         uint256 newTransfer = (totalSupply() * _trans) / 10000;
217         uint256 newWallet = (totalSupply() * _wallet) / 10000;
218         _maxTxAmountPercent = _buy;
219         _maxTransferPercent = _trans;
220         _maxWalletPercent = _wallet;
221         uint256 limit = totalSupply().mul(5).div(1000);
222         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
223     }
224 
225     function checkTradingAllowed(address sender, address recipient) internal view {
226         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
227     }
228     
229     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
230         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
231             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
232     }
233 
234     function swapbackCounters(address sender, address recipient) internal {
235         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
236     }
237 
238     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
239         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
240         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
241     }
242 
243     function swapAndLiquify(uint256 tokens) private lockTheSwap {
244         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
245         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
246         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
247         uint256 initialBalance = address(this).balance;
248         swapTokensForETH(toSwap);
249         uint256 deltaBalance = address(this).balance.sub(initialBalance);
250         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
251         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
252         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
253         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
254         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
255         uint256 remainingBalance = address(this).balance;
256         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
257     }
258 
259     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
260         _approve(address(this), address(router), tokenAmount);
261         router.addLiquidityETH{value: ETHAmount}(
262             address(this),
263             tokenAmount,
264             0,
265             0,
266             liquidity_receiver,
267             block.timestamp);
268     }
269 
270     function swapTokensForETH(uint256 tokenAmount) private {
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = router.WETH();
274         _approve(address(this), address(router), tokenAmount);
275         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             tokenAmount,
277             0,
278             path,
279             address(this),
280             block.timestamp);
281     }
282 
283     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
284         bool aboveMin = amount >= _minTokenAmount;
285         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
286         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(2) && aboveThreshold;
287     }
288 
289     function swapBack(address sender, address recipient, uint256 amount) internal {
290         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
291     }
292 
293     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
294         return !isFeeExempt[sender] && !isFeeExempt[recipient];
295     }
296 
297     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
298         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
299         if(recipient == pair){return sellFee;}
300         if(sender == pair){return totalFee;}
301         return transferFee;
302     }
303 
304     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
305         if(getTotalFee(sender, recipient) > 0){
306         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
307         _balances[address(this)] = _balances[address(this)].add(feeAmount);
308         emit Transfer(sender, address(this), feeAmount);
309         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
310         return amount.sub(feeAmount);} return amount;
311     }
312 
313     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
314         _transfer(sender, recipient, amount);
315         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
316         return true;
317     }
318 
319     function _approve(address owner, address spender, uint256 amount) private {
320         require(owner != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322         _allowances[owner][spender] = amount;
323         emit Approval(owner, spender, amount);
324     }
325 
326 }