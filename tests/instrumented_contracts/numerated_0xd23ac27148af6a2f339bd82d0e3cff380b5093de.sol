1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-14
3 */
4 
5 // From the dark depths below, rise up all Merfolks and sound your Sirens...
6 
7 // File: contracts/governance/SirenToken.sol
8 
9 pragma solidity 0.6.12;
10 
11 contract SirenToken {
12     /// @notice EIP-20 token name for this token
13     string public constant name = "SIREN";
14 
15     /// @notice EIP-20 token symbol for this token
16     string public constant symbol = "SI";
17 
18     /// @notice EIP-20 token decimals for this token
19     uint8 public constant decimals = 18;
20 
21     /// @notice Total number of tokens in circulation
22     uint256 public constant totalSupply = 100_000_000e18; // 100 million SRN
23 
24     /// @dev Allowance amounts on behalf of others
25     mapping(address => mapping(address => uint96)) internal allowances;
26 
27     /// @dev Official record of token balances for each account
28     mapping(address => uint96) internal balances;
29 
30     /// @notice A record of each accounts delegate
31     mapping(address => address) public delegates;
32 
33     /// @notice A checkpoint for marking number of votes from a given block
34     struct Checkpoint {
35         uint32 fromBlock;
36         uint96 votes;
37     }
38 
39     /// @notice A record of votes checkpoints for each account, by index
40     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
41 
42     /// @notice The number of checkpoints for each account
43     mapping(address => uint32) public numCheckpoints;
44 
45     /// @notice The EIP-712 typehash for the contract's domain
46     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
47         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
48     );
49 
50     /// @notice The EIP-712 typehash for the delegation struct used by the contract
51     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
52         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
53     );
54 
55     /// @notice A record of states for signing / validating signatures
56     mapping(address => uint256) public nonces;
57 
58     /// @notice An event thats emitted when an account changes its delegate
59     event DelegateChanged(
60         address indexed delegator,
61         address indexed fromDelegate,
62         address indexed toDelegate
63     );
64 
65     /// @notice An event thats emitted when a delegate account's vote balance changes
66     event DelegateVotesChanged(
67         address indexed delegate,
68         uint256 previousBalance,
69         uint256 newBalance
70     );
71 
72     /// @notice The standard EIP-20 transfer event
73     event Transfer(address indexed from, address indexed to, uint256 amount);
74 
75     /// @notice The standard EIP-20 approval event
76     event Approval(
77         address indexed owner,
78         address indexed spender,
79         uint256 amount
80     );
81 
82     /**
83      * @notice Construct a new SRN token
84      * @param account The initial account to grant all the tokens
85      */
86     constructor(address account) public {
87         balances[account] = uint96(totalSupply);
88         emit Transfer(address(0), account, totalSupply);
89     }
90 
91     /**
92      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
93      * @param account The address of the account holding the funds
94      * @param spender The address of the account spending the funds
95      * @return The number of tokens approved
96      */
97     function allowance(address account, address spender)
98         external
99         view
100         returns (uint256)
101     {
102         return allowances[account][spender];
103     }
104 
105     /**
106      * @notice Approve `spender` to transfer up to `amount` from `src`
107      * @dev This will overwrite the approval amount for `spender`
108      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
109      * @param spender The address of the account which may transfer tokens
110      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
111      * @return Whether or not the approval succeeded
112      */
113     function approve(address spender, uint256 rawAmount)
114         external
115         returns (bool)
116     {
117         uint96 amount;
118         if (rawAmount == uint256(-1)) {
119             amount = uint96(-1);
120         } else {
121             amount = safe96(
122                 rawAmount,
123                 "Siren::approve: amount exceeds 96 bits"
124             );
125         }
126 
127         allowances[msg.sender][spender] = amount;
128 
129         emit Approval(msg.sender, spender, amount);
130         return true;
131     }
132 
133     /**
134      * @notice Get the number of tokens held by the `account`
135      * @param account The address of the account to get the balance of
136      * @return The number of tokens held
137      */
138     function balanceOf(address account) external view returns (uint256) {
139         return balances[account];
140     }
141 
142     /**
143      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
144      * @param dst The address of the destination account
145      * @param rawAmount The number of tokens to transfer
146      * @return Whether or not the transfer succeeded
147      */
148     function transfer(address dst, uint256 rawAmount) external returns (bool) {
149         uint96 amount = safe96(
150             rawAmount,
151             "Siren::transfer: amount exceeds 96 bits"
152         );
153         _transferTokens(msg.sender, dst, amount);
154         return true;
155     }
156 
157     /**
158      * @notice Transfer `amount` tokens from `src` to `dst`
159      * @param src The address of the source account
160      * @param dst The address of the destination account
161      * @param rawAmount The number of tokens to transfer
162      * @return Whether or not the transfer succeeded
163      */
164     function transferFrom(
165         address src,
166         address dst,
167         uint256 rawAmount
168     ) external returns (bool) {
169         address spender = msg.sender;
170         uint96 spenderAllowance = allowances[src][spender];
171         uint96 amount = safe96(
172             rawAmount,
173             "Siren::approve: amount exceeds 96 bits"
174         );
175 
176         if (spender != src && spenderAllowance != uint96(-1)) {
177             uint96 newAllowance = sub96(
178                 spenderAllowance,
179                 amount,
180                 "Siren::transferFrom: transfer amount exceeds spender allowance"
181             );
182             allowances[src][spender] = newAllowance;
183 
184             emit Approval(src, spender, newAllowance);
185         }
186 
187         _transferTokens(src, dst, amount);
188         return true;
189     }
190 
191     /**
192      * @notice Delegate votes from `msg.sender` to `delegatee`
193      * @param delegatee The address to delegate votes to
194      */
195     function delegate(address delegatee) public {
196         return _delegate(msg.sender, delegatee);
197     }
198 
199     /**
200      * @notice Delegates votes from signatory to `delegatee`
201      * @param delegatee The address to delegate votes to
202      * @param nonce The contract state required to match the signature
203      * @param expiry The time at which to expire the signature
204      * @param v The recovery byte of the signature
205      * @param r Half of the ECDSA signature pair
206      * @param s Half of the ECDSA signature pair
207      */
208     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
209         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
210         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
211         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
212 
213         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
214         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
215         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
216         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
217         //
218         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
219         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
220         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
221         // these malleable signatures as well.
222         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
223         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
224 
225         address signatory = ecrecover(digest, v, r, s);
226         require(
227             signatory != address(0),
228             "Siren::delegateBySig: invalid signature"
229         );
230         require(
231             nonce == nonces[signatory]++,
232             "Siren::delegateBySig: invalid nonce"
233         );
234         require(now <= expiry, "Siren::delegateBySig: signature expired");
235         return _delegate(signatory, delegatee);
236     }
237 
238     /**
239      * @notice Gets the current votes balance for `account`
240      * @param account The address to get votes balance
241      * @return The number of current votes for `account`
242      */
243     function getCurrentVotes(address account) external view returns (uint96) {
244         uint32 nCheckpoints = numCheckpoints[account];
245         return
246             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
247     }
248 
249     /**
250      * @notice Determine the prior number of votes for an account as of a block number
251      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
252      * @param account The address of the account to check
253      * @param blockNumber The block number to get the vote balance at
254      * @return The number of votes the account had as of the given block
255      */
256     function getPriorVotes(address account, uint256 blockNumber)
257         public
258         view
259         returns (uint96)
260     {
261         require(
262             blockNumber < block.number,
263             "Siren::getPriorVotes: not yet determined"
264         );
265 
266         uint32 nCheckpoints = numCheckpoints[account];
267         if (nCheckpoints == 0) {
268             return 0;
269         }
270 
271         // First check most recent balance
272         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
273             return checkpoints[account][nCheckpoints - 1].votes;
274         }
275 
276         // Next check implicit zero balance
277         if (checkpoints[account][0].fromBlock > blockNumber) {
278             return 0;
279         }
280 
281         uint32 lower = 0;
282         uint32 upper = nCheckpoints - 1;
283         while (upper > lower) {
284             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
285             Checkpoint memory cp = checkpoints[account][center];
286             if (cp.fromBlock == blockNumber) {
287                 return cp.votes;
288             } else if (cp.fromBlock < blockNumber) {
289                 lower = center;
290             } else {
291                 upper = center - 1;
292             }
293         }
294         return checkpoints[account][lower].votes;
295     }
296 
297     function _delegate(address delegator, address delegatee) internal {
298         address currentDelegate = delegates[delegator];
299         uint96 delegatorBalance = balances[delegator];
300         delegates[delegator] = delegatee;
301 
302         emit DelegateChanged(delegator, currentDelegate, delegatee);
303 
304         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
305     }
306 
307     function _transferTokens(
308         address src,
309         address dst,
310         uint96 amount
311     ) internal {
312         require(
313             src != address(0),
314             "Siren::_transferTokens: cannot transfer from the zero address"
315         );
316         require(
317             dst != address(0),
318             "Siren::_transferTokens: cannot transfer to the zero address"
319         );
320 
321         balances[src] = sub96(
322             balances[src],
323             amount,
324             "Siren::_transferTokens: transfer amount exceeds balance"
325         );
326         balances[dst] = add96(
327             balances[dst],
328             amount,
329             "Siren::_transferTokens: transfer amount overflows"
330         );
331         emit Transfer(src, dst, amount);
332 
333         _moveDelegates(delegates[src], delegates[dst], amount);
334     }
335 
336     function _moveDelegates(
337         address srcRep,
338         address dstRep,
339         uint96 amount
340     ) internal {
341         if (srcRep != dstRep && amount > 0) {
342             if (srcRep != address(0)) {
343                 uint32 srcRepNum = numCheckpoints[srcRep];
344                 uint96 srcRepOld = srcRepNum > 0
345                     ? checkpoints[srcRep][srcRepNum - 1].votes
346                     : 0;
347                 uint96 srcRepNew = sub96(
348                     srcRepOld,
349                     amount,
350                     "Siren::_moveVotes: vote amount underflows"
351                 );
352                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
353             }
354 
355             if (dstRep != address(0)) {
356                 uint32 dstRepNum = numCheckpoints[dstRep];
357                 uint96 dstRepOld = dstRepNum > 0
358                     ? checkpoints[dstRep][dstRepNum - 1].votes
359                     : 0;
360                 uint96 dstRepNew = add96(
361                     dstRepOld,
362                     amount,
363                     "Siren::_moveVotes: vote amount overflows"
364                 );
365                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
366             }
367         }
368     }
369 
370     function _writeCheckpoint(
371         address delegatee,
372         uint32 nCheckpoints,
373         uint96 oldVotes,
374         uint96 newVotes
375     ) internal {
376         uint32 blockNumber = safe32(
377             block.number,
378             "Siren::_writeCheckpoint: block number exceeds 32 bits"
379         );
380 
381         if (
382             nCheckpoints > 0 &&
383             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
384         ) {
385             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
386         } else {
387             checkpoints[delegatee][nCheckpoints] = Checkpoint(
388                 blockNumber,
389                 newVotes
390             );
391             numCheckpoints[delegatee] = nCheckpoints + 1;
392         }
393 
394         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
395     }
396 
397     function safe32(uint256 n, string memory errorMessage)
398         internal
399         pure
400         returns (uint32)
401     {
402         require(n < 2**32, errorMessage);
403         return uint32(n);
404     }
405 
406     function safe96(uint256 n, string memory errorMessage)
407         internal
408         pure
409         returns (uint96)
410     {
411         require(n < 2**96, errorMessage);
412         return uint96(n);
413     }
414 
415     function add96(
416         uint96 a,
417         uint96 b,
418         string memory errorMessage
419     ) internal pure returns (uint96) {
420         uint96 c = a + b;
421         require(c >= a, errorMessage);
422         return c;
423     }
424 
425     function sub96(
426         uint96 a,
427         uint96 b,
428         string memory errorMessage
429     ) internal pure returns (uint96) {
430         require(b <= a, errorMessage);
431         return a - b;
432     }
433 
434     function getChainId() internal pure returns (uint256) {
435         uint256 chainId;
436         assembly {
437             chainId := chainid()
438         }
439         return chainId;
440     }
441 }
442 
443 // File: contracts/governance/Factory.sol
444 
445 pragma solidity 0.6.12;
446 
447 
448 contract Factory {
449   event TokenCreated(address token);
450   bool run  = false;
451 
452   fallback() external {
453       require(run  == false);
454       run  = true;
455       
456     SirenToken token = new SirenToken(address(0x28929B64D1E263B756Ce3CE87522Fc38778e231A));
457     emit TokenCreated(address(token));
458   }
459 }