1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
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
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
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
44     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         uint256 c = a + b;
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
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction underflow");
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
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
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
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
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
108     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
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
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
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
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
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
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
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
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 contract PSP {
190     /// @notice EIP-20 token name for this token
191     string public constant name = "ParaSwap";
192 
193     /// @notice EIP-20 token symbol for this token
194     string public constant symbol = "PSP";
195 
196     /// @notice EIP-20 token decimals for this token
197     uint8 public constant decimals = 18;
198 
199     /// @notice Total number of tokens in circulation
200     uint public totalSupply = 2_000_000_000e18; // 2 billion PSP
201 
202     /// @notice Address which may mint new tokens
203     address public minter;
204 
205     /// @notice The timestamp after which minting may occur
206     uint public mintingAllowedAfter;
207 
208     /// @notice Minimum time between mints
209     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
210 
211     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
212     uint8 public constant mintCap = 2;
213 
214     /// @notice Allowance amounts on behalf of others
215     mapping (address => mapping (address => uint96)) internal allowances;
216 
217     /// @notice Official record of token balances for each account
218     mapping (address => uint96) internal balances;
219 
220     /// @notice A record of each accounts delegate
221     mapping (address => address) public delegates;
222 
223     /// @notice A checkpoint for marking number of votes from a given block
224     struct Checkpoint {
225         uint32 fromBlock;
226         uint96 votes;
227     }
228 
229     /// @notice A record of votes checkpoints for each account, by index
230     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
231 
232     /// @notice The number of checkpoints for each account
233     mapping (address => uint32) public numCheckpoints;
234 
235     /// @notice The EIP-712 typehash for the contract's domain
236     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
237 
238     /// @notice The EIP-712 typehash for the delegation struct used by the contract
239     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
240 
241     /// @notice The EIP-712 typehash for the permit struct used by the contract
242     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
243 
244     /// @notice A record of states for signing / validating signatures
245     mapping (address => uint) public nonces;
246 
247     /// @notice An event thats emitted when the minter address is changed
248     event MinterChanged(address minter, address newMinter);
249 
250     /// @notice An event thats emitted when an account changes its delegate
251     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
252 
253     /// @notice An event thats emitted when a delegate account's vote balance changes
254     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
255 
256     /// @notice The standard EIP-20 transfer event
257     event Transfer(address indexed from, address indexed to, uint256 amount);
258 
259     /// @notice The standard EIP-20 approval event
260     event Approval(address indexed owner, address indexed spender, uint256 amount);
261 
262     /**
263      * @notice Construct a new PSP token
264      * @param account The initial account to grant all the tokens
265      * @param minter_ The account with minting ability
266      * @param mintingAllowedAfter_ The timestamp after which minting may occur
267      */
268     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
269         require(mintingAllowedAfter_ >= block.timestamp, "PSP::constructor: minting can only begin after deployment");
270 
271         balances[account] = uint96(totalSupply);
272         emit Transfer(address(0), account, totalSupply);
273         minter = minter_;
274         emit MinterChanged(address(0), minter);
275         mintingAllowedAfter = mintingAllowedAfter_;
276     }
277 
278     /**
279      * @notice Change the minter address
280      * @param minter_ The address of the new minter
281      */
282     function setMinter(address minter_) external {
283         require(msg.sender == minter, "PSP::setMinter: only the minter can change the minter address");
284         emit MinterChanged(minter, minter_);
285         minter = minter_;
286     }
287 
288     /**
289      * @notice Mint new tokens
290      * @param dst The address of the destination account
291      * @param rawAmount The number of tokens to be minted
292      */
293     function mint(address dst, uint rawAmount) external {
294         require(msg.sender == minter, "PSP::mint: only the minter can mint");
295         require(block.timestamp >= mintingAllowedAfter, "PSP::mint: minting not allowed yet");
296         require(dst != address(0), "PSP::mint: cannot transfer to the zero address");
297 
298         // record the mint
299         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
300 
301         // mint the amount
302         uint96 amount = safe96(rawAmount, "PSP::mint: amount exceeds 96 bits");
303         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "PSP::mint: exceeded mint cap");
304         totalSupply = safe96(SafeMath.add(totalSupply, amount), "PSP::mint: totalSupply exceeds 96 bits");
305 
306         // transfer the amount to the recipient
307         balances[dst] = add96(balances[dst], amount, "PSP::mint: transfer amount overflows");
308         emit Transfer(address(0), dst, amount);
309 
310         // move delegates
311         _moveDelegates(address(0), delegates[dst], amount);
312     }
313 
314     /**
315      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
316      * @param account The address of the account holding the funds
317      * @param spender The address of the account spending the funds
318      * @return The number of tokens approved
319      */
320     function allowance(address account, address spender) external view returns (uint) {
321         return allowances[account][spender];
322     }
323 
324     /**
325      * @notice Approve `spender` to transfer up to `amount` from `src`
326      * @dev This will overwrite the approval amount for `spender`
327      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
328      * @param spender The address of the account which may transfer tokens
329      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
330      * @return Whether or not the approval succeeded
331      */
332     function approve(address spender, uint rawAmount) external returns (bool) {
333         uint96 amount;
334         if (rawAmount == uint(-1)) {
335             amount = uint96(-1);
336         } else {
337             amount = safe96(rawAmount, "PSP::approve: amount exceeds 96 bits");
338         }
339 
340         allowances[msg.sender][spender] = amount;
341 
342         emit Approval(msg.sender, spender, amount);
343         return true;
344     }
345 
346     /**
347      * @notice Triggers an approval from owner to spends
348      * @param owner The address to approve from
349      * @param spender The address to be approved
350      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
351      * @param deadline The time at which to expire the signature
352      * @param v The recovery byte of the signature
353      * @param r Half of the ECDSA signature pair
354      * @param s Half of the ECDSA signature pair
355      */
356     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
357         uint96 amount;
358         if (rawAmount == uint(-1)) {
359             amount = uint96(-1);
360         } else {
361             amount = safe96(rawAmount, "PSP::permit: amount exceeds 96 bits");
362         }
363 
364         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
365         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
366         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
367         address signatory = ecrecover(digest, v, r, s);
368         require(signatory != address(0), "PSP::permit: invalid signature");
369         require(signatory == owner, "PSP::permit: unauthorized");
370         require(now <= deadline, "PSP::permit: signature expired");
371 
372         allowances[owner][spender] = amount;
373 
374         emit Approval(owner, spender, amount);
375     }
376 
377     /**
378      * @notice Get the number of tokens held by the `account`
379      * @param account The address of the account to get the balance of
380      * @return The number of tokens held
381      */
382     function balanceOf(address account) external view returns (uint) {
383         return balances[account];
384     }
385 
386     /**
387      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
388      * @param dst The address of the destination account
389      * @param rawAmount The number of tokens to transfer
390      * @return Whether or not the transfer succeeded
391      */
392     function transfer(address dst, uint rawAmount) external returns (bool) {
393         uint96 amount = safe96(rawAmount, "PSP::transfer: amount exceeds 96 bits");
394         _transferTokens(msg.sender, dst, amount);
395         return true;
396     }
397 
398     /**
399      * @notice Transfer `amount` tokens from `src` to `dst`
400      * @param src The address of the source account
401      * @param dst The address of the destination account
402      * @param rawAmount The number of tokens to transfer
403      * @return Whether or not the transfer succeeded
404      */
405     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
406         address spender = msg.sender;
407         uint96 spenderAllowance = allowances[src][spender];
408         uint96 amount = safe96(rawAmount, "PSP::approve: amount exceeds 96 bits");
409 
410         if (spender != src && spenderAllowance != uint96(-1)) {
411             uint96 newAllowance = sub96(spenderAllowance, amount, "PSP::transferFrom: transfer amount exceeds spender allowance");
412             allowances[src][spender] = newAllowance;
413 
414             emit Approval(src, spender, newAllowance);
415         }
416 
417         _transferTokens(src, dst, amount);
418         return true;
419     }
420 
421     /**
422      * @notice Delegate votes from `msg.sender` to `delegatee`
423      * @param delegatee The address to delegate votes to
424      */
425     function delegate(address delegatee) public {
426         return _delegate(msg.sender, delegatee);
427     }
428 
429     /**
430      * @notice Delegates votes from signatory to `delegatee`
431      * @param delegatee The address to delegate votes to
432      * @param nonce The contract state required to match the signature
433      * @param expiry The time at which to expire the signature
434      * @param v The recovery byte of the signature
435      * @param r Half of the ECDSA signature pair
436      * @param s Half of the ECDSA signature pair
437      */
438     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
439         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
440         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
441         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
442         address signatory = ecrecover(digest, v, r, s);
443         require(signatory != address(0), "PSP::delegateBySig: invalid signature");
444         require(nonce == nonces[signatory]++, "PSP::delegateBySig: invalid nonce");
445         require(now <= expiry, "PSP::delegateBySig: signature expired");
446         return _delegate(signatory, delegatee);
447     }
448 
449     /**
450      * @notice Gets the current votes balance for `account`
451      * @param account The address to get votes balance
452      * @return The number of current votes for `account`
453      */
454     function getCurrentVotes(address account) external view returns (uint96) {
455         uint32 nCheckpoints = numCheckpoints[account];
456         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
457     }
458 
459     /**
460      * @notice Determine the prior number of votes for an account as of a block number
461      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
462      * @param account The address of the account to check
463      * @param blockNumber The block number to get the vote balance at
464      * @return The number of votes the account had as of the given block
465      */
466     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
467         require(blockNumber < block.number, "PSP::getPriorVotes: not yet determined");
468 
469         uint32 nCheckpoints = numCheckpoints[account];
470         if (nCheckpoints == 0) {
471             return 0;
472         }
473 
474         // First check most recent balance
475         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
476             return checkpoints[account][nCheckpoints - 1].votes;
477         }
478 
479         // Next check implicit zero balance
480         if (checkpoints[account][0].fromBlock > blockNumber) {
481             return 0;
482         }
483 
484         uint32 lower = 0;
485         uint32 upper = nCheckpoints - 1;
486         while (upper > lower) {
487             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
488             Checkpoint memory cp = checkpoints[account][center];
489             if (cp.fromBlock == blockNumber) {
490                 return cp.votes;
491             } else if (cp.fromBlock < blockNumber) {
492                 lower = center;
493             } else {
494                 upper = center - 1;
495             }
496         }
497         return checkpoints[account][lower].votes;
498     }
499 
500     function _delegate(address delegator, address delegatee) internal {
501         address currentDelegate = delegates[delegator];
502         uint96 delegatorBalance = balances[delegator];
503         delegates[delegator] = delegatee;
504 
505         emit DelegateChanged(delegator, currentDelegate, delegatee);
506 
507         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
508     }
509 
510     function _transferTokens(address src, address dst, uint96 amount) internal {
511         require(src != address(0), "PSP::_transferTokens: cannot transfer from the zero address");
512         require(dst != address(0), "PSP::_transferTokens: cannot transfer to the zero address");
513 
514         balances[src] = sub96(balances[src], amount, "PSP::_transferTokens: transfer amount exceeds balance");
515         balances[dst] = add96(balances[dst], amount, "PSP::_transferTokens: transfer amount overflows");
516         emit Transfer(src, dst, amount);
517 
518         _moveDelegates(delegates[src], delegates[dst], amount);
519     }
520 
521     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
522         if (srcRep != dstRep && amount > 0) {
523             if (srcRep != address(0)) {
524                 uint32 srcRepNum = numCheckpoints[srcRep];
525                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
526                 uint96 srcRepNew = sub96(srcRepOld, amount, "PSP::_moveVotes: vote amount underflows");
527                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
528             }
529 
530             if (dstRep != address(0)) {
531                 uint32 dstRepNum = numCheckpoints[dstRep];
532                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
533                 uint96 dstRepNew = add96(dstRepOld, amount, "PSP::_moveVotes: vote amount overflows");
534                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
535             }
536         }
537     }
538 
539     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
540       uint32 blockNumber = safe32(block.number, "PSP::_writeCheckpoint: block number exceeds 32 bits");
541 
542       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
543           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
544       } else {
545           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
546           numCheckpoints[delegatee] = nCheckpoints + 1;
547       }
548 
549       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
550     }
551 
552     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
553         require(n < 2**32, errorMessage);
554         return uint32(n);
555     }
556 
557     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
558         require(n < 2**96, errorMessage);
559         return uint96(n);
560     }
561 
562     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
563         uint96 c = a + b;
564         require(c >= a, errorMessage);
565         return c;
566     }
567 
568     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
569         require(b <= a, errorMessage);
570         return a - b;
571     }
572 
573     function getChainId() internal pure returns (uint) {
574         uint256 chainId;
575         assembly { chainId := chainid() }
576         return chainId;
577     }
578 }