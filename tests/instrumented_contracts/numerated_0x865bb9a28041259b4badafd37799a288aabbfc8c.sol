1 pragma solidity 0.5.17;
2 pragma experimental ABIEncoderV2;
3 
4 contract Moma {
5     /// @notice EIP-20 token name for this token
6     string public constant name = "Moma Token";
7 
8     /// @notice EIP-20 token symbol for this token
9     string public constant symbol = "MOMAT";
10 
11     /// @notice EIP-20 token decimals for this token
12     uint8 public constant decimals = 18;
13 
14     /// @notice Total number of tokens in circulation
15     uint public constant totalSupply = 100000000e18; // 100 million Moma
16 
17     /// @notice Allowance amounts on behalf of others
18     mapping (address => mapping (address => uint96)) internal allowances;
19 
20     /// @notice Official record of token balances for each account
21     mapping (address => uint96) internal balances;
22 
23     /// @notice A record of each accounts delegate
24     mapping (address => address) public delegates;
25 
26     /// @notice A checkpoint for marking number of votes from a given block
27     struct Checkpoint {
28         uint32 fromBlock;
29         uint96 votes;
30     }
31 
32     /// @notice A record of votes checkpoints for each account, by index
33     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
34 
35     /// @notice The number of checkpoints for each account
36     mapping (address => uint32) public numCheckpoints;
37 
38     /// @notice The EIP-712 typehash for the contract's domain
39     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
40 
41     /// @notice The EIP-712 typehash for the delegation struct used by the contract
42     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
43 
44     /// @notice A record of states for signing / validating signatures
45     mapping (address => uint) public nonces;
46 
47     /// @notice An event thats emitted when an account changes its delegate
48     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
49 
50     /// @notice An event thats emitted when a delegate account's vote balance changes
51     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
52 
53     /// @notice The standard EIP-20 transfer event
54     event Transfer(address indexed from, address indexed to, uint256 amount);
55 
56     /// @notice The standard EIP-20 approval event
57     event Approval(address indexed owner, address indexed spender, uint256 amount);
58 
59     /**
60      * @notice Construct a new Moma token
61      * @param account The initial account to grant all the tokens
62      */
63     constructor(address account) public {
64         balances[account] = uint96(totalSupply);
65         emit Transfer(address(0), account, totalSupply);
66     }
67 
68     /**
69      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
70      * @param account The address of the account holding the funds
71      * @param spender The address of the account spending the funds
72      * @return The number of tokens approved
73      */
74     function allowance(address account, address spender) external view returns (uint) {
75         return allowances[account][spender];
76     }
77 
78     /**
79      * @notice Approve `spender` to transfer up to `amount` from `src`
80      * @dev This will overwrite the approval amount for `spender`
81      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
82      * @param spender The address of the account which may transfer tokens
83      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
84      * @return Whether or not the approval succeeded
85      */
86     function approve(address spender, uint rawAmount) external returns (bool) {
87         uint96 amount;
88         if (rawAmount == uint(-1)) {
89             amount = uint96(-1);
90         } else {
91             amount = safe96(rawAmount, "Moma::approve: amount exceeds 96 bits");
92         }
93 
94         allowances[msg.sender][spender] = amount;
95 
96         emit Approval(msg.sender, spender, amount);
97         return true;
98     }
99 
100     /**
101      * @notice Get the number of tokens held by the `account`
102      * @param account The address of the account to get the balance of
103      * @return The number of tokens held
104      */
105     function balanceOf(address account) external view returns (uint) {
106         return balances[account];
107     }
108 
109     /**
110      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
111      * @param dst The address of the destination account
112      * @param rawAmount The number of tokens to transfer
113      * @return Whether or not the transfer succeeded
114      */
115     function transfer(address dst, uint rawAmount) external returns (bool) {
116         uint96 amount = safe96(rawAmount, "Moma::transfer: amount exceeds 96 bits");
117         _transferTokens(msg.sender, dst, amount);
118         return true;
119     }
120 
121     /**
122      * @notice Transfer `amount` tokens from `src` to `dst`
123      * @param src The address of the source account
124      * @param dst The address of the destination account
125      * @param rawAmount The number of tokens to transfer
126      * @return Whether or not the transfer succeeded
127      */
128     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
129         address spender = msg.sender;
130         uint96 spenderAllowance = allowances[src][spender];
131         uint96 amount = safe96(rawAmount, "Moma::approve: amount exceeds 96 bits");
132 
133         if (spender != src && spenderAllowance != uint96(-1)) {
134             uint96 newAllowance = sub96(spenderAllowance, amount, "Moma::transferFrom: transfer amount exceeds spender allowance");
135             allowances[src][spender] = newAllowance;
136 
137             emit Approval(src, spender, newAllowance);
138         }
139 
140         _transferTokens(src, dst, amount);
141         return true;
142     }
143 
144     /**
145      * @notice Delegate votes from `msg.sender` to `delegatee`
146      * @param delegatee The address to delegate votes to
147      */
148     function delegate(address delegatee) public {
149         return _delegate(msg.sender, delegatee);
150     }
151 
152     /**
153      * @notice Delegates votes from signatory to `delegatee`
154      * @param delegatee The address to delegate votes to
155      * @param nonce The contract state required to match the signature
156      * @param expiry The time at which to expire the signature
157      * @param v The recovery byte of the signature
158      * @param r Half of the ECDSA signature pair
159      * @param s Half of the ECDSA signature pair
160      */
161     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
162         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
163         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
164         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
165         address signatory = ecrecover(digest, v, r, s);
166         require(signatory != address(0), "Moma::delegateBySig: invalid signature");
167         require(nonce == nonces[signatory]++, "Moma::delegateBySig: invalid nonce");
168         require(now <= expiry, "Moma::delegateBySig: signature expired");
169         return _delegate(signatory, delegatee);
170     }
171 
172     /**
173      * @notice Gets the current votes balance for `account`
174      * @param account The address to get votes balance
175      * @return The number of current votes for `account`
176      */
177     function getCurrentVotes(address account) external view returns (uint96) {
178         uint32 nCheckpoints = numCheckpoints[account];
179         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
180     }
181 
182     /**
183      * @notice Determine the prior number of votes for an account as of a block number
184      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
185      * @param account The address of the account to check
186      * @param blockNumber The block number to get the vote balance at
187      * @return The number of votes the account had as of the given block
188      */
189     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
190         require(blockNumber < block.number, "Moma::getPriorVotes: not yet determined");
191 
192         uint32 nCheckpoints = numCheckpoints[account];
193         if (nCheckpoints == 0) {
194             return 0;
195         }
196 
197         // First check most recent balance
198         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
199             return checkpoints[account][nCheckpoints - 1].votes;
200         }
201 
202         // Next check implicit zero balance
203         if (checkpoints[account][0].fromBlock > blockNumber) {
204             return 0;
205         }
206 
207         uint32 lower = 0;
208         uint32 upper = nCheckpoints - 1;
209         while (upper > lower) {
210             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
211             Checkpoint memory cp = checkpoints[account][center];
212             if (cp.fromBlock == blockNumber) {
213                 return cp.votes;
214             } else if (cp.fromBlock < blockNumber) {
215                 lower = center;
216             } else {
217                 upper = center - 1;
218             }
219         }
220         return checkpoints[account][lower].votes;
221     }
222 
223     function _delegate(address delegator, address delegatee) internal {
224         address currentDelegate = delegates[delegator];
225         uint96 delegatorBalance = balances[delegator];
226         delegates[delegator] = delegatee;
227 
228         emit DelegateChanged(delegator, currentDelegate, delegatee);
229 
230         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
231     }
232 
233     function _transferTokens(address src, address dst, uint96 amount) internal {
234         require(src != address(0), "Moma::_transferTokens: cannot transfer from the zero address");
235         require(dst != address(0), "Moma::_transferTokens: cannot transfer to the zero address");
236 
237         balances[src] = sub96(balances[src], amount, "Moma::_transferTokens: transfer amount exceeds balance");
238         balances[dst] = add96(balances[dst], amount, "Moma::_transferTokens: transfer amount overflows");
239         emit Transfer(src, dst, amount);
240 
241         _moveDelegates(delegates[src], delegates[dst], amount);
242     }
243 
244     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
245         if (srcRep != dstRep && amount > 0) {
246             if (srcRep != address(0)) {
247                 uint32 srcRepNum = numCheckpoints[srcRep];
248                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
249                 uint96 srcRepNew = sub96(srcRepOld, amount, "Moma::_moveVotes: vote amount underflows");
250                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
251             }
252 
253             if (dstRep != address(0)) {
254                 uint32 dstRepNum = numCheckpoints[dstRep];
255                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
256                 uint96 dstRepNew = add96(dstRepOld, amount, "Moma::_moveVotes: vote amount overflows");
257                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
258             }
259         }
260     }
261 
262     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
263       uint32 blockNumber = safe32(block.number, "Moma::_writeCheckpoint: block number exceeds 32 bits");
264 
265       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
266           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
267       } else {
268           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
269           numCheckpoints[delegatee] = nCheckpoints + 1;
270       }
271 
272       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
273     }
274 
275     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
276         require(n < 2**32, errorMessage);
277         return uint32(n);
278     }
279 
280     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
281         require(n < 2**96, errorMessage);
282         return uint96(n);
283     }
284 
285     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
286         uint96 c = a + b;
287         require(c >= a, errorMessage);
288         return c;
289     }
290 
291     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
292         require(b <= a, errorMessage);
293         return a - b;
294     }
295 
296     function getChainId() internal pure returns (uint) {
297         uint256 chainId;
298         assembly { chainId := chainid() }
299         return chainId;
300     }
301 }