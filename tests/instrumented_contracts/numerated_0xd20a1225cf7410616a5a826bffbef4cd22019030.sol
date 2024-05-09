1 pragma solidity ^0.4.16;
2 ////////////////////////////////////////////////////////////
3 // Initiated by : Rimdeika Consulting and Coaching AB (RCC)
4 //                Alingsas SWEDEN / VAT Nr. SE556825809801
5 ////////////////////////////////////////////////////////////
6 //
7 // "Decentralized R&D organization on the blockchain with 
8 // the mission to develop autonomous diagnostic, support 
9 // and development system for any vehicle"
10 //
11 ////////////////////////////////////////////////////////////
12 
13 contract owned {
14     address public owner;
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26         owner = newOwner;
27     }
28 }
29 
30 contract tokenRecipient {
31     event receivedEther(address sender, uint amount);
32     event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);
33 
34     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
35         Token t = Token(_token);
36         require(t.transferFrom(_from, this, _value));
37         emit receivedTokens(_from, _value, _token, _extraData);
38     }
39 
40     function () payable public {
41         emit receivedEther(msg.sender, msg.value);
42     }
43 }
44 
45 contract Token {
46     mapping (address => uint256) public balanceOf;
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
48 }
49 
50 /**
51  * The shareholder association contract itself
52  */
53 contract Association is owned, tokenRecipient {
54 
55     uint public minimumQuorum;
56     uint public debatingPeriodInMinutes;
57     Proposal[] public proposals;
58     uint public numProposals;
59     Token public sharesTokenAddress;
60 
61     event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
62     event Voted(uint proposalID, bool position, address voter);
63     event ProposalTallied(uint proposalID, uint result, uint quorum, bool active);
64     event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, address newSharesTokenAddress);
65 
66     struct Proposal {
67         address recipient;
68         uint amount;
69         string description;
70         uint minExecutionDate;
71         bool executed;
72         bool proposalPassed;
73         uint numberOfVotes;
74         bytes32 proposalHash;
75         Vote[] votes;
76         mapping (address => bool) voted;
77     }
78 
79     struct Vote {
80         bool inSupport;
81         address voter;
82     }
83 
84     // Modifier that allows only shareholders to vote and create new proposals
85     modifier onlyShareholders {
86         require(sharesTokenAddress.balanceOf(msg.sender) > 0);
87         _;
88     }
89 
90     /**
91      * Constructor function
92      *
93      * First time setup
94      */
95     constructor(Token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) payable public {
96         changeVotingRules(sharesAddress, minimumSharesToPassAVote, minutesForDebate);
97     }
98 
99     /**
100      * Change voting rules
101      *
102      * Make so that proposals need to be discussed for at least `minutesForDebate/60` hours
103      * and all voters combined must own more than `minimumSharesToPassAVote` shares of token `sharesAddress` to be executed
104      *
105      * @param sharesAddress token address
106      * @param minimumSharesToPassAVote proposal can vote only if the sum of shares held by all voters exceed this number
107      * @param minutesForDebate the minimum amount of delay between when a proposal is made and when it can be executed
108      */
109     function changeVotingRules(Token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) onlyOwner public {
110         sharesTokenAddress = Token(sharesAddress);
111         if (minimumSharesToPassAVote == 0 ) minimumSharesToPassAVote = 1;
112         minimumQuorum = minimumSharesToPassAVote;
113         debatingPeriodInMinutes = minutesForDebate;
114         emit ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, sharesTokenAddress);
115     }
116 
117     /**
118      * Add Proposal
119      *
120      * Propose to send `weiAmount / 1e18` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
121      *
122      * @param beneficiary who to send the ether to
123      * @param weiAmount amount of ether to send, in wei
124      * @param jobDescription Description of job
125      * @param transactionBytecode bytecode of transaction
126      */
127     function newProposal(
128         address beneficiary,
129         uint weiAmount,
130         string jobDescription,
131         bytes transactionBytecode
132     )
133         onlyShareholders public
134         returns (uint proposalID)
135     {
136         proposalID = proposals.length++;
137         Proposal storage p = proposals[proposalID];
138         p.recipient = beneficiary;
139         p.amount = weiAmount;
140         p.description = jobDescription;
141         p.proposalHash = keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
142         p.minExecutionDate = now + debatingPeriodInMinutes * 1 minutes;
143         p.executed = false;
144         p.proposalPassed = false;
145         p.numberOfVotes = 0;
146         emit ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
147         numProposals = proposalID+1;
148 
149         return proposalID;
150     }
151 
152     /**
153      * Add proposal in Ether
154      *
155      * Propose to send `etherAmount` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
156      * This is a convenience function to use if the amount to be given is in round number of ether units.
157      *
158      * @param beneficiary who to send the ether to
159      * @param etherAmount amount of ether to send
160      * @param jobDescription Description of job
161      * @param transactionBytecode bytecode of transaction
162      */
163     function newProposalInEther(
164         address beneficiary,
165         uint etherAmount,
166         string jobDescription,
167         bytes transactionBytecode
168     )
169         onlyShareholders public
170         returns (uint proposalID)
171     {
172         return newProposal(beneficiary, etherAmount * 1 ether, jobDescription, transactionBytecode);
173     }
174 
175     /**
176      * Check if a proposal code matches
177      *
178      * @param proposalNumber ID number of the proposal to query
179      * @param beneficiary who to send the ether to
180      * @param weiAmount amount of ether to send
181      * @param transactionBytecode bytecode of transaction
182      */
183     function checkProposalCode(
184         uint proposalNumber,
185         address beneficiary,
186         uint weiAmount,
187         bytes transactionBytecode
188     )
189         constant public
190         returns (bool codeChecksOut)
191     {
192         Proposal storage p = proposals[proposalNumber];
193         return p.proposalHash == keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
194     }
195 
196     /**
197      * Log a vote for a proposal
198      *
199      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
200      *
201      * @param proposalNumber number of proposal
202      * @param supportsProposal either in favor or against it
203      */
204     function vote(
205         uint proposalNumber,
206         bool supportsProposal
207     )
208         onlyShareholders public
209         returns (uint voteID)
210     {
211         Proposal storage p = proposals[proposalNumber];
212         require(p.voted[msg.sender] != true);
213 
214         voteID = p.votes.length++;
215         p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});
216         p.voted[msg.sender] = true;
217         p.numberOfVotes = voteID +1;
218         emit Voted(proposalNumber,  supportsProposal, msg.sender);
219         return voteID;
220     }
221 
222     /**
223      * Finish vote
224      *
225      * Count the votes proposal #`proposalNumber` and execute it if approved
226      *
227      * @param proposalNumber proposal number
228      * @param transactionBytecode optional: if the transaction contained a bytecode, you need to send it
229      */
230     function executeProposal(uint proposalNumber, bytes transactionBytecode) public {
231         Proposal storage p = proposals[proposalNumber];
232 
233         require(now > p.minExecutionDate                                             // If it is past the voting deadline
234             && !p.executed                                                          // and it has not already been executed
235             && p.proposalHash == keccak256(abi.encodePacked(p.recipient, p.amount, transactionBytecode))); // and the supplied code matches the proposal...
236 
237 
238         // ...then tally the results
239         uint quorum = 0;
240         uint yea = 0;
241         uint nay = 0;
242 
243         for (uint i = 0; i <  p.votes.length; ++i) {
244             Vote storage v = p.votes[i];
245             uint voteWeight = sharesTokenAddress.balanceOf(v.voter);
246             quorum += voteWeight;
247             if (v.inSupport) {
248                 yea += voteWeight;
249             } else {
250                 nay += voteWeight;
251             }
252         }
253 
254         require(quorum >= minimumQuorum); // Check if a minimum quorum has been reached
255 
256         if (yea > nay ) {
257             // Proposal passed; execute the transaction
258 
259             p.executed = true;
260             require(p.recipient.call.value(p.amount)(transactionBytecode));
261 
262             p.proposalPassed = true;
263         } else {
264             // Proposal failed
265             p.proposalPassed = false;
266         }
267 
268         // Fire Events
269         emit ProposalTallied(proposalNumber, yea - nay, quorum, p.proposalPassed);
270     }
271 }