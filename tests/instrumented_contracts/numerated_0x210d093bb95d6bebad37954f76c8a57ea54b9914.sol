1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     require(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     require(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     require(c >= _a);
45     return c;
46   }
47 }
48 
49 contract TwoKeyCongress {
50 
51     event ReceivedEther(address sender, uint amount);
52 
53     using SafeMath for uint;
54 
55     //Period length for voting
56     uint256 public debatingPeriodInMinutes;
57     //Array of proposals
58     Proposal[] public proposals;
59     //Number of proposals
60     uint public numProposals;
61 
62     TwoKeyCongressMembersRegistry public twoKeyCongressMembersRegistry;
63 
64     event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
65     event Voted(uint proposalID, bool position, address voter, string justification);
66     event ProposalTallied(uint proposalID, uint quorum, bool active);
67     event ChangeOfRules(uint256 _newDebatingPeriodInMinutes);
68 
69     struct Proposal {
70         address recipient;
71         uint amount;
72         string description;
73         uint minExecutionDate;
74         bool executed;
75         bool proposalPassed;
76         uint numberOfVotes;
77         uint againstProposalTotal;
78         uint supportingProposalTotal;
79         bytes32 proposalHash;
80         bytes transactionBytecode;
81         Vote[] votes;
82         mapping (address => bool) voted;
83     }
84 
85     struct Vote {
86         bool inSupport;
87         address voter;
88         string justification;
89     }
90 
91 
92     /**
93      * @notice Modifier to check if the msg.sender is member of the congress
94      */
95     modifier onlyMembers() {
96         require(twoKeyCongressMembersRegistry.isMember(msg.sender) == true);
97         _;
98     }
99 
100     /**
101      * @param _minutesForDebate is the number of minutes debate length
102      */
103     constructor(
104         uint256 _minutesForDebate
105     )
106     payable
107     public
108     {
109         changeVotingRules(_minutesForDebate);
110     }
111 
112     /**
113      * @notice Function which will be called only once immediately after contract is deployed
114      * @param _twoKeyCongressMembers is the address of already deployed contract
115      */
116     function setTwoKeyCongressMembersContract(
117         address _twoKeyCongressMembers
118     )
119     public
120     {
121         require(address(twoKeyCongressMembersRegistry) == address(0));
122         twoKeyCongressMembersRegistry = TwoKeyCongressMembersRegistry(_twoKeyCongressMembers);
123     }
124 
125 
126     /**
127      * Change voting rules
128      * @param minutesForDebate the minimum amount of delay between when a proposal is made and when it can be executed
129      */
130     function changeVotingRules(
131         uint256 minutesForDebate
132     )
133     internal
134     {
135         debatingPeriodInMinutes = minutesForDebate;
136         emit ChangeOfRules(minutesForDebate);
137     }
138 
139     /**
140      * Add Proposal
141      *
142      * Propose to send `weiAmount / 1e18` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
143      *
144      * @param beneficiary who to send the ether to
145      * @param weiAmount amount of ether to send, in wei
146      * @param jobDescription Description of job
147      * @param transactionBytecode bytecode of transaction
148      */
149     function newProposal(
150         address beneficiary,
151         uint weiAmount,
152         string jobDescription,
153         bytes transactionBytecode)
154     public
155     payable
156     onlyMembers
157     {
158         uint proposalID = proposals.length++;
159         Proposal storage p = proposals[proposalID];
160         p.recipient = beneficiary;
161         p.amount = weiAmount;
162         p.description = jobDescription;
163         p.proposalHash = keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
164         p.transactionBytecode = transactionBytecode;
165         p.minExecutionDate = block.timestamp + debatingPeriodInMinutes * 1 minutes;
166         p.executed = false;
167         p.proposalPassed = false;
168         p.numberOfVotes = 0;
169         p.againstProposalTotal = 0;
170         p.supportingProposalTotal = 0;
171         emit ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
172         numProposals = proposalID+1;
173     }
174 
175 
176     /**
177      * Check if a proposal code matches
178      *
179      * @param proposalNumber ID number of the proposal to query
180      * @param beneficiary who to send the ether to
181      * @param weiAmount amount of ether to send
182      * @param transactionBytecode bytecode of transaction
183      */
184     function checkProposalCode(
185         uint proposalNumber,
186         address beneficiary,
187         uint weiAmount,
188         bytes transactionBytecode
189     )
190     public
191     view
192     returns (bool codeChecksOut)
193     {
194         Proposal storage p = proposals[proposalNumber];
195         return p.proposalHash == keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
196     }
197 
198     /**
199      * Log a vote for a proposal
200      *
201      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
202      *
203      * @param proposalNumber number of proposal
204      * @param supportsProposal either in favor or against it
205      * @param justificationText optional justification text
206      */
207     function vote(
208         uint proposalNumber,
209         bool supportsProposal,
210         string justificationText
211     )
212     public
213     onlyMembers
214     returns (uint256 voteID)
215     {
216         Proposal storage p = proposals[proposalNumber]; // Get the proposal
217         require(block.timestamp <= p.minExecutionDate);
218         require(!p.voted[msg.sender]);                  // If has already voted, cancel
219         p.voted[msg.sender] = true;                     // Set this voter as having voted
220         p.numberOfVotes++;
221         voteID = p.numberOfVotes;                     // Increase the number of votes
222         p.votes.push(Vote({ inSupport: supportsProposal, voter: msg.sender, justification: justificationText }));
223         uint votingPower = twoKeyCongressMembersRegistry.getMemberVotingPower(msg.sender);
224         if (supportsProposal) {                         // If they support the proposal
225             p.supportingProposalTotal += votingPower; // Increase score
226         } else {                                        // If they don't
227             p.againstProposalTotal += votingPower;                          // Decrease the score
228         }
229         // Create a log of this event
230         emit Voted(proposalNumber,  supportsProposal, msg.sender, justificationText);
231         return voteID;
232     }
233 
234     function getVoteCount(
235         uint256 proposalNumber
236     )
237     onlyMembers
238     public
239     view
240     returns(uint256 numberOfVotes, uint256 supportingProposalTotal, uint256 againstProposalTotal, string description)
241     {
242         require(proposals[proposalNumber].proposalHash != 0);
243         numberOfVotes = proposals[proposalNumber].numberOfVotes;
244         supportingProposalTotal = proposals[proposalNumber].supportingProposalTotal;
245         againstProposalTotal = proposals[proposalNumber].againstProposalTotal;
246         description = proposals[proposalNumber].description;
247     }
248 
249 
250     /**
251      * Finish vote
252      *
253      * Count the votes proposal #`proposalNumber` and execute it if approved
254      *
255      * @param proposalNumber proposal number
256      * @param transactionBytecode optional: if the transaction contained a bytecode, you need to send it
257      */
258     function executeProposal(
259         uint proposalNumber,
260         bytes transactionBytecode
261     )
262     public
263     onlyMembers
264     {
265         Proposal storage p = proposals[proposalNumber];
266         uint minimumQuorum = twoKeyCongressMembersRegistry.minimumQuorum();
267         uint maxVotingPower = twoKeyCongressMembersRegistry.maxVotingPower();
268         require(
269 //            block.timestamp > p.minExecutionDate  &&                             // If it is past the voting deadline
270              !p.executed                                                         // and it has not already been executed
271             && p.proposalHash == keccak256(abi.encodePacked(p.recipient, p.amount, transactionBytecode))  // and the supplied code matches the proposal
272             && p.numberOfVotes >= minimumQuorum.sub(1) // and a minimum quorum has been reached...
273             && uint(p.supportingProposalTotal) >= maxVotingPower.mul(51).div(100) // Total support should be >= than 51%
274         );
275 
276         // ...then execute result
277         p.executed = true; // Avoid recursive calling
278         p.proposalPassed = true;
279 
280         // Fire Events
281         emit ProposalTallied(proposalNumber, p.numberOfVotes, p.proposalPassed);
282 
283 //         Call external function
284         require(p.recipient.call.value(p.amount)(transactionBytecode));
285     }
286 
287 
288     /// @notice Function to get major proposal data
289     /// @param proposalId is the id of proposal
290     /// @return tuple containing all the data for proposal
291     function getProposalData(
292         uint proposalId
293     )
294     public
295     view
296     returns (uint,string,uint,bool,uint,uint,uint,bytes)
297     {
298         Proposal memory p = proposals[proposalId];
299         return (p.amount, p.description, p.minExecutionDate, p.executed, p.numberOfVotes, p.supportingProposalTotal, p.againstProposalTotal, p.transactionBytecode);
300     }
301 
302 
303     /// @notice Fallback function
304     function () payable public {
305         emit ReceivedEther(msg.sender, msg.value);
306     }
307 }
308 
309 contract TwoKeyCongressMembersRegistry {
310     /**
311      * This contract will serve as accountant for Members inside TwoKeyCongress
312      * contract. Only contract eligible to mutate state of this contract is TwoKeyCongress
313      * TwoKeyCongress will check for it's members from this contract.
314      */
315 
316     using SafeMath for uint;
317 
318     event MembershipChanged(address member, bool isMember);
319 
320     address public TWO_KEY_CONGRESS;
321 
322     // The maximum voting power containing sum of voting powers of all active members
323     uint256 public maxVotingPower;
324     //The minimum number of voting members that must be in attendance
325     uint256 public minimumQuorum;
326 
327     // Mapping to check if the member is belonging to congress
328     mapping (address => bool) public isMemberInCongress;
329     // Mapping address to memberId
330     mapping(address => Member) public address2Member;
331     // Mapping to store all members addresses
332     address[] public allMembers;
333 
334     struct Member {
335         address memberAddress;
336         bytes32 name;
337         uint votingPower;
338         uint memberSince;
339     }
340 
341     modifier onlyTwoKeyCongress () {
342         require(msg.sender == TWO_KEY_CONGRESS);
343         _;
344     }
345 
346     /**
347      * @param initialCongressMembers is the array containing addresses of initial members
348      * @param memberVotingPowers is the array of unassigned integers containing voting powers respectively
349      * @dev initialMembers.length must be equal votingPowers.length
350      */
351     constructor(
352         address[] initialCongressMembers,
353         bytes32[] initialCongressMemberNames,
354         uint[] memberVotingPowers,
355         address _twoKeyCongress
356     )
357     public
358     {
359         uint length = initialCongressMembers.length;
360         for(uint i=0; i<length; i++) {
361             addMemberInternal(
362                 initialCongressMembers[i],
363                 initialCongressMemberNames[i],
364                 memberVotingPowers[i]
365             );
366         }
367         TWO_KEY_CONGRESS = _twoKeyCongress;
368     }
369 
370     /**
371      * Add member
372      *
373      * Make `targetMember` a member named `memberName`
374      *
375      * @param targetMember ethereum address to be added
376      * @param memberName public name for that member
377      */
378     function addMember(
379         address targetMember,
380         bytes32 memberName,
381         uint _votingPower
382     )
383     public
384     onlyTwoKeyCongress
385     {
386         addMemberInternal(targetMember, memberName, _votingPower);
387     }
388 
389     function addMemberInternal(
390         address targetMember,
391         bytes32 memberName,
392         uint _votingPower
393     )
394     internal
395     {
396         //Require that this member is not already a member of congress
397         require(isMemberInCongress[targetMember] == false);
398         minimumQuorum = allMembers.length;
399         maxVotingPower = maxVotingPower.add(_votingPower);
400         address2Member[targetMember] = Member(
401             {
402             memberAddress: targetMember,
403             memberSince: block.timestamp,
404             votingPower: _votingPower,
405             name: memberName
406             }
407         );
408         allMembers.push(targetMember);
409         isMemberInCongress[targetMember] = true;
410         emit MembershipChanged(targetMember, true);
411     }
412 
413     /**
414      * Remove member
415      *
416      * @notice Remove membership from `targetMember`
417      *
418      * @param targetMember ethereum address to be removed
419      */
420     function removeMember(
421         address targetMember
422     )
423     public
424     onlyTwoKeyCongress
425     {
426         require(isMemberInCongress[targetMember] == true);
427 
428         //Remove member voting power from max voting power
429         uint votingPower = getMemberVotingPower(targetMember);
430         maxVotingPower-= votingPower;
431 
432         uint length = allMembers.length;
433         uint i=0;
434         //Find selected member
435         while(allMembers[i] != targetMember) {
436             if(i == length) {
437                 revert();
438             }
439             i++;
440         }
441 
442         // Move the lest member to this place
443         allMembers[i] = allMembers[length-1];
444 
445         //After reduce array size
446         delete allMembers[allMembers.length-1];
447 
448         uint newLength = allMembers.length.sub(1);
449         allMembers.length = newLength;
450 
451         //Remove him from state mapping
452         isMemberInCongress[targetMember] = false;
453 
454         //Remove his state to empty member
455         address2Member[targetMember] = Member(
456             {
457                 memberAddress: address(0),
458                 memberSince: block.timestamp,
459                 votingPower: 0,
460                 name: "0x0"
461             }
462         );
463         //Reduce 1 member from quorum
464         minimumQuorum = minimumQuorum.sub(1);
465     }
466 
467     /// @notice Function getter for voting power for specific member
468     /// @param _memberAddress is the address of the member
469     /// @return integer representing voting power
470     function getMemberVotingPower(
471         address _memberAddress
472     )
473     public
474     view
475     returns (uint)
476     {
477         Member memory _member = address2Member[_memberAddress];
478         return _member.votingPower;
479     }
480 
481     /**
482      * @notice Function which will be exposed and congress will use it as "modifier"
483      * @param _address is the address we're willing to check if it belongs to congress
484      * @return true/false depending if it is either a member or not
485      */
486     function isMember(
487         address _address
488     )
489     public
490     view
491     returns (bool)
492     {
493         return isMemberInCongress[_address];
494     }
495 
496     /// @notice Getter for length for how many members are currently
497     /// @return length of members
498     function getMembersLength()
499     public
500     view
501     returns (uint)
502     {
503         return allMembers.length;
504     }
505 
506     /// @notice Function to get addresses of all members in congress
507     /// @return array of addresses
508     function getAllMemberAddresses()
509     public
510     view
511     returns (address[])
512     {
513         return allMembers;
514     }
515 
516     /// Basic getter function
517     function getMemberInfo()
518     public
519     view
520     returns (address, bytes32, uint, uint)
521     {
522         Member memory member = address2Member[msg.sender];
523         return (member.memberAddress, member.name, member.votingPower, member.memberSince);
524     }
525 }