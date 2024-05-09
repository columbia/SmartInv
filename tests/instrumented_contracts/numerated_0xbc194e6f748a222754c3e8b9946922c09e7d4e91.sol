1 pragma solidity ^0.5.16;
2 
3 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
4 // Subject to the MIT license.
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      * - Addition cannot overflow.
41      */
42     function add(
43         uint256 a,
44         uint256 b,
45         string memory errorMessage
46     ) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, errorMessage);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      * - Subtraction cannot underflow.
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction underflow");
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot underflow.
72      */
73     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b <= a, errorMessage);
75         uint256 c = a - b;
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
91         if (a == 0) { return 0;}
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94         return c;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      * - Multiplication cannot overflow.
104      */
105     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107         // benefit is lost if 'b' is also tested.
108         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109         if (a == 0) {return 0;}
110         uint256 c = a * b;
111         require(c / a == b, errorMessage);
112         return c;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers.
117      * Reverts on division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers.
132      * Reverts with custom message on division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      * - The divisor cannot be zero.
140      */
141     function div(
142         uint256 a,
143         uint256 b,
144         string memory errorMessage
145     ) internal pure returns (uint256) {
146         // Solidity only automatically asserts when dividing by 0
147         require(b > 0, errorMessage);
148         uint256 c = a / b;
149         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function mod(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 contract Lev {
191     /// @notice EIP-20 token name for this token
192     string public constant name = "Lever Token";
193     /// @notice EIP-20 token symbol for this token
194     string public constant symbol = "LEV";
195     /// @notice EIP-20 token decimals for this token
196     uint8 public constant decimals = 18;
197     /// @notice Total number of tokens in circulation
198     uint256 public totalSupply = 100_000_000e18;
199     /// @notice Allowance amounts on behalf of others
200     mapping(address => mapping(address => uint96)) internal allowances;
201     /// @notice Official record of token balances for each account
202     mapping(address => uint96) internal balances;
203     /// @notice A record of each accounts delegate
204     mapping(address => address) public delegates;
205     /// @notice A checkpoint for marking number of votes from a given block
206     struct Checkpoint {
207         uint32 fromBlock;
208         uint96 votes;
209     }
210 
211     /// @notice A record of votes checkpoints for each account, by index
212     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
213     /// @notice The number of checkpoints for each account
214     mapping(address => uint32) public numCheckpoints;
215     /// @notice The EIP-712 typehash for the contract's domain
216     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
217     /// @notice The EIP-712 typehash for the delegation struct used by the contract
218     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
219     /// @notice The EIP-712 typehash for the permit struct used by the contract
220     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
221     /// @notice A record of states for signing / validating signatures
222     mapping(address => uint256) public nonces;
223     /// @notice An event thats emitted when an account changes its delegate
224     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
225     /// @notice An event thats emitted when a delegate account's vote balance changes
226     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
227     /// @notice The standard EIP-20 transfer event
228     event Transfer(address indexed from, address indexed to, uint256 amount);
229     /// @notice The standard EIP-20 approval event
230     event Approval(address indexed owner, address indexed spender, uint256 amount);
231     /**
232      * @notice Construct a new Lev token
233      * @param account The initial account to grant all the tokens
234      */
235     constructor(address account) public {
236         balances[account] = uint96(totalSupply);
237         emit Transfer(address(0), account, totalSupply);
238     }
239 
240     /**
241      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
242      * @param account The address of the account holding the funds
243      * @param spender The address of the account spending the funds
244      * @return The number of tokens approved
245      */
246     function allowance(address account, address spender) external view returns (uint256) {
247         return allowances[account][spender];
248     }
249 
250     /**
251      * @notice Approve `spender` to transfer up to `amount` from `src`
252      * @dev This will overwrite the approval amount for `spender`
253      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
254      * @param spender The address of the account which may transfer tokens
255      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
256      * @return Whether or not the approval succeeded
257      */
258     function approve(address spender, uint256 rawAmount) external returns (bool) {
259         uint96 amount;
260         if (rawAmount == uint256(-1)) {
261             amount = uint96(-1);
262         } else {
263             amount = safe96(rawAmount, "Lev::approve: amount exceeds 96 bits");
264         }
265         allowances[msg.sender][spender] = amount;
266         emit Approval(msg.sender, spender, amount);
267         return true;
268     }
269 
270     /**
271      * @notice Triggers an approval from owner to spends
272      * @param owner The address to approve from
273      * @param spender The address to be approved
274      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
275      * @param deadline The time at which to expire the signature
276      * @param v The recovery byte of the signature
277      * @param r Half of the ECDSA signature pair
278      * @param s Half of the ECDSA signature pair
279      */
280     function permit(address owner, address spender, uint256 rawAmount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
281         uint96 amount;
282         if (rawAmount == uint256(-1)) {
283             amount = uint96(-1);
284         } else {
285             amount = safe96(rawAmount, "Lev::permit: amount exceeds 96 bits");
286         }
287         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
288         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
289         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
290         address signatory = ecrecover(digest, v, r, s);
291         require(signatory != address(0), "Lev::permit: invalid signature");
292         require(signatory == owner, "Lev::permit: unauthorized");
293         require(now <= deadline, "Lev::permit: signature expired");
294         allowances[owner][spender] = amount;
295         emit Approval(owner, spender, amount);
296     }
297 
298     /**
299      * @notice Get the number of tokens held by the `account`
300      * @param account The address of the account to get the balance of
301      * @return The number of tokens held
302      */
303     function balanceOf(address account) external view returns (uint256) {
304         return balances[account];
305     }
306 
307     /**
308      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
309      * @param dst The address of the destination account
310      * @param rawAmount The number of tokens to transfer
311      * @return Whether or not the transfer succeeded
312      */
313     function transfer(address dst, uint256 rawAmount) external returns (bool) {
314         uint96 amount = safe96(rawAmount, "Lev::transfer: amount exceeds 96 bits");
315         _transferTokens(msg.sender, dst, amount);
316         return true;
317     }
318 
319     /**
320      * @notice Transfer `amount` tokens from `src` to `dst`
321      * @param src The address of the source account
322      * @param dst The address of the destination account
323      * @param rawAmount The number of tokens to transfer
324      * @return Whether or not the transfer succeeded
325      */
326     function transferFrom(address src, address dst, uint256 rawAmount) external returns (bool) {
327         address spender = msg.sender;
328         uint96 spenderAllowance = allowances[src][spender];
329         uint96 amount = safe96(rawAmount, "Lev::approve: amount exceeds 96 bits");
330         if (spender != src && spenderAllowance != uint96(-1)) {
331             uint96 newAllowance = sub96(spenderAllowance, amount, "Lev::transferFrom: transfer amount exceeds spender allowance");
332             allowances[src][spender] = newAllowance;
333             emit Approval(src, spender, newAllowance);
334         }
335         _transferTokens(src, dst, amount);
336         return true;
337     }
338 
339     /**
340      * @notice Delegate votes from `msg.sender` to `delegatee`
341      * @param delegatee The address to delegate votes to
342      */
343     function delegate(address delegatee) public {
344         return _delegate(msg.sender, delegatee);
345     }
346 
347     /**
348      * @notice Delegates votes from signatory to `delegatee`
349      * @param delegatee The address to delegate votes to
350      * @param nonce The contract state required to match the signature
351      * @param expiry The time at which to expire the signature
352      * @param v The recovery byte of the signature
353      * @param r Half of the ECDSA signature pair
354      * @param s Half of the ECDSA signature pair
355      */
356     function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) public {
357         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
358         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
359         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
360         address signatory = ecrecover(digest, v, r, s);
361         require(signatory != address(0), "Lev::delegateBySig: invalid signature");
362         require(nonce == nonces[signatory]++, "Lev::delegateBySig: invalid nonce");
363         require(now <= expiry, "Lev::delegateBySig: signature expired");
364         return _delegate(signatory, delegatee);
365     }
366 
367     /**
368      * @notice Gets the current votes balance for `account`
369      * @param account The address to get votes balance
370      * @return The number of current votes for `account`
371      */
372     function getCurrentVotes(address account) external view returns (uint96) {
373         uint32 nCheckpoints = numCheckpoints[account];
374         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
375     }
376 
377     /**
378      * @notice Determine the prior number of votes for an account as of a block number
379      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
380      * @param account The address of the account to check
381      * @param blockNumber The block number to get the vote balance at
382      * @return The number of votes the account had as of the given block
383      */
384     function getPriorVotes(address account, uint256 blockNumber) public view returns (uint96) {
385         require(blockNumber < block.number, "Lev::getPriorVotes: not yet determined");
386         uint32 nCheckpoints = numCheckpoints[account];
387         if (nCheckpoints == 0) {return 0;}
388         // First check most recent balance
389         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) { return checkpoints[account][nCheckpoints - 1].votes;}
390         // Next check implicit zero balance
391         if (checkpoints[account][0].fromBlock > blockNumber) { return 0;}
392         uint32 lower = 0;
393         uint32 upper = nCheckpoints - 1;
394         while (upper > lower) {
395             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
396             Checkpoint memory cp = checkpoints[account][center];
397             if (cp.fromBlock == blockNumber) {
398                 return cp.votes;
399             } else if (cp.fromBlock < blockNumber) {
400                 lower = center;
401             } else {
402                 upper = center - 1;
403             }
404         }
405         return checkpoints[account][lower].votes;
406     }
407 
408     function _delegate(address delegator, address delegatee) internal {
409         address currentDelegate = delegates[delegator];
410         uint96 delegatorBalance = balances[delegator];
411         delegates[delegator] = delegatee;
412         emit DelegateChanged(delegator, currentDelegate, delegatee);
413         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
414     }
415 
416     function _transferTokens(address src, address dst, uint96 amount) internal {
417         require(src != address(0), "Lev::_transferTokens: cannot transfer from the zero address");
418         require(dst != address(0), "Lev::_transferTokens: cannot transfer to the zero address");
419         balances[src] = sub96(balances[src], amount, "Lev::_transferTokens: transfer amount exceeds balance");
420         balances[dst] = add96(balances[dst], amount, "Lev::_transferTokens: transfer amount overflows");
421         emit Transfer(src, dst, amount);
422         _moveDelegates(delegates[src], delegates[dst], amount);
423     }
424 
425     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
426         if (srcRep != dstRep && amount > 0) {
427             if (srcRep != address(0)) {
428                 uint32 srcRepNum = numCheckpoints[srcRep];
429                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
430                 uint96 srcRepNew = sub96(srcRepOld, amount, "Lev::_moveVotes: vote amount underflows" );
431                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
432             }
433 
434             if (dstRep != address(0)) {
435                 uint32 dstRepNum = numCheckpoints[dstRep];
436                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
437                 uint96 dstRepNew = add96(dstRepOld, amount, "Lev::_moveVotes: vote amount overflows");
438                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
439             }
440         }
441     }
442 
443     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
444         uint32 blockNumber = safe32(block.number, "Lev::_writeCheckpoint: block number exceeds 32 bits");
445         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
446             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
447         } else {
448             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
449             numCheckpoints[delegatee] = nCheckpoints + 1;
450         }
451         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
452     }
453 
454     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
455         require(n < 2**32, errorMessage);
456         return uint32(n);
457     }
458 
459     function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
460         require(n < 2**96, errorMessage);
461         return uint96(n);
462     }
463 
464     function add96( uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
465         uint96 c = a + b;
466         require(c >= a, errorMessage);
467         return c;
468     }
469 
470     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
471         require(b <= a, errorMessage);
472         return a - b;
473     }
474 
475     function getChainId() internal pure returns (uint256) {
476         uint256 chainId;
477         assembly {
478             chainId := chainid()
479         }
480         return chainId;
481     }
482 }