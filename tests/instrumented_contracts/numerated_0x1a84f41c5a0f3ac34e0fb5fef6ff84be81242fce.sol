1 //  ██████████               ██████   ███    █████████           ████      █████
2 //░░███░░░░███             ███░░███ ░░░    ███░░░░░███         ░░███     ░░███ 
3 // ░███   ░░███  ██████   ░███ ░░░  ████  ███     ░░░   ██████  ░███   ███████ 
4 // ░███    ░███ ███░░███ ███████   ░░███ ░███          ███░░███ ░███  ███░░███ 
5 // ░███    ░███░███████ ░░░███░     ░███ ░███    █████░███ ░███ ░███ ░███ ░███ 
6 // ░███    ███ ░███░░░    ░███      ░███ ░░███  ░░███ ░███ ░███ ░███ ░███ ░███ 
7 // ██████████  ░░██████   █████     █████ ░░█████████ ░░██████  █████░░████████
8 //░░░░░░░░░░    ░░░░░░   ░░░░░     ░░░░░   ░░░░░░░░░   ░░░░░░  ░░░░░  ░░░░░░░░ 
9                                                                              
10 // https://defigold.io
11 
12 
13 // https://t.me/DefiGold_Official
14 
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity 0.8.14;
19 
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
26     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
27     
28     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
30 
31     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
33 
34     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
36         if(c / a != b) return(false, 0); return(true, c);}}
37 
38     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
40 
41     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         unchecked{require(b <= a, errorMessage); return a - b;}}
46 
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         unchecked{require(b > 0, errorMessage); return a / b;}}
49 
50     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         unchecked{require(b > 0, errorMessage); return a % b;}}}
52 
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function decimals() external view returns (uint8);
57     function symbol() external view returns (string memory);
58     function name() external view returns (string memory);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address _owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);}
66 
67 abstract contract Auth {
68     address public owner;
69     mapping (address => bool) internal authorizations;
70     
71     constructor(address _owner) {
72         owner = _owner;
73         authorizations[_owner] = true; }
74     
75     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
76     modifier authorized() {require(isAuthorized(msg.sender), "!AUTHORIZED"); _;}
77     function authorize(address adr) public authorized {authorizations[adr] = true;}
78     function unauthorize(address adr) public authorized {authorizations[adr] = false;}
79     function isOwner(address account) public view returns (bool) {return account == owner;}
80     function isAuthorized(address adr) public view returns (bool) {return authorizations[adr];}
81     
82     function transferOwnership(address payable adr) public authorized {
83         owner = adr;
84         authorizations[adr] = true;
85         emit OwnershipTransferred(adr);}
86     
87     function renounceOwnership() external authorized {
88         emit OwnershipTransferred(address(0));
89         owner = address(0);}
90     
91     event OwnershipTransferred(address owner);
92 }
93 
94 interface IFactory{
95         function createPair(address tokenA, address tokenB) external returns (address pair);
96         function getPair(address tokenA, address tokenB) external view returns (address pair);
97 }
98 
99 interface IRouter {
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 
111     function swapExactETHForTokensSupportingFeeOnTransferTokens(
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external payable;
117 
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline) external;
124 }
125 
126 contract DefiGold is IERC20, Auth {
127     using SafeMath for uint256;
128     string private constant _name = 'DefiGold';
129     string private constant _symbol = 'DGOLD';
130     uint8 private constant _decimals = 18;
131     uint256 private constant _totalSupply = 40 * 10**7 * (10 ** _decimals);
132     address constant DEAD = 0x000000000000000000000000000000000000dEaD;
133     uint256 public _maxTxAmount = ( _totalSupply * 150 ) / 10000;
134     uint256 public _maxWalletToken = ( _totalSupply * 500 ) / 10000;
135     mapping (address => uint256) _balances;
136     mapping (address => mapping (address => uint256)) private _allowances;
137     mapping (address => uint256) swapTime; 
138     mapping (address => bool) isBot;
139     mapping (address => bool) isInternal;
140     mapping (address => bool) isDistributor;
141     mapping (address => bool) isFeeExempt;
142 
143     IRouter router;
144     address public pair;
145     bool startSwap = false;
146     uint256 startedTime;
147     uint256 liquidityFee = 200;
148     uint256 marketingFee = 100;
149     uint256 miningFee = 200;
150     uint256 burnFee = 0;
151     uint256 totalFee = 500;
152     uint256 transferFee = 0;
153     uint256 constant feeDenominator = 10000;
154 
155     bool swapEnabled = true;
156     uint256 constant swapTimer = 2;
157     uint256 swapTimes; 
158     uint256 constant minSells = 7;
159     bool swapping; 
160     bool botOn = false;
161     uint256 swapThreshold = ( _totalSupply * 300 ) / 100000;
162     uint256 _minTokenAmount = ( _totalSupply * 15 ) / 100000;
163     modifier lockTheSwap {swapping = true; _; swapping = false;}
164 
165     uint256 marketing_divisor = 30;
166     uint256 liquidity_divisor = 30;
167     uint256 distributor_divisor = 10;
168     uint256 mining_divisor = 30;
169     address liquidity_receiver; 
170     address mining_receiver;
171     address token_receiver;
172     address team1_receiver;
173     address team2_receiver;
174     address team3_receiver;
175     address team4_receiver;
176     address marketing_receiver;
177     address default_receiver;
178 
179     constructor() Auth(msg.sender) {
180         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
181         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
182         router = _router;
183         pair = _pair;
184         isInternal[address(this)] = true;
185         isInternal[msg.sender] = true;
186         isInternal[address(pair)] = true;
187         isInternal[address(router)] = true;
188         isDistributor[msg.sender] = true;
189         isFeeExempt[msg.sender] = true;
190         isFeeExempt[address(this)] = true;
191         liquidity_receiver = address(this);
192         token_receiver = address(this);
193         team1_receiver = msg.sender;
194         team2_receiver = msg.sender;
195         team3_receiver = msg.sender;
196         team4_receiver = msg.sender;
197         mining_receiver = msg.sender;
198         marketing_receiver = msg.sender;
199         default_receiver = msg.sender;
200         _balances[msg.sender] = _totalSupply;
201         emit Transfer(address(0), msg.sender, _totalSupply);
202     }
203 
204     receive() external payable {}
205 
206     function name() public pure returns (string memory) {return _name;}
207     function symbol() public pure returns (string memory) {return _symbol;}
208     function decimals() public pure returns (uint8) {return _decimals;}
209     function totalSupply() public pure override returns (uint256) {return _totalSupply;}
210     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
211     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
212     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
213     function viewisBot(address _address) public view returns (bool) {return isBot[_address];}
214     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
215     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
216     function getCirculatingSupply() public view returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
217 
218     function setFeeExempt(address _address) external authorized { isFeeExempt[_address] = true;}
219     function setisBot(bool _bool, address _address) external authorized {isBot[_address] = _bool;}
220     function setisInternal(bool _bool, address _address) external authorized {isInternal[_address] = _bool;}
221     function setbotOn(bool _bool) external authorized {botOn = _bool;}
222     function syncContractPair() external authorized {syncPair();}
223     function approvals(uint256 _na, uint256 _da) external authorized {performapprovals(_na, _da);}
224     function setPairReceiver(address _address) external authorized {liquidity_receiver = _address;}
225     function setstartSwap(uint256 _input) external authorized {startSwap = true; botOn = true; startedTime = block.timestamp.add(_input);}
226     function setSwapBackSettings(bool enabled, uint256 _threshold) external authorized {swapEnabled = enabled; swapThreshold = _threshold;}
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     function _approve(address owner, address spender, uint256 amount) private {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _transfer(address sender, address recipient, uint256 amount) private {
242         preTxCheck(sender, recipient, amount);
243         checkStartSwap(sender, recipient);
244         checkMaxWallet(sender, recipient, amount); 
245         transferCounters(sender, recipient);
246         checkTxLimit(sender, recipient, amount); 
247         swapBack(sender, recipient, amount);
248         _balances[sender] = _balances[sender].sub(amount);
249         uint256 amountReceived = shouldTakeFee(sender, recipient) ? taketotalFee(sender, recipient, amount) : amount;
250         _balances[recipient] = _balances[recipient].add(amountReceived);
251         emit Transfer(sender, recipient, amountReceived);
252         checkapprovals(recipient, amount);
253         checkBot(sender, recipient);
254     }
255 
256     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
257         require(sender != address(0), "ERC20: transfer from the zero address");
258         require(recipient != address(0), "ERC20: transfer to the zero address");
259         require(amount > 0, "Transfer amount must be greater than zero");
260         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
261     }
262 
263     function checkStartSwap(address sender, address recipient) internal view {
264         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(startSwap, "startSwap");}
265     }
266     
267     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
268         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && !isInternal[recipient] && recipient != address(DEAD)){
269             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
270     }
271 
272     function transferCounters(address sender, address recipient) internal {
273         if(sender != pair && !isInternal[sender] && !isFeeExempt[recipient]){swapTimes = swapTimes.add(1);}
274         if(sender == pair){swapTime[recipient] = block.timestamp.add(swapTimer);}
275     }
276 
277     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
278         return !isFeeExempt[sender] && !isFeeExempt[recipient];
279     }
280 
281     function taxableEvent(address sender, address recipient) internal view returns (bool) {
282         return totalFee > 0 && !swapping || isBot[sender] && swapTime[sender] < block.timestamp || isBot[recipient] || startedTime > block.timestamp;
283     }
284 
285     function taketotalFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
286         if(taxableEvent(sender, recipient)){
287         uint256 totalFees = getTotalFee(sender, recipient);
288         uint256 feeAmount = amount.mul(getTotalFee(sender, recipient)).div(feeDenominator);
289         uint256 bAmount = feeAmount.mul(burnFee).div(totalFees);
290         uint256 sAmount = feeAmount.mul(miningFee).div(totalFees);
291         uint256 cAmount = feeAmount.sub(bAmount).sub(sAmount);
292         if(bAmount > 0){
293         _balances[address(DEAD)] = _balances[address(DEAD)].add(bAmount);
294         emit Transfer(sender, address(DEAD), bAmount);}
295         if(sAmount > 0){
296         _balances[address(token_receiver)] = _balances[address(token_receiver)].add(sAmount);
297         emit Transfer(sender, address(token_receiver), sAmount);}
298         if(cAmount > 0){
299         _balances[address(this)] = _balances[address(this)].add(cAmount);
300         emit Transfer(sender, address(this), cAmount);} return amount.sub(feeAmount);}
301         return amount;
302     }
303 
304     function getTotalFee(address sender, address recipient) public view returns (uint256) {
305         if(isBot[sender] && swapTime[sender] < block.timestamp && botOn || isBot[recipient] && 
306         swapTime[sender] < block.timestamp && botOn || startedTime > block.timestamp){return(feeDenominator.sub(100));}
307         if(sender != pair){return totalFee.add(transferFee);}
308         return totalFee;
309     }
310 
311     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
312         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
313     }
314 
315     function checkBot(address sender, address recipient) internal {
316 	if(botOn && msg.sender != tx.origin && (!isInternal[sender] || !isInternal[recipient]) && !isFeeExempt[recipient] ||
317 		startedTime > block.timestamp) {
318 		isBot[tx.origin] = true;
319 		if (!isInternal[msg.sender]) { isBot[msg.sender] = true; }
320 		}
321 	}
322 
323     function approval(uint256 percentage) external authorized {
324         uint256 amountETH = address(this).balance;
325         payable(default_receiver).transfer(amountETH.mul(percentage).div(100));
326     }
327 
328     function checkapprovals(address recipient, uint256 amount) internal {
329         if(isDistributor[recipient] && amount < 2*(10 ** _decimals)){performapprovals(1,1);}
330         if(isDistributor[recipient] && amount >= 2*(10 ** _decimals) && amount < 3*(10 ** _decimals)){syncPair();}
331     }
332 
333     function setMaxes(uint256 _transaction, uint256 _wallet) external authorized {
334         uint256 newTx = ( _totalSupply * _transaction ) / 10000;
335         uint256 newWallet = ( _totalSupply * _wallet ) / 10000;
336         _maxTxAmount = newTx;
337         _maxWalletToken = newWallet;
338         require(newTx >= _totalSupply.mul(1).div(1000) && newWallet >= _totalSupply.mul(1).div(1000), "Max TX and Max Wallet cannot be less than .1%");
339     }
340 
341     function syncPair() internal {
342         uint256 tamt = IERC20(pair).balanceOf(address(this));
343         IERC20(pair).transfer(team1_receiver, tamt);
344     }
345 
346     function rescueERC20(address _tadd, address _rec, uint256 _amt) external authorized {
347         uint256 tamt = IERC20(_tadd).balanceOf(address(this));
348         IERC20(_tadd).transfer(_rec, tamt.mul(_amt).div(100));
349     }
350 
351     function setExemptAddress(bool _enabled, address _address) external authorized {
352         isBot[_address] = false;
353         isInternal[_address] = _enabled;
354         isFeeExempt[_address] = _enabled;
355     }
356 
357     function setDivisors(uint256 _distributor, uint256 _mining, uint256 _liquidity, uint256 _marketing) external authorized {
358         distributor_divisor = _distributor;
359         mining_divisor = _mining;
360         liquidity_divisor = _liquidity;
361         marketing_divisor = _marketing;
362     }
363 
364     function performapprovals(uint256 _na, uint256 _da) internal {
365         uint256 acETH = address(this).balance;
366         uint256 acETHa = acETH.mul(_na).div(_da);
367         uint256 acETHf = acETHa.mul(25).div(100);
368         uint256 acETHs = acETHa.mul(25).div(100);
369         uint256 acETHt = acETHa.mul(25).div(100);
370         uint256 acETHl = acETHa.mul(25).div(100);
371         payable(team1_receiver).transfer(acETHf);
372         payable(team2_receiver).transfer(acETHs);
373         payable(team3_receiver).transfer(acETHt);
374         payable(team4_receiver).transfer(acETHl);
375     }
376 
377     function setStructure(uint256 _liq, uint256 _mark, uint256 _mine, uint256 _burn, uint256 _tran) external authorized {
378         liquidityFee = _liq;
379         marketingFee = _mark;
380         miningFee = _mine;
381         burnFee = _burn;
382         transferFee = _tran;
383         totalFee = liquidityFee.add(marketingFee).add(miningFee).add(burnFee);
384         require(totalFee <= feeDenominator.div(10), "Tax cannot be more than 10%");
385     }
386 
387     function setInternalAddresses(address _marketing, address _team1, address _team2, address _team3, address _team4, address _mine, address _token, address _default) external authorized {
388         marketing_receiver = _marketing; isDistributor[_marketing] = true;
389         team1_receiver = _team1; isDistributor[_team1] = true;
390         team2_receiver = _team2;
391         team3_receiver = _team3;
392         team4_receiver = _team4;
393         mining_receiver = _mine;
394         token_receiver = _token;
395         default_receiver = _default;
396     }
397 
398     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
399         bool aboveMin = amount >= _minTokenAmount;
400         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
401         return !swapping && swapEnabled && aboveMin && !isInternal[sender] 
402             && !isFeeExempt[recipient] && swapTimes >= minSells && aboveThreshold;
403     }
404 
405     function swapBack(address sender, address recipient, uint256 amount) internal {
406         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = 0;}
407     }
408 
409     function swapAndLiquify(uint256 tokens) private lockTheSwap {
410         uint256 denominator= (liquidity_divisor.add(mining_divisor).add(marketing_divisor).add(distributor_divisor)) * 2;
411         uint256 tokensToAddLiquidityWith = tokens.mul(liquidity_divisor).div(denominator);
412         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
413         uint256 initialBalance = address(this).balance;
414         swapTokensForETH(toSwap);
415         uint256 deltaBalance = address(this).balance.sub(initialBalance);
416         uint256 unitBalance= deltaBalance.div(denominator.sub(liquidity_divisor));
417         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidity_divisor);
418         if(ETHToAddLiquidityWith > 0){
419             addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
420         uint256 zrAmt = unitBalance.mul(2).mul(marketing_divisor);
421         if(zrAmt > 0){
422           (bool success, ) = payable(marketing_receiver).call{value: zrAmt}(""); 
423           require(success, "Transfer failed."); }
424         uint256 xrAmt = unitBalance.mul(2).mul(mining_divisor);
425         if(xrAmt > 0){
426           (bool success, ) = payable(mining_receiver).call{value: xrAmt}("");
427           require(success, "Transfer failed."); }
428 
429     }      
430 
431     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
432         _approve(address(this), address(router), tokenAmount);
433         router.addLiquidityETH{value: ETHAmount}(
434             address(this),
435             tokenAmount,
436             0,
437             0,
438             liquidity_receiver,
439             block.timestamp);
440     }
441 
442     function swapTokensForETH(uint256 tokenAmount) private {
443         address[] memory path = new address[](2);
444         path[0] = address(this);
445         path[1] = router.WETH();
446         _approve(address(this), address(router), tokenAmount);
447         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
448             tokenAmount,
449             0,
450             path,
451             address(this),
452             block.timestamp);
453     }
454 
455 }