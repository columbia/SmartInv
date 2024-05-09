1 // File: contracts/FuelToken.sol
2 
3 pragma solidity ^0.5.16;
4 pragma experimental ABIEncoderV2;
5 
6 // Copyright 2020 Compound Labs, Inc.
7 // Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
8 // 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
9 // 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
10 // 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
11 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
12 
13 contract FuelToken {
14     /// @notice EIP-20 token name for this token
15     string public constant name = "PowerTrade Fuel Token";
16 
17     /// @notice EIP-20 token symbol for this token
18     string public constant symbol = "PTF";
19 
20     /// @notice EIP-20 token decimals for this token
21     uint8 public constant decimals = 18;
22 
23     /// @notice Total number of tokens in circulation
24     uint public totalSupply;
25 
26     /// @notice Minter address
27     address public minter;
28 
29     /// @notice Allowance amounts on behalf of others
30     mapping (address => mapping (address => uint96)) internal allowances;
31 
32     /// @notice Official record of token balances for each account
33     mapping (address => uint96) internal balances;
34 
35     /// @notice A record of each accounts delegate
36     mapping (address => address) public delegates;
37 
38     /// @notice A checkpoint for marking number of votes from a given block
39     struct Checkpoint {
40         uint32 fromBlock;
41         uint96 votes;
42     }
43 
44     /// @notice A record of votes checkpoints for each account, by index
45     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
46 
47     /// @notice The number of checkpoints for each account
48     mapping (address => uint32) public numCheckpoints;
49 
50     /// @notice The EIP-712 typehash for the contract's domain
51     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
52 
53     /// @notice The EIP-712 typehash for the delegation struct used by the contract
54     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
55 
56     /// @notice A record of states for signing / validating signatures
57     mapping (address => uint) public nonces;
58 
59     /// @notice An event thats emitted when an account changes its delegate
60     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
61 
62     /// @notice An event thats emitted when a delegate account's vote balance changes
63     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
64 
65     /// @notice The standard EIP-20 transfer event
66     event Transfer(address indexed from, address indexed to, uint256 amount);
67 
68     /// @notice The standard EIP-20 approval event
69     event Approval(address indexed owner, address indexed spender, uint256 amount);
70 
71     /// @notice An event thats emitted when the minter is changed
72     event NewMinter(address minter);
73 
74     modifier onlyMinter {
75         require(msg.sender == minter, "FuelToken:onlyMinter: should only be called by minter");
76         _;
77     }
78 
79     /**
80      * @notice Construct a new Fuel token
81      * @param initialSupply The initial supply minted at deployment
82      * @param account The initial account to grant all the tokens
83      */
84     constructor(uint initialSupply, address account, address _minter) public {
85         totalSupply = safe96(initialSupply, "FuelToken::constructor:amount exceeds 96 bits");
86         balances[account] = uint96(initialSupply);
87         minter = _minter;
88         emit Transfer(address(0), account, initialSupply);
89     }
90 
91     /**
92      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
93      * @param account The address of the account holding the funds
94      * @param spender The address of the account spending the funds
95      * @return The number of tokens approved
96      */
97     function allowance(address account, address spender) external view returns (uint) {
98         return allowances[account][spender];
99     }
100 
101     /**
102      * @notice Approve `spender` to transfer up to `amount` from `src`
103      * @dev This will overwrite the approval amount for `spender`
104      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
105      * @param spender The address of the account which may transfer tokens
106      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
107      * @return Whether or not the approval succeeded
108      */
109     function approve(address spender, uint rawAmount) external returns (bool) {
110         uint96 amount;
111         if (rawAmount == uint(-1)) {
112             amount = uint96(-1);
113         } else {
114             amount = safe96(rawAmount, "FuelToken::approve: amount exceeds 96 bits");
115         }
116 
117         allowances[msg.sender][spender] = amount;
118 
119         emit Approval(msg.sender, spender, amount);
120         return true;
121     }
122 
123     /**
124      * @notice Get the number of tokens held by the `account`
125      * @param account The address of the account to get the balance of
126      * @return The number of tokens held
127      */
128     function balanceOf(address account) external view returns (uint) {
129         return balances[account];
130     }
131 
132     /**
133      * @notice Mint `amount` tokens to `dst`
134      * @param dst The address of the destination account
135      * @param rawAmount The number of tokens to mint
136      * @notice only callable by minter
137      */
138     function mint(address dst, uint rawAmount) external onlyMinter {
139         uint96 amount = safe96(rawAmount, "FuelToken::mint: amount exceeds 96 bits");
140         _mintTokens(dst, amount);
141     }
142 
143     /**
144      * @notice Burn `amount` tokens
145      * @param rawAmount The number of tokens to burn
146      */
147     function burn(uint rawAmount) external {
148         uint96 amount = safe96(rawAmount, "FuelToken::burn: amount exceeds 96 bits");
149         _burnTokens(msg.sender, amount);
150     }
151 
152     /**
153      * @notice Change minter address to `account`
154      * @param account The address of the new minter
155      * @notice only callable by minter
156      */
157     function changeMinter(address account) external onlyMinter {
158         minter = account;
159         emit NewMinter(account);
160     }
161 
162     /**
163      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
164      * @param dst The address of the destination account
165      * @param rawAmount The number of tokens to transfer
166      * @return Whether or not the transfer succeeded
167      */
168     function transfer(address dst, uint rawAmount) external returns (bool) {
169         uint96 amount = safe96(rawAmount, "FuelToken::transfer: amount exceeds 96 bits");
170         _transferTokens(msg.sender, dst, amount);
171         return true;
172     }
173 
174     /**
175      * @notice Transfer `amount` tokens from `src` to `dst`
176      * @param src The address of the source account
177      * @param dst The address of the destination account
178      * @param rawAmount The number of tokens to transfer
179      * @return Whether or not the transfer succeeded
180      */
181     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
182         address spender = msg.sender;
183         uint96 spenderAllowance = allowances[src][spender];
184         uint96 amount = safe96(rawAmount, "FuelToken::approve: amount exceeds 96 bits");
185 
186         if (spender != src && spenderAllowance != uint96(-1)) {
187             uint96 newAllowance = sub96(spenderAllowance, amount, "FuelToken::transferFrom: transfer amount exceeds spender allowance");
188             allowances[src][spender] = newAllowance;
189 
190             emit Approval(src, spender, newAllowance);
191         }
192 
193         _transferTokens(src, dst, amount);
194         return true;
195     }
196 
197     /**
198      * @notice Delegate votes from `msg.sender` to `delegatee`
199      * @param delegatee The address to delegate votes to
200      */
201     function delegate(address delegatee) public {
202         return _delegate(msg.sender, delegatee);
203     }
204 
205     /**
206      * @notice Delegates votes from signatory to `delegatee`
207      * @param delegatee The address to delegate votes to
208      * @param nonce The contract state required to match the signature
209      * @param expiry The time at which to expire the signature
210      * @param v The recovery byte of the signature
211      * @param r Half of the ECDSA signature pair
212      * @param s Half of the ECDSA signature pair
213      */
214     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
215         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
216         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
217         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
218         address signatory = ecrecover(digest, v, r, s);
219         require(signatory != address(0), "FuelToken::delegateBySig: invalid signature");
220         require(nonce == nonces[signatory]++, "FuelToken::delegateBySig: invalid nonce");
221         require(now <= expiry, "FuelToken::delegateBySig: signature expired");
222         return _delegate(signatory, delegatee);
223     }
224 
225     /**
226      * @notice Gets the current votes balance for `account`
227      * @param account The address to get votes balance
228      * @return The number of current votes for `account`
229      */
230     function getCurrentVotes(address account) external view returns (uint96) {
231         uint32 nCheckpoints = numCheckpoints[account];
232         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
233     }
234 
235     /**
236      * @notice Determine the prior number of votes for an account as of a block number
237      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
238      * @param account The address of the account to check
239      * @param blockNumber The block number to get the vote balance at
240      * @return The number of votes the account had as of the given block
241      */
242     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
243         require(blockNumber < block.number, "FuelToken::getPriorVotes: not yet determined");
244 
245         uint32 nCheckpoints = numCheckpoints[account];
246         if (nCheckpoints == 0) {
247             return 0;
248         }
249 
250         // First check most recent balance
251         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
252             return checkpoints[account][nCheckpoints - 1].votes;
253         }
254 
255         // Next check implicit zero balance
256         if (checkpoints[account][0].fromBlock > blockNumber) {
257             return 0;
258         }
259 
260         uint32 lower = 0;
261         uint32 upper = nCheckpoints - 1;
262         while (upper > lower) {
263             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
264             Checkpoint memory cp = checkpoints[account][center];
265             if (cp.fromBlock == blockNumber) {
266                 return cp.votes;
267             } else if (cp.fromBlock < blockNumber) {
268                 lower = center;
269             } else {
270                 upper = center - 1;
271             }
272         }
273         return checkpoints[account][lower].votes;
274     }
275 
276     function _delegate(address delegator, address delegatee) internal {
277         address currentDelegate = delegates[delegator];
278         uint96 delegatorBalance = balances[delegator];
279         delegates[delegator] = delegatee;
280 
281         emit DelegateChanged(delegator, currentDelegate, delegatee);
282 
283         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
284     }
285 
286     function _transferTokens(address src, address dst, uint96 amount) internal {
287         require(src != address(0), "FuelToken::_transferTokens: cannot transfer from the zero address");
288         require(dst != address(0), "FuelToken::_transferTokens: cannot transfer to the zero address");
289 
290         balances[src] = sub96(balances[src], amount, "FuelToken::_transferTokens: transfer amount exceeds balance");
291         balances[dst] = add96(balances[dst], amount, "FuelToken::_transferTokens: transfer amount overflows");
292         emit Transfer(src, dst, amount);
293 
294         _moveDelegates(delegates[src], delegates[dst], amount);
295     }
296 
297     function _mintTokens(address dst, uint96 amount) internal {
298         require(dst != address(0), "FuelToken::_mintTokens: cannot transfer to the zero address");
299         uint96 supply = safe96(totalSupply, "FuelToken::_mintTokens: totalSupply exceeds 96 bits");
300         totalSupply = add96(supply, amount, "FuelToken::_mintTokens: totalSupply exceeds 96 bits");
301         balances[dst] = add96(balances[dst], amount, "FuelToken::_mintTokens: transfer amount overflows");
302         emit Transfer(address(0), dst, amount);
303 
304         _moveDelegates(address(0), delegates[dst], amount);
305     }
306 
307     function _burnTokens(address src, uint96 amount) internal {
308         uint96 supply = safe96(totalSupply, "FuelToken::_burnTokens: totalSupply exceeds 96 bits");
309         totalSupply = sub96(supply, amount, "FuelToken::_burnTokens:totalSupply underflow");
310         balances[src] = sub96(balances[src], amount, "FuelToken::_burnTokens: amount overflows");
311         emit Transfer(src, address(0), amount);
312 
313         _moveDelegates(delegates[src], address(0), amount);
314     }
315 
316     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
317         if (srcRep != dstRep && amount > 0) {
318             if (srcRep != address(0)) {
319                 uint32 srcRepNum = numCheckpoints[srcRep];
320                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
321                 uint96 srcRepNew = sub96(srcRepOld, amount, "FuelToken::_moveVotes: vote amount underflows");
322                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
323             }
324 
325             if (dstRep != address(0)) {
326                 uint32 dstRepNum = numCheckpoints[dstRep];
327                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
328                 uint96 dstRepNew = add96(dstRepOld, amount, "FuelToken::_moveVotes: vote amount overflows");
329                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
330             }
331         }
332     }
333 
334     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
335       uint32 blockNumber = safe32(block.number, "FuelToken::_writeCheckpoint: block number exceeds 32 bits");
336 
337       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
338           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
339       } else {
340           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
341           numCheckpoints[delegatee] = nCheckpoints + 1;
342       }
343 
344       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
345     }
346 
347     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
348         require(n < 2**32, errorMessage);
349         return uint32(n);
350     }
351 
352     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
353         require(n < 2**96, errorMessage);
354         return uint96(n);
355     }
356 
357     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
358         uint96 c = a + b;
359         require(c >= a, errorMessage);
360         return c;
361     }
362 
363     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
364         require(b <= a, errorMessage);
365         return a - b;
366     }
367 
368     function getChainId() internal pure returns (uint) {
369         uint256 chainId;
370         assembly { chainId := chainid() }
371         return chainId;
372     }
373 }