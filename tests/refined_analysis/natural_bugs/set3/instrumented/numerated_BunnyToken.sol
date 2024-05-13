1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5   ___                      _   _
6  | _ )_  _ _ _  _ _ _  _  | | | |
7  | _ \ || | ' \| ' \ || | |_| |_|
8  |___/\_,_|_||_|_||_\_, | (_) (_)
9                     |__/
10 
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 BunnyFinance
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
36 
37 
38 // BunnyToken with Governance.
39 contract BunnyToken is BEP20('Bunny Token', 'BUNNY') {
40     // @dev Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
41     function mint(address _to, uint256 _amount) public onlyOwner {
42         _mint(_to, _amount);
43         _moveDelegates(address(0), _delegates[_to], _amount);
44     }
45 
46     // Copied and modified from YAM code:
47     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
48     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
49     // Which is copied and modified from COMPOUND:
50     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
51 
52     // @dev A record of each accounts delegate
53     mapping (address => address) internal _delegates;
54 
55 
56     // @dev A checkpoint for marking number of votes from a given block
57     struct Checkpoint {
58         uint32 fromBlock;
59         uint256 votes;
60     }
61 
62     // @dev A record of votes checkpoints for each account, by index
63     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
64 
65     // @dev The number of checkpoints for each account
66     mapping (address => uint32) public numCheckpoints;
67 
68     // @dev The EIP-712 typehash for the contract's domain
69     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
70 
71     // @dev The EIP-712 typehash for the delegation struct used by the contract
72     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
73 
74     // @dev A record of states for signing / validating signatures
75     mapping (address => uint) public nonces;
76 
77     // @dev An event thats emitted when an account changes its delegate
78     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
79 
80     // @dev An event thats emitted when a delegate account's vote balance changes
81     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
82 
83     /**
84      * @dev Delegate votes from `msg.sender` to `delegatee`
85      * @param delegator The address to get delegatee for
86      */
87     function delegates(address delegator)
88     external
89     view
90     returns (address)
91     {
92         return _delegates[delegator];
93     }
94 
95     /**
96      * @dev Delegate votes from `msg.sender` to `delegatee`
97      * @param delegatee The address to delegate votes to
98      */
99     function delegate(address delegatee) external {
100         return _delegate(msg.sender, delegatee);
101     }
102 
103     /**
104      * @dev Delegates votes from signatory to `delegatee`
105      * @param delegatee The address to delegate votes to
106      * @param nonce The contract state required to match the signature
107      * @param expiry The time at which to expire the signature
108      * @param v The recovery byte of the signature
109      * @param r Half of the ECDSA signature pair
110      * @param s Half of the ECDSA signature pair
111      */
112     function delegateBySig(
113         address delegatee,
114         uint nonce,
115         uint expiry,
116         uint8 v,
117         bytes32 r,
118         bytes32 s
119     )
120     external
121     {
122         bytes32 domainSeparator = keccak256(
123             abi.encode(
124                 DOMAIN_TYPEHASH,
125                 keccak256(bytes(name())),
126                 getChainId(),
127                 address(this)
128             )
129         );
130 
131         bytes32 structHash = keccak256(
132             abi.encode(
133                 DELEGATION_TYPEHASH,
134                 delegatee,
135                 nonce,
136                 expiry
137             )
138         );
139 
140         bytes32 digest = keccak256(
141             abi.encodePacked(
142                 "\x19\x01",
143                 domainSeparator,
144                 structHash
145             )
146         );
147 
148         address signatory = ecrecover(digest, v, r, s);
149         require(signatory != address(0), "BUNNY::delegateBySig: invalid signature");
150         require(nonce == nonces[signatory]++, "BUNNY::delegateBySig: invalid nonce");
151         require(now <= expiry, "BUNNY::delegateBySig: signature expired");
152         return _delegate(signatory, delegatee);
153     }
154 
155     /**
156      * @dev Gets the current votes balance for `account`
157      * @param account The address to get votes balance
158      * @return The number of current votes for `account`
159      */
160     function getCurrentVotes(address account)
161     external
162     view
163     returns (uint256)
164     {
165         uint32 nCheckpoints = numCheckpoints[account];
166         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
167     }
168 
169     /**
170      * @dev Determine the prior number of votes for an account as of a block number
171      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
172      * @param account The address of the account to check
173      * @param blockNumber The block number to get the vote balance at
174      * @return The number of votes the account had as of the given block
175      */
176     function getPriorVotes(address account, uint blockNumber)
177     external
178     view
179     returns (uint256)
180     {
181         require(blockNumber < block.number, "BUNNY::getPriorVotes: not yet determined");
182 
183         uint32 nCheckpoints = numCheckpoints[account];
184         if (nCheckpoints == 0) {
185             return 0;
186         }
187 
188         // First check most recent balance
189         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
190             return checkpoints[account][nCheckpoints - 1].votes;
191         }
192 
193         // Next check implicit zero balance
194         if (checkpoints[account][0].fromBlock > blockNumber) {
195             return 0;
196         }
197 
198         uint32 lower = 0;
199         uint32 upper = nCheckpoints - 1;
200         while (upper > lower) {
201             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
202             Checkpoint memory cp = checkpoints[account][center];
203             if (cp.fromBlock == blockNumber) {
204                 return cp.votes;
205             } else if (cp.fromBlock < blockNumber) {
206                 lower = center;
207             } else {
208                 upper = center - 1;
209             }
210         }
211         return checkpoints[account][lower].votes;
212     }
213 
214     function _delegate(address delegator, address delegatee)
215     internal
216     {
217         address currentDelegate = _delegates[delegator];
218         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BUNNYs (not scaled);
219         _delegates[delegator] = delegatee;
220 
221         emit DelegateChanged(delegator, currentDelegate, delegatee);
222 
223         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
224     }
225 
226     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
227         if (srcRep != dstRep && amount > 0) {
228             if (srcRep != address(0)) {
229                 // decrease old representative
230                 uint32 srcRepNum = numCheckpoints[srcRep];
231                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
232                 uint256 srcRepNew = srcRepOld.sub(amount);
233                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
234             }
235 
236             if (dstRep != address(0)) {
237                 // increase new representative
238                 uint32 dstRepNum = numCheckpoints[dstRep];
239                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
240                 uint256 dstRepNew = dstRepOld.add(amount);
241                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
242             }
243         }
244     }
245 
246     function _writeCheckpoint(
247         address delegatee,
248         uint32 nCheckpoints,
249         uint256 oldVotes,
250         uint256 newVotes
251     )
252     internal
253     {
254         uint32 blockNumber = safe32(block.number, "BUNNY::_writeCheckpoint: block number exceeds 32 bits");
255 
256         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
257             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
258         } else {
259             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
260             numCheckpoints[delegatee] = nCheckpoints + 1;
261         }
262 
263         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
264     }
265 
266     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
267         require(n < 2**32, errorMessage);
268         return uint32(n);
269     }
270 
271     function getChainId() internal pure returns (uint) {
272         uint256 chainId;
273         assembly { chainId := chainid() }
274         return chainId;
275     }
276 }
