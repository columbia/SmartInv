1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 /** 
5                            
6 SharedStake Governance Token
7 
8 **/
9 
10 contract SGT {
11     /// @notice EIP-20 token name for this token
12     string public constant name = "SharedStake Governance Token";
13 
14     /// @notice EIP-20 token symbol for this token
15     string public constant symbol = "SGT";
16 
17     /// @notice EIP-20 token decimals for this token
18     uint8 public constant decimals = 18;
19 
20     /// @notice Total number of tokens in circulation
21     uint public constant totalSupply = 10000000e18; // 10,000,000 SGT
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
68     /**
69      * @notice Construct a new SGT token
70      * @param account The initial account to grant all the tokens
71      */
72     constructor(address account) public {
73         balances[account] = uint96(totalSupply);
74         emit Transfer(address(0), account, totalSupply);
75     }
76 
77     /**
78      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
79      * @param account The address of the account holding the funds
80      * @param spender The address of the account spending the funds
81      * @return The number of tokens approved
82      */
83     function allowance(address account, address spender) external view returns (uint) {
84         return allowances[account][spender];
85     }
86 
87     /**
88      * @notice Approve `spender` to transfer up to `amount` from `src`
89      * @dev This will overwrite the approval amount for `spender`
90      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
91      * @param spender The address of the account which may transfer tokens
92      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
93      * @return Whether or not the approval succeeded
94      */
95     function approve(address spender, uint rawAmount) external returns (bool) {
96         uint96 amount;
97         if (rawAmount == uint(-1)) {
98             amount = uint96(-1);
99         } else {
100             amount = safe96(rawAmount, "SGT::approve: amount exceeds 96 bits");
101         }
102 
103         allowances[msg.sender][spender] = amount;
104 
105         emit Approval(msg.sender, spender, amount);
106         return true;
107     }
108     	
109     /**
110      * @notice Triggers an approval from owner to spends
111      * @param owner The address to approve from
112      * @param spender The address to be approved
113      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
114      * @param deadline The time at which to expire the signature
115      * @param v The recovery byte of the signature
116      * @param r Half of the ECDSA signature pair
117      * @param s Half of the ECDSA signature pair
118      */
119     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
120         uint96 amount;
121         if (rawAmount == uint(-1)) {
122             amount = uint96(-1);
123         } else {
124             amount = safe96(rawAmount, "SGT::permit: amount exceeds 96 bits");
125         }
126         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
127         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
128         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
129         address signatory = ecrecover(digest, v, r, s);
130         require(signatory != address(0), "SGT::permit: invalid signature");
131         require(signatory == owner, "SGT::permit: unauthorized");
132         require(now <= deadline, "SGT::permit: signature expired");
133         allowances[owner][spender] = amount;
134         emit Approval(owner, spender, amount);
135     }
136 
137     /**
138      * @notice Get the number of tokens held by the `account`
139      * @param account The address of the account to get the balance of
140      * @return The number of tokens held
141      */
142     function balanceOf(address account) external view returns (uint) {
143         return balances[account];
144     }
145 
146     /**
147      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
148      * @param dst The address of the destination account
149      * @param rawAmount The number of tokens to transfer
150      * @return Whether or not the transfer succeeded
151      */
152     function transfer(address dst, uint rawAmount) external returns (bool) {
153         uint96 amount = safe96(rawAmount, "SGT::transfer: amount exceeds 96 bits");
154         _transferTokens(msg.sender, dst, amount);
155         return true;
156     }
157 
158     /**
159      * @notice Transfer `amount` tokens from `src` to `dst`
160      * @param src The address of the source account
161      * @param dst The address of the destination account
162      * @param rawAmount The number of tokens to transfer
163      * @return Whether or not the transfer succeeded
164      */
165     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
166         address spender = msg.sender;
167         uint96 spenderAllowance = allowances[src][spender];
168         uint96 amount = safe96(rawAmount, "SGT::approve: amount exceeds 96 bits");
169 
170         if (spender != src && spenderAllowance != uint96(-1)) {
171             uint96 newAllowance = sub96(spenderAllowance, amount, "SGT::transferFrom: transfer amount exceeds spender allowance");
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
198     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
199         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
200         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
201         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
202         address signatory = ecrecover(digest, v, r, s);
203         require(signatory != address(0), "SGT::delegateBySig: invalid signature");
204         require(nonce == nonces[signatory]++, "SGT::delegateBySig: invalid nonce");
205         require(now <= expiry, "SGT::delegateBySig: signature expired");
206         return _delegate(signatory, delegatee);
207     }
208 
209     /**
210      * @notice Gets the current votes balance for `account`
211      * @param account The address to get votes balance
212      * @return The number of current votes for `account`
213      */
214     function getCurrentVotes(address account) external view returns (uint96) {
215         uint32 nCheckpoints = numCheckpoints[account];
216         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
217     }
218 
219     /**
220      * @notice Determine the prior number of votes for an account as of a block number
221      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
222      * @param account The address of the account to check
223      * @param blockNumber The block number to get the vote balance at
224      * @return The number of votes the account had as of the given block
225      */
226     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
227         require(blockNumber < block.number, "SGT::getPriorVotes: not yet determined");
228 
229         uint32 nCheckpoints = numCheckpoints[account];
230         if (nCheckpoints == 0) {
231             return 0;
232         }
233 
234         // First check most recent balance
235         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
236             return checkpoints[account][nCheckpoints - 1].votes;
237         }
238 
239         // Next check implicit zero balance
240         if (checkpoints[account][0].fromBlock > blockNumber) {
241             return 0;
242         }
243 
244         uint32 lower = 0;
245         uint32 upper = nCheckpoints - 1;
246         while (upper > lower) {
247             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
248             Checkpoint memory cp = checkpoints[account][center];
249             if (cp.fromBlock == blockNumber) {
250                 return cp.votes;
251             } else if (cp.fromBlock < blockNumber) {
252                 lower = center;
253             } else {
254                 upper = center - 1;
255             }
256         }
257         return checkpoints[account][lower].votes;
258     }
259 
260     function _delegate(address delegator, address delegatee) internal {
261         address currentDelegate = delegates[delegator];
262         uint96 delegatorBalance = balances[delegator];
263         delegates[delegator] = delegatee;
264 
265         emit DelegateChanged(delegator, currentDelegate, delegatee);
266 
267         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
268     }
269 
270     function _transferTokens(address src, address dst, uint96 amount) internal {
271         require(src != address(0), "SGT::_transferTokens: cannot transfer from the zero address");
272         require(dst != address(0), "SGT::_transferTokens: cannot transfer to the zero address");
273 
274         balances[src] = sub96(balances[src], amount, "SGT::_transferTokens: transfer amount exceeds balance");
275         balances[dst] = add96(balances[dst], amount, "SGT::_transferTokens: transfer amount overflows");
276         emit Transfer(src, dst, amount);
277 
278         _moveDelegates(delegates[src], delegates[dst], amount);
279     }
280 
281     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
282         if (srcRep != dstRep && amount > 0) {
283             if (srcRep != address(0)) {
284                 uint32 srcRepNum = numCheckpoints[srcRep];
285                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
286                 uint96 srcRepNew = sub96(srcRepOld, amount, "SGT::_moveVotes: vote amount underflows");
287                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
288             }
289 
290             if (dstRep != address(0)) {
291                 uint32 dstRepNum = numCheckpoints[dstRep];
292                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
293                 uint96 dstRepNew = add96(dstRepOld, amount, "SGT::_moveVotes: vote amount overflows");
294                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
295             }
296         }
297     }
298 
299     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
300       uint32 blockNumber = safe32(block.number, "SGT::_writeCheckpoint: block number exceeds 32 bits");
301 
302       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
303           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
304       } else {
305           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
306           numCheckpoints[delegatee] = nCheckpoints + 1;
307       }
308 
309       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
310     }
311 
312     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
313         require(n < 2**32, errorMessage);
314         return uint32(n);
315     }
316 
317     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
318         require(n < 2**96, errorMessage);
319         return uint96(n);
320     }
321 
322     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
323         uint96 c = a + b;
324         require(c >= a, errorMessage);
325         return c;
326     }
327 
328     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
329         require(b <= a, errorMessage);
330         return a - b;
331     }
332 
333     function getChainId() internal pure returns (uint) {
334         uint256 chainId;
335         assembly { chainId := chainid() }
336         return chainId;
337     }
338 }