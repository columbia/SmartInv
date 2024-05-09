1 // SPDX-License-Identifier: GPL-3.0-only
2 // Copyright 2020 Compound Labs, Inc.
3 //
4 // Redistribution and use in source and binary forms, with or without
5 // modification, are permitted provided that the following conditions are met:
6 //
7 // 1. Redistributions of source code must retain the above copyright notice,
8 // this list of conditions and the following disclaimer.
9 // 2. Redistributions in binary form must reproduce the above copyright notice,
10 // this list of conditions and the following disclaimer in the documentation
11 // and/or other materials provided with the distribution.
12 // 3. Neither the name of the copyright holder nor the names of its
13 // contributors may be used to endorse or promote products derived from this
14 // software without specific prior written permission.
15 //
16 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
17 // AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
18 // IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
19 // ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
20 // LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
21 // CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
22 // SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
23 // INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
24 // CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
25 // ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
26 // POSSIBILITY OF SUCH DAMAGE.
27 
28 pragma solidity ^0.7.5;
29 pragma experimental ABIEncoderV2;
30 
31 contract RadicleToken {
32     /// @notice EIP-20 token name for this token
33     string public constant NAME = "Radicle";
34 
35     /// @notice EIP-20 token symbol for this token
36     string public constant SYMBOL = "RAD";
37 
38     /// @notice EIP-20 token decimals for this token
39     uint8 public constant DECIMALS = 18;
40 
41     /// @notice Total number of tokens in circulation
42     uint256 public totalSupply = 100000000e18; // 100 million tokens
43 
44     // Allowance amounts on behalf of others
45     mapping(address => mapping(address => uint96)) internal allowances;
46 
47     // Official record of token balances for each account
48     mapping(address => uint96) internal balances;
49 
50     /// @notice A record of each accounts delegate
51     mapping(address => address) public delegates;
52 
53     /// @notice A checkpoint for marking number of votes from a given block
54     struct Checkpoint {
55         uint32 fromBlock;
56         uint96 votes;
57     }
58 
59     /// @notice A record of votes checkpoints for each account, by index
60     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
61 
62     /// @notice The number of checkpoints for each account
63     mapping(address => uint32) public numCheckpoints;
64 
65     /// @notice The EIP-712 typehash for the contract's domain
66     bytes32 public constant DOMAIN_TYPEHASH =
67         keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
68 
69     /// @notice The EIP-712 typehash for the delegation struct used by the contract
70     bytes32 public constant DELEGATION_TYPEHASH =
71         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
72 
73     /// @notice The EIP-712 typehash for EIP-2612 permit
74     bytes32 public constant PERMIT_TYPEHASH =
75         keccak256(
76             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
77         );
78     /// @notice A record of states for signing / validating signatures
79     mapping(address => uint256) public nonces;
80 
81     /// @notice An event thats emitted when an account changes its delegate
82     event DelegateChanged(
83         address indexed delegator,
84         address indexed fromDelegate,
85         address indexed toDelegate
86     );
87 
88     /// @notice An event thats emitted when a delegate account's vote balance changes
89     event DelegateVotesChanged(
90         address indexed delegate,
91         uint256 previousBalance,
92         uint256 newBalance
93     );
94 
95     /// @notice The standard EIP-20 transfer event
96     event Transfer(address indexed from, address indexed to, uint256 amount);
97 
98     /// @notice The standard EIP-20 approval event
99     event Approval(address indexed owner, address indexed spender, uint256 amount);
100 
101     /**
102      * @notice Construct a new token
103      * @param account The initial account to grant all the tokens
104      */
105     constructor(address account) {
106         balances[account] = uint96(totalSupply);
107         emit Transfer(address(0), account, totalSupply);
108     }
109 
110     /* @notice Token name */
111     function name() public pure returns (string memory) {
112         return NAME;
113     }
114 
115     /* @notice Token symbol */
116     function symbol() public pure returns (string memory) {
117         return SYMBOL;
118     }
119 
120     /* @notice Token decimals */
121     function decimals() public pure returns (uint8) {
122         return DECIMALS;
123     }
124 
125     /* @notice domainSeparator */
126     // solhint-disable func-name-mixedcase
127     function DOMAIN_SEPARATOR() public view returns (bytes32) {
128         return
129             keccak256(
130                 abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(NAME)), getChainId(), address(this))
131             );
132     }
133 
134     /**
135      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
136      * @param account The address of the account holding the funds
137      * @param spender The address of the account spending the funds
138      * @return The number of tokens approved
139      */
140     function allowance(address account, address spender) external view returns (uint256) {
141         return allowances[account][spender];
142     }
143 
144     /**
145      * @notice Approve `spender` to transfer up to `amount` from `src`
146      * @dev This will overwrite the approval amount for `spender`
147      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
148      * @param spender The address of the account which may transfer tokens
149      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
150      * @return Whether or not the approval succeeded
151      */
152     function approve(address spender, uint256 rawAmount) external returns (bool) {
153         _approve(msg.sender, spender, rawAmount);
154         return true;
155     }
156 
157     function _approve(
158         address owner,
159         address spender,
160         uint256 rawAmount
161     ) internal {
162         uint96 amount;
163         if (rawAmount == uint256(-1)) {
164             amount = uint96(-1);
165         } else {
166             amount = safe96(rawAmount, "RadicleToken::approve: amount exceeds 96 bits");
167         }
168 
169         allowances[owner][spender] = amount;
170 
171         emit Approval(owner, spender, amount);
172     }
173 
174     /**
175      * @notice Get the number of tokens held by the `account`
176      * @param account The address of the account to get the balance of
177      * @return The number of tokens held
178      */
179     function balanceOf(address account) external view returns (uint256) {
180         return balances[account];
181     }
182 
183     /**
184      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
185      * @param dst The address of the destination account
186      * @param rawAmount The number of tokens to transfer
187      * @return Whether or not the transfer succeeded
188      */
189     function transfer(address dst, uint256 rawAmount) external returns (bool) {
190         uint96 amount = safe96(rawAmount, "RadicleToken::transfer: amount exceeds 96 bits");
191         _transferTokens(msg.sender, dst, amount);
192         return true;
193     }
194 
195     /**
196      * @notice Transfer `amount` tokens from `src` to `dst`
197      * @param src The address of the source account
198      * @param dst The address of the destination account
199      * @param rawAmount The number of tokens to transfer
200      * @return Whether or not the transfer succeeded
201      */
202     function transferFrom(
203         address src,
204         address dst,
205         uint256 rawAmount
206     ) external returns (bool) {
207         address spender = msg.sender;
208         uint96 spenderAllowance = allowances[src][spender];
209         uint96 amount = safe96(rawAmount, "RadicleToken::approve: amount exceeds 96 bits");
210 
211         if (spender != src && spenderAllowance != uint96(-1)) {
212             uint96 newAllowance =
213                 sub96(
214                     spenderAllowance,
215                     amount,
216                     "RadicleToken::transferFrom: transfer amount exceeds spender allowance"
217                 );
218             allowances[src][spender] = newAllowance;
219 
220             emit Approval(src, spender, newAllowance);
221         }
222 
223         _transferTokens(src, dst, amount);
224         return true;
225     }
226 
227     /**
228      * @notice Burn `rawAmount` tokens from `account`
229      * @param account The address of the account to burn
230      * @param rawAmount The number of tokens to burn
231      */
232     function burnFrom(address account, uint256 rawAmount) public {
233         require(account != address(0), "RadicleToken::burnFrom: cannot burn from the zero address");
234         uint96 amount = safe96(rawAmount, "RadicleToken::burnFrom: amount exceeds 96 bits");
235 
236         address spender = msg.sender;
237         uint96 spenderAllowance = allowances[account][spender];
238         if (spender != account && spenderAllowance != uint96(-1)) {
239             uint96 newAllowance =
240                 sub96(
241                     spenderAllowance,
242                     amount,
243                     "RadicleToken::burnFrom: burn amount exceeds allowance"
244                 );
245             allowances[account][spender] = newAllowance;
246             emit Approval(account, spender, newAllowance);
247         }
248 
249         balances[account] = sub96(
250             balances[account],
251             amount,
252             "RadicleToken::burnFrom: burn amount exceeds balance"
253         );
254         emit Transfer(account, address(0), amount);
255 
256         _moveDelegates(delegates[account], address(0), amount);
257 
258         totalSupply -= rawAmount;
259     }
260 
261     /**
262      * @notice Delegate votes from `msg.sender` to `delegatee`
263      * @param delegatee The address to delegate votes to
264      */
265     function delegate(address delegatee) public {
266         return _delegate(msg.sender, delegatee);
267     }
268 
269     /**
270      * @notice Delegates votes from signatory to `delegatee`
271      * @param delegatee The address to delegate votes to
272      * @param nonce The contract state required to match the signature
273      * @param expiry The time at which to expire the signature
274      * @param v The recovery byte of the signature
275      * @param r Half of the ECDSA signature pair
276      * @param s Half of the ECDSA signature pair
277      */
278     function delegateBySig(
279         address delegatee,
280         uint256 nonce,
281         uint256 expiry,
282         uint8 v,
283         bytes32 r,
284         bytes32 s
285     ) public {
286         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
287         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), structHash));
288         address signatory = ecrecover(digest, v, r, s);
289         require(signatory != address(0), "RadicleToken::delegateBySig: invalid signature");
290         require(nonce == nonces[signatory]++, "RadicleToken::delegateBySig: invalid nonce");
291         require(block.timestamp <= expiry, "RadicleToken::delegateBySig: signature expired");
292         _delegate(signatory, delegatee);
293     }
294 
295     /**
296      * @notice Approves spender to spend on behalf of owner.
297      * @param owner The signer of the permit
298      * @param spender The address to approve
299      * @param deadline The time at which the signature expires
300      * @param v The recovery byte of the signature
301      * @param r Half of the ECDSA signature pair
302      * @param s Half of the ECDSA signature pair
303      */
304     function permit(
305         address owner,
306         address spender,
307         uint256 value,
308         uint256 deadline,
309         uint8 v,
310         bytes32 r,
311         bytes32 s
312     ) public {
313         bytes32 structHash =
314             keccak256(
315                 abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline)
316             );
317         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), structHash));
318         require(owner == ecrecover(digest, v, r, s), "RadicleToken::permit: invalid signature");
319         require(owner != address(0), "RadicleToken::permit: invalid signature");
320         require(block.timestamp <= deadline, "RadicleToken::permit: signature expired");
321         _approve(owner, spender, value);
322     }
323 
324     /**
325      * @notice Gets the current votes balance for `account`
326      * @param account The address to get votes balance
327      * @return The number of current votes for `account`
328      */
329     function getCurrentVotes(address account) external view returns (uint96) {
330         uint32 nCheckpoints = numCheckpoints[account];
331         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
332     }
333 
334     /**
335      * @notice Determine the prior number of votes for an account as of a block number
336      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
337      * @param account The address of the account to check
338      * @param blockNumber The block number to get the vote balance at
339      * @return The number of votes the account had as of the given block
340      */
341     function getPriorVotes(address account, uint256 blockNumber) public view returns (uint96) {
342         require(blockNumber < block.number, "RadicleToken::getPriorVotes: not yet determined");
343 
344         uint32 nCheckpoints = numCheckpoints[account];
345         if (nCheckpoints == 0) {
346             return 0;
347         }
348 
349         // First check most recent balance
350         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
351             return checkpoints[account][nCheckpoints - 1].votes;
352         }
353 
354         // Next check implicit zero balance
355         if (checkpoints[account][0].fromBlock > blockNumber) {
356             return 0;
357         }
358 
359         uint32 lower = 0;
360         uint32 upper = nCheckpoints - 1;
361         while (upper > lower) {
362             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
363             Checkpoint memory cp = checkpoints[account][center];
364             if (cp.fromBlock == blockNumber) {
365                 return cp.votes;
366             } else if (cp.fromBlock < blockNumber) {
367                 lower = center;
368             } else {
369                 upper = center - 1;
370             }
371         }
372         return checkpoints[account][lower].votes;
373     }
374 
375     function _delegate(address delegator, address delegatee) internal {
376         address currentDelegate = delegates[delegator];
377         uint96 delegatorBalance = balances[delegator];
378         delegates[delegator] = delegatee;
379 
380         emit DelegateChanged(delegator, currentDelegate, delegatee);
381 
382         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
383     }
384 
385     function _transferTokens(
386         address src,
387         address dst,
388         uint96 amount
389     ) internal {
390         require(
391             src != address(0),
392             "RadicleToken::_transferTokens: cannot transfer from the zero address"
393         );
394         require(
395             dst != address(0),
396             "RadicleToken::_transferTokens: cannot transfer to the zero address"
397         );
398 
399         balances[src] = sub96(
400             balances[src],
401             amount,
402             "RadicleToken::_transferTokens: transfer amount exceeds balance"
403         );
404         balances[dst] = add96(
405             balances[dst],
406             amount,
407             "RadicleToken::_transferTokens: transfer amount overflows"
408         );
409         emit Transfer(src, dst, amount);
410 
411         _moveDelegates(delegates[src], delegates[dst], amount);
412     }
413 
414     function _moveDelegates(
415         address srcRep,
416         address dstRep,
417         uint96 amount
418     ) internal {
419         if (srcRep != dstRep && amount > 0) {
420             if (srcRep != address(0)) {
421                 uint32 srcRepNum = numCheckpoints[srcRep];
422                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
423                 uint96 srcRepNew =
424                     sub96(srcRepOld, amount, "RadicleToken::_moveVotes: vote amount underflows");
425                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
426             }
427 
428             if (dstRep != address(0)) {
429                 uint32 dstRepNum = numCheckpoints[dstRep];
430                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
431                 uint96 dstRepNew =
432                     add96(dstRepOld, amount, "RadicleToken::_moveVotes: vote amount overflows");
433                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
434             }
435         }
436     }
437 
438     function _writeCheckpoint(
439         address delegatee,
440         uint32 nCheckpoints,
441         uint96 oldVotes,
442         uint96 newVotes
443     ) internal {
444         uint32 blockNumber =
445             safe32(block.number, "RadicleToken::_writeCheckpoint: block number exceeds 32 bits");
446 
447         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
448             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
449         } else {
450             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
451             numCheckpoints[delegatee] = nCheckpoints + 1;
452         }
453 
454         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
455     }
456 
457     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
458         require(n < 2**32, errorMessage);
459         return uint32(n);
460     }
461 
462     function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
463         require(n < 2**96, errorMessage);
464         return uint96(n);
465     }
466 
467     function add96(
468         uint96 a,
469         uint96 b,
470         string memory errorMessage
471     ) internal pure returns (uint96) {
472         uint96 c = a + b;
473         require(c >= a, errorMessage);
474         return c;
475     }
476 
477     function sub96(
478         uint96 a,
479         uint96 b,
480         string memory errorMessage
481     ) internal pure returns (uint96) {
482         require(b <= a, errorMessage);
483         return a - b;
484     }
485 
486     function getChainId() internal pure returns (uint256) {
487         uint256 chainId;
488         // solhint-disable no-inline-assembly
489         assembly {
490             chainId := chainid()
491         }
492         return chainId;
493     }
494 }