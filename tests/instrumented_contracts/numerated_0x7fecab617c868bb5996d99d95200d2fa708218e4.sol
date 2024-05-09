1 //  the azimuth polls data store
2 //  https://azimuth.network
3 
4 pragma solidity 0.4.24;
5 
6 ////////////////////////////////////////////////////////////////////////////////
7 //  Imports
8 ////////////////////////////////////////////////////////////////////////////////
9 
10 // OpenZeppelin's SafeMath.sol
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
22     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
23     // benefit is lost if 'b' is also tested.
24     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25     if (_a == 0) {
26       return 0;
27     }
28 
29     c = _a * _b;
30     assert(c / _a == _b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
38     // assert(_b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = _a / _b;
40     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
41     return _a / _b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     assert(_b <= _a);
49     return _a - _b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
56     c = _a + _b;
57     assert(c >= _a);
58     return c;
59   }
60 }
61 
62 // Azimuth's SafeMath8.sol
63 
64 /**
65  * @title SafeMath8
66  * @dev Math operations for uint8 with safety checks that throw on error
67  */
68 library SafeMath8 {
69   function mul(uint8 a, uint8 b) internal pure returns (uint8) {
70     uint8 c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function div(uint8 a, uint8 b) internal pure returns (uint8) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint8 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function sub(uint8 a, uint8 b) internal pure returns (uint8) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint8 a, uint8 b) internal pure returns (uint8) {
88     uint8 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 // Azimuth's SafeMath16.sol
95 
96 /**
97  * @title SafeMath16
98  * @dev Math operations for uint16 with safety checks that throw on error
99  */
100 library SafeMath16 {
101   function mul(uint16 a, uint16 b) internal pure returns (uint16) {
102     uint16 c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint16 a, uint16 b) internal pure returns (uint16) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint16 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint16 a, uint16 b) internal pure returns (uint16) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint16 a, uint16 b) internal pure returns (uint16) {
120     uint16 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 }
125 
126 // OpenZeppelin's Ownable.sol
127 
128 /**
129  * @title Ownable
130  * @dev The Ownable contract has an owner address, and provides basic authorization control
131  * functions, this simplifies the implementation of "user permissions".
132  */
133 contract Ownable {
134   address public owner;
135 
136 
137   event OwnershipRenounced(address indexed previousOwner);
138   event OwnershipTransferred(
139     address indexed previousOwner,
140     address indexed newOwner
141   );
142 
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146    * account.
147    */
148   constructor() public {
149     owner = msg.sender;
150   }
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160   /**
161    * @dev Allows the current owner to relinquish control of the contract.
162    * @notice Renouncing to ownership will leave the contract without an owner.
163    * It will not be possible to call the functions with the `onlyOwner`
164    * modifier anymore.
165    */
166   function renounceOwnership() public onlyOwner {
167     emit OwnershipRenounced(owner);
168     owner = address(0);
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param _newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address _newOwner) public onlyOwner {
176     _transferOwnership(_newOwner);
177   }
178 
179   /**
180    * @dev Transfers control of the contract to a newOwner.
181    * @param _newOwner The address to transfer ownership to.
182    */
183   function _transferOwnership(address _newOwner) internal {
184     require(_newOwner != address(0));
185     emit OwnershipTransferred(owner, _newOwner);
186     owner = _newOwner;
187   }
188 }
189 
190 ////////////////////////////////////////////////////////////////////////////////
191 //  Polls
192 ////////////////////////////////////////////////////////////////////////////////
193 
194 //  Polls: proposals & votes data contract
195 //
196 //    This contract is used for storing all data related to the proposals
197 //    of the senate (galaxy owners) and their votes on those proposals.
198 //    It keeps track of votes and uses them to calculate whether a majority
199 //    is in favor of a proposal.
200 //
201 //    Every galaxy can only vote on a proposal exactly once. Votes cannot
202 //    be changed. If a proposal fails to achieve majority within its
203 //    duration, it can be restarted after its cooldown period has passed.
204 //
205 //    The requirements for a proposal to achieve majority are as follows:
206 //    - At least 1/4 of the currently active voters (rounded down) must have
207 //      voted in favor of the proposal,
208 //    - More than half of the votes cast must be in favor of the proposal,
209 //      and this can no longer change, either because
210 //      - the poll duration has passed, or
211 //      - not enough voters remain to take away the in-favor majority.
212 //    As soon as these conditions are met, no further interaction with
213 //    the proposal is possible. Achieving majority is permanent.
214 //
215 //    Since data stores are difficult to upgrade, all of the logic unrelated
216 //    to the voting itself (that is, determining who is eligible to vote)
217 //    is expected to be implemented by this contract's owner.
218 //
219 //    This contract will be owned by the Ecliptic contract.
220 //
221 contract Polls is Ownable
222 {
223   using SafeMath for uint256;
224   using SafeMath16 for uint16;
225   using SafeMath8 for uint8;
226 
227   //  UpgradePollStarted: a poll on :proposal has opened
228   //
229   event UpgradePollStarted(address proposal);
230 
231   //  DocumentPollStarted: a poll on :proposal has opened
232   //
233   event DocumentPollStarted(bytes32 proposal);
234 
235   //  UpgradeMajority: :proposal has achieved majority
236   //
237   event UpgradeMajority(address proposal);
238 
239   //  DocumentMajority: :proposal has achieved majority
240   //
241   event DocumentMajority(bytes32 proposal);
242 
243   //  Poll: full poll state
244   //
245   struct Poll
246   {
247     //  start: the timestamp at which the poll was started
248     //
249     uint256 start;
250 
251     //  voted: per galaxy, whether they have voted on this poll
252     //
253     bool[256] voted;
254 
255     //  yesVotes: amount of votes in favor of the proposal
256     //
257     uint16 yesVotes;
258 
259     //  noVotes: amount of votes against the proposal
260     //
261     uint16 noVotes;
262 
263     //  duration: amount of time during which the poll can be voted on
264     //
265     uint256 duration;
266 
267     //  cooldown: amount of time before the (non-majority) poll can be reopened
268     //
269     uint256 cooldown;
270   }
271 
272   //  pollDuration: duration set for new polls. see also Poll.duration above
273   //
274   uint256 public pollDuration;
275 
276   //  pollCooldown: cooldown set for new polls. see also Poll.cooldown above
277   //
278   uint256 public pollCooldown;
279 
280   //  totalVoters: amount of active galaxies
281   //
282   uint16 public totalVoters;
283 
284   //  upgradeProposals: list of all upgrades ever proposed
285   //
286   //    this allows clients to discover the existence of polls.
287   //    from there, they can do liveness checks on the polls themselves.
288   //
289   address[] public upgradeProposals;
290 
291   //  upgradePolls: per address, poll held to determine if that address
292   //                will become the new ecliptic
293   //
294   mapping(address => Poll) public upgradePolls;
295 
296   //  upgradeHasAchievedMajority: per address, whether that address
297   //                              has ever achieved majority
298   //
299   //    If we did not store this, we would have to look at old poll data
300   //    to see whether or not a proposal has ever achieved majority.
301   //    Since the outcome of a poll is calculated based on :totalVoters,
302   //    which may not be consistent across time, we need to store outcomes
303   //    explicitly instead of re-calculating them. This allows us to always
304   //    tell with certainty whether or not a majority was achieved,
305   //    regardless of the current :totalVoters.
306   //
307   mapping(address => bool) public upgradeHasAchievedMajority;
308 
309   //  documentProposals: list of all documents ever proposed
310   //
311   //    this allows clients to discover the existence of polls.
312   //    from there, they can do liveness checks on the polls themselves.
313   //
314   bytes32[] public documentProposals;
315 
316   //  documentPolls: per hash, poll held to determine if the corresponding
317   //                 document is accepted by the galactic senate
318   //
319   mapping(bytes32 => Poll) public documentPolls;
320 
321   //  documentHasAchievedMajority: per hash, whether that hash has ever
322   //                               achieved majority
323   //
324   //    the note for upgradeHasAchievedMajority above applies here as well
325   //
326   mapping(bytes32 => bool) public documentHasAchievedMajority;
327 
328   //  documentMajorities: all hashes that have achieved majority
329   //
330   bytes32[] public documentMajorities;
331 
332   //  constructor(): initial contract configuration
333   //
334   constructor(uint256 _pollDuration, uint256 _pollCooldown)
335     public
336   {
337     reconfigure(_pollDuration, _pollCooldown);
338   }
339 
340   //  reconfigure(): change poll duration and cooldown
341   //
342   function reconfigure(uint256 _pollDuration, uint256 _pollCooldown)
343     public
344     onlyOwner
345   {
346     require( (5 days <= _pollDuration) && (_pollDuration <= 90 days) &&
347              (5 days <= _pollCooldown) && (_pollCooldown <= 90 days) );
348     pollDuration = _pollDuration;
349     pollCooldown = _pollCooldown;
350   }
351 
352   //  incrementTotalVoters(): increase the amount of registered voters
353   //
354   function incrementTotalVoters()
355     external
356     onlyOwner
357   {
358     require(totalVoters < 256);
359     totalVoters = totalVoters.add(1);
360   }
361 
362   //  getAllUpgradeProposals(): return array of all upgrade proposals ever made
363   //
364   //    Note: only useful for clients, as Solidity does not currently
365   //    support returning dynamic arrays.
366   //
367   function getUpgradeProposals()
368     external
369     view
370     returns (address[] proposals)
371   {
372     return upgradeProposals;
373   }
374 
375   //  getUpgradeProposalCount(): get the number of unique proposed upgrades
376   //
377   function getUpgradeProposalCount()
378     external
379     view
380     returns (uint256 count)
381   {
382     return upgradeProposals.length;
383   }
384 
385   //  getAllDocumentProposals(): return array of all upgrade proposals ever made
386   //
387   //    Note: only useful for clients, as Solidity does not currently
388   //    support returning dynamic arrays.
389   //
390   function getDocumentProposals()
391     external
392     view
393     returns (bytes32[] proposals)
394   {
395     return documentProposals;
396   }
397 
398   //  getDocumentProposalCount(): get the number of unique proposed upgrades
399   //
400   function getDocumentProposalCount()
401     external
402     view
403     returns (uint256 count)
404   {
405     return documentProposals.length;
406   }
407 
408   //  getDocumentMajorities(): return array of all document majorities
409   //
410   //    Note: only useful for clients, as Solidity does not currently
411   //    support returning dynamic arrays.
412   //
413   function getDocumentMajorities()
414     external
415     view
416     returns (bytes32[] majorities)
417   {
418     return documentMajorities;
419   }
420 
421   //  hasVotedOnUpgradePoll(): returns true if _galaxy has voted
422   //                           on the _proposal
423   //
424   function hasVotedOnUpgradePoll(uint8 _galaxy, address _proposal)
425     external
426     view
427     returns (bool result)
428   {
429     return upgradePolls[_proposal].voted[_galaxy];
430   }
431 
432   //  hasVotedOnDocumentPoll(): returns true if _galaxy has voted
433   //                            on the _proposal
434   //
435   function hasVotedOnDocumentPoll(uint8 _galaxy, bytes32 _proposal)
436     external
437     view
438     returns (bool result)
439   {
440     return documentPolls[_proposal].voted[_galaxy];
441   }
442 
443   //  startUpgradePoll(): open a poll on making _proposal the new ecliptic
444   //
445   function startUpgradePoll(address _proposal)
446     external
447     onlyOwner
448   {
449     //  _proposal must not have achieved majority before
450     //
451     require(!upgradeHasAchievedMajority[_proposal]);
452 
453     Poll storage poll = upgradePolls[_proposal];
454 
455     //  if the proposal is being made for the first time, register it.
456     //
457     if (0 == poll.start)
458     {
459       upgradeProposals.push(_proposal);
460     }
461 
462     startPoll(poll);
463     emit UpgradePollStarted(_proposal);
464   }
465 
466   //  startDocumentPoll(): open a poll on accepting the document
467   //                       whose hash is _proposal
468   //
469   function startDocumentPoll(bytes32 _proposal)
470     external
471     onlyOwner
472   {
473     //  _proposal must not have achieved majority before
474     //
475     require(!documentHasAchievedMajority[_proposal]);
476 
477     Poll storage poll = documentPolls[_proposal];
478 
479     //  if the proposal is being made for the first time, register it.
480     //
481     if (0 == poll.start)
482     {
483       documentProposals.push(_proposal);
484     }
485 
486     startPoll(poll);
487     emit DocumentPollStarted(_proposal);
488   }
489 
490   //  startPoll(): open a new poll, or re-open an old one
491   //
492   function startPoll(Poll storage _poll)
493     internal
494   {
495     //  check that the poll has cooled down enough to be started again
496     //
497     //    for completely new polls, the values used will be zero
498     //
499     require( block.timestamp > ( _poll.start.add(
500                                  _poll.duration.add(
501                                  _poll.cooldown )) ) );
502 
503     //  set started poll state
504     //
505     _poll.start = block.timestamp;
506     delete _poll.voted;
507     _poll.yesVotes = 0;
508     _poll.noVotes = 0;
509     _poll.duration = pollDuration;
510     _poll.cooldown = pollCooldown;
511   }
512 
513   //  castUpgradeVote(): as galaxy _as, cast a vote on the _proposal
514   //
515   //    _vote is true when in favor of the proposal, false otherwise
516   //
517   function castUpgradeVote(uint8 _as, address _proposal, bool _vote)
518     external
519     onlyOwner
520     returns (bool majority)
521   {
522     Poll storage poll = upgradePolls[_proposal];
523     processVote(poll, _as, _vote);
524     return updateUpgradePoll(_proposal);
525   }
526 
527   //  castDocumentVote(): as galaxy _as, cast a vote on the _proposal
528   //
529   //    _vote is true when in favor of the proposal, false otherwise
530   //
531   function castDocumentVote(uint8 _as, bytes32 _proposal, bool _vote)
532     external
533     onlyOwner
534     returns (bool majority)
535   {
536     Poll storage poll = documentPolls[_proposal];
537     processVote(poll, _as, _vote);
538     return updateDocumentPoll(_proposal);
539   }
540 
541   //  processVote(): record a vote from _as on the _poll
542   //
543   function processVote(Poll storage _poll, uint8 _as, bool _vote)
544     internal
545   {
546     //  assist symbolic execution tools
547     //
548     assert(block.timestamp >= _poll.start);
549 
550     require( //  may only vote once
551              //
552              !_poll.voted[_as] &&
553              //
554              //  may only vote when the poll is open
555              //
556              (block.timestamp < _poll.start.add(_poll.duration)) );
557 
558     //  update poll state to account for the new vote
559     //
560     _poll.voted[_as] = true;
561     if (_vote)
562     {
563       _poll.yesVotes = _poll.yesVotes.add(1);
564     }
565     else
566     {
567       _poll.noVotes = _poll.noVotes.add(1);
568     }
569   }
570 
571   //  updateUpgradePoll(): check whether the _proposal has achieved
572   //                            majority, updating state, sending an event,
573   //                            and returning true if it has
574   //
575   function updateUpgradePoll(address _proposal)
576     public
577     onlyOwner
578     returns (bool majority)
579   {
580     //  _proposal must not have achieved majority before
581     //
582     require(!upgradeHasAchievedMajority[_proposal]);
583 
584     //  check for majority in the poll
585     //
586     Poll storage poll = upgradePolls[_proposal];
587     majority = checkPollMajority(poll);
588 
589     //  if majority was achieved, update the state and send an event
590     //
591     if (majority)
592     {
593       upgradeHasAchievedMajority[_proposal] = true;
594       emit UpgradeMajority(_proposal);
595     }
596     return majority;
597   }
598 
599   //  updateDocumentPoll(): check whether the _proposal has achieved majority,
600   //                        updating the state and sending an event if it has
601   //
602   //    this can be called by anyone, because the ecliptic does not
603   //    need to be aware of the result
604   //
605   function updateDocumentPoll(bytes32 _proposal)
606     public
607     returns (bool majority)
608   {
609     //  _proposal must not have achieved majority before
610     //
611     require(!documentHasAchievedMajority[_proposal]);
612 
613     //  check for majority in the poll
614     //
615     Poll storage poll = documentPolls[_proposal];
616     majority = checkPollMajority(poll);
617 
618     //  if majority was achieved, update state and send an event
619     //
620     if (majority)
621     {
622       documentHasAchievedMajority[_proposal] = true;
623       documentMajorities.push(_proposal);
624       emit DocumentMajority(_proposal);
625     }
626     return majority;
627   }
628 
629   //  checkPollMajority(): returns true if the majority is in favor of
630   //                       the subject of the poll
631   //
632   function checkPollMajority(Poll _poll)
633     internal
634     view
635     returns (bool majority)
636   {
637     return ( //  poll must have at least the minimum required yes-votes
638              //
639              (_poll.yesVotes >= (totalVoters / 4)) &&
640              //
641              //  and have a majority...
642              //
643              (_poll.yesVotes > _poll.noVotes) &&
644              //
645              //  ...that is indisputable
646              //
647              ( //  either because the poll has ended
648                //
649                (block.timestamp > _poll.start.add(_poll.duration)) ||
650                //
651                //  or there are more yes votes than there can be no votes
652                //
653                ( _poll.yesVotes > totalVoters.sub(_poll.yesVotes) ) ) );
654   }
655 }