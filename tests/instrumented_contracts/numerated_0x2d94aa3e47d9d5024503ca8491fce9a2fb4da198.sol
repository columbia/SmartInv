1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.5.16;
3 pragma experimental ABIEncoderV2;
4 
5 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
6 // Subject to the MIT license.
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
39      *
40      * Counterpart to Solidity's `+` operator.
41      *
42      * Requirements:
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, errorMessage);
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      * - Subtraction cannot underflow.
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction underflow");
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot underflow.
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111         // benefit is lost if 'b' is also tested.
112         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
113         if (a == 0) {
114             return 0;
115         }
116 
117         uint256 c = a * b;
118         require(c / a == b, errorMessage);
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers.
125      * Reverts on division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers.
140      * Reverts with custom message on division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 contract Bank {
191     /// @notice EIP-20 token name for this token
192     string public constant name = "Bankless Token";
193 
194     /// @notice EIP-20 token symbol for this token
195     string public constant symbol = "BANK";
196 
197     /// @notice EIP-20 token decimals for this token
198     uint8 public constant decimals = 18;
199 
200     /// @notice Total number of tokens in circulation
201     uint public totalSupply = 1_000_000_000e18; // 1 billion Bank
202 
203     /// @notice Address which may mint new tokens
204     address public minter;
205 
206     /// @notice The timestamp after which minting may occur
207     uint public mintingAllowedAfter;
208 
209     /// @notice Minimum time between mints
210     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
211 
212     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
213     uint8 public constant mintCap = 2;
214 
215     /// @notice Allowance amounts on behalf of others
216     mapping (address => mapping (address => uint96)) internal allowances;
217 
218     /// @notice Official record of token balances for each account
219     mapping (address => uint96) internal balances;
220 
221     /// @notice A record of each accounts delegate
222     mapping (address => address) public delegates;
223 
224     /// @notice A checkpoint for marking number of votes from a given block
225     struct Checkpoint {
226         uint32 fromBlock;
227         uint96 votes;
228     }
229 
230     /// @notice A record of votes checkpoints for each account, by index
231     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
232 
233     /// @notice The number of checkpoints for each account
234     mapping (address => uint32) public numCheckpoints;
235 
236     /// @notice The EIP-712 typehash for the contract's domain
237     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
238 
239     /// @notice The EIP-712 typehash for the delegation struct used by the contract
240     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
241 
242     /// @notice The EIP-712 typehash for the permit struct used by the contract
243     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
244 
245     /// @notice A record of states for signing / validating signatures
246     mapping (address => uint) public nonces;
247 
248     /// @notice An event thats emitted when the minter address is changed
249     event MinterChanged(address minter, address newMinter);
250 
251     /// @notice An event thats emitted when an account changes its delegate
252     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
253 
254     /// @notice An event thats emitted when a delegate account's vote balance changes
255     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
256 
257     /// @notice The standard EIP-20 transfer event
258     event Transfer(address indexed from, address indexed to, uint256 amount);
259 
260     /// @notice The standard EIP-20 approval event
261     event Approval(address indexed owner, address indexed spender, uint256 amount);
262 
263     /**
264      * @notice Construct a new Bank token
265      * @param account The initial account to grant all the tokens
266      * @param minter_ The account with minting ability
267      * @param mintingAllowedAfter_ The timestamp after which minting may occur
268      */
269     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
270         require(mintingAllowedAfter_ >= block.timestamp, "Bank::constructor: minting can only begin after deployment");
271 
272         balances[account] = uint96(totalSupply);
273         emit Transfer(address(0), account, totalSupply);
274         minter = minter_;
275         emit MinterChanged(address(0), minter);
276         mintingAllowedAfter = mintingAllowedAfter_;
277     }
278 
279     /**
280      * @notice Change the minter address
281      * @param minter_ The address of the new minter
282      */
283     function setMinter(address minter_) external {
284         require(msg.sender == minter, "Bank::setMinter: only the minter can change the minter address");
285         emit MinterChanged(minter, minter_);
286         minter = minter_;
287     }
288 
289     /**
290      * @notice Mint new tokens
291      * @param dst The address of the destination account
292      * @param rawAmount The number of tokens to be minted
293      */
294     function mint(address dst, uint rawAmount) external {
295         require(msg.sender == minter, "Bank::mint: only the minter can mint");
296         require(block.timestamp >= mintingAllowedAfter, "Bank::mint: minting not allowed yet");
297         require(dst != address(0), "Bank::mint: cannot transfer to the zero address");
298 
299         // record the mint
300         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
301 
302         // mint the amount
303         uint96 amount = safe96(rawAmount, "Bank::mint: amount exceeds 96 bits");
304         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "Bank::mint: exceeded mint cap");
305         totalSupply = safe96(SafeMath.add(totalSupply, amount), "Bank::mint: totalSupply exceeds 96 bits");
306 
307         // transfer the amount to the recipient
308         balances[dst] = add96(balances[dst], amount, "Bank::mint: transfer amount overflows");
309         emit Transfer(address(0), dst, amount);
310 
311         // move delegates
312         _moveDelegates(address(0), delegates[dst], amount);
313     }
314 
315     /**
316      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
317      * @param account The address of the account holding the funds
318      * @param spender The address of the account spending the funds
319      * @return The number of tokens approved
320      */
321     function allowance(address account, address spender) external view returns (uint) {
322         return allowances[account][spender];
323     }
324 
325     /**
326      * @notice Approve `spender` to transfer up to `amount` from `src`
327      * @dev This will overwrite the approval amount for `spender`
328      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
329      * @param spender The address of the account which may transfer tokens
330      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
331      * @return Whether or not the approval succeeded
332      */
333     function approve(address spender, uint rawAmount) external returns (bool) {
334         uint96 amount;
335         if (rawAmount == uint(-1)) {
336             amount = uint96(-1);
337         } else {
338             amount = safe96(rawAmount, "Bank::approve: amount exceeds 96 bits");
339         }
340 
341         allowances[msg.sender][spender] = amount;
342 
343         emit Approval(msg.sender, spender, amount);
344         return true;
345     }
346 
347     /**
348      * @notice Triggers an approval from owner to spends
349      * @param owner The address to approve from
350      * @param spender The address to be approved
351      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
352      * @param deadline The time at which to expire the signature
353      * @param v The recovery byte of the signature
354      * @param r Half of the ECDSA signature pair
355      * @param s Half of the ECDSA signature pair
356      */
357     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
358         uint96 amount;
359         if (rawAmount == uint(-1)) {
360             amount = uint96(-1);
361         } else {
362             amount = safe96(rawAmount, "Bank::permit: amount exceeds 96 bits");
363         }
364 
365         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
366         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
367         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
368         address signatory = ecrecover(digest, v, r, s);
369         require(signatory != address(0), "Bank::permit: invalid signature");
370         require(signatory == owner, "Bank::permit: unauthorized");
371         require(now <= deadline, "Bank::permit: signature expired");
372 
373         allowances[owner][spender] = amount;
374 
375         emit Approval(owner, spender, amount);
376     }
377 
378     /**
379      * @notice Get the number of tokens held by the `account`
380      * @param account The address of the account to get the balance of
381      * @return The number of tokens held
382      */
383     function balanceOf(address account) external view returns (uint) {
384         return balances[account];
385     }
386 
387     /**
388      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
389      * @param dst The address of the destination account
390      * @param rawAmount The number of tokens to transfer
391      * @return Whether or not the transfer succeeded
392      */
393     function transfer(address dst, uint rawAmount) external returns (bool) {
394         uint96 amount = safe96(rawAmount, "Bank::transfer: amount exceeds 96 bits");
395         _transferTokens(msg.sender, dst, amount);
396         return true;
397     }
398 
399     /**
400      * @notice Transfer `amount` tokens from `src` to `dst`
401      * @param src The address of the source account
402      * @param dst The address of the destination account
403      * @param rawAmount The number of tokens to transfer
404      * @return Whether or not the transfer succeeded
405      */
406     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
407         address spender = msg.sender;
408         uint96 spenderAllowance = allowances[src][spender];
409         uint96 amount = safe96(rawAmount, "Bank::approve: amount exceeds 96 bits");
410 
411         if (spender != src && spenderAllowance != uint96(-1)) {
412             uint96 newAllowance = sub96(spenderAllowance, amount, "Bank::transferFrom: transfer amount exceeds spender allowance");
413             allowances[src][spender] = newAllowance;
414 
415             emit Approval(src, spender, newAllowance);
416         }
417 
418         _transferTokens(src, dst, amount);
419         return true;
420     }
421 
422     /**
423      * @notice Delegate votes from `msg.sender` to `delegatee`
424      * @param delegatee The address to delegate votes to
425      */
426     function delegate(address delegatee) public {
427         return _delegate(msg.sender, delegatee);
428     }
429 
430     /**
431      * @notice Delegates votes from signatory to `delegatee`
432      * @param delegatee The address to delegate votes to
433      * @param nonce The contract state required to match the signature
434      * @param expiry The time at which to expire the signature
435      * @param v The recovery byte of the signature
436      * @param r Half of the ECDSA signature pair
437      * @param s Half of the ECDSA signature pair
438      */
439     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
440         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
441         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
442         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
443         address signatory = ecrecover(digest, v, r, s);
444         require(signatory != address(0), "Bank::delegateBySig: invalid signature");
445         require(nonce == nonces[signatory]++, "Bank::delegateBySig: invalid nonce");
446         require(now <= expiry, "Bank::delegateBySig: signature expired");
447         return _delegate(signatory, delegatee);
448     }
449 
450     /**
451      * @notice Gets the current votes balance for `account`
452      * @param account The address to get votes balance
453      * @return The number of current votes for `account`
454      */
455     function getCurrentVotes(address account) external view returns (uint96) {
456         uint32 nCheckpoints = numCheckpoints[account];
457         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
458     }
459 
460     /**
461      * @notice Determine the prior number of votes for an account as of a block number
462      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
463      * @param account The address of the account to check
464      * @param blockNumber The block number to get the vote balance at
465      * @return The number of votes the account had as of the given block
466      */
467     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
468         require(blockNumber < block.number, "Bank::getPriorVotes: not yet determined");
469 
470         uint32 nCheckpoints = numCheckpoints[account];
471         if (nCheckpoints == 0) {
472             return 0;
473         }
474 
475         // First check most recent balance
476         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
477             return checkpoints[account][nCheckpoints - 1].votes;
478         }
479 
480         // Next check implicit zero balance
481         if (checkpoints[account][0].fromBlock > blockNumber) {
482             return 0;
483         }
484 
485         uint32 lower = 0;
486         uint32 upper = nCheckpoints - 1;
487         while (upper > lower) {
488             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
489             Checkpoint memory cp = checkpoints[account][center];
490             if (cp.fromBlock == blockNumber) {
491                 return cp.votes;
492             } else if (cp.fromBlock < blockNumber) {
493                 lower = center;
494             } else {
495                 upper = center - 1;
496             }
497         }
498         return checkpoints[account][lower].votes;
499     }
500 
501     function _delegate(address delegator, address delegatee) internal {
502         address currentDelegate = delegates[delegator];
503         uint96 delegatorBalance = balances[delegator];
504         delegates[delegator] = delegatee;
505 
506         emit DelegateChanged(delegator, currentDelegate, delegatee);
507 
508         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
509     }
510 
511     function _transferTokens(address src, address dst, uint96 amount) internal {
512         require(src != address(0), "Bank::_transferTokens: cannot transfer from the zero address");
513         require(dst != address(0), "Bank::_transferTokens: cannot transfer to the zero address");
514         require(dst != address(this), "Bank::_transferTokens: cannot transfer to token address");
515 
516         balances[src] = sub96(balances[src], amount, "Bank::_transferTokens: transfer amount exceeds balance");
517         balances[dst] = add96(balances[dst], amount, "Bank::_transferTokens: transfer amount overflows");
518         emit Transfer(src, dst, amount);
519 
520         _moveDelegates(delegates[src], delegates[dst], amount);
521     }
522 
523     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
524         if (srcRep != dstRep && amount > 0) {
525             if (srcRep != address(0)) {
526                 uint32 srcRepNum = numCheckpoints[srcRep];
527                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
528                 uint96 srcRepNew = sub96(srcRepOld, amount, "Bank::_moveVotes: vote amount underflows");
529                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
530             }
531 
532             if (dstRep != address(0)) {
533                 uint32 dstRepNum = numCheckpoints[dstRep];
534                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
535                 uint96 dstRepNew = add96(dstRepOld, amount, "Bank::_moveVotes: vote amount overflows");
536                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
537             }
538         }
539     }
540 
541     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
542       uint32 blockNumber = safe32(block.number, "Bank::_writeCheckpoint: block number exceeds 32 bits");
543 
544       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
545           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
546       } else {
547           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
548           numCheckpoints[delegatee] = nCheckpoints + 1;
549       }
550 
551       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
552     }
553 
554     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
555         require(n < 2**32, errorMessage);
556         return uint32(n);
557     }
558 
559     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
560         require(n < 2**96, errorMessage);
561         return uint96(n);
562     }
563 
564     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
565         uint96 c = a + b;
566         require(c >= a, errorMessage);
567         return c;
568     }
569 
570     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
571         require(b <= a, errorMessage);
572         return a - b;
573     }
574 
575     function getChainId() internal pure returns (uint) {
576         uint256 chainId;
577         assembly { chainId := chainid() }
578         return chainId;
579     }
580 }