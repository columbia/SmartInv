1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 /** 
5 
6  _____ _   _ _____  _    _ 
7 /  ___| \ | |  _  || |  | |
8 \ `--.|  \| | | | || |  | |
9  `--. \ . ` | | | || |/\| |
10 /\__/ / |\  \ \_/ /\  /\  /
11 \____/\_| \_/\___/  \/  \/ 
12                            
13 
14 SNOW Token
15 
16 Forked from COMP and UNI 
17 
18 Although this contract is based on Compound and Uniswap, SNOW itself has not been audited. 
19 Use at your own risk! 
20 
21 */
22 
23 contract Snow {
24     /// @notice EIP-20 token name for this token
25     string public constant name = "SnowSwap";
26 
27     /// @notice EIP-20 token symbol for this token
28     string public constant symbol = "SNOW";
29 
30     /// @notice EIP-20 token decimals for this token
31     uint8 public constant decimals = 18;
32 
33     /// @notice Total number of tokens in circulation
34     uint public constant totalSupply = 500000e18; // 500,000 Snow
35 
36     /// @notice Allowance amounts on behalf of others
37     mapping (address => mapping (address => uint96)) internal allowances;
38 
39     /// @notice Official record of token balances for each account
40     mapping (address => uint96) internal balances;
41 
42     /// @notice A record of each accounts delegate
43     mapping (address => address) public delegates;
44 
45     /// @notice A checkpoint for marking number of votes from a given block
46     struct Checkpoint {
47         uint32 fromBlock;
48         uint96 votes;
49     }
50 
51     /// @notice A record of votes checkpoints for each account, by index
52     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
53 
54     /// @notice The number of checkpoints for each account
55     mapping (address => uint32) public numCheckpoints;
56 
57     /// @notice The EIP-712 typehash for the contract's domain
58     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
59 
60     /// @notice The EIP-712 typehash for the delegation struct used by the contract
61     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
62 
63     /// @notice The EIP-712 typehash for the permit struct used by the contract
64     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
65 
66     /// @notice A record of states for signing / validating signatures
67     mapping (address => uint) public nonces;
68 
69     /// @notice An event thats emitted when an account changes its delegate
70     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
71 
72     /// @notice An event thats emitted when a delegate account's vote balance changes
73     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
74 
75     /// @notice The standard EIP-20 transfer event
76     event Transfer(address indexed from, address indexed to, uint256 amount);
77 
78     /// @notice The standard EIP-20 approval event
79     event Approval(address indexed owner, address indexed spender, uint256 amount);
80 
81     /**
82      * @notice Construct a new Snow token
83      * @param account The initial account to grant all the tokens
84      */
85     constructor(address account) public {
86         balances[account] = uint96(totalSupply);
87         emit Transfer(address(0), account, totalSupply);
88     }
89 
90     /**
91      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
92      * @param account The address of the account holding the funds
93      * @param spender The address of the account spending the funds
94      * @return The number of tokens approved
95      */
96     function allowance(address account, address spender) external view returns (uint) {
97         return allowances[account][spender];
98     }
99 
100     /**
101      * @notice Approve `spender` to transfer up to `amount` from `src`
102      * @dev This will overwrite the approval amount for `spender`
103      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
104      * @param spender The address of the account which may transfer tokens
105      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
106      * @return Whether or not the approval succeeded
107      */
108     function approve(address spender, uint rawAmount) external returns (bool) {
109         uint96 amount;
110         if (rawAmount == uint(-1)) {
111             amount = uint96(-1);
112         } else {
113             amount = safe96(rawAmount, "Snow::approve: amount exceeds 96 bits");
114         }
115 
116         allowances[msg.sender][spender] = amount;
117 
118         emit Approval(msg.sender, spender, amount);
119         return true;
120     }
121     	
122     /**
123      * @notice Triggers an approval from owner to spends
124      * @param owner The address to approve from
125      * @param spender The address to be approved
126      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
127      * @param deadline The time at which to expire the signature
128      * @param v The recovery byte of the signature
129      * @param r Half of the ECDSA signature pair
130      * @param s Half of the ECDSA signature pair
131      */
132     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
133         uint96 amount;
134         if (rawAmount == uint(-1)) {
135             amount = uint96(-1);
136         } else {
137             amount = safe96(rawAmount, "Snow::permit: amount exceeds 96 bits");
138         }
139         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
140         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
141         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
142         address signatory = ecrecover(digest, v, r, s);
143         require(signatory != address(0), "Snow::permit: invalid signature");
144         require(signatory == owner, "Snow::permit: unauthorized");
145         require(now <= deadline, "Snow::permit: signature expired");
146         allowances[owner][spender] = amount;
147         emit Approval(owner, spender, amount);
148     }
149 
150     /**
151      * @notice Get the number of tokens held by the `account`
152      * @param account The address of the account to get the balance of
153      * @return The number of tokens held
154      */
155     function balanceOf(address account) external view returns (uint) {
156         return balances[account];
157     }
158 
159     /**
160      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
161      * @param dst The address of the destination account
162      * @param rawAmount The number of tokens to transfer
163      * @return Whether or not the transfer succeeded
164      */
165     function transfer(address dst, uint rawAmount) external returns (bool) {
166         uint96 amount = safe96(rawAmount, "Snow::transfer: amount exceeds 96 bits");
167         _transferTokens(msg.sender, dst, amount);
168         return true;
169     }
170 
171     /**
172      * @notice Transfer `amount` tokens from `src` to `dst`
173      * @param src The address of the source account
174      * @param dst The address of the destination account
175      * @param rawAmount The number of tokens to transfer
176      * @return Whether or not the transfer succeeded
177      */
178     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
179         address spender = msg.sender;
180         uint96 spenderAllowance = allowances[src][spender];
181         uint96 amount = safe96(rawAmount, "Snow::approve: amount exceeds 96 bits");
182 
183         if (spender != src && spenderAllowance != uint96(-1)) {
184             uint96 newAllowance = sub96(spenderAllowance, amount, "Snow::transferFrom: transfer amount exceeds spender allowance");
185             allowances[src][spender] = newAllowance;
186 
187             emit Approval(src, spender, newAllowance);
188         }
189 
190         _transferTokens(src, dst, amount);
191         return true;
192     }
193 
194     /**
195      * @notice Delegate votes from `msg.sender` to `delegatee`
196      * @param delegatee The address to delegate votes to
197      */
198     function delegate(address delegatee) public {
199         return _delegate(msg.sender, delegatee);
200     }
201 
202     /**
203      * @notice Delegates votes from signatory to `delegatee`
204      * @param delegatee The address to delegate votes to
205      * @param nonce The contract state required to match the signature
206      * @param expiry The time at which to expire the signature
207      * @param v The recovery byte of the signature
208      * @param r Half of the ECDSA signature pair
209      * @param s Half of the ECDSA signature pair
210      */
211     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
212         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
213         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
214         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
215         address signatory = ecrecover(digest, v, r, s);
216         require(signatory != address(0), "Snow::delegateBySig: invalid signature");
217         require(nonce == nonces[signatory]++, "Snow::delegateBySig: invalid nonce");
218         require(now <= expiry, "Snow::delegateBySig: signature expired");
219         return _delegate(signatory, delegatee);
220     }
221 
222     /**
223      * @notice Gets the current votes balance for `account`
224      * @param account The address to get votes balance
225      * @return The number of current votes for `account`
226      */
227     function getCurrentVotes(address account) external view returns (uint96) {
228         uint32 nCheckpoints = numCheckpoints[account];
229         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
230     }
231 
232     /**
233      * @notice Determine the prior number of votes for an account as of a block number
234      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
235      * @param account The address of the account to check
236      * @param blockNumber The block number to get the vote balance at
237      * @return The number of votes the account had as of the given block
238      */
239     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
240         require(blockNumber < block.number, "Snow::getPriorVotes: not yet determined");
241 
242         uint32 nCheckpoints = numCheckpoints[account];
243         if (nCheckpoints == 0) {
244             return 0;
245         }
246 
247         // First check most recent balance
248         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
249             return checkpoints[account][nCheckpoints - 1].votes;
250         }
251 
252         // Next check implicit zero balance
253         if (checkpoints[account][0].fromBlock > blockNumber) {
254             return 0;
255         }
256 
257         uint32 lower = 0;
258         uint32 upper = nCheckpoints - 1;
259         while (upper > lower) {
260             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
261             Checkpoint memory cp = checkpoints[account][center];
262             if (cp.fromBlock == blockNumber) {
263                 return cp.votes;
264             } else if (cp.fromBlock < blockNumber) {
265                 lower = center;
266             } else {
267                 upper = center - 1;
268             }
269         }
270         return checkpoints[account][lower].votes;
271     }
272 
273     function _delegate(address delegator, address delegatee) internal {
274         address currentDelegate = delegates[delegator];
275         uint96 delegatorBalance = balances[delegator];
276         delegates[delegator] = delegatee;
277 
278         emit DelegateChanged(delegator, currentDelegate, delegatee);
279 
280         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
281     }
282 
283     function _transferTokens(address src, address dst, uint96 amount) internal {
284         require(src != address(0), "Snow::_transferTokens: cannot transfer from the zero address");
285         require(dst != address(0), "Snow::_transferTokens: cannot transfer to the zero address");
286 
287         balances[src] = sub96(balances[src], amount, "Snow::_transferTokens: transfer amount exceeds balance");
288         balances[dst] = add96(balances[dst], amount, "Snow::_transferTokens: transfer amount overflows");
289         emit Transfer(src, dst, amount);
290 
291         _moveDelegates(delegates[src], delegates[dst], amount);
292     }
293 
294     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
295         if (srcRep != dstRep && amount > 0) {
296             if (srcRep != address(0)) {
297                 uint32 srcRepNum = numCheckpoints[srcRep];
298                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
299                 uint96 srcRepNew = sub96(srcRepOld, amount, "Snow::_moveVotes: vote amount underflows");
300                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
301             }
302 
303             if (dstRep != address(0)) {
304                 uint32 dstRepNum = numCheckpoints[dstRep];
305                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
306                 uint96 dstRepNew = add96(dstRepOld, amount, "Snow::_moveVotes: vote amount overflows");
307                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
308             }
309         }
310     }
311 
312     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
313       uint32 blockNumber = safe32(block.number, "Snow::_writeCheckpoint: block number exceeds 32 bits");
314 
315       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
316           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
317       } else {
318           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
319           numCheckpoints[delegatee] = nCheckpoints + 1;
320       }
321 
322       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
323     }
324 
325     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
326         require(n < 2**32, errorMessage);
327         return uint32(n);
328     }
329 
330     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
331         require(n < 2**96, errorMessage);
332         return uint96(n);
333     }
334 
335     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
336         uint96 c = a + b;
337         require(c >= a, errorMessage);
338         return c;
339     }
340 
341     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
342         require(b <= a, errorMessage);
343         return a - b;
344     }
345 
346     function getChainId() internal pure returns (uint) {
347         uint256 chainId;
348         assembly { chainId := chainid() }
349         return chainId;
350     }
351 }