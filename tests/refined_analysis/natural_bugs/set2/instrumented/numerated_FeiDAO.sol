1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/governance/compatibility/GovernorCompatibilityBravo.sol";
5 import "@openzeppelin/contracts/governance/extensions/GovernorTimelockCompound.sol";
6 import "@openzeppelin/contracts/governance/extensions/GovernorVotesComp.sol";
7 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20VotesComp.sol";
8 
9 // Forked functionality from https://github.com/unlock-protocol/unlock/blob/master/smart-contracts/contracts/UnlockProtocolGovernor.sol
10 
11 contract FeiDAO is GovernorCompatibilityBravo, GovernorVotesComp, GovernorTimelockCompound {
12     uint256 private _votingDelay = 1; // reduce voting delay to 1 block
13     uint256 private _votingPeriod = 13000; // extend voting period to 48h
14     uint256 private _quorum = 25_000_000e18;
15     uint256 private _proposalThreshold = 2_500_000e18;
16 
17     address private _guardian;
18     uint256 private _eta;
19     address public constant BACKUP_GOVERNOR = 0x4C895973334Af8E06fd6dA4f723Ac24A5f259e6B;
20     uint256 public constant ROLLBACK_DEADLINE = 1635724800; // Nov 1, 2021 midnight UTC
21 
22     constructor(
23         ERC20VotesComp tribe,
24         ICompoundTimelock timelock,
25         address guardian
26     ) GovernorVotesComp(tribe) GovernorTimelockCompound(timelock) Governor("Fei DAO") {
27         _guardian = guardian;
28     }
29 
30     /*
31      * Events to track params changes
32      */
33     event QuorumUpdated(uint256 oldQuorum, uint256 newQuorum);
34     event VotingDelayUpdated(uint256 oldVotingDelay, uint256 newVotingDelay);
35     event VotingPeriodUpdated(uint256 oldVotingPeriod, uint256 newVotingPeriod);
36     event ProposalThresholdUpdated(uint256 oldProposalThreshold, uint256 newProposalThreshold);
37     event RollbackQueued(uint256 eta);
38     event Rollback();
39 
40     function votingDelay() public view override returns (uint256) {
41         return _votingDelay;
42     }
43 
44     function votingPeriod() public view override returns (uint256) {
45         return _votingPeriod;
46     }
47 
48     function quorum(uint256) public view override returns (uint256) {
49         return _quorum;
50     }
51 
52     function proposalThreshold() public view override returns (uint256) {
53         return _proposalThreshold;
54     }
55 
56     // governance setters
57     function setVotingDelay(uint256 newVotingDelay) public onlyGovernance {
58         uint256 oldVotingDelay = _votingDelay;
59         _votingDelay = newVotingDelay;
60         emit VotingDelayUpdated(oldVotingDelay, newVotingDelay);
61     }
62 
63     function setVotingPeriod(uint256 newVotingPeriod) public onlyGovernance {
64         uint256 oldVotingPeriod = _votingPeriod;
65         _votingPeriod = newVotingPeriod;
66         emit VotingPeriodUpdated(oldVotingPeriod, newVotingPeriod);
67     }
68 
69     function setQuorum(uint256 newQuorum) public onlyGovernance {
70         uint256 oldQuorum = _quorum;
71         _quorum = newQuorum;
72         emit QuorumUpdated(oldQuorum, newQuorum);
73     }
74 
75     function setProposalThreshold(uint256 newProposalThreshold) public onlyGovernance {
76         uint256 oldProposalThreshold = _proposalThreshold;
77         _proposalThreshold = newProposalThreshold;
78         emit ProposalThresholdUpdated(oldProposalThreshold, newProposalThreshold);
79     }
80 
81     /// @notice one-time option to roll back the DAO to old GovernorAlpha
82     /// @dev guardian-only, and expires after the deadline. This function is here as a fallback in case something goes wrong.
83     function __rollback(uint256 eta) external {
84         require(msg.sender == _guardian, "FeiDAO: caller not guardian");
85         // Deleting guardian prevents multiple triggers of this function
86         _guardian = address(0);
87 
88         require(eta <= ROLLBACK_DEADLINE, "FeiDAO: rollback expired");
89         _eta = eta;
90 
91         ICompoundTimelock _timelock = ICompoundTimelock(payable(timelock()));
92         _timelock.queueTransaction(timelock(), 0, "setPendingAdmin(address)", abi.encode(BACKUP_GOVERNOR), eta);
93 
94         emit RollbackQueued(eta);
95     }
96 
97     /// @notice complete the rollback
98     function __executeRollback() external {
99         require(_eta <= block.timestamp, "FeiDAO: too soon");
100         require(_guardian == address(0), "FeiDAO: no queue");
101 
102         ICompoundTimelock _timelock = ICompoundTimelock(payable(timelock()));
103         _timelock.executeTransaction(timelock(), 0, "setPendingAdmin(address)", abi.encode(BACKUP_GOVERNOR), _eta);
104 
105         emit Rollback();
106     }
107 
108     // The following functions are overrides required by Solidity.
109     function getVotes(address account, uint256 blockNumber)
110         public
111         view
112         override(Governor, IGovernor)
113         returns (uint256)
114     {
115         return super.getVotes(account, blockNumber);
116     }
117 
118     function state(uint256 proposalId)
119         public
120         view
121         override(IGovernor, Governor, GovernorTimelockCompound)
122         returns (ProposalState)
123     {
124         return super.state(proposalId);
125     }
126 
127     function propose(
128         address[] memory targets,
129         uint256[] memory values,
130         bytes[] memory calldatas,
131         string memory description
132     ) public override(IGovernor, Governor, GovernorCompatibilityBravo) returns (uint256) {
133         return super.propose(targets, values, calldatas, description);
134     }
135 
136     function _execute(
137         uint256 proposalId,
138         address[] memory targets,
139         uint256[] memory values,
140         bytes[] memory calldatas,
141         bytes32 descriptionHash
142     ) internal override(Governor, GovernorTimelockCompound) {
143         super._execute(proposalId, targets, values, calldatas, descriptionHash);
144     }
145 
146     function _cancel(
147         address[] memory targets,
148         uint256[] memory values,
149         bytes[] memory calldatas,
150         bytes32 descriptionHash
151     ) internal override(Governor, GovernorTimelockCompound) returns (uint256) {
152         return super._cancel(targets, values, calldatas, descriptionHash);
153     }
154 
155     function _executor() internal view override(Governor, GovernorTimelockCompound) returns (address) {
156         return super._executor();
157     }
158 
159     function supportsInterface(bytes4 interfaceId)
160         public
161         view
162         override(IERC165, Governor, GovernorTimelockCompound)
163         returns (bool)
164     {
165         return super.supportsInterface(interfaceId);
166     }
167 }
