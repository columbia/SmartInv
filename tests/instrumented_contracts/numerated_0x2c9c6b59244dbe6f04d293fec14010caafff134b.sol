1 pragma solidity ^0.4.8;
2 
3 contract ibaVoter {
4     
5     struct Proposal{
6         bytes32 name;
7     }
8     
9     struct Ballot{
10         bytes32 name;
11         address chainperson;
12         bool blind;
13         bool finished;
14     }
15     
16     struct votedData{
17         uint256 proposal;
18         bool isVal;
19     }
20     
21     event Vote(
22         address votedPerson,
23         uint256 proposalIndex
24         );
25         
26     event Finish(
27         bool finished
28         );
29 
30     mapping (address => mapping(uint256 => mapping(address => votedData))) votedDatas;
31     mapping (address => mapping(uint256 => address[])) voted;
32     mapping (address => mapping(uint256 => mapping(uint256 => uint256))) voteCount;
33     mapping (address => Ballot[]) public ballots;   
34     mapping (address => mapping(uint256 => Proposal[])) public proposals;
35     
36     function getBallotsNum(address chainperson) public constant returns (uint count) {
37         return ballots[chainperson].length; 
38     }
39     function getProposalsNum(address chainperson, uint ballot) public constant returns (uint count) {
40         return proposals[chainperson][ballot].length;
41     }
42     
43     function getBallotIndex(address chainperson, bytes32 ballotName) public constant returns (uint index){
44         for (uint i=0;i<ballots[chainperson].length;i++){
45             if (ballots[chainperson][i].name == ballotName){
46                 return i;
47             }
48         }
49     }
50     function isVoted(address chainperson, uint ballot) public constant returns (bool result){
51         for (uint8 i=0;i<voted[chainperson][ballot].length;i++){
52             if (voted[chainperson][ballot][i] == msg.sender){
53                 return true;
54             }
55         }
56         return false;
57     }
58     function startNewBallot(bytes32 ballotName, bool blindParam, bytes32[] proposalNames) external returns (bool success){
59         for (uint8 y=0;y<ballots[msg.sender].length;y++){
60             if (ballots[msg.sender][i].name == ballotName){
61                 revert();
62             }
63         }
64         ballots[msg.sender].push(Ballot({
65             name: ballotName, 
66             chainperson: msg.sender, 
67             blind: blindParam,
68             finished: false
69         }));
70         
71         uint ballotsNum = ballots[msg.sender].length;
72         for (uint8 i=0;i<proposalNames.length;i++){
73             proposals[msg.sender][ballotsNum-1].push(Proposal({name:proposalNames[i]}));
74         }
75         return true;
76     }
77     
78     function getVoted(address chainperson, uint256 ballot) public constant returns (address[]){
79         if (ballots[chainperson][ballot].blind == true){
80             revert();
81         }
82         return voted[chainperson][ballot];
83     }
84     
85     function getVotesCount(address chainperson, uint256 ballot, bytes32 proposalName) public constant returns (uint256 count){
86         if (ballots[chainperson][ballot].blind == true){
87             revert();
88         }
89         
90         for (uint8 i=0;i<proposals[chainperson][ballot].length;i++){
91             if (proposals[chainperson][ballot][i].name == proposalName){
92                 return voteCount[chainperson][ballot][i];
93             }
94         }
95     }
96     
97     function getVotedData(address chainperson, uint256 ballot, address voter) public constant returns (uint256 proposalNum){
98         if (ballots[chainperson][ballot].blind == true){
99             revert();
100         }
101         
102         if (votedDatas[chainperson][ballot][voter].isVal == true){
103             return votedDatas[chainperson][ballot][voter].proposal;
104         }
105     }
106     
107     function vote(address chainperson, uint256 ballot, uint256 proposalNum) external returns (bool success){
108         
109         if (ballots[chainperson][ballot].finished == true){
110             revert();
111         }
112         for (uint8 i = 0;i<voted[chainperson][ballot].length;i++){
113             if (votedDatas[chainperson][ballot][msg.sender].isVal == true){
114                 revert();
115             }
116         }
117         voted[chainperson][ballot].push(msg.sender);
118         voteCount[chainperson][ballot][proposalNum]++;
119         votedDatas[chainperson][ballot][msg.sender] = votedData({proposal: proposalNum, isVal: true});
120         Vote(msg.sender, proposalNum);
121         return true;
122     }
123     
124     function getProposalIndex(address chainperson, uint256 ballot, bytes32 proposalName) public constant returns (uint index){
125         for (uint8 i=0;i<proposals[chainperson][ballot].length;i++){
126             if (proposals[chainperson][ballot][i].name == proposalName){
127                 return i;
128             }
129         }
130     }
131     
132     
133     function finishBallot(bytes32 ballot) external returns (bool success){
134         for (uint8 i=0;i<ballots[msg.sender].length;i++){
135             if (ballots[msg.sender][i].name == ballot) {
136                 if (ballots[msg.sender][i].chainperson == msg.sender){
137                     ballots[msg.sender][i].finished = true;
138                     Finish(true);
139                     return true;
140                 } else {
141                     return false;
142                 }
143             }
144         }
145     }
146     
147     function getWinner(address chainperson, uint ballotIndex) public constant returns (bytes32 winnerName){
148             if (ballots[chainperson][ballotIndex].finished == false){
149                 revert();
150             }
151             uint256 maxVotes;
152             bytes32 winner;
153             for (uint8 i=0;i<proposals[chainperson][ballotIndex].length;i++){
154                 if (voteCount[chainperson][ballotIndex][i]>maxVotes){
155                     maxVotes = voteCount[chainperson][ballotIndex][i];
156                     winner = proposals[chainperson][ballotIndex][i].name;
157                 }
158             }
159             return winner;
160     }
161 }