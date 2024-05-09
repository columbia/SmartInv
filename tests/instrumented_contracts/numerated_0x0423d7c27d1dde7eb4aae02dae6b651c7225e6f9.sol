1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-09
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 
7 
8 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
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
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 
166 pragma solidity ^0.6.12;
167 
168 contract WSGov {
169     /// @dev EIP-20 token name for this token
170     string public constant name = "WhiteSwap";
171 
172     /// @dev EIP-20 token symbol for this token
173     string public constant symbol = "WSD";
174 
175     /// @dev EIP-20 token decimals for this token
176     uint8 public constant decimals = 18;
177 
178     /// @dev Total number of tokens in circulation
179     uint public totalSupply = 21_000_000e18; // 1 billion WSG
180 
181     /// @dev Address which may mint new tokens
182     address public minter;
183 
184     /// @dev Allowance amounts on behalf of others
185     mapping (address => mapping (address => uint96)) internal allowances;
186 
187     /// @dev Official record of token balances for each account
188     mapping (address => uint96) internal balances;
189 
190     /// @dev A record of each accounts delegate
191     mapping (address => address) public delegates;
192 
193     /// @dev A checkpoint for marking number of votes from a given block
194     struct Checkpoint {
195         uint32 fromBlock;
196         uint96 votes;
197     }
198 
199     /// @dev A record of votes checkpoints for each account, by index
200     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
201 
202     /// @dev The number of checkpoints for each account
203     mapping (address => uint32) public numCheckpoints;
204 
205     /// @dev The EIP-712 typehash for the contract's domain
206     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
207 
208     /// @dev The EIP-712 typehash for the delegation struct used by the contract
209     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
210 
211     /// @dev The EIP-712 typehash for the permit struct used by the contract
212     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
213 
214     /// @dev A record of states for signing / validating signatures
215     mapping (address => uint) public nonces;
216 
217     /// @dev An event thats emitted when the minter address is changed
218     event MinterChanged(address minter, address newMinter);
219 
220     /// @dev An event thats emitted when an account changes its delegate
221     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
222 
223     /// @dev An event thats emitted when a delegate account's vote balance changes
224     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
225 
226     /// @dev The standard EIP-20 transfer event
227     event Transfer(address indexed from, address indexed to, uint256 amount);
228 
229     /// @dev The standard EIP-20 approval event
230     event Approval(address indexed owner, address indexed spender, uint256 amount);
231 
232     /**
233      * @dev Construct a new WSG token
234      */
235     constructor() public {
236         balances[msg.sender] = uint96(totalSupply);
237         emit Transfer(address(0), msg.sender, totalSupply);
238         minter = msg.sender;
239         emit MinterChanged(address(0), minter);
240     }
241 
242     /**
243      * @dev Change the minter address
244      * @param minter_ The address of the new minter
245      */
246     function setMinter(address minter_) external {
247         require(msg.sender == minter, "WSG::setMinter: only the minter can change the minter address");
248         emit MinterChanged(minter, minter_);
249         minter = minter_;
250     }
251 
252     /**
253      * @dev Mint new tokens
254      * @param dst The address of the destination account
255      * @param rawAmount The number of tokens to be minted
256      */
257     function mint(address dst, uint rawAmount) external {
258         require(msg.sender == minter, "WSG::mint: only the minter can mint");
259         require(dst != address(0), "WSG::mint: cannot transfer to the zero address");
260 
261         // mint the amount
262         uint96 amount = safe96(rawAmount, "WSG::mint: amount exceeds 96 bits");
263         totalSupply = safe96(SafeMath.add(totalSupply, amount), "WSG::mint: totalSupply exceeds 96 bits");
264 
265         // transfer the amount to the recipient
266         balances[dst] = add96(balances[dst], amount, "WSG::mint: transfer amount overflows");
267         emit Transfer(address(0), dst, amount);
268 
269         // move delegates
270         _moveDelegates(address(0), delegates[dst], amount);
271     }
272 
273      /**
274      * @dev Destroys `amount` tokens from `account`, reducing the
275      * total supply.
276      *
277      * Emits a {Transfer} event with `to` set to the zero address.
278      *
279      * Requirements:
280      *
281      * - `account` cannot be the zero address.
282      * - `account` must have at least `amount` tokens.
283      */
284     function _burn(address account, uint256 amount) internal virtual {
285         require(account != address(0), "WSG::burn: burn from the zero address");
286         uint256 accountBalance = balances[account];
287         require(accountBalance >= amount, "WSG::burn: burn amount exceeds balance");
288         balances[account] = safe96(SafeMath.sub(accountBalance, amount), "WSG::burn: amount exceeds 96 bits");
289         totalSupply = safe96(SafeMath.sub(totalSupply, amount), "WSG::burn: amount exceeds 96 bits");
290 
291         emit Transfer(account, address(0), amount);
292     }
293 
294     /**
295      * @dev Destroys `amount` tokens from the caller.
296      *
297      * See {ERC20-_burn}.
298      */
299     function burn(uint256 amount) public virtual {
300         _burn(msg.sender, amount);
301     }
302 
303     /**
304      * @dev Get the number of tokens `spender` is approved to spend on behalf of `account`
305      * @param account The address of the account holding the funds
306      * @param spender The address of the account spending the funds
307      * @return The number of tokens approved
308      */
309     function allowance(address account, address spender) external view returns (uint) {
310         return allowances[account][spender];
311     }
312 
313     /**
314      * @dev Approve `spender` to transfer up to `amount` from `src`
315      * @dev This will overwrite the approval amount for `spender`
316      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
317      * @param spender The address of the account which may transfer tokens
318      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
319      * @return Whether or not the approval succeeded
320      */
321     function approve(address spender, uint rawAmount) external returns (bool) {
322         uint96 amount;
323         if (rawAmount == uint(-1)) {
324             amount = uint96(-1);
325         } else {
326             amount = safe96(rawAmount, "WSG::approve: amount exceeds 96 bits");
327         }
328 
329         allowances[msg.sender][spender] = amount;
330 
331         emit Approval(msg.sender, spender, amount);
332         return true;
333     }
334 
335     /**
336      * @dev Triggers an approval from owner to spends
337      * @param owner The address to approve from
338      * @param spender The address to be approved
339      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
340      * @param deadline The time at which to expire the signature
341      * @param v The recovery byte of the signature
342      * @param r Half of the ECDSA signature pair
343      * @param s Half of the ECDSA signature pair
344      */
345     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
346         uint96 amount;
347         if (rawAmount == uint(-1)) {
348             amount = uint96(-1);
349         } else {
350             amount = safe96(rawAmount, "WSG::permit: amount exceeds 96 bits");
351         }
352 
353         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
354         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
355         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
356         address signatory = ecrecover(digest, v, r, s);
357         require(signatory != address(0), "WSG::permit: invalid signature");
358         require(signatory == owner, "WSG::permit: unauthorized");
359         require(now <= deadline, "WSG::permit: signature expired");
360 
361         allowances[owner][spender] = amount;
362 
363         emit Approval(owner, spender, amount);
364     }
365 
366     /**
367      * @dev Get the number of tokens held by the `account`
368      * @param account The address of the account to get the balance of
369      * @return The number of tokens held
370      */
371     function balanceOf(address account) external view returns (uint) {
372         return balances[account];
373     }
374 
375     /**
376      * @dev Transfer `amount` tokens from `msg.sender` to `dst`
377      * @param dst The address of the destination account
378      * @param rawAmount The number of tokens to transfer
379      * @return Whether or not the transfer succeeded
380      */
381     function transfer(address dst, uint rawAmount) external returns (bool) {
382         uint96 amount = safe96(rawAmount, "WSG::transfer: amount exceeds 96 bits");
383         _transferTokens(msg.sender, dst, amount);
384         return true;
385     }
386 
387     /**
388      * @dev Transfer `amount` tokens from `src` to `dst`
389      * @param src The address of the source account
390      * @param dst The address of the destination account
391      * @param rawAmount The number of tokens to transfer
392      * @return Whether or not the transfer succeeded
393      */
394     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
395         address spender = msg.sender;
396         uint96 spenderAllowance = allowances[src][spender];
397         uint96 amount = safe96(rawAmount, "WSG::approve: amount exceeds 96 bits");
398 
399         if (spender != src && spenderAllowance != uint96(-1)) {
400             uint96 newAllowance = sub96(spenderAllowance, amount, "WSG::transferFrom: transfer amount exceeds spender allowance");
401             allowances[src][spender] = newAllowance;
402 
403             emit Approval(src, spender, newAllowance);
404         }
405 
406         _transferTokens(src, dst, amount);
407         return true;
408     }
409 
410     /**
411      * @dev Delegate votes from `msg.sender` to `delegatee`
412      * @param delegatee The address to delegate votes to
413      */
414     function delegate(address delegatee) public {
415         return _delegate(msg.sender, delegatee);
416     }
417 
418     /**
419      * @dev Delegates votes from signatory to `delegatee`
420      * @param delegatee The address to delegate votes to
421      * @param nonce The contract state required to match the signature
422      * @param expiry The time at which to expire the signature
423      * @param v The recovery byte of the signature
424      * @param r Half of the ECDSA signature pair
425      * @param s Half of the ECDSA signature pair
426      */
427     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
428         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
429         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
430         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
431         address signatory = ecrecover(digest, v, r, s);
432         require(signatory != address(0), "WSG::delegateBySig: invalid signature");
433         require(nonce == nonces[signatory]++, "WSG::delegateBySig: invalid nonce");
434         require(now <= expiry, "WSG::delegateBySig: signature expired");
435         return _delegate(signatory, delegatee);
436     }
437 
438     /**
439      * @dev Gets the current votes balance for `account`
440      * @param account The address to get votes balance
441      * @return The number of current votes for `account`
442      */
443     function getCurrentVotes(address account) external view returns (uint96) {
444         uint32 nCheckpoints = numCheckpoints[account];
445         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
446     }
447 
448     /**
449      * @dev Determine the prior number of votes for an account as of a block number
450      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
451      * @param account The address of the account to check
452      * @param blockNumber The block number to get the vote balance at
453      * @return The number of votes the account had as of the given block
454      */
455     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
456         require(blockNumber < block.number, "WSG::getPriorVotes: not yet determined");
457 
458         uint32 nCheckpoints = numCheckpoints[account];
459         if (nCheckpoints == 0) {
460             return 0;
461         }
462 
463         // First check most recent balance
464         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
465             return checkpoints[account][nCheckpoints - 1].votes;
466         }
467 
468         // Next check implicit zero balance
469         if (checkpoints[account][0].fromBlock > blockNumber) {
470             return 0;
471         }
472 
473         uint32 lower = 0;
474         uint32 upper = nCheckpoints - 1;
475         while (upper > lower) {
476             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
477             Checkpoint memory cp = checkpoints[account][center];
478             if (cp.fromBlock == blockNumber) {
479                 return cp.votes;
480             } else if (cp.fromBlock < blockNumber) {
481                 lower = center;
482             } else {
483                 upper = center - 1;
484             }
485         }
486         return checkpoints[account][lower].votes;
487     }
488 
489     function _delegate(address delegator, address delegatee) internal {
490         address currentDelegate = delegates[delegator];
491         uint96 delegatorBalance = balances[delegator];
492         delegates[delegator] = delegatee;
493 
494         emit DelegateChanged(delegator, currentDelegate, delegatee);
495 
496         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
497     }
498 
499     function _transferTokens(address src, address dst, uint96 amount) internal {
500         require(src != address(0), "WSG::_transferTokens: cannot transfer from the zero address");
501         require(dst != address(0), "WSG::_transferTokens: cannot transfer to the zero address");
502 
503         balances[src] = sub96(balances[src], amount, "WSG::_transferTokens: transfer amount exceeds balance");
504         balances[dst] = add96(balances[dst], amount, "WSG::_transferTokens: transfer amount overflows");
505         emit Transfer(src, dst, amount);
506 
507         _moveDelegates(delegates[src], delegates[dst], amount);
508     }
509 
510     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
511         if (srcRep != dstRep && amount > 0) {
512             if (srcRep != address(0)) {
513                 uint32 srcRepNum = numCheckpoints[srcRep];
514                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
515                 uint96 srcRepNew = sub96(srcRepOld, amount, "WSG::_moveVotes: vote amount underflows");
516                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
517             }
518 
519             if (dstRep != address(0)) {
520                 uint32 dstRepNum = numCheckpoints[dstRep];
521                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
522                 uint96 dstRepNew = add96(dstRepOld, amount, "WSG::_moveVotes: vote amount overflows");
523                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
524             }
525         }
526     }
527 
528     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
529       uint32 blockNumber = safe32(block.number, "WSG::_writeCheckpoint: block number exceeds 32 bits");
530 
531       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
532           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
533       } else {
534           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
535           numCheckpoints[delegatee] = nCheckpoints + 1;
536       }
537 
538       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
539     }
540 
541     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
542         require(n < 2**32, errorMessage);
543         return uint32(n);
544     }
545 
546     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
547         require(n < 2**96, errorMessage);
548         return uint96(n);
549     }
550 
551     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
552         uint96 c = a + b;
553         require(c >= a, errorMessage);
554         return c;
555     }
556 
557     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
558         require(b <= a, errorMessage);
559         return a - b;
560     }
561 
562     function getChainId() internal pure returns (uint) {
563         uint256 chainId;
564         assembly { chainId := chainid() }
565         return chainId;
566     }
567 }