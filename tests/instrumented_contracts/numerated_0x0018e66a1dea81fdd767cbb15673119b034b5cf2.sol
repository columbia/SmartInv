1 pragma solidity ^0.6.12;
2 pragma experimental ABIEncoderV2;
3 
4 abstract contract Token {
5     
6     function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
7 
8     function balanceOf(address account) external virtual view returns (uint);
9     
10 }
11 
12 contract BNSG {
13     /// @notice EIP-20 token name for this token
14     string public constant name = "BNS Governance";
15 
16     /// @notice EIP-20 token symbol for this token
17     string public constant symbol = "BNSG";
18 
19     address public bnsdAdd;
20     address public bnsAdd;
21     address public admin;
22 
23     uint96 public bnsToBNSG; // how many satoshi of BNS makes one BNSG
24     uint96 public bnsdToBNSG; // how many satoshi of BNSD makes one BNSG
25 
26     // Formula to calculate rates above, Ex - BNS rate - 0.06$, BNSG rate - 1$
27     // bnsToBNSG = (BNSG rate in USD) * (10 ** (bnsDecimals))/(BNS rate in USD) = (1e8/ 0.06) = 1666666666
28 
29     /// @notice EIP-20 token decimals for this token
30     uint8 public constant decimals = 18;
31 
32     /// @notice Total number of tokens in circulation
33     uint96 public constant maxTotalSupply = 10000000e18; // 10 million BNSG
34 
35     uint96 public totalSupply; // Starts with 0
36 
37     /// @notice Allowance amounts on behalf of others
38     mapping (address => mapping (address => uint96)) internal allowances;
39 
40     /// @notice Official record of token balances for each account
41     mapping (address => uint96) internal balances;
42 
43     /// @notice A record of each accounts delegate
44     mapping (address => address) public delegates;
45 
46     /// @notice A checkpoint for marking number of votes from a given block
47     struct Checkpoint {
48         uint32 fromBlock;
49         uint96 votes;
50     }
51 
52     /// @notice A record of votes checkpoints for each account, by index
53     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
54 
55     /// @notice The number of checkpoints for each account
56     mapping (address => uint32) public numCheckpoints;
57 
58     /// @notice The EIP-712 typehash for the contract's domain
59     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
60 
61     /// @notice The EIP-712 typehash for the delegation struct used by the contract
62     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
63 
64     /// @notice A record of states for signing / validating signatures
65     mapping (address => uint) public nonces;
66 
67     bool public rateSet;
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
81 
82     constructor() public {
83         admin = msg.sender;
84         _mint(admin, 805712895369472282718529); // Amount of token minted in version 1, will be airdropped to users
85     }
86 
87     modifier _adminOnly() {
88         require(msg.sender == admin);
89         _;
90     }
91 
92 
93     /**
94      * @notice Add bns and bnsd addresses
95      */
96     function setAddresses(address _bns, address _bnsd) external _adminOnly returns (bool) {
97         bnsAdd = _bns;
98         bnsdAdd = _bnsd;
99         return true;
100     }
101 
102     /**
103      * @notice Add rates for bns to bnsg and bnsd to bnsg
104      */
105     function setTokenRates(uint96 _bnsRate, uint96 _bnsdRate) external _adminOnly returns (bool) {
106         bnsToBNSG = _bnsRate;
107         bnsdToBNSG = _bnsdRate;
108         if(!rateSet){
109             rateSet = true;
110         }
111         return true;
112     }
113 
114     /**
115      * @notice Mint `BNSG` by buring BNS token from msg.sender based on current rates on contract
116      * @param amountToMint The number of BNSG tokens to be minted 
117      * @return Whether or not the minting succeeded
118      */
119     function mintBNSGWithBNS(uint96 amountToMint) external returns (bool) {
120         require(rateSet, "BNSG::mint: rate not yet set");
121         require(amountToMint >= 1e18, "BNSG::mint: min mint amount 1");
122         uint96 _bnsNeeded = mul96(div96(amountToMint, 1e18, "BNSG::mint: div failed"),bnsToBNSG, "BNSG::mint: mul failed");
123         require(Token(bnsAdd).balanceOf(msg.sender) >= _bnsNeeded, "BNSG::mint: insufficient BNS");
124         require(Token(bnsAdd).transferFrom(msg.sender, address(1), _bnsNeeded), "BNSG::mint: burn BNS failed");
125         _mint(msg.sender, amountToMint);
126         _moveDelegates(delegates[address(0)], delegates[msg.sender], amountToMint);
127         return true;
128     }
129 
130     /**
131      * @notice Mint `BNSG` by buring BNSD token from msg.sender based on current rates on contract
132      * @param amountToMint The number of BNSG tokens to be minted 
133      * @return Whether or not the minting succeeded
134      */
135     function mintBNSGWithBNSD(uint96 amountToMint) external returns (bool) {
136         require(rateSet, "BNSG::mint: rate not yet set");
137         require(amountToMint >= 1e18, "BNSG::mint: min mint amount 1");
138         uint96 _bnsdNeeded = mul96(div96(amountToMint, 1e18, "BNSG::mint: div failed"),bnsdToBNSG, "BNSG::mint: mul failed");
139         require(Token(bnsdAdd).balanceOf(msg.sender) >= _bnsdNeeded, "BNSG::mint: insufficient BNSD");
140         require(Token(bnsdAdd).transferFrom(msg.sender, address(1), _bnsdNeeded), "BNSG::mint: burn BNSD failed");
141         _mint(msg.sender, amountToMint);
142         _moveDelegates(delegates[address(0)], delegates[msg.sender], amountToMint);
143         return true;
144     }
145 
146 
147     function _mint(address account, uint96 amount) internal virtual {
148         require(account != address(0), "BNSG: mint to the zero address");
149         totalSupply =  add96(totalSupply, amount, "BNSG: mint amount overflow");
150         require(totalSupply <= maxTotalSupply, "BNSG: crosses total supply possible");
151         balances[account] = add96(balances[account], amount, "BNSG::_mint: transfer amount overflows");
152         emit Transfer(address(0), account, amount);
153     }
154 
155 
156     /**
157      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
158      * @param account The address of the account holding the funds
159      * @param spender The address of the account spending the funds
160      * @return The number of tokens approved
161      */
162     function allowance(address account, address spender) external view returns (uint) {
163         return allowances[account][spender];
164     }
165 
166     /**
167      * @notice Approve `spender` to transfer up to `amount` from `src`
168      * @dev This will overwrite the approval amount for `spender`
169      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
170      * @param spender The address of the account which may transfer tokens
171      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
172      * @return Whether or not the approval succeeded
173      */
174     function approve(address spender, uint rawAmount) external returns (bool) {
175         uint96 amount;
176         if (rawAmount == uint(-1)) {
177             amount = uint96(-1);
178         } else {
179             amount = safe96(rawAmount, "BNSG::approve: amount exceeds 96 bits");
180         }
181 
182         allowances[msg.sender][spender] = amount;
183 
184         emit Approval(msg.sender, spender, amount);
185         return true;
186     }
187 
188     /**
189      * @notice Get the number of tokens held by the `account`
190      * @param account The address of the account to get the balance of
191      * @return The number of tokens held
192      */
193     function balanceOf(address account) external view returns (uint) {
194         return balances[account];
195     }
196 
197     /**
198      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
199      * @param dst The address of the destination account
200      * @param rawAmount The number of tokens to transfer
201      * @return Whether or not the transfer succeeded
202      */
203     function transfer(address dst, uint rawAmount) external returns (bool) {
204         uint96 amount = safe96(rawAmount, "BNSG::transfer: amount exceeds 96 bits");
205         _transferTokens(msg.sender, dst, amount);
206         return true;
207     }
208 
209     /**
210      * @notice Transfer `amount` tokens from `src` to `dst`
211      * @param src The address of the source account
212      * @param dst The address of the destination account
213      * @param rawAmount The number of tokens to transfer
214      * @return Whether or not the transfer succeeded
215      */
216     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
217         address spender = msg.sender;
218         uint96 spenderAllowance = allowances[src][spender];
219         uint96 amount = safe96(rawAmount, "BNSG::approve: amount exceeds 96 bits");
220 
221         if (spender != src && spenderAllowance != uint96(-1)) {
222             uint96 newAllowance = sub96(spenderAllowance, amount, "BNSG::transferFrom: transfer amount exceeds spender allowance");
223             allowances[src][spender] = newAllowance;
224 
225             emit Approval(src, spender, newAllowance);
226         }
227 
228         _transferTokens(src, dst, amount);
229         return true;
230     }
231 
232     /**
233      * @notice Delegate votes from `msg.sender` to `delegatee`
234      * @param delegatee The address to delegate votes to
235      */
236     function delegate(address delegatee) public {
237         return _delegate(msg.sender, delegatee);
238     }
239 
240     /**
241      * @notice Delegates votes from signatory to `delegatee`
242      * @param delegatee The address to delegate votes to
243      * @param nonce The contract state required to match the signature
244      * @param expiry The time at which to expire the signature
245      * @param v The recovery byte of the signature
246      * @param r Half of the ECDSA signature pair
247      * @param s Half of the ECDSA signature pair
248      */
249     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
250         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
251         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
252         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
253         address signatory = ecrecover(digest, v, r, s);
254         require(signatory != address(0), "BNSG::delegateBySig: invalid signature");
255         require(nonce == nonces[signatory]++, "BNSG::delegateBySig: invalid nonce");
256         require(now <= expiry, "BNSG::delegateBySig: signature expired");
257         return _delegate(signatory, delegatee);
258     }
259 
260     /**
261      * @notice Gets the current votes balance for `account`
262      * @param account The address to get votes balance
263      * @return The number of current votes for `account`
264      */
265     function getCurrentVotes(address account) external view returns (uint96) {
266         uint32 nCheckpoints = numCheckpoints[account];
267         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
268     }
269 
270     /**
271      * @notice Determine the prior number of votes for an account as of a block number
272      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
273      * @param account The address of the account to check
274      * @param blockNumber The block number to get the vote balance at
275      * @return The number of votes the account had as of the given block
276      */
277     function getPriorVotes(address account, uint blockNumber) public view returns (uint96) {
278         require(blockNumber < block.number, "BNSG::getPriorVotes: not yet determined");
279 
280         uint32 nCheckpoints = numCheckpoints[account];
281         if (nCheckpoints == 0) {
282             return 0;
283         }
284 
285         // First check most recent balance
286         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
287             return checkpoints[account][nCheckpoints - 1].votes;
288         }
289 
290         // Next check implicit zero balance
291         if (checkpoints[account][0].fromBlock > blockNumber) {
292             return 0;
293         }
294 
295         uint32 lower = 0;
296         uint32 upper = nCheckpoints - 1;
297         while (upper > lower) {
298             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
299             Checkpoint memory cp = checkpoints[account][center];
300             if (cp.fromBlock == blockNumber) {
301                 return cp.votes;
302             } else if (cp.fromBlock < blockNumber) {
303                 lower = center;
304             } else {
305                 upper = center - 1;
306             }
307         }
308         return checkpoints[account][lower].votes;
309     }
310 
311     function _delegate(address delegator, address delegatee) internal {
312         address currentDelegate = delegates[delegator];
313         uint96 delegatorBalance = balances[delegator];
314         delegates[delegator] = delegatee;
315 
316         emit DelegateChanged(delegator, currentDelegate, delegatee);
317 
318         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
319     }
320 
321     function _transferTokens(address src, address dst, uint96 amount) internal {
322         require(src != address(0), "BNSG::_transferTokens: cannot transfer from the zero address");
323         require(dst != address(0), "BNSG::_transferTokens: cannot transfer to the zero address");
324 
325         balances[src] = sub96(balances[src], amount, "BNSG::_transferTokens: transfer amount exceeds balance");
326         balances[dst] = add96(balances[dst], amount, "BNSG::_transferTokens: transfer amount overflows");
327         emit Transfer(src, dst, amount);
328 
329         _moveDelegates(delegates[src], delegates[dst], amount);
330     }
331 
332     function _moveDelegates(address srcRep, address dstRep, uint96 amount) internal {
333         if (srcRep != dstRep && amount > 0) {
334             if (srcRep != address(0)) {
335                 uint32 srcRepNum = numCheckpoints[srcRep];
336                 uint96 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
337                 uint96 srcRepNew = sub96(srcRepOld, amount, "BNSG::_moveVotes: vote amount underflows");
338                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
339             }
340 
341             if (dstRep != address(0)) {
342                 uint32 dstRepNum = numCheckpoints[dstRep];
343                 uint96 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
344                 uint96 dstRepNew = add96(dstRepOld, amount, "BNSG::_moveVotes: vote amount overflows");
345                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
346             }
347         }
348     }
349 
350     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint96 oldVotes, uint96 newVotes) internal {
351       uint32 blockNumber = safe32(block.number, "BNSG::_writeCheckpoint: block number exceeds 32 bits");
352 
353       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
354           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
355       } else {
356           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
357           numCheckpoints[delegatee] = nCheckpoints + 1;
358       }
359 
360       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
361     }
362 
363     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
364         require(n < 2**32, errorMessage);
365         return uint32(n);
366     }
367 
368     function safe96(uint n, string memory errorMessage) internal pure returns (uint96) {
369         require(n < 2**96, errorMessage);
370         return uint96(n);
371     }
372 
373     function add96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
374         uint96 c = a + b;
375         require(c >= a, errorMessage);
376         return c;
377     }
378 
379     function sub96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
380         require(b <= a, errorMessage);
381         return a - b;
382     }
383 
384     function div96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
385         require(b != 0, errorMessage);
386         uint96 c = a / b;
387         return c;
388     }
389 
390     function mul96(uint96 a, uint96 b, string memory errorMessage) internal pure returns (uint96) {
391         if (a == 0) {
392             return 0;
393         }
394         uint96 c = a * b;
395         require(c / a == b, errorMessage);
396         return c;
397     }
398 
399     function getChainId() internal pure returns (uint) {
400         uint256 chainId;
401         assembly { chainId := chainid() }
402         return chainId;
403     }
404 }