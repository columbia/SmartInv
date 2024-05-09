1 // File: contracts/Governance/Comp.sol
2 
3 pragma solidity ^0.5.16;
4 pragma experimental ABIEncoderV2;
5 
6 contract Comp {
7     /// @notice EIP-20 token name for this token
8     string public constant name = "OPEN Governance Token";
9 
10     /// @notice EIP-20 token symbol for this token
11     string public constant symbol = "OPEN";
12 
13     /// @notice EIP-20 token decimals for this token
14     uint8 public constant decimals = 18;
15 
16     /// @notice Total number of tokens in circulation
17     uint public constant totalSupply = 100000000e18; // 100 million OPEN
18 
19     /// @notice Allowance amounts on behalf of others
20     mapping (address => mapping (address => uint96)) internal allowances;
21 
22     /// @notice Official record of token balances for each account
23     mapping (address => uint96) internal balances;
24 
25     /// @notice A record of each accounts delegate
26     mapping (address => address) public delegates;
27 
28     /// @notice A checkpoint for marking number of votes from a given block
29     struct Checkpoint {
30         uint32 fromBlock;
31         uint96 votes;
32     }
33 
34     /// @notice A record of votes checkpoints for each account, by index
35     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
36 
37     /// @notice The number of checkpoints for each account
38     mapping (address => uint32) public numCheckpoints;
39 
40     /// @notice The EIP-712 typehash for the contract's domain
41     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
42 
43     /// @notice The EIP-712 typehash for the delegation struct used by the contract
44     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
45 
46     /// @notice A record of states for signing / validating signatures
47     mapping (address => uint) public nonces;
48 
49     /// @notice An event thats emitted when an account changes its delegate
50     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
51 
52     /// @notice An event thats emitted when a delegate account's vote balance changes
53     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
54 
55     /// @notice The standard EIP-20 transfer event
56     event Transfer(address indexed from, address indexed to, uint256 amount);
57 
58     /// @notice The standard EIP-20 approval event
59     event Approval(address indexed owner, address indexed spender, uint256 amount);
60 
61     /**
62      * @notice Construct a new Comp token
63      * @param account The initial account to grant all the tokens
64      */
65     constructor(address account) public {
66         balances[account] = uint96(totalSupply);
67         emit Transfer(address(0), account, totalSupply);
68     }
69 
70     /**
71      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
72      * @param account The address of the account holding the funds
73      * @param spender The address of the account spending the funds
74      * @return The number of tokens approved
75      */
76     function allowance(address account, address spender) external view returns (uint) {
77         return allowances[account][spender];
78     }
79 
80     /**
81      * @notice Approve `spender` to transfer up to `amount` from `src`
82      * @dev This will overwrite the approval amount for `spender`
83      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
84      * @param spender The address of the account which may transfer tokens
85      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
86      * @return Whether or not the approval succeeded
87      */
88     function approve(address spender, uint rawAmount) external returns (bool) {
89         uint96 amount;
90         if (rawAmount == uint(-1)) {
91             amount = uint96(-1);
92         } else {
93             amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
94         }
95 
96         allowances[msg.sender][spender] = amount;
97 
98         emit Approval(msg.sender, spender, amount);
99         return true;
100     }
101 
102     /**
103      * @notice Get the number of tokens held by the `account`
104      * @param account The address of the account to get the balance of
105      * @return The number of tokens held
106      */
107     function balanceOf(address account) external view returns (uint) {
108         return balances[account];
109     }
110 
111     /**
112      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
113      * @param dst The address of the destination account
114      * @param rawAmount The number of tokens to transfer
115      * @return Whether or not the transfer succeeded
116      */
117     function transfer(address dst, uint rawAmount) external returns (bool) {
118         uint96 amount = safe96(rawAmount, "Comp::transfer: amount exceeds 96 bits");
119         _transferTokens(msg.sender, dst, amount);
120         return true;
121     }
122 
123     /**
124      * @notice Transfer `amount` tokens from `src` to `dst`
125      * @param src The address of the source account
126      * @param dst The address of the destination account
127      * @param rawAmount The number of tokens to transfer
128      * @return Whether or not the transfer succeeded
129      */
130     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
131         address spender = msg.sender;
132         uint96 spenderAllowance = allowances[src][spender];
133         uint96 amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
134 
135         if (spender != src && spenderAllowance != uint96(-1)) {
136             uint96 newAllowance = sub96(spenderAllowance, amount, "Comp::transferFrom: transfer amount exceeds spender allowance");
137             allowances[src][spender] = newAllowance;
138 
139             emit Approval(src, spender, newAllowance);
140         }
141 
142         _transferTokens(src, dst, amount);
143         return true;
144     }
145 
146     /**
147      * @notice Delegate votes from `msg.sender` to `delegatee`
148      * @param delegatee The address to delegate votes to
149      */
150     function delegate(address delegatee) public {
151         return _delegate(msg.sender, delegatee);
152     }
153 
154     /**
155      * @notice Delegates votes from signatory to `delegatee`
156      * @param delegatee The address to delegate votes to
157      * @param nonce The contract state required to match the signature
158      * @param expiry The time at which to expire the signature
159      * @param v The recovery byte of the signature
160      * @param r Half of the ECDSA signature pair
161      * @param s Half of the ECDSA signature pair
162      */
163     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
164         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
165         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
166         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
167         address signatory = ecrecover(digest, v, r, s);
168         require(signatory != address(0), "Comp::delegateBySig: invalid signature");
169         require(nonce == nonces[signatory]++, "Comp::delegateBySig: invalid nonce");
170         require(now <= expiry, "Comp::delegateBySig: signature expired");
171         return _delegate(signatory, delegatee);
172     }
173 
174     /**
175      * @notice Gets the current votes balance for `account`
176      * @param account The address to get votes balance
177      * @return The number of current votes for `account`
178      */
179     function getCurrentVotes(address account) external view returns (uint96) {
180         uint32 nCheckpoints = numCheckpoints[account];
181         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
182     }
183 
184     /**
185      * @notice Determine the prior number of votes for an account as of a block number
186      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
187      * @param account The address of the account to check
188      * @param blockNumber The block number to get the vote balance at
189      * @return The number of votes the account had as of the given block
190      */
191     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
192         require(blockNumber < block.number, "Comp::getPriorVotes: not yet determined");
193 
194         uint32 nCheckpoints = numCheckpoints[account];
195         if (nCheckpoints == 0) {
196             return 0;
197         }
198 
199         // First check most recent balance
200         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
201             return checkpoints[account][nCheckpoints - 1].votes;
202         }
203 
204         // Next check implicit zero balance
205         if (checkpoints[account][0].fromBlock > blockNumber) {
206             return 0;
207         }
208 
209         uint32 lower = 0;
210         uint32 upper = nCheckpoints - 1;
211         while (upper > lower) {
212             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
213             Checkpoint memory cp = checkpoints[account][center];
214             if (cp.fromBlock == blockNumber) {
215                 return cp.votes;
216             } else if (cp.fromBlock < blockNumber) {
217                 lower = center;
218             } else {
219                 upper = center - 1;
220             }
221         }
222         return checkpoints[account][lower].votes;
223     }
224 
225     function _delegate(address delegator, address delegatee) internal {
226         address currentDelegate = delegates[delegator];
227         uint96 delegatorBalance = balances[delegator];
228         delegates[delegator] = delegatee;
229 
230         emit DelegateChanged(delegator, currentDelegate, delegatee);
231 
232         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
233     }
234 
235     function _transferTokens(address src, address dst, uint96 amount) internal {
236         require(src != address(0), "Comp::_transferTokens: cannot transfer from the zero address");
237         require(dst != address(0), "Comp::_transferTokens: cannot transfer to the zero address");
238 
239         balances[src] = sub96(balances[src], amount, "Comp::_transferTokens: transfer amount exceeds balance");
240         balances[dst] = add96(balances[dst], amount, "Comp::_transferTokens: transfer amount overflows");
241         emit Transfer(src, dst, amount);
242 
243         _moveDelegates(delegates[src], delegates[dst], amount);
244     }
245 
246     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
247         if (srcRep != dstRep && amount > 0) {
248             if (srcRep != address(0)) {
249                 uint32 srcRepNum = numCheckpoints[srcRep];
250                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
251                 uint96 srcRepNew = sub96(srcRepOld, amount, "Comp::_moveVotes: vote amount underflows");
252                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
253             }
254 
255             if (dstRep != address(0)) {
256                 uint32 dstRepNum = numCheckpoints[dstRep];
257                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
258                 uint96 dstRepNew = add96(dstRepOld, amount, "Comp::_moveVotes: vote amount overflows");
259                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
260             }
261         }
262     }
263 
264     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
265       uint32 blockNumber = safe32(block.number, "Comp::_writeCheckpoint: block number exceeds 32 bits");
266 
267       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
268           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
269       } else {
270           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
271           numCheckpoints[delegatee] = nCheckpoints + 1;
272       }
273 
274       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
275     }
276 
277     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
278         require(n < 2**32, errorMessage);
279         return uint32(n);
280     }
281 
282     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
283         require(n < 2**96, errorMessage);
284         return uint96(n);
285     }
286 
287     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
288         uint96 c = a + b;
289         require(c >= a, errorMessage);
290         return c;
291     }
292 
293     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
294         require(b <= a, errorMessage);
295         return a - b;
296     }
297 
298     function getChainId() internal pure returns (uint) {
299         uint256 chainId;
300         assembly { chainId := chainid() }
301         return chainId;
302     }
303 }