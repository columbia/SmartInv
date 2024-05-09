1 // GEL token forked from Uniswap UNI Token contract: https://etherscan.io/address/0x1f9840a85d5af5bf1d1762f925bdaddc4201f984#code
2 pragma solidity ^0.5.16;
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
190 contract Gel {
191     /// @notice EIP-20 token name for this token
192     string public constant name = "Gelato Network Token";
193 
194     /// @notice EIP-20 token symbol for this token
195     string public constant symbol = "GEL";
196 
197     /// @notice EIP-20 token decimals for this token
198     uint8 public constant decimals = 18;
199 
200     /// @notice Total number of tokens in circulation
201     uint public totalSupply = 420_690_000e18; // 420,690,000.00 Gel
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
213     uint8 public mintCap = 100;
214 
215     bool public isMintCapImmutable = false;
216 
217     /// @notice Allowance amounts on behalf of others
218     mapping (address => mapping (address => uint96)) internal allowances;
219 
220     /// @notice Official record of token balances for each account
221     mapping (address => uint96) internal balances;
222 
223     /// @notice A record of each accounts delegate
224     mapping (address => address) public delegates;
225 
226     /// @notice A checkpoint for marking number of votes from a given block
227     struct Checkpoint {
228         uint32 fromBlock;
229         uint96 votes;
230     }
231 
232     /// @notice A record of votes checkpoints for each account, by index
233     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
234 
235     /// @notice The number of checkpoints for each account
236     mapping (address => uint32) public numCheckpoints;
237 
238     /// @notice The EIP-712 typehash for the contract's domain
239     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
240 
241     /// @notice The EIP-712 typehash for the delegation struct used by the contract
242     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
243 
244     /// @notice The EIP-712 typehash for the permit struct used by the contract
245     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
246 
247     /// @notice A record of states for signing / validating signatures
248     mapping (address => uint) public nonces;
249 
250     /// @notice An event thats emitted when the minter address is changed
251     event MinterChanged(address minter, address newMinter);
252 
253     /// @notice An event thats emitted when an account changes its delegate
254     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
255 
256     /// @notice An event thats emitted when a delegate account's vote balance changes
257     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
258 
259     /// @notice The standard EIP-20 transfer event
260     event Transfer(address indexed from, address indexed to, uint256 amount);
261 
262     /// @notice The standard EIP-20 approval event
263     event Approval(address indexed owner, address indexed spender, uint256 amount);
264 
265     /**
266      * @notice Construct a new Gel token
267      * @param account The initial account to grant all the tokens
268      * @param minter_ The account with minting ability
269      * @param mintingAllowedAfter_ The timestamp after which minting may occur
270      */
271     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
272         require(mintingAllowedAfter_ >= block.timestamp, "Gel::constructor: minting can only begin after deployment");
273 
274         balances[account] = uint96(totalSupply);
275         emit Transfer(address(0), account, totalSupply);
276         minter = minter_;
277         emit MinterChanged(address(0), minter);
278         mintingAllowedAfter = mintingAllowedAfter_;
279     }
280 
281     /**
282      * @notice Change the minter address
283      * @param minter_ The address of the new minter
284      */
285     function setMinter(address minter_) external {
286         require(msg.sender == minter, "Gel::setMinter: only the minter can change the minter address");
287         emit MinterChanged(minter, minter_);
288         minter = minter_;
289     }
290 
291     /**
292      * @notice Change mintCap property to immutable, can be called once.
293      * @param _mintCap final minCap
294      */
295     function setImmutableMintCap(uint8 _mintCap) external {
296         require(msg.sender == minter, "Gel::setImmutableMintCap: only the minter can change mintCap to immutable");
297         require(!isMintCapImmutable, "Gel::setImmutableMintCap: minCap is immutable");
298         isMintCapImmutable = true;
299         mintCap = _mintCap;
300     }
301 
302     /**
303      * @notice Mint new tokens
304      * @param dst The address of the destination account
305      * @param rawAmount The number of tokens to be minted
306      */
307     function mint(address dst, uint rawAmount) external {
308         require(msg.sender == minter, "Gel::mint: only the minter can mint");
309         require(block.timestamp >= mintingAllowedAfter, "Gel::mint: minting not allowed yet");
310         require(dst != address(0), "Gel::mint: cannot transfer to the zero address");
311 
312         // record the mint
313         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
314 
315         // mint the amount
316         uint96 amount = safe96(rawAmount, "Gel::mint: amount exceeds 96 bits");
317         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "Gel::mint: exceeded mint cap");
318         totalSupply = safe96(SafeMath.add(totalSupply, amount), "Gel::mint: totalSupply exceeds 96 bits");
319 
320         // transfer the amount to the recipient
321         balances[dst] = add96(balances[dst], amount, "Gel::mint: transfer amount overflows");
322         emit Transfer(address(0), dst, amount);
323 
324         // move delegates
325         _moveDelegates(address(0), delegates[dst], amount);
326     }
327 
328     /**
329      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
330      * @param account The address of the account holding the funds
331      * @param spender The address of the account spending the funds
332      * @return The number of tokens approved
333      */
334     function allowance(address account, address spender) external view returns (uint) {
335         return allowances[account][spender];
336     }
337 
338     /**
339      * @notice Approve `spender` to transfer up to `amount` from `src`
340      * @dev This will overwrite the approval amount for `spender`
341      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
342      * @param spender The address of the account which may transfer tokens
343      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
344      * @return Whether or not the approval succeeded
345      */
346     function approve(address spender, uint rawAmount) external returns (bool) {
347         uint96 amount;
348         if (rawAmount == uint(-1)) {
349             amount = uint96(-1);
350         } else {
351             amount = safe96(rawAmount, "Gel::approve: amount exceeds 96 bits");
352         }
353 
354         allowances[msg.sender][spender] = amount;
355 
356         emit Approval(msg.sender, spender, amount);
357         return true;
358     }
359 
360     /**
361      * @notice Triggers an approval from owner to spends
362      * @param owner The address to approve from
363      * @param spender The address to be approved
364      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
365      * @param deadline The time at which to expire the signature
366      * @param v The recovery byte of the signature
367      * @param r Half of the ECDSA signature pair
368      * @param s Half of the ECDSA signature pair
369      */
370     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
371         uint96 amount;
372         if (rawAmount == uint(-1)) {
373             amount = uint96(-1);
374         } else {
375             amount = safe96(rawAmount, "Gel::permit: amount exceeds 96 bits");
376         }
377 
378         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
379         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
380         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
381         address signatory = ecrecover(digest, v, r, s);
382         require(signatory != address(0), "Gel::permit: invalid signature");
383         require(signatory == owner, "Gel::permit: unauthorized");
384         require(now <= deadline, "Gel::permit: signature expired");
385 
386         allowances[owner][spender] = amount;
387 
388         emit Approval(owner, spender, amount);
389     }
390 
391     /**
392      * @notice Get the number of tokens held by the `account`
393      * @param account The address of the account to get the balance of
394      * @return The number of tokens held
395      */
396     function balanceOf(address account) external view returns (uint) {
397         return balances[account];
398     }
399 
400     /**
401      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
402      * @param dst The address of the destination account
403      * @param rawAmount The number of tokens to transfer
404      * @return Whether or not the transfer succeeded
405      */
406     function transfer(address dst, uint rawAmount) external returns (bool) {
407         uint96 amount = safe96(rawAmount, "Gel::transfer: amount exceeds 96 bits");
408         _transferTokens(msg.sender, dst, amount);
409         return true;
410     }
411 
412     /**
413      * @notice Transfer `amount` tokens from `src` to `dst`
414      * @param src The address of the source account
415      * @param dst The address of the destination account
416      * @param rawAmount The number of tokens to transfer
417      * @return Whether or not the transfer succeeded
418      */
419     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
420         address spender = msg.sender;
421         uint96 spenderAllowance = allowances[src][spender];
422         uint96 amount = safe96(rawAmount, "Gel::approve: amount exceeds 96 bits");
423 
424         if (spender != src && spenderAllowance != uint96(-1)) {
425             uint96 newAllowance = sub96(spenderAllowance, amount, "Gel::transferFrom: transfer amount exceeds spender allowance");
426             allowances[src][spender] = newAllowance;
427 
428             emit Approval(src, spender, newAllowance);
429         }
430 
431         _transferTokens(src, dst, amount);
432         return true;
433     }
434 
435     /**
436      * @notice Delegate votes from `msg.sender` to `delegatee`
437      * @param delegatee The address to delegate votes to
438      */
439     function delegate(address delegatee) public {
440         return _delegate(msg.sender, delegatee);
441     }
442 
443     /**
444      * @notice Delegates votes from signatory to `delegatee`
445      * @param delegatee The address to delegate votes to
446      * @param nonce The contract state required to match the signature
447      * @param expiry The time at which to expire the signature
448      * @param v The recovery byte of the signature
449      * @param r Half of the ECDSA signature pair
450      * @param s Half of the ECDSA signature pair
451      */
452     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
453         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
454         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
455         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
456         address signatory = ecrecover(digest, v, r, s);
457         require(signatory != address(0), "Gel::delegateBySig: invalid signature");
458         require(nonce == nonces[signatory]++, "Gel::delegateBySig: invalid nonce");
459         require(now <= expiry, "Gel::delegateBySig: signature expired");
460         return _delegate(signatory, delegatee);
461     }
462 
463     /**
464      * @notice Gets the current votes balance for `account`
465      * @param account The address to get votes balance
466      * @return The number of current votes for `account`
467      */
468     function getCurrentVotes(address account) external view returns (uint96) {
469         uint32 nCheckpoints = numCheckpoints[account];
470         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
471     }
472 
473     /**
474      * @notice Determine the prior number of votes for an account as of a block number
475      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
476      * @param account The address of the account to check
477      * @param blockNumber The block number to get the vote balance at
478      * @return The number of votes the account had as of the given block
479      */
480     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
481         require(blockNumber < block.number, "Gel::getPriorVotes: not yet determined");
482 
483         uint32 nCheckpoints = numCheckpoints[account];
484         if (nCheckpoints == 0) {
485             return 0;
486         }
487 
488         // First check most recent balance
489         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
490             return checkpoints[account][nCheckpoints - 1].votes;
491         }
492 
493         // Next check implicit zero balance
494         if (checkpoints[account][0].fromBlock > blockNumber) {
495             return 0;
496         }
497 
498         uint32 lower = 0;
499         uint32 upper = nCheckpoints - 1;
500         while (upper > lower) {
501             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
502             Checkpoint memory cp = checkpoints[account][center];
503             if (cp.fromBlock == blockNumber) {
504                 return cp.votes;
505             } else if (cp.fromBlock < blockNumber) {
506                 lower = center;
507             } else {
508                 upper = center - 1;
509             }
510         }
511         return checkpoints[account][lower].votes;
512     }
513 
514     function _delegate(address delegator, address delegatee) internal {
515         address currentDelegate = delegates[delegator];
516         uint96 delegatorBalance = balances[delegator];
517         delegates[delegator] = delegatee;
518 
519         emit DelegateChanged(delegator, currentDelegate, delegatee);
520 
521         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
522     }
523 
524     function _transferTokens(address src, address dst, uint96 amount) internal {
525         require(src != address(0), "Gel::_transferTokens: cannot transfer from the zero address");
526         require(dst != address(0), "Gel::_transferTokens: cannot transfer to the zero address");
527 
528         balances[src] = sub96(balances[src], amount, "Gel::_transferTokens: transfer amount exceeds balance");
529         balances[dst] = add96(balances[dst], amount, "Gel::_transferTokens: transfer amount overflows");
530         emit Transfer(src, dst, amount);
531 
532         _moveDelegates(delegates[src], delegates[dst], amount);
533     }
534 
535     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
536         if (srcRep != dstRep && amount > 0) {
537             if (srcRep != address(0)) {
538                 uint32 srcRepNum = numCheckpoints[srcRep];
539                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
540                 uint96 srcRepNew = sub96(srcRepOld, amount, "Gel::_moveVotes: vote amount underflows");
541                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
542             }
543 
544             if (dstRep != address(0)) {
545                 uint32 dstRepNum = numCheckpoints[dstRep];
546                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
547                 uint96 dstRepNew = add96(dstRepOld, amount, "Gel::_moveVotes: vote amount overflows");
548                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
549             }
550         }
551     }
552 
553     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
554       uint32 blockNumber = safe32(block.number, "Gel::_writeCheckpoint: block number exceeds 32 bits");
555 
556       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
557           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
558       } else {
559           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
560           numCheckpoints[delegatee] = nCheckpoints + 1;
561       }
562 
563       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
564     }
565 
566     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
567         require(n < 2**32, errorMessage);
568         return uint32(n);
569     }
570 
571     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
572         require(n < 2**96, errorMessage);
573         return uint96(n);
574     }
575 
576     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
577         uint96 c = a + b;
578         require(c >= a, errorMessage);
579         return c;
580     }
581 
582     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
583         require(b <= a, errorMessage);
584         return a - b;
585     }
586 
587     function getChainId() internal pure returns (uint) {
588         uint256 chainId;
589         assembly { chainId := chainid() }
590         return chainId;
591     }
592 }