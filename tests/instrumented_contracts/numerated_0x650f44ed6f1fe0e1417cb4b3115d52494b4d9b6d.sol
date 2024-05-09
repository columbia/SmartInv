1 // SPDX-License-Identifier: UNLICENSED
2 // @title Meowshi (MEOW) 🐈 🍣 🍱
3 // @author Gatoshi Nyakamoto
4 
5 pragma solidity 0.8.4;
6 
7 /// @notice Interface for depositing into & withdrawing from BentoBox vault.
8 interface IERC20{} interface IBentoBoxBasic {
9     function deposit( 
10         IERC20 token_,
11         address from,
12         address to,
13         uint256 amount,
14         uint256 share
15     ) external payable returns (uint256 amountOut, uint256 shareOut);
16 
17     function withdraw(
18         IERC20 token_,
19         address from,
20         address to,
21         uint256 amount,
22         uint256 share
23     ) external returns (uint256 amountOut, uint256 shareOut);
24 }
25 
26 /// @notice Interface for depositing into & withdrawing from SushiBar.
27 interface ISushiBar { 
28     function balanceOf(address account) external view returns (uint256);
29     function enter(uint256 amount) external;
30     function leave(uint256 share) external;
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34 }
35 
36 /// @notice Meowshi takes SUSHI/xSUSHI to mint governing MEOW tokens that can be burned to claim SUSHI/xSUSHI from BENTO with yields.
37 //  ៱˳_˳៱   ∫
38 contract Meowshi {
39     IBentoBoxBasic constant bento = IBentoBoxBasic(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966); // BENTO vault contract (multinet)
40     ISushiBar constant sushiToken = ISushiBar(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2); // SUSHI token contract (mainnet)
41     address constant sushiBar = 0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272; // xSUSHI token contract for staking SUSHI (mainnet)
42     string constant public name = "Meowshi";
43     string constant public symbol = "MEOW";
44     uint8 constant public decimals = 18;
45     uint256 constant multiplier = 100_000; // 1 xSUSHI BENTO share = 100,000 MEOW
46     uint256 public totalSupply;
47     
48     /// @notice owner -> spender -> allowance mapping.
49     mapping(address => mapping(address => uint256)) public allowance;
50     /// @notice owner -> balance mapping.
51     mapping(address => uint256) public balanceOf;
52     /// @notice owner -> nonce mapping used in {permit}.
53     mapping(address => uint256) public nonces;
54     /// @notice A record of each account's delegate.
55     mapping(address => address) public delegates;
56     /// @notice A record of votes checkpoints for each account, by index.
57     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
58     /// @notice The number of checkpoints for each account.
59     mapping(address => uint32) public numCheckpoints;
60     /// @notice The ERC-712 typehash for this contract's domain.
61     bytes32 constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
62     /// @notice The ERC-712 typehash for the delegation struct used by the contract.
63     bytes32 constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
64     /// @notice The ERC-712 typehash for the permit struct used by the contract.
65     bytes32 constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
66     /// @notice Events that are emitted when an ERC-20 approval or transfer occurs. 
67     event Approval(address indexed owner, address indexed spender, uint256 amount);
68     event Transfer(address indexed from, address indexed to, uint256 amount);
69     /// @notice An event that's emitted when an account changes its delegate.
70     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
71     /// @notice An event that's emitted when a delegate account's vote balance changes.
72     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
73     
74     /// @notice A checkpoint for marking number of votes from a given block.
75     struct Checkpoint {
76         uint32 fromBlock;
77         uint256 votes;
78     }
79     
80     constructor() {
81         sushiToken.approve(sushiBar, type(uint256).max); // max {approve} xSUSHI to draw SUSHI from this contract
82         ISushiBar(sushiBar).approve(address(bento), type(uint256).max); // max {approve} BENTO to draw xSUSHI from this contract
83     }
84 
85     /*************
86     MEOW FUNCTIONS
87     *************/
88     // **** xSUSHI
89     /// @notice Enter Meowshi. Deposit xSUSHI `amount`. Mint MEOW for `to`.
90     function meow(address to, uint256 amount) external returns (uint256 shares) {
91         ISushiBar(sushiBar).transferFrom(msg.sender, address(bento), amount); // forward to BENTO for skim
92         (, shares) = bento.deposit(IERC20(sushiBar), address(bento), address(this), amount, 0);
93         meowMint(to, shares * multiplier);
94     }
95 
96     /// @notice Leave Meowshi. Burn MEOW `amount`. Claim xSUSHI for `to`.
97     function unmeow(address to, uint256 amount) external returns (uint256 amountOut) {
98         meowBurn(amount);
99         unchecked {(amountOut, ) = bento.withdraw(IERC20(sushiBar), address(this), to, 0, amount / multiplier);}
100     }
101     
102     // **** SUSHI
103     /// @notice Enter Meowshi. Deposit SUSHI `amount`. Mint MEOW for `to`.
104     function meowSushi(address to, uint256 amount) external returns (uint256 shares) {
105         sushiToken.transferFrom(msg.sender, address(this), amount);
106         ISushiBar(sushiBar).enter(amount);
107         (, shares) = bento.deposit(IERC20(sushiBar), address(this), address(this), ISushiBar(sushiBar).balanceOf(address(this)), 0);
108         meowMint(to, shares * multiplier);
109     }
110 
111     /// @notice Leave Meowshi. Burn MEOW `amount`. Claim SUSHI for `to`.
112     function unmeowSushi(address to, uint256 amount) external returns (uint256 amountOut) {
113         meowBurn(amount);
114         unchecked {(amountOut, ) = bento.withdraw(IERC20(sushiBar), address(this), address(this), 0, amount / multiplier);}
115         ISushiBar(sushiBar).leave(amountOut);
116         sushiToken.transfer(to, sushiToken.balanceOf(address(this))); 
117     }
118 
119     // **** SUPPLY MGMT
120     /// @notice Internal mint function for *meow*.
121     function meowMint(address to, uint256 amount) private {
122         balanceOf[to] += amount;
123         totalSupply += amount;
124         _moveDelegates(address(0), delegates[to], amount);
125         emit Transfer(address(0), to, amount);
126     }
127     
128     /// @notice Internal burn function for *unmeow*.
129     function meowBurn(uint256 amount) private {
130         balanceOf[msg.sender] -= amount;
131         unchecked {totalSupply -= amount;}
132         _moveDelegates(delegates[msg.sender], address(0), amount);
133         emit Transfer(msg.sender, address(0), amount);
134     }
135     
136     /**************
137     TOKEN FUNCTIONS
138     **************/
139     /// @notice Approves `amount` from msg.sender to be spent by `spender`.
140     /// @param spender Address of the party that can draw tokens from msg.sender's account.
141     /// @param amount The maximum collective `amount` that `spender` can draw.
142     /// @return (bool) Returns 'true' if succeeded.
143     function approve(address spender, uint256 amount) external returns (bool) {
144         allowance[msg.sender][spender] = amount;
145         emit Approval(msg.sender, spender, amount);
146         return true;
147     }
148 
149     /// @notice Triggers an approval from owner to spends.
150     /// @param owner The address to approve from.
151     /// @param spender The address to be approved.
152     /// @param amount The number of tokens that are approved (2^256-1 means infinite).
153     /// @param deadline The time at which to expire the signature.
154     /// @param v The recovery byte of the signature.
155     /// @param r Half of the ECDSA signature pair.
156     /// @param s Half of the ECDSA signature pair.
157     function permit(address owner, address spender, uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
158         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
159         unchecked {bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, nonces[owner]++, deadline));
160         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
161         address signatory = ecrecover(digest, v, r, s); 
162         require(signatory != address(0), 'Meowshi::permit: invalid signature');
163         require(signatory == owner, 'Meowshi::permit: unauthorized');}
164         require(block.timestamp <= deadline, 'Meowshi::permit: signature expired');
165         allowance[owner][spender] = amount;
166         emit Approval(owner, spender, amount);
167     }
168     
169     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
170     /// @param to The address to move tokens `to`.
171     /// @param amount The token `amount` to move.
172     /// @return (bool) Returns 'true' if succeeded.
173     function transfer(address to, uint256 amount) external returns (bool) {
174         balanceOf[msg.sender] -= amount; 
175         unchecked {balanceOf[to] += amount;}
176         _moveDelegates(delegates[msg.sender], delegates[to], amount);
177         emit Transfer(msg.sender, to, amount);
178         return true;
179     }
180 
181     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval from `from`.
182     /// @param from Address to draw tokens `from`.
183     /// @param to The address to move tokens `to`.
184     /// @param amount The token `amount` to move.
185     /// @return (bool) Returns 'true' if succeeded.
186     function transferFrom(address from, address to, uint256 amount) external returns (bool) {
187         if (allowance[from][msg.sender] != type(uint256).max) {
188             allowance[from][msg.sender] -= amount;
189         }
190         balanceOf[from] -= amount;
191         unchecked {balanceOf[to] += amount;}
192         _moveDelegates(delegates[from], delegates[to], amount);
193         emit Transfer(from, to, amount);
194         return true;
195     }
196     
197     /*******************
198     DELEGATION FUNCTIONS
199     *******************/
200     /// @notice Delegate votes from `msg.sender` to `delegatee`.
201     /// @param delegatee The address to delegate votes to.
202     function delegate(address delegatee) external {
203         return _delegate(msg.sender, delegatee);
204     }
205 
206     /// @notice Delegates votes from signatory to `delegatee`.
207     /// @param delegatee The address to delegate votes to.
208     /// @param nonce The contract state required to match the signature.
209     /// @param expiry The time at which to expire the signature.
210     /// @param v The recovery byte of the signature.
211     /// @param r Half of the ECDSA signature pair.
212     /// @param s Half of the ECDSA signature pair.
213     function delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s) external {
214         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
215         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
216         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
217         address signatory = ecrecover(digest, v, r, s);
218         require(signatory != address(0), 'Meowshi::delegateBySig: invalid signature');
219         unchecked {require(nonce == nonces[signatory]++, 'Meowshi::delegateBySig: invalid nonce');}
220         require(block.timestamp <= expiry, 'Meowshi::delegateBySig: signature expired');
221         return _delegate(signatory, delegatee);
222     }
223     
224     /***************
225     GETTER FUNCTIONS
226     ***************/
227     /// @notice Get current chain. 
228     function getChainId() private view returns (uint256) {
229         uint256 chainId;
230         assembly {chainId := chainid()}
231         return chainId;
232     }
233 
234     /// @notice Gets the current votes balance for `account`.
235     /// @param account The address to get votes balance.
236     /// @return The number of current votes for `account`.
237     function getCurrentVotes(address account) external view returns (uint256) {
238         unchecked {uint32 nCheckpoints = numCheckpoints[account];
239         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;}
240     }
241 
242     /// @notice Determine the prior number of votes for an `account` as of a block number.
243     /// @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
244     /// @param account The address of the `account` to check.
245     /// @param blockNumber The block number to get the vote balance at.
246     /// @return The number of votes the `account` had as of the given block.
247     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
248         require(blockNumber < block.number, 'Meowshi::getPriorVotes: not yet determined');
249         uint32 nCheckpoints = numCheckpoints[account];
250         if (nCheckpoints == 0) {return 0;}
251         unchecked {
252         // @dev First check most recent balance.
253         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {return checkpoints[account][nCheckpoints - 1].votes;}
254         // @dev Next check implicit zero balance.
255         if (checkpoints[account][0].fromBlock > blockNumber) {return 0;}
256         uint32 lower = 0;
257         uint32 upper = nCheckpoints - 1;
258         while (upper > lower) {
259             uint32 center = upper - (upper - lower) / 2; // avoiding overflow
260             Checkpoint memory cp = checkpoints[account][center];
261             if (cp.fromBlock == blockNumber) {
262                 return cp.votes;
263             } else if (cp.fromBlock < blockNumber) {
264                 lower = center;
265             } else {upper = center - 1;}}
266         return checkpoints[account][lower].votes;}
267     }
268     
269     /***************
270     HELPER FUNCTIONS
271     ***************/
272     function _delegate(address delegator, address delegatee) private {
273         address currentDelegate = delegates[delegator]; 
274         uint256 delegatorBalance = balanceOf[delegator];
275         delegates[delegator] = delegatee;
276         emit DelegateChanged(delegator, currentDelegate, delegatee);
277         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
278     }
279 
280     function _moveDelegates(address srcRep, address dstRep, uint256 amount) private {
281         unchecked {
282         if (srcRep != dstRep && amount > 0) {
283             if (srcRep != address(0)) {
284                 uint32 srcRepNum = numCheckpoints[srcRep];
285                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
286                 uint256 srcRepNew = srcRepOld - amount;
287                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
288             }
289             if (dstRep != address(0)) {
290                 uint32 dstRepNum = numCheckpoints[dstRep];
291                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
292                 uint256 dstRepNew = dstRepOld + amount;
293                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
294             }
295         }}
296     }
297     
298     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) private {
299         uint32 blockNumber = safe32(block.number);
300         unchecked {
301         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
302             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
303         } else {
304             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
305             numCheckpoints[delegatee] = nCheckpoints + 1;
306         }}
307         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
308     }
309     
310     /// @notice Enables calling multiple methods in a single call to this contract.
311     function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
312         results = new bytes[](data.length);
313         unchecked {
314         for (uint256 i = 0; i < data.length; i++) {
315             (bool success, bytes memory result) = address(this).delegatecall(data[i]);
316             if (!success) {
317                 if (result.length < 68) revert();
318                 assembly {result := add(result, 0x04)}
319                 revert(abi.decode(result, (string)));
320             }
321             results[i] = result;
322         }}
323     }
324     
325     function safe32(uint256 n) private pure returns (uint32) {
326         require(n < 2**32, 'Meowshi::_writeCheckpoint: block number exceeds 32 bits'); return uint32(n);}
327 }