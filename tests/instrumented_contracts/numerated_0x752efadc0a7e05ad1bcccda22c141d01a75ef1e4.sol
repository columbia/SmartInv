1 pragma solidity ^0.5.17;
2 pragma experimental ABIEncoderV2;
3 
4 contract Comfi {
5     /// @notice EIP-20 token name for this token
6     string public constant name = "CompliFi";
7 
8     /// @notice EIP-20 token symbol for this token
9     string public constant symbol = "COMFI";
10 
11     /// @notice EIP-20 token decimals for this token
12     uint8 public constant decimals = 18;
13 
14     /// @notice Total number of tokens in circulation
15     uint public totalSupply = 10_000_000e18; // 10 millions Comfi
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
44     /// @notice The EIP-712 typehash for the permit struct used by the contract
45     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
46 
47     /// @notice A record of states for signing / validating signatures
48     mapping (address => uint) public nonces;
49 
50     /// @notice An event thats emitted when an account changes its delegate
51     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
52 
53     /// @notice An event thats emitted when a delegate account's vote balance changes
54     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
55 
56     /// @notice The standard EIP-20 transfer event
57     event Transfer(address indexed from, address indexed to, uint256 amount);
58 
59     /// @notice The standard EIP-20 approval event
60     event Approval(address indexed owner, address indexed spender, uint256 amount);
61 
62     /**
63      * @notice Construct a new Comfi token
64      * @param account The initial account to grant all the tokens
65      */
66     constructor(address account) public {
67         balances[account] = uint96(totalSupply);
68         emit Transfer(address(0), account, totalSupply);
69     }
70 
71     /**
72      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
73      * @param account The address of the account holding the funds
74      * @param spender The address of the account spending the funds
75      * @return The number of tokens approved
76      */
77     function allowance(address account, address spender) external view returns (uint) {
78         return allowances[account][spender];
79     }
80 
81     /**
82      * @notice Approve `spender` to transfer up to `amount` from `src`
83      * @dev This will overwrite the approval amount for `spender`
84      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
85      * @param spender The address of the account which may transfer tokens
86      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
87      * @return Whether or not the approval succeeded
88      */
89     function approve(address spender, uint rawAmount) external returns (bool) {
90         uint96 amount;
91         if (rawAmount == uint(-1)) {
92             amount = uint96(-1);
93         } else {
94             amount = safe96(rawAmount, "Comfi::approve: amount exceeds 96 bits");
95         }
96 
97         allowances[msg.sender][spender] = amount;
98 
99         emit Approval(msg.sender, spender, amount);
100         return true;
101     }
102 
103     /**
104      * @notice Triggers an approval from owner to spends
105      * @param owner The address to approve from
106      * @param spender The address to be approved
107      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
108      * @param deadline The time at which to expire the signature
109      * @param v The recovery byte of the signature
110      * @param r Half of the ECDSA signature pair
111      * @param s Half of the ECDSA signature pair
112      */
113     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
114         uint96 amount;
115         if (rawAmount == uint(-1)) {
116             amount = uint96(-1);
117         } else {
118             amount = safe96(rawAmount, "Comfi::permit: amount exceeds 96 bits");
119         }
120 
121         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
122         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
123         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
124         address signatory = ecrecover(digest, v, r, s);
125         require(signatory != address(0), "Comfi::permit: invalid signature");
126         require(signatory == owner, "Comfi::permit: unauthorized");
127         require(now <= deadline, "Comfi::permit: signature expired");
128 
129         allowances[owner][spender] = amount;
130 
131         emit Approval(owner, spender, amount);
132     }
133 
134     /**
135      * @notice Get the number of tokens held by the `account`
136      * @param account The address of the account to get the balance of
137      * @return The number of tokens held
138      */
139     function balanceOf(address account) external view returns (uint) {
140         return balances[account];
141     }
142 
143     /**
144      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
145      * @param dst The address of the destination account
146      * @param rawAmount The number of tokens to transfer
147      * @return Whether or not the transfer succeeded
148      */
149     function transfer(address dst, uint rawAmount) external returns (bool) {
150         uint96 amount = safe96(rawAmount, "Comfi::transfer: amount exceeds 96 bits");
151         _transferTokens(msg.sender, dst, amount);
152         return true;
153     }
154 
155     /**
156      * @notice Transfer `amount` tokens from `src` to `dst`
157      * @param src The address of the source account
158      * @param dst The address of the destination account
159      * @param rawAmount The number of tokens to transfer
160      * @return Whether or not the transfer succeeded
161      */
162     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
163         address spender = msg.sender;
164         uint96 spenderAllowance = allowances[src][spender];
165         uint96 amount = safe96(rawAmount, "Comfi::approve: amount exceeds 96 bits");
166 
167         if (spender != src && spenderAllowance != uint96(-1)) {
168             uint96 newAllowance = sub96(spenderAllowance, amount, "Comfi::transferFrom: transfer amount exceeds spender allowance");
169             allowances[src][spender] = newAllowance;
170 
171             emit Approval(src, spender, newAllowance);
172         }
173 
174         _transferTokens(src, dst, amount);
175         return true;
176     }
177 
178     /**
179      * @notice Delegate votes from `msg.sender` to `delegatee`
180      * @param delegatee The address to delegate votes to
181      */
182     function delegate(address delegatee) public {
183         return _delegate(msg.sender, delegatee);
184     }
185 
186     /**
187      * @notice Delegates votes from signatory to `delegatee`
188      * @param delegatee The address to delegate votes to
189      * @param nonce The contract state required to match the signature
190      * @param expiry The time at which to expire the signature
191      * @param v The recovery byte of the signature
192      * @param r Half of the ECDSA signature pair
193      * @param s Half of the ECDSA signature pair
194      */
195     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
196         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
197         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
198         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
199         address signatory = ecrecover(digest, v, r, s);
200         require(signatory != address(0), "Comfi::delegateBySig: invalid signature");
201         require(nonce == nonces[signatory]++, "Comfi::delegateBySig: invalid nonce");
202         require(now <= expiry, "Comfi::delegateBySig: signature expired");
203         return _delegate(signatory, delegatee);
204     }
205 
206     /**
207      * @notice Gets the current votes balance for `account`
208      * @param account The address to get votes balance
209      * @return The number of current votes for `account`
210      */
211     function getCurrentVotes(address account) external view returns (uint96) {
212         uint32 nCheckpoints = numCheckpoints[account];
213         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
214     }
215 
216     /**
217      * @notice Determine the prior number of votes for an account as of a block number
218      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
219      * @param account The address of the account to check
220      * @param blockNumber The block number to get the vote balance at
221      * @return The number of votes the account had as of the given block
222      */
223     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
224         require(blockNumber < block.number, "Comfi::getPriorVotes: not yet determined");
225 
226         uint32 nCheckpoints = numCheckpoints[account];
227         if (nCheckpoints == 0) {
228             return 0;
229         }
230 
231         // First check most recent balance
232         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
233             return checkpoints[account][nCheckpoints - 1].votes;
234         }
235 
236         // Next check implicit zero balance
237         if (checkpoints[account][0].fromBlock > blockNumber) {
238             return 0;
239         }
240 
241         uint32 lower = 0;
242         uint32 upper = nCheckpoints - 1;
243         while (upper > lower) {
244             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
245             Checkpoint memory cp = checkpoints[account][center];
246             if (cp.fromBlock == blockNumber) {
247                 return cp.votes;
248             } else if (cp.fromBlock < blockNumber) {
249                 lower = center;
250             } else {
251                 upper = center - 1;
252             }
253         }
254         return checkpoints[account][lower].votes;
255     }
256 
257     function _delegate(address delegator, address delegatee) internal {
258         address currentDelegate = delegates[delegator];
259         uint96 delegatorBalance = balances[delegator];
260         delegates[delegator] = delegatee;
261 
262         emit DelegateChanged(delegator, currentDelegate, delegatee);
263 
264         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
265     }
266 
267     function _transferTokens(address src, address dst, uint96 amount) internal {
268         require(src != address(0), "Comfi::_transferTokens: cannot transfer from the zero address");
269         require(dst != address(0), "Comfi::_transferTokens: cannot transfer to the zero address");
270 
271         balances[src] = sub96(balances[src], amount, "Comfi::_transferTokens: transfer amount exceeds balance");
272         balances[dst] = add96(balances[dst], amount, "Comfi::_transferTokens: transfer amount overflows");
273         emit Transfer(src, dst, amount);
274 
275         _moveDelegates(delegates[src], delegates[dst], amount);
276     }
277 
278     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
279         if (srcRep != dstRep && amount > 0) {
280             if (srcRep != address(0)) {
281                 uint32 srcRepNum = numCheckpoints[srcRep];
282                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
283                 uint96 srcRepNew = sub96(srcRepOld, amount, "Comfi::_moveVotes: vote amount underflows");
284                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
285             }
286 
287             if (dstRep != address(0)) {
288                 uint32 dstRepNum = numCheckpoints[dstRep];
289                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
290                 uint96 dstRepNew = add96(dstRepOld, amount, "Comfi::_moveVotes: vote amount overflows");
291                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
292             }
293         }
294     }
295 
296     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
297         uint32 blockNumber = safe32(block.number, "Comfi::_writeCheckpoint: block number exceeds 32 bits");
298 
299         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
300             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
301         } else {
302             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
303             numCheckpoints[delegatee] = nCheckpoints + 1;
304         }
305 
306         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
307     }
308 
309     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
310         require(n < 2**32, errorMessage);
311         return uint32(n);
312     }
313 
314     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
315         require(n < 2**96, errorMessage);
316         return uint96(n);
317     }
318 
319     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
320         uint96 c = a + b;
321         require(c >= a, errorMessage);
322         return c;
323     }
324 
325     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
326         require(b <= a, errorMessage);
327         return a - b;
328     }
329 
330     function getChainId() internal pure returns (uint) {
331         uint256 chainId;
332         assembly { chainId := chainid() }
333         return chainId;
334     }
335 }