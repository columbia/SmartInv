1 /**
2 https://t.me/EightBitShibaInu
3 https://twitter.com/8BitShibaInu
4 https://8bitshib.wtf/
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.16;
10 
11 
12 library SafeMath {
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
17     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
18     
19     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
21 
22     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
24 
25     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
27         if(c / a != b) return(false, 0); return(true, c);}}
28 
29     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
31 
32     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         unchecked{require(b <= a, errorMessage); return a - b;}}
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b > 0, errorMessage); return a / b;}}
40 
41     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b > 0, errorMessage); return a % b;}}}
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function decimals() external view returns (uint8);
47     function symbol() external view returns (string memory);
48     function name() external view returns (string memory);
49     function getOwner() external view returns (address);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address _owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);}
57 
58 abstract contract Ownable {
59     address internal owner;
60     constructor(address _owner) {owner = _owner;}
61     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
62     function isOwner(address account) public view returns (bool) {return account == owner;}
63     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
64     event OwnershipTransferred(address owner);
65 }
66 
67 interface IFactory{
68         function createPair(address tokenA, address tokenB) external returns (address pair);
69         function getPair(address tokenA, address tokenB) external view returns (address pair);
70 }
71 
72 interface IRouter {
73     function factory() external pure returns (address);
74     function WETH() external pure returns (address);
75     function addLiquidityETH(
76         address token,
77         uint amountTokenDesired,
78         uint amountTokenMin,
79         uint amountETHMin,
80         address to,
81         uint deadline
82     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
83 
84     function removeLiquidityWithPermit(
85         address tokenA,
86         address tokenB,
87         uint liquidity,
88         uint amountAMin,
89         uint amountBMin,
90         address to,
91         uint deadline,
92         bool approveMax, uint8 v, bytes32 r, bytes32 s
93     ) external returns (uint amountA, uint amountB);
94 
95     function swapExactETHForTokensSupportingFeeOnTransferTokens(
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external payable;
101 
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline) external;
108 }
109 
110 contract SHIBIT is IERC20, Ownable {
111     using SafeMath for uint256;
112     string private constant _name = '8Bit Shiba Inu';
113     string private constant _symbol = 'SHIBIT';
114     uint8 private constant _decimals = 9;
115     uint256 private _totalSupply = 1000000000000 * (10 ** _decimals);
116     uint256 private _maxTxAmountPercent = 100; // 10000;
117     uint256 private _maxTransferPercent = 100;
118     uint256 private _maxWalletPercent = 100;
119     mapping (address => uint256) _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) public isFeeExempt;
122     mapping (address => bool) private isBot;
123     IRouter router;
124     address public pair;
125     bool private tradingAllowed = false;
126     uint256 private liquidityFee = 0;
127     uint256 private marketingFee = 1000;
128     uint256 private developmentFee = 1000;
129     uint256 private burnFee = 0;
130     uint256 private totalFee = 2000;
131     uint256 private sellFee = 2000;
132     uint256 private transferFee = 2000;
133     uint256 private denominator = 10000;
134     bool private swapEnabled = true;
135     uint256 private swapTimes;
136     bool private swapping;
137     uint256 swapAmount = 1;
138     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
139     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
140     modifier lockTheSwap {swapping = true; _; swapping = false;}
141 
142     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
143     address internal constant development_receiver = 0xC08c5839a06adCbe3a05b61397BF7a62BFEF661a; 
144     address internal constant marketing_receiver = 0x99Aeeb4F23eE766E11622d6dC16A4359DD5C42AA;
145     address internal constant liquidity_receiver = 0xC08c5839a06adCbe3a05b61397BF7a62BFEF661a;
146 
147     constructor() Ownable(msg.sender) {
148         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
149         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
150         router = _router;
151         pair = _pair;
152         isFeeExempt[address(this)] = true;
153         isFeeExempt[liquidity_receiver] = true;
154         isFeeExempt[marketing_receiver] = true;
155         isFeeExempt[msg.sender] = true;
156         _balances[msg.sender] = _totalSupply;
157         emit Transfer(address(0), msg.sender, _totalSupply);
158     }
159 
160     receive() external payable {}
161     function name() public pure returns (string memory) {return _name;}
162     function symbol() public pure returns (string memory) {return _symbol;}
163     function decimals() public pure returns (uint8) {return _decimals;}
164     function startTrading() external onlyOwner {tradingAllowed = true;}
165     function getOwner() external view override returns (address) { return owner; }
166     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
167     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
168     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
169     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
170     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
171     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
172     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
173     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
174     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
175     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
176     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
177 
178     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
179         require(sender != address(0), "ERC20: transfer from the zero address");
180         require(recipient != address(0), "ERC20: transfer to the zero address");
181         require(amount > uint256(0), "Transfer amount must be greater than zero");
182         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
183     }
184 
185     function _transfer(address sender, address recipient, uint256 amount) private {
186         preTxCheck(sender, recipient, amount);
187         checkTradingAllowed(sender, recipient);
188         checkMaxWallet(sender, recipient, amount); 
189         swapbackCounters(sender, recipient);
190         checkTxLimit(sender, recipient, amount); 
191         swapBack(sender, recipient, amount);
192         _balances[sender] = _balances[sender].sub(amount);
193         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
194         _balances[recipient] = _balances[recipient].add(amountReceived);
195         emit Transfer(sender, recipient, amountReceived);
196     }
197 
198     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
199         liquidityFee = _liquidity;
200         marketingFee = _marketing;
201         burnFee = _burn;
202         developmentFee = _development;
203         totalFee = _total;
204         sellFee = _sell;
205         transferFee = _trans;
206         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
207     }
208 
209     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
210         uint256 newTx = (totalSupply() * _buy) / 10000;
211         uint256 newTransfer = (totalSupply() * _trans) / 10000;
212         uint256 newWallet = (totalSupply() * _wallet) / 10000;
213         _maxTxAmountPercent = _buy;
214         _maxTransferPercent = _trans;
215         _maxWalletPercent = _wallet;
216         uint256 limit = totalSupply().mul(5).div(1000);
217         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
218     }
219 
220     function checkTradingAllowed(address sender, address recipient) internal view {
221         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
222     }
223     
224     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
225         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
226             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
227     }
228 
229     function swapbackCounters(address sender, address recipient) internal {
230         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
231     }
232 
233     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
234         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
235         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
236     }
237 
238     function swapAndLiquify(uint256 tokens) private lockTheSwap {
239         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
240         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
241         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
242         uint256 initialBalance = address(this).balance;
243         swapTokensForETH(toSwap);
244         uint256 deltaBalance = address(this).balance.sub(initialBalance);
245         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
246         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
247         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
248         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
249         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
250         uint256 remainingBalance = address(this).balance;
251         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
252     }
253 
254     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
255         _approve(address(this), address(router), tokenAmount);
256         router.addLiquidityETH{value: ETHAmount}(
257             address(this),
258             tokenAmount,
259             0,
260             0,
261             liquidity_receiver,
262             block.timestamp);
263     }
264 
265     function swapTokensForETH(uint256 tokenAmount) private {
266         address[] memory path = new address[](2);
267         path[0] = address(this);
268         path[1] = router.WETH();
269         _approve(address(this), address(router), tokenAmount);
270         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
271             tokenAmount,
272             0,
273             path,
274             address(this),
275             block.timestamp);
276     }
277 
278     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
279         bool aboveMin = amount >= minTokenAmount;
280         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
281         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
282     }
283 
284     function setSwapbackSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
285         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
286         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
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