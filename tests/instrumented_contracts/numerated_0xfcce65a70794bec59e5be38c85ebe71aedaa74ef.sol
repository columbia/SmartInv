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
189 contract Gain {
190     /// @notice EIP-20 token name for this token
191     string public constant name = "GainSwap";
192 
193     /// @notice EIP-20 token symbol for this token
194     string public constant symbol = "GAIN";
195 
196     /// @notice EIP-20 token decimals for this token
197     uint8 public constant decimals = 18;
198 
199     /// @notice Total number of tokens in circulation
200     uint public totalSupply = 30_000e18; // 30,000 Gain
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
263      * @notice Construct a new Gain token
264      * @param account The initial account to grant all the tokens
265      * @param minter_ The account with minting ability
266      * @param mintingAllowedAfter_ The timestamp after which minting may occur
267      */
268     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
269         require(mintingAllowedAfter_ >= block.timestamp, "Gain::constructor: minting can only begin after deployment");
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
283         require(msg.sender == minter, "Gain::setMinter: only the minter can change the minter address");
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
294         require(msg.sender == minter, "Gain::mint: only the minter can mint");
295         require(block.timestamp >= mintingAllowedAfter, "Gain::mint: minting not allowed yet");
296         require(dst != address(0), "Gain::mint: cannot transfer to the zero address");
297 
298         // record the mint
299         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
300 
301         // mint the amount
302         uint96 amount = safe96(rawAmount, "Gain::mint: amount exceeds 96 bits");
303         require(amount <= SafeMath.div(SafeMath.mul(totalSupply, mintCap), 100), "Gain::mint: exceeded mint cap");
304         totalSupply = safe96(SafeMath.add(totalSupply, amount), "Gain::mint: totalSupply exceeds 96 bits");
305 
306         // transfer the amount to the recipient
307         balances[dst] = add96(balances[dst], amount, "Gain::mint: transfer amount overflows");
308         emit Transfer(address(0), dst, amount);
309 
310         // move delegates
311         _moveDelegates(address(0), delegates[dst], amount);
312     }
313     
314     /**
315      * @notice Burn tokens
316      * @param rawAmount The number of tokens to be burned
317      */
318     function burn(uint rawAmount) public {
319         uint96 amount = safe96(rawAmount, "Gain::mint: amount exceeds 96 bits");
320         require(balances[msg.sender] >= amount, "Gain::burn: insufficient balance");
321         totalSupply = safe96(SafeMath.sub(totalSupply, amount), "Gain::burn: insufficient balance");
322         balances[msg.sender] = safe96(SafeMath.sub(balances[msg.sender], amount), "Gain::burn: insufficient balance");
323     }
324 
325     /**
326      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
327      * @param account The address of the account holding the funds
328      * @param spender The address of the account spending the funds
329      * @return The number of tokens approved
330      */
331     function allowance(address account, address spender) external view returns (uint) {
332         return allowances[account][spender];
333     }
334 
335     /**
336      * @notice Approve `spender` to transfer up to `amount` from `src`
337      * @dev This will overwrite the approval amount for `spender`
338      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
339      * @param spender The address of the account which may transfer tokens
340      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
341      * @return Whether or not the approval succeeded
342      */
343     function approve(address spender, uint rawAmount) external returns (bool) {
344         uint96 amount;
345         if (rawAmount == uint(-1)) {
346             amount = uint96(-1);
347         } else {
348             amount = safe96(rawAmount, "Gain::approve: amount exceeds 96 bits");
349         }
350 
351         allowances[msg.sender][spender] = amount;
352 
353         emit Approval(msg.sender, spender, amount);
354         return true;
355     }
356 
357     /**
358      * @notice Triggers an approval from owner to spends
359      * @param owner The address to approve from
360      * @param spender The address to be approved
361      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
362      * @param deadline The time at which to expire the signature
363      * @param v The recovery byte of the signature
364      * @param r Half of the ECDSA signature pair
365      * @param s Half of the ECDSA signature pair
366      */
367     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
368         uint96 amount;
369         if (rawAmount == uint(-1)) {
370             amount = uint96(-1);
371         } else {
372             amount = safe96(rawAmount, "Gain::permit: amount exceeds 96 bits");
373         }
374 
375         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
376         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
377         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
378         address signatory = ecrecover(digest, v, r, s);
379         require(signatory != address(0), "Gain::permit: invalid signature");
380         require(signatory == owner, "Gain::permit: unauthorized");
381         require(now <= deadline, "Gain::permit: signature expired");
382 
383         allowances[owner][spender] = amount;
384 
385         emit Approval(owner, spender, amount);
386     }
387 
388     /**
389      * @notice Get the number of tokens held by the `account`
390      * @param account The address of the account to get the balance of
391      * @return The number of tokens held
392      */
393     function balanceOf(address account) external view returns (uint) {
394         return balances[account];
395     }
396 
397     /**
398      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
399      * @param dst The address of the destination account
400      * @param rawAmount The number of tokens to transfer
401      * @return Whether or not the transfer succeeded
402      */
403     function transfer(address dst, uint rawAmount) external returns (bool) {
404         uint96 amount = safe96(rawAmount, "Gain::transfer: amount exceeds 96 bits");
405         _transferTokens(msg.sender, dst, amount);
406         return true;
407     }
408 
409     /**
410      * @notice Transfer `amount` tokens from `src` to `dst`
411      * @param src The address of the source account
412      * @param dst The address of the destination account
413      * @param rawAmount The number of tokens to transfer
414      * @return Whether or not the transfer succeeded
415      */
416     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
417         address spender = msg.sender;
418         uint96 spenderAllowance = allowances[src][spender];
419         uint96 amount = safe96(rawAmount, "Gain::approve: amount exceeds 96 bits");
420 
421         if (spender != src && spenderAllowance != uint96(-1)) {
422             uint96 newAllowance = sub96(spenderAllowance, amount, "Gain::transferFrom: transfer amount exceeds spender allowance");
423             allowances[src][spender] = newAllowance;
424 
425             emit Approval(src, spender, newAllowance);
426         }
427 
428         _transferTokens(src, dst, amount);
429         return true;
430     }
431 
432     /**
433      * @notice Delegate votes from `msg.sender` to `delegatee`
434      * @param delegatee The address to delegate votes to
435      */
436     function delegate(address delegatee) public {
437         return _delegate(msg.sender, delegatee);
438     }
439 
440     /**
441      * @notice Delegates votes from signatory to `delegatee`
442      * @param delegatee The address to delegate votes to
443      * @param nonce The contract state required to match the signature
444      * @param expiry The time at which to expire the signature
445      * @param v The recovery byte of the signature
446      * @param r Half of the ECDSA signature pair
447      * @param s Half of the ECDSA signature pair
448      */
449     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
450         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
451         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
452         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
453         address signatory = ecrecover(digest, v, r, s);
454         require(signatory != address(0), "Gain::delegateBySig: invalid signature");
455         require(nonce == nonces[signatory]++, "Gain::delegateBySig: invalid nonce");
456         require(now <= expiry, "Gain::delegateBySig: signature expired");
457         return _delegate(signatory, delegatee);
458     }
459 
460     /**
461      * @notice Gets the current votes balance for `account`
462      * @param account The address to get votes balance
463      * @return The number of current votes for `account`
464      */
465     function getCurrentVotes(address account) external view returns (uint96) {
466         uint32 nCheckpoints = numCheckpoints[account];
467         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
468     }
469 
470     /**
471      * @notice Determine the prior number of votes for an account as of a block number
472      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
473      * @param account The address of the account to check
474      * @param blockNumber The block number to get the vote balance at
475      * @return The number of votes the account had as of the given block
476      */
477     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
478         require(blockNumber < block.number, "Gain::getPriorVotes: not yet determined");
479 
480         uint32 nCheckpoints = numCheckpoints[account];
481         if (nCheckpoints == 0) {
482             return 0;
483         }
484 
485         // First check most recent balance
486         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
487             return checkpoints[account][nCheckpoints - 1].votes;
488         }
489 
490         // Next check implicit zero balance
491         if (checkpoints[account][0].fromBlock > blockNumber) {
492             return 0;
493         }
494 
495         uint32 lower = 0;
496         uint32 upper = nCheckpoints - 1;
497         while (upper > lower) {
498             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
499             Checkpoint memory cp = checkpoints[account][center];
500             if (cp.fromBlock == blockNumber) {
501                 return cp.votes;
502             } else if (cp.fromBlock < blockNumber) {
503                 lower = center;
504             } else {
505                 upper = center - 1;
506             }
507         }
508         return checkpoints[account][lower].votes;
509     }
510 
511     function _delegate(address delegator, address delegatee) internal {
512         address currentDelegate = delegates[delegator];
513         uint96 delegatorBalance = balances[delegator];
514         delegates[delegator] = delegatee;
515 
516         emit DelegateChanged(delegator, currentDelegate, delegatee);
517 
518         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
519     }
520 
521     function _transferTokens(address src, address dst, uint96 amount) internal {
522         require(src != address(0), "Gain::_transferTokens: cannot transfer from the zero address");
523         require(dst != address(0), "Gain::_transferTokens: cannot transfer to the zero address");
524 
525         balances[src] = sub96(balances[src], amount, "Gain::_transferTokens: transfer amount exceeds balance");
526         balances[dst] = add96(balances[dst], amount, "Gain::_transferTokens: transfer amount overflows");
527         emit Transfer(src, dst, amount);
528 
529         _moveDelegates(delegates[src], delegates[dst], amount);
530     }
531 
532     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
533         if (srcRep != dstRep && amount > 0) {
534             if (srcRep != address(0)) {
535                 uint32 srcRepNum = numCheckpoints[srcRep];
536                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
537                 uint96 srcRepNew = sub96(srcRepOld, amount, "Gain::_moveVotes: vote amount underflows");
538                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
539             }
540 
541             if (dstRep != address(0)) {
542                 uint32 dstRepNum = numCheckpoints[dstRep];
543                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
544                 uint96 dstRepNew = add96(dstRepOld, amount, "Gain::_moveVotes: vote amount overflows");
545                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
546             }
547         }
548     }
549 
550     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
551       uint32 blockNumber = safe32(block.number, "Gain::_writeCheckpoint: block number exceeds 32 bits");
552 
553       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
554           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
555       } else {
556           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
557           numCheckpoints[delegatee] = nCheckpoints + 1;
558       }
559 
560       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
561     }
562 
563     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
564         require(n < 2**32, errorMessage);
565         return uint32(n);
566     }
567 
568     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
569         require(n < 2**96, errorMessage);
570         return uint96(n);
571     }
572 
573     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
574         uint96 c = a + b;
575         require(c >= a, errorMessage);
576         return c;
577     }
578 
579     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
580         require(b <= a, errorMessage);
581         return a - b;
582     }
583 
584     function getChainId() internal pure returns (uint) {
585         uint256 chainId;
586         assembly { chainId := chainid() }
587         return chainId;
588     }
589 }