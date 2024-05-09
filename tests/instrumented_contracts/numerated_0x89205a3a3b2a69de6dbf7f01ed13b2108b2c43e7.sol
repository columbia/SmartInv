1 contract owned {
2         address public owner;
3 
4         function owned() {
5                 owner = msg.sender;
6         }
7 
8         modifier onlyOwner {
9                 if (msg.sender != owner) throw;
10                 _
11         }
12 
13         function transferOwnership(address newOwner) onlyOwner {
14                 owner = newOwner;
15         }
16 }
17 
18 /* The token is used as a voting shares */
19 contract token {
20         function mintToken(address target, uint256 mintedAmount);
21 }
22 
23 contract Congress is owned {
24 
25         /* Contract Variables and events */
26         uint public minimumQuorum;
27         uint public debatingPeriodInMinutes;
28         int public majorityMargin;
29         Proposal[] public proposals;
30         uint public numProposals;
31         mapping(address => uint) public memberId;
32         Member[] public members;
33 
34         address public unicornAddress;
35         uint public priceOfAUnicornInFinney;
36 
37         event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
38         event Voted(uint proposalID, bool position, address voter, string justification);
39         event ProposalTallied(uint proposalID, int result, uint quorum, bool active);
40         event MembershipChanged(address member);
41         event ChangeOfRules(uint minimumQuorum, uint debatingPeriodInMinutes, int majorityMargin);
42 
43         struct Proposal {
44                 address recipient;
45                 uint amount;
46                 string description;
47                 uint votingDeadline;
48                 bool executed;
49                 bool proposalPassed;
50                 uint numberOfVotes;
51                 int currentResult;
52                 bytes32 proposalHash;
53                 Vote[] votes;
54                 mapping(address => bool) voted;
55         }
56 
57         struct Member {
58                 address member;
59                 uint voteWeight;
60                 bool canAddProposals;
61                 string name;
62                 uint memberSince;
63         }
64 
65         struct Vote {
66                 bool inSupport;
67                 address voter;
68                 string justification;
69         }
70 
71 
72         /* First time setup */
73         function Congress(uint minimumQuorumForProposals, uint minutesForDebate, int marginOfVotesForMajority, address congressLeader) {
74                 minimumQuorum = minimumQuorumForProposals;
75                 debatingPeriodInMinutes = minutesForDebate;
76                 majorityMargin = marginOfVotesForMajority;
77                 members.length++;
78                 members[0] = Member({
79                         member: 0,
80                         voteWeight: 0,
81                         canAddProposals: false,
82                         memberSince: now,
83                         name: ''
84                 });
85                 if (congressLeader != 0) owner = congressLeader;
86 
87         }
88 
89         /*make member*/
90         function changeMembership(address targetMember, uint voteWeight, bool canAddProposals, string memberName) onlyOwner {
91                 uint id;
92                 if (memberId[targetMember] == 0) {
93                         memberId[targetMember] = members.length;
94                         id = members.length++;
95                         members[id] = Member({
96                                 member: targetMember,
97                                 voteWeight: voteWeight,
98                                 canAddProposals: canAddProposals,
99                                 memberSince: now,
100                                 name: memberName
101                         });
102                 } else {
103                         id = memberId[targetMember];
104                         Member m = members[id];
105                         m.voteWeight = voteWeight;
106                         m.canAddProposals = canAddProposals;
107                         m.name = memberName;
108                 }
109 
110                 MembershipChanged(targetMember);
111 
112         }
113 
114         /*change rules*/
115         function changeVotingRules(uint minimumQuorumForProposals, uint minutesForDebate, int marginOfVotesForMajority) onlyOwner {
116                 minimumQuorum = minimumQuorumForProposals;
117                 debatingPeriodInMinutes = minutesForDebate;
118                 majorityMargin = marginOfVotesForMajority;
119 
120                 ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, majorityMargin);
121         }
122 
123         // ribbonPriceInEther
124         function changeUnicorn(uint newUnicornPriceInFinney, address newUnicornAddress) onlyOwner {
125                 unicornAddress = newUnicornAddress;
126                 priceOfAUnicornInFinney = newUnicornPriceInFinney;
127         }
128 
129         /* Function to create a new proposal */
130         function newProposalInWei(address beneficiary, uint weiAmount, string JobDescription, bytes transactionBytecode) returns(uint proposalID) {
131                 if (memberId[msg.sender] == 0 || !members[memberId[msg.sender]].canAddProposals) throw;
132 
133                 proposalID = proposals.length++;
134                 Proposal p = proposals[proposalID];
135                 p.recipient = beneficiary;
136                 p.amount = weiAmount;
137                 p.description = JobDescription;
138                 p.proposalHash = sha3(beneficiary, weiAmount, transactionBytecode);
139                 p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
140                 p.executed = false;
141                 p.proposalPassed = false;
142                 p.numberOfVotes = 0;
143                 ProposalAdded(proposalID, beneficiary, weiAmount, JobDescription);
144                 numProposals = proposalID + 1;
145         }
146 
147         /* Function to create a new proposal */
148         function newProposalInEther(address beneficiary, uint etherAmount, string JobDescription, bytes transactionBytecode) returns(uint proposalID) {
149                 if (memberId[msg.sender] == 0 || !members[memberId[msg.sender]].canAddProposals) throw;
150 
151                 proposalID = proposals.length++;
152                 Proposal p = proposals[proposalID];
153                 p.recipient = beneficiary;
154                 p.amount = etherAmount * 1 ether;
155                 p.description = JobDescription;
156                 p.proposalHash = sha3(beneficiary, etherAmount * 1 ether, transactionBytecode);
157                 p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
158                 p.executed = false;
159                 p.proposalPassed = false;
160                 p.numberOfVotes = 0;
161                 ProposalAdded(proposalID, beneficiary, etherAmount, JobDescription);
162                 numProposals = proposalID + 1;
163         }
164 
165         /* function to check if a proposal code matches */
166         function checkProposalCode(uint proposalNumber, address beneficiary, uint amount, bytes transactionBytecode) constant returns(bool codeChecksOut) {
167                 Proposal p = proposals[proposalNumber];
168                 return p.proposalHash == sha3(beneficiary, amount, transactionBytecode);
169         }
170 
171         function vote(uint proposalNumber, bool supportsProposal, string justificationText) returns(uint voteID) {
172                 if (memberId[msg.sender] == 0) throw;
173 
174                 uint voteWeight = members[memberId[msg.sender]].voteWeight;
175 
176                 Proposal p = proposals[proposalNumber]; // Get the proposal
177                 if (p.voted[msg.sender] == true) throw; // If has already voted, cancel
178                 p.voted[msg.sender] = true; // Set this voter as having voted
179                 p.numberOfVotes += voteWeight; // Increase the number of votes
180                 if (supportsProposal) { // If they support the proposal
181                         p.currentResult += int(voteWeight); // Increase score
182                 } else { // If they don't
183                         p.currentResult -= int(voteWeight); // Decrease the score
184                 }
185                 // Create a log of this event
186                 Voted(proposalNumber, supportsProposal, msg.sender, justificationText);
187         }
188 
189         function executeProposal(uint proposalNumber, bytes transactionBytecode) returns(int result) {
190                 Proposal p = proposals[proposalNumber];
191                 /* Check if the proposal can be executed */
192                 if (now < p.votingDeadline // has the voting deadline arrived?  
193                         || p.executed // has it been already executed? 
194                         || p.proposalHash != sha3(p.recipient, p.amount, transactionBytecode) // Does the transaction code match the proposal? 
195                         || p.numberOfVotes < minimumQuorum) // has minimum quorum?
196                         throw;
197 
198                 /* execute result */
199                 if (p.currentResult > majorityMargin) {
200                         /* If difference between support and opposition is larger than margin */
201                         p.recipient.call.value(p.amount)(transactionBytecode);
202                         p.executed = true;
203                         p.proposalPassed = true;
204                 } else {
205                         p.executed = true;
206                         p.proposalPassed = false;
207                 }
208                 // Fire Events
209                 ProposalTallied(proposalNumber, p.currentResult, p.numberOfVotes, p.proposalPassed);
210         }
211 
212         function() {
213                 if (msg.value > priceOfAUnicornInFinney) {
214                         token unicorn = token(unicornAddress);
215                         unicorn.mintToken(msg.sender, msg.value / (priceOfAUnicornInFinney * 1 finney));
216                 }
217 
218         }
219 }
220 
221 
222 contract MyToken is owned {
223         /* Public variables of the token */
224         string public name;
225         string public symbol;
226         uint8 public decimals;
227         uint256 public totalSupply;
228 
229         /* This creates an array with all balances */
230         mapping(address => uint256) public balanceOf;
231         mapping(address => bool) public frozenAccount;
232         mapping(address => mapping(address => uint)) public allowance;
233         mapping(address => mapping(address => uint)) public spentAllowance;
234 
235 
236         /* This generates a public event on the blockchain that will notify clients */
237         event Transfer(address indexed from, address indexed to, uint256 value);
238         event FrozenFunds(address target, bool frozen);
239 
240         /* Initializes contract with initial supply tokens to the creator of the contract */
241         function MyToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol, address centralMinter) {
242                 if (centralMinter != 0) owner = centralMinter; // Sets the minter
243                 balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens                    
244                 name = tokenName; // Set the name for display purposes     
245                 symbol = tokenSymbol; // Set the symbol for display purposes    
246                 decimals = decimalUnits; // Amount of decimals for display purposes        
247                 totalSupply = initialSupply;
248         }
249 
250         /* Send coins */
251         function transfer(address _to, uint256 _value) {
252                 if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough   
253                 if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
254                 if (frozenAccount[msg.sender]) throw; // Check if frozen
255                 balanceOf[msg.sender] -= _value; // Subtract from the sender
256                 balanceOf[_to] += _value; // Add the same to the recipient            
257                 Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
258         }
259 
260         function mintToken(address target, uint256 mintedAmount) onlyOwner {
261                 balanceOf[target] += mintedAmount;
262                 totalSupply += mintedAmount;
263                 Transfer(owner, target, mintedAmount);
264         }
265 
266         function freezeAccount(address target, bool freeze) onlyOwner {
267                 frozenAccount[target] = freeze;
268                 FrozenFunds(target, freeze);
269         }
270 
271         function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
272                 if (balanceOf[_from] < _value) throw; // Check if the sender has enough   
273                 if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
274                 if (frozenAccount[_from]) throw; // Check if frozen
275                 if (spentAllowance[_from][msg.sender] + _value > allowance[_from][msg.sender]) throw; // Check allowance
276                 balanceOf[_from] -= _value; // Subtract from the sender
277                 balanceOf[_to] += _value; // Add the same to the recipient            
278                 spentAllowance[_from][msg.sender] += _value;
279                 Transfer(msg.sender, _to, _value);
280         }
281 
282         function approve(address _spender, uint256 _value) returns(bool success) {
283                 allowance[msg.sender][_spender] = _value;
284         }
285 
286         function() {
287                 //owner.send(msg.value);
288                 throw;
289         }
290 }