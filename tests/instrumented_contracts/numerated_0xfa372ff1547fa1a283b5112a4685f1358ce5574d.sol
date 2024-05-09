1 // SPDX-License-Identifier: BSD-3-Clause
2 pragma solidity ^0.8.10;
3 
4 contract Comp {
5   /// @notice EIP-20 token name for this token
6   string public constant name = "Bonded dAMM";
7 
8   /// @notice EIP-20 token symbol for this token
9   string public constant symbol = "BDAMM";
10 
11   /// @notice EIP-20 token decimals for this token
12   uint8 public constant decimals = 18;
13 
14   /// @notice Total number of tokens in circulation
15   uint256 public constant totalSupply = 250000000e18; // 250 million bdAMM
16 
17   /// @notice Allowance amounts on behalf of others
18   mapping(address => mapping(address => uint96)) internal allowances;
19 
20   /// @notice Official record of token balances for each account
21   mapping(address => uint96) internal balances;
22 
23   /// @notice A record of each accounts delegate
24   mapping(address => address) public delegates;
25 
26   /// @notice A checkpoint for marking number of votes from a given block
27   struct Checkpoint {
28     uint32 fromBlock;
29     uint96 votes;
30   }
31 
32   /// @notice A record of votes checkpoints for each account, by index
33   mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
34 
35   /// @notice The number of checkpoints for each account
36   mapping(address => uint32) public numCheckpoints;
37 
38   /// @notice The EIP-712 typehash for the contract's domain
39   bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
40 
41   /// @notice The EIP-712 typehash for the delegation struct used by the contract
42   bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
43 
44   /// @notice A record of states for signing / validating signatures
45   mapping(address => uint256) public nonces;
46 
47   /// @notice An event thats emitted when an account changes its delegate
48   event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
49 
50   /// @notice An event thats emitted when a delegate account's vote balance changes
51   event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
52 
53   /// @notice The standard EIP-20 transfer event
54   event Transfer(address indexed from, address indexed to, uint256 amount);
55 
56   /// @notice The standard EIP-20 approval event
57   event Approval(address indexed owner, address indexed spender, uint256 amount);
58 
59   /**
60    * @notice Construct a new Comp token
61    * @param account The initial account to grant all the tokens
62    */
63   constructor(address account) public {
64     balances[account] = uint96(totalSupply);
65     emit Transfer(address(0), account, totalSupply);
66   }
67 
68   /**
69    * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
70    * @param account The address of the account holding the funds
71    * @param spender The address of the account spending the funds
72    * @return The number of tokens approved
73    */
74   function allowance(address account, address spender) external view returns (uint256) {
75     return allowances[account][spender];
76   }
77 
78   /**
79    * @notice Approve `spender` to transfer up to `amount` from `src`
80    * @dev This will overwrite the approval amount for `spender`
81    *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
82    * @param spender The address of the account which may transfer tokens
83    * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
84    * @return Whether or not the approval succeeded
85    */
86   function approve(address spender, uint256 rawAmount) external returns (bool) {
87     uint96 amount;
88     if (rawAmount == type(uint256).max) {
89       amount = type(uint96).max;
90     } else {
91       amount = safe96(rawAmount, "BDAMM::approve: amount exceeds 96 bits");
92     }
93 
94     allowances[msg.sender][spender] = amount;
95 
96     emit Approval(msg.sender, spender, amount);
97     return true;
98   }
99 
100   /**
101    * @notice Get the number of tokens held by the `account`
102    * @param account The address of the account to get the balance of
103    * @return The number of tokens held
104    */
105   function balanceOf(address account) external view returns (uint256) {
106     return balances[account];
107   }
108 
109   /**
110    * @notice Transfer `amount` tokens from `msg.sender` to `dst`
111    * @param dst The address of the destination account
112    * @param rawAmount The number of tokens to transfer
113    * @return Whether or not the transfer succeeded
114    */
115   function transfer(address dst, uint256 rawAmount) external returns (bool) {
116     uint96 amount = safe96(rawAmount, "BDAMM::transfer: amount exceeds 96 bits");
117     _transferTokens(msg.sender, dst, amount);
118     return true;
119   }
120 
121   /**
122    * @notice Transfer `amount` tokens from `src` to `dst`
123    * @param src The address of the source account
124    * @param dst The address of the destination account
125    * @param rawAmount The number of tokens to transfer
126    * @return Whether or not the transfer succeeded
127    */
128   function transferFrom(
129     address src,
130     address dst,
131     uint256 rawAmount
132   ) external returns (bool) {
133     address spender = msg.sender;
134     uint96 spenderAllowance = allowances[src][spender];
135     uint96 amount = safe96(rawAmount, "BDAMM::approve: amount exceeds 96 bits");
136 
137     if (spender != src && spenderAllowance != type(uint96).max) {
138       uint96 newAllowance = sub96(spenderAllowance, amount, "BDAMM::transferFrom: transfer amount exceeds spender allowance");
139       allowances[src][spender] = newAllowance;
140 
141       emit Approval(src, spender, newAllowance);
142     }
143 
144     _transferTokens(src, dst, amount);
145     return true;
146   }
147 
148   /**
149    * @notice Delegate votes from `msg.sender` to `delegatee`
150    * @param delegatee The address to delegate votes to
151    */
152   function delegate(address delegatee) public {
153     return _delegate(msg.sender, delegatee);
154   }
155 
156   /**
157    * @notice Delegates votes from signatory to `delegatee`
158    * @param delegatee The address to delegate votes to
159    * @param nonce The contract state required to match the signature
160    * @param expiry The time at which to expire the signature
161    * @param v The recovery byte of the signature
162    * @param r Half of the ECDSA signature pair
163    * @param s Half of the ECDSA signature pair
164    */
165   function delegateBySig(
166     address delegatee,
167     uint256 nonce,
168     uint256 expiry,
169     uint8 v,
170     bytes32 r,
171     bytes32 s
172   ) public {
173     bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
174     bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
175     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
176     address signatory = ecrecover(digest, v, r, s);
177     require(signatory != address(0), "BDAMM::delegateBySig: invalid signature");
178     require(nonce == nonces[signatory]++, "BDAMM::delegateBySig: invalid nonce");
179     require(block.timestamp <= expiry, "BDAMM::delegateBySig: signature expired");
180     return _delegate(signatory, delegatee);
181   }
182 
183   /**
184    * @notice Gets the current votes balance for `account`
185    * @param account The address to get votes balance
186    * @return The number of current votes for `account`
187    */
188   function getCurrentVotes(address account) external view returns (uint96) {
189     uint32 nCheckpoints = numCheckpoints[account];
190     return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
191   }
192 
193   /**
194    * @notice Determine the prior number of votes for an account as of a block number
195    * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
196    * @param account The address of the account to check
197    * @param blockNumber The block number to get the vote balance at
198    * @return The number of votes the account had as of the given block
199    */
200   function getPriorVotes(address account, uint256 blockNumber) public view returns (uint96) {
201     require(blockNumber < block.number, "BDAMM::getPriorVotes: not yet determined");
202 
203     uint32 nCheckpoints = numCheckpoints[account];
204     if (nCheckpoints == 0) {
205       return 0;
206     }
207 
208     // First check most recent balance
209     if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
210       return checkpoints[account][nCheckpoints - 1].votes;
211     }
212 
213     // Next check implicit zero balance
214     if (checkpoints[account][0].fromBlock > blockNumber) {
215       return 0;
216     }
217 
218     uint32 lower = 0;
219     uint32 upper = nCheckpoints - 1;
220     while (upper > lower) {
221       uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
222       Checkpoint memory cp = checkpoints[account][center];
223       if (cp.fromBlock == blockNumber) {
224         return cp.votes;
225       } else if (cp.fromBlock < blockNumber) {
226         lower = center;
227       } else {
228         upper = center - 1;
229       }
230     }
231     return checkpoints[account][lower].votes;
232   }
233 
234   function _delegate(address delegator, address delegatee) internal {
235     address currentDelegate = delegates[delegator];
236     uint96 delegatorBalance = balances[delegator];
237     delegates[delegator] = delegatee;
238 
239     emit DelegateChanged(delegator, currentDelegate, delegatee);
240 
241     _moveDelegates(currentDelegate, delegatee, delegatorBalance);
242   }
243 
244   function _transferTokens(
245     address src,
246     address dst,
247     uint96 amount
248   ) internal {
249     require(src != address(0), "BDAMM::_transferTokens: cannot transfer from the zero address");
250     require(dst != address(0), "BDAMM::_transferTokens: cannot transfer to the zero address");
251 
252     balances[src] = sub96(balances[src], amount, "BDAMM::_transferTokens: transfer amount exceeds balance");
253     balances[dst] = add96(balances[dst], amount, "BDAMM::_transferTokens: transfer amount overflows");
254     emit Transfer(src, dst, amount);
255 
256     _moveDelegates(delegates[src], delegates[dst], amount);
257   }
258 
259   function _moveDelegates(
260     address srcRep,
261     address dstRep,
262     uint96 amount
263   ) internal {
264     if (srcRep != dstRep && amount > 0) {
265       if (srcRep != address(0)) {
266         uint32 srcRepNum = numCheckpoints[srcRep];
267         uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
268         uint96 srcRepNew = sub96(srcRepOld, amount, "BDAMM::_moveVotes: vote amount underflows");
269         _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
270       }
271 
272       if (dstRep != address(0)) {
273         uint32 dstRepNum = numCheckpoints[dstRep];
274         uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
275         uint96 dstRepNew = add96(dstRepOld, amount, "BDAMM::_moveVotes: vote amount overflows");
276         _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
277       }
278     }
279   }
280 
281   function _writeCheckpoint(
282     address delegatee,
283     uint32 nCheckpoints,
284     uint96 oldVotes,
285     uint96 newVotes
286   ) internal {
287     uint32 blockNumber = safe32(block.number, "BDAMM::_writeCheckpoint: block number exceeds 32 bits");
288 
289     if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
290       checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
291     } else {
292       checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
293       numCheckpoints[delegatee] = nCheckpoints + 1;
294     }
295 
296     emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
297   }
298 
299   function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
300     require(n < 2**32, errorMessage);
301     return uint32(n);
302   }
303 
304   function safe96(uint256 n, string memory errorMessage) internal pure returns (uint96) {
305     require(n < 2**96, errorMessage);
306     return uint96(n);
307   }
308 
309   function add96(
310     uint96 a,
311     uint96 b,
312     string memory errorMessage
313   ) internal pure returns (uint96) {
314     uint96 c = a + b;
315     require(c >= a, errorMessage);
316     return c;
317   }
318 
319   function sub96(
320     uint96 a,
321     uint96 b,
322     string memory errorMessage
323   ) internal pure returns (uint96) {
324     require(b <= a, errorMessage);
325     return a - b;
326   }
327 
328   function getChainId() internal view returns (uint256) {
329     uint256 chainId;
330     assembly {
331       chainId := chainid()
332     }
333     return chainId;
334   }
335 }