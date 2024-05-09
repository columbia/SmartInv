1 /*
2 https://powerpool.finance/     
3                                                                                                                                                                                                        
4           wrrrw r wrr                                                                                    
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0      
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0      
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0      
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0      
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0     
10           wrr ww0rrrr                                                                                    
11                                                                                                                                                                                                                       
12 */
13 
14 
15 
16 pragma solidity ^0.5.16;
17 pragma experimental ABIEncoderV2;
18 
19 contract Cvp {
20     /// @notice EIP-20 token name for this token
21     string public constant name = "Concentrated Voting Power";
22 
23     /// @notice EIP-20 token symbol for this token
24     string public constant symbol = "CVP";
25 
26     /// @notice EIP-20 token decimals for this token
27     uint8 public constant decimals = 18;
28 
29     /// @notice Total number of tokens in circulation
30     uint public constant totalSupply = 100000000e18;
31 
32     /// @notice Allowance amounts on behalf of others
33     mapping (address => mapping (address => uint96)) internal allowances;
34 
35     /// @notice Official record of token balances for each account
36     mapping (address => uint96) internal balances;
37 
38     /// @notice A record of each accounts delegate
39     mapping (address => address) public delegates;
40 
41     /// @notice A checkpoint for marking number of votes from a given block
42     struct Checkpoint {
43         uint32 fromBlock;
44         uint96 votes;
45     }
46 
47     /// @notice A record of votes checkpoints for each account, by index
48     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
49 
50     /// @notice The number of checkpoints for each account
51     mapping (address => uint32) public numCheckpoints;
52 
53     /// @notice The EIP-712 typehash for the contract's domain
54     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
55 
56     /// @notice The EIP-712 typehash for the delegation struct used by the contract
57     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
58 
59     /// @notice A record of states for signing / validating signatures
60     mapping (address => uint) public nonces;
61 
62     /// @notice An event thats emitted when an account changes its delegate
63     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
64 
65     /// @notice An event thats emitted when a delegate account's vote balance changes
66     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
67 
68     /// @notice The standard EIP-20 transfer event
69     event Transfer(address indexed from, address indexed to, uint256 amount);
70 
71     /// @notice The standard EIP-20 approval event
72     event Approval(address indexed owner, address indexed spender, uint256 amount);
73 
74     /**
75      * @notice Construct a new Cvp token
76      * @param account The initial account to grant all the tokens
77      */
78     constructor(address account) public {
79         balances[account] = uint96(totalSupply);
80         emit Transfer(address(0), account, totalSupply);
81     }
82 
83     /**
84      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
85      * @param account The address of the account holding the funds
86      * @param spender The address of the account spending the funds
87      * @return The number of tokens approved
88      */
89     function allowance(address account, address spender) external view returns (uint) {
90         return allowances[account][spender];
91     }
92 
93     /**
94      * @notice Approve `spender` to transfer up to `amount` from `src`
95      * @dev This will overwrite the approval amount for `spender`
96      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
97      * @param spender The address of the account which may transfer tokens
98      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
99      * @return Whether or not the approval succeeded
100      */
101     function approve(address spender, uint rawAmount) external returns (bool) {
102         uint96 amount;
103         if (rawAmount == uint(-1)) {
104             amount = uint96(-1);
105         } else {
106             amount = safe96(rawAmount, "Cvp::approve: amount exceeds 96 bits");
107         }
108 
109         allowances[msg.sender][spender] = amount;
110 
111         emit Approval(msg.sender, spender, amount);
112         return true;
113     }
114 
115     /**
116      * @notice Get the number of tokens held by the `account`
117      * @param account The address of the account to get the balance of
118      * @return The number of tokens held
119      */
120     function balanceOf(address account) external view returns (uint) {
121         return balances[account];
122     }
123 
124     /**
125      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
126      * @param dst The address of the destination account
127      * @param rawAmount The number of tokens to transfer
128      * @return Whether or not the transfer succeeded
129      */
130     function transfer(address dst, uint rawAmount) external returns (bool) {
131         uint96 amount = safe96(rawAmount, "Cvp::transfer: amount exceeds 96 bits");
132         _transferTokens(msg.sender, dst, amount);
133         return true;
134     }
135 
136     /**
137      * @notice Transfer `amount` tokens from `src` to `dst`
138      * @param src The address of the source account
139      * @param dst The address of the destination account
140      * @param rawAmount The number of tokens to transfer
141      * @return Whether or not the transfer succeeded
142      */
143     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
144         address spender = msg.sender;
145         uint96 spenderAllowance = allowances[src][spender];
146         uint96 amount = safe96(rawAmount, "Cvp::approve: amount exceeds 96 bits");
147 
148         if (spender != src && spenderAllowance != uint96(-1)) {
149             uint96 newAllowance = sub96(spenderAllowance, amount, "Cvp::transferFrom: transfer amount exceeds spender allowance");
150             allowances[src][spender] = newAllowance;
151 
152             emit Approval(src, spender, newAllowance);
153         }
154 
155         _transferTokens(src, dst, amount);
156         return true;
157     }
158 
159     /**
160      * @notice Delegate votes from `msg.sender` to `delegatee`
161      * @param delegatee The address to delegate votes to
162      */
163     function delegate(address delegatee) public {
164         return _delegate(msg.sender, delegatee);
165     }
166 
167     /**
168      * @notice Delegates votes from signatory to `delegatee`
169      * @param delegatee The address to delegate votes to
170      * @param nonce The contract state required to match the signature
171      * @param expiry The time at which to expire the signature
172      * @param v The recovery byte of the signature
173      * @param r Half of the ECDSA signature pair
174      * @param s Half of the ECDSA signature pair
175      */
176     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
177         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
178         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
179         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
180         address signatory = ecrecover(digest, v, r, s);
181         require(signatory != address(0), "Cvp::delegateBySig: invalid signature");
182         require(nonce == nonces[signatory]++, "Cvp::delegateBySig: invalid nonce");
183         require(now <= expiry, "Cvp::delegateBySig: signature expired");
184         return _delegate(signatory, delegatee);
185     }
186 
187     /**
188      * @notice Gets the current votes balance for `account`
189      * @param account The address to get votes balance
190      * @return The number of current votes for `account`
191      */
192     function getCurrentVotes(address account) external view returns (uint96) {
193         uint32 nCheckpoints = numCheckpoints[account];
194         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
195     }
196 
197     /**
198      * @notice Determine the prior number of votes for an account as of a block number
199      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
200      * @param account The address of the account to check
201      * @param blockNumber The block number to get the vote balance at
202      * @return The number of votes the account had as of the given block
203      */
204     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
205         require(blockNumber < block.number, "Cvp::getPriorVotes: not yet determined");
206 
207         uint32 nCheckpoints = numCheckpoints[account];
208         if (nCheckpoints == 0) {
209             return 0;
210         }
211 
212         // First check most recent balance
213         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
214             return checkpoints[account][nCheckpoints - 1].votes;
215         }
216 
217         // Next check implicit zero balance
218         if (checkpoints[account][0].fromBlock > blockNumber) {
219             return 0;
220         }
221 
222         uint32 lower = 0;
223         uint32 upper = nCheckpoints - 1;
224         while (upper > lower) {
225             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
226             Checkpoint memory cp = checkpoints[account][center];
227             if (cp.fromBlock == blockNumber) {
228                 return cp.votes;
229             } else if (cp.fromBlock < blockNumber) {
230                 lower = center;
231             } else {
232                 upper = center - 1;
233             }
234         }
235         return checkpoints[account][lower].votes;
236     }
237 
238     function _delegate(address delegator, address delegatee) internal {
239         address currentDelegate = delegates[delegator];
240         uint96 delegatorBalance = balances[delegator];
241         delegates[delegator] = delegatee;
242 
243         emit DelegateChanged(delegator, currentDelegate, delegatee);
244 
245         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
246     }
247 
248     function _transferTokens(address src, address dst, uint96 amount) internal {
249         require(src != address(0), "Cvp::_transferTokens: cannot transfer from the zero address");
250         require(dst != address(0), "Cvp::_transferTokens: cannot transfer to the zero address");
251 
252         balances[src] = sub96(balances[src], amount, "Cvp::_transferTokens: transfer amount exceeds balance");
253         balances[dst] = add96(balances[dst], amount, "Cvp::_transferTokens: transfer amount overflows");
254         emit Transfer(src, dst, amount);
255 
256         _moveDelegates(delegates[src], delegates[dst], amount);
257     }
258 
259     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
260         if (srcRep != dstRep && amount > 0) {
261             if (srcRep != address(0)) {
262                 uint32 srcRepNum = numCheckpoints[srcRep];
263                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
264                 uint96 srcRepNew = sub96(srcRepOld, amount, "Cvp::_moveVotes: vote amount underflows");
265                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
266             }
267 
268             if (dstRep != address(0)) {
269                 uint32 dstRepNum = numCheckpoints[dstRep];
270                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
271                 uint96 dstRepNew = add96(dstRepOld, amount, "Cvp::_moveVotes: vote amount overflows");
272                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
273             }
274         }
275     }
276 
277     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
278       uint32 blockNumber = safe32(block.number, "Cvp::_writeCheckpoint: block number exceeds 32 bits");
279 
280       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
281           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
282       } else {
283           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
284           numCheckpoints[delegatee] = nCheckpoints + 1;
285       }
286 
287       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
288     }
289 
290     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
291         require(n < 2**32, errorMessage);
292         return uint32(n);
293     }
294 
295     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
296         require(n < 2**96, errorMessage);
297         return uint96(n);
298     }
299 
300     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
301         uint96 c = a + b;
302         require(c >= a, errorMessage);
303         return c;
304     }
305 
306     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
307         require(b <= a, errorMessage);
308         return a - b;
309     }
310 
311     function getChainId() internal pure returns (uint) {
312         uint256 chainId;
313         assembly { chainId := chainid() }
314         return chainId;
315     }
316 }