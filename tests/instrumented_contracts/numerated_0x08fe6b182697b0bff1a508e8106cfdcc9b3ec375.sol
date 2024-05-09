1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 
6 library SafeMath {
7 
8     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
9         unchecked {
10             uint256 c = a + b;
11             if (c < a) return (false, 0);
12             return (true, c);
13         }
14     }
15 
16     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
17         unchecked {
18             if (b > a) return (false, 0);
19             return (true, a - b);
20         }
21     }
22 
23     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             if (a == 0) return (true, 0);
26             uint256 c = a * b;
27             if (c / a != b) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (b == 0) return (false, 0);
35             return (true, a / b);
36         }
37     }
38 
39     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b == 0) return (false, 0);
42             return (true, a % b);
43         }
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a + b;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a - b;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a * b;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a / b;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a % b;
64     }
65 
66     function sub(
67         uint256 a,
68         uint256 b,
69         string memory errorMessage
70     ) internal pure returns (uint256) {
71         unchecked {
72             require(b <= a, errorMessage);
73             return a - b;
74         }
75     }
76 
77     function div(
78         uint256 a,
79         uint256 b,
80         string memory errorMessage
81     ) internal pure returns (uint256) {
82         unchecked {
83             require(b > 0, errorMessage);
84             return a / b;
85         }
86     }
87 
88     function mod(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         unchecked {
94             require(b > 0, errorMessage);
95             return a % b;
96         }
97     }
98 }
99 
100 interface IERC20 {
101     function decimals() external view returns (uint8);
102     function symbol() external view returns (string memory);
103     function name() external view returns (string memory);
104     function getOwner() external view returns (address);
105     function totalSupply() external view returns (uint256);
106     function balanceOf(address account) external view returns (uint256);
107     function transfer(address recipient, uint256 amount) external returns (bool);
108     function allowance(address _owner, address spender) external view returns (uint256);
109     function approve(address spender, uint256 amount) external returns (bool);
110     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
111     event Transfer(address indexed from, address indexed to, uint256 value);
112     event Approval(address indexed owner, address indexed spender, uint256 value);}
113 
114 abstract contract Ownable {
115     address internal owner;
116     constructor(address _owner) {owner = _owner;}
117     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
118     function isOwner(address account) public view returns (bool) {return account == owner;}
119     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
120     event OwnershipTransferred(address owner);
121 }
122 
123 interface IFactory{
124         function createPair(address tokenA, address tokenB) external returns (address pair);
125         function getPair(address tokenA, address tokenB) external view returns (address pair);
126 }
127 
128 interface IRouter {
129     function factory() external pure returns (address);
130     function WETH() external pure returns (address);
131     function addLiquidityETH(
132         address token,
133         uint amountTokenDesired,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline
138     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
139 
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline) external;
146 }
147 
148 contract Danis is IERC20, Ownable {
149     using SafeMath for uint256;
150     string private constant _name = 'Danis';
151     string private constant _symbol = unicode'DANIS';
152     uint8 private constant _decimals = 9;
153     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
154     mapping (address => uint256) _balances;
155     mapping (address => mapping (address => uint256)) private _allowances;
156     mapping (address => bool) public isFeeExempt;
157     mapping (address => bool) private isBot;
158     IRouter router;
159     address public pair;
160     bool private tradingAllowed = false;
161     bool private swapEnabled = true;
162     uint256 private swapTimes;
163     bool private swapping;
164     uint256 swapAmount = 1;
165     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
166     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
167     modifier lockTheSwap {swapping = true; _; swapping = false;}
168     uint256 private liquidityFee = 0;
169     uint256 private marketingFee = 1250;
170     uint256 private developmentFee = 1250;
171     uint256 private burnFee = 0;
172     uint256 private totalFee = 2500;
173     uint256 private sellFee = 9900;
174     uint256 private transferFee = 9900;
175     uint256 private denominator = 10000;
176     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
177     address internal development_receiver = 0xeE79cfFD955Cd6A1A1DCB9bFF02A4DE6E1eff719; 
178     address internal marketing_receiver = 0xeE79cfFD955Cd6A1A1DCB9bFF02A4DE6E1eff719;
179     address internal liquidity_receiver = 0xeE79cfFD955Cd6A1A1DCB9bFF02A4DE6E1eff719;
180     uint256 public _maxTxAmount = ( _totalSupply * 40 ) / 10000;
181     uint256 public _maxSellAmount = ( _totalSupply * 40 ) / 10000;
182     uint256 public _maxWalletToken = ( _totalSupply * 40 ) / 10000;
183 
184     constructor() Ownable(msg.sender) {
185         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
186         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
187         router = _router; pair = _pair;
188         isFeeExempt[address(this)] = true;
189         isFeeExempt[liquidity_receiver] = true;
190         isFeeExempt[marketing_receiver] = true;
191         isFeeExempt[development_receiver] = true;
192         isFeeExempt[msg.sender] = true;
193         _balances[msg.sender] = _totalSupply;
194         emit Transfer(address(0), msg.sender, _totalSupply);
195     }
196 
197     receive() external payable {}
198     function name() public pure returns (string memory) {return _name;}
199     function symbol() public pure returns (string memory) {return _symbol;}
200     function decimals() public pure returns (uint8) {return _decimals;}
201     function startTrading() external onlyOwner {tradingAllowed = true;}
202     function getOwner() external view override returns (address) { return owner; }
203     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
204     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
205     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
206     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
207     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
208     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
209 
210     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
211         bool aboveMin = amount >= minTokenAmount;
212         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
213         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
214     }
215 
216     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
217         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
218         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
219     }
220 
221     function setFees(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
222         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
223         require(totalFee <= denominator && sellFee <= denominator && transferFee <= denominator, "totalFee and sellFee cannot be more than 100%");
224     }
225 
226     function setLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
227         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
228         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
229         uint256 limit = totalSupply().mul(5).div(1000);
230         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
231     }
232 
233     function setInternalWallet(address _marketing, address _liquidity, address _development) external onlyOwner {
234         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
235         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
236     }
237 
238     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
239         for(uint i=0; i < addresses.length; i++){
240         isBot[addresses[i]] = _enabled; }
241     }
242 
243     function manualSwap() external onlyOwner {
244         swapAndLiquify(swapThreshold);
245     }
246 
247     function rescue(address _address, uint256 percent) external onlyOwner {
248         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
249         IERC20(_address).transfer(development_receiver, _amount);
250     }
251 
252     function swapAndLiquify(uint256 tokens) private lockTheSwap {
253         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
254         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
255         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
256         uint256 initialBalance = address(this).balance;
257         swapTokensForETH(toSwap);
258         uint256 deltaBalance = address(this).balance.sub(initialBalance);
259         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
260         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
261         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
262         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
263         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
264         uint256 contractBalance = address(this).balance;
265         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
266     }
267 
268     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
269         _approve(address(this), address(router), tokenAmount);
270         router.addLiquidityETH{value: ETHAmount}(
271             address(this),
272             tokenAmount,
273             0,
274             0,
275             liquidity_receiver,
276             block.timestamp);
277     }
278 
279     function swapTokensForETH(uint256 tokenAmount) private {
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = router.WETH();
283         _approve(address(this), address(router), tokenAmount);
284         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp);
290     }
291 
292     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
293         return !isFeeExempt[sender] && !isFeeExempt[recipient];
294     }
295 
296     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
297         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
298         if(recipient == pair){return sellFee;}
299         if(sender == pair){return totalFee;}
300         return transferFee;
301     }
302 
303     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
304         if(getTotalFee(sender, recipient) > 0){
305         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
306         _balances[address(this)] = _balances[address(this)].add(feeAmount);
307         emit Transfer(sender, address(this), feeAmount);
308         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
309         return amount.sub(feeAmount);} return amount;
310     }
311 
312     function _transfer(address sender, address recipient, uint256 amount) private {
313         require(sender != address(0), "ERC20: transfer from the zero address");
314         require(recipient != address(0), "ERC20: transfer to the zero address");
315         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
316         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
317         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
318         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
319         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
320         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
321         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
322         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
323         _balances[sender] = _balances[sender].sub(amount);
324         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
325         _balances[recipient] = _balances[recipient].add(amountReceived);
326         emit Transfer(sender, recipient, amountReceived);
327     }
328 
329     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
330         _transfer(sender, recipient, amount);
331         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
332         return true;
333     }
334 
335     function _approve(address owner, address spender, uint256 amount) private {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338         _allowances[owner][spender] = amount;
339         emit Approval(owner, spender, amount);
340     }
341 
342 }