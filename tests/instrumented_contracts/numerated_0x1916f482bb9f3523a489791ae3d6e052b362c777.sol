1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 contract MoonCatKeyVote {
6 
7     // Should the MoonCatRescue developers destroy their private key so that no future Genesis MoonCats can ever be released?
8     // true  = Yes
9     // false = No
10 
11     event VoteSubmitted(address voter, bool vote);
12 
13     uint public voteStartTime = 0;
14     bool public voteCancelled = false;
15     mapping (address => bool) public hasVoted;
16     uint32 public yesVotes = 0;
17     uint32 public noVotes = 0;
18 
19     //bytes32 public immutable voterRollSha256;
20     bytes32 public immutable merkleRoot;
21     address public immutable owner;
22 
23     modifier onlyOwner {
24         require(msg.sender == owner, "Owner Only");
25         _;
26     }
27 
28     modifier voteContractIsPending {
29         require(!voteCancelled, "Vote Contract Cancelled");
30         require(voteStartTime == 0, "Vote Already Started");
31         _;
32     }
33 
34     modifier voteContractIsActive {
35         require(!voteCancelled, "Vote Contract Cancelled");
36         require(voteStartTime > 0, "Vote Not Started");
37         require(block.timestamp < (voteStartTime + 48 hours), "Vote Ended");
38         _;
39     }
40 
41     modifier voteContractIsComplete {
42         require(!voteCancelled, "Vote Contract Cancelled");
43         require(voteStartTime > 0, "Vote Not Started");
44         require(block.timestamp > (voteStartTime + 48 hours), "Vote Not Ended");
45         _;
46     }
47 
48     constructor(bytes32 merkleRoot_) {
49         merkleRoot = merkleRoot_;
50         owner = msg.sender;
51     }
52 
53     function startVote() public onlyOwner voteContractIsPending  {
54         voteStartTime = block.timestamp;
55     }
56 
57     function cancelVote() public onlyOwner voteContractIsPending {
58         voteCancelled = true;
59     }
60 
61     function getResult() public view voteContractIsComplete returns (bool) {
62         return (yesVotes > noVotes);
63     }
64 
65     uint24 empty = 0;
66 
67     function submitVote(bytes32[] calldata eligibilityProof, bool vote) public voteContractIsActive  {
68         require(!hasVoted[msg.sender], "Duplicate Vote");
69 
70         // https://github.com/miguelmota/merkletreejs-solidity/blob/master/contracts/MerkleProof.sol
71         bytes32 computedHash = keccak256(abi.encodePacked(msg.sender));
72         for (uint256 i = 0; i < eligibilityProof.length; i++) {
73             bytes32 proofElement = eligibilityProof[i];
74 
75             if (computedHash < proofElement) {
76                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
77             } else {
78                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
79             }
80         }
81 
82         require(computedHash == merkleRoot, "Ineligible Voter");
83 
84         hasVoted[msg.sender] = true;
85 
86         if(vote){
87             yesVotes++;
88         } else {
89             noVotes++;
90         }
91 
92         emit VoteSubmitted(msg.sender, vote);
93 
94     }
95 }