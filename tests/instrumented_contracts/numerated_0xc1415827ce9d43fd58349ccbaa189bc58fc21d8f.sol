1 pragma solidity 0.4.19;
2 
3 
4 contract Token {
5     function totalSupply() constant returns (uint totalSupply);
6     function balanceOf(address _owner) constant returns (uint balance);
7     function transfer(address _to, uint _value) returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) returns (bool success);
9     function approve(address _spender, uint _value) returns (bool success);
10     function allowance(address _owner, address _spender) constant returns (uint remaining);
11 
12     function issue(address _to, uint _value) public returns (bool);
13     function transferOwnership(address _newOwner) public;
14 }
15 
16 
17 contract Registry {
18     function updateFee(uint256 _fee) public;
19     function transferOwnership(address _newOwner) public;
20 }
21 
22 
23 contract DAO {
24     function payFee() public payable;
25 }
26 
27 
28 contract TokenRecipient {
29     address public receiver = 0xD86b17d42E4385293B961BE704602eDF0f4b3eB8;
30 
31     event receivedEther(address sender, uint amount);
32 
33     // Dev donations
34     function () public payable {
35         receiver.transfer(msg.value);
36         receivedEther(msg.sender, msg.value);
37     }
38 
39     function payFee() public payable {
40         receivedEther(msg.sender, msg.value);
41     }
42 
43     function withdrawTokenBalance(uint256 _value, address _token) public {
44         Token erc20 = Token(_token);
45         require(erc20.transfer(receiver, _value));
46     }
47 
48     function withdrawFullTokenBalance(address _token) public {
49         Token erc20 = Token(_token);
50         require(erc20.transfer(receiver, erc20.balanceOf(this)));
51     }
52 
53 }
54 
55 
56 /**
57  * The shareholder association contract itself
58  */
59 contract EngravedDAO is TokenRecipient {
60 
61     event ProposalAdded(uint proposalID);
62     event Voted(uint proposalID, bool position, address voter);
63     event ProposalTallied(uint proposalID, uint result, uint quorum, bool active);
64     event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, address newEgcToken);
65 
66     uint public dividend;
67 
68     uint public minimumQuorum;
69     uint public debatingPeriodInMinutes;
70     Proposal[] public proposals;
71     uint public numProposals;
72 
73     uint public minAmount;
74 
75     Token public egcToken;
76     Token public egrToken;
77 
78     Registry public ownership;
79     Registry public integrity;
80 
81     // Payment dates
82     uint256 public withdrawStart;
83 
84     // EGC stored balances for dividends
85     mapping (address => uint256) internal lockedBalances;
86 
87     enum ProposalType {
88         TransferOwnership,
89         ChangeOwnershipFee,
90         ChangeIntegrityFee
91     }
92 
93     struct Proposal {
94         string description;
95         uint votingDeadline;
96         bool executed;
97         bool proposalPassed;
98         uint numberOfVotes;
99         Vote[] votes;
100         mapping (address => bool) voted;
101         ProposalType proposalType;
102         uint newFee;
103         address newDao;
104     }
105 
106     struct Vote {
107         bool inSupport;
108         address voter;
109     }
110 
111     // Modifier that allows only shareholders to vote and create new proposals
112     modifier onlyShareholders {
113         require(egcToken.balanceOf(msg.sender) > 0);
114         _;
115     }
116 
117     /**
118      * Constructor function
119      *
120      * First time setup
121      */
122     function EngravedDAO(
123         address _ownershipAddress,
124         address _integrityAddress,
125         address _egrTokenAddress,
126         address _egcTokenAddress,
127         uint _minimumQuorum,
128         uint _debatingPeriodInMinutes,
129         uint _minAmount
130     ) public {
131         ownership = Registry(_ownershipAddress);
132         integrity = Registry(_integrityAddress);
133         egrToken = Token(_egrTokenAddress);
134         egcToken = Token(_egcTokenAddress);
135 
136         withdrawStart = block.timestamp;
137 
138         if (_minimumQuorum == 0) {
139             _minimumQuorum = 1;
140         }
141 
142         minimumQuorum = _minimumQuorum;
143         debatingPeriodInMinutes = _debatingPeriodInMinutes;
144         ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, egcToken);
145 
146         minAmount = _minAmount;
147     }
148 
149     function withdrawDividends() public {
150         // Locked balance is positive
151         require(lockedBalances[msg.sender] > 0);
152 
153         // On time
154         require(block.timestamp >= withdrawStart + 3 days && block.timestamp < withdrawStart + 1 weeks);
155 
156         uint256 locked = lockedBalances[msg.sender];
157         lockedBalances[msg.sender] = 0;
158 
159         uint256 earnings = dividend * locked / 1e18;
160 
161         // Send tokens back to the stakeholder
162         egcToken.transfer(msg.sender, locked);
163         msg.sender.transfer(earnings);
164     }
165 
166     function unlockFunds() public {
167         // Locked balance is positive
168         require(lockedBalances[msg.sender] > 0);
169 
170         uint256 locked = lockedBalances[msg.sender];
171         lockedBalances[msg.sender] = 0;
172 
173         // Send tokens back to the stakeholder
174         egcToken.transfer(msg.sender, locked);
175     }
176 
177     // Lock funds for dividends payment
178     function lockFunds(uint _value) public {
179         // Three days before the payment date
180         require(block.timestamp >= withdrawStart && block.timestamp < withdrawStart + 3 days);
181 
182         lockedBalances[msg.sender] += _value;
183 
184         require(egcToken.allowance(msg.sender, this) >= _value);
185         require(egcToken.transferFrom(msg.sender, this, _value));
186     }
187 
188     function newOwnershipFeeProposal(
189         uint256 _newFee,
190         string _jobDescription
191     )
192         public onlyShareholders
193         returns (uint proposalID)
194     {
195         proposalID = proposals.length++;
196         Proposal storage p = proposals[proposalID];
197         p.description = _jobDescription;
198         p.votingDeadline = block.timestamp + debatingPeriodInMinutes * 1 minutes;
199         p.executed = false;
200         p.proposalPassed = false;
201         p.numberOfVotes = 0;
202         p.proposalType = ProposalType.ChangeOwnershipFee;
203         p.newFee = _newFee;
204         ProposalAdded(proposalID);
205         numProposals = proposalID+1;
206 
207         return proposalID;
208     }
209 
210     function newIntegrityFeeProposal(
211         uint256 _newFee,
212         string _jobDescription
213     )
214         public onlyShareholders
215         returns (uint proposalID)
216     {
217         proposalID = proposals.length++;
218         Proposal storage p = proposals[proposalID];
219         p.description = _jobDescription;
220         p.votingDeadline = block.timestamp + debatingPeriodInMinutes * 1 minutes;
221         p.executed = false;
222         p.proposalPassed = false;
223         p.numberOfVotes = 0;
224         p.proposalType = ProposalType.ChangeIntegrityFee;
225         p.newFee = _newFee;
226         ProposalAdded(proposalID);
227         numProposals = proposalID+1;
228 
229         return proposalID;
230     }
231 
232     function newTransferProposal(
233         address _newDao,
234         string _jobDescription
235     )
236         public onlyShareholders
237         returns (uint proposalID)
238     {
239         proposalID = proposals.length++;
240         Proposal storage p = proposals[proposalID];
241         p.description = _jobDescription;
242         p.votingDeadline = block.timestamp + debatingPeriodInMinutes * 1 minutes;
243         p.executed = false;
244         p.proposalPassed = false;
245         p.numberOfVotes = 0;
246         p.proposalType = ProposalType.TransferOwnership;
247         p.newDao = _newDao;
248         ProposalAdded(proposalID);
249         numProposals = proposalID+1;
250 
251         return proposalID;
252     }
253 
254     /**
255      * Log a vote for a proposal
256      *
257      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
258      *
259      * @param proposalNumber number of proposal
260      * @param supportsProposal either in favor or against it
261      */
262     function vote(
263         uint proposalNumber,
264         bool supportsProposal
265     )
266         public onlyShareholders
267         returns (uint voteID)
268     {
269         Proposal storage p = proposals[proposalNumber];
270         require(p.voted[msg.sender] != true);
271 
272         voteID = p.votes.length++;
273         p.votes[voteID] = Vote({inSupport: supportsProposal, voter: msg.sender});
274         p.voted[msg.sender] = true;
275         p.numberOfVotes = voteID + 1;
276         Voted(proposalNumber, supportsProposal, msg.sender);
277         return voteID;
278     }
279 
280     /**
281      * Finish vote
282      *
283      * Count the votes proposal #`proposalNumber` and execute it if approved
284      *
285      * @param proposalNumber proposal number
286      */
287     function executeProposal(uint proposalNumber) public {
288         Proposal storage p = proposals[proposalNumber];
289 
290         require(block.timestamp > p.votingDeadline && !p.executed);
291 
292         // ...then tally the results
293         uint quorum = 0;
294         uint yea = 0;
295         uint nay = 0;
296 
297         for (uint i = 0; i < p.votes.length; ++i) {
298             Vote storage v = p.votes[i];
299             uint voteWeight = egcToken.balanceOf(v.voter);
300             quorum += voteWeight;
301             if (v.inSupport) {
302                 yea += voteWeight;
303             } else {
304                 nay += voteWeight;
305             }
306         }
307 
308         require(quorum >= minimumQuorum); // Check if a minimum quorum has been reached
309 
310         if (yea > nay) {
311             // Proposal passed; execute the transaction
312 
313             p.executed = true;
314 
315             if (p.proposalType == ProposalType.ChangeOwnershipFee) {
316                 changeOwnershipFee(p.newFee);
317             } else if (p.proposalType == ProposalType.ChangeIntegrityFee) {
318                 changeIntegrityFee(p.newFee);
319             } else if (p.proposalType == ProposalType.TransferOwnership) {
320                 transferOwnership(p.newDao);
321             }
322 
323             p.proposalPassed = true;
324         } else {
325             // Proposal failed
326             p.proposalPassed = false;
327         }
328 
329         // Fire Events
330         ProposalTallied(proposalNumber, yea - nay, quorum, p.proposalPassed);
331     }
332 
333     function startIncomeDistribution() public {
334         require(withdrawStart + 90 days < block.timestamp);
335 
336         uint256 totalSupply = egcToken.totalSupply();
337         require(totalSupply > 0);
338 
339         // At least 1 wei per XEG so dividend > 0
340         dividend = this.balance * 1e18 / totalSupply;
341         require(dividend >= minAmount);
342 
343         withdrawStart = block.timestamp;
344     }
345 
346     function tokenExchange(uint _amount) public {
347         require(egrToken.allowance(msg.sender, this) >= _amount);
348         require(egrToken.transferFrom(msg.sender, 0x0, _amount));
349         // 100 XEG (18 decimals) per EGR (3 decimals)
350         require(egcToken.issue(msg.sender, _amount * 1e17));
351     }
352 
353     function changeOwnershipFee(uint256 _newFee) private {
354         ownership.updateFee(_newFee);
355     }
356 
357     function changeIntegrityFee(uint256 _newFee) private {
358         integrity.updateFee(_newFee);
359     }
360 
361     function transferOwnership(address _newDao) private {
362         require(block.timestamp > withdrawStart + 1 weeks);
363 
364         // Transfer all ether to the new DAO
365         DAO(_newDao).payFee.value(this.balance)();
366 
367         // Transfer ownership of the owned contracts
368         ownership.transferOwnership(_newDao);
369         integrity.transferOwnership(_newDao);
370         egrToken.transferOwnership(_newDao);
371         egcToken.transferOwnership(_newDao);
372     }
373 
374 }