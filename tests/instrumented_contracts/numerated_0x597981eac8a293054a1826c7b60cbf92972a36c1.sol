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
59 pragma solidity 0.8.20;
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
166     uint256 private _maxTxAmountPercent = 10000; // 10000;
167     uint256 private _maxTransferPercent = 10000;
168     uint256 private _maxWalletPercent = 10000;
169     mapping (address => uint256) _balances;
170     mapping (address => mapping (address => uint256)) private _allowances;
171     mapping (address => bool) public isFeeExempt;
172     IRouter router;
173     address public pair;
174     bool private tradingAllowed = false;
175     uint256 private liquidityFee = 25;
176     uint256 private jackpotFee = 300;
177     uint256 private developmentFee = 175;
178     uint256 private holdersjackpotFee = 0;
179     uint256 private extraoneFee = 0;
180     uint256 private extratwoFee = 0;
181     uint256 private totalFee = 500;
182     uint256 private sellFee = 500;
183     uint256 private transferFee = 0;
184     uint256 private denominator = 10000;
185     bool private swapEnabled = true;
186     uint256 private swapTimes;
187     bool private swapping; 
188     uint256 public swapThreshold = ( _totalSupply * 2 ) / 1000;
189     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
190     modifier lockTheSwap {swapping = true; _; swapping = false;}
191 
192     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
193     address internal liquidity_receiver = 0xEe2b5021adBb5A3CA7C8e3f0088711D097391088;
194     address internal development_receiver = 0x12E2D89901A7B3C41232bF9158Af8CE8D6E12251;
195     address internal jackpot_receiver = 0x930458f87afC79d227fD6FBF37bd46D0d1b54b47;
196     address internal holdersjackpot_receiver = 0x03CF4588A344A525595b562fbBEEa351E8e28830;
197     address internal extratwo_receiver = 0x7AF8d5a795eD013953Bb7ddC7956f0d218C64BBb;
198     address internal extraone_receiver = 0xaa7df58fc5B297c9996e7f4ebD13E8205207B0fc;
199     
200 
201     constructor() Ownable(msg.sender) {
202         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
203         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
204         router = _router;
205         pair = _pair;
206         isFeeExempt[address(this)] = true;
207         isFeeExempt[liquidity_receiver] = true;
208         isFeeExempt[jackpot_receiver] = true;
209         isFeeExempt[development_receiver] = true;
210         isFeeExempt[holdersjackpot_receiver] = true;
211         isFeeExempt[extratwo_receiver] = true;
212         isFeeExempt[extraone_receiver] = true;
213         isFeeExempt[msg.sender] = true;
214         _balances[msg.sender] = _totalSupply;
215         emit Transfer(address(0), msg.sender, _totalSupply);
216     }
217 
218     receive() external payable {}
219     function name() public pure returns (string memory) {return _name;}
220     function symbol() public pure returns (string memory) {return _symbol;}
221     function decimals() public pure returns (uint8) {return _decimals;}
222     function launchCaacon() external onlyOwner {tradingAllowed = true;}
223     function getOwner() external view override returns (address) { return owner; }
224     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
225     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
226     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
227     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
228     function setisfeeExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
229     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
230     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(address(0)));}
231     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
232     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
233     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
234 
235     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
236         require(sender != address(0), "ERC20: transfer from the zero address");
237         require(recipient != address(0), "ERC20: transfer to the zero address");
238         require(amount > uint256(0), "Transfer amount must be greater than zero");
239         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
240     }
241 
242     function _transfer(address sender, address recipient, uint256 amount) private {
243         preTxCheck(sender, recipient, amount);
244         checkTradingAllowed(sender, recipient);
245         checkMaxWallet(sender, recipient, amount); 
246         swapbackCounters(sender, recipient);
247         checkTxLimit(sender, recipient, amount); 
248         swapBack(sender, recipient, amount);
249         _balances[sender] = _balances[sender].sub(amount);
250         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
251         _balances[recipient] = _balances[recipient].add(amountReceived);
252         emit Transfer(sender, recipient, amountReceived);
253     }
254 
255     function setnewFees(uint256 _liquidity, uint256 _jackpot, uint256 _development, uint256 _holdersjackpot, uint256 _extraone, uint256 _extratwo, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
256         liquidityFee = _liquidity;
257         jackpotFee = _jackpot;
258         developmentFee = _development;
259         holdersjackpotFee = _holdersjackpot;
260         extratwoFee - _extratwo;
261         extraoneFee - _extraone;
262         totalFee = _total;
263         sellFee = _sell;
264         transferFee = _trans;
265         require(totalFee <= denominator.div(10) && sellFee <= denominator.div(10), "totalFee and sellFee cannot be more than 10%");
266     }
267 
268     function setnewLimits(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
269         uint256 newTx = (totalSupply() * _buy) / 10000;
270         uint256 newTransfer = (totalSupply() * _trans) / 10000;
271         uint256 newWallet = (totalSupply() * _wallet) / 10000;
272         _maxTxAmountPercent = _buy;
273         _maxTransferPercent = _trans;
274         _maxWalletPercent = _wallet;
275         uint256 limit = totalSupply().mul(5).div(1000);
276         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
277     }
278 
279     function changeReceiverAddresses(address _liquidity_receiver, address _jackpot_receiver, address _development_receiver, address _holdersjackpot_receiver, address _extraone_receiver, address _extratwo_receiver) external onlyOwner {
280         liquidity_receiver = _liquidity_receiver;
281         jackpot_receiver = _jackpot_receiver;
282         development_receiver = _development_receiver;
283         holdersjackpot_receiver = _holdersjackpot_receiver;
284         extratwo_receiver = _extratwo_receiver;
285         extraone_receiver = _extraone_receiver;
286     }
287 
288     function checkTradingAllowed(address sender, address recipient) internal view {
289         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
290     }
291     
292     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
293         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
294             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
295     }
296 
297     function swapbackCounters(address sender, address recipient) internal {
298         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
299     }
300 
301     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
302         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
303         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
304     }
305 
306     function swapAndLiquify(uint256 tokens) private lockTheSwap {
307         uint256 _denominator = (liquidityFee.add(1).add(jackpotFee).add(developmentFee).add(holdersjackpotFee).add(extratwoFee).add(extraoneFee)).mul(2);
308         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
309         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
310         uint256 initialBalance = address(this).balance;
311         swapTokensForETH(toSwap);
312         uint256 deltaBalance = address(this).balance.sub(initialBalance);
313         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
314         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
315         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
316         uint256 jackpotAmt = unitBalance.mul(2).mul(jackpotFee);
317         if(jackpotAmt > 0){payable(jackpot_receiver).transfer(jackpotAmt);}
318         uint256 developmentAmt = unitBalance.mul(2).mul(developmentFee);
319         if(developmentAmt > 0){payable(development_receiver).transfer(developmentAmt);}
320         uint256 holdersjackpotAmt = unitBalance.mul(2).mul(holdersjackpotFee);
321         if(holdersjackpotAmt > 0){payable(holdersjackpot_receiver).transfer(holdersjackpotAmt);}
322         uint256 extratwoAmt = unitBalance.mul(2).mul(extratwoFee);
323         if(extratwoAmt > 0){payable(extratwo_receiver).transfer(extratwoAmt);}
324         uint256 remainingBalance = address(this).balance;
325         if(remainingBalance > uint256(0)){payable(extraone_receiver).transfer(remainingBalance);}
326     }
327 
328     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
329         _approve(address(this), address(router), tokenAmount);
330         router.addLiquidityETH{value: ETHAmount}(
331             address(this),
332             tokenAmount,
333             0,
334             0,
335             liquidity_receiver,
336             block.timestamp);
337     }
338 
339     function swapTokensForETH(uint256 tokenAmount) private {
340         address[] memory path = new address[](2);
341         path[0] = address(this);
342         path[1] = router.WETH();
343         _approve(address(this), address(router), tokenAmount);
344         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
345             tokenAmount,
346             0,
347             path,
348             address(this),
349             block.timestamp);
350     }
351 
352     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
353         bool aboveMin = amount >= _minTokenAmount;
354         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
355         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(1) && aboveThreshold;
356     }
357 
358     function swapBack(address sender, address recipient, uint256 amount) internal {
359         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
360     }
361 
362     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
363         return !isFeeExempt[sender] && !isFeeExempt[recipient];
364     }
365 
366     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
367         if(recipient == pair){return sellFee;}
368         if(sender == pair){return totalFee;}
369         return transferFee;
370     }
371 
372     function changeSwapthreshold(uint256 _swapThreshold) public onlyOwner {
373         swapThreshold = _swapThreshold;
374     
375     }
376 
377     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
378         if(getTotalFee(sender, recipient) > 0){
379         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
380         _balances[address(this)] = _balances[address(this)].add(feeAmount);
381         emit Transfer(sender, address(this), feeAmount);
382         return amount.sub(feeAmount);} return amount;
383     }
384 
385     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
386         _transfer(sender, recipient, amount);
387         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
388         return true;
389     }
390 
391     function _approve(address owner, address spender, uint256 amount) private {
392         require(owner != address(0), "ERC20: approve from the zero address");
393         require(spender != address(0), "ERC20: approve to the zero address");
394         _allowances[owner][spender] = amount;
395         emit Approval(owner, spender, amount);
396     }
397 
398 }