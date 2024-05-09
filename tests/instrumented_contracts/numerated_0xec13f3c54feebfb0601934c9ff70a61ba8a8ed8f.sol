1 /*
2 
3 https://www.unicat.farm
4 
5           _       _________ _______  _______ _________
6 |\     /|( (    /|\__   __/(  ____ \(  ___  )\__   __/
7 | )   ( ||  \  ( |   ) (   | (    \/| (   ) |   ) (   
8 | |   | ||   \ | |   | |   | |      | (___) |   | |   
9 | |   | || (\ \) |   | |   | |      |  ___  |   | |   
10 | |   | || | \   |   | |   | |      | (   ) |   | |   
11 | (___) || )  \  |___) (___| (____/\| )   ( |   | |   
12 (_______)|/    )_)\_______/(_______/|/     \|   )_(  
13 
14 
15 Because we love UNI, we grow MEOW !
16 
17 Stake your UNI and your favourite UNI Liquidity Pools tokens
18 and earn MEOW.
19 
20 
21 UniCat (MEOW) holders will govern the UniCat Exchange
22 and will earn a percentage of the fees!
23 
24 Visit and follow!
25 
26 * Website: https://www.unicat.farm
27 
28 * Twitter: https://twitter.com/unicatFarm
29 
30 * Telegram: https://t.me/unicatFarm
31 
32 * Medium: https://medium.com/@unicat.farm"
33 
34 UNI Liquidity Pools tokens includes, among others:
35 UniswapV2 (UNI-ETH)
36 MooniswapV1 (ETH-UNI)
37 Sushiswap (ETH-UNI)
38 Balancer Pools 50/50
39 
40 
41 Conract forked from UNI token
42 */
43 
44 pragma solidity 0.7.1;
45 pragma experimental ABIEncoderV2;
46 
47 // SPDX-License-Identifier: MIT
48 
49 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
50 // Subject to the MIT license.
51 
52 /**
53  * @dev Wrappers over Solidity's arithmetic operations with added overflow
54  * checks.
55  *
56  * Arithmetic operations in Solidity wrap on overflow. This can easily result
57  * in bugs, because programmers usually assume that an overflow raises an
58  * error, which is the standard behavior in high level programming languages.
59  * `SafeMath` restores this intuition by reverting the transaction when an
60  * operation overflows.
61  *
62  * Using this library instead of the unchecked operations eliminates an entire
63  * class of bugs, so it's recommended to use it always.
64  */
65 library SafeMath {
66     /**
67      * @dev Returns the addition of two unsigned integers, reverting on overflow.
68      *
69      * Counterpart to Solidity's `+` operator.
70      *
71      * Requirements:
72      * - Addition cannot overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, errorMessage);
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      * - Subtraction cannot underflow.
103      */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction underflow");
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot underflow.
115      */
116     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b <= a, errorMessage);
118         uint256 c = a - b;
119 
120         return c;
121     }
122 
123 }
124 
125 contract UniCat {
126     /// @notice EIP-20 token name for this token
127     string public constant name = "UniCat.farm";
128 
129     /// @notice EIP-20 token symbol for this token
130     string public constant symbol = "MEOW";
131 
132     /// @notice EIP-20 token decimals for this token
133     uint8 public constant decimals = 18;
134 
135     /// @notice Total number of tokens in circulation
136     uint public totalSupply; 
137 
138     /// @notice Address which may mint new tokens
139     address public minter;
140 
141     //  Allowance amounts on behalf of others
142     mapping (address => mapping (address => uint96)) internal allowances;
143 
144     // Official record of token balances for each account
145     mapping (address => uint96) internal balances;
146 
147     /// @notice A record of each accounts delegate
148     mapping (address => address) public delegates;
149 
150     /// @notice A checkpoint for marking number of votes from a given block
151     struct Checkpoint {
152         uint32 fromBlock;
153         uint96 votes;
154     }
155 
156     /// @notice A record of votes checkpoints for each account, by index
157     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
158 
159     /// @notice The number of checkpoints for each account
160     mapping (address => uint32) public numCheckpoints;
161 
162     /// @notice The EIP-712 typehash for the contract's domain
163     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
164 
165     /// @notice The EIP-712 typehash for the delegation struct used by the contract
166     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
167 
168     /// @notice The EIP-712 typehash for the permit struct used by the contract
169     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
170 
171     /// @notice A record of states for signing / validating signatures
172     mapping (address => uint) public nonces;
173 
174     /// @notice An event thats emitted when the minter address is changed
175     event MinterChanged(address minter, address newMinter);
176 
177     /// @notice An event thats emitted when an account changes its delegate
178     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
179 
180     /// @notice An event thats emitted when a delegate account's vote balance changes
181     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
182 
183     /// @notice The standard EIP-20 transfer event
184     event Transfer(address indexed from, address indexed to, uint256 amount);
185 
186     /// @notice The standard EIP-20 approval event
187     event Approval(address indexed owner, address indexed spender, uint256 amount);
188 
189     /**
190      * @notice Construct a new UniCat token
191      * @param minter_ The account with minting ability
192      */
193     constructor(address minter_) {
194         require(minter_ != address(0), "Meow::constructor: minter cannot be address 0");
195         minter = minter_;
196         emit MinterChanged(address(0), minter);
197     }
198 
199     /**
200      * @notice Change the minter address
201      * @param minter_ The address of the new minter
202      */
203     function setMinter(address minter_) external {
204         require(msg.sender == minter, "Meow::setMinter: only the minter can change the minter address");
205         emit MinterChanged(minter, minter_);
206         minter = minter_;
207     }
208 
209     /**
210      * @notice Mint new tokens
211      * @param dst The address of the destination account
212      * @param rawAmount The number of tokens to be minted
213      */
214     function mint(address dst, uint rawAmount) external {
215         require(msg.sender == minter, "Meow::mint: only the minter can mint");
216         require(dst != address(0), "Meow::mint: cannot transfer to the zero address");
217 
218         // mint the amount
219         uint96 amount = safe96(rawAmount, "Meow::mint: amount exceeds 96 bits");
220         totalSupply = safe96(SafeMath.add(totalSupply, amount), "Meow::mint: totalSupply exceeds 96 bits");
221         
222         // transfer the amount to the recipient
223         balances[dst] = add96(balances[dst], amount, "Meow::mint: transfer amount overflows");
224         emit Transfer(address(0), dst, amount);
225 
226         // move delegates
227         _moveDelegates(address(0), delegates[dst], amount);
228     }
229 
230     /**
231      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
232      * @param account The address of the account holding the funds
233      * @param spender The address of the account spending the funds
234      * @return The number of tokens approved
235      */
236     function allowance(address account, address spender) external view returns (uint) {
237         return allowances[account][spender];
238     }
239 
240     /**
241      * @notice Approve `spender` to transfer up to `amount` from `src`
242      * @dev This will overwrite the approval amount for `spender`
243      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
244      * @param spender The address of the account which may transfer tokens
245      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
246      * @return Whether or not the approval succeeded
247      */
248     function approve(address spender, uint rawAmount) external returns (bool) {
249         uint96 amount;
250         if (rawAmount == uint(-1)) {
251             amount = uint96(-1);
252         } else {
253             amount = safe96(rawAmount, "Meow::approve: amount exceeds 96 bits");
254         }
255 
256         allowances[msg.sender][spender] = amount;
257 
258         emit Approval(msg.sender, spender, amount);
259         return true;
260     }
261 
262     /**
263      * @notice Triggers an approval from owner to spends
264      * @param owner The address to approve from
265      * @param spender The address to be approved
266      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
267      * @param deadline The time at which to expire the signature
268      * @param v The recovery byte of the signature
269      * @param r Half of the ECDSA signature pair
270      * @param s Half of the ECDSA signature pair
271      */
272     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
273         uint96 amount;
274         if (rawAmount == uint(-1)) {
275             amount = uint96(-1);
276         } else {
277             amount = safe96(rawAmount, "Meow::permit: amount exceeds 96 bits");
278         }
279 
280         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
281         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
282         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
283         address signatory = ecrecover(digest, v, r, s);
284         require(signatory != address(0), "Meow::permit: invalid signature");
285         require(signatory == owner, "Meow::permit: unauthorized");
286         require(block.timestamp <= deadline, "Meow::permit: signature expired");
287 
288         allowances[owner][spender] = amount;
289 
290         emit Approval(owner, spender, amount);
291     }
292 
293     /**
294      * @notice Get the number of tokens held by the `account`
295      * @param account The address of the account to get the balance of
296      * @return The number of tokens held
297      */
298     function balanceOf(address account) external view returns (uint) {
299         return balances[account];
300     }
301 
302     /**
303      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
304      * @param dst The address of the destination account
305      * @param rawAmount The number of tokens to transfer
306      * @return Whether or not the transfer succeeded
307      */
308     function transfer(address dst, uint rawAmount) external returns (bool) {
309         uint96 amount = safe96(rawAmount, "Meow::transfer: amount exceeds 96 bits");
310         _transferTokens(msg.sender, dst, amount);
311         return true;
312     }
313 
314     /**
315      * @notice Transfer `amount` tokens from `src` to `dst`
316      * @param src The address of the source account
317      * @param dst The address of the destination account
318      * @param rawAmount The number of tokens to transfer
319      * @return Whether or not the transfer succeeded
320      */
321     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
322         address spender = msg.sender;
323         uint96 spenderAllowance = allowances[src][spender];
324         uint96 amount = safe96(rawAmount, "Meow::approve: amount exceeds 96 bits");
325 
326         if (spender != src && spenderAllowance != uint96(-1)) {
327             uint96 newAllowance = sub96(spenderAllowance, amount, "Meow::transferFrom: transfer amount exceeds spender allowance");
328             allowances[src][spender] = newAllowance;
329 
330             emit Approval(src, spender, newAllowance);
331         }
332 
333         _transferTokens(src, dst, amount);
334         return true;
335     }
336 
337     /**
338      * @notice Delegate votes from `msg.sender` to `delegatee`
339      * @param delegatee The address to delegate votes to
340      */
341     function delegate(address delegatee) public {
342         return _delegate(msg.sender, delegatee);
343     }
344 
345     /**
346      * @notice Delegates votes from signatory to `delegatee`
347      * @param delegatee The address to delegate votes to
348      * @param nonce The contract state required to match the signature
349      * @param expiry The time at which to expire the signature
350      * @param v The recovery byte of the signature
351      * @param r Half of the ECDSA signature pair
352      * @param s Half of the ECDSA signature pair
353      */
354     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
355         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
356         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
357         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
358         address signatory = ecrecover(digest, v, r, s);
359         require(signatory != address(0), "Meow::delegateBySig: invalid signature");
360         require(nonce == nonces[signatory]++, "Meow::delegateBySig: invalid nonce");
361         require(block.timestamp <= expiry, "Meow::delegateBySig: signature expired");
362         return _delegate(signatory, delegatee);
363     }
364 
365     /**
366      * @notice Gets the current votes balance for `account`
367      * @param account The address to get votes balance
368      * @return The number of current votes for `account`
369      */
370     function getCurrentVotes(address account) external view returns (uint96) {
371         uint32 nCheckpoints = numCheckpoints[account];
372         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
373     }
374 
375     /**
376      * @notice Determine the prior number of votes for an account as of a block number
377      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
378      * @param account The address of the account to check
379      * @param blockNumber The block number to get the vote balance at
380      * @return The number of votes the account had as of the given block
381      */
382     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
383         require(blockNumber < block.number, "Meow::getPriorVotes: not yet determined");
384 
385         uint32 nCheckpoints = numCheckpoints[account];
386         if (nCheckpoints == 0) {
387             return 0;
388         }
389 
390         // First check most recent balance
391         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
392             return checkpoints[account][nCheckpoints - 1].votes;
393         }
394 
395         // Next check implicit zero balance
396         if (checkpoints[account][0].fromBlock > blockNumber) {
397             return 0;
398         }
399 
400         uint32 lower = 0;
401         uint32 upper = nCheckpoints - 1;
402         while (upper > lower) {
403             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
404             Checkpoint memory cp = checkpoints[account][center];
405             if (cp.fromBlock == blockNumber) {
406                 return cp.votes;
407             } else if (cp.fromBlock < blockNumber) {
408                 lower = center;
409             } else {
410                 upper = center - 1;
411             }
412         }
413         return checkpoints[account][lower].votes;
414     }
415 
416     function _delegate(address delegator, address delegatee) internal {
417         address currentDelegate = delegates[delegator];
418         uint96 delegatorBalance = balances[delegator];
419         delegates[delegator] = delegatee;
420 
421         emit DelegateChanged(delegator, currentDelegate, delegatee);
422 
423         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
424     }
425 
426     function _transferTokens(address src, address dst, uint96 amount) internal {
427         require(src != address(0), "Meow::_transferTokens: cannot transfer from the zero address");
428         require(dst != address(0), "Meow::_transferTokens: cannot transfer to the zero address");
429 
430         balances[src] = sub96(balances[src], amount, "Meow::_transferTokens: transfer amount exceeds balance");
431         balances[dst] = add96(balances[dst], amount, "Meow::_transferTokens: transfer amount overflows");
432         emit Transfer(src, dst, amount);
433 
434         _moveDelegates(delegates[src], delegates[dst], amount);
435     }
436 
437     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
438         if (srcRep != dstRep && amount > 0) {
439             if (srcRep != address(0)) {
440                 uint32 srcRepNum = numCheckpoints[srcRep];
441                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
442                 uint96 srcRepNew = sub96(srcRepOld, amount, "Meow::_moveVotes: vote amount underflows");
443                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
444             }
445 
446             if (dstRep != address(0)) {
447                 uint32 dstRepNum = numCheckpoints[dstRep];
448                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
449                 uint96 dstRepNew = add96(dstRepOld, amount, "Meow::_moveVotes: vote amount overflows");
450                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
451             }
452         }
453     }
454 
455     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
456       uint32 blockNumber = safe32(block.number, "Meow::_writeCheckpoint: block number exceeds 32 bits");
457 
458       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
459           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
460       } else {
461           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
462           numCheckpoints[delegatee] = nCheckpoints + 1;
463       }
464 
465       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
466     }
467 
468     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
469         require(n < 2**32, errorMessage);
470         return uint32(n);
471     }
472 
473     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
474         require(n < 2**96, errorMessage);
475         return uint96(n);
476     }
477 
478     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
479         uint96 c = a + b;
480         require(c >= a, errorMessage);
481         return c;
482     }
483 
484     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
485         require(b <= a, errorMessage);
486         return a - b;
487     }
488 
489     function getChainId() internal pure returns (uint) {
490         uint256 chainId;
491         assembly { chainId := chainid() }
492         return chainId;
493     }
494 }