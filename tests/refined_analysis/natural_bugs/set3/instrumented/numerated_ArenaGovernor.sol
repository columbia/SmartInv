1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.10;
3 
4 import "@openzeppelin/contracts/governance/Governor.sol";
5 import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
6 import "@openzeppelin/contracts/governance/compatibility/GovernorCompatibilityBravo.sol";
7 import "@openzeppelin/contracts/governance/extensions/GovernorPreventLateQuorum.sol";
8 import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
9 import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
10 
11 contract ArenaGovernor is
12     Governor,
13     GovernorSettings,
14     GovernorCompatibilityBravo,
15     GovernorPreventLateQuorum,
16     GovernorVotes,
17     GovernorTimelockControl
18 {
19     constructor(IVotes _token, TimelockController _timelock)
20         Governor("ArenaGovernor")
21         GovernorSettings(
22             1, /* 1 block */
23             216_000, /* 5 days */
24             50_000e18 /* minimum proposal threshold of 50_000 tokens */
25         )
26         GovernorPreventLateQuorum(
27             129_600 /* 3 days */
28         )
29         GovernorVotes(_token)
30         GovernorTimelockControl(_timelock)
31     {}
32 
33     function quorum(uint256 blockNumber) public pure override returns (uint256) {
34         return 10_000_000e18; // 10M tokens
35     }
36 
37     // The following functions are overrides required by Solidity.
38 
39     function votingDelay() public view override(IGovernor, GovernorSettings) returns (uint256) {
40         return super.votingDelay();
41     }
42 
43     function votingPeriod() public view override(IGovernor, GovernorSettings) returns (uint256) {
44         return super.votingPeriod();
45     }
46 
47     function getVotes(address account, uint256 blockNumber)
48         public
49         view
50         override(IGovernor, GovernorVotes)
51         returns (uint256)
52     {
53         return super.getVotes(account, blockNumber);
54     }
55 
56     function state(uint256 proposalId)
57         public
58         view
59         override(Governor, IGovernor, GovernorTimelockControl)
60         returns (ProposalState)
61     {
62         return super.state(proposalId);
63     }
64 
65     function proposalDeadline(uint256 proposalId)
66         public
67         view
68         override(Governor, IGovernor, GovernorPreventLateQuorum)
69         returns (uint256)
70     {
71         return super.proposalDeadline(proposalId);
72     }
73 
74     function propose(
75         address[] memory targets,
76         uint256[] memory values,
77         bytes[] memory calldatas,
78         string memory description
79     ) public override(Governor, GovernorCompatibilityBravo, IGovernor) returns (uint256) {
80         return super.propose(targets, values, calldatas, description);
81     }
82 
83     function proposalThreshold()
84         public
85         view
86         override(Governor, GovernorSettings)
87         returns (uint256)
88     {
89         return super.proposalThreshold();
90     }
91 
92     function _execute(
93         uint256 proposalId,
94         address[] memory targets,
95         uint256[] memory values,
96         bytes[] memory calldatas,
97         bytes32 descriptionHash
98     ) internal override(Governor, GovernorTimelockControl) {
99         super._execute(proposalId, targets, values, calldatas, descriptionHash);
100     }
101 
102     function _cancel(
103         address[] memory targets,
104         uint256[] memory values,
105         bytes[] memory calldatas,
106         bytes32 descriptionHash
107     ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
108         return super._cancel(targets, values, calldatas, descriptionHash);
109     }
110 
111     function _castVote(
112         uint256 proposalId,
113         address account,
114         uint8 support,
115         string memory reason
116     ) internal override(Governor, GovernorPreventLateQuorum) returns (uint256) {
117         return super._castVote(proposalId, account, support, reason);
118     }
119 
120     function _executor()
121         internal
122         view
123         override(Governor, GovernorTimelockControl)
124         returns (address)
125     {
126         return super._executor();
127     }
128 
129     function supportsInterface(bytes4 interfaceId)
130         public
131         view
132         override(Governor, IERC165, GovernorTimelockControl)
133         returns (bool)
134     {
135         return super.supportsInterface(interfaceId);
136     }
137 }
