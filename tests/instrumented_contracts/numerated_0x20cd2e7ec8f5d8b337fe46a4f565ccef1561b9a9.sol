1 pragma solidity ^0.5.16;
2 
3 contract ESG {
4     /// @notice EIP-20 token name for this token
5     string public constant name = "ESG";
6 
7     /// @notice EIP-20 token symbol for this token
8     string public constant symbol = "ESG";
9 
10     /// @notice EIP-20 token decimals for this token
11     uint8 public constant decimals = 18;
12 
13     /// @notice Total number of tokens in circulation
14     uint public constant totalSupply = 49000000e18; // 49 million ESG in Ethereum
15 
16     /// @notice Allowance amounts on behalf of others
17     mapping (address => mapping (address => uint96)) internal allowances;
18 
19     /// @notice Official record of token balances for each account
20     mapping (address => uint96) internal balances;
21 
22     /// @notice A record of each accounts delegate
23     mapping (address => address) public delegates;
24 
25     /// @notice A checkpoint for marking number of votes from a given block
26     struct Checkpoint {
27         uint32 fromBlock;
28         uint96 votes;
29     }
30 
31     /// @notice A record of votes checkpoints for each account, by index
32     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
33 
34     /// @notice The number of checkpoints for each account
35     mapping (address => uint32) public numCheckpoints;
36 
37     /// @notice The EIP-712 typehash for the contract's domain
38     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
39 
40     /// @notice The EIP-712 typehash for the delegation struct used by the contract
41     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
42 
43     /// @notice A record of states for signing / validating signatures
44     mapping (address => uint) public nonces;
45 
46     /// @notice An event thats emitted when an account changes its delegate
47     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
48 
49     /// @notice An event thats emitted when a delegate account's vote balance changes
50     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
51 
52     /// @notice The standard EIP-20 transfer event
53     event Transfer(address indexed from, address indexed to, uint256 amount);
54 
55     /// @notice The standard EIP-20 approval event
56     event Approval(address indexed owner, address indexed spender, uint256 amount);
57 
58     /**
59      * @notice Construct a new ESG token
60      * @param account The initial account to grant all the tokens
61      */
62     constructor (address account) public{
63         balances[account] = uint96(totalSupply);
64         emit Transfer(address(0), account, totalSupply);
65     }
66 
67     /**
68      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
69      * @param account The address of the account holding the funds
70      * @param spender The address of the account spending the funds
71      * @return The number of tokens approved
72      */
73     function allowance(address account, address spender) external view returns (uint) {
74         return allowances[account][spender];
75     }
76 
77     /**
78      * @notice Approve `spender` to transfer up to `amount` from `src`
79      * @dev This will overwrite the approval amount for `spender`
80      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
81      * @param spender The address of the account which may transfer tokens
82      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
83      * @return Whether or not the approval succeeded
84      */
85     function approve(address spender, uint rawAmount) external returns (bool) {
86         uint96 amount;
87         if (rawAmount == uint(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)) {
88             amount = uint96(0xffffffffffffffffffffffff);
89         } else {
90             amount = safe96(rawAmount, "ESG::approve: amount exceeds 96 bits");
91         }
92 
93         allowances[msg.sender][spender] = amount;
94 
95         emit Approval(msg.sender, spender, amount);
96         return true;
97     }
98 
99     /**
100      * @notice Get the number of tokens held by the `account`
101      * @param account The address of the account to get the balance of
102      * @return The number of tokens held
103      */
104     function balanceOf(address account) external view returns (uint) {
105         return balances[account];
106     }
107 
108     /**
109      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
110      * @param dst The address of the destination account
111      * @param rawAmount The number of tokens to transfer
112      * @return Whether or not the transfer succeeded
113      */
114     function transfer(address dst, uint rawAmount) external returns (bool) {
115         uint96 amount = safe96(rawAmount, "ESG::transfer: amount exceeds 96 bits");
116         _transferTokens(msg.sender, dst, amount);
117         return true;
118     }
119 
120     /**
121      * @notice Transfer `amount` tokens from `src` to `dst`
122      * @param src The address of the source account
123      * @param dst The address of the destination account
124      * @param rawAmount The number of tokens to transfer
125      * @return Whether or not the transfer succeeded
126      */
127     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
128         address spender = msg.sender;
129         uint96 spenderAllowance = allowances[src][spender];
130         uint96 amount = safe96(rawAmount, "ESG::transferFrom: amount exceeds 96 bits");
131 
132         if (spender != src && spenderAllowance != uint96(0xffffffffffffffffffffffff)) {
133             uint96 newAllowance = sub96(spenderAllowance, amount, "ESG::transferFrom: transfer amount exceeds spender allowance");
134             allowances[src][spender] = newAllowance;
135 
136             emit Approval(src, spender, newAllowance);
137         }
138 
139         _transferTokens(src, dst, amount);
140         return true;
141     }
142 
143     /**
144      * @notice Delegate votes from `msg.sender` to `delegatee`
145      * @param delegatee The address to delegate votes to
146      */
147     function delegate(address delegatee) external {
148         return _delegate(msg.sender, delegatee);
149     }
150 
151     /**
152      * @notice Delegates votes from signatory to `delegatee`
153      * @param delegatee The address to delegate votes to
154      * @param nonce The contract state required to match the signature
155      * @param expiry The time at which to expire the signature
156      * @param v The recovery byte of the signature
157      * @param r Half of the ECDSA signature pair
158      * @param s Half of the ECDSA signature pair
159      */
160     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external {
161         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
162         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
163         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
164         address signatory = ecrecover(digest, v, r, s);
165         require(signatory != address(0), "ESG::delegateBySig: invalid signature");
166         require(nonce == nonces[signatory]++, "ESG::delegateBySig: invalid nonce");
167         require(block.timestamp <= expiry, "ESG::delegateBySig: signature expired");
168         return _delegate(signatory, delegatee);
169     }
170 
171     /**
172      * @notice Gets the current votes balance for `account`
173      * @param account The address to get votes balance
174      * @return The number of current votes for `account`
175      */
176     function getCurrentVotes(address account) external view returns (uint96) {
177         uint32 nCheckpoints = numCheckpoints[account];
178         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
179     }
180 
181     /**
182      * @notice Determine the prior number of votes for an account as of a block number
183      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
184      * @param account The address of the account to check
185      * @param blockNumber The block number to get the vote balance at
186      * @return The number of votes the account had as of the given block
187      */
188     function getPriorVotes(address account, uint blockNumber) external view returns (uint96) {
189         require(blockNumber < block.number, "ESG::getPriorVotes: not yet determined");
190 
191         uint32 nCheckpoints = numCheckpoints[account];
192         if (nCheckpoints == 0) {
193             return 0;
194         }
195 
196         // First check most recent balance
197         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
198             return checkpoints[account][nCheckpoints - 1].votes;
199         }
200 
201         // Next check implicit zero balance
202         if (checkpoints[account][0].fromBlock > blockNumber) {
203             return 0;
204         }
205 
206         uint32 lower = 0;
207         uint32 upper = nCheckpoints - 1;
208         while (upper > lower) {
209             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
210             Checkpoint memory cp = checkpoints[account][center];
211             if (cp.fromBlock == blockNumber) {
212                 return cp.votes;
213             } else if (cp.fromBlock < blockNumber) {
214                 lower = center;
215             } else {
216                 upper = center - 1;
217             }
218         }
219         return checkpoints[account][lower].votes;
220     }
221 
222     function _delegate(address delegator, address delegatee) internal {
223         address currentDelegate = delegates[delegator];
224         uint96 delegatorBalance = balances[delegator];
225         delegates[delegator] = delegatee;
226 
227         emit DelegateChanged(delegator, currentDelegate, delegatee);
228 
229         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
230     }
231 
232     function _transferTokens(address src, address dst, uint96 amount) internal {
233         require(src != address(0), "ESG::_transferTokens: cannot transfer from the zero address");
234         require(dst != address(0), "ESG::_transferTokens: cannot transfer to the zero address");
235 
236         balances[src] = sub96(balances[src], amount, "ESG::_transferTokens: transfer amount exceeds balance");
237         balances[dst] = add96(balances[dst], amount, "ESG::_transferTokens: transfer amount overflows");
238         emit Transfer(src, dst, amount);
239 
240         _moveDelegates(delegates[src], delegates[dst], amount);
241     }
242 
243     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
244         if (srcRep != dstRep && amount > 0) {
245             if (srcRep != address(0)) {
246                 uint32 srcRepNum = numCheckpoints[srcRep];
247                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
248                 uint96 srcRepNew = sub96(srcRepOld, amount, "ESG::_moveDelegates: vote amount underflows");
249                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
250             }
251 
252             if (dstRep != address(0)) {
253                 uint32 dstRepNum = numCheckpoints[dstRep];
254                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
255                 uint96 dstRepNew = add96(dstRepOld, amount, "ESG::_moveDelegates: vote amount overflows");
256                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
257             }
258         }
259     }
260 
261     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
262       uint32 blockNumber = safe32(block.number, "ESG::_writeCheckpoint: block number exceeds 32 bits");
263 
264       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
265           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
266       } else {
267           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
268           numCheckpoints[delegatee] = nCheckpoints + 1;
269       }
270 
271       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
272     }
273 
274     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
275         require(n < 2**32, errorMessage);
276         return uint32(n);
277     }
278 
279     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
280         require(n < 2**96, errorMessage);
281         return uint96(n);
282     }
283 
284     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
285         uint96 c = a + b;
286         require(c >= a, errorMessage);
287         return c;
288     }
289 
290     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
291         require(b <= a, errorMessage);
292         return a - b;
293     }
294 
295     function getChainId() internal pure returns (uint) {
296         uint256 chainId;
297         assembly { chainId := chainid() }
298         return chainId;
299     }
300 }