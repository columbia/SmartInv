1 pragma solidity =0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 interface IGNBU is IERC20 {
16     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
17     function freeCirculation() external view returns (uint96);
18 }
19 
20 interface INimbusStakingPool {
21     function balanceOf(address account) external view returns (uint256);
22     function stakingToken() external view returns (IERC20);
23 }
24 
25 contract NimbusGovernorV1 {
26     struct Proposal {
27         uint id;
28         address proposer;
29         address[] targets;
30         uint[] values;
31         string[] signatures;
32         bytes[] calldatas;
33         uint startBlock;
34         uint endBlock;
35         uint forVotes;
36         uint againstVotes;
37         bool canceled;
38         bool executed;
39         mapping (address => Receipt) receipts;
40     }
41 
42     struct Receipt {
43         bool hasVoted;
44         bool support;
45         uint96 votes;
46     }
47 
48     enum ProposalState {
49         Pending,
50         Active,
51         Canceled,
52         Defeated,
53         Succeeded,
54         Executed
55     }
56 
57     string public constant name = "Nimbus Governor v1";
58     uint public constant proposalMaxOperations = 10; // 10 actions
59     uint public constant votingDelay = 1; // 1 block
60     uint public constant votingPeriod = 80_640; // ~14 days in blocks (assuming 15s blocks)
61 
62     uint96 public quorumPercentage = 4000; // 40% from GNBU free circulation, changeable by voting
63     uint96 public participationThresholdPercentage = 100; // 1% from GNBU free circulation, changeable by voting
64     uint96 public proposalStakeThresholdPercentage = 10; // 0.1% from GNBU free circulation, changeable by voting
65     uint96 public maxVoteWeightPercentage = 1000; // 10% from GNBU free circulation, changeable by voting
66     IGNBU public immutable GNBU;
67     uint public proposalCount;
68     INimbusStakingPool[] public stakingPools; 
69 
70     mapping (uint => Proposal) public proposals;
71     mapping (address => uint) public latestProposalIds;
72 
73     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
74     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
75 
76     event ProposalCreated(uint indexed id, address indexed proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);
77     event VoteCast(address indexed voter, uint indexed proposalId, bool indexed support, uint votes);
78     event ProposalCanceled(uint indexed id);
79     event ProposalExecuted(uint indexed id);
80     event ExecuteTransaction(address indexed target, uint value, string signature,  bytes data);
81 
82     constructor(address gnbu, address[] memory pools) {
83         GNBU = IGNBU(gnbu);
84         for (uint i = 0; i < pools.length; i++) {
85             stakingPools.push(INimbusStakingPool(pools[i]));
86         }
87     }
88 
89     receive() payable external {
90         revert();
91     }
92 
93     function quorumVotes() public view returns (uint) { 
94         return GNBU.freeCirculation() * quorumPercentage / 10000;
95     }
96 
97     function participationThreshold() public view returns (uint) { 
98         return GNBU.freeCirculation() * participationThresholdPercentage / 10000;
99     } 
100 
101     function proposalStakeThreshold() public view returns (uint) {
102         return GNBU.freeCirculation() * proposalStakeThresholdPercentage / 10000;
103     }
104 
105     function maxVoteWeight() public view returns (uint96) {
106         return GNBU.freeCirculation() * maxVoteWeightPercentage / 10000;
107     }
108 
109     function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) external returns (uint) {
110         require(GNBU.getPriorVotes(msg.sender, sub256(block.number, 1)) > participationThreshold(), "NimbusGovernorV1::propose: proposer votes below participation threshold");
111         require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "NimbusGovernorV1::propose: proposal function information arity mismatch");
112         require(targets.length != 0, "NimbusGovernorV1::propose: must provide actions");
113         require(targets.length <= proposalMaxOperations, "NimbusGovernorV1::propose: too many actions");
114 
115         uint latestProposalId = latestProposalIds[msg.sender];
116         if (latestProposalId != 0) {
117           ProposalState proposersLatestProposalState = state(latestProposalId);
118           require(proposersLatestProposalState != ProposalState.Active, "NimbusGovernorV1::propose: one live proposal per proposer, found an already active proposal");
119           require(proposersLatestProposalState != ProposalState.Pending, "NimbusGovernorV1::propose: one live proposal per proposer, found an already pending proposal");
120         }
121 
122         uint stakedAmount;
123         for (uint i = 0; i < stakingPools.length; i++) {
124             stakedAmount = add256(stakedAmount, stakingPools[i].balanceOf(msg.sender));
125         }
126         require(stakedAmount >= proposalStakeThreshold());
127 
128         uint startBlock = add256(block.number, votingDelay);
129         uint endBlock = add256(startBlock, votingPeriod);
130 
131         proposalCount++;
132         
133         uint id = proposalCount;
134 
135         proposals[id].id = id;
136         proposals[id].proposer = msg.sender;
137         proposals[id].targets = targets;
138         proposals[id].values = values;
139         proposals[id].signatures = signatures;
140         proposals[id].calldatas = calldatas;
141         proposals[id].startBlock = startBlock;
142         proposals[id].endBlock = endBlock;
143 
144         latestProposalIds[msg.sender] = id;
145 
146         emit ProposalCreated(id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
147         return id;
148     }
149 
150     function execute(uint proposalId) external payable {
151         require(state(proposalId) == ProposalState.Succeeded, "NimbusGovernorV1::execute: proposal can only be executed if it is succeeded");
152 
153         Proposal storage proposal = proposals[proposalId];
154         proposal.executed = true;
155         for (uint i = 0; i < proposal.targets.length; i++) {
156             bytes memory callData;
157 
158             if (bytes(proposal.signatures[i]).length == 0) {
159                 callData = proposal.calldatas[i];
160             } else {
161                 callData = abi.encodePacked(bytes4(keccak256(bytes(proposal.signatures[i]))), proposal.calldatas[i]);
162             }
163 
164             (bool success, bytes memory returnData) = proposal.targets[i].call{value :proposal.values[i]}(callData);
165             require(success, "NimbusGovernorV1::executeTransaction: Transaction execution reverted.");
166 
167             emit ExecuteTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i]);
168         }
169         emit ProposalExecuted(proposalId);
170     }
171 
172     function cancel(uint proposalId) external {
173         ProposalState proposalState = state(proposalId);
174         require(proposalState != ProposalState.Executed, "NimbusGovernorV1::cancel: cannot cancel executed proposal");
175 
176         Proposal storage proposal = proposals[proposalId];
177         require(GNBU.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < participationThreshold(), "NimbusGovernorV1::cancel: proposer above threshold");
178 
179         uint stakedAmount;
180         for (uint i = 0; i < stakingPools.length; i++) {
181             stakedAmount = add256(stakedAmount, stakingPools[i].balanceOf(proposal.proposer));
182         }
183         require(stakedAmount < proposalStakeThreshold(), "NimbusGovernorV1::cancel: proposer above threshold");
184 
185         proposal.canceled = true;
186         emit ProposalCanceled(proposalId);
187     }
188 
189     function getActions(uint proposalId) external view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
190         Proposal storage p = proposals[proposalId];
191         return (p.targets, p.values, p.signatures, p.calldatas);
192     }
193 
194     function getReceipt(uint proposalId, address voter) external view returns (Receipt memory) {
195         return proposals[proposalId].receipts[voter];
196     }
197 
198     function state(uint proposalId) public view returns (ProposalState) {
199         require(proposalCount >= proposalId && proposalId > 0, "NimbusGovernorV1::state: invalid proposal id");
200         Proposal storage proposal = proposals[proposalId];
201         if (proposal.canceled) {
202             return ProposalState.Canceled;
203         } else if (block.number <= proposal.startBlock) {
204             return ProposalState.Pending;
205         } else if (block.number <= proposal.endBlock) {
206             return ProposalState.Active;
207         } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {
208             return ProposalState.Defeated;
209         } else if (!proposal.executed) {
210             return ProposalState.Succeeded;
211         } else {
212             return ProposalState.Executed;
213         }
214     }
215 
216     function castVote(uint proposalId, bool support) external {
217         return _castVote(msg.sender, proposalId, support);
218     }
219 
220     function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) external {
221         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
222         bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
223         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
224         address signatory = ecrecover(digest, v, r, s);
225         require(signatory != address(0), "NimbusGovernorV1::castVoteBySig: invalid signature");
226         return _castVote(signatory, proposalId, support);
227     }
228 
229     function _castVote(address voter, uint proposalId, bool support) internal {
230         require(state(proposalId) == ProposalState.Active, "NimbusGovernorV1::_castVote: voting is closed");
231         Proposal storage proposal = proposals[proposalId];
232         Receipt storage receipt = proposal.receipts[voter];
233         require(receipt.hasVoted == false, "NimbusGovernorV1::_castVote: voter already voted");
234         uint96 votes = GNBU.getPriorVotes(voter, proposal.startBlock);
235         require(votes > participationThreshold(), "NimbusGovernorV1::_castVote: voter votes below participation threshold");
236 
237         uint96 maxWeight = maxVoteWeight();
238         if (votes > maxWeight) votes = maxWeight;
239 
240         if (support) {
241             proposal.forVotes = add256(proposal.forVotes, votes);
242         } else {
243             proposal.againstVotes = add256(proposal.againstVotes, votes);
244         }
245 
246         receipt.hasVoted = true;
247         receipt.support = support;
248         receipt.votes = votes;
249 
250         emit VoteCast(voter, proposalId, support, votes);
251     }
252 
253     function updateStakingPoolAdd(address newStakingPool) external {
254         require(msg.sender == address(this), "NimbusGovernorV1::updateStakingPoolAdd: Call must come from Governor");
255         INimbusStakingPool pool = INimbusStakingPool(newStakingPool);
256         require (pool.stakingToken() == GNBU, "NimbusGovernorV1::updateStakingPoolAdd: Wrong pool staking tokens");
257 
258         for (uint i; i < stakingPools.length; i++) {
259             require (address(stakingPools[i]) != newStakingPool, "NimbusGovernorV1::updateStakingPoolAdd: Pool exists");
260         }
261         stakingPools.push(pool);
262     }
263 
264     function updateStakingPoolRemove(uint poolIndex) external {
265         require(msg.sender == address(this), "NimbusGovernorV1::updateStakingPoolRemove: Call must come from Governor");
266         stakingPools[poolIndex] = stakingPools[stakingPools.length - 1];
267         stakingPools.pop();
268     }
269 
270     function updateQuorumPercentage(uint96 newQuorumPercentage) external {
271         require(msg.sender == address(this), "NimbusGovernorV1::updateQuorumPercentage: Call must come from Governor");
272         quorumPercentage = newQuorumPercentage;
273     }
274 
275     function updateParticipationThresholdPercentage(uint96 newParticipationThresholdPercentage) external {
276         require(msg.sender == address(this), "NimbusGovernorV1::updateParticipationThresholdPercentage: Call must come from Governor");
277         participationThresholdPercentage = newParticipationThresholdPercentage;
278     }
279 
280     function updateProposalStakeThresholdPercentage(uint96 newProposalStakeThresholdPercentage) external {
281         require(msg.sender == address(this), "NimbusGovernorV1::updateProposalStakeThresholdPercentage: Call must come from Governor");
282         proposalStakeThresholdPercentage = newProposalStakeThresholdPercentage;
283     }
284 
285     function updateMaxVoteWeightPercentage(uint96 newMaxVoteWeightPercentage) external {
286         require(msg.sender == address(this), "NimbusGovernorV1::updateMaxVoteWeightPercentage: Call must come from Governor");
287         maxVoteWeightPercentage = newMaxVoteWeightPercentage;
288     }
289 
290     function add256(uint256 a, uint256 b) internal pure returns (uint) {
291         uint c = a + b;
292         require(c >= a, "addition overflow");
293         return c;
294     }
295 
296     function sub256(uint256 a, uint256 b) internal pure returns (uint) {
297         require(b <= a, "subtraction underflow");
298         return a - b;
299     }
300 
301     function getChainId() internal view returns (uint) {
302         return block.chainid;
303     }
304 }