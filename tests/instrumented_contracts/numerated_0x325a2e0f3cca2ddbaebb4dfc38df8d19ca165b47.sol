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
68 contract Realitio is BalanceHolder {
69 
70     using RealitioSafeMath256 for uint256;
71     using RealitioSafeMath32 for uint32;
72 
73     address constant NULL_ADDRESS = address(0);
74 
75     // History hash when no history is created, or history has been cleared
76     bytes32 constant NULL_HASH = bytes32(0);
77 
78     // An unitinalized finalize_ts for a question will indicate an unanswered question.
79     uint32 constant UNANSWERED = 0;
80 
81     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
82     uint256 constant COMMITMENT_NON_EXISTENT = 0;
83 
84     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
85     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
86 
87     event LogSetQuestionFee(
88         address arbitrator,
89         uint256 amount
90     );
91 
92     event LogNewTemplate(
93         uint256 indexed template_id,
94         address indexed user, 
95         string question_text
96     );
97 
98     event LogNewQuestion(
99         bytes32 indexed question_id,
100         address indexed user, 
101         uint256 template_id,
102         string question,
103         bytes32 indexed content_hash,
104         address arbitrator, 
105         uint32 timeout,
106         uint32 opening_ts,
107         uint256 nonce,
108         uint256 created
109     );
110 
111     event LogFundAnswerBounty(
112         bytes32 indexed question_id,
113         uint256 bounty_added,
114         uint256 bounty,
115         address indexed user 
116     );
117 
118     event LogNewAnswer(
119         bytes32 answer,
120         bytes32 indexed question_id,
121         bytes32 history_hash,
122         address indexed user,
123         uint256 bond,
124         uint256 ts,
125         bool is_commitment
126     );
127 
128     event LogAnswerReveal(
129         bytes32 indexed question_id, 
130         address indexed user, 
131         bytes32 indexed answer_hash, 
132         bytes32 answer, 
133         uint256 nonce, 
134         uint256 bond
135     );
136 
137     event LogNotifyOfArbitrationRequest(
138         bytes32 indexed question_id,
139         address indexed user 
140     );
141 
142     event LogFinalize(
143         bytes32 indexed question_id,
144         bytes32 indexed answer
145     );
146 
147     event LogClaim(
148         bytes32 indexed question_id,
149         address indexed user,
150         uint256 amount
151     );
152 
153     struct Question {
154         bytes32 content_hash;
155         address arbitrator;
156         uint32 opening_ts;
157         uint32 timeout;
158         uint32 finalize_ts;
159         bool is_pending_arbitration;
160         uint256 bounty;
161         bytes32 best_answer;
162         bytes32 history_hash;
163         uint256 bond;
164     }
165 
166     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
167     struct Commitment {
168         uint32 reveal_ts;
169         bool is_revealed;
170         bytes32 revealed_answer;
171     }
172 
173     // Only used when claiming more bonds than fits into a transaction
174     // Stored in a mapping indexed by question_id.
175     struct Claim {
176         address payee;
177         uint256 last_bond;
178         uint256 queued_funds;
179     }
180 
181     uint256 nextTemplateID = 0;
182     mapping(uint256 => uint256) public templates;
183     mapping(uint256 => bytes32) public template_hashes;
184     mapping(bytes32 => Question) public questions;
185     mapping(bytes32 => Claim) public question_claims;
186     mapping(bytes32 => Commitment) public commitments;
187     mapping(address => uint256) public arbitrator_question_fees; 
188 
189     modifier onlyArbitrator(bytes32 question_id) {
190         require(msg.sender == questions[question_id].arbitrator, "msg.sender must be arbitrator");
191         _;
192     }
193 
194     modifier stateAny() {
195         _;
196     }
197 
198     modifier stateNotCreated(bytes32 question_id) {
199         require(questions[question_id].timeout == 0, "question must not exist");
200         _;
201     }
202 
203     modifier stateOpen(bytes32 question_id) {
204         require(questions[question_id].timeout > 0, "question must exist");
205         require(!questions[question_id].is_pending_arbitration, "question must not be pending arbitration");
206         uint32 finalize_ts = questions[question_id].finalize_ts;
207         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization deadline must not have passed");
208         uint32 opening_ts = questions[question_id].opening_ts;
209         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
210         _;
211     }
212 
213     modifier statePendingArbitration(bytes32 question_id) {
214         require(questions[question_id].is_pending_arbitration, "question must be pending arbitration");
215         _;
216     }
217 
218     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
219         require(questions[question_id].timeout > 0, "question must exist");
220         uint32 finalize_ts = questions[question_id].finalize_ts;
221         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization dealine must not have passed");
222         uint32 opening_ts = questions[question_id].opening_ts;
223         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
224         _;
225     }
226 
227     modifier stateFinalized(bytes32 question_id) {
228         require(isFinalized(question_id), "question must be finalized");
229         _;
230     }
231 
232     modifier bondMustBeZero() {
233         require(msg.value == 0, "bond must be zero");
234         _;
235     }
236 
237     modifier bondMustDouble(bytes32 question_id) {
238         require(msg.value > 0, "bond must be positive"); 
239         require(msg.value >= (questions[question_id].bond.mul(2)), "bond must be double at least previous bond");
240         _;
241     }
242 
243     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
244         if (max_previous > 0) {
245             require(questions[question_id].bond <= max_previous, "bond must exceed max_previous");
246         }
247         _;
248     }
249 
250     /// @notice Constructor, sets up some initial templates
251     /// @dev Creates some generalized templates for different question types used in the DApp.
252     constructor() 
253     public {
254         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
255         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
256         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
257         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
258         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
259     }
260 
261     /// @notice Function for arbitrator to set an optional per-question fee. 
262     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
263     /// @param fee The fee to be charged by the arbitrator when a question is asked
264     function setQuestionFee(uint256 fee) 
265         stateAny() 
266     external {
267         arbitrator_question_fees[msg.sender] = fee;
268         emit LogSetQuestionFee(msg.sender, fee);
269     }
270 
271     /// @notice Create a reusable template, which should be a JSON document.
272     /// Placeholders should use gettext() syntax, eg %s.
273     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
274     /// @param content The template content
275     /// @return The ID of the newly-created template, which is created sequentially.
276     function createTemplate(string content) 
277         stateAny()
278     public returns (uint256) {
279         uint256 id = nextTemplateID;
280         templates[id] = block.number;
281         template_hashes[id] = keccak256(abi.encodePacked(content));
282         emit LogNewTemplate(id, msg.sender, content);
283         nextTemplateID = id.add(1);
284         return id;
285     }
286 
287     /// @notice Create a new reusable template and use it to ask a question
288     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
289     /// @param content The template content
290     /// @param question A string containing the parameters that will be passed into the template to make the question
291     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
292     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
293     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
294     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
295     /// @return The ID of the newly-created template, which is created sequentially.
296     function createTemplateAndAskQuestion(
297         string content, 
298         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
299     ) 
300         // stateNotCreated is enforced by the internal _askQuestion
301     public payable returns (bytes32) {
302         uint256 template_id = createTemplate(content);
303         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
304     }
305 
306     /// @notice Ask a new question and return the ID
307     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
308     /// @param template_id The ID number of the template the question will use
309     /// @param question A string containing the parameters that will be passed into the template to make the question
310     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
311     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
312     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
313     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
314     /// @return The ID of the newly-created question, created deterministically.
315     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
316         // stateNotCreated is enforced by the internal _askQuestion
317     public payable returns (bytes32) {
318 
319         require(templates[template_id] > 0, "template must exist");
320 
321         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
322         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
323 
324         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
325         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
326 
327         return question_id;
328     }
329 
330     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
331         stateNotCreated(question_id)
332     internal {
333 
334         // A timeout of 0 makes no sense, and we will use this to check existence
335         require(timeout > 0, "timeout must be positive"); 
336         require(timeout < 365 days, "timeout must be less than 365 days"); 
337         require(arbitrator != NULL_ADDRESS, "arbitrator must be set");
338 
339         uint256 bounty = msg.value;
340 
341         // The arbitrator can set a fee for asking a question. 
342         // This is intended as an anti-spam defence.
343         // The fee is waived if the arbitrator is asking the question.
344         // This allows them to set an impossibly high fee and make users proxy the question through them.
345         // This would allow more sophisticated pricing, question whitelisting etc.
346         if (msg.sender != arbitrator) {
347             uint256 question_fee = arbitrator_question_fees[arbitrator];
348             require(bounty >= question_fee, "ETH provided must cover question fee"); 
349             bounty = bounty.sub(question_fee);
350             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
351         }
352 
353         questions[question_id].content_hash = content_hash;
354         questions[question_id].arbitrator = arbitrator;
355         questions[question_id].opening_ts = opening_ts;
356         questions[question_id].timeout = timeout;
357         questions[question_id].bounty = bounty;
358 
359     }
360 
361     /// @notice Add funds to the bounty for a question
362     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
363     /// @param question_id The ID of the question you wish to fund
364     function fundAnswerBounty(bytes32 question_id) 
365         stateOpen(question_id)
366     external payable {
367         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
368         emit LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
369     }
370 
371     /// @notice Submit an answer for a question.
372     /// @dev Adds the answer to the history and updates the current "best" answer.
373     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
374     /// @param question_id The ID of the question
375     /// @param answer The answer, encoded into bytes32
376     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
377     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
378         stateOpen(question_id)
379         bondMustDouble(question_id)
380         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
381     external payable {
382         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
383         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
384     }
385 
386     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
387     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
388     /// The commitment_id is stored in the answer history where the answer would normally go.
389     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
390     /// @param question_id The ID of the question
391     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
392     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
393     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
394     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
395     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
396         stateOpen(question_id)
397         bondMustDouble(question_id)
398         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
399     external payable {
400 
401         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, msg.value));
402         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
403 
404         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
405 
406         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
407         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
408 
409         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
410 
411     }
412 
413     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
414     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
415     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
416     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
417     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
418     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
419     /// @param question_id The ID of the question
420     /// @param answer The answer, encoded as bytes32
421     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
422     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
423     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
424         stateOpenOrPendingArbitration(question_id)
425     external {
426 
427         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
428         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
429 
430         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
431         require(commitments[commitment_id].reveal_ts > uint32(now), "reveal deadline must not have passed");
432 
433         commitments[commitment_id].revealed_answer = answer;
434         commitments[commitment_id].is_revealed = true;
435 
436         if (bond == questions[question_id].bond) {
437             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
438         }
439 
440         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
441 
442     }
443 
444     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
445     internal 
446     {
447         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
448 
449         // Update the current bond level, if there's a bond (ie anything except arbitration)
450         if (bond > 0) {
451             questions[question_id].bond = bond;
452         }
453         questions[question_id].history_hash = new_history_hash;
454 
455         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
456     }
457 
458     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
459     internal {
460         questions[question_id].best_answer = answer;
461         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
462     }
463 
464     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
465     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
466     /// @param question_id The ID of the question
467     /// @param requester The account that requested arbitration
468     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
469     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
470         onlyArbitrator(question_id)
471         stateOpen(question_id)
472         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
473     external {
474         require(questions[question_id].bond > 0, "Question must already have an answer when arbitration is requested");
475         questions[question_id].is_pending_arbitration = true;
476         emit LogNotifyOfArbitrationRequest(question_id, requester);
477     }
478 
479     /// @notice Submit the answer for a question, for use by the arbitrator.
480     /// @dev Doesn't require (or allow) a bond.
481     /// If the current final answer is correct, the account should be whoever submitted it.
482     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
483     /// However, the answerer stipulations are not enforced by the contract.
484     /// @param question_id The ID of the question
485     /// @param answer The answer, encoded into bytes32
486     /// @param answerer The account credited with this answer for the purpose of bond claims
487     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
488         onlyArbitrator(question_id)
489         statePendingArbitration(question_id)
490         bondMustBeZero
491     external {
492 
493         require(answerer != NULL_ADDRESS, "answerer must be provided");
494         emit LogFinalize(question_id, answer);
495 
496         questions[question_id].is_pending_arbitration = false;
497         _addAnswerToHistory(question_id, answer, answerer, 0, false);
498         _updateCurrentAnswer(question_id, answer, 0);
499 
500     }
501 
502     /// @notice Report whether the answer to the specified question is finalized
503     /// @param question_id The ID of the question
504     /// @return Return true if finalized
505     function isFinalized(bytes32 question_id) 
506     view public returns (bool) {
507         uint32 finalize_ts = questions[question_id].finalize_ts;
508         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
509     }
510 
511     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
512     /// @param question_id The ID of the question
513     /// @return The answer formatted as a bytes32
514     function getFinalAnswer(bytes32 question_id) 
515         stateFinalized(question_id)
516     external view returns (bytes32) {
517         return questions[question_id].best_answer;
518     }
519 
520     /// @notice Return the final answer to the specified question, or revert if there isn't one
521     /// @param question_id The ID of the question
522     /// @return The answer formatted as a bytes32
523     function resultFor(bytes32 question_id) 
524         stateFinalized(question_id)
525     external view returns (bytes32) {
526         return questions[question_id].best_answer;
527     }
528 
529 
530     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
531     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
532     /// @param question_id The ID of the question
533     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
534     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
535     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
536     /// @param min_bond The bond sent with the final answer must be this high or higher
537     /// @return The answer formatted as a bytes32
538     function getFinalAnswerIfMatches(
539         bytes32 question_id, 
540         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
541     ) 
542         stateFinalized(question_id)
543     external view returns (bytes32) {
544         require(content_hash == questions[question_id].content_hash, "content hash must match");
545         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
546         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
547         require(min_bond <= questions[question_id].bond, "bond must be high enough");
548         return questions[question_id].best_answer;
549     }
550 
551     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
552     /// Caller must provide the answer history, in reverse order
553     /// @dev Works up the chain and assign bonds to the person who gave the right answer
554     /// If someone gave the winning answer earlier, they must get paid from the higher bond
555     /// That means we can't pay out the bond added at n until we have looked at n-1
556     /// The first answer is authenticated by checking against the stored history_hash.
557     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
558     /// Once we get to a null hash we'll know we're done and there are no more answers.
559     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
560     /// @param question_id The ID of the question
561     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
562     /// @param addrs Last-to-first, the address of each answerer or commitment sender
563     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
564     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
565     function claimWinnings(
566         bytes32 question_id, 
567         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
568     ) 
569         stateFinalized(question_id)
570     public {
571 
572         require(history_hashes.length > 0, "at least one history hash entry must be provided");
573 
574         // These are only set if we split our claim over multiple transactions.
575         address payee = question_claims[question_id].payee; 
576         uint256 last_bond = question_claims[question_id].last_bond; 
577         uint256 queued_funds = question_claims[question_id].queued_funds; 
578 
579         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
580         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
581         bytes32 last_history_hash = questions[question_id].history_hash;
582 
583         bytes32 best_answer = questions[question_id].best_answer;
584 
585         uint256 i;
586         for (i = 0; i < history_hashes.length; i++) {
587         
588             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
589             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
590             
591             queued_funds = queued_funds.add(last_bond); 
592             (queued_funds, payee) = _processHistoryItem(
593                 question_id, best_answer, queued_funds, payee, 
594                 addrs[i], bonds[i], answers[i], is_commitment);
595  
596             // Line the bond up for next time, when it will be added to somebody's queued_funds
597             last_bond = bonds[i];
598             last_history_hash = history_hashes[i];
599 
600         }
601  
602         if (last_history_hash != NULL_HASH) {
603             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
604             // Persist the details so we can pick up later where we left off later.
605 
606             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
607             // (We always know who to pay unless all we saw were unrevealed commits)
608             if (payee != NULL_ADDRESS) {
609                 _payPayee(question_id, payee, queued_funds);
610                 queued_funds = 0;
611             }
612 
613             question_claims[question_id].payee = payee;
614             question_claims[question_id].last_bond = last_bond;
615             question_claims[question_id].queued_funds = queued_funds;
616         } else {
617             // There is nothing left below us so the payee can keep what remains
618             _payPayee(question_id, payee, queued_funds.add(last_bond));
619             delete question_claims[question_id];
620         }
621 
622         questions[question_id].history_hash = last_history_hash;
623 
624     }
625 
626     function _payPayee(bytes32 question_id, address payee, uint256 value) 
627     internal {
628         balanceOf[payee] = balanceOf[payee].add(value);
629         emit LogClaim(question_id, payee, value);
630     }
631 
632     function _verifyHistoryInputOrRevert(
633         bytes32 last_history_hash,
634         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
635     )
636     internal pure returns (bool) {
637         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
638             return true;
639         }
640         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
641             return false;
642         } 
643         revert("History input provided did not match the expected hash");
644     }
645 
646     function _processHistoryItem(
647         bytes32 question_id, bytes32 best_answer, 
648         uint256 queued_funds, address payee, 
649         address addr, uint256 bond, bytes32 answer, bool is_commitment
650     )
651     internal returns (uint256, address) {
652 
653         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
654         // We look at the referenced commitment ID and switch in the actual answer.
655         if (is_commitment) {
656             bytes32 commitment_id = answer;
657             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
658             if (!commitments[commitment_id].is_revealed) {
659                 delete commitments[commitment_id];
660                 return (queued_funds, payee);
661             } else {
662                 answer = commitments[commitment_id].revealed_answer;
663                 delete commitments[commitment_id];
664             }
665         }
666 
667         if (answer == best_answer) {
668 
669             if (payee == NULL_ADDRESS) {
670 
671                 // The entry is for the first payee we come to, ie the winner.
672                 // They get the question bounty.
673                 payee = addr;
674                 queued_funds = queued_funds.add(questions[question_id].bounty);
675                 questions[question_id].bounty = 0;
676 
677             } else if (addr != payee) {
678 
679                 // Answerer has changed, ie we found someone lower down who needs to be paid
680 
681                 // The lower answerer will take over receiving bonds from higher answerer.
682                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
683                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
684 
685                 // There should be enough for the fee, but if not, take what we have.
686                 // There's an edge case involving weird arbitrator behaviour where we may be short.
687                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
688 
689                 // Settle up with the old (higher-bonded) payee
690                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
691 
692                 // Now start queued_funds again for the new (lower-bonded) payee
693                 payee = addr;
694                 queued_funds = answer_takeover_fee;
695 
696             }
697 
698         }
699 
700         return (queued_funds, payee);
701 
702     }
703 
704     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
705     /// Caller must provide the answer history for each question, in reverse order
706     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
707     /// @param question_ids The IDs of the questions you want to claim for
708     /// @param lengths The number of history entries you will supply for each question ID
709     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
710     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
711     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
712     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
713     function claimMultipleAndWithdrawBalance(
714         bytes32[] question_ids, uint256[] lengths, 
715         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
716     ) 
717         stateAny() // The finalization checks are done in the claimWinnings function
718     public {
719         
720         uint256 qi;
721         uint256 i;
722         for (qi = 0; qi < question_ids.length; qi++) {
723             bytes32 qid = question_ids[qi];
724             uint256 ln = lengths[qi];
725             bytes32[] memory hh = new bytes32[](ln);
726             address[] memory ad = new address[](ln);
727             uint256[] memory bo = new uint256[](ln);
728             bytes32[] memory an = new bytes32[](ln);
729             uint256 j;
730             for (j = 0; j < ln; j++) {
731                 hh[j] = hist_hashes[i];
732                 ad[j] = addrs[i];
733                 bo[j] = bonds[i];
734                 an[j] = answers[i];
735                 i++;
736             }
737             claimWinnings(qid, hh, ad, bo, an);
738         }
739         withdraw();
740     }
741 
742     /// @notice Returns the questions's content hash, identifying the question content
743     /// @param question_id The ID of the question 
744     function getContentHash(bytes32 question_id) 
745     public view returns(bytes32) {
746         return questions[question_id].content_hash;
747     }
748 
749     /// @notice Returns the arbitrator address for the question
750     /// @param question_id The ID of the question 
751     function getArbitrator(bytes32 question_id) 
752     public view returns(address) {
753         return questions[question_id].arbitrator;
754     }
755 
756     /// @notice Returns the timestamp when the question can first be answered
757     /// @param question_id The ID of the question 
758     function getOpeningTS(bytes32 question_id) 
759     public view returns(uint32) {
760         return questions[question_id].opening_ts;
761     }
762 
763     /// @notice Returns the timeout in seconds used after each answer
764     /// @param question_id The ID of the question 
765     function getTimeout(bytes32 question_id) 
766     public view returns(uint32) {
767         return questions[question_id].timeout;
768     }
769 
770     /// @notice Returns the timestamp at which the question will be/was finalized
771     /// @param question_id The ID of the question 
772     function getFinalizeTS(bytes32 question_id) 
773     public view returns(uint32) {
774         return questions[question_id].finalize_ts;
775     }
776 
777     /// @notice Returns whether the question is pending arbitration
778     /// @param question_id The ID of the question 
779     function isPendingArbitration(bytes32 question_id) 
780     public view returns(bool) {
781         return questions[question_id].is_pending_arbitration;
782     }
783 
784     /// @notice Returns the current total unclaimed bounty
785     /// @dev Set back to zero once the bounty has been claimed
786     /// @param question_id The ID of the question 
787     function getBounty(bytes32 question_id) 
788     public view returns(uint256) {
789         return questions[question_id].bounty;
790     }
791 
792     /// @notice Returns the current best answer
793     /// @param question_id The ID of the question 
794     function getBestAnswer(bytes32 question_id) 
795     public view returns(bytes32) {
796         return questions[question_id].best_answer;
797     }
798 
799     /// @notice Returns the history hash of the question 
800     /// @param question_id The ID of the question 
801     /// @dev Updated on each answer, then rewound as each is claimed
802     function getHistoryHash(bytes32 question_id) 
803     public view returns(bytes32) {
804         return questions[question_id].history_hash;
805     }
806 
807     /// @notice Returns the highest bond posted so far for a question
808     /// @param question_id The ID of the question 
809     function getBond(bytes32 question_id) 
810     public view returns(uint256) {
811         return questions[question_id].bond;
812     }
813 
814 }