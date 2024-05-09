1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ReailtioSafeMath256
5  * @dev Math operations with safety checks that throw on error
6  */
7 library RealitioSafeMath256 {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 pragma solidity ^0.4.24;
37 
38 /**
39  * @title RealitioSafeMath32
40  * @dev Math operations with safety checks that throw on error
41  * @dev Copy of SafeMath but for uint32 instead of uint256
42  * @dev Deleted functions we don't use
43  */
44 library RealitioSafeMath32 {
45   function add(uint32 a, uint32 b) internal pure returns (uint32) {
46     uint32 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 pragma solidity ^0.4.18;
53 
54 contract BalanceHolder {
55 
56     mapping(address => uint256) public balanceOf;
57 
58     event LogWithdraw(
59         address indexed user,
60         uint256 amount
61     );
62 
63     function withdraw() 
64     public {
65         uint256 bal = balanceOf[msg.sender];
66         balanceOf[msg.sender] = 0;
67         msg.sender.transfer(bal);
68         emit LogWithdraw(msg.sender, bal);
69     }
70 
71 }
72 
73 pragma solidity ^0.4.24;
74 
75 contract Realitio is BalanceHolder {
76 
77     using RealitioSafeMath256 for uint256;
78     using RealitioSafeMath32 for uint32;
79 
80     address constant NULL_ADDRESS = address(0);
81 
82     // History hash when no history is created, or history has been cleared
83     bytes32 constant NULL_HASH = bytes32(0);
84 
85     // An unitinalized finalize_ts for a question will indicate an unanswered question.
86     uint32 constant UNANSWERED = 0;
87 
88     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
89     uint256 constant COMMITMENT_NON_EXISTENT = 0;
90 
91     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
92     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
93 
94     event LogSetQuestionFee(
95         address arbitrator,
96         uint256 amount
97     );
98 
99     event LogNewTemplate(
100         uint256 indexed template_id,
101         address indexed user, 
102         string question_text
103     );
104 
105     event LogNewQuestion(
106         bytes32 indexed question_id,
107         address indexed user, 
108         uint256 template_id,
109         string question,
110         bytes32 indexed content_hash,
111         address arbitrator, 
112         uint32 timeout,
113         uint32 opening_ts,
114         uint256 nonce,
115         uint256 created
116     );
117 
118     event LogFundAnswerBounty(
119         bytes32 indexed question_id,
120         uint256 bounty_added,
121         uint256 bounty,
122         address indexed user 
123     );
124 
125     event LogNewAnswer(
126         bytes32 answer,
127         bytes32 indexed question_id,
128         bytes32 history_hash,
129         address indexed user,
130         uint256 bond,
131         uint256 ts,
132         bool is_commitment
133     );
134 
135     event LogAnswerReveal(
136         bytes32 indexed question_id, 
137         address indexed user, 
138         bytes32 indexed answer_hash, 
139         bytes32 answer, 
140         uint256 nonce, 
141         uint256 bond
142     );
143 
144     event LogNotifyOfArbitrationRequest(
145         bytes32 indexed question_id,
146         address indexed user 
147     );
148 
149     event LogFinalize(
150         bytes32 indexed question_id,
151         bytes32 indexed answer
152     );
153 
154     event LogClaim(
155         bytes32 indexed question_id,
156         address indexed user,
157         uint256 amount
158     );
159 
160     struct Question {
161         bytes32 content_hash;
162         address arbitrator;
163         uint32 opening_ts;
164         uint32 timeout;
165         uint32 finalize_ts;
166         bool is_pending_arbitration;
167         uint256 bounty;
168         bytes32 best_answer;
169         bytes32 history_hash;
170         uint256 bond;
171     }
172 
173     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
174     struct Commitment {
175         uint32 reveal_ts;
176         bool is_revealed;
177         bytes32 revealed_answer;
178     }
179 
180     // Only used when claiming more bonds than fits into a transaction
181     // Stored in a mapping indexed by question_id.
182     struct Claim {
183         address payee;
184         uint256 last_bond;
185         uint256 queued_funds;
186     }
187 
188     uint256 nextTemplateID = 0;
189     mapping(uint256 => uint256) public templates;
190     mapping(uint256 => bytes32) public template_hashes;
191     mapping(bytes32 => Question) public questions;
192     mapping(bytes32 => Claim) public question_claims;
193     mapping(bytes32 => Commitment) public commitments;
194     mapping(address => uint256) public arbitrator_question_fees; 
195 
196     modifier onlyArbitrator(bytes32 question_id) {
197         require(msg.sender == questions[question_id].arbitrator, "msg.sender must be arbitrator");
198         _;
199     }
200 
201     modifier stateAny() {
202         _;
203     }
204 
205     modifier stateNotCreated(bytes32 question_id) {
206         require(questions[question_id].timeout == 0, "question must not exist");
207         _;
208     }
209 
210     modifier stateOpen(bytes32 question_id) {
211         require(questions[question_id].timeout > 0, "question must exist");
212         require(!questions[question_id].is_pending_arbitration, "question must not be pending arbitration");
213         uint32 finalize_ts = questions[question_id].finalize_ts;
214         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization deadline must not have passed");
215         uint32 opening_ts = questions[question_id].opening_ts;
216         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
217         _;
218     }
219 
220     modifier statePendingArbitration(bytes32 question_id) {
221         require(questions[question_id].is_pending_arbitration, "question must be pending arbitration");
222         _;
223     }
224 
225     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
226         require(questions[question_id].timeout > 0, "question must exist");
227         uint32 finalize_ts = questions[question_id].finalize_ts;
228         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization dealine must not have passed");
229         uint32 opening_ts = questions[question_id].opening_ts;
230         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
231         _;
232     }
233 
234     modifier stateFinalized(bytes32 question_id) {
235         require(isFinalized(question_id), "question must be finalized");
236         _;
237     }
238 
239     modifier bondMustBeZero() {
240         require(msg.value == 0, "bond must be zero");
241         _;
242     }
243 
244     modifier bondMustDouble(bytes32 question_id) {
245         require(msg.value > 0, "bond must be positive"); 
246         require(msg.value >= (questions[question_id].bond.mul(2)), "bond must be double at least previous bond");
247         _;
248     }
249 
250     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
251         if (max_previous > 0) {
252             require(questions[question_id].bond <= max_previous, "bond must exceed max_previous");
253         }
254         _;
255     }
256 
257     /// @notice Constructor, sets up some initial templates
258     /// @dev Creates some generalized templates for different question types used in the DApp.
259     constructor() 
260     public {
261         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
262         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
263         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
264         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
265         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
266     }
267 
268     /// @notice Function for arbitrator to set an optional per-question fee. 
269     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
270     /// @param fee The fee to be charged by the arbitrator when a question is asked
271     function setQuestionFee(uint256 fee) 
272         stateAny() 
273     external {
274         arbitrator_question_fees[msg.sender] = fee;
275         emit LogSetQuestionFee(msg.sender, fee);
276     }
277 
278     /// @notice Create a reusable template, which should be a JSON document.
279     /// Placeholders should use gettext() syntax, eg %s.
280     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
281     /// @param content The template content
282     /// @return The ID of the newly-created template, which is created sequentially.
283     function createTemplate(string content) 
284         stateAny()
285     public returns (uint256) {
286         uint256 id = nextTemplateID;
287         templates[id] = block.number;
288         template_hashes[id] = keccak256(abi.encodePacked(content));
289         emit LogNewTemplate(id, msg.sender, content);
290         nextTemplateID = id.add(1);
291         return id;
292     }
293 
294     /// @notice Create a new reusable template and use it to ask a question
295     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
296     /// @param content The template content
297     /// @param question A string containing the parameters that will be passed into the template to make the question
298     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
299     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
300     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
301     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
302     /// @return The ID of the newly-created template, which is created sequentially.
303     function createTemplateAndAskQuestion(
304         string content, 
305         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
306     ) 
307         // stateNotCreated is enforced by the internal _askQuestion
308     public payable returns (bytes32) {
309         uint256 template_id = createTemplate(content);
310         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
311     }
312 
313     /// @notice Ask a new question and return the ID
314     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
315     /// @param template_id The ID number of the template the question will use
316     /// @param question A string containing the parameters that will be passed into the template to make the question
317     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
318     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
319     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
320     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
321     /// @return The ID of the newly-created question, created deterministically.
322     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
323         // stateNotCreated is enforced by the internal _askQuestion
324     public payable returns (bytes32) {
325 
326         require(templates[template_id] > 0, "template must exist");
327 
328         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
329         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
330 
331         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
332         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
333 
334         return question_id;
335     }
336 
337     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
338         stateNotCreated(question_id)
339     internal {
340 
341         // A timeout of 0 makes no sense, and we will use this to check existence
342         require(timeout > 0, "timeout must be positive"); 
343         require(timeout < 365 days, "timeout must be less than 365 days"); 
344         require(arbitrator != NULL_ADDRESS, "arbitrator must be set");
345 
346         uint256 bounty = msg.value;
347 
348         // The arbitrator can set a fee for asking a question. 
349         // This is intended as an anti-spam defence.
350         // The fee is waived if the arbitrator is asking the question.
351         // This allows them to set an impossibly high fee and make users proxy the question through them.
352         // This would allow more sophisticated pricing, question whitelisting etc.
353         if (msg.sender != arbitrator) {
354             uint256 question_fee = arbitrator_question_fees[arbitrator];
355             require(bounty >= question_fee, "ETH provided must cover question fee"); 
356             bounty = bounty.sub(question_fee);
357             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
358         }
359 
360         questions[question_id].content_hash = content_hash;
361         questions[question_id].arbitrator = arbitrator;
362         questions[question_id].opening_ts = opening_ts;
363         questions[question_id].timeout = timeout;
364         questions[question_id].bounty = bounty;
365 
366     }
367 
368     /// @notice Add funds to the bounty for a question
369     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
370     /// @param question_id The ID of the question you wish to fund
371     function fundAnswerBounty(bytes32 question_id) 
372         stateOpen(question_id)
373     external payable {
374         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
375         emit LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
376     }
377 
378     /// @notice Submit an answer for a question.
379     /// @dev Adds the answer to the history and updates the current "best" answer.
380     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
381     /// @param question_id The ID of the question
382     /// @param answer The answer, encoded into bytes32
383     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
384     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
385         stateOpen(question_id)
386         bondMustDouble(question_id)
387         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
388     external payable {
389         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
390         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
391     }
392 
393     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
394     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
395     /// The commitment_id is stored in the answer history where the answer would normally go.
396     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
397     /// @param question_id The ID of the question
398     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
399     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
400     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
401     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
402     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
403         stateOpen(question_id)
404         bondMustDouble(question_id)
405         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
406     external payable {
407 
408         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, msg.value));
409         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
410 
411         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
412 
413         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
414         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
415 
416         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
417 
418     }
419 
420     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
421     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
422     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
423     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
424     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
425     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
426     /// @param question_id The ID of the question
427     /// @param answer The answer, encoded as bytes32
428     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
429     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
430     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
431         stateOpenOrPendingArbitration(question_id)
432     external {
433 
434         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
435         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
436 
437         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
438         require(commitments[commitment_id].reveal_ts > uint32(now), "reveal deadline must not have passed");
439 
440         commitments[commitment_id].revealed_answer = answer;
441         commitments[commitment_id].is_revealed = true;
442 
443         if (bond == questions[question_id].bond) {
444             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
445         }
446 
447         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
448 
449     }
450 
451     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
452     internal 
453     {
454         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
455 
456         // Update the current bond level, if there's a bond (ie anything except arbitration)
457         if (bond > 0) {
458             questions[question_id].bond = bond;
459         }
460         questions[question_id].history_hash = new_history_hash;
461 
462         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
463     }
464 
465     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
466     internal {
467         questions[question_id].best_answer = answer;
468         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
469     }
470 
471     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
472     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
473     /// @param question_id The ID of the question
474     /// @param requester The account that requested arbitration
475     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
476     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
477         onlyArbitrator(question_id)
478         stateOpen(question_id)
479         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
480     external {
481         require(questions[question_id].bond > 0, "Question must already have an answer when arbitration is requested");
482         questions[question_id].is_pending_arbitration = true;
483         emit LogNotifyOfArbitrationRequest(question_id, requester);
484     }
485 
486     /// @notice Submit the answer for a question, for use by the arbitrator.
487     /// @dev Doesn't require (or allow) a bond.
488     /// If the current final answer is correct, the account should be whoever submitted it.
489     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
490     /// However, the answerer stipulations are not enforced by the contract.
491     /// @param question_id The ID of the question
492     /// @param answer The answer, encoded into bytes32
493     /// @param answerer The account credited with this answer for the purpose of bond claims
494     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
495         onlyArbitrator(question_id)
496         statePendingArbitration(question_id)
497         bondMustBeZero
498     external {
499 
500         require(answerer != NULL_ADDRESS, "answerer must be provided");
501         emit LogFinalize(question_id, answer);
502 
503         questions[question_id].is_pending_arbitration = false;
504         _addAnswerToHistory(question_id, answer, answerer, 0, false);
505         _updateCurrentAnswer(question_id, answer, 0);
506 
507     }
508 
509     /// @notice Report whether the answer to the specified question is finalized
510     /// @param question_id The ID of the question
511     /// @return Return true if finalized
512     function isFinalized(bytes32 question_id) 
513     view public returns (bool) {
514         uint32 finalize_ts = questions[question_id].finalize_ts;
515         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
516     }
517 
518     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
519     /// @param question_id The ID of the question
520     /// @return The answer formatted as a bytes32
521     function getFinalAnswer(bytes32 question_id) 
522         stateFinalized(question_id)
523     external view returns (bytes32) {
524         return questions[question_id].best_answer;
525     }
526 
527     /// @notice Return the final answer to the specified question, or revert if there isn't one
528     /// @param question_id The ID of the question
529     /// @return The answer formatted as a bytes32
530     function resultFor(bytes32 question_id) 
531         stateFinalized(question_id)
532     external view returns (bytes32) {
533         return questions[question_id].best_answer;
534     }
535 
536 
537     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
538     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
539     /// @param question_id The ID of the question
540     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
541     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
542     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
543     /// @param min_bond The bond sent with the final answer must be this high or higher
544     /// @return The answer formatted as a bytes32
545     function getFinalAnswerIfMatches(
546         bytes32 question_id, 
547         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
548     ) 
549         stateFinalized(question_id)
550     external view returns (bytes32) {
551         require(content_hash == questions[question_id].content_hash, "content hash must match");
552         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
553         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
554         require(min_bond <= questions[question_id].bond, "bond must be high enough");
555         return questions[question_id].best_answer;
556     }
557 
558     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
559     /// Caller must provide the answer history, in reverse order
560     /// @dev Works up the chain and assign bonds to the person who gave the right answer
561     /// If someone gave the winning answer earlier, they must get paid from the higher bond
562     /// That means we can't pay out the bond added at n until we have looked at n-1
563     /// The first answer is authenticated by checking against the stored history_hash.
564     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
565     /// Once we get to a null hash we'll know we're done and there are no more answers.
566     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
567     /// @param question_id The ID of the question
568     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
569     /// @param addrs Last-to-first, the address of each answerer or commitment sender
570     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
571     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
572     function claimWinnings(
573         bytes32 question_id, 
574         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
575     ) 
576         stateFinalized(question_id)
577     public {
578 
579         require(history_hashes.length > 0, "at least one history hash entry must be provided");
580 
581         // These are only set if we split our claim over multiple transactions.
582         address payee = question_claims[question_id].payee; 
583         uint256 last_bond = question_claims[question_id].last_bond; 
584         uint256 queued_funds = question_claims[question_id].queued_funds; 
585 
586         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
587         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
588         bytes32 last_history_hash = questions[question_id].history_hash;
589 
590         bytes32 best_answer = questions[question_id].best_answer;
591 
592         uint256 i;
593         for (i = 0; i < history_hashes.length; i++) {
594         
595             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
596             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
597             
598             queued_funds = queued_funds.add(last_bond); 
599             (queued_funds, payee) = _processHistoryItem(
600                 question_id, best_answer, queued_funds, payee, 
601                 addrs[i], bonds[i], answers[i], is_commitment);
602  
603             // Line the bond up for next time, when it will be added to somebody's queued_funds
604             last_bond = bonds[i];
605             last_history_hash = history_hashes[i];
606 
607         }
608  
609         if (last_history_hash != NULL_HASH) {
610             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
611             // Persist the details so we can pick up later where we left off later.
612 
613             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
614             // (We always know who to pay unless all we saw were unrevealed commits)
615             if (payee != NULL_ADDRESS) {
616                 _payPayee(question_id, payee, queued_funds);
617                 queued_funds = 0;
618             }
619 
620             question_claims[question_id].payee = payee;
621             question_claims[question_id].last_bond = last_bond;
622             question_claims[question_id].queued_funds = queued_funds;
623         } else {
624             // There is nothing left below us so the payee can keep what remains
625             _payPayee(question_id, payee, queued_funds.add(last_bond));
626             delete question_claims[question_id];
627         }
628 
629         questions[question_id].history_hash = last_history_hash;
630 
631     }
632 
633     function _payPayee(bytes32 question_id, address payee, uint256 value) 
634     internal {
635         balanceOf[payee] = balanceOf[payee].add(value);
636         emit LogClaim(question_id, payee, value);
637     }
638 
639     function _verifyHistoryInputOrRevert(
640         bytes32 last_history_hash,
641         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
642     )
643     internal pure returns (bool) {
644         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
645             return true;
646         }
647         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
648             return false;
649         } 
650         revert("History input provided did not match the expected hash");
651     }
652 
653     function _processHistoryItem(
654         bytes32 question_id, bytes32 best_answer, 
655         uint256 queued_funds, address payee, 
656         address addr, uint256 bond, bytes32 answer, bool is_commitment
657     )
658     internal returns (uint256, address) {
659 
660         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
661         // We look at the referenced commitment ID and switch in the actual answer.
662         if (is_commitment) {
663             bytes32 commitment_id = answer;
664             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
665             if (!commitments[commitment_id].is_revealed) {
666                 delete commitments[commitment_id];
667                 return (queued_funds, payee);
668             } else {
669                 answer = commitments[commitment_id].revealed_answer;
670                 delete commitments[commitment_id];
671             }
672         }
673 
674         if (answer == best_answer) {
675 
676             if (payee == NULL_ADDRESS) {
677 
678                 // The entry is for the first payee we come to, ie the winner.
679                 // They get the question bounty.
680                 payee = addr;
681                 queued_funds = queued_funds.add(questions[question_id].bounty);
682                 questions[question_id].bounty = 0;
683 
684             } else if (addr != payee) {
685 
686                 // Answerer has changed, ie we found someone lower down who needs to be paid
687 
688                 // The lower answerer will take over receiving bonds from higher answerer.
689                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
690                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
691 
692                 // There should be enough for the fee, but if not, take what we have.
693                 // There's an edge case involving weird arbitrator behaviour where we may be short.
694                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
695 
696                 // Settle up with the old (higher-bonded) payee
697                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
698 
699                 // Now start queued_funds again for the new (lower-bonded) payee
700                 payee = addr;
701                 queued_funds = answer_takeover_fee;
702 
703             }
704 
705         }
706 
707         return (queued_funds, payee);
708 
709     }
710 
711     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
712     /// Caller must provide the answer history for each question, in reverse order
713     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
714     /// @param question_ids The IDs of the questions you want to claim for
715     /// @param lengths The number of history entries you will supply for each question ID
716     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
717     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
718     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
719     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
720     function claimMultipleAndWithdrawBalance(
721         bytes32[] question_ids, uint256[] lengths, 
722         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
723     ) 
724         stateAny() // The finalization checks are done in the claimWinnings function
725     public {
726         
727         uint256 qi;
728         uint256 i;
729         for (qi = 0; qi < question_ids.length; qi++) {
730             bytes32 qid = question_ids[qi];
731             uint256 ln = lengths[qi];
732             bytes32[] memory hh = new bytes32[](ln);
733             address[] memory ad = new address[](ln);
734             uint256[] memory bo = new uint256[](ln);
735             bytes32[] memory an = new bytes32[](ln);
736             uint256 j;
737             for (j = 0; j < ln; j++) {
738                 hh[j] = hist_hashes[i];
739                 ad[j] = addrs[i];
740                 bo[j] = bonds[i];
741                 an[j] = answers[i];
742                 i++;
743             }
744             claimWinnings(qid, hh, ad, bo, an);
745         }
746         withdraw();
747     }
748 
749     /// @notice Returns the questions's content hash, identifying the question content
750     /// @param question_id The ID of the question 
751     function getContentHash(bytes32 question_id) 
752     public view returns(bytes32) {
753         return questions[question_id].content_hash;
754     }
755 
756     /// @notice Returns the arbitrator address for the question
757     /// @param question_id The ID of the question 
758     function getArbitrator(bytes32 question_id) 
759     public view returns(address) {
760         return questions[question_id].arbitrator;
761     }
762 
763     /// @notice Returns the timestamp when the question can first be answered
764     /// @param question_id The ID of the question 
765     function getOpeningTS(bytes32 question_id) 
766     public view returns(uint32) {
767         return questions[question_id].opening_ts;
768     }
769 
770     /// @notice Returns the timeout in seconds used after each answer
771     /// @param question_id The ID of the question 
772     function getTimeout(bytes32 question_id) 
773     public view returns(uint32) {
774         return questions[question_id].timeout;
775     }
776 
777     /// @notice Returns the timestamp at which the question will be/was finalized
778     /// @param question_id The ID of the question 
779     function getFinalizeTS(bytes32 question_id) 
780     public view returns(uint32) {
781         return questions[question_id].finalize_ts;
782     }
783 
784     /// @notice Returns whether the question is pending arbitration
785     /// @param question_id The ID of the question 
786     function isPendingArbitration(bytes32 question_id) 
787     public view returns(bool) {
788         return questions[question_id].is_pending_arbitration;
789     }
790 
791     /// @notice Returns the current total unclaimed bounty
792     /// @dev Set back to zero once the bounty has been claimed
793     /// @param question_id The ID of the question 
794     function getBounty(bytes32 question_id) 
795     public view returns(uint256) {
796         return questions[question_id].bounty;
797     }
798 
799     /// @notice Returns the current best answer
800     /// @param question_id The ID of the question 
801     function getBestAnswer(bytes32 question_id) 
802     public view returns(bytes32) {
803         return questions[question_id].best_answer;
804     }
805 
806     /// @notice Returns the history hash of the question 
807     /// @param question_id The ID of the question 
808     /// @dev Updated on each answer, then rewound as each is claimed
809     function getHistoryHash(bytes32 question_id) 
810     public view returns(bytes32) {
811         return questions[question_id].history_hash;
812     }
813 
814     /// @notice Returns the highest bond posted so far for a question
815     /// @param question_id The ID of the question 
816     function getBond(bytes32 question_id) 
817     public view returns(uint256) {
818         return questions[question_id].bond;
819     }
820 
821 }
822 
823 /**
824  *  @title Arbitrator
825  *  @author Clément Lesaege - <clement@lesaege.com>
826  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
827  */
828 
829 pragma solidity ^0.4.15;
830 
831 /** @title Arbitrator
832  *  Arbitrator abstract contract.
833  *  When developing arbitrator contracts we need to:
834  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
835  *  -Define the functions for cost display (arbitrationCost and appealCost).
836  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).
837  */
838 contract Arbitrator {
839 
840     enum DisputeStatus {Waiting, Appealable, Solved}
841 
842     modifier requireArbitrationFee(bytes _extraData) {
843         require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");
844         _;
845     }
846     modifier requireAppealFee(uint _disputeID, bytes _extraData) {
847         require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");
848         _;
849     }
850 
851     /** @dev To be raised when a dispute is created.
852      *  @param _disputeID ID of the dispute.
853      *  @param _arbitrable The contract which created the dispute.
854      */
855     event DisputeCreation(uint indexed _disputeID, Arbitrable indexed _arbitrable);
856 
857     /** @dev To be raised when a dispute can be appealed.
858      *  @param _disputeID ID of the dispute.
859      */
860     event AppealPossible(uint indexed _disputeID, Arbitrable indexed _arbitrable);
861 
862     /** @dev To be raised when the current ruling is appealed.
863      *  @param _disputeID ID of the dispute.
864      *  @param _arbitrable The contract which created the dispute.
865      */
866     event AppealDecision(uint indexed _disputeID, Arbitrable indexed _arbitrable);
867 
868     /** @dev Create a dispute. Must be called by the arbitrable contract.
869      *  Must be paid at least arbitrationCost(_extraData).
870      *  @param _choices Amount of choices the arbitrator can make in this dispute.
871      *  @param _extraData Can be used to give additional info on the dispute to be created.
872      *  @return disputeID ID of the dispute created.
873      */
874     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}
875 
876     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
877      *  @param _extraData Can be used to give additional info on the dispute to be created.
878      *  @return fee Amount to be paid.
879      */
880     function arbitrationCost(bytes _extraData) public view returns(uint fee);
881 
882     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
883      *  @param _disputeID ID of the dispute to be appealed.
884      *  @param _extraData Can be used to give extra info on the appeal.
885      */
886     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
887         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
888     }
889 
890     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
891      *  @param _disputeID ID of the dispute to be appealed.
892      *  @param _extraData Can be used to give additional info on the dispute to be created.
893      *  @return fee Amount to be paid.
894      */
895     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee);
896 
897     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible.
898      *  @param _disputeID ID of the dispute.
899      *  @return The start and end of the period.
900      */
901     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}
902 
903     /** @dev Return the status of a dispute.
904      *  @param _disputeID ID of the dispute to rule.
905      *  @return status The status of the dispute.
906      */
907     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);
908 
909     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
910      *  @param _disputeID ID of the dispute.
911      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
912      */
913     function currentRuling(uint _disputeID) public view returns(uint ruling);
914 }
915 
916 /**
917  *  @title IArbitrable
918  *  @author Enrique Piqueras - <enrique@kleros.io>
919  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
920  */
921 
922 pragma solidity ^0.4.15;
923 
924 /** @title IArbitrable
925  *  Arbitrable interface.
926  *  When developing arbitrable contracts, we need to:
927  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
928  *  -Allow dispute creation. For this a function must:
929  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
930  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
931  */
932 interface IArbitrable {
933     /** @dev To be emmited when meta-evidence is submitted.
934      *  @param _metaEvidenceID Unique identifier of meta-evidence.
935      *  @param _evidence A link to the meta-evidence JSON.
936      */
937     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
938 
939     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
940      *  @param _arbitrator The arbitrator of the contract.
941      *  @param _disputeID ID of the dispute in the Arbitrator contract.
942      *  @param _metaEvidenceID Unique identifier of meta-evidence.
943      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
944      */
945     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
946 
947     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
948      *  @param _arbitrator The arbitrator of the contract.
949      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
950      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
951      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
952      */
953     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
954 
955     /** @dev To be raised when a ruling is given.
956      *  @param _arbitrator The arbitrator giving the ruling.
957      *  @param _disputeID ID of the dispute in the Arbitrator contract.
958      *  @param _ruling The ruling which was given.
959      */
960     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
961 
962     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
963      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
964      *  @param _disputeID ID of the dispute in the Arbitrator contract.
965      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
966      */
967     function rule(uint _disputeID, uint _ruling) public;
968 }
969 
970 /**
971  *  @title Arbitrable
972  *  @author Clément Lesaege - <clement@lesaege.com>
973  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
974  */
975 
976 pragma solidity ^0.4.15;
977 
978 /** @title Arbitrable
979  *  Arbitrable abstract contract.
980  *  When developing arbitrable contracts, we need to:
981  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
982  *  -Allow dispute creation. For this a function must:
983  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
984  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
985  */
986 contract Arbitrable is IArbitrable {
987     Arbitrator public arbitrator;
988     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
989 
990     modifier onlyArbitrator {require(msg.sender == address(arbitrator), "Can only be called by the arbitrator."); _;}
991 
992     /** @dev Constructor. Choose the arbitrator.
993      *  @param _arbitrator The arbitrator of the contract.
994      *  @param _arbitratorExtraData Extra data for the arbitrator.
995      */
996     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
997         arbitrator = _arbitrator;
998         arbitratorExtraData = _arbitratorExtraData;
999     }
1000 
1001     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
1002      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
1003      *  @param _disputeID ID of the dispute in the Arbitrator contract.
1004      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
1005      */
1006     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
1007         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
1008 
1009         executeRuling(_disputeID,_ruling);
1010     }
1011 
1012 
1013     /** @dev Execute a ruling of a dispute.
1014      *  @param _disputeID ID of the dispute in the Arbitrator contract.
1015      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
1016      */
1017     function executeRuling(uint _disputeID, uint _ruling) internal;
1018 }
1019 
1020 /**
1021  *  https://contributing.kleros.io/smart-contract-workflow
1022  *  @reviewers: []
1023  *  @auditors: []
1024  *  @bounties: []
1025  *  @deployments: []
1026  */
1027 
1028 pragma solidity ^0.4.24;
1029 
1030 /**
1031  *  @title RealitioArbitratorProxy
1032  *  @author Enrique Piqueras - <enrique@kleros.io>
1033  *  @dev A Realitio arbitrator that is just a proxy for an ERC792 arbitrator.
1034  */
1035 contract RealitioArbitratorProxy is Arbitrable {
1036     /* Events */
1037 
1038     /** @dev Emitted when arbitration is requested, to link dispute ID to question ID for UIs.
1039      *  @param _disputeID The ID of the dispute in the ERC792 arbitrator.
1040      *  @param _questionID The ID of the question.
1041      */
1042     event DisputeIDToQuestionID(uint indexed _disputeID, bytes32 _questionID);
1043 
1044     /* Storage */
1045 
1046     address public deployer;
1047     Realitio public realitio;
1048     mapping(uint => bytes32) public disputeIDToQuestionID;
1049     mapping(bytes32 => address) public questionIDToDisputer;
1050     mapping(bytes32 => bytes32) public questionIDToAnswer;
1051     mapping(bytes32 => bool) public questionIDToRuled;
1052 
1053     /* Constructor */
1054 
1055     /** @dev Constructs the RealitioArbitratorProxy contract.
1056      *  @param _arbitrator The address of the ERC792 arbitrator.
1057      *  @param _arbitratorExtraData The extra data used to raise a dispute in the ERC792 arbitrator.
1058      *  @param _realitio The address of the Realitio contract.
1059      */
1060     constructor(
1061         Arbitrator _arbitrator,
1062         bytes _arbitratorExtraData,
1063         Realitio _realitio
1064     ) Arbitrable(_arbitrator, _arbitratorExtraData) public {
1065         deployer = msg.sender;
1066         realitio = _realitio;
1067     }
1068 
1069     /* External */
1070 
1071     /** @dev Sets the meta evidence. Can only be called once.
1072      *  @param _metaEvidence The URI of the meta evidence file.
1073      */
1074     function setMetaEvidence(string _metaEvidence) external {
1075         require(msg.sender == deployer, "Can only be called once by the deployer of the contract.");
1076         deployer = address(0);
1077         emit MetaEvidence(0, _metaEvidence);
1078     }
1079 
1080     /** @dev Raise a dispute from a specified question.
1081      *  @param _questionID The ID of the question.
1082      *  @param _maxPrevious If specified, reverts if a bond higher than this was submitted after you sent your transaction.
1083      */
1084     function requestArbitration(bytes32 _questionID, uint _maxPrevious) external payable {
1085         uint disputeID = arbitrator.createDispute.value(msg.value)((2 ** 128) - 1, arbitratorExtraData);
1086         disputeIDToQuestionID[disputeID] = _questionID;
1087         questionIDToDisputer[_questionID] = msg.sender;
1088         realitio.notifyOfArbitrationRequest(_questionID, msg.sender, _maxPrevious);
1089         emit Dispute(arbitrator, disputeID, 0, 0);
1090         emit DisputeIDToQuestionID(disputeID, _questionID);
1091     }
1092 
1093     /** @dev Report the answer to a specified question from the ERC792 arbitrator to the Realitio contract.
1094      *  @param _questionID The ID of the question.
1095      *  @param _lastHistoryHash The history hash given with the last answer to the question in the Realitio contract.
1096      *  @param _lastAnswerOrCommitmentID The last answer given, or its commitment ID if it was a commitment, to the question in the Realitio contract.
1097      *  @param _lastBond The bond paid for the last answer to the question in the Realitio contract.
1098      *  @param _lastAnswerer The last answerer to the question in the Realitio contract.
1099      *  @param _isCommitment Wether the last answer to the question in the Realitio contract used commit or reveal or not. True if it did, false otherwise.
1100      */
1101     function reportAnswer(
1102         bytes32 _questionID,
1103         bytes32 _lastHistoryHash,
1104         bytes32 _lastAnswerOrCommitmentID,
1105         uint _lastBond,
1106         address _lastAnswerer,
1107         bool _isCommitment
1108     ) external {
1109         require(
1110             realitio.getHistoryHash(_questionID) == keccak256(_lastHistoryHash, _lastAnswerOrCommitmentID, _lastBond, _lastAnswerer, _isCommitment),
1111             "The hash of the history parameters supplied does not match the one stored in the Realitio contract."
1112         );
1113         require(questionIDToRuled[_questionID], "The arbitrator has not ruled yet.");
1114 
1115         realitio.submitAnswerByArbitrator(
1116             _questionID,
1117             questionIDToAnswer[_questionID],
1118             computeWinner(_questionID, _lastAnswerOrCommitmentID, _lastBond, _lastAnswerer, _isCommitment)
1119         );
1120 
1121         delete questionIDToDisputer[_questionID];
1122         delete questionIDToAnswer[_questionID];
1123         delete questionIDToRuled[_questionID];
1124     }
1125 
1126     /* External Views */
1127 
1128     /** @dev Get the fee for a dispute from a specified question.
1129      *  @param _questionID The ID of the question.
1130      *  @return fee The dispute's fee.
1131      */
1132     function getDisputeFee(bytes32 _questionID) external view returns (uint fee) {
1133         return arbitrator.arbitrationCost(arbitratorExtraData);
1134     }
1135 
1136     /* Internal */
1137 
1138     /** @dev Execute the ruling of a specified dispute.
1139      *  @param _disputeID The ID of the dispute in the ERC792 arbitrator.
1140      *  @param _ruling The ruling given by the ERC792 arbitrator. Note that 0 is reserved for "Unable/refused to arbitrate" and we map it to `bytes32(-1)` which has a similar connotation in Realitio.
1141      */
1142     function executeRuling(uint _disputeID, uint _ruling) internal {
1143         questionIDToAnswer[disputeIDToQuestionID[_disputeID]] = bytes32(_ruling == 0 ? uint(-1) : _ruling - 1);
1144         questionIDToRuled[disputeIDToQuestionID[_disputeID]] = true;
1145         delete disputeIDToQuestionID[_disputeID];
1146     }
1147 
1148     /* Private Views */
1149 
1150     /** @dev Computes the Realitio answerer, of a specified question, that should win. This function is needed to avoid the "stack too deep error".
1151      *  @param _questionID The ID of the question.
1152      *  @param _lastAnswerOrCommitmentID The last answer given, or its commitment ID if it was a commitment, to the question in the Realitio contract.
1153      *  @param _lastBond The bond paid for the last answer to the question in the Realitio contract.
1154      *  @param _lastAnswerer The last answerer to the question in the Realitio contract.
1155      *  @param _isCommitment Wether the last answer to the question in the Realitio contract used commit or reveal or not. True if it did, false otherwise.
1156      *  @return winner The computed winner.
1157      */
1158     function computeWinner(
1159         bytes32 _questionID,
1160         bytes32 _lastAnswerOrCommitmentID,
1161         uint _lastBond,
1162         address _lastAnswerer,
1163         bool _isCommitment
1164     ) private view returns(address winner) {
1165         bytes32 lastAnswer;
1166         bool isAnswered;
1167         if (_lastBond == 0) { // If the question hasn't been answered, nobody is ever right.
1168             isAnswered = false;
1169         } else if (_isCommitment) {
1170             (uint32 revealTS, bool isRevealed, bytes32 revealedAnswer) = realitio.commitments(_lastAnswerOrCommitmentID);
1171             if (isRevealed) {
1172                 lastAnswer = revealedAnswer;
1173                 isAnswered = true;
1174             } else {
1175                 require(revealTS < uint32(now), "Arbitration cannot be done until the last answerer has had time to reveal its commitment.");
1176                 isAnswered = false;
1177             }
1178         } else {
1179             lastAnswer = _lastAnswerOrCommitmentID;
1180             isAnswered = true;
1181         }
1182 
1183         return isAnswered && lastAnswer == questionIDToAnswer[_questionID] ? _lastAnswerer : questionIDToDisputer[_questionID];
1184     }
1185 }