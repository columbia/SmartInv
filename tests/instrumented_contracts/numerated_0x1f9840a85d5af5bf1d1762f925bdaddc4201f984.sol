1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-15
3 */
4 
5 pragma solidity ^0.5.16;
6 pragma experimental ABIEncoderV2;
7 
8 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
9 // Subject to the MIT license.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations with added overflow
13  * checks.
14  *
15  * Arithmetic operations in Solidity wrap on overflow. This can easily result
16  * in bugs, because programmers usually assume that an overflow raises an
17  * error, which is the standard behavior in high level programming languages.
18  * `SafeMath` restores this intuition by reverting the transaction when an
19  * operation overflows.
20  *
21  * Using this library instead of the unchecked operations eliminates an entire
22  * class of bugs, so it's recommended to use it always.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, reverting on overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, errorMessage);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      * - Subtraction cannot underflow.
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction underflow");
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      * - Subtraction cannot underflow.
74      */
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
84      *
85      * Counterpart to Solidity's `*` operator.
86      *
87      * Requirements:
88      * - Multiplication cannot overflow.
89      */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath: multiplication overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      * - Multiplication cannot overflow.
111      */
112     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, errorMessage);
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers.
128      * Reverts on division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return div(a, b, "SafeMath: division by zero");
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers.
143      * Reverts with custom message on division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      */
152     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         // Solidity only automatically asserts when dividing by 0
154         require(b > 0, errorMessage);
155         uint256 c = a / b;
156         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
163      * Reverts when dividing by zero.
164      *
165      * Counterpart to Solidity's `%` operator. This function uses a `revert`
166      * opcode (which leaves remaining gas untouched) while Solidity uses an
167      * invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
173         return mod(a, b, "SafeMath: modulo by zero");
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts with custom message when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b != 0, errorMessage);
189         return a % b;
190     }
191 }
192 
193 contract Uni {
194     /// @notice EIP-20 token name for this token
195     string public constant name = "Uniswap";
196 
197     /// @notice EIP-20 token symbol for this token
198     string public constant symbol = "UNI";
199 
200     /// @notice EIP-20 token decimals for this token
201     uint8 public constant decimals = 18;
202 
203     /// @notice Total number of tokens in circulation
204     uint public totalSupply = 1_000_000_000e18; // 1 billion Uni
205 
206     /// @notice Address which may mint new tokens
207     address public minter;
208 
209     /// @notice The timestamp after which minting may occur
210     uint public mintingAllowedAfter;
211 
212     /// @notice Minimum time between mints
213     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
214 
215     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
216     uint8 public constant mintCap = 2;
217 
218     /// @notice Allowance amounts on behalf of others
219     mapping (address => mapping (address => uint96)) internal allowances;
220 
221     /// @notice Official record of token balances for each account
222     mapping (address => uint96) internal balances;
223 
224     /// @notice A record of each accounts delegate
225     mapping (address => address) public delegates;
226 
227     /// @notice A checkpoint for marking number of votes from a given block
228     struct Checkpoint {
229         uint32 fromBlock;
230         uint96 votes;
231     }
232 
233     /// @notice A record of votes checkpoints for each account, by index
234     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
235 
236     /// @notice The number of checkpoints for each account
237     mapping (address => uint32) public numCheckpoints;
238 
239     /// @notice The EIP-712 typehash for the contract's domain
240     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
241 
242     /// @notice The EIP-712 typehash for the delegation struct used by the contract
243     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
244 
245     /// @notice The EIP-712 typehash for the permit struct used by the contract
246     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
247 
248     /// @notice A record of states for signing / validating signatures
249     mapping (address => uint) public nonces;
250 
251     /// @notice An event thats emitted when the minter address is changed
252     event MinterChanged(address minter, address newMinter);
253 
254     /// @notice An event thats emitted when an account changes its delegate
255     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
256 
257     /// @notice An event thats emitted when a delegate account's vote balance changes
258     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
259 
260     /// @notice The standard EIP-20 transfer event
261     event Transfer(address indexed from, address indexed to, uint256 amount);
262 
263     /// @notice The standard EIP-20 approval event
264     event Approval(address indexed owner, address indexed spender, uint256 amount);
265 
266     /**
267      * @notice Construct a new Uni token
268      * @param account The initial account to grant all the tokens
269      * @param minter_ The account with minting ability
270      * @param mintingAllowedAfter_ The timestamp after which minting may occur
271      */
272     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
273         require(mintingAllowedAfter_ >= block.timestamp, "Uni::constructor: minting can only begin after deployment");
274 
275         balances[account] = uint96(totalSupply);
276         emit Transfer(address(0), account, totalSupply);
277         minter = minter_;
278         emit MinterChanged(address(0), minter);
279         mintingAllowedAfter = mintingAllowedAfter_;
280     }
281 
282     /**
283      * @notice Change the minter address
284      * @param minter_ The address of the new minter
285      */
286     function setMinter(address minter_) external {
287         require(msg.sender == minter, "Uni::setMinter: only the minter can change the minter address");
288         emit MinterChanged(minter, minter_);
289         minter = minter_;
290     }
291 
292     /**
293      * @notice Mint new tokens
294      * @param dst The address of the destination account
295      * @param rawAmount The number of tokens to be minted
296      */
297     function mint(address dst, uint rawAmount) external {
298         require(msg.sender == minter, "Uni::mint: only the minter can mint");
299         require(block.timestamp >= mintingAllowedAfter, "Uni::mint: minting not allowed yet");
300         require(dst != address(0), "Uni::mint: cannot transfer to the zero address");
301 
302         // record the mint
303         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
304 
305         // mint the amount
306         uint96 amount = safe96(rawAmount, "Uni::mint: amount exceeds 96 bits");
307         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "Uni::mint: exceeded mint cap");
308         totalSupply = safe96(SafeMath.add(totalSupply, amount), "Uni::mint: totalSupply exceeds 96 bits");
309 
310         // transfer the amount to the recipient
311         balances[dst] = add96(balances[dst], amount, "Uni::mint: transfer amount overflows");
312         emit Transfer(address(0), dst, amount);
313 
314         // move delegates
315         _moveDelegates(address(0), delegates[dst], amount);
316     }
317 
318     /**
319      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
320      * @param account The address of the account holding the funds
321      * @param spender The address of the account spending the funds
322      * @return The number of tokens approved
323      */
324     function allowance(address account, address spender) external view returns (uint) {
325         return allowances[account][spender];
326     }
327 
328     /**
329      * @notice Approve `spender` to transfer up to `amount` from `src`
330      * @dev This will overwrite the approval amount for `spender`
331      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
332      * @param spender The address of the account which may transfer tokens
333      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
334      * @return Whether or not the approval succeeded
335      */
336     function approve(address spender, uint rawAmount) external returns (bool) {
337         uint96 amount;
338         if (rawAmount == uint(-1)) {
339             amount = uint96(-1);
340         } else {
341             amount = safe96(rawAmount, "Uni::approve: amount exceeds 96 bits");
342         }
343 
344         allowances[msg.sender][spender] = amount;
345 
346         emit Approval(msg.sender, spender, amount);
347         return true;
348     }
349 
350     /**
351      * @notice Triggers an approval from owner to spends
352      * @param owner The address to approve from
353      * @param spender The address to be approved
354      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
355      * @param deadline The time at which to expire the signature
356      * @param v The recovery byte of the signature
357      * @param r Half of the ECDSA signature pair
358      * @param s Half of the ECDSA signature pair
359      */
360     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
361         uint96 amount;
362         if (rawAmount == uint(-1)) {
363             amount = uint96(-1);
364         } else {
365             amount = safe96(rawAmount, "Uni::permit: amount exceeds 96 bits");
366         }
367 
368         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
369         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
370         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
371         address signatory = ecrecover(digest, v, r, s);
372         require(signatory != address(0), "Uni::permit: invalid signature");
373         require(signatory == owner, "Uni::permit: unauthorized");
374         require(now <= deadline, "Uni::permit: signature expired");
375 
376         allowances[owner][spender] = amount;
377 
378         emit Approval(owner, spender, amount);
379     }
380 
381     /**
382      * @notice Get the number of tokens held by the `account`
383      * @param account The address of the account to get the balance of
384      * @return The number of tokens held
385      */
386     function balanceOf(address account) external view returns (uint) {
387         return balances[account];
388     }
389 
390     /**
391      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
392      * @param dst The address of the destination account
393      * @param rawAmount The number of tokens to transfer
394      * @return Whether or not the transfer succeeded
395      */
396     function transfer(address dst, uint rawAmount) external returns (bool) {
397         uint96 amount = safe96(rawAmount, "Uni::transfer: amount exceeds 96 bits");
398         _transferTokens(msg.sender, dst, amount);
399         return true;
400     }
401 
402     /**
403      * @notice Transfer `amount` tokens from `src` to `dst`
404      * @param src The address of the source account
405      * @param dst The address of the destination account
406      * @param rawAmount The number of tokens to transfer
407      * @return Whether or not the transfer succeeded
408      */
409     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
410         address spender = msg.sender;
411         uint96 spenderAllowance = allowances[src][spender];
412         uint96 amount = safe96(rawAmount, "Uni::approve: amount exceeds 96 bits");
413 
414         if (spender != src && spenderAllowance != uint96(-1)) {
415             uint96 newAllowance = sub96(spenderAllowance, amount, "Uni::transferFrom: transfer amount exceeds spender allowance");
416             allowances[src][spender] = newAllowance;
417 
418             emit Approval(src, spender, newAllowance);
419         }
420 
421         _transferTokens(src, dst, amount);
422         return true;
423     }
424 
425     /**
426      * @notice Delegate votes from `msg.sender` to `delegatee`
427      * @param delegatee The address to delegate votes to
428      */
429     function delegate(address delegatee) public {
430         return _delegate(msg.sender, delegatee);
431     }
432 
433     /**
434      * @notice Delegates votes from signatory to `delegatee`
435      * @param delegatee The address to delegate votes to
436      * @param nonce The contract state required to match the signature
437      * @param expiry The time at which to expire the signature
438      * @param v The recovery byte of the signature
439      * @param r Half of the ECDSA signature pair
440      * @param s Half of the ECDSA signature pair
441      */
442     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
443         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
444         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
445         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
446         address signatory = ecrecover(digest, v, r, s);
447         require(signatory != address(0), "Uni::delegateBySig: invalid signature");
448         require(nonce == nonces[signatory]++, "Uni::delegateBySig: invalid nonce");
449         require(now <= expiry, "Uni::delegateBySig: signature expired");
450         return _delegate(signatory, delegatee);
451     }
452 
453     /**
454      * @notice Gets the current votes balance for `account`
455      * @param account The address to get votes balance
456      * @return The number of current votes for `account`
457      */
458     function getCurrentVotes(address account) external view returns (uint96) {
459         uint32 nCheckpoints = numCheckpoints[account];
460         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
461     }
462 
463     /**
464      * @notice Determine the prior number of votes for an account as of a block number
465      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
466      * @param account The address of the account to check
467      * @param blockNumber The block number to get the vote balance at
468      * @return The number of votes the account had as of the given block
469      */
470     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
471         require(blockNumber < block.number, "Uni::getPriorVotes: not yet determined");
472 
473         uint32 nCheckpoints = numCheckpoints[account];
474         if (nCheckpoints == 0) {
475             return 0;
476         }
477 
478         // First check most recent balance
479         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
480             return checkpoints[account][nCheckpoints - 1].votes;
481         }
482 
483         // Next check implicit zero balance
484         if (checkpoints[account][0].fromBlock > blockNumber) {
485             return 0;
486         }
487 
488         uint32 lower = 0;
489         uint32 upper = nCheckpoints - 1;
490         while (upper > lower) {
491             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
492             Checkpoint memory cp = checkpoints[account][center];
493             if (cp.fromBlock == blockNumber) {
494                 return cp.votes;
495             } else if (cp.fromBlock < blockNumber) {
496                 lower = center;
497             } else {
498                 upper = center - 1;
499             }
500         }
501         return checkpoints[account][lower].votes;
502     }
503 
504     function _delegate(address delegator, address delegatee) internal {
505         address currentDelegate = delegates[delegator];
506         uint96 delegatorBalance = balances[delegator];
507         delegates[delegator] = delegatee;
508 
509         emit DelegateChanged(delegator, currentDelegate, delegatee);
510 
511         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
512     }
513 
514     function _transferTokens(address src, address dst, uint96 amount) internal {
515         require(src != address(0), "Uni::_transferTokens: cannot transfer from the zero address");
516         require(dst != address(0), "Uni::_transferTokens: cannot transfer to the zero address");
517 
518         balances[src] = sub96(balances[src], amount, "Uni::_transferTokens: transfer amount exceeds balance");
519         balances[dst] = add96(balances[dst], amount, "Uni::_transferTokens: transfer amount overflows");
520         emit Transfer(src, dst, amount);
521 
522         _moveDelegates(delegates[src], delegates[dst], amount);
523     }
524 
525     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
526         if (srcRep != dstRep && amount > 0) {
527             if (srcRep != address(0)) {
528                 uint32 srcRepNum = numCheckpoints[srcRep];
529                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
530                 uint96 srcRepNew = sub96(srcRepOld, amount, "Uni::_moveVotes: vote amount underflows");
531                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
532             }
533 
534             if (dstRep != address(0)) {
535                 uint32 dstRepNum = numCheckpoints[dstRep];
536                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
537                 uint96 dstRepNew = add96(dstRepOld, amount, "Uni::_moveVotes: vote amount overflows");
538                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
539             }
540         }
541     }
542 
543     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
544       uint32 blockNumber = safe32(block.number, "Uni::_writeCheckpoint: block number exceeds 32 bits");
545 
546       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
547           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
548       } else {
549           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
550           numCheckpoints[delegatee] = nCheckpoints + 1;
551       }
552 
553       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
554     }
555 
556     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
557         require(n < 2**32, errorMessage);
558         return uint32(n);
559     }
560 
561     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
562         require(n < 2**96, errorMessage);
563         return uint96(n);
564     }
565 
566     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
567         uint96 c = a + b;
568         require(c >= a, errorMessage);
569         return c;
570     }
571 
572     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
573         require(b <= a, errorMessage);
574         return a - b;
575     }
576 
577     function getChainId() internal pure returns (uint) {
578         uint256 chainId;
579         assembly { chainId := chainid() }
580         return chainId;
581     }
582 }