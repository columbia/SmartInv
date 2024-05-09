1 /**
2  * @author The Wukong Project Team
3  * @title Wukoin - The erc20 token part of the Wukong Project that starts the crypto revolution
4  * 
5  * Born to be part of a big project,
6  * the Wukoin Token gives holders access to a multitude
7  * of present and future services of the Wukong Project's ecosystem.
8  *
9  * Apart from its utilities, the token comes also with some incredible tokenomics features
10  * built right in the source code of its smart contract.
11  * To help others, the project and yourself at the same time.
12  *
13  * **Share**
14  * Part of the fees collected by the contract is used for charity initiatives
15  * in a collective effort to make the world a better place and bring happiness
16  * to its inhabitants.
17  *
18  * **Expand**
19  * Another share of the fees goes to the marketing wallet to fund marketing campaigns,
20  * with the purpose of raising people's awareness of the project.
21  *
22  * **Hold**
23  * Even eligible holders benefit from the fees collected in the form of ETH reflections
24  * and can claim them on the platform without the need to sell their own tokens: wukoin.wukongproject.com
25  *
26  * **Community**
27  * It's all about YOU, from the beginning. The Wukoin Community fuels, funds and sustain
28  * the development, expansion and charitable initiatives of the project by trading, using,
29  * sharing Wukoin Tokens, discussing, helping each other and planning initiatives
30  * of many kinds.
31  *
32  * Anti-bot
33  * Our contract makes use of a powerful anti-bot system to promote a fair environment.
34  * If you use bots/contracts to trade on Wukoin you are hereby declaring your investment in the project a DONATION.
35  *
36  * Website: wukongproject.com
37  * Telegram: t.me/WukongProject
38  *
39  *
40  *                      █▀▀▀▀▀█ ▄▀ ▄██▀█  █▀▀▀▀▀█
41  *                      █ ███ █ ▀███▀ ▄▀  █ ███ █
42  *                      █ ▀▀▀ █ █▄ ▄ █▀█▀ █ ▀▀▀ █
43  *                      ▀▀▀▀▀▀▀ █▄▀ █ █ █ ▀▀▀▀▀▀▀
44  *                      ██▄█▄▄▀█  █▄ █▀ ▄ █▀▀ ▀▀▄
45  *                      █  ██▀▀▀█▀▀  ▄▀▄ █▀ ▄  ▀▀
46  *                      ▀ █▀ ▄▀▄▀ ▄▄█▀▄  ███ █▄▀█
47  *                      ▀▄▀▀█ ▀██▀▄ █▄▀ ▄▀▄▀█ ▀▄▀
48  *                      ▀▀▀   ▀ ▄██▀▀ █▄█▀▀▀██▀ ▄
49  *                      █▀▀▀▀▀█ ▀ ▄▄▄▀ ▀█ ▀ ██▄▀▀
50  *                      █ ███ █ ▄▄█ ██▀▄█▀▀███▄▀ 
51  *                      █ ▀▀▀ █ ▄▄▀▄▄▄▀██▄▄▀▀▄▀ ▀
52  *                      ▀▀▀▀▀▀▀ ▀  ▀▀▀ ▀▀▀ ▀   ▀▀
53  *
54  *
55  * Nullus ad Unum
56  * 01100110 01111100 01111001
57  * 20220205
58  */
59 
60 // SPDX-License-Identifier: MIT
61 
62 pragma solidity ^0.8.7;
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 }
68 interface IERC20 {
69     function totalSupply() external view returns (uint256);
70     function balanceOf(address account) external view returns (uint256);
71     function transfer(address recipient, uint256 amount) external returns (bool);
72     function allowance(address owner, address spender) external view returns (uint256);
73     function approve(address spender, uint256 amount) external returns (bool);
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 library SafeMath {
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82         return c;
83     }
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90         return c;
91     }
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 }
109 
110 /**
111  * Allows for contract ownership along with multi-address authorization
112  */
113 abstract contract Ownable {
114     address internal owner;
115 
116     constructor(address _owner) {
117         owner = _owner;
118         emit OwnershipTransferred(owner);
119     }
120 
121     /**
122      * Function modifier to require caller to be contract deployer
123      */
124     modifier onlyOwner() {
125         require(isOwner(msg.sender), "Ownable: caller is not the owner"); _;
126     }
127 
128     /**
129      * Check if address is owner
130      */
131     function isOwner(address account) public view returns (bool) {
132         return account == owner;
133     }
134 
135     /**
136      * Transfer ownership to new address. Caller must be deployer. Leaves old deployer authorized
137      */
138     function transferOwnership(address payable addr) public onlyOwner {
139         owner = addr;
140         emit OwnershipTransferred(owner);
141     }
142 
143     event OwnershipTransferred(address owner);
144 }
145 
146 interface IDEXFactory {
147     function createPair(address tokenA, address tokenB) external returns (address pair);
148 }
149 
150 interface IDEXRouter {
151     function factory() external pure returns (address);
152     function WETH() external pure returns (address);
153 
154     function addLiquidity(
155         address tokenA,
156         address tokenB,
157         uint amountADesired,
158         uint amountBDesired,
159         uint amountAMin,
160         uint amountBMin,
161         address to,
162         uint deadline
163     ) external returns (uint amountA, uint amountB, uint liquidity);
164 
165     function addLiquidityETH(
166         address token,
167         uint amountTokenDesired,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline
172     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
173 
174     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
175         uint amountIn,
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external;
181 
182     function swapExactETHForTokensSupportingFeeOnTransferTokens(
183         uint amountOutMin,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external payable;
188 
189     function swapExactTokensForETHSupportingFeeOnTransferTokens(
190         uint amountIn,
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external;
196 }
197 
198 interface IReflector {
199     function setShare(address shareholder, uint256 amount) external;
200     function deposit() external payable;
201     function claimReflection(address shareholder) external;
202 }
203 
204 contract Reflector is IReflector {
205     using SafeMath for uint256;
206 
207     address private _token;
208     address private _owner;
209 
210     struct Share {
211         uint256 amount;
212         uint256 totalExcluded;
213         uint256 totalRealised;
214     }
215 
216     address[] private shareholders;
217     mapping (address => uint256) private shareholderIndexes;
218 
219     mapping (address => Share) public shares;
220 
221     uint256 public totalShares;
222     uint256 public totalReflections;
223     uint256 public totalDistributed;
224     uint256 public reflectionsPerShare;
225     uint256 private reflectionsPerShareAccuracyFactor = 10 ** 36;
226 
227     modifier onlyToken() {
228         require(msg.sender == _token); _;
229     }
230     
231     modifier onlyOwner() {
232         require(msg.sender == _owner); _;
233     }
234 
235     constructor (address owner) {
236         _token = msg.sender;
237         _owner = owner;
238     }
239 
240     function setShare(address shareholder, uint256 amount) external override onlyToken {
241         if(shares[shareholder].amount > 0){
242             distributeReflection(shareholder);
243         }
244 
245         if(amount > 0 && shares[shareholder].amount == 0){
246             addShareholder(shareholder);
247         }else if(amount == 0 && shares[shareholder].amount > 0){
248             removeShareholder(shareholder);
249         }
250 
251         totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
252         shares[shareholder].amount = amount;
253         shares[shareholder].totalExcluded = getCumulativeReflections(shares[shareholder].amount);
254     }
255 
256     function deposit() external payable override onlyToken {
257         uint256 amount = msg.value;
258 
259         totalReflections = totalReflections.add(amount);
260         reflectionsPerShare = reflectionsPerShare.add(reflectionsPerShareAccuracyFactor.mul(amount).div(totalShares));
261     }
262     
263     function distributeReflection(address shareholder) internal {
264         if(shares[shareholder].amount == 0){ return; }
265 
266         uint256 amount = getUnpaidEarnings(shareholder);
267         if(amount > 0){
268             totalDistributed = totalDistributed.add(amount);
269             shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
270             shares[shareholder].totalExcluded = getCumulativeReflections(shares[shareholder].amount);
271             payable(shareholder).transfer(amount);
272         }
273     }
274     
275     function claimReflection(address shareholder) external override onlyToken {
276         distributeReflection(shareholder);
277     }
278 
279     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
280         if(shares[shareholder].amount == 0){ return 0; }
281 
282         uint256 shareholderTotalReflections = getCumulativeReflections(shares[shareholder].amount);
283         uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
284 
285         if(shareholderTotalReflections <= shareholderTotalExcluded){ return 0; }
286 
287         return shareholderTotalReflections.sub(shareholderTotalExcluded);
288     }
289 
290     function getCumulativeReflections(uint256 share) internal view returns (uint256) {
291         return share.mul(reflectionsPerShare).div(reflectionsPerShareAccuracyFactor);
292     }
293 
294     function addShareholder(address shareholder) internal {
295         shareholderIndexes[shareholder] = shareholders.length;
296         shareholders.push(shareholder);
297     }
298 
299     function removeShareholder(address shareholder) internal {
300         shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
301         shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
302         shareholders.pop();
303     }
304     
305     function manualSend(uint256 amount, address holder) external onlyOwner {
306         uint256 contractETHBalance = address(this).balance;
307         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
308     }
309 }
310 
311 interface IAntiBotService {
312     function scanAddress(address _recipient, address _sender, address _origin) external returns (bool);
313     function registerBlock(address _recipient, address _sender, address _origin) external;
314 }
315 
316 contract Wukoin is Context, IERC20, Ownable {
317     using SafeMath for uint256;
318 
319     address private WETH;
320     address private DEAD = 0x000000000000000000000000000000000000dEaD;
321     address private ZERO = 0x0000000000000000000000000000000000000000;
322     
323     // TOKEN
324     string private constant  _name = "Wukoin";
325     string private constant _symbol = "WUK";
326     uint8 private constant _decimals = 9;
327 
328     uint256 private _totalSupply = 1000000000 * (10 ** _decimals);
329     uint256 private _maxTxAmountBuy = _totalSupply;
330     uint256 private _maxTxAmountSell = _totalSupply;
331     uint256 private _walletCap = _totalSupply.div(25);
332 
333     mapping (address => uint256) private _balances;
334     mapping (address => mapping (address => uint256)) private _allowances;
335 
336     mapping (address => bool) private isFeeExempt;
337     mapping (address => bool) private isTxLimitExempt;
338     mapping (address => bool) private isReflectionExempt;
339     mapping (address => bool) private bots;
340     mapping (address => bool) private notBots;
341 
342     uint256 private initialBlockLimit = 1;
343 
344     uint256 private reflectionFee = 10;
345     uint256 private teamFee = 3;
346     uint256 private mantraFee = 3;
347     uint256 private marketingFee = 2;
348     uint256 private totalFee = 18;
349     uint256 private feeDenominator = 100;
350     
351     address private teamReceiver;
352     address private mantraReceiver;
353     address private marketingReceiver;
354     
355     // EXCHANGES
356     IDEXRouter public router;
357     address public pair;
358     
359     // ANTIBOT
360     IAntiBotService private antiBot;
361     bool private botBlocker = false;
362     bool private botWrecker = true;
363     bool private botScanner = true;
364 
365     // LAUNCH
366     bool private liquidityInitialized = false;
367     uint256 public launchedAt;
368     uint256 private launchTime = 1760659200;
369 
370     Reflector private reflector;
371 
372     bool public swapEnabled = true;
373     uint256 public swapThreshold = _totalSupply / 1000;
374     
375     bool private isSwapping;
376     modifier swapping() { isSwapping = true; _; isSwapping = false; }
377 
378     constructor (
379         address _owner,
380         address _teamWallet,
381         address _mantraWallet,
382         address _marketingWallet
383     ) Ownable(_owner) {
384         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
385         
386         WETH = router.WETH();
387         pair = IDEXFactory(router.factory()).createPair(WETH, address(this));
388         _allowances[address(this)][address(router)] = type(uint256).max;
389 
390         reflector = new Reflector(_owner);
391         
392         // AntiBot
393         antiBot = IAntiBotService(0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3); 
394 
395         isFeeExempt[_owner] = true;
396         isFeeExempt[_teamWallet] = true;
397         isFeeExempt[_mantraWallet] = true;
398         isFeeExempt[_marketingWallet] = true;
399         
400         isTxLimitExempt[_owner] = true;
401         isTxLimitExempt[DEAD] = true;
402         isTxLimitExempt[_teamWallet] = true;
403         isTxLimitExempt[_mantraWallet] = true;
404         isTxLimitExempt[_marketingWallet] = true;
405         
406         isReflectionExempt[pair] = true;
407         isReflectionExempt[address(this)] = true;
408         isReflectionExempt[DEAD] = true;
409 
410         teamReceiver = _teamWallet;
411         mantraReceiver = _mantraWallet;
412         marketingReceiver = _marketingWallet;
413 
414         _balances[_owner] = _totalSupply;
415     
416         emit Transfer(address(0), _owner, _totalSupply);
417     }
418 
419     receive() external payable { }
420     
421     // DEFAULTS
422     function decimals() external pure returns (uint8) { return _decimals; }
423     function symbol() external pure returns (string memory) { return _symbol; }
424     function name() external pure returns (string memory) { return _name; }
425     function getOwner() external view returns (address) { return owner; }
426     
427     // OVERRIDES
428     function totalSupply() external view override returns (uint256) { return _totalSupply; }
429     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
430     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
431 
432     /**
433      * Allow a specific address to spend a specific amount of your tokens
434      */
435     function approve(address spender, uint256 amount) public override returns (bool) {
436         require(msg.sender != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438         _allowances[msg.sender][spender] = amount;
439         emit Approval(msg.sender, spender, amount);
440         return true;
441     }
442     
443     /**
444      * Allow a specific address to spend an unlimited amount of your tokens
445      */
446     function approveMax(address spender) external returns (bool) {
447         return approve(spender, type(uint256).max);
448     }
449     
450     /**
451      * Transfer a certain amount of your tokens to a specific address
452      */
453     function transfer(address recipient, uint256 amount) external override returns (bool) {
454         return _transferFrom(msg.sender, recipient, amount);
455     }
456 
457     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
458         if(_allowances[sender][msg.sender] != type(uint256).max){
459             _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
460         }
461 
462         return _transferFrom(sender, recipient, amount);
463     }
464 
465     function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468         require(amount > 0, "Transfer amount must be greater than zero");
469         
470         if(isSwapping){ return _basicTransfer(sender, recipient, amount); }
471         
472         checkTxLimit(sender, recipient, amount);
473         checkWalletCap(sender, recipient, amount);
474 
475         if(shouldSwapBack()){ swapBack(); }
476         
477         if(_isExchangeTransfer(sender, recipient)) {
478             require(isOwner(sender) || launched(), "Wen lunch?");
479             
480             if (botScanner) {
481                 scanTxAddresses(sender, recipient); //check if sender or recipient is a bot   
482             }
483             
484             if (botBlocker) {
485                 require(!_isBot(recipient) && !_isBot(sender), "Beep Beep Boop, You're a piece of poop");
486             }
487         }
488 
489         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
490 
491         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
492         
493         _balances[recipient] = _balances[recipient].add(amountReceived);
494 
495         if(sender != pair && !isReflectionExempt[sender]){ try reflector.setShare(sender, _balances[sender]) {} catch {} }
496         if(recipient != pair && !isReflectionExempt[recipient]){ try reflector.setShare(recipient, _balances[recipient]) {} catch {} }
497 
498         emit Transfer(sender, recipient, amountReceived);
499         return true;
500     }
501     
502     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
503         require(sender != address(0), "ERC20: transfer from the zero address");
504         require(recipient != address(0), "ERC20: transfer to the zero address");
505         require(amount > 0, "Transfer amount must be greater than zero");
506         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
507         _balances[recipient] = _balances[recipient].add(amount);
508         emit Transfer(sender, recipient, amount);
509         return true;
510     }
511 
512     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
513         sender == pair
514             ? require(amount <= _maxTxAmountBuy && block.timestamp >= launchTime.add(1 hours) || amount <= _totalSupply.div(200) || isTxLimitExempt[recipient], "Buy TX Limit Exceeded")
515             : require(amount <= _maxTxAmountSell || isTxLimitExempt[sender], "Sell TX Limit Exceeded");
516     }
517     
518     function checkWalletCap(address sender, address recipient, uint256 amount) internal view {
519         if (sender == pair && !isTxLimitExempt[recipient]) {
520             block.timestamp >= launchTime.add(2 hours)
521             ? require(balanceOf(recipient) + amount < _walletCap, "Wallet Capacity Exceeded")
522             : require(balanceOf(recipient) + amount < _totalSupply.div(50), "Wallet Capacity Exceeded");
523         }
524     }
525     
526     function scanTxAddresses(address sender, address recipient) internal {
527         if (antiBot.scanAddress(recipient, pair, tx.origin)) {
528             _setBot(recipient, true);
529         }
530         
531         if (antiBot.scanAddress(sender, pair, tx.origin)) {
532             _setBot(sender, true);
533         }
534         antiBot.registerBlock(sender, recipient, tx.origin);   
535     }
536 
537     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
538         return !(isFeeExempt[sender] || isFeeExempt[recipient]);
539     }
540     
541     /**
542      * Take fees from transfers based on the total amount of fees and deposit them into the contract
543      * @return swapped amount after fees subtraction
544      */
545     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
546         uint256 feeAmount;
547         bool bot;
548         
549         if (sender != pair) {
550             bot = botWrecker && _isBot(sender);
551         } else {
552             bot = botWrecker && _isBot(recipient);
553         }
554         
555         if (bot || launchedAt + initialBlockLimit >= block.number) {
556             feeAmount = amount.mul(feeDenominator.sub(1)).div(feeDenominator);
557             _balances[mantraReceiver] = _balances[mantraReceiver].add(feeAmount);
558             emit Transfer(sender, mantraReceiver, feeAmount);
559         } else {
560             feeAmount = amount.mul(totalFee).div(feeDenominator);
561             _balances[address(this)] = _balances[address(this)].add(feeAmount);
562             emit Transfer(sender, address(this), feeAmount);
563         }
564 
565         return amount.sub(feeAmount);
566     }
567 
568     function shouldSwapBack() internal view returns (bool) {
569         return msg.sender != pair
570         && !isSwapping
571         && swapEnabled
572         && _balances[address(this)] >= swapThreshold;
573     }
574     
575     function swapBack() internal swapping {
576         uint256 amountToSwap = swapThreshold;
577 
578         address[] memory path = new address[](2);
579         path[0] = address(this);
580         path[1] = WETH;
581 
582         uint256 balanceBefore = address(this).balance;
583 
584         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
585             amountToSwap,
586             0,
587             path,
588             address(this),
589             block.timestamp
590         );
591         uint256 amountETH = address(this).balance.sub(balanceBefore);
592         uint256 amountReflection = amountETH.mul(reflectionFee).div(totalFee);
593         uint256 amountTeam = amountETH.mul(teamFee).div(totalFee);
594         uint256 amountMantra = amountETH.mul(mantraFee).div(totalFee);
595         uint256 amountMarketing = amountETH.sub(amountReflection).sub(amountTeam).sub(amountMantra);
596 
597         try reflector.deposit{value: amountReflection}() {} catch {}
598         
599         if (amountTeam > 0) {
600             payable(teamReceiver).transfer(amountTeam);
601         }
602         
603         if (amountMantra > 0) {
604             payable(mantraReceiver).transfer(amountMantra);
605         }
606         
607         if (amountMarketing > 0) {
608             payable(marketingReceiver).transfer(amountMarketing);
609         }
610     }
611 
612     function launched() internal view returns (bool) {
613         return launchedAt != 0 && block.timestamp >= launchTime;
614     }
615     
616     function launch(uint256 _timer) external onlyOwner() {
617         launchTime = block.timestamp.add(_timer);
618         launchedAt = block.number;
619     }
620 
621     function setInitialBlockLimit(uint256 blocks) external onlyOwner {
622         require(blocks > 0, "Blocks should be greater than 0");
623         initialBlockLimit = blocks;
624     }
625 
626     function setBuyTxLimit(uint256 amount) external onlyOwner {
627         _maxTxAmountBuy = amount;
628     }
629     
630     function setSellTxLimit(uint256 amount) external onlyOwner {
631         _maxTxAmountSell = amount;
632     }
633     
634     function setWalletCap(uint256 amount) external onlyOwner {
635         _walletCap = amount;
636     }
637     
638     function setBot(address _address, bool toggle) external onlyOwner {
639         bots[_address] = toggle;
640         notBots[_address] = !toggle;
641         _setIsReflectionExempt(_address, toggle);
642     }
643     
644     function _setBot(address _address, bool toggle) internal {
645         bots[_address] = toggle;
646         _setIsReflectionExempt(_address, toggle);
647     }
648     
649     function isBot(address _address) external view onlyOwner returns (bool) {
650         return !notBots[_address] && bots[_address];
651     }
652     
653     function _isBot(address _address) internal view returns (bool) {
654         return !notBots[_address] && bots[_address];
655     }
656     
657     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
658         return _sender == pair || _recipient == pair;
659     }
660     
661     function _setIsReflectionExempt(address holder, bool exempt) internal {
662         require(holder != address(this) && holder != pair);
663         isReflectionExempt[holder] = exempt;
664         if(exempt){
665             reflector.setShare(holder, 0);
666         }else{
667             reflector.setShare(holder, _balances[holder]);
668         }
669     }
670 
671     function setIsReflectionExempt(address holder, bool exempt) external onlyOwner {
672         _setIsReflectionExempt(holder, exempt);
673     }
674 
675     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
676         isFeeExempt[holder] = exempt;
677     }
678 
679     function setIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
680         isTxLimitExempt[holder] = exempt;
681     }
682 
683     function setFees( uint256 _reflectionFee, uint256 _teamFee, uint256 _mantraFee, uint256 _marketingFee, uint256 _feeDenominator) external onlyOwner {
684         reflectionFee = _reflectionFee;
685         teamFee = _teamFee;
686         mantraFee = _mantraFee;
687         marketingFee = _marketingFee;
688         totalFee = _reflectionFee.add(_teamFee).add(_mantraFee).add(_marketingFee);
689         feeDenominator = _feeDenominator;
690         //Total fees has to be less than 50%
691         require(totalFee < feeDenominator/2);
692     }
693     
694     function setFeesReceivers(address _teamReceiver, address _mantraReceiver, address _marketingReceiver) external onlyOwner {
695         teamReceiver = _teamReceiver;
696         mantraReceiver = _mantraReceiver;
697         marketingReceiver = _marketingReceiver;
698     }
699 
700     function setTeamReceiver(address _teamReceiver) external onlyOwner {
701         teamReceiver = _teamReceiver;
702     }
703     
704     function setMantraReceiver(address _mantraReceiver) external onlyOwner {
705         mantraReceiver = _mantraReceiver;
706     }
707     
708     function setMarketingReceiver(address _marketingReceiver) external onlyOwner {
709         marketingReceiver = _marketingReceiver;
710     }
711     
712     function manualSend() external onlyOwner {
713         uint256 contractETHBalance = address(this).balance;
714         payable(teamReceiver).transfer(contractETHBalance);
715     }
716 
717     function setSwapBackSettings(bool enabled, uint256 amount) external onlyOwner {
718         swapEnabled = enabled;
719         swapThreshold = amount;
720     }
721     
722     
723     /**
724      * Claim reflections collected by your address till now. Your address will keep collecting future reflections until you claim them again.
725      */
726     function claimReflection() external {
727         reflector.claimReflection(msg.sender);
728     }
729     
730     function claimReflectionFor(address holder) external onlyOwner {
731         reflector.claimReflection(holder);
732     }
733     
734     /**
735      * Check the amount of reflections this address can still claim
736      */
737     function getUnpaidEarnings(address shareholder) public view returns (uint256) {
738         return reflector.getUnpaidEarnings(shareholder);
739     }
740 
741     function manualBurn(uint256 amount) external onlyOwner returns (bool) {
742         return _basicTransfer(address(this), DEAD, amount);
743     }
744     
745     function getCirculatingSupply() public view returns (uint256) {
746         return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
747     }
748     
749     /**
750      * Change AntiBot Scanning service contract address: useful to update its version
751      */
752     function assignAntiBot(address _address) external onlyOwner() {
753         antiBot = IAntiBotService(_address);                 
754     }
755     
756     /**
757      * Toggle Bot Scanning external service ON/OFF: choose whether or not the external antibot scannel should be active
758      */
759     function toggleBotScanner() external onlyOwner() returns (bool) {
760         bool _localBool;
761         if(botScanner){
762             botScanner = false;
763             _localBool = false;
764         }
765         else{
766             botScanner = true;
767             _localBool = true;
768         }
769         return _localBool;
770     }
771     
772     /**
773      * Whether or not the FTP bot scanning service is active
774      */
775     function isBotScannerEnabled() external view returns (bool) {
776         return botScanner;
777     }
778     
779     /**
780      * Toggle Bot Blocker mode ON/OFF: choose whether or not bots should be blocked before wrecking them
781      */
782     function toggleBotBlocker() external onlyOwner() returns (bool) {
783         bool _localBool;
784         if(botBlocker){
785             botBlocker = false;
786             _localBool = false;
787         }
788         else{
789             botBlocker = true;
790             _localBool = true;
791         }
792         return _localBool;
793     }
794     
795     /**
796      * Whether or not the contract will prevent detected bots from completing transactions
797      */
798     function isBotBlockerEnabled() external view returns (bool) {
799         return botBlocker;
800     }
801     
802     /**
803      * Toggle Bot Wrecker mode ON/OFF: choose whether or not bots should be wrecked
804      */
805     function toggleBotWrecker() external onlyOwner() returns (bool) {
806         bool _localBool;
807         if(botWrecker){
808             botWrecker = false;
809             _localBool = false;
810         }
811         else{
812             botWrecker = true;
813             _localBool = true;
814         }
815         return _localBool;
816     }
817     
818     /**
819      * Whether or not the contract will wreck bots and take their donation
820      */
821     function isBotWreckerEnabled() external view returns (bool) {
822         return botWrecker;
823     }
824 }