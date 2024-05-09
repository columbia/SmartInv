1 /**
2                                   --+###%              #####-=                            
3                             :++#####%%%#%              ##%%#####+::.                      
4                         :-####%%####%###%             :##%%##########+:::                 
5                      =-#####%#############-==--=-----+##%#########%%%%###*                
6                   :+#######%########%##%%#############%%%#####%%%%%%##%####+:             
7                 -##########%%######%%##%###%########%%%#%%%%%%#########%#%####-           
8               .####%%%%#######%##%%%######%%%%%%%%%%%#######%%%#################-         
9             :+###%##%%%#############*++==-::::::::--==+*#%%%#####%%#####%###%%%##*:       
10            *##%%%########%%###*=-:.                        :=*%%%%####%#######%%%%##:     
11            -+##%%#######%##%+.                                 .=##%#############+:.      
12               *##%########+:                                       -#%%##%%###+:.         
13                ##%%#####+.                                           .=*###+:.            
14               -#######=                                                 .-.               
15              %#%%###=.                       .+:                                          
16             %######-                        -###+:                                        
17   .::      +#####*:                      .=*#%####+.                                      
18   *###++++####%##:                     -###%########+:                                    
19   #%#%######%%#%=                    :+###%#######%%%#*=.                                 
20  %###%##########.                   -######%%######%####*-                                
21 +#######%%#####:                  :+##%%%###%#########%%##*-                              
22 %#############*                  =##%###%################%##*.                            
23 ##%#%%#####%##+                 =####%#############%%%##%#%###-                           
24 ##############+               .*##############################%*                          
25 ##############=               +##%#########################%%##%:                         
26 ##############=               +##%#########################%%##%:                         
27 ###%#######%##=               =###%########################%%##%:                         
28 %##%##########*               .*##############################*-                          
29 =####%#########=                :*###%##########%#######%%##%#.                           
30  :#%#%#%####%%##                 .+#%%####*+#####%%%####%##+-.                            
31   #%#%##########=                   .:::..  *#####+.:---:.                                
32   :++++:::+#%%###+.                       :*##%####=                                      
33            -#####%#:                     :###%%##%#%#.                                    
34             %##%##%#.                   .*###########+                                    
35              +##%####+                    ...                                             
36               -#%#####+                                                 :+%:              
37                ##%%#%###+:                                           .=#####++.           
38              :*##%%##%###%#+.                                    .:+%%###%%%###++-        
39            *###%%#####%%####%*=:.                             :-*%%%###%%#####%#####*     
40            .##%#%###%%%###%%%##%%*-:                       .+#%%###%%#######%%#%%%##.     
41             :+##%%########%#%%#######*+-:.           .::=+*##############%%#%#####+:      
42               .+##%#######%%%%###%%########********########%#%%#%#####%%%%%#%%##+.        
43                 :###%%%%#%##############%%%###%%%#%#####%%#########%#####%####*           
44                   :+###%%%###########%%%##############%%###########%%######-              
45                      :-+#####%#######%%##%=::::::::::-##%%%########%####%=                
46                          ::+####%%######%              ##%%%%%%####*++.                   
47                               .######%%#%              ##%######-                         
48 
49 http://t.me/CaaconPortal
50 
51 https://www.caacon.vip
52 
53 https://twitter.com/Caaconofficial
54 
55 */
56 
57 // SPDX-License-Identifier: MIT
58 
59 pragma solidity 0.8.19;
60 
61 
62 library SafeMath {
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
68     
69     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
71 
72     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
74 
75     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
77         if(c / a != b) return(false, 0); return(true, c);}}
78 
79     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
81 
82     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
83         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
84 
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         unchecked{require(b <= a, errorMessage); return a - b;}}
87 
88     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         unchecked{require(b > 0, errorMessage); return a / b;}}
90 
91     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         unchecked{require(b > 0, errorMessage); return a % b;}}}
93 
94 interface IERC20 {
95     function totalSupply() external view returns (uint256);
96     function decimals() external view returns (uint8);
97     function symbol() external view returns (string memory);
98     function name() external view returns (string memory);
99     function getOwner() external view returns (address);
100     function balanceOf(address account) external view returns (uint256);
101     function transfer(address recipient, uint256 amount) external returns (bool);
102     function allowance(address _owner, address spender) external view returns (uint256);
103     function approve(address spender, uint256 amount) external returns (bool);
104     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
105     event Transfer(address indexed from, address indexed to, uint256 value);
106     event Approval(address indexed owner, address indexed spender, uint256 value);}
107 
108 abstract contract Ownable {
109     address internal owner;
110     constructor(address _owner) {owner = _owner;}
111     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
112     function isOwner(address account) public view returns (bool) {return account == owner;}
113     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
114     event OwnershipTransferred(address owner);
115 }
116 
117 interface IFactory{
118         function createPair(address tokenA, address tokenB) external returns (address pair);
119         function getPair(address tokenA, address tokenB) external view returns (address pair);
120 }
121 
122 interface IRouter {
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 
134     function removeLiquidityWithPermit(
135         address tokenA,
136         address tokenB,
137         uint liquidity,
138         uint amountAMin,
139         uint amountBMin,
140         address to,
141         uint deadline,
142         bool approveMax, uint8 v, bytes32 r, bytes32 s
143     ) external returns (uint amountA, uint amountB);
144 
145     function swapExactETHForTokensSupportingFeeOnTransferTokens(
146         uint amountOutMin,
147         address[] calldata path,
148         address to,
149         uint deadline
150     ) external payable;
151 
152     function swapExactTokensForETHSupportingFeeOnTransferTokens(
153         uint amountIn,
154         uint amountOutMin,
155         address[] calldata path,
156         address to,
157         uint deadline) external;
158 }
159 
160 contract Caacon is IERC20, Ownable {
161     using SafeMath for uint256;
162     string private constant _name = 'Caacon';
163     string private constant _symbol = 'CC';
164     uint8 private constant _decimals = 9;
165     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
166     uint256 private _maxTxAmountPercent = 200; // 10000;
167     uint256 private _maxTransferPercent = 200;
168     uint256 private _maxWalletPercent = 200;
169     mapping (address => uint256) _balances;
170     mapping (address => mapping (address => uint256)) private _allowances;
171     mapping (address => bool) public isFeeExempt;
172     IRouter router;
173     address public pair;
174     bool private tradingAllowed = false;
175     uint256 private liquidityFee = 300;
176     uint256 private JackpotFee = 500;
177     uint256 private developmentFee = 200;
178     uint256 private burnFee = 0;
179     uint256 private totalFee = 1000;
180     uint256 private sellFee = 3000;
181     uint256 private transferFee = 0;
182     uint256 private denominator = 10000;
183     bool private swapEnabled = true;
184     uint256 private swapTimes;
185     bool private swapping; 
186     uint256 private swapThreshold = ( _totalSupply * 200 ) / 100000;
187     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
188     modifier lockTheSwap {swapping = true; _; swapping = false;}
189 
190     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
191     address internal constant development_receiver = 0x12E2D89901A7B3C41232bF9158Af8CE8D6E12251; 
192     address internal constant Jackpot_receiver = 0x930458f87afC79d227fD6FBF37bd46D0d1b54b47;
193     address internal constant liquidity_receiver = 0xEe2b5021adBb5A3CA7C8e3f0088711D097391088;
194 
195     constructor() Ownable(msg.sender) {
196         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
197         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
198         router = _router;
199         pair = _pair;
200         isFeeExempt[address(this)] = true;
201         isFeeExempt[liquidity_receiver] = true;
202         isFeeExempt[Jackpot_receiver] = true;
203         isFeeExempt[msg.sender] = true;
204         _balances[msg.sender] = _totalSupply;
205         emit Transfer(address(0), msg.sender, _totalSupply);
206     }
207 
208     receive() external payable {}
209     function name() public pure returns (string memory) {return _name;}
210     function symbol() public pure returns (string memory) {return _symbol;}
211     function decimals() public pure returns (uint8) {return _decimals;}
212     function LaunchCaacon() external onlyOwner {tradingAllowed = true;}
213     function getOwner() external view override returns (address) { return owner; }
214     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
215     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
216     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
217     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
218     function setisfeeExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
219     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
220     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
221     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
222     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
223     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
224 
225     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
226         require(sender != address(0), "ERC20: transfer from the zero address");
227         require(recipient != address(0), "ERC20: transfer to the zero address");
228         require(amount > uint256(0), "Transfer amount must be greater than zero");
229         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
230     }
231 
232     function _transfer(address sender, address recipient, uint256 amount) private {
233         preTxCheck(sender, recipient, amount);
234         checkTradingAllowed(sender, recipient);
235         checkMaxWallet(sender, recipient, amount); 
236         swapbackCounters(sender, recipient);
237         checkTxLimit(sender, recipient, amount); 
238         swapBack(sender, recipient, amount);
239         _balances[sender] = _balances[sender].sub(amount);
240         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
241         _balances[recipient] = _balances[recipient].add(amountReceived);
242         emit Transfer(sender, recipient, amountReceived);
243     }
244 
245     function setnewFees(uint256 _liquidity, uint256 _Jackpot, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
246         liquidityFee = _liquidity;
247         JackpotFee = _Jackpot;
248         burnFee = _burn;
249         developmentFee = _development;
250         totalFee = _total;
251         sellFee = _sell;
252         transferFee = _trans;
253         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
254     }
255 
256     function setLimits(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
257         uint256 newTx = (totalSupply() * _buy) / 10000;
258         uint256 newTransfer = (totalSupply() * _trans) / 10000;
259         uint256 newWallet = (totalSupply() * _wallet) / 10000;
260         _maxTxAmountPercent = _buy;
261         _maxTransferPercent = _trans;
262         _maxWalletPercent = _wallet;
263         uint256 limit = totalSupply().mul(5).div(1000);
264         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
265     }
266 
267     function checkTradingAllowed(address sender, address recipient) internal view {
268         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
269     }
270     
271     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
272         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
273             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
274     }
275 
276     function swapbackCounters(address sender, address recipient) internal {
277         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
278     }
279 
280     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
281         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
282         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
283     }
284 
285     function swapAndLiquify(uint256 tokens) private lockTheSwap {
286         uint256 _denominator = (liquidityFee.add(1).add(JackpotFee).add(developmentFee)).mul(2);
287         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
288         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
289         uint256 initialBalance = address(this).balance;
290         swapTokensForETH(toSwap);
291         uint256 deltaBalance = address(this).balance.sub(initialBalance);
292         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
293         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
294         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
295         uint256 JackpotAmt = unitBalance.mul(2).mul(JackpotFee);
296         if(JackpotAmt > 0){payable(Jackpot_receiver).transfer(JackpotAmt);}
297         uint256 remainingBalance = address(this).balance;
298         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
299     }
300 
301     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
302         _approve(address(this), address(router), tokenAmount);
303         router.addLiquidityETH{value: ETHAmount}(
304             address(this),
305             tokenAmount,
306             0,
307             0,
308             liquidity_receiver,
309             block.timestamp);
310     }
311 
312     function swapTokensForETH(uint256 tokenAmount) private {
313         address[] memory path = new address[](2);
314         path[0] = address(this);
315         path[1] = router.WETH();
316         _approve(address(this), address(router), tokenAmount);
317         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
318             tokenAmount,
319             0,
320             path,
321             address(this),
322             block.timestamp);
323     }
324 
325     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
326         bool aboveMin = amount >= _minTokenAmount;
327         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
328         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(1) && aboveThreshold;
329     }
330 
331     function swapBack(address sender, address recipient, uint256 amount) internal {
332         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
333     }
334 
335     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
336         return !isFeeExempt[sender] && !isFeeExempt[recipient];
337     }
338 
339     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
340         if(recipient == pair){return sellFee;}
341         if(sender == pair){return totalFee;}
342         return transferFee;
343     }
344 
345     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
346         if(getTotalFee(sender, recipient) > 0){
347         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
348         _balances[address(this)] = _balances[address(this)].add(feeAmount);
349         emit Transfer(sender, address(this), feeAmount);
350         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
351         return amount.sub(feeAmount);} return amount;
352     }
353 
354     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
355         _transfer(sender, recipient, amount);
356         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
357         return true;
358     }
359 
360     function _approve(address owner, address spender, uint256 amount) private {
361         require(owner != address(0), "ERC20: approve from the zero address");
362         require(spender != address(0), "ERC20: approve to the zero address");
363         _allowances[owner][spender] = amount;
364         emit Approval(owner, spender, amount);
365     }
366 
367 }