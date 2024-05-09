1 // SPDX-License-Identifier: MIT
2 
3 
4 /**
5  * KEEPERFI.COM
6  * Optimized Dapp
7  * Clean & tested code
8  */
9 
10 
11 pragma solidity ^0.6.12;
12 
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint) {
16         uint c = a + b;
17         require(c >= a, "add: +");
18 
19         return c;
20     }
21    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
22         uint c = a + b;
23         require(c >= a, errorMessage);
24 
25         return c;
26     }
27    function sub(uint a, uint b) internal pure returns (uint) {
28         return sub(a, b, "sub: -");
29     }
30    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
31         require(b <= a, errorMessage);
32         uint c = a - b;
33 
34         return c;
35     }
36   function mul(uint a, uint b) internal pure returns (uint) {
37        if (a == 0) {
38             return 0;
39         }
40         uint c = a * b;
41         require(c / a == b, "mul: *");
42 
43         return c;
44     }
45   function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
46        if (a == 0) {
47             return 0;
48         }
49         uint c = a * b;
50         require(c / a == b, errorMessage);
51         return c;
52     }
53   function div(uint a, uint b) internal pure returns (uint) {
54         return div(a, b, "div: /");
55     }
56   function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
57         require(b > 0, errorMessage);
58         uint c = a / b;
59         return c;
60     }
61    function mod(uint a, uint b) internal pure returns (uint) {
62         return mod(a, b, "mod: %");
63     }
64   function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
65         require(b != 0, errorMessage);
66         return a % b;
67     }
68 }
69 
70 
71 contract ReentrancyGuard {
72    uint256 private constant _NOT_ENTERED = 1;
73     uint256 private constant _ENTERED = 2;
74 
75     uint256 private _status;
76 
77     constructor () internal {
78         _status = _NOT_ENTERED;
79     }
80 
81     modifier nonReentrant() {
82        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
83        _status = _ENTERED;
84        _;
85        _status = _NOT_ENTERED;
86     }
87 }
88 
89 
90 interface IERC20 {
91     function totalSupply() external view returns (uint256);
92     function balanceOf(address account) external view returns (uint256);
93     function transfer(address recipient, uint256 amount) external returns (bool);
94     function allowance(address owner, address spender) external view returns (uint256);
95     function approve(address spender, uint256 amount) external returns (bool);
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97     event Transfer(address indexed from, address indexed to, uint256 value);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99     }
100 
101 library Address {
102     function isContract(address account) internal view returns (bool) {
103         bytes32 codehash;
104         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
105         // solhint-disable-next-line no-inline-assembly
106         assembly { codehash := extcodehash(account) }
107         return (codehash != accountHash && codehash != 0x0);
108     }
109     function toPayable(address account) internal pure returns (address payable) {
110         return address(uint160(account));
111     }
112    function sendValue(address payable recipient, uint256 amount) internal {
113         require(address(this).balance >= amount, "Address: insufficient");
114 
115         // solhint-disable-next-line avoid-call-value
116         (bool success, ) = recipient.call{value:amount}("");
117         require(success, "Address: reverted");
118     }
119 }
120 library SafeERC20 {
121     using SafeMath for uint256;
122     using Address for address;
123 
124     function safeTransfer(IERC20 token, address to, uint256 value) internal {
125         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
126     }
127 
128     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
129         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
130     }
131 
132     function safeApprove(IERC20 token, address spender, uint256 value) internal {
133         // solhint-disable-next-line max-line-length
134         require((value == 0) || (token.allowance(address(this), spender) == 0),
135             "SafeERC20: approve from non-zero to non-zero allowance"
136         );
137         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
138     }
139 
140     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
141         uint256 newAllowance = token.allowance(address(this), spender).add(value);
142         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
143     }
144 
145     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
146         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: < 0");
147         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
148     }
149 
150     function callOptionalReturn(IERC20 token, bytes memory data) private {
151            // solhint-disable-next-line max-line-length
152         require(address(token).isContract(), "SafeERC20: !contract");
153         // solhint-disable-next-line avoid-low-level-calls
154         (bool success, bytes memory returndata) = address(token).call(data);
155         require(success, "SafeERC20: low-level call failed");
156      if (returndata.length > 0) { // Return data is optional
157             // solhint-disable-next-line max-line-length
158             require(abi.decode(returndata, (bool)), "SafeERC20: !succeed");
159         }
160     }
161 }
162 
163 library KeeperFiLibrary {
164     function getReserve(address pair, address reserve) external view returns (uint) {
165         (uint _r0, uint _r1,) = IUniswapV2Pair(pair).getReserves();
166         if (IUniswapV2Pair(pair).token0() == reserve) {
167             return _r0;
168         } else if (IUniswapV2Pair(pair).token1() == reserve) {
169             return _r1;
170         } else {
171             return 0;
172         }
173     }
174 }
175 
176 interface IUniswapV2Pair {
177     event Approval(address indexed owner, address indexed spender, uint value);
178     event Transfer(address indexed from, address indexed to, uint value);
179 
180     function name() external pure returns (string memory);
181     function symbol() external pure returns (string memory);
182     function decimals() external pure returns (uint8);
183     function totalSupply() external view returns (uint);
184     function balanceOf(address owner) external view returns (uint);
185     function allowance(address owner, address spender) external view returns (uint);
186 
187     function approve(address spender, uint value) external returns (bool);
188     function transfer(address to, uint value) external returns (bool);
189     function transferFrom(address from, address to, uint value) external returns (bool);
190 
191     function DOMAIN_SEPARATOR() external view returns (bytes32);
192     function PERMIT_TYPEHASH() external pure returns (bytes32);
193     function nonces(address owner) external view returns (uint);
194 
195     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
196 
197     event Mint(address indexed sender, uint amount0, uint amount1);
198     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
199     event Swap(
200         address indexed sender,
201         uint amount0In,
202         uint amount1In,
203         uint amount0Out,
204         uint amount1Out,
205         address indexed to
206     );
207     event Sync(uint112 reserve0, uint112 reserve1);
208 
209     function MINIMUM_LIQUIDITY() external pure returns (uint);
210     function factory() external view returns (address);
211     function token0() external view returns (address);
212     function token1() external view returns (address);
213     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
214     function price0CumulativeLast() external view returns (uint);
215     function price1CumulativeLast() external view returns (uint);
216     function kLast() external view returns (uint);
217 
218     function mint(address to) external returns (uint liquidity);
219     function burn(address to) external returns (uint amount0, uint amount1);
220     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
221     function skim(address to) external;
222     function sync() external;
223 
224     function initialize(address, address) external;
225 }
226 
227 interface IGovernance {
228     function proposeJob(address job) external;
229 }
230 
231 interface IKeeperFiHelper {
232     function getQuoteLimit(uint gasUsed) external view returns (uint);
233 }
234 
235 contract KeeperFi is ReentrancyGuard {
236     using SafeMath for uint;
237     using SafeERC20 for IERC20;
238 
239     /// @notice KeeperFi Helper to set max prices for the ecosystem
240     IKeeperFiHelper public KPRH;
241 
242     /// @notice EIP-20 token name for this token
243     string public constant name = "KeeperFi";
244 
245     /// @notice EIP-20 token symbol for this token
246     string public constant symbol = "KFI";
247 
248     /// @notice EIP-20 token decimals for this token
249     uint8 public constant decimals = 18;
250 
251     /// @notice Total number of tokens in circulation
252     uint public totalSupply = 0; // Initial 0
253 
254     /// @notice A record of each accounts delegate
255     mapping (address => address) public delegates;
256 
257     /// @notice A record of votes checkpoints for each account, by index
258     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
259 
260     /// @notice The number of checkpoints for each account
261     mapping (address => uint32) public numCheckpoints;
262 
263     mapping (address => mapping (address => uint)) internal allowances;
264     mapping (address => uint) internal balances;
265 
266     /// @notice The EIP-712 typehash for the contract's domain
267     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
268     bytes32 public immutable DOMAINSEPARATOR;
269 
270     /// @notice The EIP-712 typehash for the delegation struct used by the contract
271     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
272 
273     /// @notice The EIP-712 typehash for the permit struct used by the contract
274     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
275 
276 
277     /// @notice A record of states for signing / validating signatures
278     mapping (address => uint) public nonces;
279 
280     /// @notice An event thats emitted when an account changes its delegate
281     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
282 
283     /// @notice An event thats emitted when a delegate account's vote balance changes
284     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
285 
286     /// @notice A checkpoint for marking number of votes from a given block
287     struct Checkpoint {
288         uint32 fromBlock;
289         uint votes;
290     }
291 
292     function delegate(address delegatee) public {
293         _delegate(msg.sender, delegatee);
294     }
295 
296     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
297         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
298         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
299         address signatory = ecrecover(digest, v, r, s);
300         require(signatory != address(0), "delegateBySig: sig");
301         require(nonce == nonces[signatory]++, "delegateBySig: nonce");
302         require(now <= expiry, "delegateBySig: expired");
303         _delegate(signatory, delegatee);
304     }
305 
306   
307     function getCurrentVotes(address account) external view returns (uint) {
308         uint32 nCheckpoints = numCheckpoints[account];
309         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
310     }
311 
312     function getPriorVotes(address account, uint blockNumber) public view returns (uint) {
313         require(blockNumber < block.number, "getPriorVotes:");
314 
315         uint32 nCheckpoints = numCheckpoints[account];
316         if (nCheckpoints == 0) {
317             return 0;
318         }
319 
320         // First check most recent balance
321         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
322             return checkpoints[account][nCheckpoints - 1].votes;
323         }
324 
325         // Next check implicit zero balance
326         if (checkpoints[account][0].fromBlock > blockNumber) {
327             return 0;
328         }
329 
330         uint32 lower = 0;
331         uint32 upper = nCheckpoints - 1;
332         while (upper > lower) {
333             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
334             Checkpoint memory cp = checkpoints[account][center];
335             if (cp.fromBlock == blockNumber) {
336                 return cp.votes;
337             } else if (cp.fromBlock < blockNumber) {
338                 lower = center;
339             } else {
340                 upper = center - 1;
341             }
342         }
343         return checkpoints[account][lower].votes;
344     }
345 
346     function _delegate(address delegator, address delegatee) internal {
347         address currentDelegate = delegates[delegator];
348         uint delegatorBalance = votes[delegator].add(bonds[delegator][address(this)]);
349         delegates[delegator] = delegatee;
350 
351         emit DelegateChanged(delegator, currentDelegate, delegatee);
352 
353         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
354     }
355 
356     function _moveDelegates(address srcRep, address dstRep, uint amount) internal {
357         if (srcRep != dstRep && amount > 0) {
358             if (srcRep != address(0)) {
359                 uint32 srcRepNum = numCheckpoints[srcRep];
360                 uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
361                 uint srcRepNew = srcRepOld.sub(amount, "_moveVotes: underflows");
362                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
363             }
364 
365             if (dstRep != address(0)) {
366                 uint32 dstRepNum = numCheckpoints[dstRep];
367                 uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
368                 uint dstRepNew = dstRepOld.add(amount);
369                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
370             }
371         }
372     }
373 
374     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {
375       uint32 blockNumber = safe32(block.number, "_writeCheckpoint: 32 bits");
376 
377       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
378           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
379       } else {
380           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
381           numCheckpoints[delegatee] = nCheckpoints + 1;
382       }
383 
384       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
385     }
386 
387     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
388         require(n < 2**32, errorMessage);
389         return uint32(n);
390     }
391 
392     /// @notice The standard EIP-20 transfer event
393     event Transfer(address indexed from, address indexed to, uint amount);
394 
395     /// @notice The standard EIP-20 approval event
396     event Approval(address indexed owner, address indexed spender, uint amount);
397 
398     /// @notice Submit a job
399     event SubmitJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
400 
401     /// @notice Apply credit to a job
402     event ApplyCredit(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
403 
404     /// @notice Remove credit for a job
405     event RemoveJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
406 
407     /// @notice Unbond credit for a job
408     event UnbondJob(address indexed job, address indexed liquidity, address indexed provider, uint block, uint credit);
409 
410     /// @notice Added a Job
411     event JobAdded(address indexed job, uint block, address governance);
412 
413     /// @notice Removed a job
414     event JobRemoved(address indexed job, uint block, address governance);
415 
416     /// @notice Worked a job
417     event KeeperWorked(address indexed credit, address indexed job, address indexed keeper, uint block, uint amount);
418 
419     /// @notice Keeper bonding
420     event KeeperBonding(address indexed keeper, uint block, uint active, uint bond);
421 
422     /// @notice Keeper bonded
423     event KeeperBonded(address indexed keeper, uint block, uint activated, uint bond);
424 
425     /// @notice Keeper unbonding
426     event KeeperUnbonding(address indexed keeper, uint block, uint deactive, uint bond);
427 
428     /// @notice Keeper unbound
429     event KeeperUnbound(address indexed keeper, uint block, uint deactivated, uint bond);
430 
431     /// @notice Keeper slashed
432     event KeeperSlashed(address indexed keeper, address indexed slasher, uint block, uint slash);
433 
434     /// @notice Keeper disputed
435     event KeeperDispute(address indexed keeper, uint block);
436 
437     /// @notice Keeper resolved
438     event KeeperResolved(address indexed keeper, uint block);
439 
440     event AddCredit(address indexed credit, address indexed job, address indexed creditor, uint block, uint amount);
441 
442     /// @notice 1 day to bond to become a keeper
443     uint constant public BOND = 1 days;
444     /// @notice 14 days to unbond to remove funds from being a keeper
445     uint constant public UNBOND = 13 days;
446     /// @notice 3 days till liquidity can be bound
447     uint constant public LIQUIDITYBOND = 1 days;
448 
449     /// @notice direct liquidity fee 0.3%
450     uint constant public FEE = 50;
451     uint constant public BASE = 10000;
452 
453     /// @notice address used for ETH transfers
454     address constant public ETH = address(0xE);
455 
456     /// @notice tracks all current bondings (time)
457     mapping(address => mapping(address => uint)) public bondings;
458     /// @notice tracks all current unbondings (time)
459     mapping(address => mapping(address => uint)) public unbondings;
460     /// @notice allows for partial unbonding
461     mapping(address => mapping(address => uint)) public partialUnbonding;
462     /// @notice tracks all current pending bonds (amount)
463     mapping(address => mapping(address => uint)) public pendingbonds;
464     /// @notice tracks how much a keeper has bonded
465     mapping(address => mapping(address => uint)) public bonds;
466     /// @notice tracks underlying votes (that don't have bond)
467     mapping(address => uint) public votes;
468 
469     /// @notice total bonded (totalSupply for bonds)
470     uint public totalBonded = 0;
471     /// @notice tracks when a keeper was first registered
472     mapping(address => uint) public firstSeen;
473 
474     /// @notice tracks if a keeper has a pending dispute
475     mapping(address => bool) public disputes;
476 
477     /// @notice tracks last job performed for a keeper
478     mapping(address => uint) public lastJob;
479     /// @notice tracks the total job executions for a keeper
480     mapping(address => uint) public workCompleted;
481     /// @notice list of all jobs registered for the keeper system
482     mapping(address => bool) public jobs;
483     /// @notice the current credit available for a job
484     mapping(address => mapping(address => uint)) public credits;
485     /// @notice the balances for the liquidity providers
486     mapping(address => mapping(address => mapping(address => uint))) public liquidityProvided;
487     /// @notice liquidity unbonding days
488     mapping(address => mapping(address => mapping(address => uint))) public liquidityUnbonding;
489     /// @notice liquidity unbonding amounts
490     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmountsUnbonding;
491     /// @notice job proposal delay
492     mapping(address => uint) public jobProposalDelay;
493     /// @notice liquidity apply date
494     mapping(address => mapping(address => mapping(address => uint))) public liquidityApplied;
495     /// @notice liquidity amount to apply
496     mapping(address => mapping(address => mapping(address => uint))) public liquidityAmount;
497 
498     /// @notice list of all current keepers
499     mapping(address => bool) public keepers;
500     /// @notice blacklist of keepers not allowed to participate
501     mapping(address => bool) public blacklist;
502 
503     /// @notice traversable array of keepers to make external management easier
504     address[] public keeperList;
505     /// @notice traversable array of jobs to make external management easier
506     address[] public jobList;
507 
508     /// @notice governance address for the governance contract
509     address public governance;
510     address public pendingGovernance;
511 
512     /// @notice the liquidity token supplied by users paying for jobs
513     mapping(address => bool) public liquidityAccepted;
514 
515     address[] public liquidityPairs;
516 
517     uint internal _gasUsed;
518 
519     constructor(address _kph) public {
520         // Set governance for this token
521         governance = msg.sender;
522         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
523         KPRH = IKeeperFiHelper(_kph);
524     }
525 
526     /**
527      * @notice Add ETH credit to a job to be paid out for work
528      * @param job the job being credited
529      */
530     function addCreditETH(address job) external payable {
531         require(jobs[job], "addCreditETH: !job");
532         uint _fee = msg.value.mul(FEE).div(BASE);
533         credits[job][ETH] = credits[job][ETH].add(msg.value.sub(_fee));
534         payable(governance).transfer(_fee);
535 
536         emit AddCredit(ETH, job, msg.sender, block.number, msg.value);
537     }
538 
539     function addCredit(address credit, address job, uint amount) external nonReentrant {
540         require(jobs[job], "addCreditETH: !job");
541         uint _before = IERC20(credit).balanceOf(address(this));
542         IERC20(credit).safeTransferFrom(msg.sender, address(this), amount);
543         uint _received = IERC20(credit).balanceOf(address(this)).sub(_before);
544         uint _fee = _received.mul(FEE).div(BASE);
545         credits[job][credit] = credits[job][credit].add(_received.sub(_fee));
546         IERC20(credit).safeTransfer(governance, _fee);
547 
548         emit AddCredit(credit, job, msg.sender, block.number, _received);
549     }
550 
551     function addVotes(address voter, uint amount) external {
552         require(msg.sender == governance, "addVotes: !gov");
553         _activate(voter, address(this));
554         votes[voter] = votes[voter].add(amount);
555         totalBonded = totalBonded.add(amount);
556         _moveDelegates(address(0), delegates[voter], amount);
557     }
558 
559  
560     function removeVotes(address voter, uint amount) external {
561         require(msg.sender == governance, "addVotes: !gov");
562         votes[voter] = votes[voter].sub(amount);
563         totalBonded = totalBonded.sub(amount);
564         _moveDelegates(delegates[voter], address(0), amount);
565     }
566 
567     function addKPRCredit(address job, uint amount) external {
568         require(msg.sender == governance, "addKPRCredit: !gov");
569         require(jobs[job], "addKPRCredit: !job");
570         credits[job][address(this)] = credits[job][address(this)].add(amount);
571         _mint(address(this), amount);
572         emit AddCredit(address(this), job, msg.sender, block.number, amount);
573     }
574 
575  
576     function approveLiquidity(address liquidity) external {
577         require(msg.sender == governance, "approveLiquidity: !gov");
578         require(!liquidityAccepted[liquidity], "approveLiquidity: !pair");
579         liquidityAccepted[liquidity] = true;
580         liquidityPairs.push(liquidity);
581     }
582 
583     function revokeLiquidity(address liquidity) external {
584         require(msg.sender == governance, "revokeLiquidity: !gov");
585         liquidityAccepted[liquidity] = false;
586     }
587 
588     function pairs() external view returns (address[] memory) {
589         return liquidityPairs;
590     }
591 
592   
593     function addLiquidityToJob(address liquidity, address job, uint amount) external nonReentrant {
594         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
595         IERC20(liquidity).safeTransferFrom(msg.sender, address(this), amount);
596         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].add(amount);
597 
598         liquidityApplied[msg.sender][liquidity][job] = now.add(LIQUIDITYBOND);
599         liquidityAmount[msg.sender][liquidity][job] = liquidityAmount[msg.sender][liquidity][job].add(amount);
600 
601         if (!jobs[job] && jobProposalDelay[job] < now) {
602             IGovernance(governance).proposeJob(job);
603             jobProposalDelay[job] = now.add(UNBOND);
604         }
605         emit SubmitJob(job, liquidity, msg.sender, block.number, amount);
606     }
607 
608     function applyCreditToJob(address provider, address liquidity, address job) external {
609         require(liquidityAccepted[liquidity], "addLiquidityToJob: !pair");
610         require(liquidityApplied[provider][liquidity][job] != 0, "credit: no bond");
611         require(liquidityApplied[provider][liquidity][job] < now, "credit: bonding");
612         uint _liquidity = KeeperFiLibrary.getReserve(liquidity, address(this));
613         uint _credit = _liquidity.mul(liquidityAmount[provider][liquidity][job]).div(IERC20(liquidity).totalSupply());
614         _mint(address(this), _credit);
615         credits[job][address(this)] = credits[job][address(this)].add(_credit);
616         liquidityAmount[provider][liquidity][job] = 0;
617 
618         emit ApplyCredit(job, liquidity, provider, block.number, _credit);
619     }
620 
621     function unbondLiquidityFromJob(address liquidity, address job, uint amount) external {
622         require(liquidityAmount[msg.sender][liquidity][job] == 0, "credit: pending credit");
623         liquidityUnbonding[msg.sender][liquidity][job] = now.add(UNBOND);
624         liquidityAmountsUnbonding[msg.sender][liquidity][job] = liquidityAmountsUnbonding[msg.sender][liquidity][job].add(amount);
625         require(liquidityAmountsUnbonding[msg.sender][liquidity][job] <= liquidityProvided[msg.sender][liquidity][job], "unbondLiquidityFromJob: insufficient funds");
626 
627         uint _liquidity = KeeperFiLibrary.getReserve(liquidity, address(this));
628         uint _credit = _liquidity.mul(amount).div(IERC20(liquidity).totalSupply());
629         if (_credit > credits[job][address(this)]) {
630             _burn(address(this), credits[job][address(this)]);
631             credits[job][address(this)] = 0;
632         } else {
633             _burn(address(this), _credit);
634             credits[job][address(this)] = credits[job][address(this)].sub(_credit);
635         }
636 
637         emit UnbondJob(job, liquidity, msg.sender, block.number, amount);
638     }
639 
640     function removeLiquidityFromJob(address liquidity, address job) external {
641         require(liquidityUnbonding[msg.sender][liquidity][job] != 0, "removeJob: unbond");
642         require(liquidityUnbonding[msg.sender][liquidity][job] < now, "removeJob: unbonding");
643         uint _amount = liquidityAmountsUnbonding[msg.sender][liquidity][job];
644         liquidityProvided[msg.sender][liquidity][job] = liquidityProvided[msg.sender][liquidity][job].sub(_amount);
645         liquidityAmountsUnbonding[msg.sender][liquidity][job] = 0;
646         IERC20(liquidity).safeTransfer(msg.sender, _amount);
647 
648         emit RemoveJob(job, liquidity, msg.sender, block.number, _amount);
649     }
650 
651     function mint(uint amount) external {
652         require(msg.sender == governance, "mint: !gov");
653         _mint(governance, amount);
654     }
655 
656   
657     function burn(uint amount) external {
658         _burn(msg.sender, amount);
659     }
660 
661     function _mint(address dst, uint amount) internal {
662         totalSupply = totalSupply.add(amount);
663         balances[dst] = balances[dst].add(amount);
664         emit Transfer(address(0), dst, amount);
665     }
666 
667     function _burn(address dst, uint amount) internal {
668         require(dst != address(0), "_burn: zero address");
669         balances[dst] = balances[dst].sub(amount, "_burn: exceeds balance");
670         totalSupply = totalSupply.sub(amount);
671         emit Transfer(dst, address(0), amount);
672     }
673 
674     function worked(address keeper) external {
675         workReceipt(keeper, KPRH.getQuoteLimit(_gasUsed.sub(gasleft())));
676     }
677 
678     function workReceipt(address keeper, uint amount) public {
679         require(jobs[msg.sender], "workReceipt: !job");
680         require(amount <= KPRH.getQuoteLimit(_gasUsed.sub(gasleft())), "workReceipt: max limit");
681         credits[msg.sender][address(this)] = credits[msg.sender][address(this)].sub(amount, "workReceipt: insuffient funds");
682         lastJob[keeper] = now;
683         _reward(keeper, amount);
684         workCompleted[keeper] = workCompleted[keeper].add(amount);
685         emit KeeperWorked(address(this), msg.sender, keeper, block.number, amount);
686     }
687 
688   
689     function receipt(address credit, address keeper, uint amount) external {
690         require(jobs[msg.sender], "receipt: !job");
691         credits[msg.sender][credit] = credits[msg.sender][credit].sub(amount, "workReceipt: insuffient funds");
692         lastJob[keeper] = now;
693         IERC20(credit).safeTransfer(keeper, amount);
694         emit KeeperWorked(credit, msg.sender, keeper, block.number, amount);
695     }
696 
697   
698     function receiptETH(address keeper, uint amount) external {
699         require(jobs[msg.sender], "receipt: !job");
700         credits[msg.sender][ETH] = credits[msg.sender][ETH].sub(amount, "workReceipt: insuffient funds");
701         lastJob[keeper] = now;
702         payable(keeper).transfer(amount);
703         emit KeeperWorked(ETH, msg.sender, keeper, block.number, amount);
704     }
705 
706     function _reward(address _from, uint _amount) internal {
707         bonds[_from][address(this)] = bonds[_from][address(this)].add(_amount);
708         totalBonded = totalBonded.add(_amount);
709         _moveDelegates(address(0), delegates[_from], _amount);
710         emit Transfer(msg.sender, _from, _amount);
711     }
712 
713     function _bond(address bonding, address _from, uint _amount) internal {
714         bonds[_from][bonding] = bonds[_from][bonding].add(_amount);
715         if (bonding == address(this)) {
716             totalBonded = totalBonded.add(_amount);
717             _moveDelegates(address(0), delegates[_from], _amount);
718         }
719     }
720 
721     function _unbond(address bonding, address _from, uint _amount) internal {
722         bonds[_from][bonding] = bonds[_from][bonding].sub(_amount);
723         if (bonding == address(this)) {
724             totalBonded = totalBonded.sub(_amount);
725             _moveDelegates(delegates[_from], address(0), _amount);
726         }
727 
728     }
729 
730     function addJob(address job) external {
731         require(msg.sender == governance, "addJob: !gov");
732         require(!jobs[job], "addJob: job known");
733         jobs[job] = true;
734         jobList.push(job);
735         emit JobAdded(job, block.number, msg.sender);
736     }
737 
738   
739     function getJobs() external view returns (address[] memory) {
740         return jobList;
741     }
742 
743  
744     function removeJob(address job) external {
745         require(msg.sender == governance, "removeJob: !gov");
746         jobs[job] = false;
747         emit JobRemoved(job, block.number, msg.sender);
748     }
749 
750     function setKeeperFiHelper(IKeeperFiHelper _kprh) external {
751         require(msg.sender == governance, "setKeeperFiHelper: !gov");
752         KPRH = _kprh;
753     }
754 
755   
756     function setGovernance(address _governance) external {
757         require(msg.sender == governance, "setGovernance: !gov");
758         pendingGovernance = _governance;
759     }
760 
761     /**
762      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
763      */
764     function acceptGovernance() external {
765         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
766         governance = pendingGovernance;
767     }
768 
769     function isKeeper(address keeper) external returns (bool) {
770         _gasUsed = gasleft();
771         return keepers[keeper];
772     }
773 
774     function isMinKeeper(address keeper, uint minBond, uint earned, uint age) external returns (bool) {
775         _gasUsed = gasleft();
776         return keepers[keeper]
777                 && bonds[keeper][address(this)].add(votes[keeper]) >= minBond
778                 && workCompleted[keeper] >= earned
779                 && now.sub(firstSeen[keeper]) >= age;
780     }
781 
782   
783     function isBondedKeeper(address keeper, address bond, uint minBond, uint earned, uint age) external returns (bool) {
784         _gasUsed = gasleft();
785         return keepers[keeper]
786                 && bonds[keeper][bond] >= minBond
787                 && workCompleted[keeper] >= earned
788                 && now.sub(firstSeen[keeper]) >= age;
789     }
790 
791  
792     function bond(address bonding, uint amount) external nonReentrant {
793         require(!blacklist[msg.sender], "bond: blacklisted");
794         bondings[msg.sender][bonding] = now.add(BOND);
795         if (bonding == address(this)) {
796             _transferTokens(msg.sender, address(this), amount);
797         } else {
798             uint _before = IERC20(bonding).balanceOf(address(this));
799             IERC20(bonding).safeTransferFrom(msg.sender, address(this), amount);
800             amount = IERC20(bonding).balanceOf(address(this)).sub(_before);
801         }
802         pendingbonds[msg.sender][bonding] = pendingbonds[msg.sender][bonding].add(amount);
803         emit KeeperBonding(msg.sender, block.number, bondings[msg.sender][bonding], amount);
804     }
805 
806    
807     function getKeepers() external view returns (address[] memory) {
808         return keeperList;
809     }
810 
811   
812     function activate(address bonding) external {
813         require(!blacklist[msg.sender], "activate: blacklisted");
814         require(bondings[msg.sender][bonding] != 0 && bondings[msg.sender][bonding] < now, "activate: bonding");
815         _activate(msg.sender, bonding);
816     }
817     
818     function _activate(address keeper, address bonding) internal {
819         if (firstSeen[keeper] == 0) {
820           firstSeen[keeper] = now;
821           keeperList.push(keeper);
822           lastJob[keeper] = now;
823         }
824         keepers[keeper] = true;
825         _bond(bonding, keeper, pendingbonds[keeper][bonding]);
826         pendingbonds[keeper][bonding] = 0;
827         emit KeeperBonded(keeper, block.number, block.timestamp, bonds[keeper][bonding]);
828     }
829 
830   
831     function unbond(address bonding, uint amount) external {
832         unbondings[msg.sender][bonding] = now.add(UNBOND);
833         _unbond(bonding, msg.sender, amount);
834         partialUnbonding[msg.sender][bonding] = partialUnbonding[msg.sender][bonding].add(amount);
835         emit KeeperUnbonding(msg.sender, block.number, unbondings[msg.sender][bonding], amount);
836     }
837 
838   
839     function withdraw(address bonding) external nonReentrant {
840         require(unbondings[msg.sender][bonding] != 0 && unbondings[msg.sender][bonding] < now, "withdraw: unbonding");
841         require(!disputes[msg.sender], "withdraw: disputes");
842 
843         if (bonding == address(this)) {
844             _transferTokens(address(this), msg.sender, partialUnbonding[msg.sender][bonding]);
845         } else {
846             IERC20(bonding).safeTransfer(msg.sender, partialUnbonding[msg.sender][bonding]);
847         }
848         emit KeeperUnbound(msg.sender, block.number, block.timestamp, partialUnbonding[msg.sender][bonding]);
849         partialUnbonding[msg.sender][bonding] = 0;
850     }
851 
852    
853     function dispute(address keeper) external {
854         require(msg.sender == governance, "dispute: !gov");
855         disputes[keeper] = true;
856         emit KeeperDispute(keeper, block.number);
857     }
858 
859   
860     function slash(address bonded, address keeper, uint amount) public nonReentrant {
861         require(msg.sender == governance, "slash: !gov");
862         if (bonded == address(this)) {
863             _transferTokens(address(this), governance, amount);
864         } else {
865             IERC20(bonded).safeTransfer(governance, amount);
866         }
867         _unbond(bonded, keeper, amount);
868         disputes[keeper] = false;
869         emit KeeperSlashed(keeper, msg.sender, block.number, amount);
870     }
871 
872     function revoke(address keeper) external {
873         require(msg.sender == governance, "slash: !gov");
874         keepers[keeper] = false;
875         blacklist[keeper] = true;
876         slash(address(this), keeper, bonds[keeper][address(this)]);
877     }
878 
879   
880     function resolve(address keeper) external {
881         require(msg.sender == governance, "resolve: !gov");
882         disputes[keeper] = false;
883         emit KeeperResolved(keeper, block.number);
884     }
885 
886    
887     function allowance(address account, address spender) external view returns (uint) {
888         return allowances[account][spender];
889     }
890 
891   
892     function approve(address spender, uint amount) public returns (bool) {
893         allowances[msg.sender][spender] = amount;
894 
895         emit Approval(msg.sender, spender, amount);
896         return true;
897     }
898 
899    
900     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
901         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
902         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
903         address signatory = ecrecover(digest, v, r, s);
904         require(signatory != address(0), "permit: signature");
905         require(signatory == owner, "permit: unauthorized");
906         require(now <= deadline, "permit: expired");
907 
908         allowances[owner][spender] = amount;
909 
910         emit Approval(owner, spender, amount);
911     }
912 
913     function balanceOf(address account) external view returns (uint) {
914         return balances[account];
915     }
916 
917     
918     function transfer(address dst, uint amount) public returns (bool) {
919         _transferTokens(msg.sender, dst, amount);
920         return true;
921     }
922 
923   
924     function transferFrom(address src, address dst, uint amount) external returns (bool) {
925         address spender = msg.sender;
926         uint spenderAllowance = allowances[src][spender];
927 
928         if (spender != src && spenderAllowance != uint(-1)) {
929             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
930             allowances[src][spender] = newAllowance;
931 
932             emit Approval(src, spender, newAllowance);
933         }
934 
935         _transferTokens(src, dst, amount);
936         return true;
937     }
938 
939     function _transferTokens(address src, address dst, uint amount) internal {
940         require(src != address(0), "_transferTokens: zero address");
941         require(dst != address(0), "_transferTokens: zero address");
942 
943         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
944         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
945         emit Transfer(src, dst, amount);
946     }
947 
948     function _getChainId() internal pure returns (uint) {
949         uint chainId;
950         assembly { chainId := chainid() }
951         return chainId;
952     }
953 }