1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 import "../token/BEP20.sol";
6 
7 import "../token/BabyToken.sol";
8 
9 // SyrupBar with Governance.
10 contract SyrupBar is BEP20('SyrupBar Token', 'SYRUP') {
11     using SafeMath for uint256;
12     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
13     function mint(address _to, uint256 _amount) public onlyOwner {
14         _mint(_to, _amount);
15         _moveDelegates(address(0), _delegates[_to], _amount);
16     }
17 
18     function burn(address _from ,uint256 _amount) public onlyOwner {
19         _burn(_from, _amount);
20         _moveDelegates(_delegates[_from], address(0), _amount);
21     }
22 
23     // The CAKE TOKEN!
24     BabyToken public cake;
25 
26 
27     constructor(
28         BabyToken _cake
29     ) {
30         cake = _cake;
31     }
32 
33     // Safe cake transfer function, just in case if rounding error causes pool to not have enough CAKEs.
34     function safeCakeTransfer(address _to, uint256 _amount) public onlyOwner {
35         uint256 cakeBal = cake.balanceOf(address(this));
36         if (_amount > cakeBal) {
37             cake.transfer(_to, cakeBal);
38         } else {
39             cake.transfer(_to, _amount);
40         }
41     }
42 
43     // Copied and modified from YAM code:
44     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
45     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
46     // Which is copied and modified from COMPOUND:
47     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
48 
49     mapping (address => address) internal _delegates;
50 
51     /// @notice A checkpoint for marking number of votes from a given block
52     struct Checkpoint {
53         uint32 fromBlock;
54         uint256 votes;
55     }
56 
57     /// @notice A record of votes checkpoints for each account, by index
58     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
59 
60     /// @notice The number of checkpoints for each account
61     mapping (address => uint32) public numCheckpoints;
62 
63     /// @notice The EIP-712 typehash for the contract's domain
64     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
65 
66     /// @notice The EIP-712 typehash for the delegation struct used by the contract
67     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
68 
69     /// @notice A record of states for signing / validating signatures
70     mapping (address => uint) public nonces;
71 
72       /// @notice An event thats emitted when an account changes its delegate
73     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
74 
75     /// @notice An event thats emitted when a delegate account's vote balance changes
76     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
77 
78     /**
79      * @notice Delegate votes from `msg.sender` to `delegatee`
80      * @param delegator The address to get delegatee for
81      */
82     function delegates(address delegator)
83         external
84         view
85         returns (address)
86     {
87         return _delegates[delegator];
88     }
89 
90    /**
91     * @notice Delegate votes from `msg.sender` to `delegatee`
92     * @param delegatee The address to delegate votes to
93     */
94     function delegate(address delegatee) external {
95         return _delegate(msg.sender, delegatee);
96     }
97 
98     /**
99      * @notice Delegates votes from signatory to `delegatee`
100      * @param delegatee The address to delegate votes to
101      * @param nonce The contract state required to match the signature
102      * @param expiry The time at which to expire the signature
103      * @param v The recovery byte of the signature
104      * @param r Half of the ECDSA signature pair
105      * @param s Half of the ECDSA signature pair
106      */
107     function delegateBySig(
108         address delegatee,
109         uint nonce,
110         uint expiry,
111         uint8 v,
112         bytes32 r,
113         bytes32 s
114     )
115         external
116     {
117         bytes32 domainSeparator = keccak256(
118             abi.encode(
119                 DOMAIN_TYPEHASH,
120                 keccak256(bytes(name())),
121                 getChainId(),
122                 address(this)
123             )
124         );
125 
126         bytes32 structHash = keccak256(
127             abi.encode(
128                 DELEGATION_TYPEHASH,
129                 delegatee,
130                 nonce,
131                 expiry
132             )
133         );
134 
135         bytes32 digest = keccak256(
136             abi.encodePacked(
137                 "\x19\x01",
138                 domainSeparator,
139                 structHash
140             )
141         );
142 
143         address signatory = ecrecover(digest, v, r, s);
144         require(signatory != address(0), "CAKE::delegateBySig: invalid signature");
145         require(nonce == nonces[signatory]++, "CAKE::delegateBySig: invalid nonce");
146         require(block.timestamp <= expiry, "CAKE::delegateBySig: signature expired");
147         return _delegate(signatory, delegatee);
148     }
149 
150     /**
151      * @notice Gets the current votes balance for `account`
152      * @param account The address to get votes balance
153      * @return The number of current votes for `account`
154      */
155     function getCurrentVotes(address account)
156         external
157         view
158         returns (uint256)
159     {
160         uint32 nCheckpoints = numCheckpoints[account];
161         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
162     }
163 
164     /**
165      * @notice Determine the prior number of votes for an account as of a block number
166      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
167      * @param account The address of the account to check
168      * @param blockNumber The block number to get the vote balance at
169      * @return The number of votes the account had as of the given block
170      */
171     function getPriorVotes(address account, uint blockNumber)
172         external
173         view
174         returns (uint256)
175     {
176         require(blockNumber < block.number, "CAKE::getPriorVotes: not yet determined");
177 
178         uint32 nCheckpoints = numCheckpoints[account];
179         if (nCheckpoints == 0) {
180             return 0;
181         }
182 
183         // First check most recent balance
184         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
185             return checkpoints[account][nCheckpoints - 1].votes;
186         }
187 
188         // Next check implicit zero balance
189         if (checkpoints[account][0].fromBlock > blockNumber) {
190             return 0;
191         }
192 
193         uint32 lower = 0;
194         uint32 upper = nCheckpoints - 1;
195         while (upper > lower) {
196             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
197             Checkpoint memory cp = checkpoints[account][center];
198             if (cp.fromBlock == blockNumber) {
199                 return cp.votes;
200             } else if (cp.fromBlock < blockNumber) {
201                 lower = center;
202             } else {
203                 upper = center - 1;
204             }
205         }
206         return checkpoints[account][lower].votes;
207     }
208 
209     function _delegate(address delegator, address delegatee)
210         internal
211     {
212         address currentDelegate = _delegates[delegator];
213         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CAKEs (not scaled);
214         _delegates[delegator] = delegatee;
215 
216         emit DelegateChanged(delegator, currentDelegate, delegatee);
217 
218         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
219     }
220 
221     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
222         if (srcRep != dstRep && amount > 0) {
223             if (srcRep != address(0)) {
224                 // decrease old representative
225                 uint32 srcRepNum = numCheckpoints[srcRep];
226                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
227                 uint256 srcRepNew = srcRepOld.sub(amount);
228                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
229             }
230 
231             if (dstRep != address(0)) {
232                 // increase new representative
233                 uint32 dstRepNum = numCheckpoints[dstRep];
234                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
235                 uint256 dstRepNew = dstRepOld.add(amount);
236                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
237             }
238         }
239     }
240 
241     function _writeCheckpoint(
242         address delegatee,
243         uint32 nCheckpoints,
244         uint256 oldVotes,
245         uint256 newVotes
246     )
247         internal
248     {
249         uint32 blockNumber = safe32(block.number, "CAKE::_writeCheckpoint: block number exceeds 32 bits");
250 
251         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
252             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
253         } else {
254             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
255             numCheckpoints[delegatee] = nCheckpoints + 1;
256         }
257 
258         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
259     }
260 
261     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
262         require(n < 2**32, errorMessage);
263         return uint32(n);
264     }
265 
266     function getChainId() internal pure returns (uint) {
267         uint256 chainId;
268         assembly { chainId := chainid() }
269         return chainId;
270     }
271 }
