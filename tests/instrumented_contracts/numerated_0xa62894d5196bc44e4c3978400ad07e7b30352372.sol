1 /**
2 https://twitter.com/X_project_ERC
3 https://t.me/Xerc20
4 */
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.19;
9 
10 
11 library SafeMath {
12 
13     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
14         unchecked {
15             uint256 c = a + b;
16             if (c < a) return (false, 0);
17             return (true, c);
18         }
19     }
20 
21     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         unchecked {
23             if (b > a) return (false, 0);
24             return (true, a - b);
25         }
26     }
27 
28     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {
30             if (a == 0) return (true, 0);
31             uint256 c = a * b;
32             if (c / a != b) return (false, 0);
33             return (true, c);
34         }
35     }
36 
37     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b == 0) return (false, 0);
40             return (true, a / b);
41         }
42     }
43 
44     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         unchecked {
46             if (b == 0) return (false, 0);
47             return (true, a % b);
48         }
49     }
50 
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a + b;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a - b;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a * b;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a / b;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a % b;
69     }
70 
71     function sub(
72         uint256 a,
73         uint256 b,
74         string memory errorMessage
75     ) internal pure returns (uint256) {
76         unchecked {
77             require(b <= a, errorMessage);
78             return a - b;
79         }
80     }
81 
82     function div(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         unchecked {
88             require(b > 0, errorMessage);
89             return a / b;
90         }
91     }
92 
93     function mod(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         unchecked {
99             require(b > 0, errorMessage);
100             return a % b;
101         }
102     }
103 }
104 
105 interface IERC20 {
106     function decimals() external view returns (uint8);
107     function symbol() external view returns (string memory);
108     function name() external view returns (string memory);
109     function getOwner() external view returns (address);
110     function totalSupply() external view returns (uint256);
111     function balanceOf(address account) external view returns (uint256);
112     function transfer(address recipient, uint256 amount) external returns (bool);
113     function allowance(address _owner, address spender) external view returns (uint256);
114     function approve(address spender, uint256 amount) external returns (bool);
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(address indexed owner, address indexed spender, uint256 value);}
118 
119 abstract contract Ownable {
120     address internal owner;
121     constructor(address _owner) {owner = _owner;}
122     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
123     function isOwner(address account) public view returns (bool) {return account == owner;}
124     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
125     event OwnershipTransferred(address owner);
126 }
127 
128 interface IFactory{
129         function createPair(address tokenA, address tokenB) external returns (address pair);
130         function getPair(address tokenA, address tokenB) external view returns (address pair);
131 }
132 
133 interface IRouter {
134     function factory() external pure returns (address);
135     function WETH() external pure returns (address);
136     function addLiquidityETH(
137         address token,
138         uint amountTokenDesired,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
144 
145     function swapExactTokensForETHSupportingFeeOnTransferTokens(
146         uint amountIn,
147         uint amountOutMin,
148         address[] calldata path,
149         address to,
150         uint deadline) external;
151 }
152 
153 contract X is IERC20, Ownable {
154     using SafeMath for uint256;
155     string private constant _name = 'X';
156     string private constant _symbol = 'X';
157     uint8 private constant _decimals = 9;
158     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
159     mapping (address => uint256) _balances;
160     mapping (address => mapping (address => uint256)) private _allowances;
161     mapping (address => bool) public isFeeExempt;
162     mapping (address => bool) private isBot;
163     IRouter router;
164     address public pair;
165     bool private tradingAllowed = false;
166     bool private swapEnabled = true;
167     uint256 private swapTimes;
168     bool private swapping;
169     uint256 swapAmount = 4;
170     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
171     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
172     modifier lockTheSwap {swapping = true; _; swapping = false;}
173     uint256 private liquidityFee = 0;
174     uint256 private marketingFee = 500;
175     uint256 private developmentFee = 500;
176     uint256 private burnFee = 0;
177     uint256 private totalFee = 2000;
178     uint256 private sellFee = 2000;
179     uint256 private transferFee = 2000;
180     uint256 private denominator = 10000;
181     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
182     address internal development_receiver = 0xc1244286eDACb4097715386992aeD36752483dcB; 
183     address internal marketing_receiver = 0xc1244286eDACb4097715386992aeD36752483dcB;
184     address internal liquidity_receiver = 0xc1244286eDACb4097715386992aeD36752483dcB;
185     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
186     uint256 public _maxSellAmount = ( _totalSupply * 200 ) / 10000;
187     uint256 public _maxWalletToken = ( _totalSupply * 200 ) / 10000;
188 
189     constructor() Ownable(msg.sender) {
190         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
191         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
192         router = _router; pair = _pair;
193         isFeeExempt[address(this)] = true;
194         isFeeExempt[liquidity_receiver] = true;
195         isFeeExempt[marketing_receiver] = true;
196         isFeeExempt[development_receiver] = true;
197         isFeeExempt[msg.sender] = true;
198         _balances[msg.sender] = _totalSupply;
199         emit Transfer(address(0), msg.sender, _totalSupply);
200     }
201 
202     receive() external payable {}
203     function name() public pure returns (string memory) {return _name;}
204     function symbol() public pure returns (string memory) {return _symbol;}
205     function decimals() public pure returns (uint8) {return _decimals;}
206     function startTrading() external onlyOwner {tradingAllowed = true;}
207     function getOwner() external view override returns (address) { return owner; }
208     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
209     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
210     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
211     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
212     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
213     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
214 
215     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
216         bool aboveMin = amount >= minTokenAmount;
217         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
218         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
219     }
220 
221     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
222         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
223         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
224     }
225 
226     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
227         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
228         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
229     }
230 
231     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
232         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
233         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
234         uint256 limit = totalSupply().mul(5).div(1000);
235         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
236     }
237 
238     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
239         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
240         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
241     }
242 
243     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
244         for(uint i=0; i < addresses.length; i++){
245         isBot[addresses[i]] = _enabled; }
246     }
247 
248     function manualSwap() external onlyOwner {
249         uint256 amount = balanceOf(address(this));
250         if(amount > swapThreshold){amount = swapThreshold;}
251         swapAndLiquify(amount);
252     }
253 
254     function rescueERC20(address _address, uint256 percent) external onlyOwner {
255         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
256         IERC20(_address).transfer(development_receiver, _amount);
257     }
258 
259     function swapAndLiquify(uint256 tokens) private lockTheSwap {
260         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
261         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
262         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
263         uint256 initialBalance = address(this).balance;
264         swapTokensForETH(toSwap);
265         uint256 deltaBalance = address(this).balance.sub(initialBalance);
266         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
267         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
268         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
269         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
270         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
271         uint256 contractBalance = address(this).balance;
272         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
273     }
274 
275     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
276         _approve(address(this), address(router), tokenAmount);
277         router.addLiquidityETH{value: ETHAmount}(
278             address(this),
279             tokenAmount,
280             0,
281             0,
282             liquidity_receiver,
283             block.timestamp);
284     }
285 
286     function swapTokensForETH(uint256 tokenAmount) private {
287         address[] memory path = new address[](2);
288         path[0] = address(this);
289         path[1] = router.WETH();
290         _approve(address(this), address(router), tokenAmount);
291         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
292             tokenAmount,
293             0,
294             path,
295             address(this),
296             block.timestamp);
297     }
298 
299     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
300         return !isFeeExempt[sender] && !isFeeExempt[recipient];
301     }
302 
303     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
304         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
305         if(recipient == pair){return sellFee;}
306         if(sender == pair){return totalFee;}
307         return transferFee;
308     }
309 
310     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
311         if(getTotalFee(sender, recipient) > 0){
312         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
313         _balances[address(this)] = _balances[address(this)].add(feeAmount);
314         emit Transfer(sender, address(this), feeAmount);
315         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
316         return amount.sub(feeAmount);} return amount;
317     }
318 
319     function _transfer(address sender, address recipient, uint256 amount) private {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
323         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
324         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
325         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
326         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
327         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
328         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
329         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
330         _balances[sender] = _balances[sender].sub(amount);
331         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
332         _balances[recipient] = _balances[recipient].add(amountReceived);
333         emit Transfer(sender, recipient, amountReceived);
334     }
335 
336     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
337         _transfer(sender, recipient, amount);
338         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
339         return true;
340     }
341 
342     function _approve(address owner, address spender, uint256 amount) private {
343         require(owner != address(0), "ERC20: approve from the zero address");
344         require(spender != address(0), "ERC20: approve to the zero address");
345         _allowances[owner][spender] = amount;
346         emit Approval(owner, spender, amount);
347     }
348 }