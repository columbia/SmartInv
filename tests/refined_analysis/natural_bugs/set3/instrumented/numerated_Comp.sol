1 pragma solidity ^0.5.16;
2 
3 contract Comp {
4     /// @notice EIP-20 token name for this token
5     string public constant name = "Cream";
6 
7     /// @notice EIP-20 token symbol for this token
8     string public constant symbol = "CREAM";
9 
10     /// @notice EIP-20 token decimals for this token
11     uint8 public constant decimals = 18;
12 
13     /// @notice Total number of tokens in circulation
14     uint256 public constant totalSupply = 9000000e18; // 9 million Comp
15 
16     /// @notice Allowance amounts on behalf of others
17     mapping(address => mapping(address => uint96)) internal allowances;
18 
19     /// @notice Official record of token balances for each account
20     mapping(address => uint96) internal balances;
21 
22     /// @notice A record of each accounts delegate
23     mapping(address => address) public delegates;
24 
25     /// @notice A checkpoint for marking number of votes from a given block
26     struct Checkpoint {
27         uint32 fromBlock;
28         uint96 votes;
29     }
30 
31     /// @notice A record of votes checkpoints for each account, by index
32     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
33 
34     /// @notice The number of checkpoints for each account
35     mapping(address => uint32) public numCheckpoints;
36 
37     /// @notice The EIP-712 typehash for the contract's domain
38     bytes32 public constant DOMAIN_TYPEHASH =
39         keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
40 
41     /// @notice The EIP-712 typehash for the delegation struct used by the contract
42     bytes32 public constant DELEGATION_TYPEHASH =
43         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
44 
45     /// @notice A record of states for signing / validating signatures
46     mapping(address => uint256) public nonces;
47 
48     /// @notice An event thats emitted when an account changes its delegate
49     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
50 
51     /// @notice An event thats emitted when a delegate account's vote balance changes
52     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
53 
54     /// @notice The standard EIP-20 transfer event
55     event Transfer(address indexed from, address indexed to, uint256 amount);
56 
57     /// @notice The standard EIP-20 approval event
58     event Approval(address indexed owner, address indexed spender, uint256 amount);
59 
60     /**
61      * @notice Construct a new Comp token
62      * @param account The initial account to grant all the tokens
63      */
64     constructor(address account) public {
65         balances[account] = uint96(totalSupply);
66         emit Transfer(address(0), account, totalSupply);
67     }
68 
69     /**
70      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
71      * @param account The address of the account holding the funds
72      * @param spender The address of the account spending the funds
73      * @return The number of tokens approved
74      */
75     function allowance(address account, address spender) external view returns (uint256) {
76         return allowances[account][spender];
77     }
78 
79     /**
80      * @notice Approve `spender` to transfer up to `amount` from `src`
81      * @dev This will overwrite the approval amount for `spender`
82      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
83      * @param spender The address of the account which may transfer tokens
84      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
85      * @return Whether or not the approval succeeded
86      */
87     function approve(address spender, uint256 rawAmount) external returns (bool) {
88         uint96 amount;
89         if (rawAmount == uint256(-1)) {
90             amount = uint96(-1);
91         } else {
92             amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
93         }
94 
95         allowances[msg.sender][spender] = amount;
96 
97         emit Approval(msg.sender, spender, amount);
98         return true;
99     }
100 
101     /**
102      * @notice Get the number of tokens held by the `account`
103      * @param account The address of the account to get the balance of
104      * @return The number of tokens held
105      */
106     function balanceOf(address account) external view returns (uint256) {
107         return balances[account];
108     }
109 
110     /**
111      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
112      * @param dst The address of the destination account
113      * @param rawAmount The number of tokens to transfer
114      * @return Whether or not the transfer succeeded
115      */
116     function transfer(address dst, uint256 rawAmount) external returns (bool) {
117         uint96 amount = safe96(rawAmount, "Comp::transfer: amount exceeds 96 bits");
118         _transferTokens(msg.sender, dst, amount);
119         return true;
120     }
121 
122     /**
123      * @notice Transfer `amount` tokens from `src` to `dst`
124      * @param src The address of the source account
125      * @param dst The address of the destination account
126      * @param rawAmount The number of tokens to transfer
127      * @return Whether or not the transfer succeeded
128      */
129     function transferFrom(
130         address src,
131         address dst,
132         uint256 rawAmount
133     ) external returns (bool) {
134         address spender = msg.sender;
135         uint96 spenderAllowance = allowances[src][spender];
136         uint96 amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
137 
138         if (spender != src && spenderAllowance != uint96(-1)) {
139             uint96 newAllowance = sub96(
140                 spenderAllowance,
141                 amount,
142                 "Comp::transferFrom: transfer amount exceeds spender allowance"
143             );
144             allowances[src][spender] = newAllowance;
145 
146             emit Approval(src, spender, newAllowance);
147         }
148 
149         _transferTokens(src, dst, amount);
150         return true;
151     }
152 
153     /**
154      * @notice Delegate votes from `msg.sender` to `delegatee`
155      * @param delegatee The address to delegate votes to
156      */
157     function delegate(address delegatee) public {
158         return _delegate(msg.sender, delegatee);
159     }
160 
161     /**
162      * @notice Delegates votes from signatory to `delegatee`
163      * @param delegatee The address to delegate votes to
164      * @param nonce The contract state required to match the signature
165      * @param expiry The time at which to expire the signature
166      * @param v The recovery byte of the signature
167      * @param r Half of the ECDSA signature pair
168      * @param s Half of the ECDSA signature pair
169      */
170     function delegateBySig(
171         address delegatee,
172         uint256 nonce,
173         uint256 expiry,
174         uint8 v,
175         bytes32 r,
176         bytes32 s
177     ) public {
178         bytes32 domainSeparator = keccak256(
179             abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this))
180         );
181         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
182         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
183         address signatory = ecrecover(digest, v, r, s);
184         require(signatory != address(0), "Comp::delegateBySig: invalid signature");
185         require(nonce == nonces[signatory]++, "Comp::delegateBySig: invalid nonce");
186         require(now <= expiry, "Comp::delegateBySig: signature expired");
187         return _delegate(signatory, delegatee);
188     }
189 
190     /**
191      * @notice Gets the current votes balance for `account`
192      * @param account The address to get votes balance
193      * @return The number of current votes for `account`
194      */
195     function getCurrentVotes(address account) external view returns (uint96) {
196         uint32 nCheckpoints = numCheckpoints[account];
197         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
198     }
199 
200     /**
201      * @notice Determine the prior number of votes for an account as of a block number
202      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
203      * @param account The address of the account to check
204      * @param blockNumber The block number to get the vote balance at
205      * @return The number of votes the account had as of the given block
206      */
207     function getPriorVotes(address account, uint256 blockNumber) public view returns (uint96) {
208         require(blockNumber < block.number, "Comp::getPriorVotes: not yet determined");
209 
210         uint32 nCheckpoints = numCheckpoints[account];
211         if (nCheckpoints == 0) {
212             return 0;
213         }
214 
215         // First check most recent balance
216         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
217             return checkpoints[account][nCheckpoints - 1].votes;
218         }
219 
220         // Next check implicit zero balance
221         if (checkpoints[account][0].fromBlock > blockNumber) {
222             return 0;
223         }
224 
225         uint32 lower = 0;
226         uint32 upper = nCheckpoints - 1;
227         while (upper > lower) {
228             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
229             Checkpoint memory cp = checkpoints[account][center];
230             if (cp.fromBlock == blockNumber) {
231                 return cp.votes;
232             } else if (cp.fromBlock < blockNumber) {
233                 lower = center;
234             } else {
235                 upper = center - 1;
236             }
237         }
238         return checkpoints[account][lower].votes;
239     }
240 
241     function _delegate(address delegator, address delegatee) internal {
242         address currentDelegate = delegates[delegator];
243         uint96 delegatorBalance = balances[delegator];
244         delegates[delegator] = delegatee;
245 
246         emit DelegateChanged(delegator, currentDelegate, delegatee);
247 
248         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
249     }
250 
251     function _transferTokens(
252         address src,
253         address dst,
254         uint96 amount
255     ) internal {
256         require(src != address(0), "Comp::_transferTokens: cannot transfer from the zero address");
257         require(dst != address(0), "Comp::_transferTokens: cannot transfer to the zero address");
258 
259         balances[src] = sub96(balances[src], amount, "Comp::_transferTokens: transfer amount exceeds balance");
260         balances[dst] = add96(balances[dst], amount, "Comp::_transferTokens: transfer amount overflows");
261         emit Transfer(src, dst, amount);
262 
263         _moveDelegates(delegates[src], delegates[dst], amount);
264     }
265 
266     function _moveDelegates(
267         address srcRep,
268         address dstRep,
269         uint96 amount
270     ) internal {
271         if (srcRep != dstRep && amount > 0) {
272             if (srcRep != address(0)) {
273                 uint32 srcRepNum = numCheckpoints[srcRep];
274                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
275                 uint96 srcRepNew = sub96(srcRepOld, amount, "Comp::_moveVotes: vote amount underflows");
276                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
277             }
278 
279             if (dstRep != address(0)) {
280                 uint32 dstRepNum = numCheckpoints[dstRep];
281                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
282                 uint96 dstRepNew = add96(dstRepOld, amount, "Comp::_moveVotes: vote amount overflows");
283                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
284             }
285         }
286     }
287 
288     function _writeCheckpoint(
289         address delegatee,
290         uint32 nCheckpoints,
291         uint96 oldVotes,
292         uint96 newVotes
293     ) internal {
294         uint32 blockNumber = safe32(block.number, "Comp::_writeCheckpoint: block number exceeds 32 bits");
295 
296         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
297             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
298         } else {
299             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
300             numCheckpoints[delegatee] = nCheckpoints + 1;
301         }
302 
303         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
304     }
305 
306     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
307         require(n < 2**32, errorMessage);
308         return uint32(n);
309     }
310 
311     function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
312         require(n < 2**96, errorMessage);
313         return uint96(n);
314     }
315 
316     function add96(
317         uint96 a,
318         uint96 b,
319         string memory errorMessage
320     ) internal pure returns (uint96) {
321         uint96 c = a + b;
322         require(c >= a, errorMessage);
323         return c;
324     }
325 
326     function sub96(
327         uint96 a,
328         uint96 b,
329         string memory errorMessage
330     ) internal pure returns (uint96) {
331         require(b <= a, errorMessage);
332         return a - b;
333     }
334 
335     function getChainId() internal pure returns (uint256) {
336         uint256 chainId;
337         assembly {
338             chainId := chainid()
339         }
340         return chainId;
341     }
342 }
