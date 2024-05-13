1 pragma solidity ^0.5.16;
2 
3 pragma experimental ABIEncoderV2;
4 
5 import "./SafeMath.sol";
6 
7 contract INV {
8     /// @notice EIP-20 token name for this token
9     string public constant name = "Inverse DAO";
10 
11     /// @notice EIP-20 token symbol for this token
12     string public constant symbol = "INV";
13 
14     /// @notice EIP-20 token decimals for this token
15     uint8 public constant decimals = 18;
16 
17     /// @notice Total number of tokens in circulation
18     uint public totalSupply = 100000e18; // 100k
19 
20     /// @notice Address which may mint new tokens
21     address public owner;
22 
23     bool public tradable;
24     bool public seizable = true;
25 
26     mapping (address => bool) public whitelist; // addresses allowed to send when non-tradable
27 
28     /// @notice Allowance amounts on behalf of others
29     mapping (address => mapping (address => uint96)) internal allowances;
30 
31     /// @notice Official record of token balances for each account
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
58     /// @notice A record of states for signing / validating signatures
59     mapping (address => uint) public nonces;
60 
61     /// @notice An event thats emitted when the owner address is changed
62     event OwnerChanged(address owner, address newOwner);
63 
64     /// @notice An event thats emitted when an account changes its delegate
65     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
66 
67     /// @notice An event thats emitted when a delegate account's vote balance changes
68     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
69 
70     /// @notice The standard EIP-20 transfer event
71     event Transfer(address indexed from, address indexed to, uint256 amount);
72 
73     /// @notice The standard EIP-20 approval event
74     event Approval(address indexed owner, address indexed spender, uint256 amount);
75 
76     modifier onlyOwner {
77         require(msg.sender == owner, "INV: only the owner can call this method");
78         _;
79     }
80 
81     /**
82      * @notice Construct a new token
83      * @param account The initial account to grant all the tokens
84      */
85     constructor(address account) public {
86 
87         balances[account] = uint96(totalSupply);
88         emit Transfer(address(0), account, totalSupply);
89         owner = account;
90         emit OwnerChanged(address(0), account);
91         whitelist[account] = true;
92     }
93 
94     /**
95      * @notice Change the owner address
96      * @param owner_ The address of the new owner
97      */
98     function setOwner(address owner_) external onlyOwner {
99         emit OwnerChanged(owner, owner_);
100         owner = owner_;
101     }
102 
103     function seize(address src, uint rawAmount) external onlyOwner {
104         require(seizable);
105         uint96 amount = safe96(rawAmount, "INV::seize: amount exceeds 96 bits");
106         totalSupply = safe96(SafeMath.sub(totalSupply, amount), "INV::seize: totalSupply exceeds 96 bits");
107 
108         balances[src] = sub96(balances[src], amount, "INV::seize: transfer amount overflows");
109         emit Transfer(src, address(0), amount);
110 
111         // move delegates
112         _moveDelegates(delegates[src], address(0), amount);
113     }
114 
115     // makes token transferrable. Also abolishes seizing irreversibly.
116     function openTheGates() external onlyOwner {
117         seizable = false;
118         tradable = true;
119     }
120 
121     function closeTheGates() external onlyOwner {
122         tradable = false;
123     }
124 
125     // one way function
126     function abolishSeizing() external onlyOwner {
127         seizable = false;
128     }
129 
130     function addToWhitelist(address _user) external onlyOwner {
131         whitelist[_user] = true;
132     }
133 
134     function removeFromWhitelist(address _user) external onlyOwner {
135         whitelist[_user] = false;
136     }
137 
138     /**
139      * @notice Mint new tokens
140      * @param dst The address of the destination account
141      * @param rawAmount The number of tokens to be minted
142      */
143     function mint(address dst, uint rawAmount) external {
144         require(msg.sender == owner, "INV::mint: only the owner can mint");
145         require(dst != address(0), "INV::mint: cannot transfer to the zero address");
146 
147         // mint the amount
148         uint96 amount = safe96(rawAmount, "INV::mint: amount exceeds 96 bits");
149         totalSupply = safe96(SafeMath.add(totalSupply, amount), "INV::mint: totalSupply exceeds 96 bits");
150 
151         // transfer the amount to the recipient
152         balances[dst] = add96(balances[dst], amount, "INV::mint: transfer amount overflows");
153         emit Transfer(address(0), dst, amount);
154 
155         // move delegates
156         _moveDelegates(address(0), delegates[dst], amount);
157     }
158 
159     /**
160      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
161      * @param account The address of the account holding the funds
162      * @param spender The address of the account spending the funds
163      * @return The number of tokens approved
164      */
165     function allowance(address account, address spender) external view returns (uint) {
166         return allowances[account][spender];
167     }
168 
169     /**
170      * @notice Approve `spender` to transfer up to `amount` from `src`
171      * @dev This will overwrite the approval amount for `spender`
172      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
173      * @param spender The address of the account which may transfer tokens
174      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
175      * @return Whether or not the approval succeeded
176      */
177     function approve(address spender, uint rawAmount) external returns (bool) {
178         uint96 amount;
179         if (rawAmount == uint(-1)) {
180             amount = uint96(-1);
181         } else {
182             amount = safe96(rawAmount, "INV::approve: amount exceeds 96 bits");
183         }
184 
185         allowances[msg.sender][spender] = amount;
186 
187         emit Approval(msg.sender, spender, amount);
188         return true;
189     }
190 
191     /**
192      * @notice Triggers an approval from owner to spends
193      * @param _owner The address to approve from
194      * @param spender The address to be approved
195      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
196      * @param deadline The time at which to expire the signature
197      * @param v The recovery byte of the signature
198      * @param r Half of the ECDSA signature pair
199      * @param s Half of the ECDSA signature pair
200      */
201     function permit(address _owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
202         uint96 amount;
203         if (rawAmount == uint(-1)) {
204             amount = uint96(-1);
205         } else {
206             amount = safe96(rawAmount, "INV::permit: amount exceeds 96 bits");
207         }
208 
209         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
210         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, _owner, spender, rawAmount, nonces[_owner]++, deadline));
211         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
212         address signatory = ecrecover(digest, v, r, s);
213         require(signatory != address(0), "INV::permit: invalid signature");
214         require(signatory == _owner, "INV::permit: unauthorized");
215         require(now <= deadline, "INV::permit: signature expired");
216 
217         allowances[_owner][spender] = amount;
218 
219         emit Approval(_owner, spender, amount);
220     }
221 
222     /**
223      * @notice Get the number of tokens held by the `account`
224      * @param account The address of the account to get the balance of
225      * @return The number of tokens held
226      */
227     function balanceOf(address account) external view returns (uint) {
228         return balances[account];
229     }
230 
231     /**
232      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
233      * @param dst The address of the destination account
234      * @param rawAmount The number of tokens to transfer
235      * @return Whether or not the transfer succeeded
236      */
237     function transfer(address dst, uint rawAmount) external returns (bool) {
238         uint96 amount = safe96(rawAmount, "INV::transfer: amount exceeds 96 bits");
239         _transferTokens(msg.sender, dst, amount);
240         return true;
241     }
242 
243     /**
244      * @notice Transfer `amount` tokens from `src` to `dst`
245      * @param src The address of the source account
246      * @param dst The address of the destination account
247      * @param rawAmount The number of tokens to transfer
248      * @return Whether or not the transfer succeeded
249      */
250     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
251         address spender = msg.sender;
252         uint96 spenderAllowance = allowances[src][spender];
253         uint96 amount = safe96(rawAmount, "INV::approve: amount exceeds 96 bits");
254 
255         if (spender != src && spenderAllowance != uint96(-1)) {
256             uint96 newAllowance = sub96(spenderAllowance, amount, "INV::transferFrom: transfer amount exceeds spender allowance");
257             allowances[src][spender] = newAllowance;
258 
259             emit Approval(src, spender, newAllowance);
260         }
261 
262         _transferTokens(src, dst, amount);
263         return true;
264     }
265 
266     /**
267      * @notice Delegate votes from `msg.sender` to `delegatee`
268      * @param delegatee The address to delegate votes to
269      */
270     function delegate(address delegatee) public {
271         return _delegate(msg.sender, delegatee);
272     }
273 
274     /**
275      * @notice Delegates votes from signatory to `delegatee`
276      * @param delegatee The address to delegate votes to
277      * @param nonce The contract state required to match the signature
278      * @param expiry The time at which to expire the signature
279      * @param v The recovery byte of the signature
280      * @param r Half of the ECDSA signature pair
281      * @param s Half of the ECDSA signature pair
282      */
283     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
284         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
285         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
286         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
287         address signatory = ecrecover(digest, v, r, s);
288         require(signatory != address(0), "INV::delegateBySig: invalid signature");
289         require(nonce == nonces[signatory]++, "INV::delegateBySig: invalid nonce");
290         require(now <= expiry, "INV::delegateBySig: signature expired");
291         return _delegate(signatory, delegatee);
292     }
293 
294     /**
295      * @notice Gets the current votes balance for `account`
296      * @param account The address to get votes balance
297      * @return The number of current votes for `account`
298      */
299     function getCurrentVotes(address account) external view returns (uint96) {
300         uint32 nCheckpoints = numCheckpoints[account];
301         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
302     }
303 
304     /**
305      * @notice Determine the prior number of votes for an account as of a block number
306      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
307      * @param account The address of the account to check
308      * @param blockNumber The block number to get the vote balance at
309      * @return The number of votes the account had as of the given block
310      */
311     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
312         require(blockNumber < block.number, "INV::getPriorVotes: not yet determined");
313 
314         uint32 nCheckpoints = numCheckpoints[account];
315         if (nCheckpoints == 0) {
316             return 0;
317         }
318 
319         // First check most recent balance
320         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
321             return checkpoints[account][nCheckpoints - 1].votes;
322         }
323 
324         // Next check implicit zero balance
325         if (checkpoints[account][0].fromBlock > blockNumber) {
326             return 0;
327         }
328 
329         uint32 lower = 0;
330         uint32 upper = nCheckpoints - 1;
331         while (upper > lower) {
332             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
333             Checkpoint memory cp = checkpoints[account][center];
334             if (cp.fromBlock == blockNumber) {
335                 return cp.votes;
336             } else if (cp.fromBlock < blockNumber) {
337                 lower = center;
338             } else {
339                 upper = center - 1;
340             }
341         }
342         return checkpoints[account][lower].votes;
343     }
344 
345     function _delegate(address delegator, address delegatee) internal {
346         address currentDelegate = delegates[delegator];
347         uint96 delegatorBalance = balances[delegator];
348         delegates[delegator] = delegatee;
349 
350         emit DelegateChanged(delegator, currentDelegate, delegatee);
351 
352         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
353     }
354 
355     function _transferTokens(address src, address dst, uint96 amount) internal {
356         require(src != address(0), "INV::_transferTokens: cannot transfer from the zero address");
357         require(dst != address(0), "INV::_transferTokens: cannot transfer to the zero address");
358 
359         if(!tradable) {
360             require(whitelist[src], "INV::_transferTokens: src not whitelisted");
361         }
362 
363         balances[src] = sub96(balances[src], amount, "INV::_transferTokens: transfer amount exceeds balance");
364         balances[dst] = add96(balances[dst], amount, "INV::_transferTokens: transfer amount overflows");
365         emit Transfer(src, dst, amount);
366 
367         _moveDelegates(delegates[src], delegates[dst], amount);
368     }
369 
370     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
371         if (srcRep != dstRep && amount > 0) {
372             if (srcRep != address(0)) {
373                 uint32 srcRepNum = numCheckpoints[srcRep];
374                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
375                 uint96 srcRepNew = sub96(srcRepOld, amount, "INV::_moveVotes: vote amount underflows");
376                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
377             }
378 
379             if (dstRep != address(0)) {
380                 uint32 dstRepNum = numCheckpoints[dstRep];
381                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
382                 uint96 dstRepNew = add96(dstRepOld, amount, "INV::_moveVotes: vote amount overflows");
383                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
384             }
385         }
386     }
387 
388     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
389       uint32 blockNumber = safe32(block.number, "INV::_writeCheckpoint: block number exceeds 32 bits");
390 
391       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
392           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
393       } else {
394           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
395           numCheckpoints[delegatee] = nCheckpoints + 1;
396       }
397 
398       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
399     }
400 
401     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
402         require(n < 2**32, errorMessage);
403         return uint32(n);
404     }
405 
406     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
407         require(n < 2**96, errorMessage);
408         return uint96(n);
409     }
410 
411     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
412         uint96 c = a + b;
413         require(c >= a, errorMessage);
414         return c;
415     }
416 
417     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
418         require(b <= a, errorMessage);
419         return a - b;
420     }
421 
422     function getChainId() internal pure returns (uint) {
423         uint256 chainId;
424         assembly { chainId := chainid() }
425         return chainId;
426     }
427 }