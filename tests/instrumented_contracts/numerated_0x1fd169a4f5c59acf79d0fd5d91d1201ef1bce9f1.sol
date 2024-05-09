1 pragma solidity ^0.5.3;
2 
3 contract Moloch {
4     using SafeMath for uint256;
5 
6     /***************
7     GLOBAL CONSTANTS
8     ***************/
9     uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
10     uint256 public votingPeriodLength; // default = 35 periods (7 days)
11     uint256 public gracePeriodLength; // default = 35 periods (7 days)
12     uint256 public abortWindow; // default = 5 periods (1 day)
13     uint256 public proposalDeposit; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
14     uint256 public dilutionBound; // default = 3 - maximum multiplier a YES voter will be obligated to pay in case of mass ragequit
15     uint256 public processingReward; // default = 0.1 - amount of ETH to give to whoever processes a proposal
16     uint256 public summoningTime; // needed to determine the current period
17 
18     IERC20 public approvedToken; // approved token contract reference; default = wETH
19     GuildBank public guildBank; // guild bank contract reference
20 
21     // HARD-CODED LIMITS
22     // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
23     // with periods or shares, yet big enough to not limit reasonable use cases.
24     uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; // maximum length of voting period
25     uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; // maximum length of grace period
26     uint256 constant MAX_DILUTION_BOUND = 10**18; // maximum dilution bound
27     uint256 constant MAX_NUMBER_OF_SHARES = 10**18; // maximum number of shares that can be minted
28 
29     /***************
30     EVENTS
31     ***************/
32     event SubmitProposal(uint256 proposalIndex, address indexed delegateKey, address indexed memberAddress, address indexed applicant, uint256 tokenTribute, uint256 sharesRequested);
33     event SubmitVote(uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
34     event ProcessProposal(uint256 indexed proposalIndex, address indexed applicant, address indexed memberAddress, uint256 tokenTribute, uint256 sharesRequested, bool didPass);
35     event Ragequit(address indexed memberAddress, uint256 sharesToBurn);
36     event Abort(uint256 indexed proposalIndex, address applicantAddress);
37     event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
38     event SummonComplete(address indexed summoner, uint256 shares);
39 
40     /******************
41     INTERNAL ACCOUNTING
42     ******************/
43     uint256 public totalShares = 0; // total shares across all members
44     uint256 public totalSharesRequested = 0; // total shares that have been requested in unprocessed proposals
45 
46     enum Vote {
47         Null, // default value, counted as abstention
48         Yes,
49         No
50     }
51 
52     struct Member {
53         address delegateKey; // the key responsible for submitting proposals and voting - defaults to member address unless updated
54         uint256 shares; // the # of shares assigned to this member
55         bool exists; // always true once a member has been created
56         uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
57     }
58 
59     struct Proposal {
60         address proposer; // the member who submitted the proposal
61         address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals
62         uint256 sharesRequested; // the # of shares the applicant is requesting
63         uint256 startingPeriod; // the period in which voting can start for this proposal
64         uint256 yesVotes; // the total number of YES votes for this proposal
65         uint256 noVotes; // the total number of NO votes for this proposal
66         bool processed; // true only if the proposal has been processed
67         bool didPass; // true only if the proposal passed
68         bool aborted; // true only if applicant calls "abort" fn before end of voting period
69         uint256 tokenTribute; // amount of tokens offered as tribute
70         string details; // proposal details - could be IPFS hash, plaintext, or JSON
71         uint256 maxTotalSharesAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
72         mapping (address => Vote) votesByMember; // the votes on this proposal by each member
73     }
74 
75     mapping (address => Member) public members;
76     mapping (address => address) public memberAddressByDelegateKey;
77     Proposal[] public proposalQueue;
78 
79     /********
80     MODIFIERS
81     ********/
82     modifier onlyMember {
83         require(members[msg.sender].shares > 0, "Moloch::onlyMember - not a member");
84         _;
85     }
86 
87     modifier onlyDelegate {
88         require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "Moloch::onlyDelegate - not a delegate");
89         _;
90     }
91 
92     /********
93     FUNCTIONS
94     ********/
95     constructor(
96         address summoner,
97         address _approvedToken,
98         uint256 _periodDuration,
99         uint256 _votingPeriodLength,
100         uint256 _gracePeriodLength,
101         uint256 _abortWindow,
102         uint256 _proposalDeposit,
103         uint256 _dilutionBound,
104         uint256 _processingReward
105     ) public {
106         require(summoner != address(0), "Moloch::constructor - summoner cannot be 0");
107         require(_approvedToken != address(0), "Moloch::constructor - _approvedToken cannot be 0");
108         require(_periodDuration > 0, "Moloch::constructor - _periodDuration cannot be 0");
109         require(_votingPeriodLength > 0, "Moloch::constructor - _votingPeriodLength cannot be 0");
110         require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "Moloch::constructor - _votingPeriodLength exceeds limit");
111         require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "Moloch::constructor - _gracePeriodLength exceeds limit");
112         require(_abortWindow > 0, "Moloch::constructor - _abortWindow cannot be 0");
113         require(_abortWindow <= _votingPeriodLength, "Moloch::constructor - _abortWindow must be smaller than or equal to _votingPeriodLength");
114         require(_dilutionBound > 0, "Moloch::constructor - _dilutionBound cannot be 0");
115         require(_dilutionBound <= MAX_DILUTION_BOUND, "Moloch::constructor - _dilutionBound exceeds limit");
116         require(_proposalDeposit >= _processingReward, "Moloch::constructor - _proposalDeposit cannot be smaller than _processingReward");
117 
118         approvedToken = IERC20(_approvedToken);
119 
120         guildBank = new GuildBank(_approvedToken);
121 
122         periodDuration = _periodDuration;
123         votingPeriodLength = _votingPeriodLength;
124         gracePeriodLength = _gracePeriodLength;
125         abortWindow = _abortWindow;
126         proposalDeposit = _proposalDeposit;
127         dilutionBound = _dilutionBound;
128         processingReward = _processingReward;
129 
130         summoningTime = now;
131 
132         members[summoner] = Member(summoner, 1, true, 0);
133         memberAddressByDelegateKey[summoner] = summoner;
134         totalShares = 1;
135 
136         emit SummonComplete(summoner, 1);
137     }
138 
139     /*****************
140     PROPOSAL FUNCTIONS
141     *****************/
142 
143     function submitProposal(
144         address applicant,
145         uint256 tokenTribute,
146         uint256 sharesRequested,
147         string memory details
148     )
149         public
150         onlyDelegate
151     {
152         require(applicant != address(0), "Moloch::submitProposal - applicant cannot be 0");
153 
154         // Make sure we won't run into overflows when doing calculations with shares.
155         // Note that totalShares + totalSharesRequested + sharesRequested is an upper bound
156         // on the number of shares that can exist until this proposal has been processed.
157         require(totalShares.add(totalSharesRequested).add(sharesRequested) <= MAX_NUMBER_OF_SHARES, "Moloch::submitProposal - too many shares requested");
158 
159         totalSharesRequested = totalSharesRequested.add(sharesRequested);
160 
161         address memberAddress = memberAddressByDelegateKey[msg.sender];
162 
163         // collect proposal deposit from proposer and store it in the Moloch until the proposal is processed
164         require(approvedToken.transferFrom(msg.sender, address(this), proposalDeposit), "Moloch::submitProposal - proposal deposit token transfer failed");
165 
166         // collect tribute from applicant and store it in the Moloch until the proposal is processed
167         require(approvedToken.transferFrom(applicant, address(this), tokenTribute), "Moloch::submitProposal - tribute token transfer failed");
168 
169         // compute startingPeriod for proposal
170         uint256 startingPeriod = max(
171             getCurrentPeriod(),
172             proposalQueue.length == 0 ? 0 : proposalQueue[proposalQueue.length.sub(1)].startingPeriod
173         ).add(1);
174 
175         // create proposal ...
176         Proposal memory proposal = Proposal({
177             proposer: memberAddress,
178             applicant: applicant,
179             sharesRequested: sharesRequested,
180             startingPeriod: startingPeriod,
181             yesVotes: 0,
182             noVotes: 0,
183             processed: false,
184             didPass: false,
185             aborted: false,
186             tokenTribute: tokenTribute,
187             details: details,
188             maxTotalSharesAtYesVote: 0
189         });
190 
191         // ... and append it to the queue
192         proposalQueue.push(proposal);
193 
194         uint256 proposalIndex = proposalQueue.length.sub(1);
195         emit SubmitProposal(proposalIndex, msg.sender, memberAddress, applicant, tokenTribute, sharesRequested);
196     }
197 
198     function submitVote(uint256 proposalIndex, uint8 uintVote) public onlyDelegate {
199         address memberAddress = memberAddressByDelegateKey[msg.sender];
200         Member storage member = members[memberAddress];
201 
202         require(proposalIndex < proposalQueue.length, "Moloch::submitVote - proposal does not exist");
203         Proposal storage proposal = proposalQueue[proposalIndex];
204 
205         require(uintVote < 3, "Moloch::submitVote - uintVote must be less than 3");
206         Vote vote = Vote(uintVote);
207 
208         require(getCurrentPeriod() >= proposal.startingPeriod, "Moloch::submitVote - voting period has not started");
209         require(!hasVotingPeriodExpired(proposal.startingPeriod), "Moloch::submitVote - proposal voting period has expired");
210         require(proposal.votesByMember[memberAddress] == Vote.Null, "Moloch::submitVote - member has already voted on this proposal");
211         require(vote == Vote.Yes || vote == Vote.No, "Moloch::submitVote - vote must be either Yes or No");
212         require(!proposal.aborted, "Moloch::submitVote - proposal has been aborted");
213 
214         // store vote
215         proposal.votesByMember[memberAddress] = vote;
216 
217         // count vote
218         if (vote == Vote.Yes) {
219             proposal.yesVotes = proposal.yesVotes.add(member.shares);
220 
221             // set highest index (latest) yes vote - must be processed for member to ragequit
222             if (proposalIndex > member.highestIndexYesVote) {
223                 member.highestIndexYesVote = proposalIndex;
224             }
225 
226             // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
227             if (totalShares > proposal.maxTotalSharesAtYesVote) {
228                 proposal.maxTotalSharesAtYesVote = totalShares;
229             }
230 
231         } else if (vote == Vote.No) {
232             proposal.noVotes = proposal.noVotes.add(member.shares);
233         }
234 
235         emit SubmitVote(proposalIndex, msg.sender, memberAddress, uintVote);
236     }
237 
238     function processProposal(uint256 proposalIndex) public {
239         require(proposalIndex < proposalQueue.length, "Moloch::processProposal - proposal does not exist");
240         Proposal storage proposal = proposalQueue[proposalIndex];
241 
242         require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "Moloch::processProposal - proposal is not ready to be processed");
243         require(proposal.processed == false, "Moloch::processProposal - proposal has already been processed");
244         require(proposalIndex == 0 || proposalQueue[proposalIndex.sub(1)].processed, "Moloch::processProposal - previous proposal must be processed");
245 
246         proposal.processed = true;
247         totalSharesRequested = totalSharesRequested.sub(proposal.sharesRequested);
248 
249         bool didPass = proposal.yesVotes > proposal.noVotes;
250 
251         // Make the proposal fail if the dilutionBound is exceeded
252         if (totalShares.mul(dilutionBound) < proposal.maxTotalSharesAtYesVote) {
253             didPass = false;
254         }
255 
256         // PROPOSAL PASSED
257         if (didPass && !proposal.aborted) {
258 
259             proposal.didPass = true;
260 
261             // if the applicant is already a member, add to their existing shares
262             if (members[proposal.applicant].exists) {
263                 members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
264 
265             // the applicant is a new member, create a new record for them
266             } else {
267                 // if the applicant address is already taken by a member's delegateKey, reset it to their member address
268                 if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
269                     address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
270                     memberAddressByDelegateKey[memberToOverride] = memberToOverride;
271                     members[memberToOverride].delegateKey = memberToOverride;
272                 }
273 
274                 // use applicant address as delegateKey by default
275                 members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, true, 0);
276                 memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
277             }
278 
279             // mint new shares
280             totalShares = totalShares.add(proposal.sharesRequested);
281 
282             // transfer tokens to guild bank
283             require(
284                 approvedToken.transfer(address(guildBank), proposal.tokenTribute),
285                 "Moloch::processProposal - token transfer to guild bank failed"
286             );
287 
288         // PROPOSAL FAILED OR ABORTED
289         } else {
290             // return all tokens to the applicant
291             require(
292                 approvedToken.transfer(proposal.applicant, proposal.tokenTribute),
293                 "Moloch::processProposal - failing vote token transfer failed"
294             );
295         }
296 
297         // send msg.sender the processingReward
298         require(
299             approvedToken.transfer(msg.sender, processingReward),
300             "Moloch::processProposal - failed to send processing reward to msg.sender"
301         );
302 
303         // return deposit to proposer (subtract processing reward)
304         require(
305             approvedToken.transfer(proposal.proposer, proposalDeposit.sub(processingReward)),
306             "Moloch::processProposal - failed to return proposal deposit to proposer"
307         );
308 
309         emit ProcessProposal(
310             proposalIndex,
311             proposal.applicant,
312             proposal.proposer,
313             proposal.tokenTribute,
314             proposal.sharesRequested,
315             didPass
316         );
317     }
318 
319     function ragequit(uint256 sharesToBurn) public onlyMember {
320         uint256 initialTotalShares = totalShares;
321 
322         Member storage member = members[msg.sender];
323 
324         require(member.shares >= sharesToBurn, "Moloch::ragequit - insufficient shares");
325 
326         require(canRagequit(member.highestIndexYesVote), "Moloch::ragequit - cant ragequit until highest index proposal member voted YES on is processed");
327 
328         // burn shares
329         member.shares = member.shares.sub(sharesToBurn);
330         totalShares = totalShares.sub(sharesToBurn);
331 
332         // instruct guildBank to transfer fair share of tokens to the ragequitter
333         require(
334             guildBank.withdraw(msg.sender, sharesToBurn, initialTotalShares),
335             "Moloch::ragequit - withdrawal of tokens from guildBank failed"
336         );
337 
338         emit Ragequit(msg.sender, sharesToBurn);
339     }
340 
341     function abort(uint256 proposalIndex) public {
342         require(proposalIndex < proposalQueue.length, "Moloch::abort - proposal does not exist");
343         Proposal storage proposal = proposalQueue[proposalIndex];
344 
345         require(msg.sender == proposal.applicant, "Moloch::abort - msg.sender must be applicant");
346         require(getCurrentPeriod() < proposal.startingPeriod.add(abortWindow), "Moloch::abort - abort window must not have passed");
347         require(!proposal.aborted, "Moloch::abort - proposal must not have already been aborted");
348 
349         uint256 tokensToAbort = proposal.tokenTribute;
350         proposal.tokenTribute = 0;
351         proposal.aborted = true;
352 
353         // return all tokens to the applicant
354         require(
355             approvedToken.transfer(proposal.applicant, tokensToAbort),
356             "Moloch::processProposal - failed to return tribute to applicant"
357         );
358 
359         emit Abort(proposalIndex, msg.sender);
360     }
361 
362     function updateDelegateKey(address newDelegateKey) public onlyMember {
363         require(newDelegateKey != address(0), "Moloch::updateDelegateKey - newDelegateKey cannot be 0");
364 
365         // skip checks if member is setting the delegate key to their member address
366         if (newDelegateKey != msg.sender) {
367             require(!members[newDelegateKey].exists, "Moloch::updateDelegateKey - cant overwrite existing members");
368             require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "Moloch::updateDelegateKey - cant overwrite existing delegate keys");
369         }
370 
371         Member storage member = members[msg.sender];
372         memberAddressByDelegateKey[member.delegateKey] = address(0);
373         memberAddressByDelegateKey[newDelegateKey] = msg.sender;
374         member.delegateKey = newDelegateKey;
375 
376         emit UpdateDelegateKey(msg.sender, newDelegateKey);
377     }
378 
379     /***************
380     GETTER FUNCTIONS
381     ***************/
382 
383     function max(uint256 x, uint256 y) internal pure returns (uint256) {
384         return x >= y ? x : y;
385     }
386 
387     function getCurrentPeriod() public view returns (uint256) {
388         return now.sub(summoningTime).div(periodDuration);
389     }
390 
391     function getProposalQueueLength() public view returns (uint256) {
392         return proposalQueue.length;
393     }
394 
395     // can only ragequit if the latest proposal you voted YES on has been processed
396     function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
397         require(highestIndexYesVote < proposalQueue.length, "Moloch::canRagequit - proposal does not exist");
398         return proposalQueue[highestIndexYesVote].processed;
399     }
400 
401     function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
402         return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
403     }
404 
405     function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
406         require(members[memberAddress].exists, "Moloch::getMemberProposalVote - member doesn't exist");
407         require(proposalIndex < proposalQueue.length, "Moloch::getMemberProposalVote - proposal doesn't exist");
408         return proposalQueue[proposalIndex].votesByMember[memberAddress];
409     }
410 }
411 
412 interface IERC20 {
413     function transfer(address to, uint256 value) external returns (bool);
414 
415     function approve(address spender, uint256 value) external returns (bool);
416 
417     function transferFrom(address from, address to, uint256 value) external returns (bool);
418 
419     function totalSupply() external view returns (uint256);
420 
421     function balanceOf(address who) external view returns (uint256);
422 
423     function allowance(address owner, address spender) external view returns (uint256);
424 
425     event Transfer(address indexed from, address indexed to, uint256 value);
426 
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 contract Ownable {
431     address private _owner;
432 
433     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     /**
436      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
437      * account.
438      */
439     constructor () internal {
440         _owner = msg.sender;
441         emit OwnershipTransferred(address(0), _owner);
442     }
443 
444     /**
445      * @return the address of the owner.
446      */
447     function owner() public view returns (address) {
448         return _owner;
449     }
450 
451     /**
452      * @dev Throws if called by any account other than the owner.
453      */
454     modifier onlyOwner() {
455         require(isOwner());
456         _;
457     }
458 
459     /**
460      * @return true if `msg.sender` is the owner of the contract.
461      */
462     function isOwner() public view returns (bool) {
463         return msg.sender == _owner;
464     }
465 
466     /**
467      * @dev Allows the current owner to relinquish control of the contract.
468      * @notice Renouncing to ownership will leave the contract without an owner.
469      * It will not be possible to call the functions with the `onlyOwner`
470      * modifier anymore.
471      */
472     function renounceOwnership() public onlyOwner {
473         emit OwnershipTransferred(_owner, address(0));
474         _owner = address(0);
475     }
476 
477     /**
478      * @dev Allows the current owner to transfer control of the contract to a newOwner.
479      * @param newOwner The address to transfer ownership to.
480      */
481     function transferOwnership(address newOwner) public onlyOwner {
482         _transferOwnership(newOwner);
483     }
484 
485     /**
486      * @dev Transfers control of the contract to a newOwner.
487      * @param newOwner The address to transfer ownership to.
488      */
489     function _transferOwnership(address newOwner) internal {
490         require(newOwner != address(0));
491         emit OwnershipTransferred(_owner, newOwner);
492         _owner = newOwner;
493     }
494 }
495 
496 contract GuildBank is Ownable {
497     using SafeMath for uint256;
498 
499     IERC20 public approvedToken; // approved token contract reference
500 
501     event Withdrawal(address indexed receiver, uint256 amount);
502 
503     constructor(address approvedTokenAddress) public {
504         approvedToken = IERC20(approvedTokenAddress);
505     }
506 
507     function withdraw(address receiver, uint256 shares, uint256 totalShares) public onlyOwner returns (bool) {
508         uint256 amount = approvedToken.balanceOf(address(this)).mul(shares).div(totalShares);
509         emit Withdrawal(receiver, amount);
510         return approvedToken.transfer(receiver, amount);
511     }
512 }
513 
514 library SafeMath {
515     /**
516      * @dev Multiplies two unsigned integers, reverts on overflow.
517      */
518     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
519         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
520         // benefit is lost if 'b' is also tested.
521         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
522         if (a == 0) {
523             return 0;
524         }
525 
526         uint256 c = a * b;
527         require(c / a == b);
528 
529         return c;
530     }
531 
532     /**
533      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
534      */
535     function div(uint256 a, uint256 b) internal pure returns (uint256) {
536         // Solidity only automatically asserts when dividing by 0
537         require(b > 0);
538         uint256 c = a / b;
539         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
540 
541         return c;
542     }
543 
544     /**
545      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
546      */
547     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
548         require(b <= a);
549         uint256 c = a - b;
550 
551         return c;
552     }
553 
554     /**
555      * @dev Adds two unsigned integers, reverts on overflow.
556      */
557     function add(uint256 a, uint256 b) internal pure returns (uint256) {
558         uint256 c = a + b;
559         require(c >= a);
560 
561         return c;
562     }
563 
564     /**
565      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
566      * reverts when dividing by zero.
567      */
568     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
569         require(b != 0);
570         return a % b;
571     }
572 }