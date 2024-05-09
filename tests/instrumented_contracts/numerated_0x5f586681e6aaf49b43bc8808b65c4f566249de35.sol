1 pragma solidity ^0.4.4;
2 
3 /**
4  * @title Contract for object that have an owner
5  */
6 contract Owned {
7     /**
8      * Contract owner address
9      */
10     address public owner;
11 
12     /**
13      * @dev Delegate contract to another person
14      * @param _owner New owner address 
15      */
16     function setOwner(address _owner) onlyOwner
17     { owner = _owner; }
18 
19     /**
20      * @dev Owner check modifier
21      */
22     modifier onlyOwner { if (msg.sender != owner) throw; _; }
23 }
24 
25 /**
26  * @title Common pattern for destroyable contracts 
27  */
28 contract Destroyable {
29     address public hammer;
30 
31     /**
32      * @dev Hammer setter
33      * @param _hammer New hammer address
34      */
35     function setHammer(address _hammer) onlyHammer
36     { hammer = _hammer; }
37 
38     /**
39      * @dev Destroy contract and scrub a data
40      * @notice Only hammer can call it 
41      */
42     function destroy() onlyHammer
43     { suicide(msg.sender); }
44 
45     /**
46      * @dev Hammer check modifier
47      */
48     modifier onlyHammer { if (msg.sender != hammer) throw; _; }
49 }
50 
51 /**
52  * @title Generic owned destroyable contract
53  */
54 contract Object is Owned, Destroyable {
55     function Object() {
56         owner  = msg.sender;
57         hammer = msg.sender;
58     }
59 }
60 
61 // Standard token interface (ERC 20)
62 // https://github.com/ethereum/EIPs/issues/20
63 contract ERC20 
64 {
65 // Functions:
66     /// @return total amount of tokens
67     uint256 public totalSupply;
68 
69     /// @param _owner The address from which the balance will be retrieved
70     /// @return The balance
71     function balanceOf(address _owner) constant returns (uint256);
72 
73     /// @notice send `_value` token to `_to` from `msg.sender`
74     /// @param _to The address of the recipient
75     /// @param _value The amount of token to be transferred
76     /// @return Whether the transfer was successful or not
77     function transfer(address _to, uint256 _value) returns (bool);
78 
79     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
85 
86     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
87     /// @param _spender The address of the account able to transfer the tokens
88     /// @param _value The amount of wei to be approved for transfer
89     /// @return Whether the approval was successful or not
90     function approve(address _spender, uint256 _value) returns (bool);
91 
92     /// @param _owner The address of the account owning tokens
93     /// @param _spender The address of the account able to transfer the tokens
94     /// @return Amount of remaining tokens allowed to spent
95     function allowance(address _owner, address _spender) constant returns (uint256);
96 
97 // Events:
98     event Transfer(address indexed _from, address indexed _to, uint256 _value);
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 /**
103  * @title Asset recipient interface
104  */
105 contract Recipient {
106     /**
107      * @dev On received ethers
108      * @param sender Ether sender
109      * @param amount Ether value
110      */
111     event ReceivedEther(address indexed sender,
112                         uint256 indexed amount);
113 
114     /**
115      * @dev On received custom ERC20 tokens
116      * @param from Token sender
117      * @param value Token value
118      * @param token Token contract address
119      * @param extraData Custom additional data
120      */
121     event ReceivedTokens(address indexed from,
122                          uint256 indexed value,
123                          address indexed token,
124                          bytes extraData);
125 
126     /**
127      * @dev Receive approved ERC20 tokens
128      * @param _from Spender address
129      * @param _value Transaction value
130      * @param _token ERC20 token contract address
131      * @param _extraData Custom additional data
132      */
133     function receiveApproval(address _from, uint256 _value,
134                              ERC20 _token, bytes _extraData) {
135         if (!_token.transferFrom(_from, this, _value)) throw;
136         ReceivedTokens(_from, _value, _token, _extraData);
137     }
138 
139     /**
140      * @dev Catch sended to contract ethers
141      */
142     function () payable
143     { ReceivedEther(msg.sender, msg.value); }
144 }
145 
146 /**
147  * @title Improved congress contract by Ethereum Foundation
148  * @dev https://www.ethereum.org/dao#the-blockchain-congress 
149  */
150 contract Congress is Object, Recipient {
151     /**
152      * @dev Minimal quorum value
153      */
154     uint256 public minimumQuorum;
155 
156     /**
157      * @dev Duration of debates
158      */
159     uint256 public debatingPeriodInMinutes;
160 
161     /**
162      * @dev Majority margin is used in voting procedure 
163      */
164     int256 public majorityMargin;
165 
166     /**
167      * @dev Archive of all member proposals 
168      */
169     Proposal[] public proposals;
170 
171     /**
172      * @dev Count of proposals in archive 
173      */
174     function numProposals() constant returns (uint256)
175     { return proposals.length; }
176 
177     /**
178      * @dev Congress members list
179      */
180     Member[] public members;
181 
182     /**
183      * @dev Get member identifier by account address
184      */
185     mapping(address => uint256) public memberId;
186 
187     /**
188      * @dev On proposal added 
189      * @param proposal Proposal identifier
190      * @param recipient Ether recipient
191      * @param amount Amount of wei to transfer
192      */
193     event ProposalAdded(uint256 indexed proposal,
194                         address indexed recipient,
195                         uint256 indexed amount,
196                         string description);
197 
198     /**
199      * @dev On vote by member accepted
200      * @param proposal Proposal identifier
201      * @param position Is proposal accepted by memeber
202      * @param voter Congress memeber account address
203      * @param justification Member comment
204      */
205     event Voted(uint256 indexed proposal,
206                 bool    indexed position,
207                 address indexed voter,
208                 string justification);
209 
210     /**
211      * @dev On Proposal closed
212      * @param proposal Proposal identifier
213      * @param quorum Number of votes 
214      * @param active Is proposal passed
215      */
216     event ProposalTallied(uint256 indexed proposal,
217                           uint256 indexed quorum,
218                           bool    indexed active);
219 
220     /**
221      * @dev On changed membership
222      * @param member Account address 
223      * @param isMember Is account member now
224      */
225     event MembershipChanged(address indexed member,
226                             bool    indexed isMember);
227 
228     /**
229      * @dev On voting rules changed
230      * @param minimumQuorum New minimal count of votes
231      * @param debatingPeriodInMinutes New debating duration
232      * @param majorityMargin New majority margin value
233      */
234     event ChangeOfRules(uint256 indexed minimumQuorum,
235                         uint256 indexed debatingPeriodInMinutes,
236                         int256  indexed majorityMargin);
237 
238     struct Proposal {
239         address recipient;
240         uint256 amount;
241         string  description;
242         uint256 votingDeadline;
243         bool    executed;
244         bool    proposalPassed;
245         uint256 numberOfVotes;
246         int256  currentResult;
247         bytes32 proposalHash;
248         Vote[]  votes;
249         mapping(address => bool) voted;
250     }
251 
252     struct Member {
253         address member;
254         string  name;
255         uint256 memberSince;
256     }
257 
258     struct Vote {
259         bool    inSupport;
260         address voter;
261         string  justification;
262     }
263 
264     /**
265      * @dev Modifier that allows only shareholders to vote and create new proposals
266      */
267     modifier onlyMembers {
268         if (memberId[msg.sender] == 0) throw;
269         _;
270     }
271 
272     /**
273      * @dev First time setup
274      */
275     function Congress(
276         uint256 minimumQuorumForProposals,
277         uint256 minutesForDebate,
278         int256  marginOfVotesForMajority,
279         address congressLeader
280     ) {
281         changeVotingRules(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority);
282         // It’s necessary to add an empty first member
283         addMember(0, ''); // and let's add the founder, to save a step later
284         if (congressLeader != 0)
285             addMember(congressLeader, 'The Founder');
286     }
287 
288     /**
289      * @dev Append new congress member 
290      * @param targetMember Member account address
291      * @param memberName Member full name
292      */
293     function addMember(address targetMember, string memberName) onlyOwner {
294         if (memberId[targetMember] != 0) throw;
295 
296         memberId[targetMember] = members.length;
297         members.push(Member({member:      targetMember,
298                              memberSince: now,
299                              name:        memberName}));
300 
301         MembershipChanged(targetMember, true);
302     }
303 
304     /**
305      * @dev Remove congress member
306      * @param targetMember Member account address
307      */
308     function removeMember(address targetMember) onlyOwner {
309         if (memberId[targetMember] == 0) throw;
310 
311         uint256 targetId = memberId[targetMember];
312         uint256 lastId   = members.length - 1;
313 
314         // Move last member to removed position
315         Member memory moved    = members[lastId];
316         members[targetId]      = moved; 
317         memberId[moved.member] = targetId;
318 
319         // Clean up
320         memberId[targetMember] = 0;
321         delete members[lastId];
322         --members.length;
323 
324         MembershipChanged(targetMember, false);
325     }
326 
327     /**
328      * @dev Change rules of voting
329      * @param minimumQuorumForProposals Minimal count of votes
330      * @param minutesForDebate Debate deadline in minutes
331      * @param marginOfVotesForMajority Majority margin value
332      */
333     function changeVotingRules(
334         uint256 minimumQuorumForProposals,
335         uint256 minutesForDebate,
336         int256  marginOfVotesForMajority
337     )
338         onlyOwner
339     {
340         minimumQuorum           = minimumQuorumForProposals;
341         debatingPeriodInMinutes = minutesForDebate;
342         majorityMargin          = marginOfVotesForMajority;
343 
344         ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, majorityMargin);
345     }
346 
347     /**
348      * @dev Create a new proposal
349      * @param beneficiary Beneficiary account address
350      * @param amount Transaction value in Wei 
351      * @param jobDescription Job description string
352      * @param transactionBytecode Bytecode of transaction
353      */
354     function newProposal(
355         address beneficiary,
356         uint256 amount,
357         string  jobDescription,
358         bytes   transactionBytecode
359     )
360         onlyMembers
361         returns (uint256 id)
362     {
363         id               = proposals.length++;
364         Proposal p       = proposals[id];
365         p.recipient      = beneficiary;
366         p.amount         = amount;
367         p.description    = jobDescription;
368         p.proposalHash   = sha3(beneficiary, amount, transactionBytecode);
369         p.votingDeadline = now + debatingPeriodInMinutes * 1 minutes;
370         p.executed       = false;
371         p.proposalPassed = false;
372         p.numberOfVotes  = 0;
373         ProposalAdded(id, beneficiary, amount, jobDescription);
374     }
375 
376     /**
377      * @dev Check if a proposal code matches
378      * @param id Proposal identifier
379      * @param beneficiary Beneficiary account address
380      * @param amount Transaction value in Wei 
381      * @param transactionBytecode Bytecode of transaction
382      */
383     function checkProposalCode(
384         uint256 id,
385         address beneficiary,
386         uint256 amount,
387         bytes   transactionBytecode
388     )
389         constant
390         returns (bool codeChecksOut)
391     {
392         return proposals[id].proposalHash
393             == sha3(beneficiary, amount, transactionBytecode);
394     }
395 
396     /**
397      * @dev Proposal voting
398      * @param id Proposal identifier
399      * @param supportsProposal Is proposal supported
400      * @param justificationText Member comment
401      */
402     function vote(
403         uint256 id,
404         bool    supportsProposal,
405         string  justificationText
406     )
407         onlyMembers
408         returns (uint256 vote)
409     {
410         Proposal p = proposals[id];             // Get the proposal
411         if (p.voted[msg.sender] == true) throw; // If has already voted, cancel
412         p.voted[msg.sender] = true;             // Set this voter as having voted
413         p.numberOfVotes++;                      // Increase the number of votes
414         if (supportsProposal) {                 // If they support the proposal
415             p.currentResult++;                  // Increase score
416         } else {                                // If they don't
417             p.currentResult--;                  // Decrease the score
418         }
419         // Create a log of this event
420         Voted(id,  supportsProposal, msg.sender, justificationText);
421     }
422 
423     /**
424      * @dev Try to execute proposal
425      * @param id Proposal identifier
426      * @param transactionBytecode Transaction data
427      */
428     function executeProposal(
429         uint256 id,
430         bytes   transactionBytecode
431     )
432         onlyMembers
433     {
434         Proposal p = proposals[id];
435         /* Check if the proposal can be executed:
436            - Has the voting deadline arrived?
437            - Has it been already executed or is it being executed?
438            - Does the transaction code match the proposal?
439            - Has a minimum quorum?
440         */
441 
442         if (now < p.votingDeadline
443             || p.executed
444             || p.proposalHash != sha3(p.recipient, p.amount, transactionBytecode)
445             || p.numberOfVotes < minimumQuorum)
446             throw;
447 
448         /* execute result */
449         /* If difference between support and opposition is larger than margin */
450         if (p.currentResult > majorityMargin) {
451             // Avoid recursive calling
452 
453             p.executed = true;
454             if (!p.recipient.call.value(p.amount)(transactionBytecode))
455                 throw;
456 
457             p.proposalPassed = true;
458         } else {
459             p.proposalPassed = false;
460         }
461         // Fire Events
462         ProposalTallied(id, p.numberOfVotes, p.proposalPassed);
463     }
464 }
465 
466 library CreatorCongress {
467     function create(uint256 minimumQuorumForProposals, uint256 minutesForDebate, int256 marginOfVotesForMajority, address congressLeader) returns (Congress)
468     { return new Congress(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority, congressLeader); }
469 
470     function version() constant returns (string)
471     { return "v0.6.3"; }
472 
473     function abi() constant returns (string)
474     { return '[{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"proposals","outputs":[{"name":"recipient","type":"address"},{"name":"amount","type":"uint256"},{"name":"description","type":"string"},{"name":"votingDeadline","type":"uint256"},{"name":"executed","type":"bool"},{"name":"proposalPassed","type":"bool"},{"name":"numberOfVotes","type":"uint256"},{"name":"currentResult","type":"int256"},{"name":"proposalHash","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"targetMember","type":"address"}],"name":"removeMember","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"setOwner","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"id","type":"uint256"},{"name":"transactionBytecode","type":"bytes"}],"name":"executeProposal","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"memberId","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"numProposals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"hammer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"members","outputs":[{"name":"member","type":"address"},{"name":"name","type":"string"},{"name":"memberSince","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"debatingPeriodInMinutes","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"minimumQuorum","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"destroy","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"},{"name":"_token","type":"address"},{"name":"_extraData","type":"bytes"}],"name":"receiveApproval","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"majorityMargin","outputs":[{"name":"","type":"int256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"beneficiary","type":"address"},{"name":"amount","type":"uint256"},{"name":"jobDescription","type":"string"},{"name":"transactionBytecode","type":"bytes"}],"name":"newProposal","outputs":[{"name":"id","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"minimumQuorumForProposals","type":"uint256"},{"name":"minutesForDebate","type":"uint256"},{"name":"marginOfVotesForMajority","type":"int256"}],"name":"changeVotingRules","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"targetMember","type":"address"},{"name":"memberName","type":"string"}],"name":"addMember","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hammer","type":"address"}],"name":"setHammer","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"id","type":"uint256"},{"name":"supportsProposal","type":"bool"},{"name":"justificationText","type":"string"}],"name":"vote","outputs":[{"name":"vote","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"id","type":"uint256"},{"name":"beneficiary","type":"address"},{"name":"amount","type":"uint256"},{"name":"transactionBytecode","type":"bytes"}],"name":"checkProposalCode","outputs":[{"name":"codeChecksOut","type":"bool"}],"payable":false,"type":"function"},{"inputs":[{"name":"minimumQuorumForProposals","type":"uint256"},{"name":"minutesForDebate","type":"uint256"},{"name":"marginOfVotesForMajority","type":"int256"},{"name":"congressLeader","type":"address"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"proposal","type":"uint256"},{"indexed":true,"name":"recipient","type":"address"},{"indexed":true,"name":"amount","type":"uint256"},{"indexed":false,"name":"description","type":"string"}],"name":"ProposalAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"proposal","type":"uint256"},{"indexed":true,"name":"position","type":"bool"},{"indexed":true,"name":"voter","type":"address"},{"indexed":false,"name":"justification","type":"string"}],"name":"Voted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"proposal","type":"uint256"},{"indexed":true,"name":"quorum","type":"uint256"},{"indexed":true,"name":"active","type":"bool"}],"name":"ProposalTallied","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"member","type":"address"},{"indexed":true,"name":"isMember","type":"bool"}],"name":"MembershipChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"minimumQuorum","type":"uint256"},{"indexed":true,"name":"debatingPeriodInMinutes","type":"uint256"},{"indexed":true,"name":"majorityMargin","type":"int256"}],"name":"ChangeOfRules","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"sender","type":"address"},{"indexed":true,"name":"amount","type":"uint256"}],"name":"ReceivedEther","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"value","type":"uint256"},{"indexed":true,"name":"token","type":"address"},{"indexed":false,"name":"extraData","type":"bytes"}],"name":"ReceivedTokens","type":"event"}]'; }
475 }
476 
477 /**
478  * @title Builder based contract
479  */
480 contract Builder is Object {
481     /**
482      * @dev this event emitted for every builded contract
483      */
484     event Builded(address indexed client, address indexed instance);
485  
486     /* Addresses builded contracts at sender */
487     mapping(address => address[]) public getContractsOf;
488  
489     /**
490      * @dev Get last address
491      * @return last address contract
492      */
493     function getLastContract() constant returns (address) {
494         var sender_contracts = getContractsOf[msg.sender];
495         return sender_contracts[sender_contracts.length - 1];
496     }
497 
498     /* Building beneficiary */
499     address public beneficiary;
500 
501     /**
502      * @dev Set beneficiary
503      * @param _beneficiary is address of beneficiary
504      */
505     function setBeneficiary(address _beneficiary) onlyOwner
506     { beneficiary = _beneficiary; }
507 
508     /* Building cost  */
509     uint public buildingCostWei;
510 
511     /**
512      * @dev Set building cost
513      * @param _buildingCostWei is cost
514      */
515     function setCost(uint _buildingCostWei) onlyOwner
516     { buildingCostWei = _buildingCostWei; }
517 
518     /* Security check report */
519     string public securityCheckURI;
520 
521     /**
522      * @dev Set security check report URI
523      * @param _uri is an URI to report
524      */
525     function setSecurityCheck(string _uri) onlyOwner
526     { securityCheckURI = _uri; }
527 }
528 
529 //
530 // AIRA Builder for Congress contract
531 //
532 contract BuilderCongress is Builder {
533     /**
534      * @dev Run script creation contract
535      * @return address new contract
536      */
537     function create(uint256 minimumQuorumForProposals,
538                     uint256 minutesForDebate,
539                     int256 marginOfVotesForMajority,
540                     address congressLeader,
541                     address _client) payable returns (address) {
542         if (buildingCostWei > 0 && beneficiary != 0) {
543             // Too low value
544             if (msg.value < buildingCostWei) throw;
545             // Beneficiary send
546             if (!beneficiary.send(buildingCostWei)) throw;
547             // Refund
548             if (msg.value > buildingCostWei) {
549                 if (!msg.sender.send(msg.value - buildingCostWei)) throw;
550             }
551         } else {
552             // Refund all
553             if (msg.value > 0) {
554                 if (!msg.sender.send(msg.value)) throw;
555             }
556         }
557 
558         if (_client == 0)
559             _client = msg.sender;
560  
561         if (congressLeader == 0)
562             congressLeader = _client;
563 
564         var inst = CreatorCongress.create(minimumQuorumForProposals,
565                                           minutesForDebate,
566                                           marginOfVotesForMajority,
567                                           congressLeader);
568         inst.setOwner(_client);
569         inst.setHammer(_client);
570         getContractsOf[_client].push(inst);
571         Builded(_client, inst);
572         return inst;
573     }
574 }