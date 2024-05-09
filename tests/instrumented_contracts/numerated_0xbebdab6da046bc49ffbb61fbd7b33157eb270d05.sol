1 pragma solidity ^0.6.7;
2 
3 contract Shard {
4     /// @notice EIP-20 token name for this token
5     string public constant name = "Shard";
6 
7     /// @notice EIP-20 token symbol for this token
8     string public constant symbol = "SHARD";
9 
10     /// @notice EIP-20 token decimals for this token
11     uint8 public constant decimals = 18;
12 
13     /// @notice Total number of tokens in circulation
14     uint public totalSupply = 80_000_000e18; // 80 million Shard
15 
16     /// @notice Limit on the totalSupply that can be minted
17     uint96 public constant maxSupply = 210_000_000e18; // 210 million Shard
18 
19     /// @notice Address which may mint new tokens
20     address public minter;
21 
22     /// @notice The timestamp after which minting may occur
23     uint public mintingAllowedAfter;
24 
25     /// @notice Minimum time between mints
26     uint32 public constant minimumTimeBetweenMints = 183 days;
27 
28     /// @dev Allowance amounts on behalf of others
29     mapping (address => mapping (address => uint96)) internal allowances;
30 
31     /// @dev Official record of token balances for each account
32     mapping (address => uint96) internal balances;
33 
34     /// @notice A record of each accounts delegate
35     mapping (address => address) public delegates;
36 
37     /// @notice A checkpoint for marking number of votes from a given block
38     struct Checkpoint {
39         uint32 fromBlock;
40         uint96 votes;
41     }
42 
43     /// @notice A record of votes checkpoints for each account, by index
44     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
45 
46     /// @notice The number of checkpoints for each account
47     mapping (address => uint32) public numCheckpoints;
48 
49     /// @notice The EIP-712 typehash for the contract's domain
50     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
51 
52     /// @notice The EIP-712 typehash for the delegation struct used by the contract
53     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
54 
55     /// @notice The EIP-712 typehash for the permit struct used by the contract
56     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
57 
58     /// @notice The EIP-712 typehash for the transfer struct used by the contract
59     bytes32 public constant TRANSFER_TYPEHASH = keccak256("Transfer(address to,uint256 value,uint256 nonce,uint256 expiry)");
60 
61     /// @notice The EIP-712 typehash for the transferWithFee struct used by the contract
62     bytes32 public constant TRANSFER_WITH_FEE_TYPEHASH = keccak256("TransferWithFee(address to,uint256 value,uint256 fee,uint256 nonce,uint256 expiry)");
63 
64     /// @notice A record of states for signing / validating signatures
65     mapping (address => uint) public nonces;
66 
67     /// @notice An event thats emitted when the minter address is changed
68     event MinterChanged(address minter, address newMinter);
69 
70     /// @notice An event thats emitted when an account changes its delegate
71     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
72 
73     /// @notice An event thats emitted when a delegate account's vote balance changes
74     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
75 
76     /// @notice The standard EIP-20 transfer event
77     event Transfer(address indexed from, address indexed to, uint256 amount);
78 
79     /// @notice The standard EIP-20 approval event
80     event Approval(address indexed owner, address indexed spender, uint256 amount);
81 
82     /**
83      * @notice Construct a new Shard token
84      * @param account The initial account to grant all the tokens
85      * @param minter_ The account with minting ability
86      * @param mintingAllowedAfter_ The timestamp after which minting may occur
87      */
88     constructor(address account, address minter_, uint mintingAllowedAfter_) public {
89         require(mintingAllowedAfter_ >= block.timestamp, "Shard::constructor: minting can only begin after deployment");
90 
91         balances[account] = uint96(totalSupply);
92         emit Transfer(address(0), account, totalSupply);
93         minter = minter_;
94         emit MinterChanged(address(0), minter_);
95         mintingAllowedAfter = mintingAllowedAfter_;
96     }
97 
98     /**
99      * @notice Change the minter address
100      * @param minter_ The address of the new minter
101      */
102     function setMinter(address minter_) external {
103         require(msg.sender == minter, "Shard::setMinter: only the minter can change the minter address");
104         require(minter_ != address(0), "Shard::setMinter: cannot set minter to the zero address");
105         emit MinterChanged(minter, minter_);
106         minter = minter_;
107     }
108 
109     /**
110      * @notice Mint new tokens
111      * @param dst The address of the destination account
112      * @param rawAmount The number of tokens to be minted
113      */
114     function mint(address dst, uint rawAmount) external {
115         require(msg.sender == minter, "Shard::mint: only the minter can mint");
116         require(block.timestamp >= mintingAllowedAfter, "Shard::mint: minting not allowed yet");
117         require(dst != address(0), "Shard::mint: cannot transfer to the zero address");
118 
119         // record the mint
120         mintingAllowedAfter = add256(block.timestamp, minimumTimeBetweenMints, "Shard::mint: mintingAllowedAfter overflows");
121 
122         // mint the amount
123         uint96 amount = safe96(rawAmount, "Shard::mint: amount exceeds 96 bits");
124         uint _totalSupply = totalSupply;
125         require(amount <= _totalSupply / 100, "Shard::mint: amount exceeds mint allowance");
126         _totalSupply = add256(_totalSupply, amount, "Shard::mint: totalSupply overflows");
127         require(_totalSupply <= maxSupply, "Shard::mint: totalSupply exceeds maxSupply");
128         totalSupply = _totalSupply;
129 
130         // transfer the amount to the recipient
131         balances[dst] = add96(balances[dst], amount, "Shard::mint: transfer amount overflows");
132         emit Transfer(address(0), dst, amount);
133 
134         // move delegates
135         _moveDelegates(address(0), delegates[dst], amount);
136     }
137 
138     /**
139      * @notice Burn `amount` tokens from `msg.sender`
140      * @param rawAmount The number of tokens to burn
141      * @return Whether or not the burn succeeded
142      */
143     function burn(uint rawAmount) external returns (bool) {
144         uint96 amount = safe96(rawAmount, "Shard::burn: amount exceeds 96 bits");
145         _burnTokens(msg.sender, amount);
146         return true;
147     }
148 
149     /**
150      * @notice Burn `amount` tokens from `src`
151      * @param src The address of the source account
152      * @param rawAmount The number of tokens to burn
153      * @return Whether or not the burn succeeded
154      */
155     function burnFrom(address src, uint rawAmount) external returns (bool) {
156         uint96 amount = safe96(rawAmount, "Shard::burnFrom: amount exceeds 96 bits");
157         address spender = msg.sender;
158         uint96 spenderAllowance = allowances[src][spender];
159 
160         if (spender != src && spenderAllowance != uint96(-1)) {
161             uint96 newAllowance = sub96(spenderAllowance, amount, "Shard::burnFrom: amount exceeds spender allowance");
162             _approve(src, spender, newAllowance);
163         }
164 
165         _burnTokens(src, amount);
166         return true;
167     }
168 
169     /**
170      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
171      * @param account The address of the account holding the funds
172      * @param spender The address of the account spending the funds
173      * @return The number of tokens approved
174      */
175     function allowance(address account, address spender) external view returns (uint) {
176         return allowances[account][spender];
177     }
178 
179     /**
180      * @notice Approve `spender` to transfer up to `amount` from `src`
181      * @dev This will overwrite the approval amount for `spender`
182      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
183      * @param spender The address of the account which may transfer tokens
184      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
185      * @return Whether or not the approval succeeded
186      */
187     function approve(address spender, uint rawAmount) external returns (bool) {
188         uint96 amount;
189         if (rawAmount == uint(-1)) {
190             amount = uint96(-1);
191         } else {
192             amount = safe96(rawAmount, "Shard::approve: amount exceeds 96 bits");
193         }
194 
195         _approve(msg.sender, spender, amount);
196         return true;
197     }
198 
199     /**
200      * @notice Approve `spender` to transfer `amount` extra from `src`
201      * @param spender The address of the account which may transfer tokens
202      * @param rawAmount The number of tokens to increase the approval by
203      * @return Whether or not the approval succeeded
204      */
205     function increaseAllowance(address spender, uint rawAmount) external returns (bool) {
206         uint96 amount = safe96(rawAmount, "Shard::increaseAllowance: amount exceeds 96 bits");
207         uint96 newAllowance = add96(allowances[msg.sender][spender], amount, "Shard::increaseAllowance: allowance overflows");
208         _approve(msg.sender, spender, newAllowance);
209         return true;
210     }
211 
212     /**
213      * @notice Approve `spender` to transfer `amount` less from `src`
214      * @param spender The address of the account which may transfer tokens
215      * @param rawAmount The number of tokens to decrease the approval by
216      * @return Whether or not the approval succeeded
217      */
218     function decreaseAllowance(address spender, uint rawAmount) external returns (bool) {
219         uint96 amount = safe96(rawAmount, "Shard::decreaseAllowance: amount exceeds 96 bits");
220         uint96 newAllowance = sub96(allowances[msg.sender][spender], amount, "Shard::decreaseAllowance: allowance underflows");
221         _approve(msg.sender, spender, newAllowance);
222         return true;
223     }
224 
225     /**
226      * @notice Triggers an approval from owner to spender
227      * @param owner The address to approve from
228      * @param spender The address to be approved
229      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
230      * @param deadline The time at which to expire the signature
231      * @param v The recovery byte of the signature
232      * @param r Half of the ECDSA signature pair
233      * @param s Half of the ECDSA signature pair
234      */
235     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
236         uint96 amount;
237         if (rawAmount == uint(-1)) {
238             amount = uint96(-1);
239         } else {
240             amount = safe96(rawAmount, "Shard::permit: amount exceeds 96 bits");
241         }
242 
243         require(block.timestamp <= deadline, "Shard::permit: signature expired");
244         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
245         address signatory = ecrecover(getDigest(structHash), v, r, s);
246         require(signatory != address(0), "Shard::permit: invalid signature");
247         require(signatory == owner, "Shard::permit: unauthorized");
248 
249         return _approve(owner, spender, amount);
250     }
251 
252     /**
253      * @notice Get the number of tokens held by the `account`
254      * @param account The address of the account to get the balance of
255      * @return The number of tokens held
256      */
257     function balanceOf(address account) external view returns (uint) {
258         return balances[account];
259     }
260 
261     /**
262      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
263      * @param dst The address of the destination account
264      * @param rawAmount The number of tokens to transfer
265      * @return Whether or not the transfer succeeded
266      */
267     function transfer(address dst, uint rawAmount) external returns (bool) {
268         uint96 amount = safe96(rawAmount, "Shard::transfer: amount exceeds 96 bits");
269         _transferTokens(msg.sender, dst, amount);
270         return true;
271     }
272 
273     /**
274      * @notice Transfer `amount` tokens from `src` to `dst`
275      * @param src The address of the source account
276      * @param dst The address of the destination account
277      * @param rawAmount The number of tokens to transfer
278      * @return Whether or not the transfer succeeded
279      */
280     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
281         uint96 amount = safe96(rawAmount, "Shard::transferFrom: amount exceeds 96 bits");
282         address spender = msg.sender;
283         uint96 spenderAllowance = allowances[src][spender];
284 
285         if (spender != src && spenderAllowance != uint96(-1)) {
286             uint96 newAllowance = sub96(spenderAllowance, amount, "Shard::transferFrom: amount exceeds spender allowance");
287             _approve(src, spender, newAllowance);
288         }
289 
290         _transferTokens(src, dst, amount);
291         return true;
292     }
293 
294     /**
295      * @notice Transfer various `amount` tokens from `msg.sender` to `dsts`
296      * @param dsts The addresses of the destination accounts
297      * @param rawAmounts The numbers of tokens to transfer
298      * @return Whether or not the transfers succeeded
299      */
300     function transferBatch(address[] calldata dsts, uint[] calldata rawAmounts) external returns (bool) {
301         uint length = dsts.length;
302         require(length == rawAmounts.length, "Shard::transferBatch: calldata arrays must have the same length");
303         for (uint i = 0; i < length; i++) {
304             uint96 amount = safe96(rawAmounts[i], "Shard::transferBatch: amount exceeds 96 bits");
305             _transferTokens(msg.sender, dsts[i], amount);
306         }
307         return true;
308     }
309 
310     /**
311      * @notice Transfer `amount` tokens from signatory to `dst`
312      * @param dst The address of the destination account
313      * @param rawAmount The number of tokens to transfer
314      * @param nonce The contract state required to match the signature
315      * @param expiry The time at which to expire the signature
316      * @param v The recovery byte of the signature
317      * @param r Half of the ECDSA signature pair
318      * @param s Half of the ECDSA signature pair
319      */
320     function transferBySig(address dst, uint rawAmount, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external {
321         uint96 amount = safe96(rawAmount, "Shard::transferBySig: amount exceeds 96 bits");
322 
323         require(block.timestamp <= expiry, "Shard::transferBySig: signature expired");
324         bytes32 structHash = keccak256(abi.encode(TRANSFER_TYPEHASH, dst, rawAmount, nonce, expiry));
325         address signatory = ecrecover(getDigest(structHash), v, r, s);
326         require(signatory != address(0), "Shard::transferBySig: invalid signature");
327         require(nonce == nonces[signatory]++, "Shard::transferBySig: invalid nonce");
328 
329         return _transferTokens(signatory, dst, amount);
330     }
331 
332     /**
333      * @notice Transfer `amount` tokens from signatory to `dst` with 'fee' tokens to 'feeTo'
334      * @param dst The address of the destination account
335      * @param rawAmount The number of tokens to transfer
336      * @param rawFee The number of tokens to transfer as fee
337      * @param nonce The contract state required to match the signature
338      * @param expiry The time at which to expire the signature
339      * @param feeTo The address of the fee recipient account chosen by the msg.sender
340      * @param v The recovery byte of the signature
341      * @param r Half of the ECDSA signature pair
342      * @param s Half of the ECDSA signature pair
343      */
344     function transferWithFeeBySig(address dst, uint rawAmount, uint rawFee, uint nonce, uint expiry, address feeTo, uint8 v, bytes32 r, bytes32 s) external {
345         uint96 amount = safe96(rawAmount, "Shard::transferWithFeeBySig: amount exceeds 96 bits");
346         uint96 fee = safe96(rawFee, "Shard::transferWithFeeBySig: fee exceeds 96 bits");
347 
348         require(block.timestamp <= expiry, "Shard::transferWithFeeBySig: signature expired");
349         bytes32 structHash = keccak256(abi.encode(TRANSFER_WITH_FEE_TYPEHASH, dst, rawAmount, rawFee, nonce, expiry));
350         address signatory = ecrecover(getDigest(structHash), v, r, s);
351         require(signatory != address(0), "Shard::transferWithFeeBySig: invalid signature");
352         require(nonce == nonces[signatory]++, "Shard::transferWithFeeBySig: invalid nonce");
353 
354         _transferTokens(signatory, feeTo, fee);
355         return _transferTokens(signatory, dst, amount);
356     }
357 
358     /**
359      * @notice Delegate votes from `msg.sender` to `delegatee`
360      * @param delegatee The address to delegate votes to
361      */
362     function delegate(address delegatee) public {
363         return _delegate(msg.sender, delegatee);
364     }
365 
366     /**
367      * @notice Delegates votes from signatory to `delegatee`
368      * @param delegatee The address to delegate votes to
369      * @param nonce The contract state required to match the signature
370      * @param expiry The time at which to expire the signature
371      * @param v The recovery byte of the signature
372      * @param r Half of the ECDSA signature pair
373      * @param s Half of the ECDSA signature pair
374      */
375     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
376         require(block.timestamp <= expiry, "Shard::delegateBySig: signature expired");
377         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
378         address signatory = ecrecover(getDigest(structHash), v, r, s);
379         require(signatory != address(0), "Shard::delegateBySig: invalid signature");
380         require(nonce == nonces[signatory]++, "Shard::delegateBySig: invalid nonce");
381         return _delegate(signatory, delegatee);
382     }
383 
384     /**
385      * @notice Gets the current votes balance for `account`
386      * @param account The address to get votes balance
387      * @return The number of current votes for `account`
388      */
389     function getCurrentVotes(address account) external view returns (uint96) {
390         uint32 nCheckpoints = numCheckpoints[account];
391         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
392     }
393 
394     /**
395      * @notice Determine the prior number of votes for an account as of a block number
396      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
397      * @param account The address of the account to check
398      * @param blockNumber The block number to get the vote balance at
399      * @return The number of votes the account had as of the given block
400      */
401     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
402         require(blockNumber < block.number, "Shard::getPriorVotes: not yet determined");
403 
404         uint32 nCheckpoints = numCheckpoints[account];
405         if (nCheckpoints == 0) {
406             return 0;
407         }
408 
409         // First check most recent balance
410         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
411             return checkpoints[account][nCheckpoints - 1].votes;
412         }
413 
414         // Next check implicit zero balance
415         if (checkpoints[account][0].fromBlock > blockNumber) {
416             return 0;
417         }
418 
419         uint32 lower = 0;
420         uint32 upper = nCheckpoints - 1;
421         while (upper > lower) {
422             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
423             Checkpoint memory cp = checkpoints[account][center];
424             if (cp.fromBlock == blockNumber) {
425                 return cp.votes;
426             } else if (cp.fromBlock < blockNumber) {
427                 lower = center;
428             } else {
429                 upper = center - 1;
430             }
431         }
432         return checkpoints[account][lower].votes;
433     }
434 
435     function _approve(address owner, address spender, uint96 amount) internal {
436         allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439 
440     function _burnTokens(address src, uint96 amount) internal {
441         require(src != address(0), "Shard::_burnTokens: cannot transfer from the zero address");
442 
443         balances[src] = sub96(balances[src], amount, "Shard::_burnTokens: transfer amount exceeds balance");
444         totalSupply -= amount; // no case where balance exceeds totalSupply
445         emit Transfer(src, address(0), amount);
446 
447         _moveDelegates(delegates[src], address(0), amount);
448     }
449 
450     function _delegate(address delegator, address delegatee) internal {
451         address currentDelegate = delegates[delegator];
452         uint96 delegatorBalance = balances[delegator];
453         delegates[delegator] = delegatee;
454 
455         emit DelegateChanged(delegator, currentDelegate, delegatee);
456 
457         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
458     }
459 
460     function _transferTokens(address src, address dst, uint96 amount) internal {
461         require(src != address(0), "Shard::_transferTokens: cannot transfer from the zero address");
462         require(dst != address(0), "Shard::_transferTokens: cannot transfer to the zero address");
463 
464         balances[src] = sub96(balances[src], amount, "Shard::_transferTokens: transfer amount exceeds balance");
465         balances[dst] = add96(balances[dst], amount, "Shard::_transferTokens: transfer amount overflows");
466         emit Transfer(src, dst, amount);
467 
468         _moveDelegates(delegates[src], delegates[dst], amount);
469     }
470 
471     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
472         if (srcRep != dstRep && amount > 0) {
473             if (srcRep != address(0)) {
474                 uint32 srcRepNum = numCheckpoints[srcRep];
475                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
476                 uint96 srcRepNew = sub96(srcRepOld, amount, "Shard::_moveVotes: vote amount underflows");
477                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
478             }
479 
480             if (dstRep != address(0)) {
481                 uint32 dstRepNum = numCheckpoints[dstRep];
482                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
483                 uint96 dstRepNew = add96(dstRepOld, amount, "Shard::_moveVotes: vote amount overflows");
484                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
485             }
486         }
487     }
488 
489     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
490       uint32 blockNumber = safe32(block.number, "Shard::_writeCheckpoint: block number exceeds 32 bits");
491 
492       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
493           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
494       } else {
495           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
496           numCheckpoints[delegatee] = nCheckpoints + 1;
497       }
498 
499       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
500     }
501 
502     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
503         require(n < 2**32, errorMessage);
504         return uint32(n);
505     }
506 
507     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
508         require(n < 2**96, errorMessage);
509         return uint96(n);
510     }
511 
512     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96 c) {
513         require((c = a + b) >= a, errorMessage);
514     }
515 
516     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
517         require(b <= a, errorMessage);
518         return a - b;
519     }
520 
521     function add256(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256 c) {
522         require((c = a + b) >= a, errorMessage);
523     }
524 
525     function getDigest(bytes32 structHash) internal view returns (bytes32) {
526         uint256 chainId;
527         assembly { chainId := chainid() }
528         bytes32 domainSeparator =  keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), chainId, address(this)));
529         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
530     }
531 }