1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract tokenRecipient {
45     event receivedEther(address sender, uint amount);
46     event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);
47 
48     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
49         Token t = Token(_token);
50         require(t.transferFrom(_from, this, _value));
51         receivedTokens(_from, _value, _token, _extraData);
52     }
53 
54     function () payable public {
55         receivedEther(msg.sender, msg.value);
56     }
57 }
58 
59 contract Token {
60     mapping (address => uint256) public balanceOf;
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
62 }
63 
64 /**
65  * The shareholder association contract itself
66  */
67 contract QuantumGoldDAO is Ownable, tokenRecipient {
68 
69     uint public minimumQuorum;
70     uint public debatingPeriodInMinutes;
71     Proposal[] public proposals;
72     uint public numProposals;
73     Token public sharesTokenAddress;
74 
75     event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
76     event Voted(uint proposalID, bool position, address voter);
77     event ProposalTallied(uint proposalID, uint result, uint quorum, bool active);
78     event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, address newSharesTokenAddress);
79 
80     struct Proposal {
81         address recipient;
82         uint amount;
83         string description;
84         uint minExecutionDate;
85         bool executed;
86         bool proposalPassed;
87         uint numberOfVotes;
88         bytes32 proposalHash;
89         Vote[] votes;
90         mapping (address => bool) voted;
91     }
92 
93     struct Vote {
94         bool inSupport;
95         address voter;
96     }
97 
98     // Modifier that allows only shareholders to vote and create new proposals
99     modifier onlyShareholders {
100         require(sharesTokenAddress.balanceOf(msg.sender) > 0);
101         _;
102     }
103 
104     /**
105      * Constructor function
106      *
107      * First time setup
108      */
109     function QuantumGoldDAO(Token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) payable public {
110         changeVotingRules(sharesAddress, minimumSharesToPassAVote, minutesForDebate);
111     }
112 
113     /**
114      * Change voting rules
115      *
116      * Make so that proposals need to be discussed for at least `minutesForDebate/60` hours
117      * and all voters combined must own more than `minimumSharesToPassAVote` shares of token `sharesAddress` to be executed
118      *
119      * @param sharesAddress token address
120      * @param minimumSharesToPassAVote proposal can vote only if the sum of shares held by all voters exceed this number
121      * @param minutesForDebate the minimum amount of delay between when a proposal is made and when it can be executed
122      */
123     function changeVotingRules(Token sharesAddress, uint minimumSharesToPassAVote, uint minutesForDebate) onlyOwner public {
124         sharesTokenAddress = Token(sharesAddress);
125         if (minimumSharesToPassAVote == 0 ) minimumSharesToPassAVote = 1;
126         minimumQuorum = minimumSharesToPassAVote;
127         debatingPeriodInMinutes = minutesForDebate;
128         ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, sharesTokenAddress);
129     }
130     
131     /**
132      * Add Proposal
133      *
134      * Propose to send `weiAmount / 1e18` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
135      *
136      * @param beneficiary who to send the ether to
137      * @param weiAmount amount of ether to send, in wei
138      * @param jobDescription Description of job
139      * @param transactionBytecode bytecode of transaction
140      */
141     function newProposal(
142         address beneficiary,
143         uint weiAmount,
144         string jobDescription,
145         bytes transactionBytecode
146     )
147         onlyShareholders public
148         returns (uint proposalID)
149     {
150         proposalID = proposals.length++;
151         Proposal storage p = proposals[proposalID];
152         p.recipient = beneficiary;
153         p.amount = weiAmount;
154         p.description = jobDescription;
155         p.proposalHash = keccak256(beneficiary, weiAmount, transactionBytecode);
156         p.minExecutionDate = now + debatingPeriodInMinutes * 1 minutes;
157         p.executed = false;
158         p.proposalPassed = false;
159         p.numberOfVotes = 0;
160         ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
161         numProposals = proposalID+1;
162 
163         return proposalID;
164     }
165 
166     /**
167      * Add proposal in Ether
168      *
169      * Propose to send `etherAmount` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
170      * This is a convenience function to use if the amount to be given is in round number of ether units.
171      *
172      * @param beneficiary who to send the ether to
173      * @param etherAmount amount of ether to send
174      * @param jobDescription Description of job
175      * @param transactionBytecode bytecode of transaction
176      */
177     function newProposalInEther(
178         address beneficiary,
179         uint etherAmount,
180         string jobDescription,
181         bytes transactionBytecode
182     )
183         onlyShareholders public
184         returns (uint proposalID)
185     {
186         return newProposal(beneficiary, etherAmount * 1 ether, jobDescription, transactionBytecode);
187     }
188 
189     /**
190      * Check if a proposal code matches
191      *
192      * @param proposalNumber ID number of the proposal to query
193      * @param beneficiary who to send the ether to
194      * @param weiAmount amount of ether to send
195      * @param transactionBytecode bytecode of transaction
196      */
197     function checkProposalCode(
198         uint proposalNumber,
199         address beneficiary,
200         uint weiAmount,
201         bytes transactionBytecode
202     )
203         constant public
204         returns (bool codeChecksOut)
205     {
206         Proposal storage p = proposals[proposalNumber];
207         return p.proposalHash == keccak256(beneficiary, weiAmount, transactionBytecode);
208     }
209 
210     /**
211      * Log a vote for a proposal
212      *
213      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
214      *
215      * @param proposalNumber number of proposal
216      * @param supportsProposal either in favor or against it
217      */
218     function vote(
219         uint proposalNumber,
220         bool supportsProposal
221     )
222         onlyShareholders public
223         returns (uint voteID)
224     {
225         Proposal storage p = proposals[proposalNumber];
226         require(p.voted[msg.sender] != true);
227 
228         voteID = p.votes.length++;
229         p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});
230         p.voted[msg.sender] = true;
231         p.numberOfVotes = voteID +1;
232         Voted(proposalNumber,  supportsProposal, msg.sender);
233         return voteID;
234     }
235 
236     /**
237      * Finish vote
238      *
239      * Count the votes proposal #`proposalNumber` and execute it if approved
240      *
241      * @param proposalNumber proposal number
242      * @param transactionBytecode optional: if the transaction contained a bytecode, you need to send it
243      */
244     function executeProposal(uint proposalNumber, bytes transactionBytecode) public {
245         Proposal storage p = proposals[proposalNumber];
246 
247         require(now > p.minExecutionDate                                             // If it is past the voting deadline
248             && !p.executed                                                          // and it has not already been executed
249             && p.proposalHash == keccak256(p.recipient, p.amount, transactionBytecode)); // and the supplied code matches the proposal...
250 
251 
252         // ...then tally the results
253         uint quorum = 0;
254         uint yea = 0;
255         uint nay = 0;
256 
257         for (uint i = 0; i <  p.votes.length; ++i) {
258             Vote storage v = p.votes[i];
259             uint voteWeight = sharesTokenAddress.balanceOf(v.voter);
260             quorum += voteWeight;
261             if (v.inSupport) {
262                 yea += voteWeight;
263             } else {
264                 nay += voteWeight;
265             }
266         }
267 
268         require(quorum >= minimumQuorum); // Check if a minimum quorum has been reached
269 
270         if (yea > nay ) {
271             // Proposal passed; execute the transaction
272 
273             p.executed = true;
274             require(p.recipient.call.value(p.amount)(transactionBytecode));
275 
276             p.proposalPassed = true;
277         } else {
278             // Proposal failed
279             p.proposalPassed = false;
280         }
281 
282         // Fire Events
283         ProposalTallied(proposalNumber, yea - nay, quorum, p.proposalPassed);
284     }
285 }