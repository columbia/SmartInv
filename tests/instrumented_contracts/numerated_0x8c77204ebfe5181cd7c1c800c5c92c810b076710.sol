1 pragma solidity ^0.4.2;
2 /* The token is used as a voting shares */
3 contract token { mapping (address => uint256) public balanceOf;  }
4 
5 
6 /* define 'owned' */
7 contract owned {
8     address public owner;
9 
10     function owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         if (msg.sender != owner) throw;
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;
21     }
22 }
23 
24 contract tokenRecipient { 
25     event receivedEther(address sender, uint amount);
26     event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);
27 
28     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData){
29         Token t = Token(_token);
30         if (!t.transferFrom(_from, this, _value)) throw;
31         receivedTokens(_from, _value, _token, _extraData);
32     }
33 
34     function () payable {
35         receivedEther(msg.sender, msg.value);
36     }
37 }
38 
39 contract Token {
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41 }
42 
43 /* The democracy contract itself */
44 contract Association is owned, tokenRecipient {
45 
46     /* Contract Variables and events */
47     uint public minimumQuorum;
48     uint public debatingPeriodInMinutes;
49     Proposal[] public proposals;
50     uint public numProposals;
51     token public sharesTokenAddress;
52 
53     event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
54     event Voted(uint proposalID, bool position, address voter);
55     event ProposalTallied(uint proposalID, uint result, uint quorum, bool active);
56     event ChangeOfRules(uint minimumQuorum, uint debatingPeriodInMinutes, address sharesTokenAddress);
57 
58     struct Proposal {
59         address recipient;
60         uint amount;
61         string description;
62         uint votingDeadline;
63         bool executed;
64         bool proposalPassed;
65         uint numberOfVotes;
66         bytes32 proposalHash;
67         Vote[] votes;
68         mapping (address => bool) voted;
69     }
70 
71     struct Vote {
72         bool inSupport;
73         address voter;
74     }
75 
76     /* modifier that allows only shareholders to vote and create new proposals */
77     modifier onlyShareholders {
78         if (sharesTokenAddress.balanceOf(msg.sender) == 0) throw;
79         _;
80     }
81 
82     /* First time setup */
83     function Association(token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) payable {
84         changeVotingRules(sharesAddress, minimumSharesToPassAVote, minutesForDebate);
85     }
86 
87     /*change rules*/
88     function changeVotingRules(token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) onlyOwner {
89         sharesTokenAddress = token(sharesAddress);
90         if (minimumSharesToPassAVote == 0 ) minimumSharesToPassAVote = 1;
91         minimumQuorum = minimumSharesToPassAVote;
92         debatingPeriodInMinutes = minutesForDebate;
93         ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, sharesTokenAddress);
94     }
95 
96     /* Function to create a new proposal */
97     function newProposal(
98         address beneficiary,
99         uint etherAmount,
100         string JobDescription,
101         bytes transactionBytecode
102     )
103         onlyShareholders
104         returns (uint proposalID)
105     {
106         proposalID = proposals.length++;
107         Proposal p = proposals[proposalID];
108         p.recipient = beneficiary;
109         p.amount = etherAmount;
110         p.description = JobDescription;
111         p.proposalHash = sha3(beneficiary, etherAmount, transactionBytecode);
112         p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
113         p.executed = false;
114         p.proposalPassed = false;
115         p.numberOfVotes = 0;
116         ProposalAdded(proposalID, beneficiary, etherAmount, JobDescription);
117         numProposals = proposalID+1;
118 
119         return proposalID;
120     }
121 
122     /* function to check if a proposal code matches */
123     function checkProposalCode(
124         uint proposalNumber,
125         address beneficiary,
126         uint etherAmount,
127         bytes transactionBytecode
128     )
129         constant
130         returns (bool codeChecksOut)
131     {
132         Proposal p = proposals[proposalNumber];
133         return p.proposalHash == sha3(beneficiary, etherAmount, transactionBytecode);
134     }
135 
136     /* */
137     function vote(uint proposalNumber, bool supportsProposal)
138         onlyShareholders
139         returns (uint voteID)
140     {
141         Proposal p = proposals[proposalNumber];
142         if (p.voted[msg.sender] == true) throw;
143 
144         voteID = p.votes.length++;
145         p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});
146         p.voted[msg.sender] = true;
147         p.numberOfVotes = voteID +1;
148         Voted(proposalNumber,  supportsProposal, msg.sender); 
149         return voteID;
150     }
151 
152     function executeProposal(uint proposalNumber, bytes transactionBytecode) {
153         Proposal p = proposals[proposalNumber];
154         /* Check if the proposal can be executed */
155         if (now < p.votingDeadline  /* has the voting deadline arrived? */
156             ||  p.executed        /* has it been already executed? */
157             ||  p.proposalHash != sha3(p.recipient, p.amount, transactionBytecode)) /* Does the transaction code match the proposal? */
158             throw;
159 
160         /* tally the votes */
161         uint quorum = 0;
162         uint yea = 0;
163         uint nay = 0;
164 
165         for (uint i = 0; i <  p.votes.length; ++i) {
166             Vote v = p.votes[i];
167             uint voteWeight = sharesTokenAddress.balanceOf(v.voter);
168             quorum += voteWeight;
169             if (v.inSupport) {
170                 yea += voteWeight;
171             } else {
172                 nay += voteWeight;
173             }
174         }
175 
176         /* execute result */
177         if (quorum <= minimumQuorum) {
178             /* Not enough significant voters */
179             throw;
180         } else if (yea > nay ) {
181             /* has quorum and was approved */
182             p.executed = true;
183             if (!p.recipient.call.value(p.amount * 1 ether)(transactionBytecode)) {
184                 throw;
185             }
186             p.proposalPassed = true;
187         } else {
188             p.proposalPassed = false;
189         }
190         // Fire Events
191         ProposalTallied(proposalNumber, yea - nay, quorum, p.proposalPassed);
192     }
193 }