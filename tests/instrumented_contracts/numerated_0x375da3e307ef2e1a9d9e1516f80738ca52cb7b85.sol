1 /*
2 
3  This contract is provided "as is" and "with all faults." The deployer makes no representations or warranties
4  of any kind concerning the safety, suitability, lack of exploits, inaccuracies, typographical errors, or other
5  harmful components of this contract. There are inherent dangers in the use of any contract, and you are solely
6  responsible for determining whether this contract is safe to use. You are also solely responsible for the 
7  protection of your funds, and the deployer will not be liable for any damages you may suffer in connection with
8  using, modifying, or distributing this contract.
9 
10 */
11 
12 pragma solidity ^0.5.17;
13 
14 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
15 // Subject to the MIT license.
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations with added overflow
19  * checks.
20  *
21  * Arithmetic operations in Solidity wrap on overflow. This can easily result
22  * in bugs, because programmers usually assume that an overflow raises an
23  * error, which is the standard behavior in high level programming languages.
24  * `SafeMath` restores this intuition by reverting the transaction when an
25  * operation overflows.
26  *
27  * Using this library instead of the unchecked operations eliminates an entire
28  * class of bugs, so it's recommended to use it always.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, reverting on overflow.
33      *
34      * Counterpart to Solidity's `+` operator.
35      *
36      * Requirements:
37      * - Addition cannot overflow.
38      */
39     function add(uint a, uint b) internal pure returns (uint) {
40         uint c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      * - Addition cannot overflow.
53      */
54     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
55         uint c = a + b;
56         require(c >= a, errorMessage);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot underflow.
68      */
69     function sub(uint a, uint b) internal pure returns (uint) {
70         return sub(a, b, "LBI::SafeMath: subtraction underflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      * - Subtraction cannot underflow.
80      */
81     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
82         require(b <= a, errorMessage);
83         uint c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      * - Multiplication cannot overflow.
95      */
96     function mul(uint a, uint b) internal pure returns (uint) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
119         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120         // benefit is lost if 'b' is also tested.
121         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122         if (a == 0) {
123             return 0;
124         }
125 
126         uint c = a * b;
127         require(c / a == b, errorMessage);
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers.
134      * Reverts on division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142      */
143     function div(uint a, uint b) internal pure returns (uint) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers.
149      * Reverts with custom message on division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, errorMessage);
161         uint c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint a, uint b) internal pure returns (uint) {
179         return mod(a, b, "SafeMath: modulo by zero");
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts with custom message when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
194         require(b != 0, errorMessage);
195         return a % b;
196     }
197 }
198 
199 interface UniswapPair {
200     function sync() external;
201     function transferFrom(address from, address to, uint value) external returns (bool);
202     function balanceOf(address account) external view returns (uint);
203     function approve(address spender, uint amount) external returns (bool);
204     function mint(address to) external returns (uint liquidity);
205 }
206 
207 interface IBondingCurve {
208     function calculatePurchaseReturn(uint _supply,  uint _reserveBalance, uint32 _reserveRatio, uint _depositAmount) external view returns (uint);
209 }
210 
211 interface WETH9 {
212     function deposit() external payable;
213     function balanceOf(address account) external view returns (uint);
214     function transfer(address recipient, uint amount) external returns (bool);
215     function approve(address spender, uint amount) external returns (bool);
216 }
217 
218 interface Uniswap {
219     function factory() external pure returns (address);
220     function addLiquidity(
221         address tokenA,
222         address tokenB,
223         uint amountADesired,
224         uint amountBDesired,
225         uint amountAMin,
226         uint amountBMin,
227         address to,
228         uint deadline
229     ) external returns (uint amountA, uint amountB, uint liquidity);
230     function removeLiquidity(
231         address tokenA,
232         address tokenB,
233         uint liquidity,
234         uint amountAMin,
235         uint amountBMin,
236         address to,
237         uint deadline
238     ) external returns (uint amountA, uint amountB);
239     function swapExactTokensForTokens(
240         uint amountIn,
241         uint amountOutMin,
242         address[] calldata path,
243         address to,
244         uint deadline
245     ) external returns (uint[] memory amounts);
246 }
247 
248 interface Factory {
249     function getPair(address tokenA, address tokenB) external view returns (address pair);
250 }
251 
252 interface LBI {
253     function approve(address spender, uint amount) external returns (bool);
254 }
255 
256 interface RewardDistributionDelegate {
257     function notifyRewardAmount(uint reward) external;
258 }
259 
260 interface RewardDistributionFactory {
261     function deploy(
262         address lp_, 
263         address earn_, 
264         address rewardDistribution_,
265         uint8 decimals_,
266         string calldata name_,
267         string calldata symbol_
268     ) external returns (address);
269 }
270 
271 interface GovernanceFactory {
272     function deploy(address token) external returns (address);
273 }
274 
275 contract LiquidityIncome {
276     using SafeMath for uint;
277     
278     /* BondingCurve */
279     
280     uint public scale = 10**18;
281     uint public reserveBalance = 1*10**14;
282     uint32 public constant RATIO = 500000;
283     
284     WETH9 constant public WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
285     
286     function () external payable { mint(0); }
287     
288     function mint(uint min) public payable {
289         require(msg.value > 0, "LBI::mint: msg.value = 0");
290         uint _bought = _continuousMint(msg.value);
291         require(_bought >= min, "LBI::mint: slippage");
292         WETH.deposit.value(msg.value)();
293         WETH.transfer(address(pool), WETH.balanceOf(address(this)));
294         pool.sync();
295         _mint(msg.sender, _bought, true);
296     }
297     
298     IBondingCurve constant public CURVE = IBondingCurve(0x16F6664c16beDE5d70818654dEfef11769D40983);
299 
300     function _buy(uint _amount) internal returns (uint _bought) {
301         _bought = _continuousMint(_amount);
302     }
303 
304     function calculateMint(uint _amount) public view returns (uint mintAmount) {
305         return CURVE.calculatePurchaseReturn(totalSupply, reserveBalance, RATIO, _amount);
306     }
307 
308     function _continuousMint(uint _deposit) internal returns (uint) {
309         uint amount = calculateMint(_deposit);
310         reserveBalance = reserveBalance.add(_deposit);
311         return amount;
312     }
313     
314     /// @notice EIP-20 token name for this token
315     string public constant name = "Liquidity Income";
316 
317     /// @notice EIP-20 token symbol for this token
318     string public constant symbol = "LBI";
319 
320     /// @notice EIP-20 token decimals for this token
321     uint8 public constant decimals = 18;
322     
323     /// @notice Total number of tokens in circulation
324     uint public totalSupply = 0; // Initial 0
325     
326     /// @notice the last block the tick was applied
327     uint public lastTick = 0;
328     
329     /// @notice the uniswap pool that will receive the rebase
330     UniswapPair public pool;
331     RewardDistributionDelegate public rewardDistribution;
332     RewardDistributionFactory public constant REWARDFACTORY = RewardDistributionFactory(0x323B2b67Ed1a745e5208ac18625ecef187a421D0);
333     GovernanceFactory public constant GOVERNANCEFACTORY = GovernanceFactory(0x4179Ef5dC359A4f73D5A14aF264f759052325bc1);
334     
335     /// @notice Allowance amounts on behalf of others
336     mapping (address => mapping (address => uint)) internal allowances;
337 
338     /// @notice Official record of token balances for each account
339     mapping (address => uint) internal balances;
340 
341     /// @notice The EIP-712 typehash for the contract's domain
342     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
343 
344     /// @notice The EIP-712 typehash for the permit struct used by the contract
345     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
346 
347     /// @notice A record of states for signing / validating signatures
348     mapping (address => uint) public nonces;
349 
350     /// @notice The standard EIP-20 transfer event
351     event Transfer(address indexed from, address indexed to, uint amount);
352     
353     /// @notice Tick event
354     event Tick(uint block, uint minted);
355 
356     /// @notice The standard EIP-20 approval event
357     event Approval(address indexed owner, address indexed spender, uint amount);
358     
359     Uniswap public constant UNI = Uniswap(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
360     
361     /* Incremental system for balance increments */
362     uint256 public index = 0; // previously accumulated index
363     uint256 public bal = 0; // previous calculated balance of COMP
364 
365     mapping(address => uint256) public supplyIndex;
366     
367     function _update(bool sync) internal {
368         if (totalSupply > 0) {
369             uint256 _before = balances[address(this)];
370             tick(sync);
371             uint256 _bal = balances[address(this)];
372             if (_bal > 0 && _bal > _before) {
373                 uint256 _diff = _bal.sub(bal, "LBI::_update: ball _diff");
374                 if (_diff > 0) {
375                     uint256 _ratio = _diff.mul(1e18).div(totalSupply);
376                     if (_ratio > 0) {
377                       index = index.add(_ratio);
378                       bal = _bal;
379                     }
380                 }
381             }
382         }
383     }
384     
385     mapping(address => uint) claimable;
386     
387     function claim() external {
388         claimFor(msg.sender);
389     }
390     function claimFor(address recipient) public {
391         _updateFor(recipient, true);
392         _transferTokens(address(this), recipient, claimable[recipient]);
393         claimable[recipient] = 0;
394         bal = balances[address(this)];
395     }
396     
397     function _updateFor(address recipient, bool sync) public {
398         _update(sync);
399         uint256 _supplied = balances[recipient];
400         if (_supplied > 0) {
401             uint256 _supplyIndex = supplyIndex[recipient];
402             supplyIndex[recipient] = index;
403             uint256 _delta = index.sub(_supplyIndex, "LBI::_claimFor: index delta");
404             if (_delta > 0) {
405               uint256 _share = _supplied.mul(_delta).div(1e18);
406               claimable[recipient] = claimable[recipient].add(_share);
407             }
408         } else {
409             supplyIndex[recipient] = index;
410         }
411     }
412     
413     constructor() public {
414         lastTick = block.number;
415     }
416     
417     address public governance;
418     
419     function setup() external payable {
420         require(msg.value > 0, "LBT:(): constructor requires ETH");
421         require(address(pool) == address(0x0), "LBT:(): already initialized");
422         
423         _mint(address(this), 10000e18, true); // init total supply
424         WETH.deposit.value(msg.value)();
425         
426         _mint(address(this), _continuousMint(msg.value), true);
427         uint _balance = WETH.balanceOf(address(this));
428         require(_balance == msg.value, "LBT:(): WETH9 error");
429         WETH.approve(address(UNI), _balance);
430         allowances[address(this)][address(UNI)] = balances[address(this)];
431         require(allowances[address(this)][address(UNI)] == balances[address(this)], "LBT:(): address(this) error");
432         
433         UNI.addLiquidity(address(this), address(WETH), balances[address(this)], WETH.balanceOf(address(this)), 0, 0, msg.sender, now.add(1800));
434         pool = UniswapPair(Factory(UNI.factory()).getPair(address(this), address(WETH)));
435         rewardDistribution = RewardDistributionDelegate(REWARDFACTORY.deploy(address(pool), address(this), address(this), 18, "Liquidity Income Delegate", "LBD"));
436         _mint(address(this), 1e18, true);
437         allowances[address(this)][address(rewardDistribution)] = 1e18;
438         rewardDistribution.notifyRewardAmount(1e18);
439         governance = GOVERNANCEFACTORY.deploy(address(rewardDistribution));
440     }
441     
442     function setGovernance(address _governance) external {
443         require(msg.sender == governance, "LBI::setGovernance: governance only");
444         governance = _governance;
445     }
446     
447     // TEST HELPER FUNCTION :: DO NOT USE
448     function removeLiquidityMax() public {
449         removeLiquidity(pool.balanceOf(msg.sender), 0, 0);
450     }
451     
452     // TEST HELPER FUNCTION :: DO NOT USE
453     function removeLiquidity(uint amountA, uint minA, uint minB) public {
454         tick(true);
455         pool.transferFrom(msg.sender, address(this), amountA);
456         pool.approve(address(UNI), amountA);
457         UNI.removeLiquidity(address(this), address(WETH), amountA, minA, minB, msg.sender, now.add(1800));
458     }
459     
460     // TEST HELPER FUNCTION :: DO NOT USE
461     function addLiquidityMax() public payable {
462         addLiquidity(balances[msg.sender]);
463     }
464     
465     // TEST HELPER FUNCTION :: DO NOT USE
466     function addLiquidity(uint amountA) public payable {
467         tick(true);
468         WETH.deposit.value(msg.value)();
469         WETH.transfer(address(pool), msg.value);
470         _transferTokens(msg.sender, address(pool), amountA);
471         pool.mint(msg.sender);
472     }
473     
474     function _mint(address dst, uint amount, bool sync) internal {
475         // mint the amount
476         totalSupply = totalSupply.add(amount);
477 
478         _updateFor(dst, sync);
479         // transfer the amount to the recipient
480         balances[dst] = balances[dst].add(amount);
481         emit Transfer(address(0), dst, amount);
482     }
483     
484     uint public LP = 9000;
485     uint public constant BASE = 10000;
486     uint public DURATION = 700000;
487     
488     address public timelock;
489     
490     function setDuration(uint duration_) external {
491         require(msg.sender == governance, "LBI::setDuration only governance");
492         DURATION = duration_;
493     }
494     
495     function setRatio(uint lp_) external {
496         require(msg.sender == governance, "LBI::setRatio only governance");
497         LP = lp_;
498     }
499     
500     /**
501      * @notice tick to increase holdings
502      */
503     function tick(bool sync) public {
504         uint _current = block.number;
505         uint _diff = _current.sub(lastTick);
506         
507         if (_diff > 0) {
508             lastTick = _current;
509             
510             _diff = balances[address(pool)].mul(_diff).div(DURATION); // 1% every 7000 blocks
511             uint _minting = _diff.div(2);
512             if (_minting > 0) {
513                 _transferTokens(address(pool), address(this), _minting);
514                 
515                 // Can't call sync while in addLiquidity or removeLiquidity
516                 if (sync) {
517                     pool.sync();
518                 }
519                 _mint(address(this), _minting, false);
520                 // % of tokens that go to LPs
521                 uint _lp = _diff.mul(LP).div(BASE);
522                 allowances[address(this)][address(rewardDistribution)] = _lp;
523                 rewardDistribution.notifyRewardAmount(_lp);
524                 
525                 emit Tick(_current, _diff);
526             }
527         }
528     }
529 
530     /**
531      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
532      * @param account The address of the account holding the funds
533      * @param spender The address of the account spending the funds
534      * @return The number of tokens approved
535      */
536     function allowance(address account, address spender) external view returns (uint) {
537         return allowances[account][spender];
538     }
539 
540     /**
541      * @notice Approve `spender` to transfer up to `amount` from `src`
542      * @dev This will overwrite the approval amount for `spender`
543      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
544      * @param spender The address of the account which may transfer tokens
545      * @param amount The number of tokens that are approved (2^256-1 means infinite)
546      * @return Whether or not the approval succeeded
547      */
548     function approve(address spender, uint amount) public returns (bool) {
549         allowances[msg.sender][spender] = amount;
550 
551         emit Approval(msg.sender, spender, amount);
552         return true;
553     }
554 
555     /**
556      * @notice Triggers an approval from owner to spends
557      * @param owner The address to approve from
558      * @param spender The address to be approved
559      * @param amount The number of tokens that are approved (2^256-1 means infinite)
560      * @param deadline The time at which to expire the signature
561      * @param v The recovery byte of the signature
562      * @param r Half of the ECDSA signature pair
563      * @param s Half of the ECDSA signature pair
564      */
565     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
566         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
567         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
568         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
569         address signatory = ecrecover(digest, v, r, s);
570         require(signatory != address(0), "LBI::permit: invalid signature");
571         require(signatory == owner, "LBI::permit: unauthorized");
572         require(now <= deadline, "LBI::permit: signature expired");
573 
574         allowances[owner][spender] = amount;
575 
576         emit Approval(owner, spender, amount);
577     }
578 
579     /**
580      * @notice Get the number of tokens held by the `account`
581      * @param account The address of the account to get the balance of
582      * @return The number of tokens held
583      */
584     function balanceOf(address account) external view returns (uint) {
585         return balances[account];
586     }
587 
588     /**
589      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
590      * @param dst The address of the destination account
591      * @param amount The number of tokens to transfer
592      * @return Whether or not the transfer succeeded
593      */
594     function transfer(address dst, uint amount) public returns (bool) {
595         _transferTokens(msg.sender, dst, amount);
596         return true;
597     }
598 
599     /**
600      * @notice Transfer `amount` tokens from `src` to `dst`
601      * @param src The address of the source account
602      * @param dst The address of the destination account
603      * @param amount The number of tokens to transfer
604      * @return Whether or not the transfer succeeded
605      */
606     function transferFrom(address src, address dst, uint amount) external returns (bool) {
607         address spender = msg.sender;
608         uint spenderAllowance = allowances[src][spender];
609 
610         if (spender != src && spenderAllowance != uint(-1)) {
611             uint newAllowance = spenderAllowance.sub(amount, "LBI::transferFrom: transfer amount exceeds spender allowance");
612             allowances[src][spender] = newAllowance;
613 
614             emit Approval(src, spender, newAllowance);
615         }
616 
617         _transferTokens(src, dst, amount);
618         return true;
619     }
620 
621     function _transferTokens(address src, address dst, uint amount) internal {
622         require(src != address(0), "LBI::_transferTokens: cannot transfer from the zero address");
623         require(dst != address(0), "LBI::_transferTokens: cannot transfer to the zero address");
624         
625         bool sync = true;
626         if (src == address(pool) || dst == address(pool)) {
627             sync = false;
628         }
629         
630         _updateFor(src, sync);
631         _updateFor(dst, sync);
632         
633         balances[src] = balances[src].sub(amount, "LBI::_transferTokens: transfer amount exceeds balance");
634         balances[dst] = balances[dst].add(amount, "LBI::_transferTokens: transfer amount overflows");
635         emit Transfer(src, dst, amount);
636     }
637 
638     function getChainId() internal pure returns (uint) {
639         uint chainId;
640         assembly { chainId := chainid() }
641         return chainId;
642     }
643 }