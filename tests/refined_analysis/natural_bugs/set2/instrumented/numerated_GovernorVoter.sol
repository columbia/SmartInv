1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../../refs/CoreRef.sol";
5 import "../../core/TribeRoles.sol";
6 
7 interface IMetagovGovernor {
8     // OpenZeppelin Governor propose signature
9     function propose(
10         address[] memory targets,
11         uint256[] memory values,
12         bytes[] memory calldatas,
13         string memory description
14     ) external returns (uint256 proposalId);
15 
16     // Governor Bravo propose signature
17     function propose(
18         address[] memory targets,
19         uint256[] memory values,
20         string[] memory signatures,
21         bytes[] memory calldatas,
22         string memory description
23     ) external returns (uint256 proposalId);
24 
25     function castVote(uint256 proposalId, uint8 support) external returns (uint256 weight);
26 
27     function state(uint256 proposalId) external view returns (uint256);
28 }
29 
30 /// @title Abstract class to interact with an OZ governor.
31 /// @author Fei Protocol
32 abstract contract GovernorVoter is CoreRef {
33     // Events
34     event Proposed(IMetagovGovernor indexed governor, uint256 proposalId);
35     event Voted(IMetagovGovernor indexed governor, uint256 proposalId, uint256 weight, uint8 support);
36 
37     /// @notice propose a new proposal on the target OZ governor.
38     function proposeOZ(
39         IMetagovGovernor governor,
40         address[] memory targets,
41         uint256[] memory values,
42         bytes[] memory calldatas,
43         string memory description
44     ) external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) returns (uint256) {
45         uint256 proposalId = governor.propose(targets, values, calldatas, description);
46         emit Proposed(governor, proposalId);
47         return proposalId;
48     }
49 
50     /// @notice propose a new proposal on the target Bravo governor.
51     function proposeBravo(
52         IMetagovGovernor governor,
53         address[] memory targets,
54         uint256[] memory values,
55         string[] memory signatures,
56         bytes[] memory calldatas,
57         string memory description
58     ) external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) returns (uint256) {
59         uint256 proposalId = governor.propose(targets, values, signatures, calldatas, description);
60         emit Proposed(governor, proposalId);
61         return proposalId;
62     }
63 
64     /// @notice cast a vote on a given proposal on the target governor.
65     function castVote(
66         IMetagovGovernor governor,
67         uint256 proposalId,
68         uint8 support
69     ) external onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN) returns (uint256) {
70         uint256 weight = governor.castVote(proposalId, support);
71         emit Voted(governor, proposalId, weight, support);
72         return weight;
73     }
74 }
