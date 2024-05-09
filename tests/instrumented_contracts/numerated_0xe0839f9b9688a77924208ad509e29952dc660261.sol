1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function decimals() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library Address {
17     function isContract(address account) internal view returns (bool) {
18         bytes32 codehash;
19         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
20         // solhint-disable-next-line no-inline-assembly
21         assembly { codehash := extcodehash(account) }
22         return (codehash != 0x0 && codehash != accountHash);
23     }
24 }
25 
26 library SafeERC20 {
27     using Address for address;
28 
29     function safeTransfer(IERC20 token, address to, uint value) internal {
30         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
31     }
32 
33     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
34         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
35     }
36 
37     function safeApprove(IERC20 token, address spender, uint value) internal {
38         require((value == 0) || (token.allowance(address(this), spender) == 0),
39             "SafeERC20: approve from non-zero to non-zero allowance"
40         );
41         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
42     }
43     function callOptionalReturn(IERC20 token, bytes memory data) private {
44         require(address(token).isContract(), "SafeERC20: call to non-contract");
45 
46         // solhint-disable-next-line avoid-low-level-calls
47         (bool success, bytes memory returndata) = address(token).call(data);
48         require(success, "SafeERC20: low-level call failed");
49 
50         if (returndata.length > 0) { // Return data is optional
51             // solhint-disable-next-line max-line-length
52             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
53         }
54     }
55 }
56 
57 interface Oracle {
58     function getPriceUSD(address reserve) external view returns (uint);
59 }
60 
61 interface ISushiswapV2Factory {
62     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
63 
64     function feeTo() external view returns (address);
65     function feeToSetter() external view returns (address);
66 
67     function getPair(address tokenA, address tokenB) external view returns (address pair);
68     function allPairs(uint) external view returns (address pair);
69     function allPairsLength() external view returns (uint);
70 
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72 
73     function setFeeTo(address) external;
74     function setFeeToSetter(address) external;
75 }
76 
77 interface ISushiswapV2Pair {
78     event Approval(address indexed owner, address indexed spender, uint value);
79     event Transfer(address indexed from, address indexed to, uint value);
80 
81     function name() external pure returns (string memory);
82     function symbol() external pure returns (string memory);
83     function decimals() external pure returns (uint8);
84     function totalSupply() external view returns (uint);
85     function balanceOf(address owner) external view returns (uint);
86     function allowance(address owner, address spender) external view returns (uint);
87 
88     function approve(address spender, uint value) external returns (bool);
89     function transfer(address to, uint value) external returns (bool);
90     function transferFrom(address from, address to, uint value) external returns (bool);
91 
92     function DOMAIN_SEPARATOR() external view returns (bytes32);
93     function PERMIT_TYPEHASH() external pure returns (bytes32);
94     function nonces(address owner) external view returns (uint);
95 
96     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
97 
98     event Mint(address indexed sender, uint amount0, uint amount1);
99     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
100     event Swap(
101         address indexed sender,
102         uint amount0In,
103         uint amount1In,
104         uint amount0Out,
105         uint amount1Out,
106         address indexed to
107     );
108     event Sync(uint112 reserve0, uint112 reserve1);
109 
110     function MINIMUM_LIQUIDITY() external pure returns (uint);
111     function factory() external view returns (address);
112     function token0() external view returns (address);
113     function token1() external view returns (address);
114     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
115     function price0CumulativeLast() external view returns (uint);
116     function price1CumulativeLast() external view returns (uint);
117     function kLast() external view returns (uint);
118 
119     function mint(address to) external returns (uint liquidity);
120     function burn(address to) external returns (uint amount0, uint amount1);
121     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
122     function skim(address to) external;
123     function sync() external;
124 
125     function initialize(address, address) external;
126 }
127 
128 /**
129  * @dev Contract module that helps prevent reentrant calls to a function.
130  *
131  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
132  * available, which can be applied to functions to make sure there are no nested
133  * (reentrant) calls to them.
134  *
135  * Note that because there is a single `nonReentrant` guard, functions marked as
136  * `nonReentrant` may not call one another. This can be worked around by making
137  * those functions `private`, and then adding `external` `nonReentrant` entry
138  * points to them.
139  *
140  * TIP: If you would like to learn more about reentrancy and alternative ways
141  * to protect against it, check out our blog post
142  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
143  */
144 abstract contract ReentrancyGuard {
145     // Booleans are more expensive than uint256 or any type that takes up a full
146     // word because each write operation emits an extra SLOAD to first read the
147     // slot's contents, replace the bits taken up by the boolean, and then write
148     // back. This is the compiler's defense against contract upgrades and
149     // pointer aliasing, and it cannot be disabled.
150 
151     // The values being non-zero value makes deployment a bit more expensive,
152     // but in exchange the refund on every call to nonReentrant will be lower in
153     // amount. Since refunds are capped to a percentage of the total
154     // transaction's gas, it is best to keep them low in cases like this one, to
155     // increase the likelihood of the full refund coming into effect.
156     uint256 private constant _NOT_ENTERED = 1;
157     uint256 private constant _ENTERED = 2;
158 
159     uint256 private _status;
160 
161     constructor () {
162         _status = _NOT_ENTERED;
163     }
164 
165     /**
166      * @dev Prevents a contract from calling itself, directly or indirectly.
167      * Calling a `nonReentrant` function from another `nonReentrant`
168      * function is not supported. It is possible to prevent this from happening
169      * by making the `nonReentrant` function external, and make it call a
170      * `private` function that does the actual work.
171      */
172     modifier nonReentrant() {
173         // On the first call to nonReentrant, _notEntered will be true
174         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
175 
176         // Any calls to nonReentrant after this point will fail
177         _status = _ENTERED;
178 
179         _;
180 
181         // By storing the original value once again, a refund is triggered (see
182         // https://eips.ethereum.org/EIPS/eip-2200)
183         _status = _NOT_ENTERED;
184     }
185 }
186 
187 
188 
189 library SushiswapV2Library {
190     // returns sorted token addresses, used to handle return values from pairs sorted in this order
191     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
192         require(tokenA != tokenB, 'SushiswapV2Library: IDENTICAL_ADDRESSES');
193         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
194         require(token0 != address(0), 'SushiswapV2Library: ZERO_ADDRESS');
195     }
196 
197     // calculates the CREATE2 address for a pair without making any external calls
198     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
199         (address token0, address token1) = sortTokens(tokenA, tokenB);
200         pair = address(uint160(uint(keccak256(abi.encodePacked(
201                 hex'ff',
202                 factory,
203                 keccak256(abi.encodePacked(token0, token1)),
204                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
205             )))));
206     }
207 
208     // fetches and sorts the reserves for a pair
209     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
210         (address token0,) = sortTokens(tokenA, tokenB);
211         (uint reserve0, uint reserve1,) = ISushiswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
212         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
213     }
214     
215 
216     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
217     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
218         require(amountA > 0, 'SushiswapV2Library: INSUFFICIENT_AMOUNT');
219         require(reserveA > 0 && reserveB > 0, 'SushiswapV2Library: INSUFFICIENT_LIQUIDITY');
220         amountB = amountA * reserveB / reserveA;
221     }
222 }
223 
224 /**
225  * @dev Standard math utilities missing in the Solidity language.
226  */
227 library Math {
228     /**
229      * @dev Returns the largest of two numbers.
230      */
231     function max(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a >= b ? a : b;
233     }
234 
235     /**
236      * @dev Returns the smallest of two numbers.
237      */
238     function min(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a < b ? a : b;
240     }
241 
242     /**
243      * @dev Returns the average of two numbers. The result is rounded towards
244      * zero.
245      */
246     function average(uint256 a, uint256 b) internal pure returns (uint256) {
247         // (a + b) / 2 can overflow, so we distribute
248         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
249     }
250 }
251 
252 contract StableYieldCredit is ReentrancyGuard {
253     using SafeERC20 for IERC20;
254 
255     /// @notice EIP-20 token name for this token
256     string public constant name = "Stable Yield Credit";
257 
258     /// @notice EIP-20 token symbol for this token
259     string public constant symbol = "yCREDIT";
260 
261     /// @notice EIP-20 token decimals for this token
262     uint8 public constant decimals = 8;
263 
264     /// @notice Total number of tokens in circulation
265     uint public totalSupply = 0;
266     
267     /// @notice Total number of tokens staked for yield
268     uint public stakedSupply = 0;
269 
270     mapping(address => mapping (address => uint)) internal allowances;
271     mapping(address => uint) internal balances;
272     mapping(address => uint) public stakes;
273 
274     /// @notice The EIP-712 typehash for the contract's domain
275     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
276     bytes32 public immutable DOMAINSEPARATOR;
277 
278     /// @notice The EIP-712 typehash for the permit struct used by the contract
279     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
280 
281     /// @notice A record of states for signing / validating signatures
282     mapping (address => uint) public nonces;
283 
284     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
285         require(n < 2**32, errorMessage);
286         return uint32(n);
287     }
288 
289     /// @notice The standard EIP-20 transfer event
290     event Transfer(address indexed from, address indexed to, uint amount);
291     
292     /// @notice Stake event for claiming rewards
293     event Staked(address indexed from, uint amount);
294     
295     // @notice Unstake event
296     event Unstaked(address indexed from, uint amount);
297     
298     event Earned(address indexed from, uint amount);
299     event Fees(uint amount);
300 
301     /// @notice The standard EIP-20 approval event
302     event Approval(address indexed owner, address indexed spender, uint amount);
303 
304     // Oracle used for price debt data (external to the AMM balance to avoid internal manipulation)
305     Oracle public constant LINK = Oracle(0x271bf4568fb737cc2e6277e9B1EE0034098cDA2a);
306     ISushiswapV2Factory public constant FACTORY = ISushiswapV2Factory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);
307     
308     // user => token => collateral
309     mapping (address => mapping(address => uint)) public collateral;
310     // user => token => credit
311     mapping (address => mapping(address => uint)) public collateralCredit;
312     
313     address[] private _markets;
314     mapping (address => bool) pairs;
315     
316     uint public rewardRate = 0;
317     uint public periodFinish = 0;
318     uint public DURATION = 7 days;
319     uint public lastUpdateTime;
320     uint public rewardPerTokenStored;
321     
322     mapping(address => uint) public userRewardPerTokenPaid;
323     mapping(address => uint) public rewards;
324     
325     event Deposit(address indexed creditor, address indexed collateral, uint creditOut, uint amountIn, uint creditMinted);
326     event Withdraw(address indexed creditor, address indexed collateral, uint creditIn, uint creditOut, uint amountOut);
327     
328     constructor () {
329         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
330     }
331     
332     uint public FEE = 50;
333     uint public BASE = 10000;
334     
335     function lastTimeRewardApplicable() public view returns (uint) {
336         return Math.min(block.timestamp, periodFinish);
337     }
338     
339     function rewardPerToken() public view returns (uint) {
340         if (stakedSupply == 0) {
341             return rewardPerTokenStored;
342         }
343         return
344             rewardPerTokenStored +
345                 ((lastTimeRewardApplicable() - 
346                 lastUpdateTime) * 
347                 rewardRate * 1e18 / stakedSupply);
348     }
349     
350     function earned(address account) public view returns (uint) {
351         return (stakes[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18) + rewards[account];
352     }
353 
354     function getRewardForDuration() external view returns (uint) {
355         return rewardRate * DURATION;
356     }
357     
358     modifier updateReward(address account) {
359         rewardPerTokenStored = rewardPerToken();
360         lastUpdateTime = lastTimeRewardApplicable();
361         if (account != address(0)) {
362             rewards[account] = earned(account);
363             userRewardPerTokenPaid[account] = rewardPerTokenStored;
364         }
365         _;
366     }
367     
368     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
369         require(amount > 0, "Cannot stake 0");
370         stakedSupply += amount;
371         stakes[msg.sender] += amount;
372         _transferTokens(msg.sender, address(this), amount);
373         emit Staked(msg.sender, amount);
374     }
375 
376     function unstake(uint amount) public nonReentrant updateReward(msg.sender) {
377         require(amount > 0, "Cannot withdraw 0");
378         stakedSupply -= amount;
379         stakes[msg.sender] -= amount;
380         _transferTokens(address(this), msg.sender, amount);
381         emit Unstaked(msg.sender, amount);
382     }
383 
384     function getReward() public nonReentrant updateReward(msg.sender) {
385         uint256 reward = rewards[msg.sender];
386         if (reward > 0) {
387             rewards[msg.sender] = 0;
388             _transferTokens(address(this), msg.sender, reward);
389             emit Earned(msg.sender, reward);
390         }
391     }
392 
393     function exit() external {
394         unstake(stakes[msg.sender]);
395         getReward();
396     }
397     
398     function notifyFeeAmount(uint reward) internal updateReward(address(0)) {
399         if (block.timestamp >= periodFinish) {
400             rewardRate = reward / DURATION;
401         } else {
402             uint remaining = periodFinish - block.timestamp;
403             uint leftover = remaining * rewardRate;
404             rewardRate = (reward + leftover) / DURATION;
405         }
406 
407         // Ensure the provided reward amount is not more than the balance in the contract.
408         // This keeps the reward rate in the right range, preventing overflows due to
409         // very high values of rewardRate in the earned and rewardsPerToken functions;
410         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
411         uint balance = balances[address(this)];
412         require(rewardRate <= balance / DURATION, "Provided reward too high");
413 
414         lastUpdateTime = block.timestamp;
415         periodFinish = block.timestamp + DURATION;
416         emit Fees(reward);
417     }
418     
419     function markets() external view returns (address[] memory) {
420         return _markets;
421     }
422     
423     function _mint(address dst, uint amount) internal {
424         // mint the amount
425         totalSupply += amount;
426         // transfer the amount to the recipient
427         balances[dst] += amount;
428         emit Transfer(address(0), dst, amount);
429     }
430     
431     function _burn(address dst, uint amount) internal {
432         // burn the amount
433         totalSupply -= amount;
434         // transfer the amount from the recipient
435         balances[dst] -= amount;
436         emit Transfer(dst, address(0), amount);
437     }
438     
439     function depositAll(IERC20 token) external {
440         _deposit(token, token.balanceOf(msg.sender));
441     }
442     
443     function deposit(IERC20 token, uint amount) external {
444         _deposit(token, amount);
445     }
446     
447     function _addLiquidity(
448         address tokenA,
449         address tokenB,
450         uint amountADesired,
451         uint amountBDesired
452     ) internal virtual returns (address pair, uint amountA, uint amountB) {
453         // create the pair if it doesn't exist yet
454         pair = FACTORY.getPair(tokenA, tokenB);
455         if (pair == address(0)) {
456             pair = FACTORY.createPair(tokenA, tokenB);
457             pairs[pair] = true;
458             _markets.push(tokenA);
459         } else if (!pairs[pair]) {
460             pairs[pair] = true;
461             _markets.push(tokenA);
462         }
463         
464         (uint reserveA, uint reserveB) = SushiswapV2Library.getReserves(address(FACTORY), tokenA, tokenB);
465         if (reserveA == 0 && reserveB == 0) {
466             (amountA, amountB) = (amountADesired, amountBDesired);
467         } else {
468             uint amountBOptimal = SushiswapV2Library.quote(amountADesired, reserveA, reserveB);
469             if (amountBOptimal <= amountBDesired) {
470                 (amountA, amountB) = (amountADesired, amountBOptimal);
471             } else {
472                 uint amountAOptimal = SushiswapV2Library.quote(amountBDesired, reserveB, reserveA);
473                 assert(amountAOptimal <= amountADesired);
474                 (amountA, amountB) = (amountAOptimal, amountBDesired);
475             }
476         }
477     }
478     
479     function _deposit(IERC20 token, uint amount) internal {
480         uint _value = LINK.getPriceUSD(address(token)) * amount / uint256(10)**token.decimals();
481         require(_value > 0, "!value");
482         
483         (address _pair, uint amountA,) = _addLiquidity(address(token), address(this), amount, _value);
484         
485         token.safeTransferFrom(msg.sender, _pair, amountA);
486         _mint(_pair, _value); // Amount of scUSD to mint
487         
488         uint _liquidity = ISushiswapV2Pair(_pair).mint(address(this));
489         collateral[msg.sender][address(token)] += _liquidity;
490         
491         collateralCredit[msg.sender][address(token)] += _value;
492         uint _fee = _value * FEE / BASE;
493         _mint(msg.sender, _value - _fee);
494         _mint(address(this), _fee);
495         notifyFeeAmount(_fee);
496         
497         emit Deposit(msg.sender, address(token), _value, amount, _value);
498     }
499     
500     function withdrawAll(IERC20 token) external {
501         _withdraw(token, IERC20(address(this)).balanceOf(msg.sender));
502     }
503     
504     function withdraw(IERC20 token, uint amount) external {
505         _withdraw(token, amount);
506     }
507     
508     function _withdraw(IERC20 token, uint amount) internal {
509         uint _credit = collateralCredit[msg.sender][address(token)];
510         uint _collateral = collateral[msg.sender][address(token)];
511         
512         if (_credit < amount) {
513             amount = _credit;
514         }
515         
516         // Calculate % of collateral to release
517         uint _burned = _collateral * amount / _credit;
518         address _pair = FACTORY.getPair(address(token), address(this));
519         
520         IERC20(_pair).safeTransfer(_pair, _burned); // send liquidity to pair
521         (uint _amount0, uint _amount1) = ISushiswapV2Pair(_pair).burn(msg.sender);
522         (address _token0,) = SushiswapV2Library.sortTokens(address(token), address(this));
523         (uint _amountA, uint _amountB) = address(token) == _token0 ? (_amount0, _amount1) : (_amount1, _amount0);
524         
525         collateralCredit[msg.sender][address(token)] -= amount;
526         collateral[msg.sender][address(token)] -= _burned;
527         _burn(msg.sender, _amountB+amount); // Amount of scUSD to burn (value of A leaving the system)
528         
529         emit Withdraw(msg.sender, address(token), amount, _amountB, _amountA);
530     }
531 
532     /**
533      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
534      * @param account The address of the account holding the funds
535      * @param spender The address of the account spending the funds
536      * @return The number of tokens approved
537      */
538     function allowance(address account, address spender) external view returns (uint) {
539         return allowances[account][spender];
540     }
541 
542     /**
543      * @notice Approve `spender` to transfer up to `amount` from `src`
544      * @dev This will overwrite the approval amount for `spender`
545      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
546      * @param spender The address of the account which may transfer tokens
547      * @param amount The number of tokens that are approved (2^256-1 means infinite)
548      * @return Whether or not the approval succeeded
549      */
550     function approve(address spender, uint amount) external returns (bool) {
551         allowances[msg.sender][spender] = amount;
552 
553         emit Approval(msg.sender, spender, amount);
554         return true;
555     }
556 
557     /**
558      * @notice Triggers an approval from owner to spends
559      * @param owner The address to approve from
560      * @param spender The address to be approved
561      * @param amount The number of tokens that are approved (2^256-1 means infinite)
562      * @param deadline The time at which to expire the signature
563      * @param v The recovery byte of the signature
564      * @param r Half of the ECDSA signature pair
565      * @param s Half of the ECDSA signature pair
566      */
567     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
568         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
569         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
570         address signatory = ecrecover(digest, v, r, s);
571         require(signatory != address(0), "permit: signature");
572         require(signatory == owner, "permit: unauthorized");
573         require(block.timestamp <= deadline, "permit: expired");
574 
575         allowances[owner][spender] = amount;
576 
577         emit Approval(owner, spender, amount);
578     }
579 
580     /**
581      * @notice Get the number of tokens held by the `account`
582      * @param account The address of the account to get the balance of
583      * @return The number of tokens held
584      */
585     function balanceOf(address account) external view returns (uint) {
586         return balances[account];
587     }
588 
589     /**
590      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
591      * @param dst The address of the destination account
592      * @param amount The number of tokens to transfer
593      * @return Whether or not the transfer succeeded
594      */
595     function transfer(address dst, uint amount) external returns (bool) {
596         _transferTokens(msg.sender, dst, amount);
597         return true;
598     }
599 
600     /**
601      * @notice Transfer `amount` tokens from `src` to `dst`
602      * @param src The address of the source account
603      * @param dst The address of the destination account
604      * @param amount The number of tokens to transfer
605      * @return Whether or not the transfer succeeded
606      */
607     function transferFrom(address src, address dst, uint amount) external returns (bool) {
608         address spender = msg.sender;
609         uint spenderAllowance = allowances[src][spender];
610 
611         if (spender != src && spenderAllowance != type(uint).max) {
612             uint newAllowance = spenderAllowance - amount;
613             allowances[src][spender] = newAllowance;
614 
615             emit Approval(src, spender, newAllowance);
616         }
617 
618         _transferTokens(src, dst, amount);
619         return true;
620     }
621 
622     function _transferTokens(address src, address dst, uint amount) internal {
623         balances[src] -= amount;
624         balances[dst] += amount;
625         
626         emit Transfer(src, dst, amount);
627         
628         if (pairs[src]) {
629             uint _fee = amount * FEE / BASE;
630             _transferTokens(dst, address(this), _fee);
631             notifyFeeAmount(_fee);
632         }
633     }
634 
635     function _getChainId() internal view returns (uint) {
636         uint chainId;
637         assembly { chainId := chainid() }
638         return chainId;
639     }
640 }