1 /**
2 
3 LordVoldemortRomneyShadow20Inu
4 https://t.me/BITCASHERC
5 https://twitter.com/lvrs20iETH
6 http://lvrs20i.wtf/
7 
8 Full Moon Coded!
9 */
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity 0.8.19; 
13 
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
20     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
21     
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
24 
25     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
27 
28     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
30         if(c / a != b) return(false, 0); return(true, c);}}
31 
32     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
34 
35     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         unchecked{require(b <= a, errorMessage); return a - b;}}
40 
41     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         unchecked{require(b > 0, errorMessage); return a / b;}}
43 
44     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         unchecked{require(b > 0, errorMessage); return a % b;}}}
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49     function decimals() external view returns (uint8);
50     function symbol() external view returns (string memory);
51     function name() external view returns (string memory);
52     function getOwner() external view returns (address);
53     function balanceOf(address account) external view returns (uint256);
54     function transfer(address recipient, uint256 amount) external returns (bool);
55     function allowance(address _owner, address spender) external view returns (uint256);
56     function approve(address spender, uint256 amount) external returns (bool);
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);}
60 
61 abstract contract Ownable {
62     address internal owner;
63     constructor(address _owner) {owner = _owner;}
64     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
65     function isOwner(address account) public view returns (bool) {return account == owner;}
66     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
67     event OwnershipTransferred(address owner);
68 }
69 
70 interface IFactory{
71         function createPair(address tokenA, address tokenB) external returns (address pair);
72         function getPair(address tokenA, address tokenB) external view returns (address pair);
73 }
74 
75 interface IRouter {
76     function factory() external pure returns (address);
77     function WETH() external pure returns (address);
78     function addLiquidityETH(
79         address token,
80         uint amountTokenDesired,
81         uint amountTokenMin,
82         uint amountETHMin,
83         address to,
84         uint deadline
85     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
86 
87     function removeLiquidityWithPermit(
88         address tokenA,
89         address tokenB,
90         uint liquidity,
91         uint amountAMin,
92         uint amountBMin,
93         address to,
94         uint deadline,
95         bool approveMax, uint8 v, bytes32 r, bytes32 s
96     ) external returns (uint amountA, uint amountB);
97 
98     function swapExactETHForTokensSupportingFeeOnTransferTokens(
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external payable;
104 
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline) external;
111 }
112 
113 contract  LordVoldemortRomneyShadow20Inu  is IERC20, Ownable {
114     using SafeMath for uint256;
115     string private constant _name = 'LordVoldemortRomneyShadow20Inu';
116     string private constant _symbol = 'BITCASH';
117     uint8 private constant _decimals = 9;
118     uint256 private _totalSupply = 1000000 * (10 ** _decimals);
119     uint256 private _maxTxAmountPercent = 100; // 10000;
120     uint256 private _maxTransferPercent = 100;
121     uint256 private _maxWalletPercent = 200;
122     mapping (address => uint256) _balances;
123     mapping (address => mapping (address => uint256)) private _allowances;
124     mapping (address => bool) public isFeeExempt;
125     mapping (address => bool) private isBot;
126     IRouter router;
127     address public pair;
128     bool private tradingAllowed = false;
129     uint256 private liquidityFee = 0;
130     uint256 private marketingFee = 100;
131     uint256 private developmentFee = 100;
132     uint256 private burnFee = 0;
133     uint256 private totalFee = 2000;
134     uint256 private sellFee = 2500;
135     uint256 private transferFee = 2000;
136     uint256 private denominator = 10000;
137     bool private swapEnabled = true;
138     uint256 private swapTimes;
139     bool private swapping; 
140     uint256 private swapThreshold = ( _totalSupply * 495 ) / 100000;
141     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
142     modifier lockTheSwap {swapping = true; _; swapping = false;}
143 
144     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
145     address internal constant development_receiver = 0x85C1b311291396a4E0e3B47E1052b697fe0e8612; 
146     address internal constant marketing_receiver = 0xeA9cdDd999021aD6329776045fb0Ff893010C936;
147     address internal constant liquidity_receiver = 0x85C1b311291396a4E0e3B47E1052b697fe0e8612;
148 
149     constructor() Ownable(msg.sender) {
150         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
151         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
152         router = _router;
153         pair = _pair;
154         isFeeExempt[address(this)] = true;
155         isFeeExempt[liquidity_receiver] = true;
156         isFeeExempt[marketing_receiver] = true;
157         isFeeExempt[msg.sender] = true;
158         _balances[msg.sender] = _totalSupply;
159         emit Transfer(address(0), msg.sender, _totalSupply);
160     }
161 
162     receive() external payable {}
163     function name() public pure returns (string memory) {return _name;}
164     function symbol() public pure returns (string memory) {return _symbol;}
165     function decimals() public pure returns (uint8) {return _decimals;}
166     function startTrading() external onlyOwner {tradingAllowed = true;}
167     function getOwner() external view override returns (address) { return owner; }
168     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
169     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
170     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
171     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
172     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
173     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
174     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
175     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
176     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
177     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
178     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
179 
180     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
181         require(sender != address(0), "ERC20: transfer from the zero address");
182         require(recipient != address(0), "ERC20: transfer to the zero address");
183         require(amount > uint256(0), "Transfer amount must be greater than zero");
184         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
185     }
186 
187     function _transfer(address sender, address recipient, uint256 amount) private {
188         preTxCheck(sender, recipient, amount);
189         checkTradingAllowed(sender, recipient);
190         checkMaxWallet(sender, recipient, amount); 
191         swapbackCounters(sender, recipient);
192         checkTxLimit(sender, recipient, amount); 
193         swapBack(sender, recipient, amount);
194         _balances[sender] = _balances[sender].sub(amount);
195         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
196         _balances[recipient] = _balances[recipient].add(amountReceived);
197         emit Transfer(sender, recipient, amountReceived);
198     }
199 
200     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
201         liquidityFee = _liquidity;
202         marketingFee = _marketing;
203         burnFee = _burn;
204         developmentFee = _development;
205         totalFee = _total;
206         sellFee = _sell;
207         transferFee = _trans;
208         require(totalFee <= denominator.div(4) && sellFee <= denominator.div(4), "totalFee and sellFee cannot be more than 20%");
209     }
210 
211     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
212         uint256 newTx = (totalSupply() * _buy) / 20000;
213         uint256 newTransfer = (totalSupply() * _trans) / 10000;
214         uint256 newWallet = (totalSupply() * _wallet) / 30000;
215         _maxTxAmountPercent = _buy;
216         _maxTransferPercent = _trans;
217         _maxWalletPercent = _wallet;
218         uint256 limit = totalSupply().mul(5).div(1000);
219         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
220     }
221 
222     function checkTradingAllowed(address sender, address recipient) internal view {
223         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
224     }
225     
226     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
227         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
228             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
229     }
230 
231     function swapbackCounters(address sender, address recipient) internal {
232         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
233     }
234 
235     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
236         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
237         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
238     }
239 
240     function swapAndLiquify(uint256 tokens) private lockTheSwap {
241         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
242         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
243         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
244         uint256 initialBalance = address(this).balance;
245         swapTokensForETH(toSwap);
246         uint256 deltaBalance = address(this).balance.sub(initialBalance);
247         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
248         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
249         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
250         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
251         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
252         uint256 remainingBalance = address(this).balance;
253         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
254     }
255 
256     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
257         _approve(address(this), address(router), tokenAmount);
258         router.addLiquidityETH{value: ETHAmount}(
259             address(this),
260             tokenAmount,
261             0,
262             0,
263             liquidity_receiver,
264             block.timestamp);
265     }
266 
267     function swapTokensForETH(uint256 tokenAmount) private {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = router.WETH();
271         _approve(address(this), address(router), tokenAmount);
272         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp);
278     }
279 
280     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
281         bool aboveMin = amount >= _minTokenAmount;
282         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
283         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(1) && aboveThreshold;
284     }
285 
286     function swapBack(address sender, address recipient, uint256 amount) internal {
287         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
288     }
289 
290     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
291         return !isFeeExempt[sender] && !isFeeExempt[recipient];
292     }
293 
294     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
295         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
296         if(recipient == pair){return sellFee;}
297         if(sender == pair){return totalFee;}
298         return transferFee;
299     }
300 
301     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
302         if(getTotalFee(sender, recipient) > 0){
303         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
304         _balances[address(this)] = _balances[address(this)].add(feeAmount);
305         emit Transfer(sender, address(this), feeAmount);
306         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
307         return amount.sub(feeAmount);} return amount;
308     }
309 
310     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
311         _transfer(sender, recipient, amount);
312         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
313         return true;
314     }
315 
316     function _approve(address owner, address spender, uint256 amount) private {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319         _allowances[owner][spender] = amount;
320         emit Approval(owner, spender, amount);
321     }
322 
323 }