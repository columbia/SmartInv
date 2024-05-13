1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >0.6.6;
4 
5 import "./BEP20.sol";
6 
7 // CakeToken with Governance.
8 contract BabyToken is BEP20('BabySwap Token', 'BABY') {
9     using SafeMath for uint256;
10     uint256 public constant maxSupply = 10 ** 27;
11     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
12     function mintFor(address _to, uint256 _amount) public onlyOwner {
13         _mint(_to, _amount);
14         require(totalSupply() <= maxSupply, "reach max supply");
15         _moveDelegates(address(0), _delegates[_to], _amount);
16     }
17 
18     function mint(uint256 amount) public override onlyOwner returns (bool) {
19         _mint(_msgSender(), amount);
20         require(totalSupply() <= maxSupply, "reach max supply");
21         return true;
22     }
23 
24     // Copied and modified from YAM code:
25     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
26     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
27     // Which is copied and modified from COMPOUND:
28     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
29 
30     mapping (address => address) internal _delegates;
31 
32     /// @notice A checkpoint for marking number of votes from a given block
33     struct Checkpoint {
34         uint32 fromBlock;
35         uint256 votes;
36     }
37 
38     /// @notice A record of votes checkpoints for each account, by index
39     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
40 
41     /// @notice The number of checkpoints for each account
42     mapping (address => uint32) public numCheckpoints;
43 
44     /// @notice The EIP-712 typehash for the contract's domain
45     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
46 
47     /// @notice The EIP-712 typehash for the delegation struct used by the contract
48     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
49 
50     /// @notice A record of states for signing / validating signatures
51     mapping (address => uint) public nonces;
52 
53       /// @notice An event thats emitted when an account changes its delegate
54     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
55 
56     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
57 
58     /**
59      * @notice Delegate votes from `msg.sender` to `delegatee`
60      * @param delegator The address to get delegatee for
61      */
62     function delegates(address delegator)
63         external
64         view
65         returns (address)
66     {
67         return _delegates[delegator];
68     }
69 
70    /**
71     * @notice Delegate votes from `msg.sender` to `delegatee`
72     * @param delegatee The address to delegate votes to
73     */
74     function delegate(address delegatee) external {
75         return _delegate(msg.sender, delegatee);
76     }
77 
78     /**
79      * @notice Delegates votes from signatory to `delegatee`
80      * @param delegatee The address to delegate votes to
81      * @param nonce The contract state required to match the signature
82      * @param expiry The time at which to expire the signature
83      * @param v The recovery byte of the signature
84      * @param r Half of the ECDSA signature pair
85      * @param s Half of the ECDSA signature pair
86      */
87     function delegateBySig(
88         address delegatee,
89         uint nonce,
90         uint expiry,
91         uint8 v,
92         bytes32 r,
93         bytes32 s
94     )
95         external
96     {
97         bytes32 domainSeparator = keccak256(
98             abi.encode(
99                 DOMAIN_TYPEHASH,
100                 keccak256(bytes(name())),
101                 getChainId(),
102                 address(this)
103             )
104         );
105 
106         bytes32 structHash = keccak256(
107             abi.encode(
108                 DELEGATION_TYPEHASH,
109                 delegatee,
110                 nonce,
111                 expiry
112             )
113         );
114 
115         bytes32 digest = keccak256(
116             abi.encodePacked(
117                 "\x19\x01",
118                 domainSeparator,
119                 structHash
120             )
121         );
122 
123         address signatory = ecrecover(digest, v, r, s);
124         require(signatory != address(0), "CAKE::delegateBySig: invalid signature");
125         require(nonce == nonces[signatory]++, "CAKE::delegateBySig: invalid nonce");
126         require(block.timestamp <= expiry, "CAKE::delegateBySig: signature expired");
127         return _delegate(signatory, delegatee);
128     }
129 
130     /**
131      * @notice Gets the current votes balance for `account`
132      * @param account The address to get votes balance
133      * @return The number of current votes for `account`
134      */
135     function getCurrentVotes(address account)
136         external
137         view
138         returns (uint256)
139     {
140         uint32 nCheckpoints = numCheckpoints[account];
141         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
142     }
143 
144     /**
145      * @notice Determine the prior number of votes for an account as of a block number
146      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
147      * @param account The address of the account to check
148      * @param blockNumber The block number to get the vote balance at
149      * @return The number of votes the account had as of the given block
150      */
151     function getPriorVotes(address account, uint blockNumber)
152         external
153         view
154         returns (uint256)
155     {
156         require(blockNumber < block.number, "CAKE::getPriorVotes: not yet determined");
157 
158         uint32 nCheckpoints = numCheckpoints[account];
159         if (nCheckpoints == 0) {
160             return 0;
161         }
162 
163         // First check most recent balance
164         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
165             return checkpoints[account][nCheckpoints - 1].votes;
166         }
167 
168         // Next check implicit zero balance
169         if (checkpoints[account][0].fromBlock > blockNumber) {
170             return 0;
171         }
172 
173         uint32 lower = 0;
174         uint32 upper = nCheckpoints - 1;
175         while (upper > lower) {
176             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
177             Checkpoint memory cp = checkpoints[account][center];
178             if (cp.fromBlock == blockNumber) {
179                 return cp.votes;
180             } else if (cp.fromBlock < blockNumber) {
181                 lower = center;
182             } else {
183                 upper = center - 1;
184             }
185         }
186         return checkpoints[account][lower].votes;
187     }
188 
189     function _delegate(address delegator, address delegatee)
190         internal
191     {
192         address currentDelegate = _delegates[delegator];
193         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CAKEs (not scaled);
194         _delegates[delegator] = delegatee;
195 
196         emit DelegateChanged(delegator, currentDelegate, delegatee);
197 
198         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
199     }
200 
201     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
202         if (srcRep != dstRep && amount > 0) {
203             if (srcRep != address(0)) {
204                 // decrease old representative
205                 uint32 srcRepNum = numCheckpoints[srcRep];
206                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
207                 uint256 srcRepNew = srcRepOld.sub(amount);
208                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
209             }
210 
211             if (dstRep != address(0)) {
212                 // increase new representative
213                 uint32 dstRepNum = numCheckpoints[dstRep];
214                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
215                 uint256 dstRepNew = dstRepOld.add(amount);
216                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
217             }
218         }
219     }
220 
221     function _writeCheckpoint(
222         address delegatee,
223         uint32 nCheckpoints,
224         uint256 oldVotes,
225         uint256 newVotes
226     )
227         internal
228     {
229         uint32 blockNumber = safe32(block.number, "CAKE::_writeCheckpoint: block number exceeds 32 bits");
230 
231         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
232             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
233         } else {
234             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
235             numCheckpoints[delegatee] = nCheckpoints + 1;
236         }
237 
238         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
239     }
240 
241     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
242         require(n < 2**32, errorMessage);
243         return uint32(n);
244     }
245 
246     function getChainId() internal pure returns (uint) {
247         uint256 chainId;
248         assembly { chainId := chainid() }
249         return chainId;
250     }
251 }
