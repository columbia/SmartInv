1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-09-15
7 */
8 
9 pragma solidity ^0.7.5;
10 pragma experimental ABIEncoderV2;
11 
12 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
13 // Subject to the MIT license.
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations with added overflow
17  * checks.
18  *
19  * Arithmetic operations in Solidity wrap on overflow. This can easily result
20  * in bugs, because programmers usually assume that an overflow raises an
21  * error, which is the standard behavior in high level programming languages.
22  * `SafeMath` restores this intuition by reverting the transaction when an
23  * operation overflows.
24  *
25  * Using this library instead of the unchecked operations eliminates an entire
26  * class of bugs, so it's recommended to use it always.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, reverting on overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, errorMessage);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot underflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction underflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      * - Subtraction cannot underflow.
78      */
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
88      *
89      * Counterpart to Solidity's `*` operator.
90      *
91      * Requirements:
92      * - Multiplication cannot overflow.
93      */
94     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
96         // benefit is lost if 'b' is also tested.
97         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
98         if (a == 0) {
99             return 0;
100         }
101 
102         uint256 c = a * b;
103         require(c / a == b, "SafeMath: multiplication overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118         // benefit is lost if 'b' is also tested.
119         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120         if (a == 0) {
121             return 0;
122         }
123 
124         uint256 c = a * b;
125         require(c / a == b, errorMessage);
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers.
132      * Reverts on division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         return div(a, b, "SafeMath: division by zero");
143     }
144 
145     /**
146      * @dev Returns the integer division of two unsigned integers.
147      * Reverts with custom message on division by zero. The result is rounded towards zero.
148      *
149      * Counterpart to Solidity's `/` operator. Note: this function uses a
150      * `revert` opcode (which leaves remaining gas untouched) while Solidity
151      * uses an invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         // Solidity only automatically asserts when dividing by 0
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
177         return mod(a, b, "SafeMath: modulo by zero");
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * Reverts with custom message when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b != 0, errorMessage);
193         return a % b;
194     }
195 }
196 
197 contract vEth2 {
198     /// @notice EIP-20 token name for this token
199     string public constant name = "validator-Eth2";
200 
201     /// @notice EIP-20 token symbol for this token
202     string public constant symbol = "vETH2";
203 
204     /// @notice EIP-20 token decimals for this token
205     uint8 public constant decimals = 18;
206 
207     /// @notice Total number of tokens in circulation
208     uint public totalSupply;
209 
210     /// @notice Address which may mint new tokens
211     address public minter;
212 
213     /// @notice The timestamp after which minting may occur
214     uint public mintingAllowedAfter;
215 
216     /// @notice Minimum time between mints
217     // Flash mint protection
218     uint32 public constant minimumTimeBetweenMints = 1;
219 
220     //Allowance amounts on behalf of others
221     mapping (address => mapping (address => uint96)) internal allowances;
222 
223     // Official record of token balances for each account
224     mapping (address => uint96) internal balances;
225 
226     /// @notice A record of each accounts delegate
227     mapping (address => address) public delegates;
228 
229     /// @notice A checkpoint for marking number of votes from a given block
230     struct Checkpoint {
231         uint32 fromBlock;
232         uint96 votes;
233     }
234 
235     /// @notice A record of votes checkpoints for each account, by index
236     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
237 
238     /// @notice The number of checkpoints for each account
239     mapping (address => uint32) public numCheckpoints;
240 
241     /// @notice The EIP-712 typehash for the contract's domain
242     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
243 
244     /// @notice The EIP-712 typehash for the delegation struct used by the contract
245     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
246 
247     /// @notice The EIP-712 typehash for the permit struct used by the contract
248     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
249 
250     /// @notice A record of states for signing / validating signatures
251     mapping (address => uint) public nonces;
252 
253     /// @notice An event thats emitted when the minter address is changed
254     event MinterChanged(address minter, address newMinter);
255 
256     /// @notice An event thats emitted when an account changes its delegate
257     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
258 
259     /// @notice An event thats emitted when a delegate account's vote balance changes
260     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
261 
262     /// @notice The standard EIP-20 transfer event
263     event Transfer(address indexed from, address indexed to, uint256 amount);
264 
265     /// @notice The standard EIP-20 approval event
266     event Approval(address indexed owner, address indexed spender, uint256 amount);
267 
268     /**
269      * @notice Construct a new Uni token
270      * @param account The initial account to grant all the tokens
271      * @param minter_ The account with minting ability
272      * @param mintingAllowedAfter_ The timestamp after which minting may occur
273      */
274     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
275         require(mintingAllowedAfter_ >= block.timestamp, "vETH2::constructor: minting can only begin after deployment");
276 
277         balances[account] = uint96(totalSupply);
278         emit Transfer(address(0), account, totalSupply);
279         minter = minter_;
280         emit MinterChanged(address(0), minter);
281         mintingAllowedAfter = mintingAllowedAfter_;
282     }
283 
284     /**
285      * @notice Change the minter address
286      * @param minter_ The address of the new minter
287      */
288     function setMinter(address minter_) external {
289         require(msg.sender == minter, "vETH2::setMinter: only the minter can change the minter address");
290         emit MinterChanged(minter, minter_);
291         minter = minter_;
292     }
293 
294     /**
295      * @notice Mint new tokens
296      * @param dst The address of the destination account
297      * @param rawAmount The number of tokens to be minted
298      */
299     function mint(address dst, uint rawAmount) external {
300         require(msg.sender == minter, "vETH2::mint: only the minter can mint");
301         require(block.timestamp >= mintingAllowedAfter, "vETH2::mint: minting not allowed yet");
302         require(dst != address(0), "vETH2::mint: cannot transfer to the zero address");
303 
304         // record the mint
305         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
306 
307         // mint the amount
308         uint96 amount = safe96(rawAmount, "vETH2::mint: amount exceeds 96 bits");
309         totalSupply = safe96(SafeMath.add(totalSupply, amount), "vETH2::mint: totalSupply exceeds 96 bits");
310 
311         // transfer the amount to the recipient
312         balances[dst] = add96(balances[dst], amount, "vETH2::mint: transfer amount overflows");
313         emit Transfer(address(0), dst, amount);
314 
315         // move delegates
316         _moveDelegates(address(0), delegates[dst], amount);
317     }
318     
319     
320     function burn(address src, uint rawAmount) external {
321         require(msg.sender == minter, "vETH2::burn: only the minter can burn");
322         require(block.timestamp >= mintingAllowedAfter, "vETH2::burn: minting not allowed yet");
323         uint96 amount = safe96(rawAmount, "vETH2::burn: amount exceeds 96 bits");
324         require(amount <= totalSupply, "vETH2::burn: exceededed total supply");
325         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
326 
327         totalSupply = safe96(SafeMath.sub(totalSupply, amount), "vETH2::burn: totalSupply exceeds 96 bits");
328         
329         // transfer the amount to the recipient
330         balances[src] = sub96(balances[src], amount, "vETH2::burn: transfer amount overflows");
331         emit Transfer(src, address(0), amount);
332 
333         // move delegates
334         _moveDelegates(delegates[src], address(0), amount);
335     }
336 
337     /**
338      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
339      * @param account The address of the account holding the funds
340      * @param spender The address of the account spending the funds
341      * @return The number of tokens approved
342      */
343     function allowance(address account, address spender) external view returns (uint) {
344         return allowances[account][spender];
345     }
346 
347     /**
348      * @notice Approve `spender` to transfer up to `amount` from `src`
349      * @dev This will overwrite the approval amount for `spender`
350      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
351      * @param spender The address of the account which may transfer tokens
352      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
353      * @return Whether or not the approval succeeded
354      */
355     function approve(address spender, uint rawAmount) external returns (bool) {
356         uint96 amount;
357         if (rawAmount == uint(-1)) {
358             amount = uint96(-1);
359         } else {
360             amount = safe96(rawAmount, "vETH2::approve: amount exceeds 96 bits");
361         }
362 
363         allowances[msg.sender][spender] = amount;
364 
365         emit Approval(msg.sender, spender, amount);
366         return true;
367     }
368 
369     /**
370      * @notice Triggers an approval from owner to spends
371      * @param owner The address to approve from
372      * @param spender The address to be approved
373      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
374      * @param deadline The time at which to expire the signature
375      * @param v The recovery byte of the signature
376      * @param r Half of the ECDSA signature pair
377      * @param s Half of the ECDSA signature pair
378      */
379     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
380         uint96 amount;
381         if (rawAmount == uint(-1)) {
382             amount = uint96(-1);
383         } else {
384             amount = safe96(rawAmount, "vETH2::permit: amount exceeds 96 bits");
385         }
386 
387         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
388         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
389         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
390         address signatory = ecrecover(digest, v, r, s);
391         require(signatory != address(0), "vETH2::permit: invalid signature");
392         require(signatory == owner, "vETH2::permit: unauthorized");
393         require(block.timestamp <= deadline, "vETH2::permit: signature expired");
394 
395         allowances[owner][spender] = amount;
396 
397         emit Approval(owner, spender, amount);
398     }
399 
400     /**
401      * @notice Get the number of tokens held by the `account`
402      * @param account The address of the account to get the balance of
403      * @return The number of tokens held
404      */
405     function balanceOf(address account) external view returns (uint) {
406         return balances[account];
407     }
408 
409     /**
410      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
411      * @param dst The address of the destination account
412      * @param rawAmount The number of tokens to transfer
413      * @return Whether or not the transfer succeeded
414      */
415     function transfer(address dst, uint rawAmount) external returns (bool) {
416         uint96 amount = safe96(rawAmount, "vETH2::transfer: amount exceeds 96 bits");
417         _transferTokens(msg.sender, dst, amount);
418         return true;
419     }
420 
421     /**
422      * @notice Transfer `amount` tokens from `src` to `dst`
423      * @param src The address of the source account
424      * @param dst The address of the destination account
425      * @param rawAmount The number of tokens to transfer
426      * @return Whether or not the transfer succeeded
427      */
428     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
429         address spender = msg.sender;
430         uint96 spenderAllowance = allowances[src][spender];
431         uint96 amount = safe96(rawAmount, "vETH2::approve: amount exceeds 96 bits");
432 
433         if (spender != src && spenderAllowance != uint96(-1)) {
434             uint96 newAllowance = sub96(spenderAllowance, amount, "vETH2::transferFrom: transfer amount exceeds spender allowance");
435             allowances[src][spender] = newAllowance;
436 
437             emit Approval(src, spender, newAllowance);
438         }
439 
440         _transferTokens(src, dst, amount);
441         return true;
442     }
443 
444     /**
445      * @notice Delegate votes from `msg.sender` to `delegatee`
446      * @param delegatee The address to delegate votes to
447      */
448     function delegate(address delegatee) public {
449         return _delegate(msg.sender, delegatee);
450     }
451 
452     /**
453      * @notice Delegates votes from signatory to `delegatee`
454      * @param delegatee The address to delegate votes to
455      * @param nonce The contract state required to match the signature
456      * @param expiry The time at which to expire the signature
457      * @param v The recovery byte of the signature
458      * @param r Half of the ECDSA signature pair
459      * @param s Half of the ECDSA signature pair
460      */
461     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
462         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
463         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
464         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
465         address signatory = ecrecover(digest, v, r, s);
466         require(signatory != address(0), "vETH2::delegateBySig: invalid signature");
467         require(nonce == nonces[signatory]++, "vETH2::delegateBySig: invalid nonce");
468         require(block.timestamp <= expiry, "vETH2::delegateBySig: signature expired");
469         return _delegate(signatory, delegatee);
470     }
471 
472     /**
473      * @notice Gets the current votes balance for `account`
474      * @param account The address to get votes balance
475      * @return The number of current votes for `account`
476      */
477     function getCurrentVotes(address account) external view returns (uint96) {
478         uint32 nCheckpoints = numCheckpoints[account];
479         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
480     }
481 
482     /**
483      * @notice Determine the prior number of votes for an account as of a block number
484      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
485      * @param account The address of the account to check
486      * @param blockNumber The block number to get the vote balance at
487      * @return The number of votes the account had as of the given block
488      */
489     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
490         require(blockNumber < block.number, "vETH2::getPriorVotes: not yet determined");
491 
492         uint32 nCheckpoints = numCheckpoints[account];
493         if (nCheckpoints == 0) {
494             return 0;
495         }
496 
497         // First check most recent balance
498         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
499             return checkpoints[account][nCheckpoints - 1].votes;
500         }
501 
502         // Next check implicit zero balance
503         if (checkpoints[account][0].fromBlock > blockNumber) {
504             return 0;
505         }
506 
507         uint32 lower = 0;
508         uint32 upper = nCheckpoints - 1;
509         while (upper > lower) {
510             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
511             Checkpoint memory cp = checkpoints[account][center];
512             if (cp.fromBlock == blockNumber) {
513                 return cp.votes;
514             } else if (cp.fromBlock < blockNumber) {
515                 lower = center;
516             } else {
517                 upper = center - 1;
518             }
519         }
520         return checkpoints[account][lower].votes;
521     }
522 
523     function _delegate(address delegator, address delegatee) internal {
524         address currentDelegate = delegates[delegator];
525         uint96 delegatorBalance = balances[delegator];
526         delegates[delegator] = delegatee;
527 
528         emit DelegateChanged(delegator, currentDelegate, delegatee);
529 
530         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
531     }
532 
533     function _transferTokens(address src, address dst, uint96 amount) internal {
534         require(src != address(0), "vETH2::_transferTokens: cannot transfer from the zero address");
535         require(dst != address(0), "vETH2::_transferTokens: cannot transfer to the zero address");
536 
537         balances[src] = sub96(balances[src], amount, "vETH2::_transferTokens: transfer amount exceeds balance");
538         balances[dst] = add96(balances[dst], amount, "vETH2::_transferTokens: transfer amount overflows");
539         emit Transfer(src, dst, amount);
540 
541         _moveDelegates(delegates[src], delegates[dst], amount);
542     }
543 
544     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
545         if (srcRep != dstRep && amount > 0) {
546             if (srcRep != address(0)) {
547                 uint32 srcRepNum = numCheckpoints[srcRep];
548                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
549                 uint96 srcRepNew = sub96(srcRepOld, amount, "vETH2::_moveVotes: vote amount underflows");
550                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
551             }
552 
553             if (dstRep != address(0)) {
554                 uint32 dstRepNum = numCheckpoints[dstRep];
555                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
556                 uint96 dstRepNew = add96(dstRepOld, amount, "vETH2::_moveVotes: vote amount overflows");
557                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
558             }
559         }
560     }
561 
562     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
563       uint32 blockNumber = safe32(block.number, "vETH2::_writeCheckpoint: block number exceeds 32 bits");
564 
565       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
566           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
567       } else {
568           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
569           numCheckpoints[delegatee] = nCheckpoints + 1;
570       }
571 
572       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
573     }
574 
575     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
576         require(n < 2**32, errorMessage);
577         return uint32(n);
578     }
579 
580     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
581         require(n < 2**96, errorMessage);
582         return uint96(n);
583     }
584 
585     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
586         uint96 c = a + b;
587         require(c >= a, errorMessage);
588         return c;
589     }
590 
591     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
592         require(b <= a, errorMessage);
593         return a - b;
594     }
595 
596     function getChainId() internal pure returns (uint) {
597         uint256 chainId;
598         assembly { chainId := chainid() }
599         return chainId;
600     }
601 }
