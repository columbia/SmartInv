1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 contract Lexe {
5     /// @notice EIP-20 token name for this token
6     string public constant name = "Lendexe";
7 
8     /// @notice EIP-20 token symbol for this token
9     string public constant symbol = "LEXE";
10 
11     /// @notice EIP-20 token decimals for this token
12     uint8 public constant decimals = 18;
13 
14     /// @notice Total number of tokens in circulation
15     uint256 public constant totalSupply = 1000000000e18; // 1000 million Lexe
16 
17     /// @notice Allowance amounts on behalf of others
18     mapping(address => mapping(address => uint96)) internal allowances;
19 
20     /// @notice Official record of token balances for each account
21     mapping(address => uint96) internal balances;
22 
23     /// @notice A record of each accounts delegate
24     mapping(address => address) public delegates;
25 
26     /// @notice A checkpoint for marking number of votes from a given block
27     struct Checkpoint {
28         uint32 fromBlock;
29         uint96 votes;
30     }
31 
32     /// @notice A record of votes checkpoints for each account, by index
33     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
34 
35     /// @notice The number of checkpoints for each account
36     mapping(address => uint32) public numCheckpoints;
37 
38     /// @notice The EIP-712 typehash for the contract's domain
39     bytes32 public constant DOMAIN_TYPEHASH =
40         keccak256(
41             "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
42         );
43 
44     /// @notice The EIP-712 typehash for the delegation struct used by the contract
45     bytes32 public constant DELEGATION_TYPEHASH =
46         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
47 
48     /// @notice A record of states for signing / validating signatures
49     mapping(address => uint256) public nonces;
50 
51     /// @notice An event thats emitted when an account changes its delegate
52     event DelegateChanged(
53         address indexed delegator,
54         address indexed fromDelegate,
55         address indexed toDelegate
56     );
57 
58     /// @notice An event thats emitted when a delegate account's vote balance changes
59     event DelegateVotesChanged(
60         address indexed delegate,
61         uint256 previousBalance,
62         uint256 newBalance
63     );
64 
65     /// @notice The standard EIP-20 transfer event
66     event Transfer(address indexed from, address indexed to, uint256 amount);
67 
68     /// @notice The standard EIP-20 approval event
69     event Approval(
70         address indexed owner,
71         address indexed spender,
72         uint256 amount
73     );
74 
75     /**
76      * @notice Construct a new Lexe token
77      * @param account The initial account to grant all the tokens
78      */
79     constructor(address account) public {
80         balances[account] = uint96(totalSupply);
81         emit Transfer(address(0), account, totalSupply);
82     }
83 
84     /**
85      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
86      * @param account The address of the account holding the funds
87      * @param spender The address of the account spending the funds
88      * @return The number of tokens approved
89      */
90     function allowance(address account, address spender)
91         external
92         view
93         returns (uint256)
94     {
95         return allowances[account][spender];
96     }
97 
98     /**
99      * @notice Approve `spender` to transfer up to `amount` from `src`
100      * @dev This will overwrite the approval amount for `spender`
101      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
102      * @param spender The address of the account which may transfer tokens
103      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
104      * @return Whether or not the approval succeeded
105      */
106     function approve(address spender, uint256 rawAmount)
107         external
108         returns (bool)
109     {
110         uint96 amount;
111         if (rawAmount == uint256(-1)) {
112             amount = uint96(-1);
113         } else {
114             amount = safe96(rawAmount, "Lexe::approve: amount exceeds 96 bits");
115         }
116 
117         allowances[msg.sender][spender] = amount;
118 
119         emit Approval(msg.sender, spender, amount);
120         return true;
121     }
122 
123     /**
124      * @notice Get the number of tokens held by the `account`
125      * @param account The address of the account to get the balance of
126      * @return The number of tokens held
127      */
128     function balanceOf(address account) external view returns (uint256) {
129         return balances[account];
130     }
131 
132     /**
133      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
134      * @param dst The address of the destination account
135      * @param rawAmount The number of tokens to transfer
136      * @return Whether or not the transfer succeeded
137      */
138     function transfer(address dst, uint256 rawAmount) external returns (bool) {
139         uint96 amount = safe96(
140             rawAmount,
141             "Lexe::transfer: amount exceeds 96 bits"
142         );
143         _transferTokens(msg.sender, dst, amount);
144         return true;
145     }
146 
147     /**
148      * @notice Transfer `amount` tokens from `src` to `dst`
149      * @param src The address of the source account
150      * @param dst The address of the destination account
151      * @param rawAmount The number of tokens to transfer
152      * @return Whether or not the transfer succeeded
153      */
154     function transferFrom(
155         address src,
156         address dst,
157         uint256 rawAmount
158     ) external returns (bool) {
159         address spender = msg.sender;
160         uint96 spenderAllowance = allowances[src][spender];
161         uint96 amount = safe96(
162             rawAmount,
163             "Lexe::approve: amount exceeds 96 bits"
164         );
165 
166         if (spender != src && spenderAllowance != uint96(-1)) {
167             uint96 newAllowance = sub96(
168                 spenderAllowance,
169                 amount,
170                 "Lexe::transferFrom: transfer amount exceeds spender allowance"
171             );
172             allowances[src][spender] = newAllowance;
173 
174             emit Approval(src, spender, newAllowance);
175         }
176 
177         _transferTokens(src, dst, amount);
178         return true;
179     }
180 
181     /**
182      * @notice Delegate votes from `msg.sender` to `delegatee`
183      * @param delegatee The address to delegate votes to
184      */
185     function delegate(address delegatee) public {
186         return _delegate(msg.sender, delegatee);
187     }
188 
189     /**
190      * @notice Delegates votes from signatory to `delegatee`
191      * @param delegatee The address to delegate votes to
192      * @param nonce The contract state required to match the signature
193      * @param expiry The time at which to expire the signature
194      * @param v The recovery byte of the signature
195      * @param r Half of the ECDSA signature pair
196      * @param s Half of the ECDSA signature pair
197      */
198     function delegateBySig(
199         address delegatee,
200         uint256 nonce,
201         uint256 expiry,
202         uint8 v,
203         bytes32 r,
204         bytes32 s
205     ) public {
206         bytes32 domainSeparator = keccak256(
207             abi.encode(
208                 DOMAIN_TYPEHASH,
209                 keccak256(bytes(name)),
210                 getChainId(),
211                 address(this)
212             )
213         );
214         bytes32 structHash = keccak256(
215             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
216         );
217         bytes32 digest = keccak256(
218             abi.encodePacked("\x19\x01", domainSeparator, structHash)
219         );
220         address signatory = ecrecover(digest, v, r, s);
221         require(
222             signatory != address(0),
223             "Lexe::delegateBySig: invalid signature"
224         );
225         require(
226             nonce == nonces[signatory]++,
227             "Lexe::delegateBySig: invalid nonce"
228         );
229         require(now <= expiry, "Lexe::delegateBySig: signature expired");
230         return _delegate(signatory, delegatee);
231     }
232 
233     /**
234      * @notice Gets the current votes balance for `account`
235      * @param account The address to get votes balance
236      * @return The number of current votes for `account`
237      */
238     function getCurrentVotes(address account) external view returns (uint96) {
239         uint32 nCheckpoints = numCheckpoints[account];
240         return
241             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
242     }
243 
244     /**
245      * @notice Determine the prior number of votes for an account as of a block number
246      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
247      * @param account The address of the account to check
248      * @param blockNumber The block number to get the vote balance at
249      * @return The number of votes the account had as of the given block
250      */
251     function getPriorVotes(address account, uint256 blockNumber)
252         public
253         view
254         returns (uint96)
255     {
256         require(
257             blockNumber < block.number,
258             "Lexe::getPriorVotes: not yet determined"
259         );
260 
261         uint32 nCheckpoints = numCheckpoints[account];
262         if (nCheckpoints == 0) {
263             return 0;
264         }
265 
266         // First check most recent balance
267         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
268             return checkpoints[account][nCheckpoints - 1].votes;
269         }
270 
271         // Next check implicit zero balance
272         if (checkpoints[account][0].fromBlock > blockNumber) {
273             return 0;
274         }
275 
276         uint32 lower = 0;
277         uint32 upper = nCheckpoints - 1;
278         while (upper > lower) {
279             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
280             Checkpoint memory cp = checkpoints[account][center];
281             if (cp.fromBlock == blockNumber) {
282                 return cp.votes;
283             } else if (cp.fromBlock < blockNumber) {
284                 lower = center;
285             } else {
286                 upper = center - 1;
287             }
288         }
289         return checkpoints[account][lower].votes;
290     }
291 
292     function _delegate(address delegator, address delegatee) internal {
293         address currentDelegate = delegates[delegator];
294         uint96 delegatorBalance = balances[delegator];
295         delegates[delegator] = delegatee;
296 
297         emit DelegateChanged(delegator, currentDelegate, delegatee);
298 
299         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
300     }
301 
302     function _transferTokens(
303         address src,
304         address dst,
305         uint96 amount
306     ) internal {
307         require(
308             src != address(0),
309             "Lexe::_transferTokens: cannot transfer from the zero address"
310         );
311         require(
312             dst != address(0),
313             "Lexe::_transferTokens: cannot transfer to the zero address"
314         );
315 
316         balances[src] = sub96(
317             balances[src],
318             amount,
319             "Lexe::_transferTokens: transfer amount exceeds balance"
320         );
321         balances[dst] = add96(
322             balances[dst],
323             amount,
324             "Lexe::_transferTokens: transfer amount overflows"
325         );
326         emit Transfer(src, dst, amount);
327 
328         _moveDelegates(delegates[src], delegates[dst], amount);
329     }
330 
331     function _moveDelegates(
332         address srcRep,
333         address dstRep,
334         uint96 amount
335     ) internal {
336         if (srcRep != dstRep && amount > 0) {
337             if (srcRep != address(0)) {
338                 uint32 srcRepNum = numCheckpoints[srcRep];
339                 uint96 srcRepOld = srcRepNum > 0
340                     ? checkpoints[srcRep][srcRepNum - 1].votes
341                     : 0;
342                 uint96 srcRepNew = sub96(
343                     srcRepOld,
344                     amount,
345                     "Lexe::_moveVotes: vote amount underflows"
346                 );
347                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
348             }
349 
350             if (dstRep != address(0)) {
351                 uint32 dstRepNum = numCheckpoints[dstRep];
352                 uint96 dstRepOld = dstRepNum > 0
353                     ? checkpoints[dstRep][dstRepNum - 1].votes
354                     : 0;
355                 uint96 dstRepNew = add96(
356                     dstRepOld,
357                     amount,
358                     "Lexe::_moveVotes: vote amount overflows"
359                 );
360                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
361             }
362         }
363     }
364 
365     function _writeCheckpoint(
366         address delegatee,
367         uint32 nCheckpoints,
368         uint96 oldVotes,
369         uint96 newVotes
370     ) internal {
371         uint32 blockNumber = safe32(
372             block.number,
373             "Lexe::_writeCheckpoint: block number exceeds 32 bits"
374         );
375 
376         if (
377             nCheckpoints > 0 &&
378             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
379         ) {
380             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
381         } else {
382             checkpoints[delegatee][nCheckpoints] = Checkpoint(
383                 blockNumber,
384                 newVotes
385             );
386             numCheckpoints[delegatee] = nCheckpoints + 1;
387         }
388 
389         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
390     }
391 
392     function safe32(uint256 n, string memory errorMessage)
393         internal
394         pure
395         returns (uint32)
396     {
397         require(n < 2**32, errorMessage);
398         return uint32(n);
399     }
400 
401     function safe96(uint256 n, string memory errorMessage)
402         internal
403         pure
404         returns (uint96)
405     {
406         require(n < 2**96, errorMessage);
407         return uint96(n);
408     }
409 
410     function add96(
411         uint96 a,
412         uint96 b,
413         string memory errorMessage
414     ) internal pure returns (uint96) {
415         uint96 c = a + b;
416         require(c >= a, errorMessage);
417         return c;
418     }
419 
420     function sub96(
421         uint96 a,
422         uint96 b,
423         string memory errorMessage
424     ) internal pure returns (uint96) {
425         require(b <= a, errorMessage);
426         return a - b;
427     }
428 
429     function getChainId() internal pure returns (uint256) {
430         uint256 chainId;
431         assembly {
432             chainId := chainid()
433         }
434         return chainId;
435     }
436 }