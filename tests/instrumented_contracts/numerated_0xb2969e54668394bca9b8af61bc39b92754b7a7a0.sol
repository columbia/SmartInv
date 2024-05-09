1 pragma solidity 0.4.26;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address private _owner;
11 
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() internal {
22     _owner = msg.sender;
23     emit OwnershipTransferred(address(0), _owner);
24   }
25 
26   /**
27    * @return the address of the owner.
28    */
29   function owner() public view returns(address) {
30     return _owner;
31   }
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(isOwner());
38     _;
39   }
40 
41   /**
42    * @return true if `msg.sender` is the owner of the contract.
43    */
44   function isOwner() public view returns(bool) {
45     return msg.sender == _owner;
46   }
47 
48   /**
49    * @dev Allows the current owner to relinquish control of the contract.
50    * @notice Renouncing to ownership will leave the contract without an owner.
51    * It will not be possible to call the functions with the `onlyOwner`
52    * modifier anymore.
53    */
54   function renounceOwnership() public onlyOwner {
55     emit OwnershipTransferred(_owner, address(0));
56     _owner = address(0);
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) public onlyOwner {
64     _transferOwnership(newOwner);
65   }
66 
67   /**
68    * @dev Transfers control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function _transferOwnership(address newOwner) internal {
72     require(newOwner != address(0));
73     emit OwnershipTransferred(_owner, newOwner);
74     _owner = newOwner;
75   }
76 }
77 
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 interface IERC20 {
84   function totalSupply() external view returns (uint256);
85 
86   function balanceOf(address who) external view returns (uint256);
87 
88   function allowance(address owner, address spender)
89     external view returns (uint256);
90 
91   function transfer(address to, uint256 value) external returns (bool);
92 
93   function approve(address spender, uint256 value)
94     external returns (bool);
95 
96   function transferFrom(address from, address to, uint256 value)
97     external returns (bool);
98 
99   event Transfer(
100     address indexed from,
101     address indexed to,
102     uint256 value
103   );
104 
105   event Approval(
106     address indexed owner,
107     address indexed spender,
108     uint256 value
109   );
110 }
111 
112 
113 
114 
115 interface IOrbsRewardsDistribution {
116     event RewardDistributed(string distributionEvent, address indexed recipient, uint256 amount);
117 
118     event RewardsDistributionAnnounced(string distributionEvent, bytes32[] batchHash, uint256 batchCount);
119     event RewardsBatchExecuted(string distributionEvent, bytes32 batchHash, uint256 batchIndex);
120     event RewardsDistributionAborted(string distributionEvent, bytes32[] abortedBatchHashes, uint256[] abortedBatchIndices);
121     event RewardsDistributionCompleted(string distributionEvent);
122 
123     event RewardsDistributorReassigned(address indexed previousRewardsDistributor, address indexed newRewardsDistributor);
124 
125     function announceDistributionEvent(string distributionEvent, bytes32[] batchHashes) external;
126     function abortDistributionEvent(string distributionEvent) external;
127 
128     function executeCommittedBatch(string distributionEvent, address[] recipients, uint256[] amounts, uint256 batchIndex) external;
129 
130     function distributeRewards(string distributionEvent, address[] recipients, uint256[] amounts) external;
131 
132     function getPendingBatches(string distributionEvent) external view returns (bytes32[] pendingBatchHashes, uint256[] pendingBatchIndices);
133     function reassignRewardsDistributor(address _newRewardsDistributor) external;
134     function isRewardsDistributor() external returns (bool);
135 }
136 
137 /// @title Orbs rewards distribution smart contract.
138 contract OrbsRewardsDistribution is Ownable, IOrbsRewardsDistribution {
139 
140     struct Distribution {
141         uint256 pendingBatchCount;
142         bool hasPendingBatches;
143         bytes32[] batchHashes;
144     }
145 
146     /// The Orbs token smart contract address.
147     IERC20 public orbs;
148 
149     /// Mapping of all ongoing distribution events.
150     /// Distribution events are identified by a unique string
151     /// for the duration of their execution.
152     /// After completion or abortion the same name may be used again.
153     mapping(string => Distribution) distributions;
154 
155     /// Address of an optional rewards-distributor account/contract.
156     /// Meant to be used in the future, should an alternate implementation of
157     /// batch commitment mechanism will be needed. Alternately, manual
158     /// transfers without batch commitment may be executed by rewardsDistributor.
159     /// Only the address of rewardsDistributor may call distributeRewards()
160     address public rewardsDistributor;
161 
162     /// Constructor to set Orbs token contract address.
163     /// @param _orbs IERC20 The address of the Orbs token contract.
164     constructor(IERC20 _orbs) public {
165         require(address(_orbs) != address(0), "Address must not be 0!");
166 
167         rewardsDistributor = address(0);
168         orbs = _orbs;
169     }
170 
171     /// Announce a new distribution event, and commits to a list of transfer batch
172     /// hashes. Only the contract owner may call this method. The method verifies
173     /// a distributionEvent with the same name is not currently ongoing.
174     /// It then records commitments for all reward payments in the form of batch
175     /// hashes array to state.
176     /// @param _distributionEvent string Name of a new distribution event
177     /// @param _batchHashes bytes32[] The address of the OrbsValidators contract.
178     function announceDistributionEvent(string _distributionEvent, bytes32[] _batchHashes) external onlyOwner {
179         require(!distributions[_distributionEvent].hasPendingBatches, "distribution event is currently ongoing");
180         require(_batchHashes.length > 0, "at least one batch must be announced");
181 
182         for (uint256 i = 0; i < _batchHashes.length; i++) {
183             require(_batchHashes[i] != bytes32(0), "batch hash may not be 0x0");
184         }
185 
186         // store distribution event record
187         Distribution storage distribution = distributions[_distributionEvent];
188         distribution.pendingBatchCount = _batchHashes.length;
189         distribution.hasPendingBatches = true;
190         distribution.batchHashes = _batchHashes;
191 
192         emit RewardsDistributionAnnounced(_distributionEvent, _batchHashes, _batchHashes.length);
193     }
194 
195     /// Aborts an ongoing distributionEvent and revokes all batch commitments.
196     /// Only the contract owner may call this method.
197     /// @param _distributionEvent string Name of a new distribution event
198     function abortDistributionEvent(string _distributionEvent) external onlyOwner {
199         require(distributions[_distributionEvent].hasPendingBatches, "distribution event is not currently ongoing");
200 
201         (bytes32[] memory abortedBatchHashes, uint256[] memory abortedBatchIndices) = this.getPendingBatches(_distributionEvent);
202 
203         delete distributions[_distributionEvent];
204 
205         emit RewardsDistributionAborted(_distributionEvent, abortedBatchHashes, abortedBatchIndices);
206     }
207 
208     /// Carry out and log transfers in batch. receives two arrays of same length
209     /// representing rewards payments for a list of reward recipients.
210     /// distributionEvent is only provided for logging purposes.
211     /// @param _distributionEvent string Name of a new distribution event
212     /// @param _recipients address[] a list of recipients addresses
213     /// @param _amounts uint256[] a list of amounts to transfer each recipient at the corresponding array index
214     function _distributeRewards(string _distributionEvent, address[] _recipients, uint256[] _amounts) private {
215         uint256 batchSize = _recipients.length;
216         require(batchSize == _amounts.length, "array length mismatch");
217 
218         for (uint256 i = 0; i < batchSize; i++) {
219             require(_recipients[i] != address(0), "recipient must be a valid address");
220             require(orbs.transfer(_recipients[i], _amounts[i]), "transfer failed");
221             emit RewardDistributed(_distributionEvent, _recipients[i], _amounts[i]);
222         }
223     }
224 
225     /// Perform a single batch transfer, bypassing announcement/commitment flow.
226     /// Only the assigned rewardsDistributor account may call this method.
227     /// Provided to allow another contract or user to implement an alternative
228     /// batch commitment mechanism, should on be needed in the future.
229     /// @param _distributionEvent string Name of a new distribution event
230     /// @param _recipients address[] a list of recipients addresses
231     /// @param _amounts uint256[] a list of amounts to transfer each recipient at the corresponding array index
232     function distributeRewards(string _distributionEvent, address[] _recipients, uint256[] _amounts) external onlyRewardsDistributor {
233         _distributeRewards(_distributionEvent, _recipients, _amounts);
234     }
235 
236     /// Accepts a batch of payments associated with a distributionEvent.
237     /// The batch will be executed only if it matches the commitment hash
238     /// published by this contract's owner in a previous
239     /// announceDistributionEvent() call. Once validated against an existing
240     /// batch hash commitment, the commitment is cleared to ensure the batch
241     /// cannot be executed twice.
242     /// If this was the last batch in distributionEvent, the event record is
243     /// cleared logged as completed.
244     /// @param _distributionEvent string Name of a new distribution event
245     /// @param _recipients address[] a list of recipients addresses
246     /// @param _amounts uint256[] a list of amounts to transfer each recipient at the corresponding array index
247     /// @param _batchIndex uint256 index of the specified batch in commitments array
248     function executeCommittedBatch(string _distributionEvent, address[] _recipients, uint256[] _amounts, uint256 _batchIndex) external {
249         Distribution storage distribution = distributions[_distributionEvent];
250         bytes32[] storage batchHashes = distribution.batchHashes;
251 
252         require(_recipients.length == _amounts.length, "array length mismatch");
253         require(_recipients.length > 0, "at least one reward must be included in a batch");
254         require(distribution.hasPendingBatches, "distribution event is not currently ongoing");
255         require(batchHashes.length > _batchIndex, "batch number out of range");
256         require(batchHashes[_batchIndex] != bytes32(0), "specified batch number already executed");
257 
258         bytes32 calculatedHash = calcBatchHash(_recipients, _amounts, _batchIndex);
259         require(batchHashes[_batchIndex] == calculatedHash, "batch hash does not match");
260 
261         distribution.pendingBatchCount--;
262         batchHashes[_batchIndex] = bytes32(0); // delete
263 
264         if (distribution.pendingBatchCount == 0) {
265             delete distributions[_distributionEvent];
266             emit RewardsDistributionCompleted(_distributionEvent);
267         }
268         emit RewardsBatchExecuted(_distributionEvent, calculatedHash, _batchIndex);
269 
270         _distributeRewards(_distributionEvent, _recipients, _amounts);
271     }
272 
273     /// Returns all pending (not yet executed) batch hashes and indices
274     /// associated with a distributionEvent.
275     /// @param _distributionEvent string Name of a new distribution event
276     /// @return pendingBatchHashes bytes32[]
277     /// @return pendingBatchIndices uint256[]
278     function getPendingBatches(string _distributionEvent) external view returns (bytes32[] pendingBatchHashes, uint256[] pendingBatchIndices) {
279         Distribution storage distribution = distributions[_distributionEvent];
280         bytes32[] storage batchHashes = distribution.batchHashes;
281         uint256 pendingBatchCount = distribution.pendingBatchCount;
282         uint256 batchHashesLength = distribution.batchHashes.length;
283 
284         pendingBatchHashes = new bytes32[](pendingBatchCount);
285         pendingBatchIndices = new uint256[](pendingBatchCount);
286 
287         uint256 addNextAt = 0;
288         for (uint256 i = 0; i < batchHashesLength; i++) {
289             bytes32 hash = batchHashes[i];
290             if (hash != bytes32(0)) {
291                 pendingBatchIndices[addNextAt] = i;
292                 pendingBatchHashes[addNextAt] = hash;
293                 addNextAt++;
294             }
295         }
296     }
297 
298     /// For disaster recovery purposes. transfers all orbs from this contract to owner.
299     /// Only the contract owner may call this method.
300     /// Transfers away any Orbs balance from this contract to the owners address
301     function drainOrbs() external onlyOwner {
302         uint256 balance = orbs.balanceOf(address(this));
303         orbs.transfer(owner(), balance);
304     }
305 
306     /// Assigns a new rewards-distributor account.
307     /// To revoke the current rewards-distributor's rights call this method with 0x0.
308     /// Only the contract owner may call this method.
309     /// @param _newRewardsDistributor The address to set as the new rewards-distributor.
310     function reassignRewardsDistributor(address _newRewardsDistributor) external onlyOwner {
311         emit RewardsDistributorReassigned(rewardsDistributor, _newRewardsDistributor);
312         rewardsDistributor = _newRewardsDistributor;
313     }
314 
315     /// Return true if `msg.sender` is the assigned rewards-distributor.
316     function isRewardsDistributor() public view returns(bool) {
317         return msg.sender == rewardsDistributor;
318     }
319 
320     /// Throws if called by any account other than the rewards-distributor.
321     modifier onlyRewardsDistributor() {
322         require(isRewardsDistributor(), "only the assigned rewards-distributor may call this method");
323         _;
324     }
325 
326     /// Computes a hash code form a batch payment specification.
327     /// @param _recipients address[] a list of recipients addresses
328     /// @param _amounts uint256[] a list of amounts to transfer each recipient at the corresponding array index
329     /// @param _batchIndex uint256 index of the specified batch in commitments array
330     function calcBatchHash(address[] _recipients, uint256[] _amounts, uint256 _batchIndex) private pure returns (bytes32) {
331         bytes memory batchData = abi.encodePacked(_batchIndex, _recipients.length, _recipients, _amounts);
332 
333         uint256 expectedLength = 32 * (2 + _recipients.length + _amounts.length);
334         require(batchData.length == expectedLength, "unexpected data length");
335 
336         return keccak256(batchData);
337     }
338 }