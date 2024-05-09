1 // Official Website: percent.finance
2 
3 // File: contracts/Governance/Comp.sol
4 
5 pragma solidity ^0.5.16;
6 pragma experimental ABIEncoderV2;
7 
8 contract Comp {
9     /// @notice EIP-20 token name for this token
10     string public constant name = "Percent";
11 
12     /// @notice EIP-20 token symbol for this token
13     string public constant symbol = "PCT";
14 
15     /// @notice EIP-20 token decimals for this token
16     uint8 public constant decimals = 18;
17 
18     /// @notice Total number of tokens in circulation
19     uint public constant totalSupply = 20000000e18; // 20 million PCT
20 
21     /// @notice Allowance amounts on behalf of others
22     mapping (address => mapping (address => uint96)) internal allowances;
23 
24     /// @notice Official record of token balances for each account
25     mapping (address => uint96) internal balances;
26 
27     /// @notice A record of each accounts delegate
28     mapping (address => address) public delegates;
29 
30     /// @notice A checkpoint for marking number of votes from a given block
31     struct Checkpoint {
32         uint32 fromBlock;
33         uint96 votes;
34     }
35 
36     /// @notice A record of votes checkpoints for each account, by index
37     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
38 
39     /// @notice The number of checkpoints for each account
40     mapping (address => uint32) public numCheckpoints;
41 
42     /// @notice The EIP-712 typehash for the contract's domain
43     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
44 
45     /// @notice The EIP-712 typehash for the delegation struct used by the contract
46     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
47 
48     /// @notice A record of states for signing / validating signatures
49     mapping (address => uint) public nonces;
50 
51     /// @notice An event thats emitted when an account changes its delegate
52     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
53 
54     /// @notice An event thats emitted when a delegate account's vote balance changes
55     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
56 
57     /// @notice The standard EIP-20 transfer event
58     event Transfer(address indexed from, address indexed to, uint256 amount);
59 
60     /// @notice The standard EIP-20 approval event
61     event Approval(address indexed owner, address indexed spender, uint256 amount);
62 
63     /**
64      * @notice Construct a new Comp token
65      * @param account The initial account to grant all the tokens
66      */
67     constructor(address account) public {
68         balances[account] = uint96(totalSupply);
69         emit Transfer(address(0), account, totalSupply);
70     }
71 
72     /**
73      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
74      * @param account The address of the account holding the funds
75      * @param spender The address of the account spending the funds
76      * @return The number of tokens approved
77      */
78     function allowance(address account, address spender) external view returns (uint) {
79         return allowances[account][spender];
80     }
81 
82     /**
83      * @notice Approve `spender` to transfer up to `amount` from `src`
84      * @dev This will overwrite the approval amount for `spender`
85      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
86      * @param spender The address of the account which may transfer tokens
87      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
88      * @return Whether or not the approval succeeded
89      */
90     function approve(address spender, uint rawAmount) external returns (bool) {
91         uint96 amount;
92         if (rawAmount == uint(-1)) {
93             amount = uint96(-1);
94         } else {
95             amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
96         }
97 
98         allowances[msg.sender][spender] = amount;
99 
100         emit Approval(msg.sender, spender, amount);
101         return true;
102     }
103 
104     /**
105      * @notice Get the number of tokens held by the `account`
106      * @param account The address of the account to get the balance of
107      * @return The number of tokens held
108      */
109     function balanceOf(address account) external view returns (uint) {
110         return balances[account];
111     }
112 
113     /**
114      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
115      * @param dst The address of the destination account
116      * @param rawAmount The number of tokens to transfer
117      * @return Whether or not the transfer succeeded
118      */
119     function transfer(address dst, uint rawAmount) external returns (bool) {
120         uint96 amount = safe96(rawAmount, "Comp::transfer: amount exceeds 96 bits");
121         _transferTokens(msg.sender, dst, amount);
122         return true;
123     }
124 
125     /**
126      * @notice Transfer `amount` tokens from `src` to `dst`
127      * @param src The address of the source account
128      * @param dst The address of the destination account
129      * @param rawAmount The number of tokens to transfer
130      * @return Whether or not the transfer succeeded
131      */
132     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
133         address spender = msg.sender;
134         uint96 spenderAllowance = allowances[src][spender];
135         uint96 amount = safe96(rawAmount, "Comp::approve: amount exceeds 96 bits");
136 
137         if (spender != src && spenderAllowance != uint96(-1)) {
138             uint96 newAllowance = sub96(spenderAllowance, amount, "Comp::transferFrom: transfer amount exceeds spender allowance");
139             allowances[src][spender] = newAllowance;
140 
141             emit Approval(src, spender, newAllowance);
142         }
143 
144         _transferTokens(src, dst, amount);
145         return true;
146     }
147 
148     /**
149      * @notice Delegate votes from `msg.sender` to `delegatee`
150      * @param delegatee The address to delegate votes to
151      */
152     function delegate(address delegatee) public {
153         return _delegate(msg.sender, delegatee);
154     }
155 
156     /**
157      * @notice Delegates votes from signatory to `delegatee`
158      * @param delegatee The address to delegate votes to
159      * @param nonce The contract state required to match the signature
160      * @param expiry The time at which to expire the signature
161      * @param v The recovery byte of the signature
162      * @param r Half of the ECDSA signature pair
163      * @param s Half of the ECDSA signature pair
164      */
165     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
166         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
167         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
168         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
169         address signatory = ecrecover(digest, v, r, s);
170         require(signatory != address(0), "Comp::delegateBySig: invalid signature");
171         require(nonce == nonces[signatory]++, "Comp::delegateBySig: invalid nonce");
172         require(now <= expiry, "Comp::delegateBySig: signature expired");
173         return _delegate(signatory, delegatee);
174     }
175 
176     /**
177      * @notice Gets the current votes balance for `account`
178      * @param account The address to get votes balance
179      * @return The number of current votes for `account`
180      */
181     function getCurrentVotes(address account) external view returns (uint96) {
182         uint32 nCheckpoints = numCheckpoints[account];
183         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
184     }
185 
186     /**
187      * @notice Determine the prior number of votes for an account as of a block number
188      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
189      * @param account The address of the account to check
190      * @param blockNumber The block number to get the vote balance at
191      * @return The number of votes the account had as of the given block
192      */
193     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
194         require(blockNumber < block.number, "Comp::getPriorVotes: not yet determined");
195 
196         uint32 nCheckpoints = numCheckpoints[account];
197         if (nCheckpoints == 0) {
198             return 0;
199         }
200 
201         // First check most recent balance
202         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
203             return checkpoints[account][nCheckpoints - 1].votes;
204         }
205 
206         // Next check implicit zero balance
207         if (checkpoints[account][0].fromBlock > blockNumber) {
208             return 0;
209         }
210 
211         uint32 lower = 0;
212         uint32 upper = nCheckpoints - 1;
213         while (upper > lower) {
214             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
215             Checkpoint memory cp = checkpoints[account][center];
216             if (cp.fromBlock == blockNumber) {
217                 return cp.votes;
218             } else if (cp.fromBlock < blockNumber) {
219                 lower = center;
220             } else {
221                 upper = center - 1;
222             }
223         }
224         return checkpoints[account][lower].votes;
225     }
226 
227     function _delegate(address delegator, address delegatee) internal {
228         address currentDelegate = delegates[delegator];
229         uint96 delegatorBalance = balances[delegator];
230         delegates[delegator] = delegatee;
231 
232         emit DelegateChanged(delegator, currentDelegate, delegatee);
233 
234         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
235     }
236 
237     function _transferTokens(address src, address dst, uint96 amount) internal {
238         require(src != address(0), "Comp::_transferTokens: cannot transfer from the zero address");
239         require(dst != address(0), "Comp::_transferTokens: cannot transfer to the zero address");
240 
241         balances[src] = sub96(balances[src], amount, "Comp::_transferTokens: transfer amount exceeds balance");
242         balances[dst] = add96(balances[dst], amount, "Comp::_transferTokens: transfer amount overflows");
243         emit Transfer(src, dst, amount);
244 
245         _moveDelegates(delegates[src], delegates[dst], amount);
246     }
247 
248     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
249         if (srcRep != dstRep && amount > 0) {
250             if (srcRep != address(0)) {
251                 uint32 srcRepNum = numCheckpoints[srcRep];
252                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
253                 uint96 srcRepNew = sub96(srcRepOld, amount, "Comp::_moveVotes: vote amount underflows");
254                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
255             }
256 
257             if (dstRep != address(0)) {
258                 uint32 dstRepNum = numCheckpoints[dstRep];
259                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
260                 uint96 dstRepNew = add96(dstRepOld, amount, "Comp::_moveVotes: vote amount overflows");
261                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
262             }
263         }
264     }
265 
266     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
267       uint32 blockNumber = safe32(block.number, "Comp::_writeCheckpoint: block number exceeds 32 bits");
268 
269       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
270           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
271       } else {
272           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
273           numCheckpoints[delegatee] = nCheckpoints + 1;
274       }
275 
276       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
277     }
278 
279     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
280         require(n < 2**32, errorMessage);
281         return uint32(n);
282     }
283 
284     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
285         require(n < 2**96, errorMessage);
286         return uint96(n);
287     }
288 
289     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
290         uint96 c = a + b;
291         require(c >= a, errorMessage);
292         return c;
293     }
294 
295     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
296         require(b <= a, errorMessage);
297         return a - b;
298     }
299 
300     function getChainId() internal pure returns (uint) {
301         uint256 chainId;
302         assembly { chainId := chainid() }
303         return chainId;
304     }
305 }