1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned()  public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner  public {
16         owner = newOwner;
17     }
18 }
19 
20 contract tokenRecipient {
21     event receivedEther(address sender, uint amount);
22     event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);
23 
24     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
25         Token t = Token(_token);
26         require(t.transferFrom(_from, this, _value));
27         receivedTokens(_from, _value, _token, _extraData);
28     }
29 
30     function () payable  public {
31         receivedEther(msg.sender, msg.value);
32     }
33 }
34 
35 interface Token {
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 }
38 
39 contract Congress is owned, tokenRecipient {
40     // Contract Variables and events
41     uint public minimumQuorum;
42     uint public debatingPeriodInMinutes;
43     int public majorityMargin;
44     Proposal[] public proposals;
45     uint public numProposals;
46     mapping (address => uint) public memberId;
47     Member[] public members;
48 
49     event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
50     event Voted(uint proposalID, bool position, address voter, string justification);
51     event ProposalTallied(uint proposalID, int result, uint quorum, bool active);
52     event MembershipChanged(address member, bool isMember);
53     event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, int newMajorityMargin);
54 
55     struct Proposal {
56         address recipient;
57         uint amount;
58         string description;
59         uint votingDeadline;
60         bool executed;
61         bool proposalPassed;
62         uint numberOfVotes;
63         int currentResult;
64         bytes32 proposalHash;
65         Vote[] votes;
66         mapping (address => bool) voted;
67     }
68 
69     struct Member {
70         address member;
71         string name;
72         uint memberSince;
73     }
74 
75     struct Vote {
76         bool inSupport;
77         address voter;
78         string justification;
79     }
80 
81     // Modifier that allows only shareholders to vote and create new proposals
82     modifier onlyMembers {
83         require(memberId[msg.sender] != 0);
84         _;
85     }
86 
87     /**
88      * Constructor function
89      */
90     function Congress (
91         uint minimumQuorumForProposals,
92         uint minutesForDebate,
93         int marginOfVotesForMajority
94     )  payable public {
95         changeVotingRules(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority);
96         // It’s necessary to add an empty first member
97         addMember(0, "");
98         // and let's add the founder, to save a step later
99         addMember(owner, 'founder');
100     }
101 
102     /**
103      * Add member
104      *
105      * Make `targetMember` a member named `memberName`
106      *
107      * @param targetMember ethereum address to be added
108      * @param memberName public name for that member
109      */
110     function addMember(address targetMember, string memberName) onlyOwner public {
111         uint id = memberId[targetMember];
112         if (id == 0) {
113             memberId[targetMember] = members.length;
114             id = members.length++;
115         }
116 
117         members[id] = Member({member: targetMember, memberSince: now, name: memberName});
118         MembershipChanged(targetMember, true);
119     }
120 
121     /**
122      * Remove member
123      *
124      * @notice Remove membership from `targetMember`
125      *
126      * @param targetMember ethereum address to be removed
127      */
128     function removeMember(address targetMember) onlyOwner public {
129         require(memberId[targetMember] != 0);
130 
131         for (uint i = memberId[targetMember]; i<members.length-1; i++){
132             members[i] = members[i+1];
133         }
134         delete members[members.length-1];
135         members.length--;
136     }
137 
138     /**
139      * Change voting rules
140      *
141      * Make so that proposals need tobe discussed for at least `minutesForDebate/60` hours,
142      * have at least `minimumQuorumForProposals` votes, and have 50% + `marginOfVotesForMajority` votes to be executed
143      *
144      * @param minimumQuorumForProposals how many members must vote on a proposal for it to be executed
145      * @param minutesForDebate the minimum amount of delay between when a proposal is made and when it can be executed
146      * @param marginOfVotesForMajority the proposal needs to have 50% plus this number
147      */
148     function changeVotingRules(
149         uint minimumQuorumForProposals,
150         uint minutesForDebate,
151         int marginOfVotesForMajority
152     ) onlyOwner public {
153         minimumQuorum = minimumQuorumForProposals;
154         debatingPeriodInMinutes = minutesForDebate;
155         majorityMargin = marginOfVotesForMajority;
156 
157         ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, majorityMargin);
158     }
159 
160     /**
161      * Add Proposal
162      *
163      * Propose to send `weiAmount / 1e18` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
164      *
165      * @param beneficiary who to send the ether to
166      * @param weiAmount amount of ether to send, in wei
167      * @param jobDescription Description of job
168      * @param transactionBytecode bytecode of transaction
169      */
170     function newProposal(
171         address beneficiary,
172         uint weiAmount,
173         string jobDescription,
174         bytes transactionBytecode
175     )
176         onlyMembers public
177         returns (uint proposalID)
178     {
179         proposalID = proposals.length++;
180         Proposal storage p = proposals[proposalID];
181         p.recipient = beneficiary;
182         p.amount = weiAmount;
183         p.description = jobDescription;
184         p.proposalHash = keccak256(beneficiary, weiAmount, transactionBytecode);
185         p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
186         p.executed = false;
187         p.proposalPassed = false;
188         p.numberOfVotes = 0;
189         ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
190         numProposals = proposalID+1;
191 
192         return proposalID;
193     }
194 
195     /**
196      * Add proposal in Ether
197      *
198      * Propose to send `etherAmount` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
199      * This is a convenience function to use if the amount to be given is in round number of ether units.
200      *
201      * @param beneficiary who to send the ether to
202      * @param etherAmount amount of ether to send
203      * @param jobDescription Description of job
204      * @param transactionBytecode bytecode of transaction
205      */
206     function newProposalInEther(
207         address beneficiary,
208         uint etherAmount,
209         string jobDescription,
210         bytes transactionBytecode
211     )
212         onlyMembers public
213         returns (uint proposalID)
214     {
215         return newProposal(beneficiary, etherAmount * 1 ether, jobDescription, transactionBytecode);
216     }
217 
218     /**
219      * Check if a proposal code matches
220      *
221      * @param proposalNumber ID number of the proposal to query
222      * @param beneficiary who to send the ether to
223      * @param weiAmount amount of ether to send
224      * @param transactionBytecode bytecode of transaction
225      */
226     function checkProposalCode(
227         uint proposalNumber,
228         address beneficiary,
229         uint weiAmount,
230         bytes transactionBytecode
231     )
232         constant public
233         returns (bool codeChecksOut)
234     {
235         Proposal storage p = proposals[proposalNumber];
236         return p.proposalHash == keccak256(beneficiary, weiAmount, transactionBytecode);
237     }
238 
239     /**
240      * Log a vote for a proposal
241      *
242      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
243      *
244      * @param proposalNumber number of proposal
245      * @param supportsProposal either in favor or against it
246      * @param justificationText optional justification text
247      */
248     function vote(
249         uint proposalNumber,
250         bool supportsProposal,
251         string justificationText
252     )
253         onlyMembers public
254         returns (uint voteID)
255     {
256         Proposal storage p = proposals[proposalNumber];         // Get the proposal
257         require(!p.voted[msg.sender]);         // If has already voted, cancel
258         p.voted[msg.sender] = true;                     // Set this voter as having voted
259         p.numberOfVotes++;                              // Increase the number of votes
260         if (supportsProposal) {                         // If they support the proposal
261             p.currentResult++;                          // Increase score
262         } else {                                        // If they don't
263             p.currentResult--;                          // Decrease the score
264         }
265 
266         // Create a log of this event
267         Voted(proposalNumber,  supportsProposal, msg.sender, justificationText);
268         return p.numberOfVotes;
269     }
270 
271     /**
272      * Finish vote
273      *
274      * Count the votes proposal #`proposalNumber` and execute it if approved
275      *
276      * @param proposalNumber proposal number
277      * @param transactionBytecode optional: if the transaction contained a bytecode, you need to send it
278      */
279     function executeProposal(uint proposalNumber, bytes transactionBytecode) public {
280         Proposal storage p = proposals[proposalNumber];
281 
282         require(now > p.votingDeadline                                            // If it is past the voting deadline
283             && !p.executed                                                         // and it has not already been executed
284             && p.proposalHash == keccak256(p.recipient, p.amount, transactionBytecode)  // and the supplied code matches the proposal
285             && p.numberOfVotes >= minimumQuorum);                                  // and a minimum quorum has been reached...
286 
287         // ...then execute result
288 
289         if (p.currentResult > majorityMargin) {
290             // Proposal passed; execute the transaction
291 
292             p.executed = true; // Avoid recursive calling
293             require(p.recipient.call.value(p.amount)(transactionBytecode));
294 
295             p.proposalPassed = true;
296         } else {
297             // Proposal failed
298             p.proposalPassed = false;
299         }
300 
301         // Fire Events
302         ProposalTallied(proposalNumber, p.currentResult, p.numberOfVotes, p.proposalPassed);
303     }
304 }