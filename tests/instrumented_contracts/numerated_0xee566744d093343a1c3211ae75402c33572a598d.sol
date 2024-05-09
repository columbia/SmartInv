1 /**
2   * The Movement
3   * Decentralized Autonomous Organization
4   */
5   
6 pragma solidity ^0.4.18;
7 
8 contract MovementVoting {
9     mapping(address => int256) public votes;
10     address[] public voters;
11     uint256 public endBlock;
12 	address public admin;
13 	
14     event onVote(address indexed voter, int256 indexed proposalId);
15     event onUnVote(address indexed voter, int256 indexed proposalId);
16 
17     function MovementVoting(uint256 _endBlock) {
18         endBlock = _endBlock;
19 		admin = msg.sender;
20     }
21 
22 	function changeEndBlock(uint256 _endBlock)
23 	onlyAdmin {
24 		endBlock = _endBlock;
25 	}
26 
27     function vote(int256 proposalId) {
28 
29         require(msg.sender != address(0));
30         require(proposalId > 0);
31         require(endBlock == 0 || block.number <= endBlock);
32         if (votes[msg.sender] == 0) {
33             voters.push(msg.sender);
34         }
35 
36         votes[msg.sender] = proposalId;
37 
38         onVote(msg.sender, proposalId);
39     }
40 
41     function unVote() {
42 
43         require(msg.sender != address(0));
44         require(votes[msg.sender] > 0);
45         int256 proposalId = votes[msg.sender];
46 		votes[msg.sender] = -1;
47         onUnVote(msg.sender, proposalId);
48     }
49 
50     function votersCount()
51     constant
52     returns(uint256) {
53         return voters.length;
54     }
55 
56     function getVoters(uint256 offset, uint256 limit)
57     constant
58     returns(address[] _voters, int256[] _proposalIds) {
59 
60         if (offset < voters.length) {
61             uint256 resultLength = limit;
62             uint256 index = 0;
63 
64          
65             if (voters.length - offset < limit) {
66                 resultLength = voters.length - offset;
67             }
68 
69             _voters = new address[](resultLength);
70             _proposalIds = new int256[](resultLength);
71 
72             for(uint256 i = offset; i < offset + resultLength; i++) {
73                 _voters[index] = voters[i];
74                 _proposalIds[index] = votes[voters[i]];
75                 index++;
76             }
77 
78             return (_voters, _proposalIds);
79         }
80     }
81 
82 	modifier onlyAdmin() {
83 		if (msg.sender != admin) revert();
84 		_;
85 	}
86 }