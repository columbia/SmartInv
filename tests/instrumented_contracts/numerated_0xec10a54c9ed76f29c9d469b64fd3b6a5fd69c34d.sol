1 pragma solidity 0.5.3;
2 
3 /**
4  * @dev Contract module that helps prevent reentrant calls to a function.
5  *
6  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
7  * available, which can be applied to functions to make sure there are no nested
8  * (reentrant) calls to them.
9  *
10  * Note that because there is a single `nonReentrant` guard, functions marked as
11  * `nonReentrant` may not call one another. This can be worked around by making
12  * those functions `private`, and then adding `external` `nonReentrant` entry
13  * points to them.
14  *
15  * TIP: If you would like to learn more about reentrancy and alternative ways
16  * to protect against it, check out our blog post
17  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
18  */
19 contract ReentrancyGuard {
20     // Booleans are more expensive than uint256 or any type that takes up a full
21     // word because each write operation emits an extra SLOAD to first read the
22     // slot's contents, replace the bits taken up by the boolean, and then write
23     // back. This is the compiler's defense against contract upgrades and
24     // pointer aliasing, and it cannot be disabled.
25 
26     // The values being non-zero value makes deployment a bit more expensive,
27     // but in exchange the refund on every call to nonReentrant will be lower in
28     // amount. Since refunds are capped to a percentage of the total
29     // transaction's gas, it is best to keep them low in cases like this one, to
30     // increase the likelihood of the full refund coming into effect.
31     uint256 private constant _NOT_ENTERED = 1;
32     uint256 private constant _ENTERED = 2;
33 
34     uint256 private _status;
35 
36     constructor () internal {
37         _status = _NOT_ENTERED;
38     }
39 
40     /**
41      * @dev Prevents a contract from calling itself, directly or indirectly.
42      * Calling a `nonReentrant` function from another `nonReentrant`
43      * function is not supported. It is possible to prevent this from happening
44      * by making the `nonReentrant` function external, and make it call a
45      * `private` function that does the actual work.
46      */
47     modifier nonReentrant() {
48         // On the first call to nonReentrant, _notEntered will be true
49         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
50 
51         // Any calls to nonReentrant after this point will fail
52         _status = _ENTERED;
53 
54         _;
55 
56         // By storing the original value once again, a refund is triggered (see
57         // https://eips.ethereum.org/EIPS/eip-2200)
58         _status = _NOT_ENTERED;
59     }
60 }
61 
62 interface IERC20 {
63     function transfer(address to, uint256 value) external returns (bool);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68 
69     function totalSupply() external view returns (uint256);
70 
71     function balanceOf(address who) external view returns (uint256);
72 
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library SafeMath {
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93 
94         require(b > 0);
95         uint256 c = a / b;
96 
97         return c;
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b <= a);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a);
110 
111         return c;
112     }
113 }
114 
115 contract Moloch is ReentrancyGuard {
116     using SafeMath for uint256;
117 
118     /***************
119     GLOBAL CONSTANTS
120     ***************/
121     uint256 public periodDuration; // default = 17280 = 4.8 hours in seconds (5 periods per day)
122     uint256 public votingPeriodLength; // default = 35 periods (7 days)
123     uint256 public gracePeriodLength; // default = 35 periods (7 days)
124     uint256 public proposalDeposit; // default = 10 ETH (~$1,000 worth of ETH at contract deployment)
125     uint256 public dilutionBound; // default = 3 - maximum multiplier a YES voter will be obligated to pay in case of mass ragequit
126     uint256 public processingReward; // default = 0.1 - amount of ETH to give to whoever processes a proposal
127     uint256 public summoningTime; // needed to determine the current period
128     bool private initialized; // internally tracks deployment under eip-1167 proxy pattern
129 
130     address public depositToken; // deposit token contract reference; default = wETH
131 
132     // HARD-CODED LIMITS
133     // These numbers are quite arbitrary; they are small enough to avoid overflows when doing calculations
134     // with periods or shares, yet big enough to not limit reasonable use cases.
135     uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; // maximum length of voting period
136     uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; // maximum length of grace period
137     uint256 constant MAX_DILUTION_BOUND = 10**18; // maximum dilution bound
138     uint256 constant MAX_NUMBER_OF_SHARES_AND_LOOT = 10**18; // maximum number of shares that can be minted
139     uint256 constant MAX_TOKEN_WHITELIST_COUNT = 400; // maximum number of whitelisted tokens
140     uint256 constant MAX_TOKEN_GUILDBANK_COUNT = 200; // maximum number of tokens with non-zero balance in guildbank
141 
142     // ***************
143     // EVENTS
144     // ***************
145     event SummonComplete(address indexed summoner, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward);
146     event SubmitProposal(address indexed applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken, string details, bool[6] flags, uint256 proposalId, address indexed delegateKey, address indexed memberAddress);
147     event SponsorProposal(address indexed delegateKey, address indexed memberAddress, uint256 proposalId, uint256 proposalIndex, uint256 startingPeriod);
148     event SubmitVote(uint256 proposalId, uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
149     event ProcessProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
150     event ProcessWhitelistProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
151     event ProcessGuildKickProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
152     event Ragequit(address indexed memberAddress, uint256 sharesToBurn, uint256 lootToBurn);
153     event TokensCollected(address indexed token, uint256 amountToCollect);
154     event CancelProposal(uint256 indexed proposalId, address applicantAddress);
155     event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
156     event Withdraw(address indexed memberAddress, address token, uint256 amount);
157 
158     // *******************
159     // INTERNAL ACCOUNTING
160     // *******************
161     uint256 public proposalCount = 0; // total proposals submitted
162     uint256 public totalShares = 0; // total shares across all members
163     uint256 public totalLoot = 0; // total loot across all members
164 
165     uint256 public totalGuildBankTokens = 0; // total tokens with non-zero balance in guild bank
166 
167     address public constant GUILD = address(0xdead);
168     address public constant ESCROW = address(0xbeef);
169     address public constant TOTAL = address(0xbabe);
170     mapping (address => mapping(address => uint256)) public userTokenBalances; // userTokenBalances[userAddress][tokenAddress]
171 
172     enum Vote {
173         Null, // default value, counted as abstention
174         Yes,
175         No
176     }
177 
178     struct Member {
179         address delegateKey; // the key responsible for submitting proposals and voting - defaults to member address unless updated
180         uint256 shares; // the # of voting shares assigned to this member
181         uint256 loot; // the loot amount available to this member (combined with shares on ragequit)
182         bool exists; // always true once a member has been created
183         uint256 highestIndexYesVote; // highest proposal index # on which the member voted YES
184         uint256 jailed; // set to proposalIndex of a passing guild kick proposal for this member, prevents voting on and sponsoring proposals
185     }
186 
187     struct Proposal {
188         address applicant; // the applicant who wishes to become a member - this key will be used for withdrawals (doubles as guild kick target for gkick proposals)
189         address proposer; // the account that submitted the proposal (can be non-member)
190         address sponsor; // the member that sponsored the proposal (moving it into the queue)
191         uint256 sharesRequested; // the # of shares the applicant is requesting
192         uint256 lootRequested; // the amount of loot the applicant is requesting
193         uint256 tributeOffered; // amount of tokens offered as tribute
194         address tributeToken; // tribute token contract reference
195         uint256 paymentRequested; // amount of tokens requested as payment
196         address paymentToken; // payment token contract reference
197         uint256 startingPeriod; // the period in which voting can start for this proposal
198         uint256 yesVotes; // the total number of YES votes for this proposal
199         uint256 noVotes; // the total number of NO votes for this proposal
200         bool[6] flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
201         string details; // proposal details - could be IPFS hash, plaintext, or JSON
202         uint256 maxTotalSharesAndLootAtYesVote; // the maximum # of total shares encountered at a yes vote on this proposal
203         mapping(address => Vote) votesByMember; // the votes on this proposal by each member
204     }
205 
206     mapping(address => bool) public tokenWhitelist;
207     address[] public approvedTokens;
208 
209     mapping(address => bool) public proposedToWhitelist;
210     mapping(address => bool) public proposedToKick;
211 
212     mapping(address => Member) public members;
213     mapping(address => address) public memberAddressByDelegateKey;
214     address[] public memberList;
215 
216 
217     mapping(uint256 => Proposal) public proposals;
218 
219     uint256[] public proposalQueue;
220 
221     modifier onlyMember {
222         require(members[msg.sender].shares > 0 || members[msg.sender].loot > 0, "not a member");
223         _;
224     }
225 
226     modifier onlyShareholder {
227         require(members[msg.sender].shares > 0, "not a shareholder");
228         _;
229     }
230 
231     modifier onlyDelegate {
232         require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "not a delegate");
233         _;
234     }
235 
236     function init(
237         address[] calldata _summoner,
238         address[] calldata _approvedTokens,
239         uint256 _periodDuration,
240         uint256 _votingPeriodLength,
241         uint256 _gracePeriodLength,
242         uint256 _proposalDeposit,
243         uint256 _dilutionBound,
244         uint256 _processingReward,
245         uint256[] calldata _summonerShares
246     ) external {
247         require(!initialized, "initialized");
248         require(_summoner.length == _summonerShares.length, "summoner length mismatches summonerShares");
249         require(_periodDuration > 0, "_periodDuration cannot be 0");
250         require(_votingPeriodLength > 0, "_votingPeriodLength cannot be 0");
251         require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "_votingPeriodLength exceeds limit");
252         require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "_gracePeriodLength exceeds limit");
253         require(_dilutionBound > 0, "_dilutionBound cannot be 0");
254         require(_dilutionBound <= MAX_DILUTION_BOUND, "_dilutionBound exceeds limit");
255         require(_approvedTokens.length > 0, "need at least one approved token");
256         require(_approvedTokens.length <= MAX_TOKEN_WHITELIST_COUNT, "too many tokens");
257         require(_proposalDeposit >= _processingReward, "_proposalDeposit cannot be smaller than _processingReward");
258         
259         depositToken = _approvedTokens[0];
260       
261         for (uint256 i = 0; i < _summoner.length; i++) {
262             require(_summoner[i] != address(0), "summoner cannot be 0");
263             members[_summoner[i]] = Member(_summoner[i], _summonerShares[i], 0, true, 0, 0);
264             memberAddressByDelegateKey[_summoner[i]] = _summoner[i];
265             totalShares = totalShares.add(_summonerShares[i]);
266         }
267         
268         require(totalShares <= MAX_NUMBER_OF_SHARES_AND_LOOT, "too many shares requested");
269 
270         for (uint256 i = 0; i < _approvedTokens.length; i++) {
271             require(_approvedTokens[i] != address(0), "_approvedToken cannot be 0");
272             require(!tokenWhitelist[_approvedTokens[i]], "duplicate approved token");
273             tokenWhitelist[_approvedTokens[i]] = true;
274             approvedTokens.push(_approvedTokens[i]);
275         }
276 
277         periodDuration = _periodDuration;
278         votingPeriodLength = _votingPeriodLength;
279         gracePeriodLength = _gracePeriodLength;
280         proposalDeposit = _proposalDeposit;
281         dilutionBound = _dilutionBound;
282         processingReward = _processingReward;
283         summoningTime = now;
284         initialized = true;
285     }
286 
287     /*****************
288     PROPOSAL FUNCTIONS
289     *****************/
290     function submitProposal(
291         address applicant,
292         uint256 sharesRequested,
293         uint256 lootRequested,
294         uint256 tributeOffered,
295         address tributeToken,
296         uint256 paymentRequested,
297         address paymentToken,
298         string memory details
299     ) public nonReentrant returns (uint256 proposalId) {
300         require(sharesRequested.add(lootRequested) <= MAX_NUMBER_OF_SHARES_AND_LOOT, "too many shares requested");
301         require(tokenWhitelist[tributeToken], "tributeToken is not whitelisted");
302         require(tokenWhitelist[paymentToken], "payment is not whitelisted");
303         require(applicant != address(0), "applicant cannot be 0");
304         require(applicant != GUILD && applicant != ESCROW && applicant != TOTAL, "applicant address cannot be reserved");
305         require(members[applicant].jailed == 0, "proposal applicant must not be jailed");
306 
307         if (tributeOffered > 0 && userTokenBalances[GUILD][tributeToken] == 0) {
308             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot submit more tribute proposals for new tokens - guildbank is full');
309         }
310 
311         // collect tribute from proposer and store it in the Moloch until the proposal is processed
312         require(IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered), "tribute token transfer failed");
313         unsafeAddToBalance(ESCROW, tributeToken, tributeOffered);
314 
315         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
316 
317         _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);
318         return proposalCount - 1; // return proposalId - contracts calling submit might want it
319     }
320 
321     function submitWhitelistProposal(address tokenToWhitelist, string memory details) public nonReentrant returns (uint256 proposalId) {
322         require(tokenToWhitelist != address(0), "must provide token address");
323         require(!tokenWhitelist[tokenToWhitelist], "cannot already have whitelisted the token");
324         require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot submit more whitelist proposals");
325 
326         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
327         flags[4] = true; // whitelist
328 
329         _submitProposal(address(0), 0, 0, 0, tokenToWhitelist, 0, address(0), details, flags);
330         return proposalCount - 1;
331     }
332 
333     function submitGuildKickProposal(address memberToKick, string memory details) public nonReentrant returns (uint256 proposalId) {
334         Member memory member = members[memberToKick];
335 
336         require(member.shares > 0 || member.loot > 0, "member must have at least one share or one loot");
337         require(members[memberToKick].jailed == 0, "member must not already be jailed");
338 
339         bool[6] memory flags; // [sponsored, processed, didPass, cancelled, whitelist, guildkick]
340         flags[5] = true; // guild kick
341 
342         _submitProposal(memberToKick, 0, 0, 0, address(0), 0, address(0), details, flags);
343         return proposalCount - 1;
344     }
345 
346     function _submitProposal(
347         address applicant,
348         uint256 sharesRequested,
349         uint256 lootRequested,
350         uint256 tributeOffered,
351         address tributeToken,
352         uint256 paymentRequested,
353         address paymentToken,
354         string memory details,
355         bool[6] memory flags
356     ) internal {
357         Proposal memory proposal = Proposal({
358             applicant : applicant,
359             proposer : msg.sender,
360             sponsor : address(0),
361             sharesRequested : sharesRequested,
362             lootRequested : lootRequested,
363             tributeOffered : tributeOffered,
364             tributeToken : tributeToken,
365             paymentRequested : paymentRequested,
366             paymentToken : paymentToken,
367             startingPeriod : 0,
368             yesVotes : 0,
369             noVotes : 0,
370             flags : flags,
371             details : details,
372             maxTotalSharesAndLootAtYesVote : 0
373         });
374 
375         proposals[proposalCount] = proposal;
376         address memberAddress = memberAddressByDelegateKey[msg.sender];
377         // NOTE: argument order matters, avoid stack too deep
378         emit SubmitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags, proposalCount, msg.sender, memberAddress);
379         proposalCount += 1;
380     }
381 
382     function sponsorProposal(uint256 proposalId) public nonReentrant onlyDelegate {
383         // collect proposal deposit from sponsor and store it in the Moloch until the proposal is processed
384         require(IERC20(depositToken).transferFrom(msg.sender, address(this), proposalDeposit), "proposal deposit token transfer failed");
385         unsafeAddToBalance(ESCROW, depositToken, proposalDeposit);
386 
387         Proposal storage proposal = proposals[proposalId];
388 
389         require(proposal.proposer != address(0), 'proposal must have been proposed');
390         require(!proposal.flags[0], "proposal has already been sponsored");
391         require(!proposal.flags[3], "proposal has been cancelled");
392         require(members[proposal.applicant].jailed == 0, "proposal applicant must not be jailed");
393 
394         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0) {
395             require(totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'cannot sponsor more tribute proposals for new tokens - guildbank is full');
396         }
397 
398         // whitelist proposal
399         if (proposal.flags[4]) {
400             require(!tokenWhitelist[address(proposal.tributeToken)], "cannot already have whitelisted the token");
401             require(!proposedToWhitelist[address(proposal.tributeToken)], 'already proposed to whitelist');
402             require(approvedTokens.length < MAX_TOKEN_WHITELIST_COUNT, "cannot sponsor more whitelist proposals");
403             proposedToWhitelist[address(proposal.tributeToken)] = true;
404 
405         // guild kick proposal
406         } else if (proposal.flags[5]) {
407             require(!proposedToKick[proposal.applicant], 'already proposed to kick');
408             proposedToKick[proposal.applicant] = true;
409         }
410 
411         // compute startingPeriod for proposal
412         uint256 startingPeriod = max(
413             getCurrentPeriod(),
414             proposalQueue.length == 0 ? 0 : proposals[proposalQueue[proposalQueue.length.sub(1)]].startingPeriod
415         ).add(1);
416 
417         proposal.startingPeriod = startingPeriod;
418 
419         address memberAddress = memberAddressByDelegateKey[msg.sender];
420         proposal.sponsor = memberAddress;
421 
422         proposal.flags[0] = true; // sponsored
423 
424         // append proposal to the queue
425         proposalQueue.push(proposalId);
426         
427         emit SponsorProposal(msg.sender, memberAddress, proposalId, proposalQueue.length.sub(1), startingPeriod);
428     }
429 
430     // NOTE: In MolochV2 proposalIndex !== proposalId
431     function submitVote(uint256 proposalIndex, uint8 uintVote) public nonReentrant onlyDelegate {
432         address memberAddress = memberAddressByDelegateKey[msg.sender];
433         Member storage member = members[memberAddress];
434 
435         require(proposalIndex < proposalQueue.length, "proposal does not exist");
436         Proposal storage proposal = proposals[proposalQueue[proposalIndex]];
437 
438         require(uintVote < 3, "must be less than 3");
439         Vote vote = Vote(uintVote);
440 
441         require(getCurrentPeriod() >= proposal.startingPeriod, "voting period has not started");
442         require(!hasVotingPeriodExpired(proposal.startingPeriod), "proposal voting period has expired");
443         require(proposal.votesByMember[memberAddress] == Vote.Null, "member has already voted");
444         require(vote == Vote.Yes || vote == Vote.No, "vote must be either Yes or No");
445 
446         proposal.votesByMember[memberAddress] = vote;
447 
448         if (vote == Vote.Yes) {
449             proposal.yesVotes = proposal.yesVotes.add(member.shares);
450 
451             // set highest index (latest) yes vote - must be processed for member to ragequit
452             if (proposalIndex > member.highestIndexYesVote) {
453                 member.highestIndexYesVote = proposalIndex;
454             }
455 
456             // set maximum of total shares encountered at a yes vote - used to bound dilution for yes voters
457             if (totalShares.add(totalLoot) > proposal.maxTotalSharesAndLootAtYesVote) {
458                 proposal.maxTotalSharesAndLootAtYesVote = totalShares.add(totalLoot);
459             }
460 
461         } else if (vote == Vote.No) {
462             proposal.noVotes = proposal.noVotes.add(member.shares);
463         }
464      
465         // NOTE: subgraph indexes by proposalId not proposalIndex since proposalIndex isn't set untill it's been sponsored but proposal is created on submission
466         emit SubmitVote(proposalQueue[proposalIndex], proposalIndex, msg.sender, memberAddress, uintVote);
467     }
468 
469     function processProposal(uint256 proposalIndex) public nonReentrant {
470         _validateProposalForProcessing(proposalIndex);
471 
472         uint256 proposalId = proposalQueue[proposalIndex];
473         Proposal storage proposal = proposals[proposalId];
474 
475         require(!proposal.flags[4] && !proposal.flags[5], "must be a standard proposal");
476 
477         proposal.flags[1] = true; // processed
478 
479         bool didPass = _didPass(proposalIndex);
480 
481         // Make the proposal fail if the new total number of shares and loot exceeds the limit
482         if (totalShares.add(totalLoot).add(proposal.sharesRequested).add(proposal.lootRequested) > MAX_NUMBER_OF_SHARES_AND_LOOT) {
483             didPass = false;
484         }
485 
486         // Make the proposal fail if it is requesting more tokens as payment than the available guild bank balance
487         if (proposal.paymentRequested > userTokenBalances[GUILD][proposal.paymentToken]) {
488             didPass = false;
489         }
490 
491         // Make the proposal fail if it would result in too many tokens with non-zero balance in guild bank
492         if (proposal.tributeOffered > 0 && userTokenBalances[GUILD][proposal.tributeToken] == 0 && totalGuildBankTokens >= MAX_TOKEN_GUILDBANK_COUNT) {
493            didPass = false;
494         }
495 
496         // PROPOSAL PASSED
497         if (didPass) {
498             proposal.flags[2] = true; // didPass
499 
500             // if the applicant is already a member, add to their existing shares & loot
501             if (members[proposal.applicant].exists) {
502                 members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
503                 members[proposal.applicant].loot = members[proposal.applicant].loot.add(proposal.lootRequested);
504 
505             // the applicant is a new member, create a new record for them
506             } else {
507                 // if the applicant address is already taken by a member's delegateKey, reset it to their member address
508                 if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
509                     address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
510                     memberAddressByDelegateKey[memberToOverride] = memberToOverride;
511                     members[memberToOverride].delegateKey = memberToOverride;
512                 }
513 
514                 // use applicant address as delegateKey by default
515                 members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, proposal.lootRequested, true, 0, 0);
516                 memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
517             }
518 
519             // mint new shares & loot
520             totalShares = totalShares.add(proposal.sharesRequested);
521             totalLoot = totalLoot.add(proposal.lootRequested);
522 
523             // if the proposal tribute is the first tokens of its kind to make it into the guild bank, increment total guild bank tokens
524             if (userTokenBalances[GUILD][proposal.tributeToken] == 0 && proposal.tributeOffered > 0) {
525                 totalGuildBankTokens += 1;
526             }
527 
528             unsafeInternalTransfer(ESCROW, GUILD, proposal.tributeToken, proposal.tributeOffered);
529             unsafeInternalTransfer(GUILD, proposal.applicant, proposal.paymentToken, proposal.paymentRequested);
530 
531             // if the proposal spends 100% of guild bank balance for a token, decrement total guild bank tokens
532             if (userTokenBalances[GUILD][proposal.paymentToken] == 0 && proposal.paymentRequested > 0) {
533                 totalGuildBankTokens -= 1;
534             }
535 
536         // PROPOSAL FAILED
537         } else {
538             // return all tokens to the proposer (not the applicant, because funds come from proposer)
539             unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
540         }
541 
542         _returnDeposit(proposal.sponsor);
543 
544         emit ProcessProposal(proposalIndex, proposalId, didPass);
545     }
546 
547     function processWhitelistProposal(uint256 proposalIndex) public nonReentrant {
548         _validateProposalForProcessing(proposalIndex);
549 
550         uint256 proposalId = proposalQueue[proposalIndex];
551         Proposal storage proposal = proposals[proposalId];
552 
553         require(proposal.flags[4], "must be a whitelist proposal");
554 
555         proposal.flags[1] = true; // processed
556 
557         bool didPass = _didPass(proposalIndex);
558 
559         if (approvedTokens.length >= MAX_TOKEN_WHITELIST_COUNT) {
560             didPass = false;
561         }
562 
563         if (didPass) {
564             proposal.flags[2] = true; // didPass
565 
566             tokenWhitelist[address(proposal.tributeToken)] = true;
567             approvedTokens.push(proposal.tributeToken);
568         }
569 
570         proposedToWhitelist[address(proposal.tributeToken)] = false;
571 
572         _returnDeposit(proposal.sponsor);
573 
574         emit ProcessWhitelistProposal(proposalIndex, proposalId, didPass);
575     }
576 
577     function processGuildKickProposal(uint256 proposalIndex) public nonReentrant {
578         _validateProposalForProcessing(proposalIndex);
579 
580         uint256 proposalId = proposalQueue[proposalIndex];
581         Proposal storage proposal = proposals[proposalId];
582 
583         require(proposal.flags[5], "must be a guild kick proposal");
584 
585         proposal.flags[1] = true; // processed
586 
587         bool didPass = _didPass(proposalIndex);
588 
589         if (didPass) {
590             proposal.flags[2] = true; // didPass
591             Member storage member = members[proposal.applicant];
592             member.jailed = proposalIndex;
593 
594             // transfer shares to loot
595             member.loot = member.loot.add(member.shares);
596             totalShares = totalShares.sub(member.shares);
597             totalLoot = totalLoot.add(member.shares);
598             member.shares = 0; // revoke all shares
599         }
600 
601         proposedToKick[proposal.applicant] = false;
602 
603         _returnDeposit(proposal.sponsor);
604 
605         emit ProcessGuildKickProposal(proposalIndex, proposalId, didPass);
606     }
607 
608     function _didPass(uint256 proposalIndex) internal returns (bool didPass) {
609         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
610 
611         didPass = proposal.yesVotes > proposal.noVotes;
612 
613         // Make the proposal fail if the dilutionBound is exceeded
614         if ((totalShares.add(totalLoot)).mul(dilutionBound) < proposal.maxTotalSharesAndLootAtYesVote) {
615             didPass = false;
616         }
617 
618         // Make the proposal fail if the applicant is jailed
619         // - for standard proposals, we don't want the applicant to get any shares/loot/payment
620         // - for guild kick proposals, we should never be able to propose to kick a jailed member (or have two kick proposals active), so it doesn't matter
621         if (members[proposal.applicant].jailed != 0) {
622             didPass = false;
623         }
624 
625         return didPass;
626     }
627 
628     function _validateProposalForProcessing(uint256 proposalIndex) internal view {
629         require(proposalIndex < proposalQueue.length, "proposal does not exist");
630         Proposal memory proposal = proposals[proposalQueue[proposalIndex]];
631 
632         require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "proposal is not ready to be processed");
633         require(proposal.flags[1] == false, "proposal has already been processed");
634         require(proposalIndex == 0 || proposals[proposalQueue[proposalIndex.sub(1)]].flags[1], "previous proposal must be processed");
635     }
636 
637     function _returnDeposit(address sponsor) internal {
638         unsafeInternalTransfer(ESCROW, msg.sender, depositToken, processingReward);
639         unsafeInternalTransfer(ESCROW, sponsor, depositToken, proposalDeposit.sub(processingReward));
640     }
641 
642     function ragequit(uint256 sharesToBurn, uint256 lootToBurn) public nonReentrant onlyMember {
643         _ragequit(msg.sender, sharesToBurn, lootToBurn);
644     }
645 
646     function _ragequit(address memberAddress, uint256 sharesToBurn, uint256 lootToBurn) internal {
647         uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);
648 
649         Member storage member = members[memberAddress];
650 
651         require(member.shares >= sharesToBurn, "insufficient shares");
652         require(member.loot >= lootToBurn, "insufficient loot");
653 
654         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
655 
656         uint256 sharesAndLootToBurn = sharesToBurn.add(lootToBurn);
657 
658         // burn shares and loot
659         member.shares = member.shares.sub(sharesToBurn);
660         member.loot = member.loot.sub(lootToBurn);
661         totalShares = totalShares.sub(sharesToBurn);
662         totalLoot = totalLoot.sub(lootToBurn);
663 
664         for (uint256 i = 0; i < approvedTokens.length; i++) {
665             uint256 amountToRagequit = fairShare(userTokenBalances[GUILD][approvedTokens[i]], sharesAndLootToBurn, initialTotalSharesAndLoot);
666             if (amountToRagequit > 0) { // gas optimization to allow a higher maximum token limit
667                 // deliberately not using safemath here to keep overflows from preventing the function execution (which would break ragekicks)
668                 // if a token overflows, it is because the supply was artificially inflated to oblivion, so we probably don't care about it anyways
669                 userTokenBalances[GUILD][approvedTokens[i]] -= amountToRagequit;
670                 userTokenBalances[memberAddress][approvedTokens[i]] += amountToRagequit;
671             }
672         }
673 
674         emit Ragequit(msg.sender, sharesToBurn, lootToBurn);
675     }
676 
677     function ragekick(address memberToKick) public nonReentrant {
678         Member storage member = members[memberToKick];
679 
680         require(member.jailed != 0, "member must be in jail");
681         require(member.loot > 0, "member must have some loot"); // note - should be impossible for jailed member to have shares
682         require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
683 
684         _ragequit(memberToKick, 0, member.loot);
685     }
686 
687     function withdrawBalance(address token, uint256 amount) public nonReentrant {
688         _withdrawBalance(token, amount);
689     }
690 
691     function withdrawBalances(address[] memory tokens, uint256[] memory amounts, bool max) public nonReentrant {
692         require(tokens.length == amounts.length, "tokens and amounts arrays must be matching lengths");
693 
694         for (uint256 i=0; i < tokens.length; i++) {
695             uint256 withdrawAmount = amounts[i];
696             if (max) { // withdraw the maximum balance
697                 withdrawAmount = userTokenBalances[msg.sender][tokens[i]];
698             }
699 
700             _withdrawBalance(tokens[i], withdrawAmount);
701         }
702     }
703     
704     function _withdrawBalance(address token, uint256 amount) internal {
705         require(userTokenBalances[msg.sender][token] >= amount, "insufficient balance");
706         unsafeSubtractFromBalance(msg.sender, token, amount);
707         require(IERC20(token).transfer(msg.sender, amount), "transfer failed");
708         emit Withdraw(msg.sender, token, amount);
709     }
710 
711     function collectTokens(address token) public onlyDelegate nonReentrant {
712         uint256 amountToCollect = IERC20(token).balanceOf(address(this)).sub(userTokenBalances[TOTAL][token]);
713         // only collect if 1) there are tokens to collect 2) token is whitelisted 3) token has non-zero balance
714         require(amountToCollect > 0, 'no tokens to collect');
715         require(tokenWhitelist[token], 'token to collect must be whitelisted');
716         require(userTokenBalances[GUILD][token] > 0 || totalGuildBankTokens < MAX_TOKEN_GUILDBANK_COUNT, 'token to collect must have non-zero guild bank balance');
717         
718         if (userTokenBalances[GUILD][token] == 0){
719             totalGuildBankTokens += 1;
720         }
721         
722         unsafeAddToBalance(GUILD, token, amountToCollect);
723         emit TokensCollected(token, amountToCollect);
724     }
725 
726     // NOTE: requires that delegate key which sent the original proposal cancels, msg.sender == proposal.proposer
727     function cancelProposal(uint256 proposalId) public nonReentrant {
728         Proposal storage proposal = proposals[proposalId];
729         require(!proposal.flags[0], "proposal has already been sponsored");
730         require(!proposal.flags[3], "proposal has already been cancelled");
731         require(msg.sender == proposal.proposer, "solely the proposer can cancel");
732 
733         proposal.flags[3] = true; // cancelled
734         
735         unsafeInternalTransfer(ESCROW, proposal.proposer, proposal.tributeToken, proposal.tributeOffered);
736         emit CancelProposal(proposalId, msg.sender);
737     }
738 
739     function updateDelegateKey(address newDelegateKey) public nonReentrant onlyShareholder {
740         require(newDelegateKey != address(0), "newDelegateKey cannot be 0");
741 
742         // skip checks if member is setting the delegate key to their member address
743         if (newDelegateKey != msg.sender) {
744             require(!members[newDelegateKey].exists, "cannot overwrite existing members");
745             require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "cannot overwrite existing delegate keys");
746         }
747 
748         Member storage member = members[msg.sender];
749         memberAddressByDelegateKey[member.delegateKey] = address(0);
750         memberAddressByDelegateKey[newDelegateKey] = msg.sender;
751         member.delegateKey = newDelegateKey;
752 
753         emit UpdateDelegateKey(msg.sender, newDelegateKey);
754     }
755 
756     // can only ragequit if the latest proposal you voted YES on has been processed
757     function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
758         require(highestIndexYesVote < proposalQueue.length, "proposal does not exist");
759         return proposals[proposalQueue[highestIndexYesVote]].flags[1];
760     }
761 
762     function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
763         return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
764     }
765 
766     /***************
767     GETTER FUNCTIONS
768     ***************/
769     function max(uint256 x, uint256 y) internal pure returns (uint256) {
770         return x >= y ? x : y;
771     }
772 
773     function getCurrentPeriod() public view returns (uint256) {
774         return now.sub(summoningTime).div(periodDuration);
775     }
776 
777     function getProposalQueueLength() public view returns (uint256) {
778         return proposalQueue.length;
779     }
780 
781     function getProposalFlags(uint256 proposalId) public view returns (bool[6] memory) {
782         return proposals[proposalId].flags;
783     }
784 
785     function getUserTokenBalance(address user, address token) public view returns (uint256) {
786         return userTokenBalances[user][token];
787     }
788 
789     function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
790         require(members[memberAddress].exists, "member does not exist");
791         require(proposalIndex < proposalQueue.length, "proposal does not exist");
792         return proposals[proposalQueue[proposalIndex]].votesByMember[memberAddress];
793     }
794 
795     function getTokenCount() public view returns (uint256) {
796         return approvedTokens.length;
797     }
798 
799     /***************
800     HELPER FUNCTIONS
801     ***************/
802     function unsafeAddToBalance(address user, address token, uint256 amount) internal {
803         userTokenBalances[user][token] += amount;
804         userTokenBalances[TOTAL][token] += amount;
805     }
806 
807     function unsafeSubtractFromBalance(address user, address token, uint256 amount) internal {
808         userTokenBalances[user][token] -= amount;
809         userTokenBalances[TOTAL][token] -= amount;
810     }
811 
812     function unsafeInternalTransfer(address from, address to, address token, uint256 amount) internal {
813         unsafeSubtractFromBalance(from, token, amount);
814         unsafeAddToBalance(to, token, amount);
815     }
816 
817     function fairShare(uint256 balance, uint256 shares, uint256 totalShares) internal pure returns (uint256) {
818         require(totalShares != 0);
819 
820         if (balance == 0) { return 0; }
821 
822         uint256 prod = balance * shares;
823 
824         if (prod / balance == shares) { // no overflow in multiplication above?
825             return prod / totalShares;
826         }
827 
828         return (balance / totalShares) * shares;
829     }
830 }
831 
832 /*
833 The MIT License (MIT)
834 Copyright (c) 2018 Murray Software, LLC.
835 Permission is hereby granted, free of charge, to any person obtaining
836 a copy of this software and associated documentation files (the
837 "Software"), to deal in the Software without restriction, including
838 without limitation the rights to use, copy, modify, merge, publish,
839 distribute, sublicense, and/or sell copies of the Software, and to
840 permit persons to whom the Software is furnished to do so, subject to
841 the following conditions:
842 The above copyright notice and this permission notice shall be included
843 in all copies or substantial portions of the Software.
844 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
845 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
846 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
847 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
848 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
849 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
850 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
851 */
852 contract CloneFactory { // implementation of eip-1167 - see https://eips.ethereum.org/EIPS/eip-1167
853     function createClone(address target) internal returns (address result) {
854         bytes20 targetBytes = bytes20(target);
855         assembly {
856             let clone := mload(0x40)
857             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
858             mstore(add(clone, 0x14), targetBytes)
859             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
860             result := create(0, clone, 0x37)
861         }
862     }
863 }
864 
865 contract MolochSummoner is CloneFactory { 
866     
867     address public template;
868     mapping (address => bool) public daos;
869     uint daoIdx = 0;
870     Moloch private moloch; // moloch contract
871     
872     constructor(address _template) public {
873         template = _template;
874     }
875     
876     event SummonComplete(address indexed moloch, address[] summoner, address[] tokens, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward, uint256[] summonerShares);
877     event Register(uint daoIdx, address moloch, string title, string http, uint version);
878      
879     function summonMoloch(
880         address[] memory _summoner,
881         address[] memory _approvedTokens,
882         uint256 _periodDuration,
883         uint256 _votingPeriodLength,
884         uint256 _gracePeriodLength,
885         uint256 _proposalDeposit,
886         uint256 _dilutionBound,
887         uint256 _processingReward,
888         uint256[] memory _summonerShares
889     ) public returns (address) {
890         Moloch moloch = Moloch(createClone(template));
891         
892         moloch.init(
893             _summoner,
894             _approvedTokens,
895             _periodDuration,
896             _votingPeriodLength,
897             _gracePeriodLength,
898             _proposalDeposit,
899             _dilutionBound,
900             _processingReward,
901             _summonerShares
902         );
903        
904         emit SummonComplete(address(moloch), _summoner, _approvedTokens, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward, _summonerShares);
905         
906         return address(moloch);
907     }
908     
909     function registerDao(
910         address _daoAdress,
911         string memory _daoTitle,
912         string memory _http,
913         uint _version
914       ) public returns (bool) {
915           
916       moloch = Moloch(_daoAdress);
917       (,,,bool exists,,) = moloch.members(msg.sender);
918     
919       require(exists == true, "must be a member");
920       require(daos[_daoAdress] == false, "dao metadata already registered");
921 
922       daos[_daoAdress] = true;
923       
924       daoIdx = daoIdx + 1;
925       emit Register(daoIdx, _daoAdress, _daoTitle, _http, _version);
926       return true;
927       
928     }
929     
930 }