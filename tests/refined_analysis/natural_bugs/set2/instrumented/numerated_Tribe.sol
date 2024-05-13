1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 // Forked from Uniswap's UNI
5 // Reference: https://etherscan.io/address/0x1f9840a85d5af5bf1d1762f925bdaddc4201f984#code
6 
7 contract Tribe {
8     /// @notice EIP-20 token name for this token
9     // solhint-disable-next-line const-name-snakecase
10     string public constant name = "Tribe";
11 
12     /// @notice EIP-20 token symbol for this token
13     // solhint-disable-next-line const-name-snakecase
14     string public constant symbol = "TRIBE";
15 
16     /// @notice EIP-20 token decimals for this token
17     // solhint-disable-next-line const-name-snakecase
18     uint8 public constant decimals = 18;
19 
20     /// @notice Total number of tokens in circulation
21     // solhint-disable-next-line const-name-snakecase
22     uint256 public totalSupply = 1_000_000_000e18; // 1 billion Tribe
23 
24     /// @notice Address which may mint new tokens
25     address public minter;
26 
27     /// @notice Allowance amounts on behalf of others
28     mapping(address => mapping(address => uint96)) internal allowances;
29 
30     /// @notice Official record of token balances for each account
31     mapping(address => uint96) internal balances;
32 
33     /// @notice A record of each accounts delegate
34     mapping(address => address) public delegates;
35 
36     /// @notice A checkpoint for marking number of votes from a given block
37     struct Checkpoint {
38         uint32 fromBlock;
39         uint96 votes;
40     }
41 
42     /// @notice A record of votes checkpoints for each account, by index
43     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
44 
45     /// @notice The number of checkpoints for each account
46     mapping(address => uint32) public numCheckpoints;
47 
48     /// @notice The EIP-712 typehash for the contract's domain
49     bytes32 public constant DOMAIN_TYPEHASH =
50         keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
51 
52     /// @notice The EIP-712 typehash for the delegation struct used by the contract
53     bytes32 public constant DELEGATION_TYPEHASH =
54         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
55 
56     /// @notice The EIP-712 typehash for the permit struct used by the contract
57     bytes32 public constant PERMIT_TYPEHASH =
58         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
59 
60     /// @notice A record of states for signing / validating signatures
61     mapping(address => uint256) public nonces;
62 
63     /// @notice An event thats emitted when the minter address is changed
64     event MinterChanged(address minter, address newMinter);
65 
66     /// @notice An event thats emitted when an account changes its delegate
67     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
68 
69     /// @notice An event thats emitted when a delegate account's vote balance changes
70     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
71 
72     /// @notice The standard EIP-20 transfer event
73     event Transfer(address indexed from, address indexed to, uint256 amount);
74 
75     /// @notice The standard EIP-20 approval event
76     event Approval(address indexed owner, address indexed spender, uint256 amount);
77 
78     /**
79      * @notice Construct a new Tribe token
80      * @param account The initial account to grant all the tokens
81      * @param minter_ The account with minting ability
82      */
83     constructor(address account, address minter_) {
84         balances[account] = uint96(totalSupply);
85         emit Transfer(address(0), account, totalSupply);
86         minter = minter_;
87         emit MinterChanged(address(0), minter);
88     }
89 
90     /**
91      * @notice Change the minter address
92      * @param minter_ The address of the new minter
93      */
94     function setMinter(address minter_) external {
95         require(msg.sender == minter, "Tribe: only the minter can change the minter address");
96         emit MinterChanged(minter, minter_);
97         minter = minter_;
98     }
99 
100     /**
101      * @notice Mint new tokens
102      * @param dst The address of the destination account
103      * @param rawAmount The number of tokens to be minted
104      */
105     function mint(address dst, uint256 rawAmount) external {
106         require(msg.sender == minter, "Tribe: only the minter can mint");
107         require(dst != address(0), "Tribe: cannot transfer to the zero address");
108 
109         // mint the amount
110         uint96 amount = safe96(rawAmount, "Tribe: amount exceeds 96 bits");
111         uint96 safeSupply = safe96(totalSupply, "Tribe: totalSupply exceeds 96 bits");
112         totalSupply = add96(safeSupply, amount, "Tribe: totalSupply exceeds 96 bits");
113 
114         // transfer the amount to the recipient
115         balances[dst] = add96(balances[dst], amount, "Tribe: transfer amount overflows");
116         emit Transfer(address(0), dst, amount);
117 
118         // move delegates
119         _moveDelegates(address(0), delegates[dst], amount);
120     }
121 
122     /**
123      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
124      * @param account The address of the account holding the funds
125      * @param spender The address of the account spending the funds
126      * @return The number of tokens approved
127      */
128     function allowance(address account, address spender) external view returns (uint256) {
129         return allowances[account][spender];
130     }
131 
132     /**
133      * @notice Approve `spender` to transfer up to `amount` from `src`
134      * @dev This will overwrite the approval amount for `spender`
135      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
136      * @param spender The address of the account which may transfer tokens
137      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
138      * @return Whether or not the approval succeeded
139      */
140     function approve(address spender, uint256 rawAmount) external returns (bool) {
141         uint96 amount;
142         if (rawAmount == type(uint256).max) {
143             amount = type(uint96).max;
144         } else {
145             amount = safe96(rawAmount, "Tribe: amount exceeds 96 bits");
146         }
147 
148         allowances[msg.sender][spender] = amount;
149 
150         emit Approval(msg.sender, spender, amount);
151         return true;
152     }
153 
154     /**
155      * @notice Triggers an approval from owner to spends
156      * @param owner The address to approve from
157      * @param spender The address to be approved
158      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
159      * @param deadline The time at which to expire the signature
160      * @param v The recovery byte of the signature
161      * @param r Half of the ECDSA signature pair
162      * @param s Half of the ECDSA signature pair
163      */
164     function permit(
165         address owner,
166         address spender,
167         uint256 rawAmount,
168         uint256 deadline,
169         uint8 v,
170         bytes32 r,
171         bytes32 s
172     ) external {
173         uint96 amount;
174         if (rawAmount == type(uint256).max) {
175             amount = type(uint96).max;
176         } else {
177             amount = safe96(rawAmount, "Tribe: amount exceeds 96 bits");
178         }
179 
180         bytes32 domainSeparator = keccak256(
181             abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this))
182         );
183         bytes32 structHash = keccak256(
184             abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline)
185         );
186         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
187         address signatory = ecrecover(digest, v, r, s);
188         require(signatory != address(0), "Tribe: invalid signature");
189         require(signatory == owner, "Tribe: unauthorized");
190         require(block.timestamp <= deadline, "Tribe: signature expired");
191 
192         allowances[owner][spender] = amount;
193 
194         emit Approval(owner, spender, amount);
195     }
196 
197     /**
198      * @notice Get the number of tokens held by the `account`
199      * @param account The address of the account to get the balance of
200      * @return The number of tokens held
201      */
202     function balanceOf(address account) external view returns (uint256) {
203         return balances[account];
204     }
205 
206     /**
207      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
208      * @param dst The address of the destination account
209      * @param rawAmount The number of tokens to transfer
210      * @return Whether or not the transfer succeeded
211      */
212     function transfer(address dst, uint256 rawAmount) external returns (bool) {
213         uint96 amount = safe96(rawAmount, "Tribe: amount exceeds 96 bits");
214         _transferTokens(msg.sender, dst, amount);
215         return true;
216     }
217 
218     /**
219      * @notice Transfer `amount` tokens from `src` to `dst`
220      * @param src The address of the source account
221      * @param dst The address of the destination account
222      * @param rawAmount The number of tokens to transfer
223      * @return Whether or not the transfer succeeded
224      */
225     function transferFrom(
226         address src,
227         address dst,
228         uint256 rawAmount
229     ) external returns (bool) {
230         address spender = msg.sender;
231         uint96 spenderAllowance = allowances[src][spender];
232         uint96 amount = safe96(rawAmount, "Tribe: amount exceeds 96 bits");
233 
234         if (spender != src && spenderAllowance != type(uint96).max) {
235             uint96 newAllowance = sub96(spenderAllowance, amount, "Tribe: transfer amount exceeds spender allowance");
236             allowances[src][spender] = newAllowance;
237 
238             emit Approval(src, spender, newAllowance);
239         }
240 
241         _transferTokens(src, dst, amount);
242         return true;
243     }
244 
245     /**
246      * @notice Delegate votes from `msg.sender` to `delegatee`
247      * @param delegatee The address to delegate votes to
248      */
249     function delegate(address delegatee) public {
250         return _delegate(msg.sender, delegatee);
251     }
252 
253     /**
254      * @notice Delegates votes from signatory to `delegatee`
255      * @param delegatee The address to delegate votes to
256      * @param nonce The contract state required to match the signature
257      * @param expiry The time at which to expire the signature
258      * @param v The recovery byte of the signature
259      * @param r Half of the ECDSA signature pair
260      * @param s Half of the ECDSA signature pair
261      */
262     function delegateBySig(
263         address delegatee,
264         uint256 nonce,
265         uint256 expiry,
266         uint8 v,
267         bytes32 r,
268         bytes32 s
269     ) public {
270         bytes32 domainSeparator = keccak256(
271             abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this))
272         );
273         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
274         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
275         address signatory = ecrecover(digest, v, r, s);
276         require(signatory != address(0), "Tribe: invalid signature");
277         require(nonce == nonces[signatory]++, "Tribe: invalid nonce");
278         require(block.timestamp <= expiry, "Tribe: signature expired");
279         return _delegate(signatory, delegatee);
280     }
281 
282     /**
283      * @notice Gets the current votes balance for `account`
284      * @param account The address to get votes balance
285      * @return The number of current votes for `account`
286      */
287     function getCurrentVotes(address account) external view returns (uint96) {
288         uint32 nCheckpoints = numCheckpoints[account];
289         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
290     }
291 
292     /**
293      * @notice Determine the prior number of votes for an account as of a block number
294      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
295      * @param account The address of the account to check
296      * @param blockNumber The block number to get the vote balance at
297      * @return The number of votes the account had as of the given block
298      */
299     function getPriorVotes(address account, uint256 blockNumber) public view returns (uint96) {
300         require(blockNumber < block.number, "Tribe: not yet determined");
301 
302         uint32 nCheckpoints = numCheckpoints[account];
303         if (nCheckpoints == 0) {
304             return 0;
305         }
306 
307         // First check most recent balance
308         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
309             return checkpoints[account][nCheckpoints - 1].votes;
310         }
311 
312         // Next check implicit zero balance
313         if (checkpoints[account][0].fromBlock > blockNumber) {
314             return 0;
315         }
316 
317         uint32 lower = 0;
318         uint32 upper = nCheckpoints - 1;
319         while (upper > lower) {
320             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
321             Checkpoint memory cp = checkpoints[account][center];
322             if (cp.fromBlock == blockNumber) {
323                 return cp.votes;
324             } else if (cp.fromBlock < blockNumber) {
325                 lower = center;
326             } else {
327                 upper = center - 1;
328             }
329         }
330         return checkpoints[account][lower].votes;
331     }
332 
333     function _delegate(address delegator, address delegatee) internal {
334         address currentDelegate = delegates[delegator];
335         uint96 delegatorBalance = balances[delegator];
336         delegates[delegator] = delegatee;
337 
338         emit DelegateChanged(delegator, currentDelegate, delegatee);
339 
340         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
341     }
342 
343     function _transferTokens(
344         address src,
345         address dst,
346         uint96 amount
347     ) internal {
348         require(src != address(0), "Tribe: cannot transfer from the zero address");
349         require(dst != address(0), "Tribe: cannot transfer to the zero address");
350 
351         balances[src] = sub96(balances[src], amount, "Tribe: transfer amount exceeds balance");
352         balances[dst] = add96(balances[dst], amount, "Tribe: transfer amount overflows");
353         emit Transfer(src, dst, amount);
354 
355         _moveDelegates(delegates[src], delegates[dst], amount);
356     }
357 
358     function _moveDelegates(
359         address srcRep,
360         address dstRep,
361         uint96 amount
362     ) internal {
363         if (srcRep != dstRep && amount > 0) {
364             if (srcRep != address(0)) {
365                 uint32 srcRepNum = numCheckpoints[srcRep];
366                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
367                 uint96 srcRepNew = sub96(srcRepOld, amount, "Tribe: vote amount underflows");
368                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
369             }
370 
371             if (dstRep != address(0)) {
372                 uint32 dstRepNum = numCheckpoints[dstRep];
373                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
374                 uint96 dstRepNew = add96(dstRepOld, amount, "Tribe: vote amount overflows");
375                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
376             }
377         }
378     }
379 
380     function _writeCheckpoint(
381         address delegatee,
382         uint32 nCheckpoints,
383         uint96 oldVotes,
384         uint96 newVotes
385     ) internal {
386         uint32 blockNumber = safe32(block.number, "Tribe: block number exceeds 32 bits");
387 
388         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
389             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
390         } else {
391             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
392             numCheckpoints[delegatee] = nCheckpoints + 1;
393         }
394 
395         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
396     }
397 
398     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
399         require(n < 2**32, errorMessage);
400         return uint32(n);
401     }
402 
403     function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
404         require(n < 2**96, errorMessage);
405         return uint96(n);
406     }
407 
408     function add96(
409         uint96 a,
410         uint96 b,
411         string memory errorMessage
412     ) internal pure returns (uint96) {
413         uint96 c = a + b;
414         require(c >= a, errorMessage);
415         return c;
416     }
417 
418     function sub96(
419         uint96 a,
420         uint96 b,
421         string memory errorMessage
422     ) internal pure returns (uint96) {
423         require(b <= a, errorMessage);
424         return a - b;
425     }
426 
427     function getChainId() internal view returns (uint256) {
428         uint256 chainId;
429         // solhint-disable-next-line no-inline-assembly
430         assembly {
431             chainId := chainid()
432         }
433         return chainId;
434     }
435 }
