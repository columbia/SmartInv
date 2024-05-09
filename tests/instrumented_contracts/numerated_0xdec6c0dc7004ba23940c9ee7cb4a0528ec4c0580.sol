1 pragma solidity ^0.4.24;
2 
3 /// @title DigixDAO's 2nd Carbon Voting contracts
4 /// @author Digix Holdings
5 
6 /// @notice NumberCarbonVoting contract, generalized carbon voting contract
7 contract NumberCarbonVoting {
8     uint256 public start;
9     uint256 public end;
10     struct VoteItem {
11         bytes32 title;
12         uint256 minValue;
13         uint256 maxValue;
14         mapping (address => uint256) votes;
15     }
16 
17     mapping(uint256 => VoteItem) public voteItems;
18     uint256 public itemCount;
19 
20     mapping(address => bool) public voted;
21     address[] public voters;
22 
23     constructor (
24         uint256 _itemCount,
25         bytes32[] _titles,
26         uint256[] _minValues,
27         uint256[] _maxValues,
28         uint256 _start,
29         uint256 _end
30     )
31         public
32     {
33         itemCount = _itemCount;
34         for (uint256 i=0;i<itemCount;i++) {
35             voteItems[i].title = _titles[i];
36             voteItems[i].minValue = _minValues[i];
37             voteItems[i].maxValue = _maxValues[i];
38         }
39         start = _start;
40         end = _end;
41     }
42 
43     function vote(uint256[] _votes) public {
44         require(_votes.length == itemCount);
45         require(now >= start && now < end);
46 
47         address voter = msg.sender;
48         if (!voted[voter]) {
49             voted[voter] = true;
50             voters.push(voter);
51         }
52 
53         for (uint256 i=0;i<itemCount;i++) {
54             require(_votes[i] >= voteItems[i].minValue && _votes[i] <= voteItems[i].maxValue);
55             voteItems[i].votes[voter] = _votes[i];
56         }
57     }
58 
59     function getAllVoters() public view
60         returns (address[] _voters)
61     {
62         _voters = voters;
63     }
64 
65     function getVotesForItem(uint256 _itemIndex) public view
66         returns (address[] _voters, uint256[] _votes)
67     {
68         return getVotesForItemFromVoterIndex(_itemIndex, 0, voters.length);
69     }
70 
71 
72     /// @dev get votes for a subset of _count voters, from _voterIndex
73     function getVotesForItemFromVoterIndex(uint256 _itemIndex, uint256 _voterIndex, uint256 _count) public view
74         returns (address[] _voters, uint256[] _votes)
75     {
76         require(_itemIndex < itemCount);
77         require(_voterIndex < voters.length);
78 
79         _count = min(voters.length - _voterIndex, _count);
80         _voters = new address[](_count);
81         _votes = new uint256[](_count);
82         for (uint256 i=0;i<_count;i++) {
83             _voters[i] = voters[_voterIndex + i];
84             _votes[i] = voteItems[_itemIndex].votes[_voters[i]];
85         }
86     }
87 
88     function min(uint256 _a, uint256 _b) returns (uint256 _min) {
89         _min = _a;
90         if (_b < _a) {
91             _min = _b;
92         }
93     }
94 
95     function getVoteItemDetails(uint256 _itemIndex) public view
96         returns (bytes32 _title, uint256 _minValue, uint256 _maxValue)
97     {
98         _title = voteItems[_itemIndex].title;
99         _minValue = voteItems[_itemIndex].minValue;
100         _maxValue = voteItems[_itemIndex].maxValue;
101     }
102 
103     function getUserVote(address _voter) public view
104         returns (uint256[] _votes, bool _voted)
105     {
106         _voted = voted[_voter];
107         _votes = new uint256[](itemCount);
108         for (uint256 i=0;i<itemCount;i++) {
109             _votes[i] = voteItems[i].votes[_voter];
110         }
111     }
112 }
113 
114 /// @notice the actual carbon voting contract, specific to DigixDAO's 2nd carbon voting: DigixDAO's first proposal
115 contract DigixDaoFirstProposal is NumberCarbonVoting {
116     constructor (
117         uint256 _itemCount,
118         bytes32[] _titles,
119         uint256[] _minValues,
120         uint256[] _maxValues,
121         uint256 _start,
122         uint256 _end
123     ) public NumberCarbonVoting(
124         _itemCount,
125         _titles,
126         _minValues,
127         _maxValues,
128         _start,
129         _end
130     ) {
131     }
132 }