1 pragma solidity ^0.4.24;
2 
3 /// @title DigixDAO Carbon Voting contract
4 /// @author Digix Holdings
5 /// @notice NumberCarbonVoting contract, generalized carbon voting contract
6 contract NumberCarbonVoting {
7     uint256 public start;
8     uint256 public end;
9     struct VoteItem {
10         bytes32 title;
11         uint256 minValue;
12         uint256 maxValue;
13         mapping (address => uint256) votes;
14     }
15 
16     mapping(uint256 => VoteItem) public voteItems;
17     uint256 public itemCount;
18 
19     mapping(address => bool) public voted;
20     address[] public voters;
21 
22     /// @notice Constructor, accept the number of voting items, and their infos
23     /// @param _itemCount Number of voting items
24     /// @param _titles List of titles of the voting items
25     /// @param _minValues List of min values for the voting items
26     /// @param _maxValues List of max values for the voting items
27     /// @param _start Start time of the voting (UTC)
28     /// @param _end End time of the voting (UTC)
29     constructor (
30         uint256 _itemCount,
31         bytes32[] _titles,
32         uint256[] _minValues,
33         uint256[] _maxValues,
34         uint256 _start,
35         uint256 _end
36     )
37         public
38     {
39         itemCount = _itemCount;
40         for (uint256 i=0;i<itemCount;i++) {
41             voteItems[i].title = _titles[i];
42             voteItems[i].minValue = _minValues[i];
43             voteItems[i].maxValue = _maxValues[i];
44         }
45         start = _start;
46         end = _end;
47     }
48 
49     /// @notice Function to case vote in this carbon voting
50     /// @dev Every item must be voted on. Reverts if number of votes is
51     ///      not equal to the itemCount
52     /// @param _votes List of votes on the voting items
53     function vote(uint256[] _votes) public {
54         require(_votes.length == itemCount);
55         require(now >= start && now < end);
56 
57         address voter = msg.sender;
58         if (!voted[voter]) {
59             voted[voter] = true;
60             voters.push(voter);
61         }
62 
63         for (uint256 i=0;i<itemCount;i++) {
64             require(_votes[i] >= voteItems[i].minValue && _votes[i] <= voteItems[i].maxValue);
65             voteItems[i].votes[voter] = _votes[i];
66         }
67     }
68 
69     function getAllVoters() public view
70         returns (address[] _voters)
71     {
72         _voters = voters;
73     }
74 
75     function getVotesForItem(uint256 _itemIndex) public view
76         returns (address[] _voters, uint256[] _votes)
77     {
78         uint256 _voterCount = voters.length;
79         require(_itemIndex < itemCount);
80         _voters = voters;
81         _votes = new uint256[](_voterCount);
82         for (uint256 i=0;i<_voterCount;i++) {
83             _votes[i] = voteItems[_itemIndex].votes[_voters[i]];
84         }
85     }
86 
87     function getVoteItemDetails(uint256 _itemIndex) public view
88         returns (bytes32 _title, uint256 _minValue, uint256 _maxValue)
89     {
90         _title = voteItems[_itemIndex].title;
91         _minValue = voteItems[_itemIndex].minValue;
92         _maxValue = voteItems[_itemIndex].maxValue;
93     }
94 
95     function getUserVote(address _voter) public view
96         returns (uint256[] _votes, bool _voted)
97     {
98         _voted = voted[_voter];
99         _votes = new uint256[](itemCount);
100         for (uint256 i=0;i<itemCount;i++) {
101             _votes[i] = voteItems[i].votes[_voter];
102         }
103     }
104 }
105 
106 /// @notice The DigixDAO Carbon Voting contract, this in turn calls the
107 ///         NumberCarbonVoting contract
108 /// @dev  This contract will be used for carbon voting on
109 ///       minimum DGDs for Moderator status and
110 ///       Rewards pool for Moderators
111 contract DigixDaoCarbonVoting is NumberCarbonVoting {
112     constructor (
113         uint256 _itemCount,
114         bytes32[] _titles,
115         uint256[] _minValues,
116         uint256[] _maxValues,
117         uint256 _start,
118         uint256 _end
119     ) public NumberCarbonVoting(
120         _itemCount,
121         _titles,
122         _minValues,
123         _maxValues,
124         _start,
125         _end
126     ) {
127     }
128 }