1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/governance/dmg/SafeBitMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 library SafeBitMath {
85 
86     function safe64(uint n, string memory errorMessage) internal pure returns (uint64) {
87         require(n < 2 ** 64, errorMessage);
88         return uint64(n);
89     }
90 
91     function safe128(uint n, string memory errorMessage) internal pure returns (uint128) {
92         require(n < 2 ** 128, errorMessage);
93         return uint128(n);
94     }
95 
96     function add128(uint128 a, uint128 b, string memory errorMessage) internal pure returns (uint128) {
97         uint128 c = a + b;
98         require(c >= a, errorMessage);
99         return c;
100     }
101 
102     function sub128(uint128 a, uint128 b, string memory errorMessage) internal pure returns (uint128) {
103         require(b <= a, errorMessage);
104         return a - b;
105     }
106 
107 }
108 
109 // File: contracts/utils/EvmUtil.sol
110 
111 pragma solidity ^0.5.13;
112 
113 library EvmUtil {
114 
115     function getChainId() internal pure returns (uint) {
116         uint256 chainId;
117         assembly { chainId := chainid() }
118         return chainId;
119     }
120 
121 }
122 
123 // File: contracts/governance/dmg/DMGToken.sol
124 
125 pragma solidity ^0.5.13;
126 pragma experimental ABIEncoderV2;
127 
128 
129 
130 
131 /**
132  * This contract is mainly based on Compound's COMP token
133  * (https://etherscan.io/address/0xc00e94cb662c3520282e6f5717214004a7f26888). Unfortunately, no license was found on
134  * Etherscan for the token and the code for the token cannot be found on their GitHub, so the proper attribution to the
135  * Compound team cannot be made.
136  *
137  * Changes made to the token contract include modifying internal storage of balances/allowances to use 128 bits instead
138  * of 96, increasing the number of bits for a checkpoint to 64, adding a burn function, and creating an initial
139  * totalSupply of 250mm.
140  */
141 contract DMGToken is IERC20 {
142 
143     string public constant name = "DMM: Governance";
144 
145     string public constant symbol = "DMG";
146 
147     uint8 public constant decimals = 18;
148 
149     uint public totalSupply;
150 
151     /// @notice Allowance amounts on behalf of others
152     mapping(address => mapping(address => uint128)) internal allowances;
153 
154     /// @notice Official record of token balances for each account
155     mapping(address => uint128) internal balances;
156 
157     /// @notice A record of each account's delegate
158     mapping(address => address) public delegates;
159 
160     /// @notice A checkpoint for marking number of votes from a given block
161     struct Checkpoint {
162         uint64 fromBlock;
163         uint128 votes;
164     }
165 
166     /// @notice A record of votes checkpoints for each account, by index
167     mapping(address => mapping(uint64 => Checkpoint)) public checkpoints;
168 
169     /// @notice The number of checkpoints for each account
170     mapping(address => uint64) public numCheckpoints;
171 
172     bytes32 public domainSeparator;
173 
174     /// @notice The EIP-712 typehash for the contract's domain
175     bytes32 public constant DOMAIN_TYPE_HASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
176 
177     /// @notice The EIP-712 typehash for the delegation struct used by the contract
178     bytes32 public constant DELEGATION_TYPE_HASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
179 
180     /// @notice The EIP-712 typehash for the transfer struct used by the contract
181     bytes32 public constant TRANSFER_TYPE_HASH = keccak256("Transfer(address recipient,uint256 rawAmount,uint256 nonce,uint256 expiry)");
182 
183     /// @notice The EIP-712 typehash for the approve struct used by the contract
184     bytes32 public constant APPROVE_TYPE_HASH = keccak256("Approve(address spender,uint256 rawAmount,uint256 nonce,uint256 expiry)");
185 
186     /// @notice A record of states for signing / validating signatures
187     mapping(address => uint) public nonces;
188 
189     /// @notice An event thats emitted when an account changes its delegate
190     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
191 
192     /// @notice An event thats emitted when a delegate account's vote balance changes
193     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
194 
195     /**
196      * @notice Construct the DMG token
197      * @param account The initial account to receive all of the tokens
198      */
199     constructor(address account) public {
200         // 250mm
201         totalSupply = 250000000e18;
202         require(totalSupply == uint128(totalSupply), "DMG: total supply exceeds 128 bits");
203 
204         domainSeparator = keccak256(
205             abi.encode(DOMAIN_TYPE_HASH, keccak256(bytes(name)), EvmUtil.getChainId(), address(this))
206         );
207 
208         balances[account] = uint128(totalSupply);
209         emit Transfer(address(0), account, totalSupply);
210     }
211 
212     /**
213      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
214      * @param account The address of the account holding the funds
215      * @param spender The address of the account spending the funds
216      * @return The number of tokens approved
217      */
218     function allowance(address account, address spender) external view returns (uint) {
219         return allowances[account][spender];
220     }
221 
222     /**
223      * @notice Approve `spender` to transfer up to `amount` from `src`
224      * @dev This will overwrite the approval amount for `spender`
225      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
226      * @param spender The address of the account which may transfer tokens
227      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
228      * @return Whether or not the approval succeeded
229      */
230     function approve(address spender, uint rawAmount) external returns (bool) {
231         uint128 amount;
232         if (rawAmount == uint(- 1)) {
233             amount = uint128(- 1);
234         } else {
235             amount = SafeBitMath.safe128(rawAmount, "DMG::approve: amount exceeds 128 bits");
236         }
237 
238         _approveTokens(msg.sender, spender, amount);
239         return true;
240     }
241 
242     /**
243      * @notice Get the number of tokens held by the `account`
244      * @param account The address of the account to get the balance of
245      * @return The number of tokens held
246      */
247     function balanceOf(address account) external view returns (uint) {
248         return balances[account];
249     }
250 
251     /**
252      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
253      * @param dst The address of the destination account
254      * @param rawAmount The number of tokens to transfer
255      * @return Whether or not the transfer succeeded
256      */
257     function transfer(address dst, uint rawAmount) external returns (bool) {
258         uint128 amount = SafeBitMath.safe128(rawAmount, "DMG::transfer: amount exceeds 128 bits");
259         _transferTokens(msg.sender, dst, amount);
260         return true;
261     }
262 
263     /**
264      * @notice Transfers `amount` tokens from `msg.sender` to the zero address
265      * @param rawAmount The number of tokens to burn
266      * @return Whether or not the transfer succeeded
267     */
268     function burn(uint rawAmount) external returns (bool) {
269         uint128 amount = SafeBitMath.safe128(rawAmount, "DMG::burn: amount exceeds 128 bits");
270         _burnTokens(msg.sender, amount);
271         return true;
272     }
273 
274     /**
275      * @notice Transfer `amount` tokens from `src` to `dst`
276      * @param src The address of the source account
277      * @param dst The address of the destination account
278      * @param rawAmount The number of tokens to transfer
279      * @return Whether or not the transfer succeeded
280      */
281     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
282         address spender = msg.sender;
283         uint128 spenderAllowance = allowances[src][spender];
284         uint128 amount = SafeBitMath.safe128(rawAmount, "DMG::allowances: amount exceeds 128 bits");
285 
286         if (spender != src && spenderAllowance != uint128(- 1)) {
287             uint128 newAllowance = SafeBitMath.sub128(spenderAllowance, amount, "DMG::transferFrom: transfer amount exceeds spender allowance");
288             allowances[src][spender] = newAllowance;
289 
290             emit Approval(src, spender, newAllowance);
291         }
292 
293         _transferTokens(src, dst, amount);
294         return true;
295     }
296 
297     /**
298      * @notice Delegate votes from `msg.sender` to `delegatee`
299      * @param delegatee The address to delegate votes to
300      */
301     function delegate(address delegatee) public {
302         return _delegate(msg.sender, delegatee);
303     }
304 
305     function nonceOf(address signer) public view returns (uint) {
306         return nonces[signer];
307     }
308 
309     /**
310      * @notice Delegates votes from signatory to `delegatee`
311      * @param delegatee The address to delegate votes to
312      * @param nonce The contract state required to match the signature
313      * @param expiry The time at which to expire the signature
314      * @param v The recovery byte of the signature
315      * @param r Half of the ECDSA signature pair
316      * @param s Half of the ECDSA signature pair
317      */
318     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
319         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPE_HASH, delegatee, nonce, expiry));
320         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
321         address signatory = ecrecover(digest, v, r, s);
322         require(signatory != address(0), "DMG::delegateBySig: invalid signature");
323         require(nonce == nonces[signatory]++, "DMG::delegateBySig: invalid nonce");
324         require(now <= expiry, "DMG::delegateBySig: signature expired");
325         return _delegate(signatory, delegatee);
326     }
327 
328     /**
329      * @notice Transfers tokens from signatory to `recipient`
330      * @param recipient The address to receive the tokens
331      * @param rawAmount The amount of tokens to be sent to recipient
332      * @param nonce The contract state required to match the signature
333      * @param expiry The time at which to expire the signature
334      * @param v The recovery byte of the signature
335      * @param r Half of the ECDSA signature pair
336      * @param s Half of the ECDSA signature pair
337      */
338     function transferBySig(address recipient, uint rawAmount, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
339         bytes32 structHash = keccak256(abi.encode(TRANSFER_TYPE_HASH, recipient, rawAmount, nonce, expiry));
340         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
341         address signatory = ecrecover(digest, v, r, s);
342         require(signatory != address(0), "DMG::transferBySig: invalid signature");
343         require(nonce == nonces[signatory]++, "DMG::transferBySig: invalid nonce");
344         require(now <= expiry, "DMG::transferBySig: signature expired");
345 
346         uint128 amount = SafeBitMath.safe128(rawAmount, "DMG::transferBySig: amount exceeds 128 bits");
347         return _transferTokens(signatory, recipient, amount);
348     }
349 
350     /**
351      * @notice Approves tokens from signatory to be spent by `spender`
352      * @param spender The address to receive the tokens
353      * @param rawAmount The amount of tokens to be sent to spender
354      * @param nonce The contract state required to match the signature
355      * @param expiry The time at which to expire the signature
356      * @param v The recovery byte of the signature
357      * @param r Half of the ECDSA signature pair
358      * @param s Half of the ECDSA signature pair
359      */
360     function approveBySig(address spender, uint rawAmount, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
361         bytes32 structHash = keccak256(abi.encode(APPROVE_TYPE_HASH, spender, rawAmount, nonce, expiry));
362         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
363         address signatory = ecrecover(digest, v, r, s);
364         require(signatory != address(0), "DMG::approveBySig: invalid signature");
365         require(nonce == nonces[signatory]++, "DMG::approveBySig: invalid nonce");
366         require(now <= expiry, "DMG::approveBySig: signature expired");
367 
368         uint128 amount;
369         if (rawAmount == uint(- 1)) {
370             amount = uint128(- 1);
371         } else {
372             amount = SafeBitMath.safe128(rawAmount, "DMG::approveBySig: amount exceeds 128 bits");
373         }
374         _approveTokens(signatory, spender, amount);
375     }
376 
377     /**
378      * @notice Gets the current votes balance for `account`
379      * @param account The address to get votes balance
380      * @return The number of current votes for `account`
381      */
382     function getCurrentVotes(address account) external view returns (uint128) {
383         uint64 nCheckpoints = numCheckpoints[account];
384         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
385     }
386 
387     /**
388      * @notice Determine the prior number of votes for an account as of a block number
389      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
390      * @param account The address of the account to check
391      * @param blockNumber The block number to get the vote balance at
392      * @return The number of votes the account had as of the given block
393      */
394     function getPriorVotes(address account, uint blockNumber) public view returns (uint128) {
395         require(blockNumber < block.number, "DMG::getPriorVotes: not yet determined");
396 
397         uint64 nCheckpoints = numCheckpoints[account];
398         if (nCheckpoints == 0) {
399             return 0;
400         }
401 
402         // First check most recent balance
403         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
404             return checkpoints[account][nCheckpoints - 1].votes;
405         }
406 
407         // Next check implicit zero balance
408         if (checkpoints[account][0].fromBlock > blockNumber) {
409             return 0;
410         }
411 
412         uint64 lower = 0;
413         uint64 upper = nCheckpoints - 1;
414         while (upper > lower) {
415             uint64 center = upper - (upper - lower) / 2;
416             // ceil, avoiding overflow
417             Checkpoint memory cp = checkpoints[account][center];
418             if (cp.fromBlock == blockNumber) {
419                 return cp.votes;
420             } else if (cp.fromBlock < blockNumber) {
421                 lower = center;
422             } else {
423                 upper = center - 1;
424             }
425         }
426         return checkpoints[account][lower].votes;
427     }
428 
429     function _delegate(address delegator, address delegatee) internal {
430         address currentDelegate = delegates[delegator];
431         uint128 delegatorBalance = balances[delegator];
432         delegates[delegator] = delegatee;
433 
434         emit DelegateChanged(delegator, currentDelegate, delegatee);
435 
436         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
437     }
438 
439     function _transferTokens(address src, address dst, uint128 amount) internal {
440         require(src != address(0), "DMG::_transferTokens: cannot transfer from the zero address");
441         require(dst != address(0), "DMG::_transferTokens: cannot transfer to the zero address");
442 
443         balances[src] = SafeBitMath.sub128(balances[src], amount, "DMG::_transferTokens: transfer amount exceeds balance");
444         balances[dst] = SafeBitMath.add128(balances[dst], amount, "DMG::_transferTokens: transfer amount overflows");
445         emit Transfer(src, dst, amount);
446 
447         _moveDelegates(delegates[src], delegates[dst], amount);
448     }
449 
450     function _approveTokens(address owner, address spender, uint128 amount) internal {
451         allowances[owner][spender] = amount;
452 
453         emit Approval(owner, spender, amount);
454     }
455 
456     function _burnTokens(address src, uint128 amount) internal {
457         require(src != address(0), "DMG::_burnTokens: cannot burn from the zero address");
458 
459         balances[src] = SafeBitMath.sub128(balances[src], amount, "DMG::_burnTokens: burn amount exceeds balance");
460         emit Transfer(src, address(0), amount);
461 
462         totalSupply = SafeBitMath.sub128(uint128(totalSupply), amount, "DMG::_burnTokens: burn amount exceeds total supply");
463 
464         _moveDelegates(delegates[src], address(0), amount);
465     }
466 
467     function _moveDelegates(address srcRep, address dstRep, uint128 amount) internal {
468         if (srcRep != dstRep && amount > 0) {
469             if (srcRep != address(0)) {
470                 uint64 srcRepNum = numCheckpoints[srcRep];
471                 uint128 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
472                 uint128 srcRepNew = SafeBitMath.sub128(srcRepOld, amount, "DMG::_moveVotes: vote amount underflows");
473                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
474             }
475 
476             if (dstRep != address(0)) {
477                 uint64 dstRepNum = numCheckpoints[dstRep];
478                 uint128 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
479                 uint128 dstRepNew = SafeBitMath.add128(dstRepOld, amount, "DMG::_moveVotes: vote amount overflows");
480                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
481             }
482         }
483     }
484 
485     function _writeCheckpoint(address delegatee, uint64 nCheckpoints, uint128 oldVotes, uint128 newVotes) internal {
486         uint64 blockNumber = SafeBitMath.safe64(block.number, "DMG::_writeCheckpoint: block number exceeds 64 bits");
487 
488         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
489             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
490         } else {
491             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
492             numCheckpoints[delegatee] = nCheckpoints + 1;
493         }
494 
495         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
496     }
497 
498 }