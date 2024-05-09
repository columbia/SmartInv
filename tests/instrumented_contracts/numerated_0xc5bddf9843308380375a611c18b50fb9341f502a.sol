1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
5 // Subject to the MIT license.
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      * - Addition cannot overflow.
28      */
29     function add(uint a, uint b) internal pure returns (uint) {
30         uint c = a + b;
31         require(c >= a, "add: +");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      * - Addition cannot overflow.
43      */
44     function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
45         uint c = a + b;
46         require(c >= a, errorMessage);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot underflow.
58      */
59     function sub(uint a, uint b) internal pure returns (uint) {
60         return sub(a, b, "sub: -");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot underflow.
70      */
71     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
72         require(b <= a, errorMessage);
73         uint c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint a, uint b) internal pure returns (uint) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint c = a * b;
95         require(c / a == b, "mul: *");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint c = a * b;
117         require(c / a == b, errorMessage);
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers.
124      * Reverts on division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function div(uint a, uint b) internal pure returns (uint) {
134         return div(a, b, "div: /");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers.
139      * Reverts with custom message on division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function mod(uint a, uint b) internal pure returns (uint) {
169         return mod(a, b, "mod: %");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 /**
190  * @dev Interface of the ERC20 standard as defined in the EIP.
191  */
192 interface IERC20 {
193     /**
194      * @dev Returns the amount of tokens in existence.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     /**
199      * @dev Returns the amount of tokens owned by `account`.
200      */
201     function balanceOf(address account) external view returns (uint256);
202 
203     /**
204      * @dev Moves `amount` tokens from the caller's account to `recipient`.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transfer(address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Returns the remaining number of tokens that `spender` will be
214      * allowed to spend on behalf of `owner` through {transferFrom}. This is
215      * zero by default.
216      *
217      * This value changes when {approve} or {transferFrom} are called.
218      */
219     function allowance(address owner, address spender) external view returns (uint256);
220 
221     /**
222      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * IMPORTANT: Beware that changing an allowance with this method brings the risk
227      * that someone may use both the old and the new allowance by unfortunate
228      * transaction ordering. One possible solution to mitigate this race
229      * condition is to first reduce the spender's allowance to 0 and set the
230      * desired value afterwards:
231      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address spender, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Moves `amount` tokens from `sender` to `recipient` using the
239      * allowance mechanism. `amount` is then deducted from the caller's
240      * allowance.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Emitted when `value` tokens are moved from one account (`from`) to
250      * another (`to`).
251      *
252      * Note that `value` may be zero.
253      */
254     event Transfer(address indexed from, address indexed to, uint256 value);
255 
256     /**
257      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
258      * a call to {approve}. `value` is the new allowance.
259      */
260     event Approval(address indexed owner, address indexed spender, uint256 value);
261 }
262 
263 interface StrategyProxy {
264     function lock() external;
265 }
266 
267 interface FeeDistribution {
268     function claim(address) external;
269 }
270 
271 contract veCurveVault {
272     using SafeMath for uint;
273 
274     /// @notice EIP-20 token name for this token
275     string public constant name = "veCRV-DAO yVault";
276 
277     /// @notice EIP-20 token symbol for this token
278     string public constant symbol = "yveCRV-DAO";
279 
280     /// @notice EIP-20 token decimals for this token
281     uint8 public constant decimals = 18;
282 
283     /// @notice Total number of tokens in circulation
284     uint public totalSupply = 0; // Initial 0
285 
286     /// @notice A record of each accounts delegate
287     mapping (address => address) public delegates;
288 
289     /// @notice A record of votes checkpoints for each account, by index
290     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
291 
292     /// @notice The number of checkpoints for each account
293     mapping (address => uint32) public numCheckpoints;
294 
295     mapping (address => mapping (address => uint)) internal allowances;
296     mapping (address => uint) internal balances;
297 
298     /// @notice The EIP-712 typehash for the contract's domain
299     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint chainId,address verifyingContract)");
300     bytes32 public immutable DOMAINSEPARATOR;
301 
302     /// @notice The EIP-712 typehash for the delegation struct used by the contract
303     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint nonce,uint expiry)");
304 
305     /// @notice The EIP-712 typehash for the permit struct used by the contract
306     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint value,uint nonce,uint deadline)");
307 
308 
309     /// @notice A record of states for signing / validating signatures
310     mapping (address => uint) public nonces;
311 
312     /// @notice An event thats emitted when an account changes its delegate
313     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
314 
315     /// @notice An event thats emitted when a delegate account's vote balance changes
316     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
317 
318     /// @notice A checkpoint for marking number of votes from a given block
319     struct Checkpoint {
320         uint32 fromBlock;
321         uint votes;
322     }
323 
324     /**
325      * @notice Delegate votes from `msg.sender` to `delegatee`
326      * @param delegatee The address to delegate votes to
327      */
328     function delegate(address delegatee) public {
329         _delegate(msg.sender, delegatee);
330     }
331 
332     /**
333      * @notice Delegates votes from signatory to `delegatee`
334      * @param delegatee The address to delegate votes to
335      * @param nonce The contract state required to match the signature
336      * @param expiry The time at which to expire the signature
337      * @param v The recovery byte of the signature
338      * @param r Half of the ECDSA signature pair
339      * @param s Half of the ECDSA signature pair
340      */
341     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
342         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
343         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
344         address signatory = ecrecover(digest, v, r, s);
345         require(signatory != address(0), "delegateBySig: sig");
346         require(nonce == nonces[signatory]++, "delegateBySig: nonce");
347         require(now <= expiry, "delegateBySig: expired");
348         _delegate(signatory, delegatee);
349     }
350 
351     /**
352      * @notice Gets the current votes balance for `account`
353      * @param account The address to get votes balance
354      * @return The number of current votes for `account`
355      */
356     function getCurrentVotes(address account) external view returns (uint) {
357         uint32 nCheckpoints = numCheckpoints[account];
358         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
359     }
360 
361     /**
362      * @notice Determine the prior number of votes for an account as of a block number
363      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
364      * @param account The address of the account to check
365      * @param blockNumber The block number to get the vote balance at
366      * @return The number of votes the account had as of the given block
367      */
368     function getPriorVotes(address account, uint blockNumber) public view returns (uint) {
369         require(blockNumber < block.number, "getPriorVotes:");
370 
371         uint32 nCheckpoints = numCheckpoints[account];
372         if (nCheckpoints == 0) {
373             return 0;
374         }
375 
376         // First check most recent balance
377         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
378             return checkpoints[account][nCheckpoints - 1].votes;
379         }
380 
381         // Next check implicit zero balance
382         if (checkpoints[account][0].fromBlock > blockNumber) {
383             return 0;
384         }
385 
386         uint32 lower = 0;
387         uint32 upper = nCheckpoints - 1;
388         while (upper > lower) {
389             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
390             Checkpoint memory cp = checkpoints[account][center];
391             if (cp.fromBlock == blockNumber) {
392                 return cp.votes;
393             } else if (cp.fromBlock < blockNumber) {
394                 lower = center;
395             } else {
396                 upper = center - 1;
397             }
398         }
399         return checkpoints[account][lower].votes;
400     }
401 
402     function _delegate(address delegator, address delegatee) internal {
403         address currentDelegate = delegates[delegator];
404         uint delegatorBalance = balances[delegator];
405         delegates[delegator] = delegatee;
406 
407         emit DelegateChanged(delegator, currentDelegate, delegatee);
408 
409         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
410     }
411 
412     function _moveDelegates(address srcRep, address dstRep, uint amount) internal {
413         if (srcRep != dstRep && amount > 0) {
414             if (srcRep != address(0)) {
415                 uint32 srcRepNum = numCheckpoints[srcRep];
416                 uint srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
417                 uint srcRepNew = srcRepOld.sub(amount, "_moveVotes: underflows");
418                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
419             }
420 
421             if (dstRep != address(0)) {
422                 uint32 dstRepNum = numCheckpoints[dstRep];
423                 uint dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
424                 uint dstRepNew = dstRepOld.add(amount);
425                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
426             }
427         }
428     }
429 
430     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint oldVotes, uint newVotes) internal {
431       uint32 blockNumber = safe32(block.number, "_writeCheckpoint: 32 bits");
432 
433       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
434           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
435       } else {
436           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
437           numCheckpoints[delegatee] = nCheckpoints + 1;
438       }
439 
440       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
441     }
442 
443     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
444         require(n < 2**32, errorMessage);
445         return uint32(n);
446     }
447 
448     /// @notice The standard EIP-20 transfer event
449     event Transfer(address indexed from, address indexed to, uint amount);
450 
451     /// @notice The standard EIP-20 approval event
452     event Approval(address indexed owner, address indexed spender, uint amount);
453 
454     /// @notice governance address for the governance contract
455     address public governance;
456     address public pendingGovernance;
457     
458     IERC20 public constant CRV = IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52);
459     address public constant LOCK = address(0xF147b8125d2ef93FB6965Db97D6746952a133934);
460     address public proxy = address(0x7A1848e7847F3f5FfB4d8e63BdB9569db535A4f0);
461     address public feeDistribution;
462     
463     IERC20 public constant rewards = IERC20(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
464     
465     uint public index = 0;
466     uint public bal = 0;
467     
468     mapping(address => uint) public supplyIndex;
469     
470     function update() external {
471         _update();
472     }
473     
474     function _update() internal {
475         if (totalSupply > 0) {
476             _claim();
477             uint256 _bal = rewards.balanceOf(address(this));
478             if (_bal > bal) {
479                 uint256 _diff = _bal.sub(bal, "veCRV::_update: bal _diff");
480                 if (_diff > 0) {
481                     uint256 _ratio = _diff.mul(1e18).div(totalSupply);
482                     if (_ratio > 0) {
483                       index = index.add(_ratio);
484                       bal = _bal;
485                     }
486                 }
487             }
488         }
489     }
490     
491     function _claim() internal {
492         if (feeDistribution != address(0x0)) {
493             FeeDistribution(feeDistribution).claim(address(this));
494         }
495     }
496     
497     function updateFor(address recipient) public {
498         _update();
499         uint256 _supplied = balances[recipient];
500         if (_supplied > 0) {
501             uint256 _supplyIndex = supplyIndex[recipient];
502             supplyIndex[recipient] = index;
503             uint256 _delta = index.sub(_supplyIndex, "veCRV::_claimFor: index delta");
504             if (_delta > 0) {
505               uint256 _share = _supplied.mul(_delta).div(1e18);
506               claimable[recipient] = claimable[recipient].add(_share);
507             }
508         } else {
509             supplyIndex[recipient] = index;
510         }
511     }
512     
513     mapping(address => uint) public claimable;
514     
515     function claim() external {
516         _claimFor(msg.sender);
517     }
518     function claimFor(address recipient) external {
519         _claimFor(recipient);
520     }
521     
522     function _claimFor(address recipient) internal {
523         updateFor(recipient);
524         rewards.transfer(recipient, claimable[recipient]);
525         claimable[recipient] = 0;
526         bal = rewards.balanceOf(address(this));
527     }
528 
529     constructor() public {
530         // Set governance for this token
531         governance = msg.sender;
532         DOMAINSEPARATOR = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), _getChainId(), address(this)));
533     }
534 
535     function _mint(address dst, uint amount) internal {
536         updateFor(dst);
537         // mint the amount
538         totalSupply = totalSupply.add(amount);
539         // transfer the amount to the recipient
540         balances[dst] = balances[dst].add(amount);
541         emit Transfer(address(0), dst, amount);
542         
543         // move delegates
544         _moveDelegates(address(0), delegates[dst], amount);
545     }
546     
547     function depositAll() external {
548         _deposit(CRV.balanceOf(msg.sender));
549     }
550     
551     function deposit(uint _amount) external {
552         _deposit(_amount);
553     }
554     
555     function _deposit(uint _amount) internal {
556         CRV.transferFrom(msg.sender, LOCK, _amount);
557         _mint(msg.sender, _amount);
558         StrategyProxy(proxy).lock();
559     }
560     
561     function setProxy(address _proxy) external {
562         require(msg.sender == governance, "setGovernance: !gov");
563         proxy = _proxy;
564     }
565     
566     function setFeeDistribution(address _feeDistribution) external {
567         require(msg.sender == governance, "setGovernance: !gov");
568         feeDistribution = _feeDistribution;
569     }
570     
571     /**
572      * @notice Allows governance to change governance (for future upgradability)
573      * @param _governance new governance address to set
574      */
575     function setGovernance(address _governance) external {
576         require(msg.sender == governance, "setGovernance: !gov");
577         pendingGovernance = _governance;
578     }
579 
580     /**
581      * @notice Allows pendingGovernance to accept their role as governance (protection pattern)
582      */
583     function acceptGovernance() external {
584         require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
585         governance = pendingGovernance;
586     }
587 
588     /**
589      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
590      * @param account The address of the account holding the funds
591      * @param spender The address of the account spending the funds
592      * @return The number of tokens approved
593      */
594     function allowance(address account, address spender) external view returns (uint) {
595         return allowances[account][spender];
596     }
597 
598     /**
599      * @notice Approve `spender` to transfer up to `amount` from `src`
600      * @dev This will overwrite the approval amount for `spender`
601      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
602      * @param spender The address of the account which may transfer tokens
603      * @param amount The number of tokens that are approved (2^256-1 means infinite)
604      * @return Whether or not the approval succeeded
605      */
606     function approve(address spender, uint amount) external returns (bool) {
607         allowances[msg.sender][spender] = amount;
608 
609         emit Approval(msg.sender, spender, amount);
610         return true;
611     }
612 
613     /**
614      * @notice Triggers an approval from owner to spends
615      * @param owner The address to approve from
616      * @param spender The address to be approved
617      * @param amount The number of tokens that are approved (2^256-1 means infinite)
618      * @param deadline The time at which to expire the signature
619      * @param v The recovery byte of the signature
620      * @param r Half of the ECDSA signature pair
621      * @param s Half of the ECDSA signature pair
622      */
623     function permit(address owner, address spender, uint amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
624         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
625         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
626         address signatory = ecrecover(digest, v, r, s);
627         require(signatory != address(0), "permit: signature");
628         require(signatory == owner, "permit: unauthorized");
629         require(now <= deadline, "permit: expired");
630 
631         allowances[owner][spender] = amount;
632 
633         emit Approval(owner, spender, amount);
634     }
635 
636     /**
637      * @notice Get the number of tokens held by the `account`
638      * @param account The address of the account to get the balance of
639      * @return The number of tokens held
640      */
641     function balanceOf(address account) external view returns (uint) {
642         return balances[account];
643     }
644 
645     /**
646      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
647      * @param dst The address of the destination account
648      * @param amount The number of tokens to transfer
649      * @return Whether or not the transfer succeeded
650      */
651     function transfer(address dst, uint amount) external returns (bool) {
652         _transferTokens(msg.sender, dst, amount);
653         return true;
654     }
655 
656     /**
657      * @notice Transfer `amount` tokens from `src` to `dst`
658      * @param src The address of the source account
659      * @param dst The address of the destination account
660      * @param amount The number of tokens to transfer
661      * @return Whether or not the transfer succeeded
662      */
663     function transferFrom(address src, address dst, uint amount) external returns (bool) {
664         address spender = msg.sender;
665         uint spenderAllowance = allowances[src][spender];
666 
667         if (spender != src && spenderAllowance != uint(-1)) {
668             uint newAllowance = spenderAllowance.sub(amount, "transferFrom: exceeds spender allowance");
669             allowances[src][spender] = newAllowance;
670 
671             emit Approval(src, spender, newAllowance);
672         }
673 
674         _transferTokens(src, dst, amount);
675         return true;
676     }
677 
678     function _transferTokens(address src, address dst, uint amount) internal {
679         require(src != address(0), "_transferTokens: zero address");
680         require(dst != address(0), "_transferTokens: zero address");
681         
682         updateFor(src);
683         updateFor(dst);
684 
685         balances[src] = balances[src].sub(amount, "_transferTokens: exceeds balance");
686         balances[dst] = balances[dst].add(amount, "_transferTokens: overflows");
687         emit Transfer(src, dst, amount);
688     }
689 
690     function _getChainId() internal pure returns (uint) {
691         uint chainId;
692         assembly { chainId := chainid() }
693         return chainId;
694     }
695 }