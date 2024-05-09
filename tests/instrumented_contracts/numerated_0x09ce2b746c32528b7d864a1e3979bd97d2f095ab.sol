1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 
5 // Copied from compound/EIP20Interface
6 /**
7  * @title ERC 20 Token Standard Interface
8  *  https://eips.ethereum.org/EIPS/eip-20
9  */
10 interface EIP20Interface {
11     function name() external view returns (string memory);
12     function symbol() external view returns (string memory);
13     function decimals() external view returns (uint8);
14 
15     /**
16       * @notice Get the total number of tokens in circulation
17       * @return The supply of tokens
18       */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @notice Gets the balance of the specified address
23      * @param owner The address from which the balance will be retrieved
24      * @return The balance
25      */
26     function balanceOf(address owner) external view returns (uint256 balance);
27 
28     /**
29       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
30       * @param dst The address of the destination account
31       * @param amount The number of tokens to transfer
32       * @return Whether or not the transfer succeeded
33       */
34     function transfer(address dst, uint256 amount) external returns (bool success);
35 
36     /**
37       * @notice Transfer `amount` tokens from `src` to `dst`
38       * @param src The address of the source account
39       * @param dst The address of the destination account
40       * @param amount The number of tokens to transfer
41       * @return Whether or not the transfer succeeded
42       */
43     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
44 
45     /**
46       * @notice Approve `spender` to transfer up to `amount` from `src`
47       * @dev This will overwrite the approval amount for `spender`
48       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
49       * @param spender The address of the account which may transfer tokens
50       * @param amount The number of tokens that are approved (-1 means infinite)
51       * @return Whether or not the approval succeeded
52       */
53     function approve(address spender, uint256 amount) external returns (bool success);
54 
55     /**
56       * @notice Get the current allowance from `owner` for `spender`
57       * @param owner The address of the account which owns the tokens to be spent
58       * @param spender The address of the account which may transfer tokens
59       * @return The number of tokens allowed to be spent (-1 means infinite)
60       */
61     function allowance(address owner, address spender) external view returns (uint256 remaining);
62 
63     event Transfer(address indexed from, address indexed to, uint256 amount);
64     event Approval(address indexed owner, address indexed spender, uint256 amount);
65 }
66 
67 /**
68  * @dev Contract module which provides a basic access control mechanism, where
69  * there is an account (an owner) that can be granted exclusive access to
70  * specific functions.
71  *
72  * By default, the owner account will be the one that deploys the contract. This
73  * can later be changed with {transferOwnership}.
74  *
75  * This module is used through inheritance. It will make available the modifier
76  * `onlyOwner`, which can be applied to your functions to restrict their use to
77  * the owner.
78  */
79 contract Ownable {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev Initializes the contract setting the deployer as the initial owner.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), msg.sender);
90     }
91 
92     /**
93      * @dev Returns the address of the current owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(_owner == msg.sender, "Ownable: caller is not the owner");
104         _;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Can only be called by the current owner.
122      */
123     function transferOwnership(address newOwner) public onlyOwner {
124         require(newOwner != address(0), "Ownable: new owner is the zero address");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 }
129 
130 // Modified from Compound/COMP
131 contract DFL is EIP20Interface, Ownable {
132     /// @notice EIP-20 token name for this token
133     string public constant name = "DeFIL-V2";
134 
135     /// @notice EIP-20 token symbol for this token
136     string public constant symbol = "DFL";
137 
138     /// @notice EIP-20 token decimals for this token
139     uint8 public constant decimals = 18;
140 
141     /// @notice Total number of tokens in circulation
142     uint96 internal _totalSupply;
143 
144     /// @notice Allowance amounts on behalf of others
145     mapping (address => mapping (address => uint96)) internal allowances;
146 
147     /// @notice Official record of token balances for each account
148     mapping (address => uint96) internal balances;
149 
150     /// @notice A record of each accounts delegate
151     mapping (address => address) public delegates;
152 
153     /// @notice A checkpoint for marking number of votes from a given block
154     struct Checkpoint {
155         uint32 fromBlock;
156         uint96 votes;
157     }
158 
159     /// @notice A record of votes checkpoints for each account, by index
160     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
161 
162     /// @notice The number of checkpoints for each account
163     mapping (address => uint32) public numCheckpoints;
164 
165     /// @notice The EIP-712 typehash for the contract's domain
166     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
167 
168     /// @notice The EIP-712 typehash for the delegation struct used by the contract
169     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
170 
171     /// @notice A record of states for signing / validating signatures
172     mapping (address => uint) public nonces;
173 
174     /// @notice An event thats emitted when an account changes its delegate
175     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
176 
177     /// @notice An event thats emitted when a delegate account's vote balance changes
178     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
179 
180     /// @notice The standard EIP-20 transfer event
181     event Transfer(address indexed from, address indexed to, uint256 amount);
182 
183     /// @notice The standard EIP-20 approval event
184     event Approval(address indexed owner, address indexed spender, uint256 amount);
185 
186     /**
187      * @notice Construct a new DFL token
188      */
189     constructor() public {
190         emit Transfer(address(0), address(this), 0);
191     }
192 
193     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
194      * the total supply.
195      * Emits a {Transfer} event with `from` set to the zero address.
196      * @param account The address of the account holding the new funds
197      * @param rawAmount The number of tokens that are minted
198      */
199     function mint(address account, uint rawAmount) public onlyOwner {
200         require(account != address(0), "DFL:: mint: cannot mint to the zero address");
201         uint96 amount = safe96(rawAmount, "DFL::mint: amount exceeds 96 bits");
202         _totalSupply = add96(_totalSupply, amount, "DFL::mint: total supply exceeds");
203         balances[account] = add96(balances[account], amount, "DFL::mint: mint amount exceeds balance");
204 
205         _moveDelegates(address(0), delegates[account], amount);
206         emit Transfer(address(0), account, amount);
207     }
208 
209     /** @dev Burns `amount` tokens, decreasing the total supply.
210      * @param rawAmount The number of tokens that are bruned
211      */
212     function burn(uint rawAmount) external {
213         uint96 amount = safe96(rawAmount, "DFL::burn: amount exceeds 96 bits");
214         _totalSupply = sub96(_totalSupply, amount, "DFL::burn: total supply exceeds");
215         balances[msg.sender] = sub96(balances[msg.sender], amount, "DFL::burn: burn amount exceeds balance");
216 
217         _moveDelegates(delegates[msg.sender], address(0), amount);
218         emit Transfer(msg.sender, address(0), amount);
219     }
220 
221     /**
222      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
223      * @param account The address of the account holding the funds
224      * @param spender The address of the account spending the funds
225      * @return The number of tokens approved
226      */
227     function allowance(address account, address spender) external view returns (uint) {
228         return allowances[account][spender];
229     }
230 
231     /**
232      * @notice Approve `spender` to transfer up to `amount` from `src`
233      * @dev This will overwrite the approval amount for `spender`
234      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
235      * @param spender The address of the account which may transfer tokens
236      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
237      * @return Whether or not the approval succeeded
238      */
239     function approve(address spender, uint rawAmount) external returns (bool) {
240         uint96 amount;
241         if (rawAmount == uint(-1)) {
242             amount = uint96(-1);
243         } else {
244             amount = safe96(rawAmount, "DFL::approve: amount exceeds 96 bits");
245         }
246 
247         allowances[msg.sender][spender] = amount;
248 
249         emit Approval(msg.sender, spender, amount);
250         return true;
251     }
252 
253     /**
254      * @notice Get the total supply of tokens
255      * @return The total supply of tokens
256      */
257     function totalSupply() external view returns (uint) {
258         return _totalSupply;
259     }
260 
261     /**
262      * @notice Get the number of tokens held by the `account`
263      * @param account The address of the account to get the balance of
264      * @return The number of tokens held
265      */
266     function balanceOf(address account) external view returns (uint) {
267         return balances[account];
268     }
269 
270     /**
271      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
272      * @param dst The address of the destination account
273      * @param rawAmount The number of tokens to transfer
274      * @return Whether or not the transfer succeeded
275      */
276     function transfer(address dst, uint rawAmount) external returns (bool) {
277         uint96 amount = safe96(rawAmount, "DFL::transfer: amount exceeds 96 bits");
278         _transferTokens(msg.sender, dst, amount);
279         return true;
280     }
281 
282     /**
283      * @notice Transfer `amount` tokens from `src` to `dst`
284      * @param src The address of the source account
285      * @param dst The address of the destination account
286      * @param rawAmount The number of tokens to transfer
287      * @return Whether or not the transfer succeeded
288      */
289     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
290         address spender = msg.sender;
291         uint96 spenderAllowance = allowances[src][spender];
292         uint96 amount = safe96(rawAmount, "DFL::approve: amount exceeds 96 bits");
293 
294         if (spender != src && spenderAllowance != uint96(-1)) {
295             uint96 newAllowance = sub96(spenderAllowance, amount, "DFL::transferFrom: transfer amount exceeds spender allowance");
296             allowances[src][spender] = newAllowance;
297 
298             emit Approval(src, spender, newAllowance);
299         }
300 
301         _transferTokens(src, dst, amount);
302         return true;
303     }
304 
305     /**
306      * @notice Delegate votes from `msg.sender` to `delegatee`
307      * @param delegatee The address to delegate votes to
308      */
309     function delegate(address delegatee) public {
310         return _delegate(msg.sender, delegatee);
311     }
312 
313     /**
314      * @notice Delegates votes from signatory to `delegatee`
315      * @param delegatee The address to delegate votes to
316      * @param nonce The contract state required to match the signature
317      * @param expiry The time at which to expire the signature
318      * @param v The recovery byte of the signature
319      * @param r Half of the ECDSA signature pair
320      * @param s Half of the ECDSA signature pair
321      */
322     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
323         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
324         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
325         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
326         address signatory = ecrecover(digest, v, r, s);
327         require(signatory != address(0), "DFL::delegateBySig: invalid signature");
328         require(nonce == nonces[signatory]++, "DFL::delegateBySig: invalid nonce");
329         require(block.timestamp <= expiry, "DFL::delegateBySig: signature expired");
330         return _delegate(signatory, delegatee);
331     }
332 
333     /**
334      * @notice Gets the current votes balance for `account`
335      * @param account The address to get votes balance
336      * @return The number of current votes for `account`
337      */
338     function getCurrentVotes(address account) external view returns (uint96) {
339         uint32 nCheckpoints = numCheckpoints[account];
340         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
341     }
342 
343     /**
344      * @notice Determine the prior number of votes for an account as of a block number
345      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
346      * @param account The address of the account to check
347      * @param blockNumber The block number to get the vote balance at
348      * @return The number of votes the account had as of the given block
349      */
350     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
351         require(blockNumber < block.number, "DFL::getPriorVotes: not yet determined");
352 
353         uint32 nCheckpoints = numCheckpoints[account];
354         if (nCheckpoints == 0) {
355             return 0;
356         }
357 
358         // First check most recent balance
359         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
360             return checkpoints[account][nCheckpoints - 1].votes;
361         }
362 
363         // Next check implicit zero balance
364         if (checkpoints[account][0].fromBlock > blockNumber) {
365             return 0;
366         }
367 
368         uint32 lower = 0;
369         uint32 upper = nCheckpoints - 1;
370         while (upper > lower) {
371             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
372             Checkpoint memory cp = checkpoints[account][center];
373             if (cp.fromBlock == blockNumber) {
374                 return cp.votes;
375             } else if (cp.fromBlock < blockNumber) {
376                 lower = center;
377             } else {
378                 upper = center - 1;
379             }
380         }
381         return checkpoints[account][lower].votes;
382     }
383 
384     function _delegate(address delegator, address delegatee) internal {
385         address currentDelegate = delegates[delegator];
386         uint96 delegatorBalance = balances[delegator];
387         delegates[delegator] = delegatee;
388 
389         emit DelegateChanged(delegator, currentDelegate, delegatee);
390 
391         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
392     }
393 
394     function _transferTokens(address src, address dst, uint96 amount) internal {
395         require(src != address(0), "DFL::_transferTokens: cannot transfer from the zero address");
396         require(dst != address(0), "DFL::_transferTokens: cannot transfer to the zero address");
397 
398         balances[src] = sub96(balances[src], amount, "DFL::_transferTokens: transfer amount exceeds balance");
399         balances[dst] = add96(balances[dst], amount, "DFL::_transferTokens: transfer amount overflows");
400         emit Transfer(src, dst, amount);
401 
402         _moveDelegates(delegates[src], delegates[dst], amount);
403     }
404 
405     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
406         if (srcRep != dstRep && amount > 0) {
407             if (srcRep != address(0)) {
408                 uint32 srcRepNum = numCheckpoints[srcRep];
409                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
410                 uint96 srcRepNew = sub96(srcRepOld, amount, "DFL::_moveVotes: vote amount underflows");
411                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
412             }
413 
414             if (dstRep != address(0)) {
415                 uint32 dstRepNum = numCheckpoints[dstRep];
416                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
417                 uint96 dstRepNew = add96(dstRepOld, amount, "DFL::_moveVotes: vote amount overflows");
418                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
419             }
420         }
421     }
422 
423     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
424       uint32 blockNumber = safe32(block.number, "DFL::_writeCheckpoint: block number exceeds 32 bits");
425 
426       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
427           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
428       } else {
429           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
430           numCheckpoints[delegatee] = nCheckpoints + 1;
431       }
432 
433       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
434     }
435 
436     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
437         require(n < 2**32, errorMessage);
438         return uint32(n);
439     }
440 
441     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
442         require(n < 2**96, errorMessage);
443         return uint96(n);
444     }
445 
446     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
447         uint96 c = a + b;
448         require(c >= a, errorMessage);
449         return c;
450     }
451 
452     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
453         require(b <= a, errorMessage);
454         return a - b;
455     }
456 
457     function getChainId() internal pure returns (uint) {
458         uint256 chainId;
459         assembly { chainId := chainid() }
460         return chainId;
461     }
462 }