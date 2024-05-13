1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {Governor, IGovernor} from "@openzeppelin/contracts/governance/Governor.sol";
5 import {GovernorSettings} from "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
6 import {GovernorVotesComp, IERC165} from "@openzeppelin/contracts/governance/extensions/GovernorVotesComp.sol";
7 import {GovernorCountingSimple} from "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
8 import {ERC20VotesComp} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20VotesComp.sol";
9 import {CoreRef} from "../../refs/CoreRef.sol";
10 import {TribeRoles} from "../../core/TribeRoles.sol";
11 import {GovernorQuickReaction} from "./GovernorQuickReaction.sol";
12 
13 contract NopeDAO is
14     Governor,
15     GovernorSettings,
16     GovernorVotesComp,
17     GovernorQuickReaction,
18     GovernorCountingSimple,
19     CoreRef
20 {
21     /// @notice Initial quorum required for a Nope proposal
22     uint256 private _quorum = 10_000_000e18;
23 
24     /// @notice Additional governance events
25     event QuorumUpdated(uint256 oldQuorum, uint256 newQuorum);
26 
27     constructor(ERC20VotesComp _tribe, address _core)
28         Governor("NopeDAO")
29         GovernorSettings(
30             0, /* 0 blocks */
31             26585, /* 4 days measured in blocks. Assumed 13s block time */
32             0
33         )
34         GovernorVotesComp(_tribe)
35         GovernorQuickReaction()
36         CoreRef(_core)
37     {}
38 
39     function quorum(uint256 blockNumber) public view override returns (uint256) {
40         return _quorum;
41     }
42 
43     ////////////     GOVERNOR ONLY FUNCTIONS     //////////////
44 
45     /// @notice Override of a Governor Settings function, to restrict to Tribe GOVERNOR
46     function setVotingDelay(uint256 newVotingDelay) public override onlyTribeRole(TribeRoles.GOVERNOR) {
47         _setVotingDelay(newVotingDelay);
48     }
49 
50     /// @notice Override of a Governor Settings function, to restrict to Tribe GOVERNOR
51     function setVotingPeriod(uint256 newVotingPeriod) public override onlyTribeRole(TribeRoles.GOVERNOR) {
52         _setVotingPeriod(newVotingPeriod);
53     }
54 
55     /// @notice Override of a Governor Settings function, to restrict to Tribe GOVERNOR
56     function setProposalThreshold(uint256 newProposalThreshold) public override onlyTribeRole(TribeRoles.GOVERNOR) {
57         _setProposalThreshold(newProposalThreshold);
58     }
59 
60     /// @notice Adjust quorum of NopeDAO. Restricted to GOVERNOR, not part of GovernorSettings
61     function setQuorum(uint256 newQuroum) public onlyTribeRole(TribeRoles.GOVERNOR) {
62         uint256 oldQuorum = _quorum;
63         _quorum = newQuroum;
64         emit QuorumUpdated(oldQuorum, newQuroum);
65     }
66 
67     // The following functions are overrides required by Solidity.
68 
69     function votingDelay() public view override(IGovernor, GovernorSettings) returns (uint256) {
70         return super.votingDelay();
71     }
72 
73     function votingPeriod() public view override(IGovernor, GovernorSettings) returns (uint256) {
74         return super.votingPeriod();
75     }
76 
77     function getVotes(address account, uint256 blockNumber) public view override(Governor) returns (uint256) {
78         return super.getVotes(account, blockNumber);
79     }
80 
81     function state(uint256 proposalId) public view override(GovernorQuickReaction, Governor) returns (ProposalState) {
82         return super.state(proposalId);
83     }
84 
85     function propose(
86         address[] memory targets,
87         uint256[] memory values,
88         bytes[] memory calldatas,
89         string memory description
90     ) public override(Governor) returns (uint256) {
91         return super.propose(targets, values, calldatas, description);
92     }
93 
94     function proposalThreshold() public view override(Governor, GovernorSettings) returns (uint256) {
95         return super.proposalThreshold();
96     }
97 
98     function _execute(
99         uint256 proposalId,
100         address[] memory targets,
101         uint256[] memory values,
102         bytes[] memory calldatas,
103         bytes32 descriptionHash
104     ) internal override(Governor) {
105         super._execute(proposalId, targets, values, calldatas, descriptionHash);
106     }
107 
108     function _cancel(
109         address[] memory targets,
110         uint256[] memory values,
111         bytes[] memory calldatas,
112         bytes32 descriptionHash
113     ) internal override(Governor) returns (uint256) {
114         return super._cancel(targets, values, calldatas, descriptionHash);
115     }
116 
117     function _executor() internal view override(Governor) returns (address) {
118         return super._executor();
119     }
120 
121     function supportsInterface(bytes4 interfaceId) public view override(Governor) returns (bool) {
122         return super.supportsInterface(interfaceId);
123     }
124 }
