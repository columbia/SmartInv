1 /******************************************************************                                                          
2                              ---:::....                                                   
3                              @@@@@@@@@@@@@@@@@=                                           
4                             .@@@@@@@@@@@@@@@@@=                                           
5                             :@@@@@@@@@@@@@@@@@-                                           
6                             -@@@@@@@@@@@@@@@@@-                                           
7                             =@@@@@@@@@@@@@@@@@:                                           
8                             +@@@@@@@@@@@@@@@@@.                                           
9                             #@@@@@@@@@@@@@@@@@.                                           
10                             %@@@@@@@@@@@@@@@@@@+--:                                       
11                             @@@@@@@@@@@@@@@@@@@@@@%*+-::-                                 
12                            .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%-*=:.-=-.  -:===+:              
13                            :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@%@@@@@@@@%*+--         
14                            =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:        
15                            +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-        
16                            #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=        
17                            %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@=        
18      -%%%###**+++===---::::@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+        
19        *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%:       
20         :*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       
21           -#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#      
22             =#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*     
23               :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+     
24                -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%      
25                 %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%      
26                 -@@@@@@@@@@@@%*#%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=      
27                  :+@@@@@@@@#        -%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*=@@@#=       
28                    .-*%@@@%.          =%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+.:.          
29                        -+-              +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+.             
30                                          *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*:               
31                                           *@@@@@@@@@@@@@@@@@@@@@@@*==*=.                  
32                                           .%@@@@@@@@@@@@@@@@@@@@%=*:                      
33                                             =@@@@@@@@@@@@@@@@@#-:.                        
34                                              :#@@@@@@@@@@@@@@+-                           
35                                                -@@@@@@@@@@@@@*                            
36                                                .@@@@@@@@@@@*+.                            
37                                                 -@@@@@@@@@@@:.                            
38                                                  =@@@@@@@@@@*.                            
39                                                   -=*@@@@@@@@:                            
40                                                       .++**%@#.                           
41                                                             ::                            
42                                                                                           
43 
44 Telegram: T.me/texreserve
45 X/Twitter: X.com/texasreserve
46 Website: https://texasreserve.xyz/
47 
48 
49 Inspired by House Bill 4903 of the Texas Senate Texas Reserve will become the decentralized proof of concept for the framework set out by the bill.
50 
51 ******************************************************************/
52 // SPDX-License-Identifier: MIT
53 pragma solidity 0.8.21;
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 }
60 
61 interface IERC20 {
62     function totalSupply() external view returns (uint256);
63 
64     function balanceOf(address account) external view returns (uint256);
65 
66     function transfer(address recipient, uint256 amount)
67         external
68         returns (bool);
69 
70     function allowance(address owner, address spender)
71         external
72         view
73         returns (uint256);
74 
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     function transferFrom(
78         address sender,
79         address recipient,
80         uint256 amount
81     ) external returns (bool);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 contract Ownable {
92     address private _owner;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     constructor () {
97         _owner = msg.sender;
98         emit OwnershipTransferred(address(0), _owner);
99     }
100 
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     modifier onlyOwner() {
106         require(isOwner());
107         _;
108     }
109 
110     function isOwner() private view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     function transferOwnership(address newOwner) public onlyOwner {
120         _transferOwnership(newOwner);
121     }
122 
123     function _transferOwnership(address newOwner) internal {
124         require(newOwner != address(0));
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 
131 library SafeMath {
132 
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165 
166     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b > 0, errorMessage);
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170 
171         return c;
172     }
173 
174 }
175 
176 
177 interface IUniswapV2Factory {
178     function createPair(address tokenA, address tokenB)
179         external
180         returns (address pair);
181 }
182 
183 interface IUniswapV2Router02 {
184     function swapExactTokensForETHSupportingFeeOnTransferTokens(
185         uint256 amountIn,
186         uint256 amountOutMin,
187         address[] calldata path,
188         address to,
189         uint256 deadline
190     ) external;
191 
192     function factory() external pure returns (address);
193 
194     function WETH() external pure returns (address);
195 }
196 
197 contract TEXAS is Context, IERC20, Ownable {
198     using SafeMath for uint256;
199     
200     string private constant _name = "Texas Reserve";
201     string private constant _symbol = "TEXAS";
202     uint256 private constant _totalSupply = 100_000_000_000 * 10**18;
203     uint256 public maxWalletlimit = 2_000_000_001 * 10**18; // 1% Maxwalletlimit
204     uint256 public minSwap = 1_000_000 * 10**18; 
205     uint8 private constant _decimals = 18;
206 
207     IUniswapV2Router02 immutable uniswapV2Router;
208     address immutable uniswapV2Pair;
209     address immutable WETH;
210  
211     address payable public marketingWallet;
212     address payable public DevWallet;
213     address payable public communityFundWallet;
214     uint256 public BuyTax;
215     uint256 public SellTax;
216     uint8 private inSwapAndLiquify;
217     
218     uint256 public taxChangeInterval = 15 minutes;
219     uint256 public lastTaxChangeTimestamp;
220     uint8 public currentTaxPeriod = 0;
221     
222     bool public TradingEnabled = false;
223 
224     mapping(address => uint256) private _balance;
225     mapping(address => mapping(address => uint256)) private _allowances;
226     mapping(address => bool) private _isExcludedFromFees;
227     mapping(address => bool) private _isExcludedFromWalletLimit;
228 
229 
230     constructor() {
231         uniswapV2Router = IUniswapV2Router02( 
232             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
233         );
234         WETH = uniswapV2Router.WETH();
235 
236         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
237             address(this),
238             WETH
239         );
240 
241         //initial tax values
242         BuyTax = 6;
243         SellTax = 6;
244 
245         marketingWallet = payable(0x39C308bADb047Aaa3a2c02e9B19DA605573b6a16); //Marketing Wallet Address
246         DevWallet = payable(0xC6aa2f0FF6b8563EA418ec2558890D6027413699); // Dev Wallet Address
247         communityFundWallet = payable(0xcC653Ed86F8eB9b9cc2612ee54a56ea683d41d31); // Community Wallet Address
248         _balance[msg.sender] = _totalSupply;
249         _isExcludedFromFees[marketingWallet] = true;
250         _isExcludedFromFees[msg.sender] = true;
251         _isExcludedFromFees[address(this)] = true;
252         _isExcludedFromFees[address(uniswapV2Router)] = true;
253         _isExcludedFromWalletLimit[marketingWallet] = true;
254         _isExcludedFromWalletLimit[msg.sender] = true;
255         _isExcludedFromWalletLimit[address(this)] = true;
256         _isExcludedFromWalletLimit[address(uniswapV2Router)] = true;
257 
258         _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
259             .max;
260         _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
261         _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
262             .max;
263 
264         emit Transfer(address(0), _msgSender(), _totalSupply);
265     }
266 
267     function name() public pure returns (string memory) {
268         return _name;
269     }
270 
271     function symbol() public pure returns (string memory) {
272         return _symbol;
273     }
274 
275     function decimals() public pure returns (uint8) {
276         return _decimals;
277     }
278 
279     function totalSupply() public pure override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     function balanceOf(address account) public view override returns (uint256) {
284         return _balance[account];
285     }
286 
287     function transfer(address recipient, uint256 amount)
288         public
289         override
290         returns (bool)
291     {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295 
296     function allowance(address owner, address spender)
297         public
298         view
299         override
300         returns (uint256)
301     {
302         return _allowances[owner][spender];
303     }
304 
305     function approve(address spender, uint256 amount)
306         public
307         override
308         returns (bool)
309     {
310         _approve(_msgSender(), spender, amount);
311         return true;
312     }
313 
314     function transferFrom(
315         address sender,
316         address recipient,
317         uint256 amount
318     ) public override returns (bool) {
319         _transfer(sender, recipient, amount);
320         _approve(
321             sender,
322             _msgSender(),
323             _allowances[sender][_msgSender()] - amount
324         );
325         return true;
326     }
327 
328     function _approve(
329         address owner,
330         address spender,
331         uint256 amount
332     ) private {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335         _allowances[owner][spender] = amount;
336         emit Approval(owner, spender, amount);
337     }
338     
339     function ExcludeFromFees(address holder, bool exempt) external onlyOwner {
340         _isExcludedFromFees[holder] = exempt;
341     }
342     
343     function ChangeMinSwap(uint256 NewMinSwapAmount) external onlyOwner {
344         minSwap = NewMinSwapAmount * 10**18;
345     }
346 
347     function ChangeMarketingWalletAddress(address newAddress) external onlyOwner() {
348         marketingWallet = payable(newAddress);
349     }
350     
351     function ChangeDevWalletAddress(address newAddress) external onlyOwner() {
352         DevWallet = payable(newAddress);
353     }
354     
355     function EnableTrading() external onlyOwner {
356         TradingEnabled = true;
357         lastTaxChangeTimestamp = block.timestamp;
358     }
359 
360     function transferToAddressETH(address payable recipient, uint256 amount) private {
361         recipient.transfer(amount);
362     }
363 
364     function DisableWalletLimit() external onlyOwner {
365         maxWalletlimit = _totalSupply;
366     }
367     
368     function ExcludeFromWalletLimit(address holder, bool exempt) external onlyOwner {
369         _isExcludedFromWalletLimit[holder] = exempt;
370     }
371 
372 
373     function _transfer(
374         address from,
375         address to,
376         uint256 amount
377     ) private {
378         require(from != address(0), "ERC20: transfer from the zero address");
379         require(amount > 1e9, "Min transfer amt");
380         require(TradingEnabled || _isExcludedFromFees[from] || _isExcludedFromFees[to], "Not Enabled");
381         
382         
383         uint256 elapsedTime = block.timestamp - lastTaxChangeTimestamp;
384         
385         if (elapsedTime >= taxChangeInterval && currentTaxPeriod < 2) {
386             currentTaxPeriod++;
387                 if (currentTaxPeriod == 1) {
388                     //Initial Tax values
389                     BuyTax = 6;
390                     SellTax = 6;
391                 } else if (currentTaxPeriod == 2) {
392                     // After 15 minutes, set buyTax to 3% and sellTax to 3%
393                     BuyTax = 3;
394                     SellTax = 3;
395                 }
396                 // Update the last tax change timestamp    
397                 lastTaxChangeTimestamp = block.timestamp;
398             }
399 
400 
401 
402         uint256 _tax;
403         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
404             _tax = 0;
405         } else {
406 
407             if (inSwapAndLiquify == 1) {
408                 //No tax transfer
409                 _balance[from] -= amount;
410                 _balance[to] += amount;
411 
412                 emit Transfer(from, to, amount);
413                 return;
414             }
415 
416             if (from == uniswapV2Pair) {
417                     _tax = BuyTax;
418                 if (!_isExcludedFromWalletLimit[from] || !_isExcludedFromWalletLimit[to]) {
419                 require(balanceOf(to).add(amount) <= maxWalletlimit);
420                 }
421             } else if (to == uniswapV2Pair) {
422                 uint256 tokensToSwap = _balance[address(this)];
423                 if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
424                     inSwapAndLiquify = 1;
425                     address[] memory path = new address[](2);
426                     path[0] = address(this);
427                     path[1] = WETH;
428                     uniswapV2Router
429                         .swapExactTokensForETHSupportingFeeOnTransferTokens(
430                             tokensToSwap,
431                             0,
432                             path,
433                             address(this),
434                             block.timestamp
435                         );
436                     inSwapAndLiquify = 0;
437                 }
438                     _tax = SellTax;
439 
440             } else {
441                 _tax = 0;
442             }
443         }
444         
445 
446         //Is there tax for sender|receiver?
447         if (_tax != 0) {
448             //Tax transfer
449             uint256 taxTokens = (amount * _tax) / 100;
450             uint256 transferAmount = amount - taxTokens;
451 
452             _balance[from] -= amount;
453             _balance[to] += transferAmount;
454             _balance[address(this)] += taxTokens;
455             emit Transfer(from, address(this), taxTokens);
456             emit Transfer(from, to, transferAmount);
457         } else {
458             //No tax transfer
459             _balance[from] -= amount;
460             _balance[to] += amount;
461 
462             emit Transfer(from, to, amount);
463         }
464 
465     uint256 amountReceived = address(this).balance;
466 
467     uint256 amountETHMarketing = amountReceived.mul(33).div(100); // 33% to marketing wallet
468     uint256 amountETHTeam = amountReceived.mul(34).div(100); // 34% to Community wallet
469     uint256 amountETHDev = amountReceived.mul(33).div(100); // 33% to dev wallet
470     
471     
472     if (amountETHMarketing > 0)
473     transferToAddressETH(marketingWallet, amountETHMarketing);
474     
475     if (amountETHTeam > 0)
476     transferToAddressETH(communityFundWallet, amountETHTeam);
477     
478     if (amountETHDev > 0)
479     transferToAddressETH(DevWallet, amountETHDev);
480     }
481 
482     receive() external payable {}
483 }