1 pragma solidity ^0.4.19;
2 
3 /// @title Voting with delegation.
4 contract Ballot {
5     // This declares a new complex type which will
6     // be used for variables later.
7     // It will represent a vote for one batch votes in blockchain.
8     struct Voter {
9         uint weight; // vote number of specified voter and voted proposal
10         bytes32 voterName; // voter's name
11         uint proposalId; // index of the voted proposal
12     }
13 
14     // This is a type for a single proposal.
15     struct Proposal {
16         uint proposalId;// proposal's id, equals to proposals' index
17         bytes32 proposalName;   // proposal's description
18         uint voteCount; // number of accumulated votes
19     }
20 
21     address public chairperson;
22 
23     // A dynamically-sized array of `Proposal` structs.
24     Proposal[] public proposals;
25 
26     event BatchVote(address indexed _from);
27 
28     modifier onlyChairperson {
29       require(msg.sender == chairperson);
30       _;
31     }
32 
33     function transferChairperson(address newChairperson) onlyChairperson  public {
34         chairperson = newChairperson;
35     }
36 
37     /// Create a new ballot to choose one of `proposalNames`.
38     function Ballot(bytes32[] proposalNames) public {
39         chairperson = msg.sender;
40 
41         // For each of the provided proposal names,
42         // create a new proposal object and add it
43         // to the end of the array.
44         for (uint i = 0; i < proposalNames.length; i++) {
45             // `Proposal({...})` creates a temporary
46             // Proposal object and `proposals.push(...)`
47             // appends it to the end of `proposals`.
48             proposals.push(Proposal({
49                 proposalId: proposals.length,
50                 proposalName: proposalNames[i],
51                 voteCount: 0
52             }));
53         }
54     }
55 
56     function addProposals(bytes32[] proposalNames) onlyChairperson public {
57         // For each of the provided proposal names,
58         // create a new proposal object and add it
59         // to the end of the array.
60         for (uint i = 0; i < proposalNames.length; i++) {
61             // `Proposal({...})` creates a temporary
62             // Proposal object and `proposals.push(...)`
63             // appends it to the end of `proposals`.
64             proposals.push(Proposal({
65                 proposalId: proposals.length,
66                 proposalName: proposalNames[i],
67                 voteCount: 0
68             }));
69         }
70     }
71 
72 
73     /// batch vote (delegated to chairperson)
74     function vote(uint[] weights, bytes32[] voterNames, uint[] proposalIds) onlyChairperson public {
75 
76         require(weights.length == voterNames.length);
77         require(weights.length == proposalIds.length);
78         require(voterNames.length == proposalIds.length);
79 
80         for (uint i = 0; i < weights.length; i++) {
81             Voter memory voter = Voter({
82               weight: weights[i],
83               voterName: voterNames[i],
84               proposalId: proposalIds[i]
85             });
86             proposals[voter.proposalId-1].voteCount += voter.weight;
87         }
88 
89         BatchVote(msg.sender);
90     }
91 
92     /// @dev Computes the winning proposal taking all
93     /// previous votes into account.
94     function winningProposal() internal
95             returns (uint winningProposal)
96     {
97         uint winningVoteCount = 0;
98         for (uint p = 0; p < proposals.length; p++) {
99             if (proposals[p].voteCount > winningVoteCount) {
100                 winningVoteCount = proposals[p].voteCount;
101                 winningProposal = p;
102             }
103         }
104     }
105 
106     // Calls winningProposal() function to get the index
107     // of the winner contained in the proposals array and then
108     // returns the name of the winner
109     function winnerName() public view
110             returns (bytes32 winnerName)
111     {
112         winnerName = proposals[winningProposal()].proposalName;
113     }
114 
115     function resetBallot(bytes32[] proposalNames) onlyChairperson public {
116 
117         delete proposals;
118 
119         // For each of the provided proposal names,
120         // create a new proposal object and add it
121         // to the end of the array.
122         for (uint i = 0; i < proposalNames.length; i++) {
123             // `Proposal({...})` creates a temporary
124             // Proposal object and `proposals.push(...)`
125             // appends it to the end of `proposals`.
126             proposals.push(Proposal({
127                 proposalId: proposals.length,
128                 proposalName: proposalNames[i],
129                 voteCount: 0
130             }));
131         }
132     }
133 
134     function batchSearchProposalsId(bytes32[] proposalsName) public view
135           returns (uint[] proposalsId) {
136       proposalsId = new uint[](proposalsName.length);
137       for (uint i = 0; i < proposalsName.length; i++) {
138         uint proposalId = searchProposalId(proposalsName[i]);
139         proposalsId[i]=proposalId;
140       }
141     }
142 
143     function searchProposalId(bytes32 proposalName) public view
144           returns (uint proposalId) {
145       for (uint i = 0; i < proposals.length; i++) {
146           if(proposals[i].proposalName == proposalName){
147             proposalId = proposals[i].proposalId;
148           }
149       }
150     }
151 
152     // proposal rank by voteCount
153     function proposalsRank() public view
154           returns (uint[] rankByProposalId,
155           bytes32[] rankByName,
156           uint[] rankByvoteCount) {
157 
158     uint n = proposals.length;
159     Proposal[] memory arr = new Proposal[](n);
160 
161     uint i;
162     for(i=0; i<n; i++) {
163       arr[i] = proposals[i];
164     }
165 
166     uint[] memory stack = new uint[](n+ 2);
167 
168     //Push initial lower and higher bound
169     uint top = 1;
170     stack[top] = 0;
171     top = top + 1;
172     stack[top] = n-1;
173 
174     //Keep popping from stack while is not empty
175     while (top > 0) {
176 
177       uint h = stack[top];
178       top = top - 1;
179       uint l = stack[top];
180       top = top - 1;
181 
182       i = l;
183       uint x = arr[h].voteCount;
184 
185       for(uint j=l; j<h; j++){
186         if  (arr[j].voteCount <= x) {
187           //Move smaller element
188           (arr[i], arr[j]) = (arr[j],arr[i]);
189           i = i + 1;
190         }
191       }
192       (arr[i], arr[h]) = (arr[h],arr[i]);
193       uint p = i;
194 
195       //Push left side to stack
196       if (p > l + 1) {
197         top = top + 1;
198         stack[top] = l;
199         top = top + 1;
200         stack[top] = p - 1;
201       }
202 
203       //Push right side to stack
204       if (p+1 < h) {
205         top = top + 1;
206         stack[top] = p + 1;
207         top = top + 1;
208         stack[top] = h;
209       }
210     }
211 
212     rankByProposalId = new uint[](n);
213     rankByName = new bytes32[](n);
214     rankByvoteCount = new uint[](n);
215     for(i=0; i<n; i++) {
216       rankByProposalId[i]= arr[n-1-i].proposalId;
217       rankByName[i]=arr[n-1-i].proposalName;
218       rankByvoteCount[i]=arr[n-1-i].voteCount;
219     }
220   }
221 }