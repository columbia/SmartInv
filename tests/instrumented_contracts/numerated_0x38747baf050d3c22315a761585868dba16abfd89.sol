1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 contract GovERC20 {
79     /// @notice EIP-20 token name for this token
80     string public constant name = "SeenHaus Governance";
81 
82     /// @notice EIP-20 token symbol for this token
83     string public constant symbol = "xSEEN";
84 
85     /// @notice EIP-20 token decimals for this token
86     uint8 public constant decimals = 18;
87 
88     uint public totalSupply;
89 
90     mapping (address => mapping (address => uint96)) internal allowances;
91 
92     mapping (address => uint96) internal balances;
93 
94     /// @notice A record of each accounts delegate
95     mapping (address => address) public delegates;
96 
97     /// @notice A checkpoint for marking number of votes from a given block
98     struct Checkpoint {
99         uint32 fromBlock;
100         uint96 votes;
101     }
102 
103     /// @notice A record of votes checkpoints for each account, by index
104     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
105 
106     /// @notice The number of checkpoints for each account
107     mapping (address => uint32) public numCheckpoints;
108 
109     /// @notice The EIP-712 typehash for the contract's domain
110     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
111 
112     /// @notice The EIP-712 typehash for the delegation struct used by the contract
113     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
114 
115     /// @notice A record of states for signing / validating signatures
116     mapping (address => uint) public nonces;
117 
118     /// @notice An event thats emitted when an account changes its delegate
119     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
120 
121     /// @notice An event thats emitted when a delegate account's vote balance changes
122     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
123 
124     /// @notice The standard EIP-20 transfer event
125     event Transfer(address indexed from, address indexed to, uint256 amount);
126 
127     /// @notice The standard EIP-20 approval event
128     event Approval(address indexed owner, address indexed spender, uint256 amount);
129 
130     /**
131      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
132      * @param account The address of the account holding the funds
133      * @param spender The address of the account spending the funds
134      * @return The number of tokens approved
135      */
136     function allowance(address account, address spender) external view returns (uint) {
137         return allowances[account][spender];
138     }
139 
140     /**
141      * @notice Approve `spender` to transfer up to `amount` from `src`
142      * @dev This will overwrite the approval amount for `spender`
143      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
144      * @param spender The address of the account which may transfer tokens
145      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
146      * @return Whether or not the approval succeeded
147      */
148     function approve(address spender, uint rawAmount) external returns (bool) {
149         uint96 amount;
150         if (rawAmount == type(uint256).max) {
151             amount = type(uint96).max;
152         } else {
153             amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
154         }
155 
156         allowances[msg.sender][spender] = amount;
157 
158         emit Approval(msg.sender, spender, amount);
159         return true;
160     }
161 
162     /**
163      * @notice Get the number of tokens held by the `account`
164      * @param account The address of the account to get the balance of
165      * @return The number of tokens held
166      */
167     function balanceOf(address account) external view returns (uint) {
168         return balances[account];
169     }
170 
171     /**
172      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
173      * @param dst The address of the destination account
174      * @param rawAmount The number of tokens to transfer
175      * @return Whether or not the transfer succeeded
176      */
177     function transfer(address dst, uint rawAmount) external returns (bool) {
178         uint96 amount = safe96(rawAmount, "Comp::transfer: amount exceeds 96 bits");
179         _transferTokens(msg.sender, dst, amount);
180         return true;
181     }
182 
183     /**
184      * @notice Transfer `amount` tokens from `src` to `dst`
185      * @param src The address of the source account
186      * @param dst The address of the destination account
187      * @param rawAmount The number of tokens to transfer
188      * @return Whether or not the transfer succeeded
189      */
190     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
191         address spender = msg.sender;
192         uint96 spenderAllowance = allowances[src][spender];
193         uint96 amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
194 
195         if (spender != src && spenderAllowance != type(uint96).max) {
196             uint96 newAllowance = sub96(spenderAllowance, amount, "Comp::transferFrom: transfer amount exceeds spender allowance");
197             allowances[src][spender] = newAllowance;
198 
199             emit Approval(src, spender, newAllowance);
200         }
201 
202         _transferTokens(src, dst, amount);
203         return true;
204     }
205 
206     function _mint(address account, uint amount) internal virtual {
207         require(account != address(0), "ERC20: mint to the zero address");
208 
209         _beforeTokenTransfer(address(0));
210 
211         totalSupply += amount;
212         balances[account] += uint96(amount);
213         emit Transfer(address(0), account, amount);
214     }
215 
216     function _burn(address account, uint amount) internal virtual {
217         require(account != address(0), "ERC20: burn from the zero address");
218 
219         _beforeTokenTransfer(account);
220 
221         require(balances[account] >= uint96(amount), "ERC20: burn amount exceeds balance");
222         balances[account] -= uint96(amount);
223         totalSupply -= amount;
224 
225         emit Transfer(account, address(0), amount);
226     }
227 
228     /**
229      * @notice Delegate votes from `msg.sender` to `delegatee`
230      * @param delegatee The address to delegate votes to
231      */
232     function delegate(address delegatee) public {
233         return _delegate(msg.sender, delegatee);
234     }
235 
236     /**
237      * @notice Delegates votes from signatory to `delegatee`
238      * @param delegatee The address to delegate votes to
239      * @param nonce The contract state required to match the signature
240      * @param expiry The time at which to expire the signature
241      * @param v The recovery byte of the signature
242      * @param r Half of the ECDSA signature pair
243      * @param s Half of the ECDSA signature pair
244      */
245     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
246         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
247         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
248         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
249         address signatory = ecrecover(digest, v, r, s);
250         require(signatory != address(0), "Comp::delegateBySig: invalid signature");
251         require(nonce == nonces[signatory]++, "Comp::delegateBySig: invalid nonce");
252         require(block.timestamp <= expiry, "Comp::delegateBySig: signature expired");
253         return _delegate(signatory, delegatee);
254     }
255 
256     /**
257      * @notice Gets the current votes balance for `account`
258      * @param account The address to get votes balance
259      * @return The number of current votes for `account`
260      */
261     function getCurrentVotes(address account) external view returns (uint96) {
262         uint32 nCheckpoints = numCheckpoints[account];
263         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
264     }
265 
266     /**
267      * @notice Determine the prior number of votes for an account as of a block number
268      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
269      * @param account The address of the account to check
270      * @param blockNumber The block number to get the vote balance at
271      * @return The number of votes the account had as of the given block
272      */
273     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
274         require(blockNumber < block.number, "Comp::getPriorVotes: not yet determined");
275 
276         uint32 nCheckpoints = numCheckpoints[account];
277         if (nCheckpoints == 0) {
278             return 0;
279         }
280 
281         // First check most recent balance
282         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
283             return checkpoints[account][nCheckpoints - 1].votes;
284         }
285 
286         // Next check implicit zero balance
287         if (checkpoints[account][0].fromBlock > blockNumber) {
288             return 0;
289         }
290 
291         uint32 lower = 0;
292         uint32 upper = nCheckpoints - 1;
293         while (upper > lower) {
294             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
295             Checkpoint memory cp = checkpoints[account][center];
296             if (cp.fromBlock == blockNumber) {
297                 return cp.votes;
298             } else if (cp.fromBlock < blockNumber) {
299                 lower = center;
300             } else {
301                 upper = center - 1;
302             }
303         }
304         return checkpoints[account][lower].votes;
305     }
306 
307     function _delegate(address delegator, address delegatee) internal {
308         address currentDelegate = delegates[delegator];
309         uint96 delegatorBalance = balances[delegator];
310         delegates[delegator] = delegatee;
311 
312         emit DelegateChanged(delegator, currentDelegate, delegatee);
313 
314         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
315     }
316 
317     function _transferTokens(address src, address dst, uint96 amount) internal {
318         require(src != address(0), "Comp::_transferTokens: cannot transfer from the zero address");
319         require(dst != address(0), "Comp::_transferTokens: cannot transfer to the zero address");
320 
321         _beforeTokenTransfer(src);
322 
323         balances[src] = sub96(balances[src], amount, "Comp::_transferTokens: transfer amount exceeds balance");
324         balances[dst] = add96(balances[dst], amount, "Comp::_transferTokens: transfer amount overflows");
325         emit Transfer(src, dst, amount);
326 
327         _moveDelegates(delegates[src], delegates[dst], amount);
328     }
329 
330     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
331         if (srcRep != dstRep && amount > 0) {
332             if (srcRep != address(0)) {
333                 uint32 srcRepNum = numCheckpoints[srcRep];
334                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
335                 uint96 srcRepNew = sub96(srcRepOld, amount, "Comp::_moveVotes: vote amount underflows");
336                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
337             }
338 
339             if (dstRep != address(0)) {
340                 uint32 dstRepNum = numCheckpoints[dstRep];
341                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
342                 uint96 dstRepNew = add96(dstRepOld, amount, "Comp::_moveVotes: vote amount overflows");
343                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
344             }
345         }
346     }
347 
348     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
349       uint32 blockNumber = safe32(block.number, "Comp::_writeCheckpoint: block number exceeds 32 bits");
350 
351       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
352           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
353       } else {
354           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
355           numCheckpoints[delegatee] = nCheckpoints + 1;
356       }
357 
358       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
359     }
360 
361     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
362         require(n < 2**32, errorMessage);
363         return uint32(n);
364     }
365 
366     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
367         require(n < 2**96, errorMessage);
368         return uint96(n);
369     }
370 
371     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
372         uint96 c = a + b;
373         require(c >= a, errorMessage);
374         return c;
375     }
376 
377     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
378         require(b <= a, errorMessage);
379         return a - b;
380     }
381 
382     function getChainId() internal view returns (uint) {
383         uint256 chainId;
384         assembly { chainId := chainid() }
385         return chainId;
386     }
387 
388     function _beforeTokenTransfer(address from) internal virtual { }
389 }
390 
391 interface IWETH {
392     function deposit() external payable;
393 }
394 
395 interface Sushiswap {
396     function swapExactTokensForTokens(
397         uint256 amountIn,
398         uint256 amountOutMin,
399         address[] calldata path,
400         address to,
401         uint256 deadline
402     ) external returns (uint256[] memory amounts);
403 }
404 
405 contract SeenHaus is GovERC20(){
406     address public constant weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
407     address public constant sushiswap = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
408     IERC20 public constant seen = IERC20(0xCa3FE04C7Ee111F0bbb02C328c699226aCf9Fd33);
409 
410     // accounts balances are locked for 3 days after entering 
411     mapping(address => uint256) locked;
412 
413     constructor() {
414         IERC20(weth).approve(sushiswap, type(uint256).max);
415     }
416 
417     function _beforeTokenTransfer(address from) internal view override {
418         require(locked[from] <= block.timestamp, "transfer:too soon after minting");
419     }
420 
421     // Enter the haus. Pay some SEENs. Earn some shares.
422     function enter(uint256 _amount) public {
423         uint256 totalSeen = seen.balanceOf(address(this));
424         uint256 totalShares = totalSupply;
425 
426         locked[msg.sender] = block.timestamp + 3 days;
427 
428         if (totalShares == 0 || totalSeen == 0) {
429             _mint(msg.sender, _amount);
430         } else {
431             uint256 what = _amount * totalShares / totalSeen;
432             _mint(msg.sender, what);
433         }
434         seen.transferFrom(msg.sender, address(this), _amount);
435     }
436 
437     // Leave the haus. Claim back your SEENs.
438     function leave(uint256 _share) public {
439         uint256 totalShares = totalSupply;
440         uint256 what = _share * seen.balanceOf(address(this)) / totalShares;
441         _burn(msg.sender, _share);
442         seen.transfer(msg.sender, what);
443     }
444 
445     function swap() public {
446         IWETH(weth).deposit{value: address(this).balance}();
447         uint256 amountIn = IERC20(weth).balanceOf(address(this));
448 
449         address[] memory path = new address[](2);
450         path[0] = weth;
451         path[1] = address(seen);
452 
453         Sushiswap(sushiswap).swapExactTokensForTokens(
454             amountIn,
455             0,
456             path,
457             address(this),
458             block.timestamp
459         );
460     }
461 
462     receive() external payable {}
463 
464 }