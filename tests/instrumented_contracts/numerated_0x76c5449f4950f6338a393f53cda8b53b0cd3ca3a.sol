1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-02
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
193 contract BT {
194     /// @notice EIP-20 token name for this token
195     string public constant name = "BT.Finance";
196 
197     /// @notice EIP-20 token symbol for this token
198     string public constant symbol = "BT";
199 
200     /// @notice EIP-20 token decimals for this token
201     uint8 public constant decimals = 18;
202 
203     /// @notice Total number of tokens in circulation
204     uint public totalSupply = 0;
205 
206     /// @notice Address which may mint new tokens
207     address public minter;
208 
209     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
210     uint256 public constant maxTotalSupply = 270027e18;
211 
212     /// @notice Allowance amounts on behalf of others
213     mapping (address => mapping (address => uint96)) internal allowances;
214 
215     /// @notice Official record of token balances for each account
216     mapping (address => uint96) internal balances;
217 
218     /// @notice A record of each accounts delegate
219     mapping (address => address) public delegates;
220 
221     /// @notice A checkpoint for marking number of votes from a given block
222     struct Checkpoint {
223         uint32 fromBlock;
224         uint96 votes;
225     }
226 
227     /// @notice A record of votes checkpoints for each account, by index
228     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
229 
230     /// @notice The number of checkpoints for each account
231     mapping (address => uint32) public numCheckpoints;
232 
233     /// @notice The EIP-712 typehash for the contract's domain
234     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
235 
236     /// @notice The EIP-712 typehash for the delegation struct used by the contract
237     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
238 
239     /// @notice The EIP-712 typehash for the permit struct used by the contract
240     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
241 
242     /// @notice A record of states for signing / validating signatures
243     mapping (address => uint) public nonces;
244 
245     /// @notice An event thats emitted when the minter address is changed
246     event MinterChanged(address minter, address newMinter);
247 
248     /// @notice An event thats emitted when an account changes its delegate
249     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
250 
251     /// @notice An event thats emitted when a delegate account's vote balance changes
252     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
253 
254     /// @notice The standard EIP-20 transfer event
255     event Transfer(address indexed from, address indexed to, uint256 amount);
256 
257     /// @notice The standard EIP-20 approval event
258     event Approval(address indexed owner, address indexed spender, uint256 amount);
259 
260     /**
261      * @notice Construct a new BT token
262      * @param minter_ The account with minting ability
263      */
264     constructor(address minter_) public {
265         minter = minter_;
266         emit MinterChanged(address(0), minter);
267     }
268 
269     /**
270      * @notice Change the minter address
271      * @param minter_ The address of the new minter
272      */
273     function setMinter(address minter_) external {
274         require(msg.sender == minter, "BT::setMinter: only the minter can change the minter address");
275         emit MinterChanged(minter, minter_);
276         minter = minter_;
277     }
278 
279     /**
280      * @notice Mint new tokens
281      * @param dst The address of the destination account
282      * @param rawAmount The number of tokens to be minted
283      */
284     function mint(address dst, uint rawAmount) external {
285         require(msg.sender == minter, "BT::mint: only the minter can mint");
286         require(dst != address(0), "BT::mint: cannot transfer to the zero address");
287 
288         // mint the amount
289         uint96 amount = safe96(rawAmount, "BT::mint: amount exceeds 96 bits");
290         require(maxTotalSupply >= SafeMath.add(totalSupply, amount), "BT::mint: exceeded max totalSupply");
291         totalSupply = safe96(SafeMath.add(totalSupply, amount), "BT::mint: totalSupply exceeds 96 bits");
292 
293         // transfer the amount to the recipient
294         balances[dst] = add96(balances[dst], amount, "BT::mint: transfer amount overflows");
295         emit Transfer(address(0), dst, amount);
296 
297         // move delegates
298         _moveDelegates(address(0), delegates[dst], amount);
299     }
300 
301     /**
302      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
303      * @param account The address of the account holding the funds
304      * @param spender The address of the account spending the funds
305      * @return The number of tokens approved
306      */
307     function allowance(address account, address spender) external view returns (uint) {
308         return allowances[account][spender];
309     }
310 
311     /**
312      * @notice Approve `spender` to transfer up to `amount` from `src`
313      * @dev This will overwrite the approval amount for `spender`
314      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
315      * @param spender The address of the account which may transfer tokens
316      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
317      * @return Whether or not the approval succeeded
318      */
319     function approve(address spender, uint rawAmount) external returns (bool) {
320         uint96 amount;
321         if (rawAmount == uint(-1)) {
322             amount = uint96(-1);
323         } else {
324             amount = safe96(rawAmount, "BT::approve: amount exceeds 96 bits");
325         }
326 
327         allowances[msg.sender][spender] = amount;
328 
329         emit Approval(msg.sender, spender, amount);
330         return true;
331     }
332 
333     /**
334      * @notice Triggers an approval from owner to spends
335      * @param owner The address to approve from
336      * @param spender The address to be approved
337      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
338      * @param deadline The time at which to expire the signature
339      * @param v The recovery byte of the signature
340      * @param r Half of the ECDSA signature pair
341      * @param s Half of the ECDSA signature pair
342      */
343     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
344         uint96 amount;
345         if (rawAmount == uint(-1)) {
346             amount = uint96(-1);
347         } else {
348             amount = safe96(rawAmount, "BT::permit: amount exceeds 96 bits");
349         }
350 
351         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
352         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
353         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
354         address signatory = ecrecover(digest, v, r, s);
355         require(signatory != address(0), "BT::permit: invalid signature");
356         require(signatory == owner, "BT::permit: unauthorized");
357         require(now <= deadline, "BT::permit: signature expired");
358 
359         allowances[owner][spender] = amount;
360 
361         emit Approval(owner, spender, amount);
362     }
363 
364     /**
365      * @notice Get the number of tokens held by the `account`
366      * @param account The address of the account to get the balance of
367      * @return The number of tokens held
368      */
369     function balanceOf(address account) external view returns (uint) {
370         return balances[account];
371     }
372 
373     /**
374      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
375      * @param dst The address of the destination account
376      * @param rawAmount The number of tokens to transfer
377      * @return Whether or not the transfer succeeded
378      */
379     function transfer(address dst, uint rawAmount) external returns (bool) {
380         uint96 amount = safe96(rawAmount, "BT::transfer: amount exceeds 96 bits");
381         _transferTokens(msg.sender, dst, amount);
382         return true;
383     }
384 
385     /**
386      * @notice Transfer `amount` tokens from `src` to `dst`
387      * @param src The address of the source account
388      * @param dst The address of the destination account
389      * @param rawAmount The number of tokens to transfer
390      * @return Whether or not the transfer succeeded
391      */
392     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
393         address spender = msg.sender;
394         uint96 spenderAllowance = allowances[src][spender];
395         uint96 amount = safe96(rawAmount, "BT::approve: amount exceeds 96 bits");
396 
397         if (spender != src && spenderAllowance != uint96(-1)) {
398             uint96 newAllowance = sub96(spenderAllowance, amount, "BT::transferFrom: transfer amount exceeds spender allowance");
399             allowances[src][spender] = newAllowance;
400 
401             emit Approval(src, spender, newAllowance);
402         }
403 
404         _transferTokens(src, dst, amount);
405         return true;
406     }
407 
408     /**
409      * @notice Delegate votes from `msg.sender` to `delegatee`
410      * @param delegatee The address to delegate votes to
411      */
412     function delegate(address delegatee) public {
413         return _delegate(msg.sender, delegatee);
414     }
415 
416     /**
417      * @notice Delegates votes from signatory to `delegatee`
418      * @param delegatee The address to delegate votes to
419      * @param nonce The contract state required to match the signature
420      * @param expiry The time at which to expire the signature
421      * @param v The recovery byte of the signature
422      * @param r Half of the ECDSA signature pair
423      * @param s Half of the ECDSA signature pair
424      */
425     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
426         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
427         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
428         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
429         address signatory = ecrecover(digest, v, r, s);
430         require(signatory != address(0), "BT::delegateBySig: invalid signature");
431         require(nonce == nonces[signatory]++, "BT::delegateBySig: invalid nonce");
432         require(now <= expiry, "BT::delegateBySig: signature expired");
433         return _delegate(signatory, delegatee);
434     }
435 
436     /**
437      * @notice Gets the current votes balance for `account`
438      * @param account The address to get votes balance
439      * @return The number of current votes for `account`
440      */
441     function getCurrentVotes(address account) external view returns (uint96) {
442         uint32 nCheckpoints = numCheckpoints[account];
443         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
444     }
445 
446     /**
447      * @notice Determine the prior number of votes for an account as of a block number
448      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
449      * @param account The address of the account to check
450      * @param blockNumber The block number to get the vote balance at
451      * @return The number of votes the account had as of the given block
452      */
453     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
454         require(blockNumber < block.number, "BT::getPriorVotes: not yet determined");
455 
456         uint32 nCheckpoints = numCheckpoints[account];
457         if (nCheckpoints == 0) {
458             return 0;
459         }
460 
461         // First check most recent balance
462         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
463             return checkpoints[account][nCheckpoints - 1].votes;
464         }
465 
466         // Next check implicit zero balance
467         if (checkpoints[account][0].fromBlock > blockNumber) {
468             return 0;
469         }
470 
471         uint32 lower = 0;
472         uint32 upper = nCheckpoints - 1;
473         while (upper > lower) {
474             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
475             Checkpoint memory cp = checkpoints[account][center];
476             if (cp.fromBlock == blockNumber) {
477                 return cp.votes;
478             } else if (cp.fromBlock < blockNumber) {
479                 lower = center;
480             } else {
481                 upper = center - 1;
482             }
483         }
484         return checkpoints[account][lower].votes;
485     }
486 
487     function _delegate(address delegator, address delegatee) internal {
488         address currentDelegate = delegates[delegator];
489         uint96 delegatorBalance = balances[delegator];
490         delegates[delegator] = delegatee;
491 
492         emit DelegateChanged(delegator, currentDelegate, delegatee);
493 
494         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
495     }
496 
497     function _transferTokens(address src, address dst, uint96 amount) internal {
498         require(src != address(0), "BT::_transferTokens: cannot transfer from the zero address");
499         require(dst != address(0), "BT::_transferTokens: cannot transfer to the zero address");
500 
501         balances[src] = sub96(balances[src], amount, "BT::_transferTokens: transfer amount exceeds balance");
502         balances[dst] = add96(balances[dst], amount, "BT::_transferTokens: transfer amount overflows");
503         emit Transfer(src, dst, amount);
504 
505         _moveDelegates(delegates[src], delegates[dst], amount);
506     }
507 
508     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
509         if (srcRep != dstRep && amount > 0) {
510             if (srcRep != address(0)) {
511                 uint32 srcRepNum = numCheckpoints[srcRep];
512                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
513                 uint96 srcRepNew = sub96(srcRepOld, amount, "BT::_moveVotes: vote amount underflows");
514                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
515             }
516 
517             if (dstRep != address(0)) {
518                 uint32 dstRepNum = numCheckpoints[dstRep];
519                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
520                 uint96 dstRepNew = add96(dstRepOld, amount, "BT::_moveVotes: vote amount overflows");
521                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
522             }
523         }
524     }
525 
526     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
527         uint32 blockNumber = safe32(block.number, "BT::_writeCheckpoint: block number exceeds 32 bits");
528 
529         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
530             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
531         } else {
532             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
533             numCheckpoints[delegatee] = nCheckpoints + 1;
534         }
535 
536         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
537     }
538 
539     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
540         require(n < 2**32, errorMessage);
541         return uint32(n);
542     }
543 
544     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
545         require(n < 2**96, errorMessage);
546         return uint96(n);
547     }
548 
549     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
550         uint96 c = a + b;
551         require(c >= a, errorMessage);
552         return c;
553     }
554 
555     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
556         require(b <= a, errorMessage);
557         return a - b;
558     }
559 
560     function getChainId() internal pure returns (uint) {
561         uint256 chainId;
562         assembly { chainId := chainid() }
563         return chainId;
564     }
565 }