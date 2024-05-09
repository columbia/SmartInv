1 pragma solidity 0.8.11;
2 
3 contract Ply {
4     address public governance;
5     address public pendingGovernance;
6     uint256 public createdAt;
7 
8     /// @notice EIP-20 token name for this token
9     string public constant name = "Aurigami Token";
10 
11     /// @notice EIP-20 token symbol for this token
12     string public constant symbol = "PLY";
13 
14     /// @notice EIP-20 token decimals for this token
15     uint8 public constant decimals = 18;
16 
17     /// @notice Initial number of tokens in circulation
18     uint private constant INITIAL_SUPPLY = 10_000_000_000e18; // 10 billion PLY
19 
20     /// @notice Total number of tokens in circulation
21     uint public totalSupply;
22 
23     /// @notice Allowance amounts on behalf of others
24     mapping (address => mapping (address => uint96)) internal allowances;
25 
26     /// @notice Official record of token balances for each account
27     mapping (address => uint96) internal balances;
28 
29     /// @notice A record of each accounts delegate
30     mapping (address => address) public delegates;
31 
32     /// @notice A checkpoint for marking number of votes from a given block
33     struct Checkpoint {
34         uint32 fromBlock;
35         uint96 votes;
36     }
37 
38     /// @notice A record of votes checkpoints for each account, by index
39     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
40 
41     /// @notice The number of checkpoints for each account
42     mapping (address => uint32) public numCheckpoints;
43 
44     /// @notice The EIP-712 typehash for the contract's domain
45     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
46 
47     /// @notice The EIP-712 typehash for the delegation struct used by the contract
48     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
49 
50     /// @notice The EIP-712 typehash for the permit struct used by the contract
51     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
52 
53     /// @notice A record of states for signing / validating signatures
54     mapping (address => uint) public nonces;
55 
56     /// @notice An event thats emitted when an account changes its delegate
57     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
58 
59     /// @notice An event thats emitted when a delegate account's vote balance changes
60     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
61 
62     /// @notice The standard EIP-20 transfer event
63     event Transfer(address indexed from, address indexed to, uint256 amount);
64 
65     /// @notice The standard EIP-20 approval event
66     event Approval(address indexed owner, address indexed spender, uint256 amount);
67 
68     /// @notice Event for transfering Governance to a new address
69     event TransferGovernance(address newGovernance);
70 
71     /// @notice Event for claiming Governance
72     event ClaimGovernance(address newGovernance);
73 
74     modifier onlyGovernance() {
75         require(governance == msg.sender, "Caller is not governance");
76         _;
77     }
78 
79     /**
80      * @notice Construct a new PLY token
81      * @param account The initial account to grant all the tokens and Governance of the contract
82      */
83     constructor(address account) {
84         governance = account;
85         balances[account] = uint96(INITIAL_SUPPLY);
86         totalSupply = INITIAL_SUPPLY;
87         createdAt = block.timestamp;
88         emit Transfer(address(0), account, INITIAL_SUPPLY);
89     }
90 
91     /**
92      * @notice Transfer Governance to a new owner address
93      */
94     function transferGovernance(address newGovernance) external onlyGovernance {
95         pendingGovernance = newGovernance;
96         emit TransferGovernance(newGovernance);
97     }
98 
99     /**
100      * @notice Claim Governance to the pending owner address
101      */
102     function claimGovernance() external {
103         require(msg.sender == pendingGovernance, "Wrong governance");
104         governance = pendingGovernance;
105         pendingGovernance = address(0);
106         emit ClaimGovernance(governance);
107     }
108 
109     /**
110      * @notice Mint Ply to an account, could only be done by governance address after at least 1 year
111      * @param account The account to receive the Ply tokens
112      * @param amount The amount to be minted
113      */
114     function mintPly(address account, uint96 amount) external onlyGovernance {
115         require(block.timestamp > createdAt + (1 days) * 365, "Must be after 1 year");
116         balances[account] = add96(balances[account], amount, "Ply::mintPly: new account balance overflows");
117         totalSupply = add96(uint96(totalSupply), amount, "Ply:mintPly: total supply overflows");
118         _moveDelegates(address(0), delegates[account], amount);
119 
120         emit Transfer(address(0), account, amount);
121     }
122 
123     /**
124      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
125      * @param account The address of the account holding the funds
126      * @param spender The address of the account spending the funds
127      * @return The number of tokens approved
128      */
129     function allowance(address account, address spender) external view returns (uint) {
130         return allowances[account][spender];
131     }
132 
133     /**
134      * @notice Approve `spender` to transfer up to `amount` from `src`
135      * @dev This will overwrite the approval amount for `spender`
136      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
137      * @param spender The address of the account which may transfer tokens
138      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
139      * @return Whether or not the approval succeeded
140      */
141     function approve(address spender, uint rawAmount) external returns (bool) {
142         uint96 amount;
143         if (rawAmount == type(uint256).max) {
144             amount = type(uint96).max;
145         } else {
146             amount = safe96(rawAmount, "Ply::approve: amount exceeds 96 bits");
147         }
148 
149         allowances[msg.sender][spender] = amount;
150 
151         emit Approval(msg.sender, spender, amount);
152         return true;
153     }
154 
155     /**
156      * @notice Triggers an approval from owner to spends
157      * @param owner The address to approve from
158      * @param spender The address to be approved
159      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
160      * @param deadline The time at which to expire the signature
161      * @param v The recovery byte of the signature
162      * @param r Half of the ECDSA signature pair
163      * @param s Half of the ECDSA signature pair
164      */
165     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
166         uint96 amount;
167         if (rawAmount == type(uint256).max) {
168             amount = type(uint96).max;
169         } else {
170             amount = safe96(rawAmount, "Ply::permit: amount exceeds 96 bits");
171         }
172 
173         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
174         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
175         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
176         address signatory = ecrecover(digest, v, r, s);
177         require(signatory != address(0), "Ply::permit: invalid signature");
178         require(signatory == owner, "Ply::permit: unauthorized");
179         require(block.timestamp <= deadline, "Ply::permit: signature expired");
180 
181         allowances[owner][spender] = amount;
182 
183         emit Approval(owner, spender, amount);
184     }
185 
186     /**
187      * @notice Get the number of tokens held by the `account`
188      * @param account The address of the account to get the balance of
189      * @return The number of tokens held
190      */
191     function balanceOf(address account) external view returns (uint) {
192         return balances[account];
193     }
194 
195     /**
196      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
197      * @param dst The address of the destination account
198      * @param rawAmount The number of tokens to transfer
199      * @return Whether or not the transfer succeeded
200      */
201     function transfer(address dst, uint rawAmount) external returns (bool) {
202         uint96 amount = safe96(rawAmount, "Ply::transfer: amount exceeds 96 bits");
203         _transferTokens(msg.sender, dst, amount);
204         return true;
205     }
206 
207     /**
208      * @notice Transfer `amount` tokens from `src` to `dst`
209      * @param src The address of the source account
210      * @param dst The address of the destination account
211      * @param rawAmount The number of tokens to transfer
212      * @return Whether or not the transfer succeeded
213      */
214     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
215         address spender = msg.sender;
216         uint96 spenderAllowance = allowances[src][spender];
217         uint96 amount = safe96(rawAmount, "Ply::approve: amount exceeds 96 bits");
218 
219         if (spender != src && spenderAllowance != type(uint96).max) {
220             uint96 newAllowance = sub96(spenderAllowance, amount, "Ply::transferFrom: transfer amount exceeds spender allowance");
221             allowances[src][spender] = newAllowance;
222 
223             emit Approval(src, spender, newAllowance);
224         }
225 
226         _transferTokens(src, dst, amount);
227         return true;
228     }
229 
230     /**
231      * @notice Delegate votes from `msg.sender` to `delegatee`
232      * @param delegatee The address to delegate votes to
233      */
234     function delegate(address delegatee) external {
235         return _delegate(msg.sender, delegatee);
236     }
237 
238     /**
239      * @notice Delegates votes from signatory to `delegatee`
240      * @param delegatee The address to delegate votes to
241      * @param nonce The contract state required to match the signature
242      * @param expiry The time at which to expire the signature
243      * @param v The recovery byte of the signature
244      * @param r Half of the ECDSA signature pair
245      * @param s Half of the ECDSA signature pair
246      */
247     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external {
248         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
249         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
250         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
251         address signatory = ecrecover(digest, v, r, s);
252         require(signatory != address(0), "Ply::delegateBySig: invalid signature");
253         require(nonce == nonces[signatory]++, "Ply::delegateBySig: invalid nonce");
254         require(block.timestamp <= expiry, "Ply::delegateBySig: signature expired");
255         return _delegate(signatory, delegatee);
256     }
257 
258     /**
259      * @notice Gets the current votes balance for `account`
260      * @param account The address to get votes balance
261      * @return The number of current votes for `account`
262      */
263     function getCurrentVotes(address account) external view returns (uint96) {
264         uint32 nCheckpoints = numCheckpoints[account];
265         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
266     }
267 
268     /**
269      * @notice Determine the prior number of votes for an account as of a block number
270      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
271      * @param account The address of the account to check
272      * @param blockNumber The block number to get the vote balance at
273      * @return The number of votes the account had as of the given block
274      */
275     function getPriorVotes(address account, uint blockNumber) external view returns (uint96) {
276         require(blockNumber < block.number, "Ply::getPriorVotes: not yet determined");
277 
278         uint32 nCheckpoints = numCheckpoints[account];
279         if (nCheckpoints == 0) {
280             return 0;
281         }
282 
283         // First check most recent balance
284         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
285             return checkpoints[account][nCheckpoints - 1].votes;
286         }
287 
288         // Next check implicit zero balance
289         if (checkpoints[account][0].fromBlock > blockNumber) {
290             return 0;
291         }
292 
293         uint32 lower = 0;
294         uint32 upper = nCheckpoints - 1;
295         while (upper > lower) {
296             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
297             Checkpoint memory cp = checkpoints[account][center];
298             if (cp.fromBlock == blockNumber) {
299                 return cp.votes;
300             } else if (cp.fromBlock < blockNumber) {
301                 lower = center;
302             } else {
303                 upper = center - 1;
304             }
305         }
306         return checkpoints[account][lower].votes;
307     }
308 
309     function _delegate(address delegator, address delegatee) internal {
310         address currentDelegate = delegates[delegator];
311         uint96 delegatorBalance = balances[delegator];
312         delegates[delegator] = delegatee;
313 
314         emit DelegateChanged(delegator, currentDelegate, delegatee);
315 
316         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
317     }
318 
319     function _transferTokens(address src, address dst, uint96 amount) internal {
320         require(src != address(0), "Ply::_transferTokens: cannot transfer from the zero address");
321         require(dst != address(0), "Ply::_transferTokens: cannot transfer to the zero address");
322         require(dst != address(this), "Ply::_transferTokens: cannot transfer to the token address");
323 
324         balances[src] = sub96(balances[src], amount, "Ply::_transferTokens: transfer amount exceeds balance");
325         balances[dst] = add96(balances[dst], amount, "Ply::_transferTokens: transfer amount overflows");
326         emit Transfer(src, dst, amount);
327 
328         _moveDelegates(delegates[src], delegates[dst], amount);
329     }
330 
331     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
332         if (srcRep != dstRep && amount > 0) {
333             if (srcRep != address(0)) {
334                 uint32 srcRepNum = numCheckpoints[srcRep];
335                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
336                 uint96 srcRepNew = sub96(srcRepOld, amount, "Ply::_moveVotes: vote amount underflows");
337                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
338             }
339 
340             if (dstRep != address(0)) {
341                 uint32 dstRepNum = numCheckpoints[dstRep];
342                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
343                 uint96 dstRepNew = add96(dstRepOld, amount, "Ply::_moveVotes: vote amount overflows");
344                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
345             }
346         }
347     }
348 
349     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
350       uint32 blockNumber = safe32(block.number, "Ply::_writeCheckpoint: block number exceeds 32 bits");
351 
352       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
353           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
354       } else {
355           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
356           numCheckpoints[delegatee] = nCheckpoints + 1;
357       }
358 
359       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
360     }
361 
362     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
363         require(n <= type(uint32).max, errorMessage);
364         return uint32(n);
365     }
366 
367     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
368         require(n <= type(uint96).max, errorMessage);
369         return uint96(n);
370     }
371 
372     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
373         uint96 c = a + b;
374         require(c >= a, errorMessage);
375         return c;
376     }
377 
378     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
379         require(b <= a, errorMessage);
380         return a - b;
381     }
382 
383     function getChainId() internal view returns (uint) {
384         uint256 chainId;
385         assembly { chainId := chainid() }
386         return chainId;
387     }
388 }