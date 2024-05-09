1 /**
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠄⠒⠂⢄⠀⠀⠀
4 ⠀⠀⠀⠠⣐⠞⡆⢇⠷⢥⣓⡀⠀⠀⠀⡠⣊⣵⠟⣿⣇⣦⡡⠀⠀
5 ⠀⠀⡢⠓⡓⠗⢇⣿⡯⣿⣿⠗⣆⠀⣰⡯⡭⣻⡫⡗⠏⡏⣏⢕⠀
6 ⠀⢐⡗⡛⡬⢻⡋⡈⡃⡭⠿⡇⡑⣙⣗⡟⡽⢟⣇⡇⠃⡿⡯⣗⠀
7 ⠀⢐⣇⠞⡗⠭⠅⡂⣕⣻⣛⡯⡃⡂⣿⡳⡫⠁⡺⢁⠏⡓⣟⡃⠀
8 ⠀⠀⡇⢭⡟⠛⡊⡦⣾⡛⡓⠃⠄⡡⢿⡗⣿⡥⢯⠋⡴⢏⡗⠀⠀
9 ⠀⠀⠊⢛⣍⢏⢃⡏⡍⡊⡇⠎⠊⡃⠃⠿⣿⡿⣟⣩⡯⡗⠀⠀⠀
10 ⠀⠀⠈⠂⠓⠒⠂⢚⡅⠁⠀⠠⠀⠀⠀⠌⠈⠟⠙⠃⠊⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠁⠀⠀⠀⡃⠀⠅⠀⠀⠈⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⡅⠀⠀⠀⠀⡔⠂⠁⠠⠃⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠧⠀⠀⠀⡊⠀⠀⠀⢘⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⡇⠁⠒⠊⠀⠀⠀⠀⠨⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⡀⣀⣀⠀⠅⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⡊⠀⠀⠀⡃⠃⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⡇⣇⡐⠀⠀⠀⠀⢃⡃⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠅⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⡇⢀⡀⣀⡀⡀⠀⣀⣧⣀⡀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⢠⢤⡞⠛⠙⢉⠉⠻⡟⣿⠋⠉⠛⣯⠳⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⡃⡏⠃⠀⠁⠀⠄⠀⠀⡀⠀⢁⠀⠈⣿⡀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠑⡇⠀⢁⠀⠀⢀⠁⠀⠀⠄⠀⠂⠀⢟⠇⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠫⣇⠀⠀⡀⠀⠀⡎⠀⠀⠂⠈⢰⣏⠇⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠁⠃⣆⠀⡀⠈⡇⠀⠁⠈⣐⡏⠇⠀⠀⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣦⣀⡇⡀⣤⠞⠋⠁⠀⠀⠀⠀⠀⠀
26 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀
27 
28 https://t.me/mishaentry
29 
30 https://Misha.lol
31 
32 https://twitter.com/mishaethereum
33 
34 */
35 
36 // SPDX-License-Identifier: MIT
37 
38 pragma solidity 0.8.19;
39 
40 
41 library SafeMath {
42 
43     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             uint256 c = a + b;
46             if (c < a) return (false, 0);
47             return (true, c);
48         }
49     }
50 
51     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b > a) return (false, 0);
54             return (true, a - b);
55         }
56     }
57 
58     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (a == 0) return (true, 0);
61             uint256 c = a * b;
62             if (c / a != b) return (false, 0);
63             return (true, c);
64         }
65     }
66 
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a % b);
78         }
79     }
80 
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a + b;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a - b;
87     }
88 
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a * b;
91     }
92 
93     function div(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a / b;
95     }
96 
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a % b;
99     }
100 
101     function sub(
102         uint256 a,
103         uint256 b,
104         string memory errorMessage
105     ) internal pure returns (uint256) {
106         unchecked {
107             require(b <= a, errorMessage);
108             return a - b;
109         }
110     }
111 
112     function div(
113         uint256 a,
114         uint256 b,
115         string memory errorMessage
116     ) internal pure returns (uint256) {
117         unchecked {
118             require(b > 0, errorMessage);
119             return a / b;
120         }
121     }
122 
123     function mod(
124         uint256 a,
125         uint256 b,
126         string memory errorMessage
127     ) internal pure returns (uint256) {
128         unchecked {
129             require(b > 0, errorMessage);
130             return a % b;
131         }
132     }
133 }
134 
135 interface IERC20 {
136     function decimals() external view returns (uint8);
137     function symbol() external view returns (string memory);
138     function name() external view returns (string memory);
139     function mishaOwner() external view returns (address);
140     function totalSupply() external view returns (uint256);
141     function balanceOf(address account) external view returns (uint256);
142     function transfer(address recipient, uint256 amount) external returns (bool);
143     function allowance(address _owner, address spender) external view returns (uint256);
144     function approve(address spender, uint256 amount) external returns (bool);
145     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
146     event Transfer(address indexed from, address indexed to, uint256 value);
147     event Approval(address indexed owner, address indexed spender, uint256 value);}
148 
149 abstract contract Ownable {
150     address internal owner;
151     constructor(address _owner) {owner = _owner;}
152     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
153     function isOwner(address account) public view returns (bool) {return account == owner;}
154     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
155     event OwnershipTransferred(address owner);
156 }
157 
158 interface IFactory{
159         function createPair(address tokenA, address tokenB) external returns (address pair);
160         function getPair(address tokenA, address tokenB) external view returns (address pair);
161 }
162 
163 interface IRouter {
164     function factory() external pure returns (address);
165     function WETH() external pure returns (address);
166     function addLiquidityETH(
167         address token,
168         uint amountTokenDesired,
169         uint amountTokenMin,
170         uint amountETHMin,
171         address to,
172         uint deadline
173     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
174 
175     function swapExactTokensForETHSupportingFeeOnTransferTokens(
176         uint amountIn,
177         uint amountOutMin,
178         address[] calldata path,
179         address to,
180         uint deadline) external;
181 }
182 
183 contract MISHA is IERC20, Ownable {
184     using SafeMath for uint256;
185     string private constant _name = unicode"MISHA";
186     string private constant _symbol = unicode"MISHA";
187     uint8 private constant _decimals = 9;
188     uint256 private _totalSupply = 1111111111111 * (10 ** _decimals);
189     mapping (address => uint256) _balances;
190     mapping (address => mapping (address => uint256)) private _allowances;
191     mapping (address => bool) public isFeeExempt;
192     mapping (address => bool) private isBot;
193     IRouter router;
194     address public pair;
195     bool private tradingAllowed = false;
196     bool private swapEnabled = true;
197     uint256 private swapTimes;
198     bool private swapping;
199     uint256 swapAmount = 1;
200     uint256 private swapThreshold = ( _totalSupply * 1000 ) / 100000;
201     uint256 private minTokenAmount = ( _totalSupply * 10 ) / 100000;
202     modifier lockTheSwap {swapping = true; _; swapping = false;}
203     uint256 private liquidityFee = 0;
204     uint256 private marketingFee = 1250;
205     uint256 private developmentFee = 1250;
206     uint256 private burnFee = 0;
207     uint256 private totalFee = 2500;
208     uint256 private sellFee = 2500;
209     uint256 private transferFee = 2500;
210     uint256 private denominator = 10000;
211     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
212     address internal development_receiver = 0x446a4F6fb58310d4C2799c9d73F3092C11772d25; 
213     address internal marketing_receiver = 0x138747be82fc0650306189c0FBDe7A6e1A62AE13;
214     address internal liquidity_receiver = 0x446a4F6fb58310d4C2799c9d73F3092C11772d25;
215     uint256 public _maxTxAmount = ( _totalSupply * 25 ) / 10000;
216     uint256 public _maxSellAmount = ( _totalSupply * 25 ) / 10000;
217     uint256 public _maxWalletToken = ( _totalSupply * 50 ) / 10000;
218 
219     constructor() Ownable(msg.sender) {
220         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
221         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
222         router = _router; pair = _pair;
223         isFeeExempt[address(this)] = true;
224         isFeeExempt[liquidity_receiver] = true;
225         isFeeExempt[marketing_receiver] = true;
226         isFeeExempt[development_receiver] = true;
227         isFeeExempt[msg.sender] = true;
228         _balances[msg.sender] = _totalSupply;
229         emit Transfer(address(0), msg.sender, _totalSupply);
230     }
231 
232     receive() external payable {}
233     function name() public pure returns (string memory) {return _name;}
234     function symbol() public pure returns (string memory) {return _symbol;}
235     function decimals() public pure returns (uint8) {return _decimals;}
236     function startTrading() external onlyOwner {tradingAllowed = true;}
237     function mishaOwner() external view override returns (address) { return owner; }
238     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
239     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
240     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
241     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
242     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
243     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
244 
245     function shouldContractSwap(address sender, address recipient, uint256 amount) internal view returns (bool) {
246         bool aboveMin = amount >= minTokenAmount;
247         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
248         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= swapAmount && aboveThreshold;
249     }
250 
251     function setContractSwapSettings(uint256 _swapAmount, uint256 _swapThreshold, uint256 _minTokenAmount) external onlyOwner {
252         swapAmount = _swapAmount; swapThreshold = _totalSupply.mul(_swapThreshold).div(uint256(100000)); 
253         minTokenAmount = _totalSupply.mul(_minTokenAmount).div(uint256(100000));
254     }
255 
256     function setMishaTransactionRequirements(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
257         liquidityFee = _liquidity; marketingFee = _marketing; burnFee = _burn; developmentFee = _development; totalFee = _total; sellFee = _sell; transferFee = _trans;
258         require(totalFee <= denominator.div(1) && sellFee <= denominator.div(1) && transferFee <= denominator.div(1), "totalFee and sellFee cannot be more than 20%");
259     }
260 
261     function setTransactionLimits(uint256 _buy, uint256 _sell, uint256 _wallet) external onlyOwner {
262         uint256 newTx = _totalSupply.mul(_buy).div(10000); uint256 newTransfer = _totalSupply.mul(_sell).div(10000); uint256 newWallet = _totalSupply.mul(_wallet).div(10000);
263         _maxTxAmount = newTx; _maxSellAmount = newTransfer; _maxWalletToken = newWallet;
264         uint256 limit = totalSupply().mul(5).div(1000);
265         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
266     }
267 
268     function setInternalAddresses(address _marketing, address _liquidity, address _development) external onlyOwner {
269         marketing_receiver = _marketing; liquidity_receiver = _liquidity; development_receiver = _development;
270         isFeeExempt[_marketing] = true; isFeeExempt[_liquidity] = true; isFeeExempt[_development] = true;
271     }
272 
273     function setisBot(address[] calldata addresses, bool _enabled) external onlyOwner {
274         for(uint i=0; i < addresses.length; i++){
275         isBot[addresses[i]] = _enabled; }
276     }
277 
278     function manualSwap() external onlyOwner {
279         uint256 amount = balanceOf(address(this));
280         if(amount > swapThreshold){amount = swapThreshold;}
281         swapAndLiquify(amount);
282     }
283 
284     function rescueERC20(address _address, uint256 percent) external onlyOwner {
285         uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
286         IERC20(_address).transfer(development_receiver, _amount);
287     }
288 
289     function swapAndLiquify(uint256 tokens) private lockTheSwap {
290         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
291         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
292         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
293         uint256 initialBalance = address(this).balance;
294         swapTokensForETH(toSwap);
295         uint256 deltaBalance = address(this).balance.sub(initialBalance);
296         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
297         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
298         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
299         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
300         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
301         uint256 contractBalance = address(this).balance;
302         if(contractBalance > uint256(0)){payable(development_receiver).transfer(contractBalance);}
303     }
304 
305     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
306         _approve(address(this), address(router), tokenAmount);
307         router.addLiquidityETH{value: ETHAmount}(
308             address(this),
309             tokenAmount,
310             0,
311             0,
312             liquidity_receiver,
313             block.timestamp);
314     }
315 
316     function swapTokensForETH(uint256 tokenAmount) private {
317         address[] memory path = new address[](2);
318         path[0] = address(this);
319         path[1] = router.WETH();
320         _approve(address(this), address(router), tokenAmount);
321         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
322             tokenAmount,
323             0,
324             path,
325             address(this),
326             block.timestamp);
327     }
328 
329     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
330         return !isFeeExempt[sender] && !isFeeExempt[recipient];
331     }
332 
333     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
334         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
335         if(recipient == pair){return sellFee;}
336         if(sender == pair){return totalFee;}
337         return transferFee;
338     }
339 
340     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
341         if(getTotalFee(sender, recipient) > 0){
342         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
343         _balances[address(this)] = _balances[address(this)].add(feeAmount);
344         emit Transfer(sender, address(this), feeAmount);
345         if(burnFee > uint256(0) && getTotalFee(sender, recipient) > burnFee){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
346         return amount.sub(feeAmount);} return amount;
347     }
348 
349     function _transfer(address sender, address recipient, uint256 amount) private {
350         require(sender != address(0), "ERC20: transfer from the zero address");
351         require(recipient != address(0), "ERC20: transfer to the zero address");
352         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
353         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
354         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
355         require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
356         if(sender != pair){require(amount <= _maxSellAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
357         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded"); 
358         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
359         if(shouldContractSwap(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
360         _balances[sender] = _balances[sender].sub(amount);
361         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
362         _balances[recipient] = _balances[recipient].add(amountReceived);
363         emit Transfer(sender, recipient, amountReceived);
364     }
365 
366     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
367         _transfer(sender, recipient, amount);
368         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
369         return true;
370     }
371 
372     function _approve(address owner, address spender, uint256 amount) private {
373         require(owner != address(0), "ERC20: approve from the zero address");
374         require(spender != address(0), "ERC20: approve to the zero address");
375         _allowances[owner][spender] = amount;
376         emit Approval(owner, spender, amount);
377     }
378 }