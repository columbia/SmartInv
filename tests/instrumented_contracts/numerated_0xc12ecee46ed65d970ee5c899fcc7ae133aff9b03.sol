1 /* TRY token has been being developed since 10/2020 and has more features than most other DEFI token's on the market, here is a summary of built in features that TRY token offers:
2  
3  * We added a brand new feature never seen before in any DEFI token, a tx reward pool, 1% of all transactions are given to the reward pool and are awarded to the sender of every 25th transaction.
4  * We added a deflationary burn fee of 1% on every tx which is automatically sent directly to the burn address upon every transfer, this feature will ensure a truly deflationary model.
5  * We wanted to discourage token dumping so we added a 5% antiDumpFee to all TRY sold on UNIswap. This fee is distributed to all TRYstake users when buyback feature is performed.
6  * Previous rebalance liquidity models used a liquidity divisor as a liquidity reward, however that process made the rebalance feature not as effective since it had to rebalance its own rewards.
7  * To help replace the removal of awarding liquidity providers via the Buyback function we will allow LP tokens to farm TRY tokens directly on TRYfarm.
8  * We coded this contract to have the ability to ADDfunds into TRYstake so it can directly be its own UNIswap sell fee rewards distributor. The staking rewards distribution is called every time 
9    a user performs the rebalance liquidity function. The rebalance function still burns TRY that it purchases with the rebalance increasing the effectiveness of the deflationary model.
10  * When Buyback function is called the caller gets a 4% reward of the buyback TRY amount and 96% of the buyback TRY amount gets sent directly to the burn address.
11  * We coded the buyback function to work on 2 hour intervals and set the rate to 1%, we also added the ability for this contract to add 20 seconds to the buyback interval on each use of the 
12    buyback function. This will help ensure that the buyback feature cannot be manipulated and insure maximum life expectancy of the feature.
13  * We ensured that all of TRY protocols are whitelist able so when you use them you will not incur any transactional fee's when sending TRY to those protocols.
14  * Once this contract creates the UNIswap pair the LP tokens that are sent back are unable to be removed, there is no withdrawal code for these LP tokens this locked them for their intended purpose forever.
15  * We added the ability to add and remove blacklist addresses, this will help insure that we can properly fight hackers and malicious intents on TRY token's economy.
16  * We added createUNISwapPair function that will ensure ETH collected for liquidity can only be used for that one specific purpose, TRY presale contract automatically sends ETH liquidity to this contract.
17  * We are sure that TRY will be the most successful project to ever use a rebalancer style feature, TRYstake will ensure TRY tokens are happy earning in the staking contracts and not on the market to lower 
18    the price. UNIswap sell fees will discourage selling, while offering incentivized rewards for staking. TRYfarm will directly reward liquidity providers in replacement of the liquidity reward distribution 
19    on the previous model. The Tx Reward pool feature helps complete the package, TRY token has the most rewarding features of any DEFI token!
20  
21  For more information please visit try.finance/whitepaper.html 
22 */
23 
24 pragma solidity ^0.5.17;
25 
26 
27 contract Context {
28 
29     constructor () internal { }
30 
31 
32     function _msgSender() internal view returns (address payable) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view returns (bytes memory) {
37         this; 
38         return msg.data;
39     }
40 }
41 
42 contract WhitelistAdminRole is Context {
43     using Roles for Roles.Role;
44 
45     event WhitelistAdminAdded(address indexed account);
46     event WhitelistAdminRemoved(address indexed account);
47 
48     Roles.Role private _whitelistAdmins;
49 
50     constructor () internal {
51         _addWhitelistAdmin(_msgSender());
52     }
53 
54     modifier onlyWhitelistAdmin() {
55         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
56         _;
57     }
58 
59     function isWhitelistAdmin(address account) public view returns (bool) {
60         return _whitelistAdmins.has(account);
61     }
62     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
63         _addWhitelistAdmin(account);
64     }
65 
66     function renounceWhitelistAdmin() public {
67         _removeWhitelistAdmin(_msgSender());
68     }
69 
70     function _addWhitelistAdmin(address account) internal {
71         _whitelistAdmins.add(account);
72         emit WhitelistAdminAdded(account);
73     } 
74 
75     function _removeWhitelistAdmin(address account) internal {
76         _whitelistAdmins.remove(account);
77         emit WhitelistAdminRemoved(account);
78     }
79 }
80 
81 
82 interface IERC20 {
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address account) external view returns (uint256);
87      
88     function transfer(address recipient, uint256 amount) external returns (bool);
89 
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 library SafeMath {
102 
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return sub(a, b, "SafeMath: subtraction overflow");
112     }
113 
114     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b <= a, errorMessage);
116         uint256 c = a - b;
117 
118         return c;
119     }
120 
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122 
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint256 c = a * b;
128         require(c / a == b, "SafeMath: multiplication overflow");
129 
130         return c;
131     }
132 
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138 
139         require(b > 0, errorMessage);
140         uint256 c = a / b;
141 
142         return c;
143     }
144 
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b != 0, errorMessage);
151         return a % b;
152     }
153     function ceil(uint a, uint m) internal pure returns (uint r) {
154         return (a + m - 1) / m * m;
155     }
156 }
157 
158 contract ERC20 is Context, IERC20 {
159     using SafeMath for uint256;
160 
161     mapping (address => uint256) private _balances;
162     mapping (address => mapping (address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165     constructor (uint256 totalSupply) public {
166         _mint(_msgSender(),totalSupply);
167     }
168     
169     function totalSupply() public view returns (uint256) {
170         return _totalSupply;
171     }
172 
173     function balanceOf(address account) public view returns (uint256) {
174         return _balances[account];
175     }
176 
177     function transfer(address recipient, uint256 amount) public returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     function allowance(address owner, address spender) public view returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount) public returns (bool) {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190     
191     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
194         return true;
195     }
196 
197     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
198         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
199         return true;
200     }
201 
202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
204         return true;
205     }
206 
207     function _transfer(address sender, address recipient, uint256 amount) internal {
208         require(sender != address(0), "ERC20: transfer from the zero address");
209         require(recipient != address(0), "ERC20: transfer to the zero address");
210 
211         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
212         _balances[recipient] = _balances[recipient].add(amount);
213         emit Transfer(sender, recipient, amount);
214     }
215 
216     function _mint(address account, uint256 amount) internal {
217         require(account != address(0), "ERC20: mint to the zero address");
218 
219         _totalSupply = _totalSupply.add(amount);
220         _balances[account] = _balances[account].add(amount);
221         emit Transfer(address(0), account, amount);
222     }
223 
224     function _burn(address account, uint256 amount) internal {
225         require(account != address(0), "ERC20: burn from the zero address");
226 
227         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
228         _totalSupply = _totalSupply.sub(amount);
229         emit Transfer(account, address(0), amount);
230     }
231 
232     function _approve(address owner, address spender, uint256 amount) internal {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235 
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _burnFrom(address account, uint256 amount) internal {
241         _burn(account, amount);
242         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
243     }
244 }
245 
246 contract ERC20Burnable is Context, ERC20 {
247 
248     function burn(uint256 amount) public {
249         _burn(_msgSender(), amount);
250     }
251 
252     function burnFrom(address account, uint256 amount) public {
253         _burnFrom(account, amount);
254     }
255 }
256 
257 library Roles {
258     struct Role {
259         mapping (address => bool) bearer;
260     }
261 
262     function add(Role storage role, address account) internal {
263         require(!has(role, account), "Roles: account already has role");
264         role.bearer[account] = true;
265     }
266 
267     function remove(Role storage role, address account) internal {
268         require(has(role, account), "Roles: account does not have role");
269         role.bearer[account] = false;
270     }
271 
272     function has(Role storage role, address account) internal view returns (bool) {
273         require(account != address(0), "Roles: account is the zero address");
274         return role.bearer[account];
275     }
276 }
277 
278 contract ERC20Detailed is IERC20 {
279     string private _name;
280     string private _symbol;
281     uint8 private _decimals;
282 
283     constructor (string memory name, string memory symbol, uint8 decimals) public {
284         _name = name;
285         _symbol = symbol;
286         _decimals = decimals;
287     }
288 
289     function name() public view returns (string memory) {
290         return _name;
291     }
292 
293     function symbol() public view returns (string memory) {
294         return _symbol;
295     }
296 
297     function decimals() public view returns (uint8) {
298         return _decimals;
299     }
300 }
301 
302 contract ERC20TransferLiquidityLock is ERC20 {
303     using SafeMath for uint256;
304 
305 
306     event Rebalance(uint256 tokenBurnt);
307     event SupplyTRYStake(uint256 tokenAmount);
308     event RewardStakers(uint256 stakingRewards);
309     
310     address public uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
311     address public uniswapV2Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
312     address public uniswapV2Pair; 
313     address public TRYStake;
314     address public presaleAddress;
315     address public LPFarm; 
316     address public Master = address (uniswapV2Router);     
317     address public Trident = address (this);
318     address payable public treasury;
319     mapping(address => bool) public feelessAddr;
320     mapping(address => bool) public unlocked;
321     mapping(address => bool) public oracle; 
322     mapping(address => bool) public blacklist; 
323     
324     uint256 public rewardPoolDivisor;
325     uint256 public rebalanceRewardDivisor;
326     uint256 public rebalanceDivisor; 
327     uint256 public burnTxFee;    
328     uint256 public antiDumpFee;       
329     uint256 public minRebalanceAmount;
330     uint256 public lastRebalance;
331     uint256 public rebalanceInterval;
332     address public burnAddr = 0x000000000000000000000000000000000000dEaD;
333     bool public LPLocked; 
334     
335     uint256 public txNumber;
336     uint256 one = 1000000000000000000;
337     uint256 public trans100 = 25000000000000000000; 
338     
339     uint256 public stakePool = 0;
340     uint256 public rewardPool = 0;    
341 
342     bool public locked;
343     Balancer balancer;
344     
345     constructor() public {
346         lastRebalance = block.timestamp;
347         burnTxFee = 100;
348         rewardPoolDivisor = 100;
349         antiDumpFee = 20;
350         rebalanceRewardDivisor = 25;
351         rebalanceDivisor = 100;
352         rebalanceInterval = 2 hours;
353         minRebalanceAmount = 100e18; 
354         treasury = msg.sender;
355         balancer = new Balancer(treasury);
356         feelessAddr[address(this)] = true;
357         feelessAddr[address(balancer)] = true;
358         feelessAddr[address(uniswapV2Router)] = true; 
359         feelessAddr[address(uniswapV2Factory)] = true;        
360         feelessAddr[address(TRYStake)] = true; 
361         feelessAddr[address(presaleAddress)] = true;
362         locked = true;
363         LPLocked = true;
364         unlocked[msg.sender] = false;
365         unlocked[address(this)] = true;
366         unlocked[address(balancer)] = true; 
367         unlocked[address(balancer)] = true; 
368         unlocked[address(uniswapV2Router)] = true;
369         unlocked[address(presaleAddress)] = true;
370         txNumber = 0;
371     } 
372     
373     function calculateFees(address from, address to, uint256 amount) public view returns( uint256 rewardtx, uint256  Burntx, uint256  selltx){
374     }
375     
376     function isContract(address _addr) public view returns (bool _isContract){
377         uint32 size;
378         assembly {
379         size := extcodesize(_addr)}
380         
381         return (size > 0);
382     }
383 
384     function _transfer(address from, address to, uint256 amount) internal {
385         
386         if(locked && unlocked[from] != true && unlocked[to] != true)
387             revert("Transfers are locked until after presale.");
388 
389         if(blacklist [from] == true || blacklist [to] == true) 
390             revert("Address is blacklisted");
391           
392        uint256  Burntx = 0;
393         uint256  rewardtx = 0;
394         
395     if(feelessAddr[from] == false && feelessAddr[to] == false){    
396         
397        if (burnTxFee != 0) { 
398         Burntx = amount.div(burnTxFee); 
399         amount = amount.sub(Burntx);
400            super._transfer(from, address(burnAddr), Burntx); 
401         } 
402         
403         if (rewardPoolDivisor != 0) { 
404             txNumber = txNumber.add(one);
405             rewardtx = amount.div(rewardPoolDivisor); 
406             amount = amount.sub(rewardtx);
407             super._transfer(from, address(this), rewardtx); 
408           
409             rewardPool += rewardtx;
410             if(txNumber == trans100){
411                 require( !(isContract(from)), 'inValid caller');
412                 super._transfer(address(this), from, rewardPool);
413                 rewardPool = 0;
414                 txNumber = 0;  
415             }
416         }
417         
418         if (antiDumpFee != 0 && oracle[to]) {
419            uint256 selltx = amount.div(antiDumpFee); 
420            stakePool += selltx;
421            amount = amount.sub(selltx);
422                 super._transfer(from, address(this), selltx);
423             }
424             
425          super._transfer(from, to, amount);
426         }
427     
428         else {
429          super._transfer(from, to, amount);   
430         }
431     }
432 
433 
434     function () external payable {}
435 
436     function RebalanceLiquidity() public {
437         require(balanceOf(msg.sender) >= minRebalanceAmount, "You do not have the required amount of TRY.");
438         require(block.timestamp > lastRebalance + rebalanceInterval, "It is too early to use this function."); 
439         lastRebalance = block.timestamp;
440         uint256 _lockableSupply = stakePool;  
441         _addRebalanceInterval();        
442         _rewardStakers(_lockableSupply);
443         
444         uint256 amountToRemove = ERC20(uniswapV2Pair).balanceOf(address(this)).div(rebalanceDivisor);
445         
446         remLiquidity(amountToRemove);
447         uint _locked = balancer.rebalance(rebalanceRewardDivisor);
448 
449         emit Rebalance(_locked);
450     }
451     
452     function _addRebalanceInterval() private {
453         rebalanceInterval = rebalanceInterval.add(20 seconds);
454     }
455     
456     function _rewardStakers(uint256 stakingRewards) private {
457         if(TRYStake != address(0)) {
458            TRYstakingContract(TRYStake).ADDFUNDS(stakingRewards);
459            stakePool= 0;
460             emit RewardStakers(stakingRewards); 
461         }
462     }
463 
464     function remLiquidity(uint256 lpAmount) private returns(uint ETHAmount) {
465         ERC20(uniswapV2Pair).approve(uniswapV2Router, lpAmount);
466         (ETHAmount) = IUniswapV2Router02(uniswapV2Router)
467             .removeLiquidityETHSupportingFeeOnTransferTokens(
468                 address(this),
469                 lpAmount,
470                 0,
471                 0,
472                 address(balancer),
473                 block.timestamp);
474     }
475     
476 
477     function lockableSupply() external view returns (uint256) {
478         return balanceOf(address(this));
479     }
480 
481     function lockedSupply() external view returns (uint256) {
482         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
483         uint256 lpBalance = lockedLiquidity();
484         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
485 
486         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
487         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
488         return _lockedSupply;
489     }
490 
491     function burnedSupply() external view returns (uint256) {
492         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
493         uint256 lpBalance = burnedLiquidity();
494         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
495 
496         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
497         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
498         return _burnedSupply;
499     }
500 
501     function burnableLiquidity() public view returns (uint256) {
502         return ERC20(uniswapV2Pair).balanceOf(address(this));
503     }
504 
505     function burnedLiquidity() public view returns (uint256) {
506         return ERC20(uniswapV2Pair).balanceOf(address(0));
507     }
508 
509     function lockedLiquidity() public view returns (uint256) {
510         return burnableLiquidity().add(burnedLiquidity());
511     }
512 }
513 
514 interface TRYstakingContract {
515     function ADDFUNDS(uint256 stakingRewards) external;
516 }
517 
518 interface IUniswapV2Router01 {
519     function factory() external pure returns (address);
520     function WETH() external pure returns (address);
521     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
522     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
523     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
524     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
525     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
526 
527     function addLiquidityETH(
528         address token,
529         uint amountTokenDesired,
530         uint amountTokenMin,
531         uint amountETHMin,
532         address to,
533         uint deadline
534     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
535 }
536 
537 interface IUniswapV2Router02 {
538     function WETH() external pure returns (address);
539     function swapExactETHForTokensSupportingFeeOnTransferTokens(
540       uint amountOutMin,
541       address[] calldata path,
542       address to,
543       uint deadline
544     ) external payable;
545     function removeLiquidityETH(
546       address token,
547       uint liquidity,
548       uint amountTokenMin,
549       uint amountETHMin,
550       address to,
551       uint deadline
552     ) external returns (uint amountToken, uint amountETH);
553     function removeLiquidityETHSupportingFeeOnTransferTokens(
554       address token,
555       uint liquidity,
556       uint amountTokenMin,
557       uint amountETHMin,
558       address to,
559       uint deadline
560     ) external returns (uint amountETH);    
561 }
562 
563 interface IUniswapV2Pair {
564     function sync() external;
565 }
566 
567 contract ERC20Governance is ERC20, ERC20Detailed {
568     using SafeMath for uint256;
569 
570     function _transfer(address from, address to, uint256 amount) internal {
571         _moveDelegates(_delegates[from], _delegates[to], amount);
572         super._transfer(from, to, amount);
573     }
574 
575     function _mint(address account, uint256 amount) internal {
576         _moveDelegates(address(0), _delegates[account], amount);
577         super._mint(account, amount);
578     }
579 
580     function _burn(address account, uint256 amount) internal {
581         _moveDelegates(_delegates[account], address(0), amount);
582         super._burn(account, amount);
583     }
584 
585     mapping (address => address) internal _delegates;
586 
587     struct Checkpoint {
588         uint32 fromBlock;
589         uint256 votes;
590     }
591     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
592 
593     mapping (address => uint32) public numCheckpoints;
594 
595     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
596 
597     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
598 
599     mapping (address => uint) public nonces;
600 
601     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
602 
603     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
604 
605     function delegates(address delegator)
606         external
607         view
608         returns (address)
609     {
610         return _delegates[delegator];
611     }
612 
613     function delegate(address delegatee) external {
614         return _delegate(msg.sender, delegatee);
615     }
616 
617     function delegateBySig(
618         address delegatee,
619         uint nonce,
620         uint expiry,
621         uint8 v,
622         bytes32 r,
623         bytes32 s
624     )
625         external
626     {
627         bytes32 domainSeparator = keccak256(
628             abi.encode(
629                 DOMAIN_TYPEHASH,
630                 keccak256(bytes(name())),
631                 getChainId(),
632                 address(this)
633             )
634         );
635 
636         bytes32 structHash = keccak256(
637             abi.encode(
638                 DELEGATION_TYPEHASH,
639                 delegatee,
640                 nonce,
641                 expiry
642             )
643         );
644 
645         bytes32 digest = keccak256(
646             abi.encodePacked(
647                 "\x19\x01",
648                 domainSeparator,
649                 structHash
650             )
651         );
652 
653         address signatory = ecrecover(digest, v, r, s);
654         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
655         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
656         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
657         return _delegate(signatory, delegatee);
658     }
659 
660     function getCurrentVotes(address account)
661         external
662         view
663         returns (uint256)
664     {
665         uint32 nCheckpoints = numCheckpoints[account];
666         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
667     }
668 
669     function getPriorVotes(address account, uint blockNumber)
670         external
671         view
672         returns (uint256)
673     {
674         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
675 
676         uint32 nCheckpoints = numCheckpoints[account];
677         if (nCheckpoints == 0) {
678             return 0;
679         }
680 
681         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
682             return checkpoints[account][nCheckpoints - 1].votes;
683         }
684 
685         if (checkpoints[account][0].fromBlock > blockNumber) {
686             return 0;
687         }
688 
689         uint32 lower = 0;
690         uint32 upper = nCheckpoints - 1;
691         while (upper > lower) {
692             uint32 center = upper - (upper - lower) / 2; 
693             Checkpoint memory cp = checkpoints[account][center];
694             if (cp.fromBlock == blockNumber) {
695                 return cp.votes;
696             } else if (cp.fromBlock < blockNumber) {
697                 lower = center;
698             } else {
699                 upper = center - 1;
700             }
701         }
702         return checkpoints[account][lower].votes;
703     }
704 
705     function _delegate(address delegator, address delegatee)
706         internal
707     {
708         address currentDelegate = _delegates[delegator];
709         uint256 delegatorBalance = balanceOf(delegator); 
710         _delegates[delegator] = delegatee;
711 
712         emit DelegateChanged(delegator, currentDelegate, delegatee);
713 
714         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
715     }
716 
717     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
718         if (srcRep != dstRep && amount > 0) {
719             if (srcRep != address(0)) {
720                 uint32 srcRepNum = numCheckpoints[srcRep];
721                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
722                 uint256 srcRepNew = srcRepOld.sub(amount);
723                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
724             }
725 
726             if (dstRep != address(0)) {
727                 uint32 dstRepNum = numCheckpoints[dstRep];
728                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
729                 uint256 dstRepNew = dstRepOld.add(amount);
730                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
731             }
732         }
733     }
734 
735     function _writeCheckpoint(
736         address delegatee,
737         uint32 nCheckpoints,
738         uint256 oldVotes,
739         uint256 newVotes
740     )
741         internal
742     {
743         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
744 
745         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
746             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
747         } else {
748             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
749             numCheckpoints[delegatee] = nCheckpoints + 1;
750         }
751 
752         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
753     }
754 
755     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
756         require(n < 2**32, errorMessage);
757         return uint32(n);
758     }
759 
760     function getChainId() internal pure returns (uint) {
761         uint256 chainId;
762         assembly { chainId := chainid() }
763         return chainId;
764     }
765 }
766 
767 contract Balancer {
768     using SafeMath for uint256;    
769     TRYfinance token;
770     address public burnAddr = 0x000000000000000000000000000000000000dEaD;
771     address payable public treasury;
772   
773     constructor(address payable treasury_) public {
774         token = TRYfinance(msg.sender);
775         treasury = treasury_;
776     }
777     
778     function () external payable {}
779     
780     function rebalance(uint rebalanceRewardDivisor) external returns (uint256) { 
781         require(msg.sender == address(token), "only token contract can perform this function");
782         swapEthForTokens(address(this).balance, rebalanceRewardDivisor);
783         uint256 lockableBalance = token.balanceOf(address(this));
784         uint256 callerReward = lockableBalance.div(rebalanceRewardDivisor);
785         token.transfer(tx.origin, callerReward);
786         token.transfer(burnAddr, lockableBalance.sub(callerReward));  
787         return lockableBalance.sub(callerReward);
788     }
789     function swapEthForTokens(uint256 EthAmount, uint rebalanceRewardDivisor) private {
790         address[] memory uniswapPairPath = new address[](2);
791         uniswapPairPath[0] = IUniswapV2Router02(token.uniswapV2Router()).WETH();
792         uniswapPairPath[1] = address(token);
793         uint256 treasuryAmount = EthAmount.div(rebalanceRewardDivisor);
794         treasury.transfer(treasuryAmount);
795         
796         token.approve(token.uniswapV2Router(), EthAmount);
797         
798         IUniswapV2Router02(token.uniswapV2Router())
799             .swapExactETHForTokensSupportingFeeOnTransferTokens.value(EthAmount.sub(treasuryAmount))(
800                 0,
801                 uniswapPairPath,
802                 address(this),
803                 block.timestamp);
804     }        
805 }
806 
807 
808 contract TRYfinance is 
809     ERC20(100000e18), 
810     ERC20Detailed("TRYfinance", "TRY", 18), 
811     ERC20Burnable, 
812     ERC20Governance,
813     ERC20TransferLiquidityLock,
814     WhitelistAdminRole
815     
816 {
817 
818     function createUNISwapPair(uint amountTokenDesired) public onlyWhitelistAdmin {
819         uint amountETH = address(this).balance;
820         approve(address(uniswapV2Router), amountTokenDesired);
821         IUniswapV2Router01(uniswapV2Router).addLiquidityETH.value(amountETH)(
822             address(this),
823             amountTokenDesired,
824             0,
825             0,
826             address(this),
827             now); 
828     }
829     
830     function quickApproveTRYStake() public {
831         _approve(_msgSender(), TRYStake, 10000e18);
832     } 
833     
834     function quickApproveMaster() public {
835         _approve(_msgSender(), Master, 10000e18);
836     } 
837  
838     function quickApproveFarm() public {
839         _approve(_msgSender(), LPFarm, 10000e18);
840     } 
841     
842     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
843         uniswapV2Router = _uniswapV2Router;
844     }
845 
846     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
847         uniswapV2Pair = _uniswapV2Pair;  
848     }
849     
850     function setUniswapV2Factory(address _uniswapV2Factory) public onlyWhitelistAdmin {
851         uniswapV2Factory = _uniswapV2Factory; 
852     }
853 
854     function setTrans100(uint256 _trans100) public onlyWhitelistAdmin {
855         require(_trans100 <= 100e18, "Cannot set over 100 transactions");        
856         trans100 = _trans100; 
857     }
858 
859     function setRewardPoolDivisor(uint256 _rdiv) public onlyWhitelistAdmin {
860         require(_rdiv >= 100, "Cannot set over 1% RewardPoolDivisor");        
861         rewardPoolDivisor = _rdiv;
862     } 
863     
864     function setRebalanceDivisor(uint256 _rebalanceDivisor) public onlyWhitelistAdmin {
865         if (_rebalanceDivisor != 0) {
866             require(_rebalanceDivisor >= 10, "Cannot set rebalanceDivisor over 10%");
867             require(_rebalanceDivisor <= 100, "Cannot set rebalanceDivisor under 1%");
868         }        
869         rebalanceDivisor = _rebalanceDivisor;
870     }
871     
872     function addTRYStake(address _stake) public onlyWhitelistAdmin {
873         TRYStake = _stake;
874     }
875 
876     function addPresaleAddress(address _presaleaddress) public onlyWhitelistAdmin {
877         presaleAddress = _presaleaddress;  
878     }
879     
880     function addLPFarm(address _farm) public onlyWhitelistAdmin {
881         LPFarm = _farm;  
882     }
883 
884     function addMaster(address _master) public onlyWhitelistAdmin {
885         Master = _master;  
886     }
887      
888     function addTrident(address _Trident) public onlyWhitelistAdmin {
889         Trident = _Trident;
890     } 
891     
892     function setMaster () public onlyWhitelistAdmin { 
893         ERC20(Trident).approve(Master, 100000e18);       
894     }  
895     
896     function setTrident () public onlyWhitelistAdmin {
897         ERC20(Trident).approve(TRYStake, 100000e18);        
898     }  
899     
900     function rewardStaking(uint256 stakingRewards) internal {
901             TRYstakingContract(TRYStake).ADDFUNDS(stakingRewards);
902             emit SupplyTRYStake(stakingRewards); 
903     }
904  
905     function setRebalanceInterval(uint256 _interval) public onlyWhitelistAdmin {
906         require(_interval<= 7200, "Cannot set over 2 hour interval");  
907         require(_interval>= 3600, "Cannot set under 1 hour interval");
908         rebalanceInterval = _interval;
909     }
910      
911     function setRebalanceRewardDivisior(uint256 _rDivisor) public onlyWhitelistAdmin {
912         if (_rDivisor != 0) {
913             require(_rDivisor <= 25, "Cannot set rebalanceRewardDivisor under 4%");
914             require(_rDivisor >= 10, "Cannot set rebalanceRewardDivisor over 10%");
915         }        
916         rebalanceRewardDivisor = _rDivisor;
917     }
918     
919     function toggleFeeless(address _addr) public onlyWhitelistAdmin {
920         feelessAddr[_addr] = true;
921     }
922     
923     function toggleFees(address _addr) public onlyWhitelistAdmin {
924         feelessAddr[_addr] = false;
925     }
926     
927     function toggleUnlocked(address _addr) public onlyWhitelistAdmin {
928         unlocked[_addr] = !unlocked[_addr];
929     } 
930     
931     function setOracle(address _addr, bool _bool) public onlyWhitelistAdmin {  
932         oracle[_addr] = _bool; 
933     }  
934  
935     function setBlackListAddress(address _addr, bool _bool) public onlyWhitelistAdmin { 
936         blacklist[_addr] = _bool; 
937     } 
938     
939     function activateTrading() public onlyWhitelistAdmin {
940         locked = false;
941     }   
942  
943     function setMinRebalanceAmount(uint256 amount_) public onlyWhitelistAdmin {
944         require(amount_ <= 1000e18, "Cannot set over 1000 TRY tokens");
945         require(amount_ >= 20e18, "Cannot set under 20 TRY tokens");
946         minRebalanceAmount = amount_;
947     }
948     
949     function setBurnTxFee(uint256 amount_) public onlyWhitelistAdmin {
950         require(amount_ >= 100, "Cannot set over 1% burnTxFee"); 
951         burnTxFee = amount_;
952     }
953     
954     function setAntiDumpFee(uint256 amount_) public onlyWhitelistAdmin {
955         require(amount_ >= 10, "Cannot set over 10% antiDumpFee"); 
956         require(amount_ <= 100, "Cannot set under 1% antiDumpFee");
957         antiDumpFee = amount_;
958     }
959 }