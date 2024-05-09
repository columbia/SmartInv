1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-25
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 /**
8  * @title ReailtioSafeMath256
9  * @dev Math operations with safety checks that throw on error
10  */
11 library RealitioSafeMath256 {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 pragma solidity ^0.4.24;
40 
41 /**
42  * @title RealitioSafeMath32
43  * @dev Math operations with safety checks that throw on error
44  * @dev Copy of SafeMath but for uint32 instead of uint256
45  * @dev Deleted functions we don't use
46  */
47 library RealitioSafeMath32 {
48   function add(uint32 a, uint32 b) internal pure returns (uint32) {
49     uint32 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 pragma solidity ^0.4.24;
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address who) external view returns (uint256);
64 
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     function transfer(address to, uint256 value) external returns (bool);
68 
69     function approve(address spender, uint256 value) external returns (bool);
70 
71     function transferFrom(address from, address to, uint256 value) external returns (bool);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 pragma solidity ^0.4.18;
78 
79 contract BalanceHolder {
80 
81     mapping(address => uint256) public balanceOf;
82 
83     event LogWithdraw(
84         address indexed user,
85         uint256 amount
86     );
87 
88     function withdraw() 
89     public {
90         uint256 bal = balanceOf[msg.sender];
91         balanceOf[msg.sender] = 0;
92         msg.sender.transfer(bal);
93         emit LogWithdraw(msg.sender, bal);
94     }
95 
96 }
97 pragma solidity ^0.4.18;
98 
99 
100 contract Owned {
101     address public owner;
102 
103     constructor() 
104     public {
105         owner = msg.sender;
106     }
107 
108     modifier onlyOwner {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     function transferOwnership(address newOwner) 
114         onlyOwner 
115     public {
116         owner = newOwner;
117     }
118 }
119 pragma solidity ^0.4.24;
120 
121 
122 contract Realitio is BalanceHolder {
123 
124     using RealitioSafeMath256 for uint256;
125     using RealitioSafeMath32 for uint32;
126 
127     address constant NULL_ADDRESS = address(0);
128 
129     // History hash when no history is created, or history has been cleared
130     bytes32 constant NULL_HASH = bytes32(0);
131 
132     // An unitinalized finalize_ts for a question will indicate an unanswered question.
133     uint32 constant UNANSWERED = 0;
134 
135     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
136     uint256 constant COMMITMENT_NON_EXISTENT = 0;
137 
138     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
139     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
140 
141     event LogSetQuestionFee(
142         address arbitrator,
143         uint256 amount
144     );
145 
146     event LogNewTemplate(
147         uint256 indexed template_id,
148         address indexed user, 
149         string question_text
150     );
151 
152     event LogNewQuestion(
153         bytes32 indexed question_id,
154         address indexed user, 
155         uint256 template_id,
156         string question,
157         bytes32 indexed content_hash,
158         address arbitrator, 
159         uint32 timeout,
160         uint32 opening_ts,
161         uint256 nonce,
162         uint256 created
163     );
164 
165     event LogFundAnswerBounty(
166         bytes32 indexed question_id,
167         uint256 bounty_added,
168         uint256 bounty,
169         address indexed user 
170     );
171 
172     event LogNewAnswer(
173         bytes32 answer,
174         bytes32 indexed question_id,
175         bytes32 history_hash,
176         address indexed user,
177         uint256 bond,
178         uint256 ts,
179         bool is_commitment
180     );
181 
182     event LogAnswerReveal(
183         bytes32 indexed question_id, 
184         address indexed user, 
185         bytes32 indexed answer_hash, 
186         bytes32 answer, 
187         uint256 nonce, 
188         uint256 bond
189     );
190 
191     event LogNotifyOfArbitrationRequest(
192         bytes32 indexed question_id,
193         address indexed user 
194     );
195 
196     event LogFinalize(
197         bytes32 indexed question_id,
198         bytes32 indexed answer
199     );
200 
201     event LogClaim(
202         bytes32 indexed question_id,
203         address indexed user,
204         uint256 amount
205     );
206 
207     struct Question {
208         bytes32 content_hash;
209         address arbitrator;
210         uint32 opening_ts;
211         uint32 timeout;
212         uint32 finalize_ts;
213         bool is_pending_arbitration;
214         uint256 bounty;
215         bytes32 best_answer;
216         bytes32 history_hash;
217         uint256 bond;
218     }
219 
220     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
221     struct Commitment {
222         uint32 reveal_ts;
223         bool is_revealed;
224         bytes32 revealed_answer;
225     }
226 
227     // Only used when claiming more bonds than fits into a transaction
228     // Stored in a mapping indexed by question_id.
229     struct Claim {
230         address payee;
231         uint256 last_bond;
232         uint256 queued_funds;
233     }
234 
235     uint256 nextTemplateID = 0;
236     mapping(uint256 => uint256) public templates;
237     mapping(uint256 => bytes32) public template_hashes;
238     mapping(bytes32 => Question) public questions;
239     mapping(bytes32 => Claim) public question_claims;
240     mapping(bytes32 => Commitment) public commitments;
241     mapping(address => uint256) public arbitrator_question_fees; 
242 
243     modifier onlyArbitrator(bytes32 question_id) {
244         require(msg.sender == questions[question_id].arbitrator, "msg.sender must be arbitrator");
245         _;
246     }
247 
248     modifier stateAny() {
249         _;
250     }
251 
252     modifier stateNotCreated(bytes32 question_id) {
253         require(questions[question_id].timeout == 0, "question must not exist");
254         _;
255     }
256 
257     modifier stateOpen(bytes32 question_id) {
258         require(questions[question_id].timeout > 0, "question must exist");
259         require(!questions[question_id].is_pending_arbitration, "question must not be pending arbitration");
260         uint32 finalize_ts = questions[question_id].finalize_ts;
261         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization deadline must not have passed");
262         uint32 opening_ts = questions[question_id].opening_ts;
263         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
264         _;
265     }
266 
267     modifier statePendingArbitration(bytes32 question_id) {
268         require(questions[question_id].is_pending_arbitration, "question must be pending arbitration");
269         _;
270     }
271 
272     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
273         require(questions[question_id].timeout > 0, "question must exist");
274         uint32 finalize_ts = questions[question_id].finalize_ts;
275         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization dealine must not have passed");
276         uint32 opening_ts = questions[question_id].opening_ts;
277         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
278         _;
279     }
280 
281     modifier stateFinalized(bytes32 question_id) {
282         require(isFinalized(question_id), "question must be finalized");
283         _;
284     }
285 
286     modifier bondMustDouble(bytes32 question_id) {
287         require(msg.value > 0, "bond must be positive"); 
288         require(msg.value >= (questions[question_id].bond.mul(2)), "bond must be double at least previous bond");
289         _;
290     }
291 
292     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
293         if (max_previous > 0) {
294             require(questions[question_id].bond <= max_previous, "bond must exceed max_previous");
295         }
296         _;
297     }
298 
299     /// @notice Constructor, sets up some initial templates
300     /// @dev Creates some generalized templates for different question types used in the DApp.
301     constructor() 
302     public {
303         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
304         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
305         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
306         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
307         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
308     }
309 
310     /// @notice Function for arbitrator to set an optional per-question fee. 
311     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
312     /// @param fee The fee to be charged by the arbitrator when a question is asked
313     function setQuestionFee(uint256 fee) 
314         stateAny() 
315     external {
316         arbitrator_question_fees[msg.sender] = fee;
317         emit LogSetQuestionFee(msg.sender, fee);
318     }
319 
320     /// @notice Create a reusable template, which should be a JSON document.
321     /// Placeholders should use gettext() syntax, eg %s.
322     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
323     /// @param content The template content
324     /// @return The ID of the newly-created template, which is created sequentially.
325     function createTemplate(string content) 
326         stateAny()
327     public returns (uint256) {
328         uint256 id = nextTemplateID;
329         templates[id] = block.number;
330         template_hashes[id] = keccak256(abi.encodePacked(content));
331         emit LogNewTemplate(id, msg.sender, content);
332         nextTemplateID = id.add(1);
333         return id;
334     }
335 
336     /// @notice Create a new reusable template and use it to ask a question
337     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
338     /// @param content The template content
339     /// @param question A string containing the parameters that will be passed into the template to make the question
340     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
341     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
342     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
343     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
344     /// @return The ID of the newly-created template, which is created sequentially.
345     function createTemplateAndAskQuestion(
346         string content, 
347         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
348     ) 
349         // stateNotCreated is enforced by the internal _askQuestion
350     public payable returns (bytes32) {
351         uint256 template_id = createTemplate(content);
352         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
353     }
354 
355     /// @notice Ask a new question and return the ID
356     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
357     /// @param template_id The ID number of the template the question will use
358     /// @param question A string containing the parameters that will be passed into the template to make the question
359     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
360     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
361     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
362     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
363     /// @return The ID of the newly-created question, created deterministically.
364     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
365         // stateNotCreated is enforced by the internal _askQuestion
366     public payable returns (bytes32) {
367 
368         require(templates[template_id] > 0, "template must exist");
369 
370         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
371         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
372 
373         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
374         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
375 
376         return question_id;
377     }
378 
379     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
380         stateNotCreated(question_id)
381     internal {
382 
383         // A timeout of 0 makes no sense, and we will use this to check existence
384         require(timeout > 0, "timeout must be positive"); 
385         require(timeout < 365 days, "timeout must be less than 365 days"); 
386         require(arbitrator != NULL_ADDRESS, "arbitrator must be set");
387 
388         uint256 bounty = msg.value;
389 
390         // The arbitrator can set a fee for asking a question. 
391         // This is intended as an anti-spam defence.
392         // The fee is waived if the arbitrator is asking the question.
393         // This allows them to set an impossibly high fee and make users proxy the question through them.
394         // This would allow more sophisticated pricing, question whitelisting etc.
395         if (msg.sender != arbitrator) {
396             uint256 question_fee = arbitrator_question_fees[arbitrator];
397             require(bounty >= question_fee, "ETH provided must cover question fee"); 
398             bounty = bounty.sub(question_fee);
399             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
400         }
401 
402         questions[question_id].content_hash = content_hash;
403         questions[question_id].arbitrator = arbitrator;
404         questions[question_id].opening_ts = opening_ts;
405         questions[question_id].timeout = timeout;
406         questions[question_id].bounty = bounty;
407 
408     }
409 
410     /// @notice Add funds to the bounty for a question
411     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
412     /// @param question_id The ID of the question you wish to fund
413     function fundAnswerBounty(bytes32 question_id) 
414         stateOpen(question_id)
415     external payable {
416         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
417         emit LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
418     }
419 
420     /// @notice Submit an answer for a question.
421     /// @dev Adds the answer to the history and updates the current "best" answer.
422     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
423     /// @param question_id The ID of the question
424     /// @param answer The answer, encoded into bytes32
425     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
426     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
427         stateOpen(question_id)
428         bondMustDouble(question_id)
429         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
430     external payable {
431         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
432         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
433     }
434 
435     // @notice Verify and store a commitment, including an appropriate timeout
436     // @param question_id The ID of the question to store
437     // @param commitment The ID of the commitment
438     function _storeCommitment(bytes32 question_id, bytes32 commitment_id) 
439     internal
440     {
441         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
442 
443         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
444         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
445     }
446 
447     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
448     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
449     /// The commitment_id is stored in the answer history where the answer would normally go.
450     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
451     /// @param question_id The ID of the question
452     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
453     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
454     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
455     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
456     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
457         stateOpen(question_id)
458         bondMustDouble(question_id)
459         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
460     external payable {
461 
462         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, msg.value));
463         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
464         _storeCommitment(question_id, commitment_id);
465         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
466 
467     }
468 
469     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
470     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
471     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
472     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
473     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
474     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
475     /// @param question_id The ID of the question
476     /// @param answer The answer, encoded as bytes32
477     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
478     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
479     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
480         stateOpenOrPendingArbitration(question_id)
481     external {
482 
483         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
484         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
485 
486         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
487         require(commitments[commitment_id].reveal_ts > uint32(now), "reveal deadline must not have passed");
488 
489         commitments[commitment_id].revealed_answer = answer;
490         commitments[commitment_id].is_revealed = true;
491 
492         if (bond == questions[question_id].bond) {
493             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
494         }
495 
496         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
497 
498     }
499 
500     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
501     internal 
502     {
503         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
504 
505         // Update the current bond level, if there's a bond (ie anything except arbitration)
506         if (bond > 0) {
507             questions[question_id].bond = bond;
508         }
509         questions[question_id].history_hash = new_history_hash;
510 
511         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
512     }
513 
514     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
515     internal {
516         questions[question_id].best_answer = answer;
517         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
518     }
519 
520     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
521     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
522     /// @param question_id The ID of the question
523     /// @param requester The account that requested arbitration
524     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
525     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
526         onlyArbitrator(question_id)
527         stateOpen(question_id)
528         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
529     external {
530         require(questions[question_id].bond > 0, "Question must already have an answer when arbitration is requested");
531         questions[question_id].is_pending_arbitration = true;
532         emit LogNotifyOfArbitrationRequest(question_id, requester);
533     }
534 
535     /// @notice Submit the answer for a question, for use by the arbitrator.
536     /// @dev Doesn't require (or allow) a bond.
537     /// If the current final answer is correct, the account should be whoever submitted it.
538     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
539     /// However, the answerer stipulations are not enforced by the contract.
540     /// @param question_id The ID of the question
541     /// @param answer The answer, encoded into bytes32
542     /// @param answerer The account credited with this answer for the purpose of bond claims
543     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
544         onlyArbitrator(question_id)
545         statePendingArbitration(question_id)
546     external {
547 
548         require(answerer != NULL_ADDRESS, "answerer must be provided");
549         emit LogFinalize(question_id, answer);
550 
551         questions[question_id].is_pending_arbitration = false;
552         _addAnswerToHistory(question_id, answer, answerer, 0, false);
553         _updateCurrentAnswer(question_id, answer, 0);
554 
555     }
556 
557     /// @notice Report whether the answer to the specified question is finalized
558     /// @param question_id The ID of the question
559     /// @return Return true if finalized
560     function isFinalized(bytes32 question_id) 
561     view public returns (bool) {
562         uint32 finalize_ts = questions[question_id].finalize_ts;
563         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
564     }
565 
566     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
567     /// @param question_id The ID of the question
568     /// @return The answer formatted as a bytes32
569     function getFinalAnswer(bytes32 question_id) 
570         stateFinalized(question_id)
571     external view returns (bytes32) {
572         return questions[question_id].best_answer;
573     }
574 
575     /// @notice Return the final answer to the specified question, or revert if there isn't one
576     /// @param question_id The ID of the question
577     /// @return The answer formatted as a bytes32
578     function resultFor(bytes32 question_id) 
579         stateFinalized(question_id)
580     external view returns (bytes32) {
581         return questions[question_id].best_answer;
582     }
583 
584 
585     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
586     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
587     /// @param question_id The ID of the question
588     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
589     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
590     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
591     /// @param min_bond The bond sent with the final answer must be this high or higher
592     /// @return The answer formatted as a bytes32
593     function getFinalAnswerIfMatches(
594         bytes32 question_id, 
595         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
596     ) 
597         stateFinalized(question_id)
598     external view returns (bytes32) {
599         require(content_hash == questions[question_id].content_hash, "content hash must match");
600         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
601         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
602         require(min_bond <= questions[question_id].bond, "bond must be high enough");
603         return questions[question_id].best_answer;
604     }
605 
606     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
607     /// Caller must provide the answer history, in reverse order
608     /// @dev Works up the chain and assign bonds to the person who gave the right answer
609     /// If someone gave the winning answer earlier, they must get paid from the higher bond
610     /// That means we can't pay out the bond added at n until we have looked at n-1
611     /// The first answer is authenticated by checking against the stored history_hash.
612     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
613     /// Once we get to a null hash we'll know we're done and there are no more answers.
614     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
615     /// @param question_id The ID of the question
616     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
617     /// @param addrs Last-to-first, the address of each answerer or commitment sender
618     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
619     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
620     function claimWinnings(
621         bytes32 question_id, 
622         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
623     ) 
624         stateFinalized(question_id)
625     public {
626 
627         require(history_hashes.length > 0, "at least one history hash entry must be provided");
628 
629         // These are only set if we split our claim over multiple transactions.
630         address payee = question_claims[question_id].payee; 
631         uint256 last_bond = question_claims[question_id].last_bond; 
632         uint256 queued_funds = question_claims[question_id].queued_funds; 
633 
634         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
635         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
636         bytes32 last_history_hash = questions[question_id].history_hash;
637 
638         bytes32 best_answer = questions[question_id].best_answer;
639 
640         uint256 i;
641         for (i = 0; i < history_hashes.length; i++) {
642         
643             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
644             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
645             
646             queued_funds = queued_funds.add(last_bond); 
647             (queued_funds, payee) = _processHistoryItem(
648                 question_id, best_answer, queued_funds, payee, 
649                 addrs[i], bonds[i], answers[i], is_commitment);
650  
651             // Line the bond up for next time, when it will be added to somebody's queued_funds
652             last_bond = bonds[i];
653             last_history_hash = history_hashes[i];
654 
655         }
656  
657         if (last_history_hash != NULL_HASH) {
658             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
659             // Persist the details so we can pick up later where we left off later.
660 
661             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
662             // (We always know who to pay unless all we saw were unrevealed commits)
663             if (payee != NULL_ADDRESS) {
664                 _payPayee(question_id, payee, queued_funds);
665                 queued_funds = 0;
666             }
667 
668             question_claims[question_id].payee = payee;
669             question_claims[question_id].last_bond = last_bond;
670             question_claims[question_id].queued_funds = queued_funds;
671         } else {
672             // There is nothing left below us so the payee can keep what remains
673             _payPayee(question_id, payee, queued_funds.add(last_bond));
674             delete question_claims[question_id];
675         }
676 
677         questions[question_id].history_hash = last_history_hash;
678 
679     }
680 
681     function _payPayee(bytes32 question_id, address payee, uint256 value) 
682     internal {
683         balanceOf[payee] = balanceOf[payee].add(value);
684         emit LogClaim(question_id, payee, value);
685     }
686 
687     function _verifyHistoryInputOrRevert(
688         bytes32 last_history_hash,
689         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
690     )
691     internal pure returns (bool) {
692         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
693             return true;
694         }
695         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
696             return false;
697         } 
698         revert("History input provided did not match the expected hash");
699     }
700 
701     function _processHistoryItem(
702         bytes32 question_id, bytes32 best_answer, 
703         uint256 queued_funds, address payee, 
704         address addr, uint256 bond, bytes32 answer, bool is_commitment
705     )
706     internal returns (uint256, address) {
707 
708         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
709         // We look at the referenced commitment ID and switch in the actual answer.
710         if (is_commitment) {
711             bytes32 commitment_id = answer;
712             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
713             if (!commitments[commitment_id].is_revealed) {
714                 delete commitments[commitment_id];
715                 return (queued_funds, payee);
716             } else {
717                 answer = commitments[commitment_id].revealed_answer;
718                 delete commitments[commitment_id];
719             }
720         }
721 
722         if (answer == best_answer) {
723 
724             if (payee == NULL_ADDRESS) {
725 
726                 // The entry is for the first payee we come to, ie the winner.
727                 // They get the question bounty.
728                 payee = addr;
729                 queued_funds = queued_funds.add(questions[question_id].bounty);
730                 questions[question_id].bounty = 0;
731 
732             } else if (addr != payee) {
733 
734                 // Answerer has changed, ie we found someone lower down who needs to be paid
735 
736                 // The lower answerer will take over receiving bonds from higher answerer.
737                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
738                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
739 
740                 // There should be enough for the fee, but if not, take what we have.
741                 // There's an edge case involving weird arbitrator behaviour where we may be short.
742                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
743 
744                 // Settle up with the old (higher-bonded) payee
745                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
746 
747                 // Now start queued_funds again for the new (lower-bonded) payee
748                 payee = addr;
749                 queued_funds = answer_takeover_fee;
750 
751             }
752 
753         }
754 
755         return (queued_funds, payee);
756 
757     }
758 
759     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
760     /// Caller must provide the answer history for each question, in reverse order
761     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
762     /// @param question_ids The IDs of the questions you want to claim for
763     /// @param lengths The number of history entries you will supply for each question ID
764     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
765     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
766     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
767     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
768     function claimMultipleAndWithdrawBalance(
769         bytes32[] question_ids, uint256[] lengths, 
770         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
771     ) 
772         stateAny() // The finalization checks are done in the claimWinnings function
773     public {
774         
775         uint256 qi;
776         uint256 i;
777         for (qi = 0; qi < question_ids.length; qi++) {
778             bytes32 qid = question_ids[qi];
779             uint256 ln = lengths[qi];
780             bytes32[] memory hh = new bytes32[](ln);
781             address[] memory ad = new address[](ln);
782             uint256[] memory bo = new uint256[](ln);
783             bytes32[] memory an = new bytes32[](ln);
784             uint256 j;
785             for (j = 0; j < ln; j++) {
786                 hh[j] = hist_hashes[i];
787                 ad[j] = addrs[i];
788                 bo[j] = bonds[i];
789                 an[j] = answers[i];
790                 i++;
791             }
792             claimWinnings(qid, hh, ad, bo, an);
793         }
794         withdraw();
795     }
796 
797     /// @notice Returns the questions's content hash, identifying the question content
798     /// @param question_id The ID of the question 
799     function getContentHash(bytes32 question_id) 
800     public view returns(bytes32) {
801         return questions[question_id].content_hash;
802     }
803 
804     /// @notice Returns the arbitrator address for the question
805     /// @param question_id The ID of the question 
806     function getArbitrator(bytes32 question_id) 
807     public view returns(address) {
808         return questions[question_id].arbitrator;
809     }
810 
811     /// @notice Returns the timestamp when the question can first be answered
812     /// @param question_id The ID of the question 
813     function getOpeningTS(bytes32 question_id) 
814     public view returns(uint32) {
815         return questions[question_id].opening_ts;
816     }
817 
818     /// @notice Returns the timeout in seconds used after each answer
819     /// @param question_id The ID of the question 
820     function getTimeout(bytes32 question_id) 
821     public view returns(uint32) {
822         return questions[question_id].timeout;
823     }
824 
825     /// @notice Returns the timestamp at which the question will be/was finalized
826     /// @param question_id The ID of the question 
827     function getFinalizeTS(bytes32 question_id) 
828     public view returns(uint32) {
829         return questions[question_id].finalize_ts;
830     }
831 
832     /// @notice Returns whether the question is pending arbitration
833     /// @param question_id The ID of the question 
834     function isPendingArbitration(bytes32 question_id) 
835     public view returns(bool) {
836         return questions[question_id].is_pending_arbitration;
837     }
838 
839     /// @notice Returns the current total unclaimed bounty
840     /// @dev Set back to zero once the bounty has been claimed
841     /// @param question_id The ID of the question 
842     function getBounty(bytes32 question_id) 
843     public view returns(uint256) {
844         return questions[question_id].bounty;
845     }
846 
847     /// @notice Returns the current best answer
848     /// @param question_id The ID of the question 
849     function getBestAnswer(bytes32 question_id) 
850     public view returns(bytes32) {
851         return questions[question_id].best_answer;
852     }
853 
854     /// @notice Returns the history hash of the question 
855     /// @param question_id The ID of the question 
856     /// @dev Updated on each answer, then rewound as each is claimed
857     function getHistoryHash(bytes32 question_id) 
858     public view returns(bytes32) {
859         return questions[question_id].history_hash;
860     }
861 
862     /// @notice Returns the highest bond posted so far for a question
863     /// @param question_id The ID of the question 
864     function getBond(bytes32 question_id) 
865     public view returns(uint256) {
866         return questions[question_id].bond;
867     }
868 
869 }
870 pragma solidity ^0.4.24;
871 
872 contract Arbitrator is Owned {
873 
874     Realitio public realitio;
875 
876     mapping(bytes32 => uint256) public arbitration_bounties;
877 
878     uint256 dispute_fee;
879     mapping(bytes32 => uint256) custom_dispute_fees;
880 
881     string public metadata;
882 
883     event LogRequestArbitration(
884         bytes32 indexed question_id,
885         uint256 fee_paid,
886         address requester,
887         uint256 remaining
888     );
889 
890     event LogSetRealitio(
891         address realitio
892     );
893 
894     event LogSetQuestionFee(
895         uint256 fee
896     );
897 
898 
899     event LogSetDisputeFee(
900         uint256 fee
901     );
902 
903     event LogSetCustomDisputeFee(
904         bytes32 indexed question_id,
905         uint256 fee
906     );
907 
908     /// @notice Constructor. Sets the deploying address as owner.
909     constructor() 
910     public {
911         owner = msg.sender;
912     }
913 
914     /// @notice Returns the Realitio contract address - deprecated in favour of realitio()
915     function realitycheck() 
916     external view returns(Realitio) {
917         return realitio;
918     }
919 
920     /// @notice Set the Reality Check contract address
921     /// @param addr The address of the Reality Check contract
922     function setRealitio(address addr) 
923         onlyOwner 
924     public {
925         realitio = Realitio(addr);
926         emit LogSetRealitio(addr);
927     }
928 
929     /// @notice Set the default fee
930     /// @param fee The default fee amount
931     function setDisputeFee(uint256 fee) 
932         onlyOwner 
933     public {
934         dispute_fee = fee;
935         emit LogSetDisputeFee(fee);
936     }
937 
938     /// @notice Set a custom fee for this particular question
939     /// @param question_id The question in question
940     /// @param fee The fee amount
941     function setCustomDisputeFee(bytes32 question_id, uint256 fee) 
942         onlyOwner 
943     public {
944         custom_dispute_fees[question_id] = fee;
945         emit LogSetCustomDisputeFee(question_id, fee);
946     }
947 
948     /// @notice Return the dispute fee for the specified question. 0 indicates that we won't arbitrate it.
949     /// @param question_id The question in question
950     /// @dev Uses a general default, but can be over-ridden on a question-by-question basis.
951     function getDisputeFee(bytes32 question_id) 
952     public view returns (uint256) {
953         return (custom_dispute_fees[question_id] > 0) ? custom_dispute_fees[question_id] : dispute_fee;
954     }
955 
956     /// @notice Set a fee for asking a question with us as the arbitrator
957     /// @param fee The fee amount
958     /// @dev Default is no fee. Unlike the dispute fee, 0 is an acceptable setting.
959     /// You could set an impossibly high fee if you want to prevent us being used as arbitrator unless we submit the question.
960     /// (Submitting the question ourselves is not implemented here.)
961     /// This fee can be used as a revenue source, an anti-spam measure, or both.
962     function setQuestionFee(uint256 fee) 
963         onlyOwner 
964     public {
965         realitio.setQuestionFee(fee);
966         emit LogSetQuestionFee(fee);
967     }
968 
969     /// @notice Submit the arbitrator's answer to a question.
970     /// @param question_id The question in question
971     /// @param answer The answer
972     /// @param answerer The answerer. If arbitration changed the answer, it should be the payer. If not, the old answerer.
973     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
974         onlyOwner 
975     public {
976         delete arbitration_bounties[question_id];
977         realitio.submitAnswerByArbitrator(question_id, answer, answerer);
978     }
979 
980     /// @notice Request arbitration, freezing the question until we send submitAnswerByArbitrator
981     /// @dev The bounty can be paid only in part, in which case the last person to pay will be considered the payer
982     /// Will trigger an error if the notification fails, eg because the question has already been finalized
983     /// @param question_id The question in question
984     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
985     function requestArbitration(bytes32 question_id, uint256 max_previous) 
986     external payable returns (bool) {
987 
988         uint256 arbitration_fee = getDisputeFee(question_id);
989         require(arbitration_fee > 0, "The arbitrator must have set a non-zero fee for the question");
990 
991         arbitration_bounties[question_id] += msg.value;
992         uint256 paid = arbitration_bounties[question_id];
993 
994         if (paid >= arbitration_fee) {
995             realitio.notifyOfArbitrationRequest(question_id, msg.sender, max_previous);
996             emit LogRequestArbitration(question_id, msg.value, msg.sender, 0);
997             return true;
998         } else {
999             require(!realitio.isFinalized(question_id), "The question must not have been finalized");
1000             emit LogRequestArbitration(question_id, msg.value, msg.sender, arbitration_fee - paid);
1001             return false;
1002         }
1003 
1004     }
1005 
1006     /// @notice Withdraw any accumulated ETH fees to the specified address
1007     /// @param addr The address to which the balance should be sent
1008     function withdraw(address addr) 
1009         onlyOwner 
1010     public {
1011         addr.transfer(address(this).balance); 
1012     }
1013 
1014     /// @notice Withdraw any accumulated token fees to the specified address
1015     /// @param addr The address to which the balance should be sent
1016     /// @dev Only needed if the Realitio contract used is using an ERC20 token
1017     /// @dev Also only normally useful if a per-question fee is set, otherwise we only have ETH.
1018     function withdrawERC20(IERC20 _token, address addr) 
1019         onlyOwner 
1020     public {
1021         uint256 bal = _token.balanceOf(address(this));
1022         IERC20(_token).transfer(addr, bal); 
1023     }
1024 
1025     function() 
1026     external payable {
1027     }
1028 
1029     /// @notice Withdraw any accumulated question fees from the specified address into this contract
1030     /// @dev Funds can then be liberated from this contract with our withdraw() function
1031     /// @dev This works in the same way whether the realitio contract is using ETH or an ERC20 token
1032     function callWithdraw() 
1033         onlyOwner 
1034     public {
1035         realitio.withdraw(); 
1036     }
1037 
1038     /// @notice Set a metadata string, expected to be JSON, containing things like arbitrator TOS address
1039     function setMetaData(string _metadata) 
1040         onlyOwner
1041     public {
1042         metadata = _metadata;
1043     }
1044 
1045 }