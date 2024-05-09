1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 
7 
8 // Part: SafeMath
9 
10 // Subject to the MIT license.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations with added overflow
14  * checks.
15  *
16  * Arithmetic operations in Solidity wrap on overflow. This can easily result
17  * in bugs, because programmers usually assume that an overflow raises an
18  * error, which is the standard behavior in high level programming languages.
19  * `SafeMath` restores this intuition by reverting the transaction when an
20  * operation overflows.
21  *
22  * Using this library instead of the unchecked operations eliminates an entire
23  * class of bugs, so it's recommended to use it always.
24  */
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, reverting on overflow.
28      *
29      * Counterpart to Solidity's `+` operator.
30      *
31      * Requirements:
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, errorMessage);
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      * - Subtraction cannot underflow.
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction underflow");
66     }
67 
68     /**
69      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot underflow.
75      */
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      * - Multiplication cannot overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
107      *
108      * Counterpart to Solidity's `*` operator.
109      *
110      * Requirements:
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, errorMessage);
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers.
129      * Reverts on division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers.
144      * Reverts with custom message on division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         // Solidity only automatically asserts when dividing by 0
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return mod(a, b, "SafeMath: modulo by zero");
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts with custom message when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b != 0, errorMessage);
190         return a % b;
191     }
192 }
193 
194 // File: GTC.sol
195 
196 contract GTC {
197     /// @notice EIP-20 token name for this token
198     string public constant name = "Gitcoin";
199 
200     /// @notice EIP-20 token symbol for this token
201     string public constant symbol = "GTC";
202 
203     /// @notice EIP-20 token decimals for this token
204     uint8 public constant decimals = 18;
205 
206     /// @notice Total number of tokens in circulation
207     uint public totalSupply = 100_000_000e18; // 100 million GTC
208 
209     /// @notice Address which may mint new tokens
210     address public minter;
211 
212     /// @notice Address of the GTCDistribution contract 
213     address public GTCDist;
214 
215     /// @notice The timestamp after which minting may occur
216     uint public mintingAllowedAfter;
217 
218     /// @notice Minimum time between mints
219     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
220 
221     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
222     uint8 public constant mintCap = 2;
223 
224     /// @notice Allowance amounts on behalf of others
225     mapping (address => mapping (address => uint96)) internal allowances;
226 
227     /// @notice Official record of token balances for each account
228     mapping (address => uint96) internal balances;
229 
230     /// @notice A record of each accounts delegate
231     mapping (address => address) public delegates;
232 
233     /// @notice A checkpoint for marking number of votes from a given block
234     struct Checkpoint {
235         uint32 fromBlock;
236         uint96 votes;
237     }
238 
239     /// @notice A record of votes checkpoints for each account, by index
240     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
241 
242     /// @notice The number of checkpoints for each account
243     mapping (address => uint32) public numCheckpoints;
244 
245     /// @notice The EIP-712 typehash for the contract's domain
246     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
247 
248     /// @notice The EIP-712 typehash for the delegation struct used by the contract
249     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
250 
251     /// @notice The EIP-712 typehash for the permit struct used by the contract
252     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
253 
254     /// @notice A record of states for signing / validating signatures
255     mapping (address => uint) public nonces;
256 
257     /// @notice An event thats emitted when the minter address is changed
258     event MinterChanged(address minter, address newMinter);
259 
260     /// @notice An event thats emitted when the minter address is changed
261     event GTCDistChanged(address delegator, address delegatee);
262 
263     /// @notice An event thats emitted when an account changes its delegate
264     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
265 
266     /// @notice An event thats emitted when a delegate account's vote balance changes
267     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
268 
269     /// @notice The standard EIP-20 transfer event
270     event Transfer(address indexed from, address indexed to, uint256 amount);
271 
272     /// @notice The standard EIP-20 approval event
273     event Approval(address indexed owner, address indexed spender, uint256 amount);
274 
275     /**
276      * @notice Construct a new GTC token
277      * @param account The initial account to grant all the tokens
278      * @param minter_ The account with minting ability
279      * @param mintingAllowedAfter_ The timestamp after which minting may occur
280      */
281     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
282         require(mintingAllowedAfter_ >= block.timestamp, "GTC::constructor: minting can only begin after deployment");
283         balances[account] = uint96(totalSupply);
284         emit Transfer(address(0), account, totalSupply);
285         minter = minter_;
286         emit MinterChanged(address(0), minter);
287         mintingAllowedAfter = mintingAllowedAfter_;
288     }
289 
290     /**
291      * @notice Change the minter address
292      * @param minter_ The address of the new minter
293      */
294     function setMinter(address minter_) external {
295         require(msg.sender == minter, "GTC::setMinter: only the minter can change the minter address");
296         emit MinterChanged(minter, minter_);
297         minter = minter_;
298     }
299 
300     /**
301      * @notice Change/set TokenDistribution address, needs to be called after GTCToken contract is deployed 
302      * @param GTCDist_ The address of the TokenDistributor contract
303      */
304     function setGTCDist(address GTCDist_) external {
305         require(msg.sender == minter, "GTC::setGTCDist: only the minter can change the GTCDist address");
306         emit GTCDistChanged(GTCDist, GTCDist_);
307         GTCDist = GTCDist_;
308     }
309 
310     /**
311      * @notice Mint new tokens
312      * @param dst The address of the destination account
313      * @param rawAmount The number of tokens to be minted
314      */
315     function mint(address dst, uint rawAmount) external {
316         require(msg.sender == minter, "GTC::mint: only the minter can mint");
317         require(block.timestamp >= mintingAllowedAfter, "GTC::mint: minting not allowed yet");
318         require(dst != address(0), "GTC::mint: cannot transfer to the zero address");
319 
320         // record the mint
321         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
322 
323         // mint the amount
324         uint96 amount = safe96(rawAmount, "GTC::mint: amount exceeds 96 bits");
325         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "GTC::mint: exceeded mint cap");
326         totalSupply = safe96(SafeMath.add(totalSupply, amount), "GTC::mint: totalSupply exceeds 96 bits");
327 
328         // transfer the amount to the recipient
329         balances[dst] = add96(balances[dst], amount, "GTC::mint: transfer amount overflows");
330         emit Transfer(address(0), dst, amount);
331 
332         // move delegates
333         _moveDelegates(address(0), delegates[dst], amount);
334     }
335 
336     /**
337      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
338      * @param account The address of the account holding the funds
339      * @param spender The address of the account spending the funds
340      * @return The number of tokens approved
341      */
342     function allowance(address account, address spender) external view returns (uint) {
343         return allowances[account][spender];
344     }
345 
346     /**
347      * @notice Approve `spender` to transfer up to `amount` from `src`
348      * @dev This will overwrite the approval amount for `spender`
349      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
350      * @param spender The address of the account which may transfer tokens
351      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
352      * @return Whether or not the approval succeeded
353      */
354     function approve(address spender, uint rawAmount) external returns (bool) {
355         uint96 amount;
356         if (rawAmount == uint(-1)) {
357             amount = uint96(-1);
358         } else {
359             amount = safe96(rawAmount, "GTC::approve: amount exceeds 96 bits");
360         }
361 
362         allowances[msg.sender][spender] = amount;
363 
364         emit Approval(msg.sender, spender, amount);
365         return true;
366     }
367 
368     /**
369      * @notice Triggers an approval from owner to spends
370      * @param owner The address to approve from
371      * @param spender The address to be approved
372      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
373      * @param deadline The time at which to expire the signature
374      * @param v The recovery byte of the signature
375      * @param r Half of the ECDSA signature pair
376      * @param s Half of the ECDSA signature pair
377      */
378     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
379         uint96 amount;
380         if (rawAmount == uint(-1)) {
381             amount = uint96(-1);
382         } else {
383             amount = safe96(rawAmount, "GTC::permit: amount exceeds 96 bits");
384         }
385 
386         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
387         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
388         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
389         address signatory = ecrecover(digest, v, r, s);
390         require(signatory != address(0), "GTC::permit: invalid signature");
391         require(signatory == owner, "GTC::permit: unauthorized");
392         require(now <= deadline, "GTC::permit: signature expired");
393 
394         allowances[owner][spender] = amount;
395 
396         emit Approval(owner, spender, amount);
397     }
398 
399     /**
400      * @notice Get the number of tokens held by the `account`
401      * @param account The address of the account to get the balance of
402      * @return The number of tokens held
403      */
404     function balanceOf(address account) external view returns (uint) {
405         return balances[account];
406     }
407 
408     /**
409      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
410      * @param dst The address of the destination account
411      * @param rawAmount The number of tokens to transfer
412      * @return Whether or not the transfer succeeded
413      */
414     function transfer(address dst, uint rawAmount) external returns (bool) {
415         uint96 amount = safe96(rawAmount, "GTC::transfer: amount exceeds 96 bits");
416         _transferTokens(msg.sender, dst, amount);
417         return true;
418     }
419 
420     /**
421      * @notice Transfer `amount` tokens from `src` to `dst`
422      * @param src The address of the source account
423      * @param dst The address of the destination account
424      * @param rawAmount The number of tokens to transfer
425      * @return Whether or not the transfer succeeded
426      */
427     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
428         address spender = msg.sender;
429         uint96 spenderAllowance = allowances[src][spender];
430         uint96 amount = safe96(rawAmount, "GTC::approve: amount exceeds 96 bits");
431 
432         if (spender != src && spenderAllowance != uint96(-1)) {
433             uint96 newAllowance = sub96(spenderAllowance, amount, "GTC::transferFrom: transfer amount exceeds spender allowance");
434             allowances[src][spender] = newAllowance;
435 
436             emit Approval(src, spender, newAllowance);
437         }
438 
439         _transferTokens(src, dst, amount);
440         return true;
441     }
442 
443     /**
444      * @notice Delegate votes from `msg.sender` to `delegatee`
445      * @param delegatee The address to delegate votes to
446      */
447     function delegate(address delegatee) external {
448         return _delegate(msg.sender, delegatee);
449     }
450 
451     /**
452      * @notice Delegate votes from `delegator` to `delegatee` 
453      * @param delegator The address to delegate votes from 
454      * @param delegatee The address to delegate votes to
455      */
456     function delegateOnDist(address delegator, address delegatee) external {
457         require(msg.sender == GTCDist, "Sender not authorized");
458         return _delegate(delegator, delegatee);
459     }
460 
461     /**
462      * @notice Delegates votes from signatory to `delegatee`
463      * @param delegatee The address to delegate votes to
464      * @param nonce The contract state required to match the signature
465      * @param expiry The time at which to expire the signature
466      * @param v The recovery byte of the signature
467      * @param r Half of the ECDSA signature pair
468      * @param s Half of the ECDSA signature pair
469      */
470     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external {
471         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
472         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
473         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
474         address signatory = ecrecover(digest, v, r, s);
475         require(signatory != address(0), "GTC::delegateBySig: invalid signature");
476         require(nonce == nonces[signatory]++, "GTC::delegateBySig: invalid nonce");
477         require(now <= expiry, "GTC::delegateBySig: signature expired");
478         return _delegate(signatory, delegatee);
479     }
480 
481     /**
482      * @notice Gets the current votes balance for `account`
483      * @param account The address to get votes balance
484      * @return The number of current votes for `account`
485      */
486     function getCurrentVotes(address account) external view returns (uint96) {
487         uint32 nCheckpoints = numCheckpoints[account];
488         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
489     }
490 
491     /**
492      * @notice Determine the prior number of votes for an account as of a block number
493      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
494      * @param account The address of the account to check
495      * @param blockNumber The block number to get the vote balance at
496      * @return The number of votes the account had as of the given block
497      */
498     function getPriorVotes(address account, uint blockNumber) external view returns (uint96) {
499         require(blockNumber < block.number, "GTC::getPriorVotes: not yet determined");
500 
501         uint32 nCheckpoints = numCheckpoints[account];
502         if (nCheckpoints == 0) {
503             return 0;
504         }
505 
506         // First check most recent balance
507         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
508             return checkpoints[account][nCheckpoints - 1].votes;
509         }
510 
511         // Next check implicit zero balance
512         if (checkpoints[account][0].fromBlock > blockNumber) {
513             return 0;
514         }
515 
516         uint32 lower = 0;
517         uint32 upper = nCheckpoints - 1;
518         while (upper > lower) {
519             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
520             Checkpoint memory cp = checkpoints[account][center];
521             if (cp.fromBlock == blockNumber) {
522                 return cp.votes;
523             } else if (cp.fromBlock < blockNumber) {
524                 lower = center;
525             } else {
526                 upper = center - 1;
527             }
528         }
529         return checkpoints[account][lower].votes;
530     }
531 
532     function _delegate(address delegator, address delegatee) internal {
533         address currentDelegate = delegates[delegator]; 
534         uint96 delegatorBalance = balances[delegator];
535         delegates[delegator] = delegatee;
536 
537         emit DelegateChanged(delegator, currentDelegate, delegatee);
538 
539         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
540     }
541 
542     function _transferTokens(address src, address dst, uint96 amount) internal {
543         require(src != address(0), "GTC::_transferTokens: cannot transfer from the zero address");
544         require(dst != address(0), "GTC::_transferTokens: cannot transfer to the zero address");
545 
546         balances[src] = sub96(balances[src], amount, "GTC::_transferTokens: transfer amount exceeds balance");
547         balances[dst] = add96(balances[dst], amount, "GTC::_transferTokens: transfer amount overflows");
548         emit Transfer(src, dst, amount);
549 
550         _moveDelegates(delegates[src], delegates[dst], amount);
551     }
552 
553     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
554         if (srcRep != dstRep && amount > 0) {
555             if (srcRep != address(0)) {
556                 uint32 srcRepNum = numCheckpoints[srcRep];
557                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
558                 uint96 srcRepNew = sub96(srcRepOld, amount, "GTC::_moveVotes: vote amount underflows");
559                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
560             }
561 
562             if (dstRep != address(0)) {
563                 uint32 dstRepNum = numCheckpoints[dstRep];
564                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
565                 uint96 dstRepNew = add96(dstRepOld, amount, "GTC::_moveVotes: vote amount overflows");
566                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
567             }
568         }
569     }
570 
571     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
572       uint32 blockNumber = safe32(block.number, "GTC::_writeCheckpoint: block number exceeds 32 bits");
573 
574       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
575           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
576       } else {
577           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
578           numCheckpoints[delegatee] = nCheckpoints + 1;
579       }
580 
581       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
582     }
583 
584     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
585         require(n < 2**32, errorMessage);
586         return uint32(n);
587     }
588 
589     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
590         require(n < 2**96, errorMessage);
591         return uint96(n);
592     }
593 
594     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
595         uint96 c = a + b;
596         require(c >= a, errorMessage);
597         return c;
598     }
599 
600     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
601         require(b <= a, errorMessage);
602         return a - b;
603     }
604 
605     function getChainId() internal pure returns (uint) {
606         uint256 chainId;
607         assembly { chainId := chainid() }
608         return chainId;
609     }
610 
611 }
