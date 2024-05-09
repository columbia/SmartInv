1 /**
2  * @title ReailtioSafeMath256
3  * @dev Math operations with safety checks that throw on error
4  */
5 library RealitioSafeMath256 {
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title RealitioSafeMath32
36  * @dev Math operations with safety checks that throw on error
37  * @dev Copy of SafeMath but for uint32 instead of uint256
38  * @dev Deleted functions we don't use
39  */
40 library RealitioSafeMath32 {
41   function add(uint32 a, uint32 b) internal pure returns (uint32) {
42     uint32 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract BalanceHolder {
49 
50     mapping(address => uint256) public balanceOf;
51 
52     event LogWithdraw(
53         address indexed user,
54         uint256 amount
55     );
56 
57     function withdraw() 
58     public {
59         uint256 bal = balanceOf[msg.sender];
60         balanceOf[msg.sender] = 0;
61         msg.sender.transfer(bal);
62         emit LogWithdraw(msg.sender, bal);
63     }
64 
65 }
66 
67 
68 contract Owned {
69     address public owner;
70 
71     constructor() 
72     public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address newOwner) 
82         onlyOwner 
83     public {
84         owner = newOwner;
85     }
86 }
87 
88 
89 contract Realitio is BalanceHolder {
90 
91     using RealitioSafeMath256 for uint256;
92     using RealitioSafeMath32 for uint32;
93 
94     address constant NULL_ADDRESS = address(0);
95 
96     // History hash when no history is created, or history has been cleared
97     bytes32 constant NULL_HASH = bytes32(0);
98 
99     // An unitinalized finalize_ts for a question will indicate an unanswered question.
100     uint32 constant UNANSWERED = 0;
101 
102     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
103     uint256 constant COMMITMENT_NON_EXISTENT = 0;
104 
105     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
106     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
107 
108     event LogSetQuestionFee(
109         address arbitrator,
110         uint256 amount
111     );
112 
113     event LogNewTemplate(
114         uint256 indexed template_id,
115         address indexed user, 
116         string question_text
117     );
118 
119     event LogNewQuestion(
120         bytes32 indexed question_id,
121         address indexed user, 
122         uint256 template_id,
123         string question,
124         bytes32 indexed content_hash,
125         address arbitrator, 
126         uint32 timeout,
127         uint32 opening_ts,
128         uint256 nonce,
129         uint256 created
130     );
131 
132     event LogFundAnswerBounty(
133         bytes32 indexed question_id,
134         uint256 bounty_added,
135         uint256 bounty,
136         address indexed user 
137     );
138 
139     event LogNewAnswer(
140         bytes32 answer,
141         bytes32 indexed question_id,
142         bytes32 history_hash,
143         address indexed user,
144         uint256 bond,
145         uint256 ts,
146         bool is_commitment
147     );
148 
149     event LogAnswerReveal(
150         bytes32 indexed question_id, 
151         address indexed user, 
152         bytes32 indexed answer_hash, 
153         bytes32 answer, 
154         uint256 nonce, 
155         uint256 bond
156     );
157 
158     event LogNotifyOfArbitrationRequest(
159         bytes32 indexed question_id,
160         address indexed user 
161     );
162 
163     event LogFinalize(
164         bytes32 indexed question_id,
165         bytes32 indexed answer
166     );
167 
168     event LogClaim(
169         bytes32 indexed question_id,
170         address indexed user,
171         uint256 amount
172     );
173 
174     struct Question {
175         bytes32 content_hash;
176         address arbitrator;
177         uint32 opening_ts;
178         uint32 timeout;
179         uint32 finalize_ts;
180         bool is_pending_arbitration;
181         uint256 bounty;
182         bytes32 best_answer;
183         bytes32 history_hash;
184         uint256 bond;
185     }
186 
187     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
188     struct Commitment {
189         uint32 reveal_ts;
190         bool is_revealed;
191         bytes32 revealed_answer;
192     }
193 
194     // Only used when claiming more bonds than fits into a transaction
195     // Stored in a mapping indexed by question_id.
196     struct Claim {
197         address payee;
198         uint256 last_bond;
199         uint256 queued_funds;
200     }
201 
202     uint256 nextTemplateID = 0;
203     mapping(uint256 => uint256) public templates;
204     mapping(uint256 => bytes32) public template_hashes;
205     mapping(bytes32 => Question) public questions;
206     mapping(bytes32 => Claim) public question_claims;
207     mapping(bytes32 => Commitment) public commitments;
208     mapping(address => uint256) public arbitrator_question_fees; 
209 
210     modifier onlyArbitrator(bytes32 question_id) {
211         require(msg.sender == questions[question_id].arbitrator, "msg.sender must be arbitrator");
212         _;
213     }
214 
215     modifier stateAny() {
216         _;
217     }
218 
219     modifier stateNotCreated(bytes32 question_id) {
220         require(questions[question_id].timeout == 0, "question must not exist");
221         _;
222     }
223 
224     modifier stateOpen(bytes32 question_id) {
225         require(questions[question_id].timeout > 0, "question must exist");
226         require(!questions[question_id].is_pending_arbitration, "question must not be pending arbitration");
227         uint32 finalize_ts = questions[question_id].finalize_ts;
228         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization deadline must not have passed");
229         uint32 opening_ts = questions[question_id].opening_ts;
230         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
231         _;
232     }
233 
234     modifier statePendingArbitration(bytes32 question_id) {
235         require(questions[question_id].is_pending_arbitration, "question must be pending arbitration");
236         _;
237     }
238 
239     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
240         require(questions[question_id].timeout > 0, "question must exist");
241         uint32 finalize_ts = questions[question_id].finalize_ts;
242         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization dealine must not have passed");
243         uint32 opening_ts = questions[question_id].opening_ts;
244         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
245         _;
246     }
247 
248     modifier stateFinalized(bytes32 question_id) {
249         require(isFinalized(question_id), "question must be finalized");
250         _;
251     }
252 
253     modifier bondMustBeZero() {
254         require(msg.value == 0, "bond must be zero");
255         _;
256     }
257 
258     modifier bondMustDouble(bytes32 question_id) {
259         require(msg.value > 0, "bond must be positive"); 
260         require(msg.value >= (questions[question_id].bond.mul(2)), "bond must be double at least previous bond");
261         _;
262     }
263 
264     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
265         if (max_previous > 0) {
266             require(questions[question_id].bond <= max_previous, "bond must exceed max_previous");
267         }
268         _;
269     }
270 
271     /// @notice Constructor, sets up some initial templates
272     /// @dev Creates some generalized templates for different question types used in the DApp.
273     constructor() 
274     public {
275         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
276         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
277         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
278         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
279         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
280     }
281 
282     /// @notice Function for arbitrator to set an optional per-question fee. 
283     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
284     /// @param fee The fee to be charged by the arbitrator when a question is asked
285     function setQuestionFee(uint256 fee) 
286         stateAny() 
287     external {
288         arbitrator_question_fees[msg.sender] = fee;
289         emit LogSetQuestionFee(msg.sender, fee);
290     }
291 
292     /// @notice Create a reusable template, which should be a JSON document.
293     /// Placeholders should use gettext() syntax, eg %s.
294     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
295     /// @param content The template content
296     /// @return The ID of the newly-created template, which is created sequentially.
297     function createTemplate(string content) 
298         stateAny()
299     public returns (uint256) {
300         uint256 id = nextTemplateID;
301         templates[id] = block.number;
302         template_hashes[id] = keccak256(abi.encodePacked(content));
303         emit LogNewTemplate(id, msg.sender, content);
304         nextTemplateID = id.add(1);
305         return id;
306     }
307 
308     /// @notice Create a new reusable template and use it to ask a question
309     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
310     /// @param content The template content
311     /// @param question A string containing the parameters that will be passed into the template to make the question
312     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
313     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
314     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
315     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
316     /// @return The ID of the newly-created template, which is created sequentially.
317     function createTemplateAndAskQuestion(
318         string content, 
319         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
320     ) 
321         // stateNotCreated is enforced by the internal _askQuestion
322     public payable returns (bytes32) {
323         uint256 template_id = createTemplate(content);
324         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
325     }
326 
327     /// @notice Ask a new question and return the ID
328     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
329     /// @param template_id The ID number of the template the question will use
330     /// @param question A string containing the parameters that will be passed into the template to make the question
331     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
332     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
333     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
334     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
335     /// @return The ID of the newly-created question, created deterministically.
336     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
337         // stateNotCreated is enforced by the internal _askQuestion
338     public payable returns (bytes32) {
339 
340         require(templates[template_id] > 0, "template must exist");
341 
342         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
343         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
344 
345         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
346         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
347 
348         return question_id;
349     }
350 
351     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
352         stateNotCreated(question_id)
353     internal {
354 
355         // A timeout of 0 makes no sense, and we will use this to check existence
356         require(timeout > 0, "timeout must be positive"); 
357         require(timeout < 365 days, "timeout must be less than 365 days"); 
358         require(arbitrator != NULL_ADDRESS, "arbitrator must be set");
359 
360         uint256 bounty = msg.value;
361 
362         // The arbitrator can set a fee for asking a question. 
363         // This is intended as an anti-spam defence.
364         // The fee is waived if the arbitrator is asking the question.
365         // This allows them to set an impossibly high fee and make users proxy the question through them.
366         // This would allow more sophisticated pricing, question whitelisting etc.
367         if (msg.sender != arbitrator) {
368             uint256 question_fee = arbitrator_question_fees[arbitrator];
369             require(bounty >= question_fee, "ETH provided must cover question fee"); 
370             bounty = bounty.sub(question_fee);
371             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
372         }
373 
374         questions[question_id].content_hash = content_hash;
375         questions[question_id].arbitrator = arbitrator;
376         questions[question_id].opening_ts = opening_ts;
377         questions[question_id].timeout = timeout;
378         questions[question_id].bounty = bounty;
379 
380     }
381 
382     /// @notice Add funds to the bounty for a question
383     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
384     /// @param question_id The ID of the question you wish to fund
385     function fundAnswerBounty(bytes32 question_id) 
386         stateOpen(question_id)
387     external payable {
388         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
389         emit LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
390     }
391 
392     /// @notice Submit an answer for a question.
393     /// @dev Adds the answer to the history and updates the current "best" answer.
394     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
395     /// @param question_id The ID of the question
396     /// @param answer The answer, encoded into bytes32
397     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
398     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
399         stateOpen(question_id)
400         bondMustDouble(question_id)
401         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
402     external payable {
403         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
404         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
405     }
406 
407     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
408     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
409     /// The commitment_id is stored in the answer history where the answer would normally go.
410     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
411     /// @param question_id The ID of the question
412     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
413     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
414     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
415     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
416     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
417         stateOpen(question_id)
418         bondMustDouble(question_id)
419         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
420     external payable {
421 
422         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, msg.value));
423         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
424 
425         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
426 
427         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
428         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
429 
430         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
431 
432     }
433 
434     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
435     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
436     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
437     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
438     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
439     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
440     /// @param question_id The ID of the question
441     /// @param answer The answer, encoded as bytes32
442     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
443     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
444     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
445         stateOpenOrPendingArbitration(question_id)
446     external {
447 
448         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
449         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
450 
451         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
452         require(commitments[commitment_id].reveal_ts > uint32(now), "reveal deadline must not have passed");
453 
454         commitments[commitment_id].revealed_answer = answer;
455         commitments[commitment_id].is_revealed = true;
456 
457         if (bond == questions[question_id].bond) {
458             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
459         }
460 
461         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
462 
463     }
464 
465     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
466     internal 
467     {
468         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
469 
470         // Update the current bond level, if there's a bond (ie anything except arbitration)
471         if (bond > 0) {
472             questions[question_id].bond = bond;
473         }
474         questions[question_id].history_hash = new_history_hash;
475 
476         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
477     }
478 
479     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
480     internal {
481         questions[question_id].best_answer = answer;
482         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
483     }
484 
485     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
486     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
487     /// @param question_id The ID of the question
488     /// @param requester The account that requested arbitration
489     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
490     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
491         onlyArbitrator(question_id)
492         stateOpen(question_id)
493         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
494     external {
495         require(questions[question_id].bond > 0, "Question must already have an answer when arbitration is requested");
496         questions[question_id].is_pending_arbitration = true;
497         emit LogNotifyOfArbitrationRequest(question_id, requester);
498     }
499 
500     /// @notice Submit the answer for a question, for use by the arbitrator.
501     /// @dev Doesn't require (or allow) a bond.
502     /// If the current final answer is correct, the account should be whoever submitted it.
503     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
504     /// However, the answerer stipulations are not enforced by the contract.
505     /// @param question_id The ID of the question
506     /// @param answer The answer, encoded into bytes32
507     /// @param answerer The account credited with this answer for the purpose of bond claims
508     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
509         onlyArbitrator(question_id)
510         statePendingArbitration(question_id)
511         bondMustBeZero
512     external {
513 
514         require(answerer != NULL_ADDRESS, "answerer must be provided");
515         emit LogFinalize(question_id, answer);
516 
517         questions[question_id].is_pending_arbitration = false;
518         _addAnswerToHistory(question_id, answer, answerer, 0, false);
519         _updateCurrentAnswer(question_id, answer, 0);
520 
521     }
522 
523     /// @notice Report whether the answer to the specified question is finalized
524     /// @param question_id The ID of the question
525     /// @return Return true if finalized
526     function isFinalized(bytes32 question_id) 
527     view public returns (bool) {
528         uint32 finalize_ts = questions[question_id].finalize_ts;
529         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
530     }
531 
532     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
533     /// @param question_id The ID of the question
534     /// @return The answer formatted as a bytes32
535     function getFinalAnswer(bytes32 question_id) 
536         stateFinalized(question_id)
537     external view returns (bytes32) {
538         return questions[question_id].best_answer;
539     }
540 
541     /// @notice Return the final answer to the specified question, or revert if there isn't one
542     /// @param question_id The ID of the question
543     /// @return The answer formatted as a bytes32
544     function resultFor(bytes32 question_id) 
545         stateFinalized(question_id)
546     external view returns (bytes32) {
547         return questions[question_id].best_answer;
548     }
549 
550 
551     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
552     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
553     /// @param question_id The ID of the question
554     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
555     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
556     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
557     /// @param min_bond The bond sent with the final answer must be this high or higher
558     /// @return The answer formatted as a bytes32
559     function getFinalAnswerIfMatches(
560         bytes32 question_id, 
561         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
562     ) 
563         stateFinalized(question_id)
564     external view returns (bytes32) {
565         require(content_hash == questions[question_id].content_hash, "content hash must match");
566         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
567         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
568         require(min_bond <= questions[question_id].bond, "bond must be high enough");
569         return questions[question_id].best_answer;
570     }
571 
572     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
573     /// Caller must provide the answer history, in reverse order
574     /// @dev Works up the chain and assign bonds to the person who gave the right answer
575     /// If someone gave the winning answer earlier, they must get paid from the higher bond
576     /// That means we can't pay out the bond added at n until we have looked at n-1
577     /// The first answer is authenticated by checking against the stored history_hash.
578     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
579     /// Once we get to a null hash we'll know we're done and there are no more answers.
580     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
581     /// @param question_id The ID of the question
582     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
583     /// @param addrs Last-to-first, the address of each answerer or commitment sender
584     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
585     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
586     function claimWinnings(
587         bytes32 question_id, 
588         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
589     ) 
590         stateFinalized(question_id)
591     public {
592 
593         require(history_hashes.length > 0, "at least one history hash entry must be provided");
594 
595         // These are only set if we split our claim over multiple transactions.
596         address payee = question_claims[question_id].payee; 
597         uint256 last_bond = question_claims[question_id].last_bond; 
598         uint256 queued_funds = question_claims[question_id].queued_funds; 
599 
600         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
601         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
602         bytes32 last_history_hash = questions[question_id].history_hash;
603 
604         bytes32 best_answer = questions[question_id].best_answer;
605 
606         uint256 i;
607         for (i = 0; i < history_hashes.length; i++) {
608         
609             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
610             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
611             
612             queued_funds = queued_funds.add(last_bond); 
613             (queued_funds, payee) = _processHistoryItem(
614                 question_id, best_answer, queued_funds, payee, 
615                 addrs[i], bonds[i], answers[i], is_commitment);
616  
617             // Line the bond up for next time, when it will be added to somebody's queued_funds
618             last_bond = bonds[i];
619             last_history_hash = history_hashes[i];
620 
621         }
622  
623         if (last_history_hash != NULL_HASH) {
624             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
625             // Persist the details so we can pick up later where we left off later.
626 
627             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
628             // (We always know who to pay unless all we saw were unrevealed commits)
629             if (payee != NULL_ADDRESS) {
630                 _payPayee(question_id, payee, queued_funds);
631                 queued_funds = 0;
632             }
633 
634             question_claims[question_id].payee = payee;
635             question_claims[question_id].last_bond = last_bond;
636             question_claims[question_id].queued_funds = queued_funds;
637         } else {
638             // There is nothing left below us so the payee can keep what remains
639             _payPayee(question_id, payee, queued_funds.add(last_bond));
640             delete question_claims[question_id];
641         }
642 
643         questions[question_id].history_hash = last_history_hash;
644 
645     }
646 
647     function _payPayee(bytes32 question_id, address payee, uint256 value) 
648     internal {
649         balanceOf[payee] = balanceOf[payee].add(value);
650         emit LogClaim(question_id, payee, value);
651     }
652 
653     function _verifyHistoryInputOrRevert(
654         bytes32 last_history_hash,
655         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
656     )
657     internal pure returns (bool) {
658         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
659             return true;
660         }
661         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
662             return false;
663         } 
664         revert("History input provided did not match the expected hash");
665     }
666 
667     function _processHistoryItem(
668         bytes32 question_id, bytes32 best_answer, 
669         uint256 queued_funds, address payee, 
670         address addr, uint256 bond, bytes32 answer, bool is_commitment
671     )
672     internal returns (uint256, address) {
673 
674         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
675         // We look at the referenced commitment ID and switch in the actual answer.
676         if (is_commitment) {
677             bytes32 commitment_id = answer;
678             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
679             if (!commitments[commitment_id].is_revealed) {
680                 delete commitments[commitment_id];
681                 return (queued_funds, payee);
682             } else {
683                 answer = commitments[commitment_id].revealed_answer;
684                 delete commitments[commitment_id];
685             }
686         }
687 
688         if (answer == best_answer) {
689 
690             if (payee == NULL_ADDRESS) {
691 
692                 // The entry is for the first payee we come to, ie the winner.
693                 // They get the question bounty.
694                 payee = addr;
695                 queued_funds = queued_funds.add(questions[question_id].bounty);
696                 questions[question_id].bounty = 0;
697 
698             } else if (addr != payee) {
699 
700                 // Answerer has changed, ie we found someone lower down who needs to be paid
701 
702                 // The lower answerer will take over receiving bonds from higher answerer.
703                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
704                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
705 
706                 // There should be enough for the fee, but if not, take what we have.
707                 // There's an edge case involving weird arbitrator behaviour where we may be short.
708                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
709 
710                 // Settle up with the old (higher-bonded) payee
711                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
712 
713                 // Now start queued_funds again for the new (lower-bonded) payee
714                 payee = addr;
715                 queued_funds = answer_takeover_fee;
716 
717             }
718 
719         }
720 
721         return (queued_funds, payee);
722 
723     }
724 
725     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
726     /// Caller must provide the answer history for each question, in reverse order
727     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
728     /// @param question_ids The IDs of the questions you want to claim for
729     /// @param lengths The number of history entries you will supply for each question ID
730     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
731     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
732     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
733     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
734     function claimMultipleAndWithdrawBalance(
735         bytes32[] question_ids, uint256[] lengths, 
736         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
737     ) 
738         stateAny() // The finalization checks are done in the claimWinnings function
739     public {
740         
741         uint256 qi;
742         uint256 i;
743         for (qi = 0; qi < question_ids.length; qi++) {
744             bytes32 qid = question_ids[qi];
745             uint256 ln = lengths[qi];
746             bytes32[] memory hh = new bytes32[](ln);
747             address[] memory ad = new address[](ln);
748             uint256[] memory bo = new uint256[](ln);
749             bytes32[] memory an = new bytes32[](ln);
750             uint256 j;
751             for (j = 0; j < ln; j++) {
752                 hh[j] = hist_hashes[i];
753                 ad[j] = addrs[i];
754                 bo[j] = bonds[i];
755                 an[j] = answers[i];
756                 i++;
757             }
758             claimWinnings(qid, hh, ad, bo, an);
759         }
760         withdraw();
761     }
762 
763     /// @notice Returns the questions's content hash, identifying the question content
764     /// @param question_id The ID of the question 
765     function getContentHash(bytes32 question_id) 
766     public view returns(bytes32) {
767         return questions[question_id].content_hash;
768     }
769 
770     /// @notice Returns the arbitrator address for the question
771     /// @param question_id The ID of the question 
772     function getArbitrator(bytes32 question_id) 
773     public view returns(address) {
774         return questions[question_id].arbitrator;
775     }
776 
777     /// @notice Returns the timestamp when the question can first be answered
778     /// @param question_id The ID of the question 
779     function getOpeningTS(bytes32 question_id) 
780     public view returns(uint32) {
781         return questions[question_id].opening_ts;
782     }
783 
784     /// @notice Returns the timeout in seconds used after each answer
785     /// @param question_id The ID of the question 
786     function getTimeout(bytes32 question_id) 
787     public view returns(uint32) {
788         return questions[question_id].timeout;
789     }
790 
791     /// @notice Returns the timestamp at which the question will be/was finalized
792     /// @param question_id The ID of the question 
793     function getFinalizeTS(bytes32 question_id) 
794     public view returns(uint32) {
795         return questions[question_id].finalize_ts;
796     }
797 
798     /// @notice Returns whether the question is pending arbitration
799     /// @param question_id The ID of the question 
800     function isPendingArbitration(bytes32 question_id) 
801     public view returns(bool) {
802         return questions[question_id].is_pending_arbitration;
803     }
804 
805     /// @notice Returns the current total unclaimed bounty
806     /// @dev Set back to zero once the bounty has been claimed
807     /// @param question_id The ID of the question 
808     function getBounty(bytes32 question_id) 
809     public view returns(uint256) {
810         return questions[question_id].bounty;
811     }
812 
813     /// @notice Returns the current best answer
814     /// @param question_id The ID of the question 
815     function getBestAnswer(bytes32 question_id) 
816     public view returns(bytes32) {
817         return questions[question_id].best_answer;
818     }
819 
820     /// @notice Returns the history hash of the question 
821     /// @param question_id The ID of the question 
822     /// @dev Updated on each answer, then rewound as each is claimed
823     function getHistoryHash(bytes32 question_id) 
824     public view returns(bytes32) {
825         return questions[question_id].history_hash;
826     }
827 
828     /// @notice Returns the highest bond posted so far for a question
829     /// @param question_id The ID of the question 
830     function getBond(bytes32 question_id) 
831     public view returns(uint256) {
832         return questions[question_id].bond;
833     }
834 
835 }
836 
837 contract Arbitrator is Owned {
838 
839     Realitio public realitio;
840 
841     mapping(bytes32 => uint256) public arbitration_bounties;
842 
843     uint256 dispute_fee;
844     mapping(bytes32 => uint256) custom_dispute_fees;
845 
846     string public metadata;
847 
848     event LogRequestArbitration(
849         bytes32 indexed question_id,
850         uint256 fee_paid,
851         address requester,
852         uint256 remaining
853     );
854 
855     event LogSetRealitio(
856         address realitio
857     );
858 
859     event LogSetQuestionFee(
860         uint256 fee
861     );
862 
863 
864     event LogSetDisputeFee(
865         uint256 fee
866     );
867 
868     event LogSetCustomDisputeFee(
869         bytes32 indexed question_id,
870         uint256 fee
871     );
872 
873     /// @notice Constructor. Sets the deploying address as owner.
874     constructor() 
875     public {
876         owner = msg.sender;
877     }
878 
879     /// @notice Returns the Realitio contract address - deprecated in favour of realitio()
880     function realitycheck() 
881     external view returns(Realitio) {
882         return realitio;
883     }
884 
885     /// @notice Set the Reality Check contract address
886     /// @param addr The address of the Reality Check contract
887     function setRealitio(address addr) 
888         onlyOwner 
889     public {
890         realitio = Realitio(addr);
891         emit LogSetRealitio(addr);
892     }
893 
894     /// @notice Set the default fee
895     /// @param fee The default fee amount
896     function setDisputeFee(uint256 fee) 
897         onlyOwner 
898     public {
899         dispute_fee = fee;
900         emit LogSetDisputeFee(fee);
901     }
902 
903     /// @notice Set a custom fee for this particular question
904     /// @param question_id The question in question
905     /// @param fee The fee amount
906     function setCustomDisputeFee(bytes32 question_id, uint256 fee) 
907         onlyOwner 
908     public {
909         custom_dispute_fees[question_id] = fee;
910         emit LogSetCustomDisputeFee(question_id, fee);
911     }
912 
913     /// @notice Return the dispute fee for the specified question. 0 indicates that we won't arbitrate it.
914     /// @param question_id The question in question
915     /// @dev Uses a general default, but can be over-ridden on a question-by-question basis.
916     function getDisputeFee(bytes32 question_id) 
917     public view returns (uint256) {
918         return (custom_dispute_fees[question_id] > 0) ? custom_dispute_fees[question_id] : dispute_fee;
919     }
920 
921     /// @notice Set a fee for asking a question with us as the arbitrator
922     /// @param fee The fee amount
923     /// @dev Default is no fee. Unlike the dispute fee, 0 is an acceptable setting.
924     /// You could set an impossibly high fee if you want to prevent us being used as arbitrator unless we submit the question.
925     /// (Submitting the question ourselves is not implemented here.)
926     /// This fee can be used as a revenue source, an anti-spam measure, or both.
927     function setQuestionFee(uint256 fee) 
928         onlyOwner 
929     public {
930         realitio.setQuestionFee(fee);
931         emit LogSetQuestionFee(fee);
932     }
933 
934     /// @notice Submit the arbitrator's answer to a question.
935     /// @param question_id The question in question
936     /// @param answer The answer
937     /// @param answerer The answerer. If arbitration changed the answer, it should be the payer. If not, the old answerer.
938     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
939         onlyOwner 
940     public {
941         delete arbitration_bounties[question_id];
942         realitio.submitAnswerByArbitrator(question_id, answer, answerer);
943     }
944 
945     /// @notice Request arbitration, freezing the question until we send submitAnswerByArbitrator
946     /// @dev The bounty can be paid only in part, in which case the last person to pay will be considered the payer
947     /// Will trigger an error if the notification fails, eg because the question has already been finalized
948     /// @param question_id The question in question
949     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
950     function requestArbitration(bytes32 question_id, uint256 max_previous) 
951     external payable returns (bool) {
952 
953         uint256 arbitration_fee = getDisputeFee(question_id);
954         require(arbitration_fee > 0, "The arbitrator must have set a non-zero fee for the question");
955 
956         arbitration_bounties[question_id] += msg.value;
957         uint256 paid = arbitration_bounties[question_id];
958 
959         if (paid >= arbitration_fee) {
960             realitio.notifyOfArbitrationRequest(question_id, msg.sender, max_previous);
961             emit LogRequestArbitration(question_id, msg.value, msg.sender, 0);
962             return true;
963         } else {
964             require(!realitio.isFinalized(question_id), "The question must not have been finalized");
965             emit LogRequestArbitration(question_id, msg.value, msg.sender, arbitration_fee - paid);
966             return false;
967         }
968 
969     }
970 
971     /// @notice Withdraw any accumulated fees to the specified address
972     /// @param addr The address to which the balance should be sent
973     function withdraw(address addr) 
974         onlyOwner 
975     public {
976         addr.transfer(address(this).balance); 
977     }
978 
979     function() 
980     external payable {
981     }
982 
983     /// @notice Withdraw any accumulated question fees from the specified address into this contract
984     /// @dev Funds can then be liberated from this contract with our withdraw() function
985     function callWithdraw() 
986         onlyOwner 
987     public {
988         realitio.withdraw(); 
989     }
990 
991     /// @notice Set a metadata string, expected to be JSON, containing things like arbitrator TOS address
992     function setMetaData(string _metadata) 
993         onlyOwner
994     public {
995         metadata = _metadata;
996     }
997 
998 }