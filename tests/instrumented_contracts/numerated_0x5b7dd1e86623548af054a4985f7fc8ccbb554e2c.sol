1 // SPDX-License-Identifier: GPL-3.0-only
2 
3 pragma solidity ^0.8.6;
4 
5 contract BalanceHolder {
6 
7     mapping(address => uint256) public balanceOf;
8 
9     event LogWithdraw(
10         address indexed user,
11         uint256 amount
12     );
13 
14     function withdraw() 
15     public {
16         uint256 bal = balanceOf[msg.sender];
17         balanceOf[msg.sender] = 0;
18         payable(msg.sender).transfer(bal);
19         emit LogWithdraw(msg.sender, bal);
20     }
21 
22 }
23 
24 contract RealityETH_v3_0 is BalanceHolder {
25 
26     address constant NULL_ADDRESS = address(0);
27 
28     // History hash when no history is created, or history has been cleared
29     bytes32 constant NULL_HASH = bytes32(0);
30 
31     // An unitinalized finalize_ts for a question will indicate an unanswered question.
32     uint32 constant UNANSWERED = 0;
33 
34     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
35     uint256 constant COMMITMENT_NON_EXISTENT = 0;
36 
37     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
38     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
39 
40     // Proportion withheld when you claim an earlier bond.
41     uint256 constant BOND_CLAIM_FEE_PROPORTION = 40; // One 40th ie 2.5%
42 
43     // Special value representing a question that was answered too soon.
44     // bytes32(-2). By convention we use bytes32(-1) for "invalid", although the contract does not handle this.
45     bytes32 constant UNRESOLVED_ANSWER = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe;
46 
47     event LogSetQuestionFee(
48         address arbitrator,
49         uint256 amount
50     );
51 
52     event LogNewTemplate(
53         uint256 indexed template_id,
54         address indexed user, 
55         string question_text
56     );
57 
58     event LogNewQuestion(
59         bytes32 indexed question_id,
60         address indexed user, 
61         uint256 template_id,
62         string question,
63         bytes32 indexed content_hash,
64         address arbitrator, 
65         uint32 timeout,
66         uint32 opening_ts,
67         uint256 nonce,
68         uint256 created
69     );
70 
71     event LogMinimumBond(
72         bytes32 indexed question_id,
73         uint256 min_bond
74     );
75 
76     event LogFundAnswerBounty(
77         bytes32 indexed question_id,
78         uint256 bounty_added,
79         uint256 bounty,
80         address indexed user 
81     );
82 
83     event LogNewAnswer(
84         bytes32 answer,
85         bytes32 indexed question_id,
86         bytes32 history_hash,
87         address indexed user,
88         uint256 bond,
89         uint256 ts,
90         bool is_commitment
91     );
92 
93     event LogAnswerReveal(
94         bytes32 indexed question_id, 
95         address indexed user, 
96         bytes32 indexed answer_hash, 
97         bytes32 answer, 
98         uint256 nonce, 
99         uint256 bond
100     );
101 
102     event LogNotifyOfArbitrationRequest(
103         bytes32 indexed question_id,
104         address indexed user 
105     );
106 
107     event LogCancelArbitration(
108         bytes32 indexed question_id
109     );
110 
111     event LogFinalize(
112         bytes32 indexed question_id,
113         bytes32 indexed answer
114     );
115 
116     event LogClaim(
117         bytes32 indexed question_id,
118         address indexed user,
119         uint256 amount
120     );
121 
122     event LogReopenQuestion(
123         bytes32 indexed question_id,
124         bytes32 indexed reopened_question_id
125     );
126 
127     struct Question {
128         bytes32 content_hash;
129         address arbitrator;
130         uint32 opening_ts;
131         uint32 timeout;
132         uint32 finalize_ts;
133         bool is_pending_arbitration;
134         uint256 bounty;
135         bytes32 best_answer;
136         bytes32 history_hash;
137         uint256 bond;
138         uint256 min_bond;
139     }
140 
141     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
142     struct Commitment {
143         uint32 reveal_ts;
144         bool is_revealed;
145         bytes32 revealed_answer;
146     }
147 
148     // Only used when claiming more bonds than fits into a transaction
149     // Stored in a mapping indexed by question_id.
150     struct Claim {
151         address payee;
152         uint256 last_bond;
153         uint256 queued_funds;
154     }
155 
156     uint256 nextTemplateID = 0;
157     mapping(uint256 => uint256) public templates;
158     mapping(uint256 => bytes32) public template_hashes;
159     mapping(bytes32 => Question) public questions;
160     mapping(bytes32 => Claim) public question_claims;
161     mapping(bytes32 => Commitment) public commitments;
162     mapping(address => uint256) public arbitrator_question_fees; 
163     mapping(bytes32 => bytes32) public reopened_questions;
164     mapping(bytes32 => bool) public reopener_questions;
165 
166 
167     modifier onlyArbitrator(bytes32 question_id) {
168         require(msg.sender == questions[question_id].arbitrator, "msg.sender must be arbitrator");
169         _;
170     }
171 
172     modifier stateAny() {
173         _;
174     }
175 
176     modifier stateNotCreated(bytes32 question_id) {
177         require(questions[question_id].timeout == 0, "question must not exist");
178         _;
179     }
180 
181     modifier stateOpen(bytes32 question_id) {
182         require(questions[question_id].timeout > 0, "question must exist");
183         require(!questions[question_id].is_pending_arbitration, "question must not be pending arbitration");
184         uint32 finalize_ts = questions[question_id].finalize_ts;
185         require(finalize_ts == UNANSWERED || finalize_ts > uint32(block.timestamp), "finalization deadline must not have passed");
186         uint32 opening_ts = questions[question_id].opening_ts;
187         require(opening_ts == 0 || opening_ts <= uint32(block.timestamp), "opening date must have passed"); 
188         _;
189     }
190 
191     modifier statePendingArbitration(bytes32 question_id) {
192         require(questions[question_id].is_pending_arbitration, "question must be pending arbitration");
193         _;
194     }
195 
196     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
197         require(questions[question_id].timeout > 0, "question must exist");
198         uint32 finalize_ts = questions[question_id].finalize_ts;
199         require(finalize_ts == UNANSWERED || finalize_ts > uint32(block.timestamp), "finalization dealine must not have passed");
200         uint32 opening_ts = questions[question_id].opening_ts;
201         require(opening_ts == 0 || opening_ts <= uint32(block.timestamp), "opening date must have passed"); 
202         _;
203     }
204 
205     modifier stateFinalized(bytes32 question_id) {
206         require(isFinalized(question_id), "question must be finalized");
207         _;
208     }
209 
210     modifier bondMustDoubleAndMatchMinimum(bytes32 question_id) {
211         require(msg.value > 0, "bond must be positive"); 
212         uint256 current_bond = questions[question_id].bond;
213         if (current_bond == 0) {
214             require(msg.value >= (questions[question_id].min_bond), "bond must exceed the minimum");
215         } else {
216             require(msg.value >= (current_bond * 2), "bond must be double at least previous bond");
217         }
218         _;
219     }
220 
221     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
222         if (max_previous > 0) {
223             require(questions[question_id].bond <= max_previous, "bond must exceed max_previous");
224         }
225         _;
226     }
227 
228     /// @notice Constructor, sets up some initial templates
229     /// @dev Creates some generalized templates for different question types used in the DApp.
230     constructor() {
231         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
232         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
233         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
234         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
235         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
236     }
237 
238     /// @notice Function for arbitrator to set an optional per-question fee. 
239     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
240     /// @param fee The fee to be charged by the arbitrator when a question is asked
241     function setQuestionFee(uint256 fee) 
242         stateAny() 
243     external {
244         arbitrator_question_fees[msg.sender] = fee;
245         emit LogSetQuestionFee(msg.sender, fee);
246     }
247 
248     /// @notice Create a reusable template, which should be a JSON document.
249     /// Placeholders should use gettext() syntax, eg %s.
250     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
251     /// @param content The template content
252     /// @return The ID of the newly-created template, which is created sequentially.
253     function createTemplate(string memory content) 
254         stateAny()
255     public returns (uint256) {
256         uint256 id = nextTemplateID;
257         templates[id] = block.number;
258         template_hashes[id] = keccak256(abi.encodePacked(content));
259         emit LogNewTemplate(id, msg.sender, content);
260         nextTemplateID = id + 1;
261         return id;
262     }
263 
264     /// @notice Create a new reusable template and use it to ask a question
265     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
266     /// @param content The template content
267     /// @param question A string containing the parameters that will be passed into the template to make the question
268     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
269     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
270     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
271     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
272     /// @return The ID of the newly-created template, which is created sequentially.
273     function createTemplateAndAskQuestion(
274         string memory content, 
275         string memory question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
276     ) 
277         // stateNotCreated is enforced by the internal _askQuestion
278     public payable returns (bytes32) {
279         uint256 template_id = createTemplate(content);
280         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
281     }
282 
283     /// @notice Ask a new question and return the ID
284     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
285     /// @param template_id The ID number of the template the question will use
286     /// @param question A string containing the parameters that will be passed into the template to make the question
287     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
288     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
289     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
290     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
291     /// @return The ID of the newly-created question, created deterministically.
292     function askQuestion(uint256 template_id, string memory question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
293         // stateNotCreated is enforced by the internal _askQuestion
294     public payable returns (bytes32) {
295 
296         require(templates[template_id] > 0, "template must exist");
297 
298         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
299         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, uint256(0), address(this), msg.sender, nonce));
300 
301         // We emit this event here because _askQuestion doesn't need to know the unhashed question. Other events are emitted by _askQuestion.
302         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, block.timestamp);
303         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts, 0);
304 
305         return question_id;
306     }
307 
308     /// @notice Ask a new question and return the ID
309     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
310     /// @param template_id The ID number of the template the question will use
311     /// @param question A string containing the parameters that will be passed into the template to make the question
312     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
313     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
314     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
315     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
316     /// @param min_bond The minimum bond that may be used for an answer.
317     /// @return The ID of the newly-created question, created deterministically.
318     function askQuestionWithMinBond(uint256 template_id, string memory question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce, uint256 min_bond) 
319         // stateNotCreated is enforced by the internal _askQuestion
320     public payable returns (bytes32) {
321 
322         require(templates[template_id] > 0, "template must exist");
323 
324         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
325         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, min_bond, address(this), msg.sender, nonce));
326 
327         // We emit this event here because _askQuestion doesn't need to know the unhashed question.
328         // Other events are emitted by _askQuestion.
329         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, block.timestamp);
330         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts, min_bond);
331 
332         return question_id;
333     }
334 
335     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 min_bond) 
336         stateNotCreated(question_id)
337     internal {
338 
339         // A timeout of 0 makes no sense, and we will use this to check existence
340         require(timeout > 0, "timeout must be positive"); 
341         require(timeout < 365 days, "timeout must be less than 365 days"); 
342 
343         uint256 bounty = msg.value;
344 
345         // The arbitrator can set a fee for asking a question. 
346         // This is intended as an anti-spam defence.
347         // The fee is waived if the arbitrator is asking the question.
348         // This allows them to set an impossibly high fee and make users proxy the question through them.
349         // This would allow more sophisticated pricing, question whitelisting etc.
350         if (arbitrator != NULL_ADDRESS && msg.sender != arbitrator) {
351             uint256 question_fee = arbitrator_question_fees[arbitrator];
352             require(bounty >= question_fee, "ETH provided must cover question fee"); 
353             bounty = bounty - question_fee;
354             balanceOf[arbitrator] = balanceOf[arbitrator] + question_fee;
355         }
356 
357         questions[question_id].content_hash = content_hash;
358         questions[question_id].arbitrator = arbitrator;
359         questions[question_id].opening_ts = opening_ts;
360         questions[question_id].timeout = timeout;
361 
362         if (bounty > 0) {
363             questions[question_id].bounty = bounty;
364             emit LogFundAnswerBounty(question_id, bounty, bounty, msg.sender);
365         }
366 
367         if (min_bond > 0) {
368             questions[question_id].min_bond = min_bond;
369             emit LogMinimumBond(question_id, min_bond);
370         }
371 
372     }
373 
374     /// @notice Add funds to the bounty for a question
375     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
376     /// @param question_id The ID of the question you wish to fund
377     function fundAnswerBounty(bytes32 question_id) 
378         stateOpen(question_id)
379     external payable {
380         questions[question_id].bounty = questions[question_id].bounty + msg.value;
381         emit LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
382     }
383 
384     /// @notice Submit an answer for a question.
385     /// @dev Adds the answer to the history and updates the current "best" answer.
386     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
387     /// @param question_id The ID of the question
388     /// @param answer The answer, encoded into bytes32
389     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
390     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
391         stateOpen(question_id)
392         bondMustDoubleAndMatchMinimum(question_id)
393         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
394     external payable {
395         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
396         _updateCurrentAnswer(question_id, answer);
397     }
398 
399     /// @notice Submit an answer for a question, crediting it to the specified account.
400     /// @dev Adds the answer to the history and updates the current "best" answer.
401     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
402     /// @param question_id The ID of the question
403     /// @param answer The answer, encoded into bytes32
404     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
405     /// @param answerer The account to which the answer should be credited
406     function submitAnswerFor(bytes32 question_id, bytes32 answer, uint256 max_previous, address answerer)
407         stateOpen(question_id)
408         bondMustDoubleAndMatchMinimum(question_id)
409         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
410     external payable {
411         require(answerer != NULL_ADDRESS, "answerer must be non-zero");
412         _addAnswerToHistory(question_id, answer, answerer, msg.value, false);
413         _updateCurrentAnswer(question_id, answer);
414     }
415 
416     // @notice Verify and store a commitment, including an appropriate timeout
417     // @param question_id The ID of the question to store
418     // @param commitment The ID of the commitment
419     function _storeCommitment(bytes32 question_id, bytes32 commitment_id) 
420     internal
421     {
422         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
423 
424         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
425         commitments[commitment_id].reveal_ts = uint32(block.timestamp) + commitment_timeout;
426     }
427 
428     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
429     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
430     /// The commitment_id is stored in the answer history where the answer would normally go.
431     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
432     /// @param question_id The ID of the question
433     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
434     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
435     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
436     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
437     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
438         stateOpen(question_id)
439         bondMustDoubleAndMatchMinimum(question_id)
440         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
441     external payable {
442 
443         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, msg.value));
444         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
445         _storeCommitment(question_id, commitment_id);
446         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
447 
448     }
449 
450     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
451     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
452     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
453     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
454     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
455     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
456     /// @param question_id The ID of the question
457     /// @param answer The answer, encoded as bytes32
458     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
459     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
460     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
461         stateOpenOrPendingArbitration(question_id)
462     external {
463 
464         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
465         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
466 
467         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
468         require(commitments[commitment_id].reveal_ts > uint32(block.timestamp), "reveal deadline must not have passed");
469 
470         commitments[commitment_id].revealed_answer = answer;
471         commitments[commitment_id].is_revealed = true;
472 
473         if (bond == questions[question_id].bond) {
474             _updateCurrentAnswer(question_id, answer);
475         }
476 
477         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
478 
479     }
480 
481     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
482     internal 
483     {
484         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
485 
486         // Update the current bond level, if there's a bond (ie anything except arbitration)
487         if (bond > 0) {
488             questions[question_id].bond = bond;
489         }
490         questions[question_id].history_hash = new_history_hash;
491 
492         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, block.timestamp, is_commitment);
493     }
494 
495     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer)
496     internal {
497         questions[question_id].best_answer = answer;
498         questions[question_id].finalize_ts = uint32(block.timestamp) + questions[question_id].timeout;
499     }
500 
501     // Like _updateCurrentAnswer but without advancing the timeout
502     function _updateCurrentAnswerByArbitrator(bytes32 question_id, bytes32 answer)
503     internal {
504         questions[question_id].best_answer = answer;
505         questions[question_id].finalize_ts = uint32(block.timestamp);
506     }
507 
508     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
509     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
510     /// @param question_id The ID of the question
511     /// @param requester The account that requested arbitration
512     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
513     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
514         onlyArbitrator(question_id)
515         stateOpen(question_id)
516         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
517     external {
518         require(questions[question_id].finalize_ts > UNANSWERED, "Question must already have an answer when arbitration is requested");
519         questions[question_id].is_pending_arbitration = true;
520         emit LogNotifyOfArbitrationRequest(question_id, requester);
521     }
522 
523     /// @notice Cancel a previously-requested arbitration and extend the timeout
524     /// @dev Useful when doing arbitration across chains that can't be requested atomically
525     /// @param question_id The ID of the question
526     function cancelArbitration(bytes32 question_id) 
527         onlyArbitrator(question_id)
528         statePendingArbitration(question_id)
529     external {
530         questions[question_id].is_pending_arbitration = false;
531         questions[question_id].finalize_ts = uint32(block.timestamp) + questions[question_id].timeout;
532         emit LogCancelArbitration(question_id);
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
546     public {
547 
548         require(answerer != NULL_ADDRESS, "answerer must be provided");
549         emit LogFinalize(question_id, answer);
550 
551         questions[question_id].is_pending_arbitration = false;
552         _addAnswerToHistory(question_id, answer, answerer, 0, false);
553         _updateCurrentAnswerByArbitrator(question_id, answer);
554 
555     }
556 
557     /// @notice Submit the answer for a question, for use by the arbitrator, working out the appropriate winner based on the last answer details.
558     /// @dev Doesn't require (or allow) a bond.
559     /// @param question_id The ID of the question
560     /// @param answer The answer, encoded into bytes32
561     /// @param payee_if_wrong The account to by credited as winner if the last answer given is wrong, usually the account that paid the arbitrator
562     /// @param last_history_hash The history hash before the final one
563     /// @param last_answer_or_commitment_id The last answer given, or the commitment ID if it was a commitment.
564     /// @param last_answerer The address that supplied the last answer
565     function assignWinnerAndSubmitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address payee_if_wrong, bytes32 last_history_hash, bytes32 last_answer_or_commitment_id, address last_answerer) 
566     external {
567         bool is_commitment = _verifyHistoryInputOrRevert(questions[question_id].history_hash, last_history_hash, last_answer_or_commitment_id, questions[question_id].bond, last_answerer);
568 
569         address payee;
570         // If the last answer is an unrevealed commit, it's always wrong.
571         // For anything else, the last answer was set as the "best answer" in submitAnswer or submitAnswerReveal.
572         if (is_commitment && !commitments[last_answer_or_commitment_id].is_revealed) {
573             require(commitments[last_answer_or_commitment_id].reveal_ts < uint32(block.timestamp), "You must wait for the reveal deadline before finalizing");
574             payee = payee_if_wrong;
575         } else {
576             payee = (questions[question_id].best_answer == answer) ? last_answerer : payee_if_wrong;
577         }
578         submitAnswerByArbitrator(question_id, answer, payee);
579     }
580 
581 
582     /// @notice Report whether the answer to the specified question is finalized
583     /// @param question_id The ID of the question
584     /// @return Return true if finalized
585     function isFinalized(bytes32 question_id) 
586     view public returns (bool) {
587         uint32 finalize_ts = questions[question_id].finalize_ts;
588         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(block.timestamp)) );
589     }
590 
591     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
592     /// @param question_id The ID of the question
593     /// @return The answer formatted as a bytes32
594     function getFinalAnswer(bytes32 question_id) 
595         stateFinalized(question_id)
596     external view returns (bytes32) {
597         return questions[question_id].best_answer;
598     }
599 
600     /// @notice Return the final answer to the specified question, or revert if there isn't one
601     /// @param question_id The ID of the question
602     /// @return The answer formatted as a bytes32
603     function resultFor(bytes32 question_id) 
604         stateFinalized(question_id)
605     public view returns (bytes32) {
606         return questions[question_id].best_answer;
607     }
608 
609     /// @notice Returns whether the question was answered before it had an answer, ie resolved to UNRESOLVED_ANSWER
610     /// @param question_id The ID of the question 
611     function isSettledTooSoon(bytes32 question_id)
612     public view returns(bool) {
613         return (resultFor(question_id) == UNRESOLVED_ANSWER);
614     }
615 
616     /// @notice Like resultFor(), but errors out if settled too soon, or returns the result of a replacement if it was reopened at the right time and settled
617     /// @param question_id The ID of the question 
618     function resultForOnceSettled(bytes32 question_id)
619     external view returns(bytes32) {
620         bytes32 result = resultFor(question_id);
621         if (result == UNRESOLVED_ANSWER) {
622             // Try the replacement
623             bytes32 replacement_id = reopened_questions[question_id];
624             require(replacement_id != bytes32(0x0), "Question was settled too soon and has not been reopened");
625             // We only try one layer down rather than recursing to keep the gas costs predictable
626             result = resultFor(replacement_id);
627             require(result != UNRESOLVED_ANSWER, "Question replacement was settled too soon and has not been reopened");
628         }
629         return result;
630     }
631 
632     /// @notice Asks a new question reopening a previously-asked question that was settled too soon
633     /// @dev A special version of askQuestion() that replaces a previous question that was settled too soon
634     /// @param template_id The ID number of the template the question will use
635     /// @param question A string containing the parameters that will be passed into the template to make the question
636     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
637     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
638     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
639     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
640     /// @param min_bond The minimum bond that can be used to provide the first answer.
641     /// @param reopens_question_id The ID of the question this reopens
642     /// @return The ID of the newly-created question, created deterministically.
643     function reopenQuestion(uint256 template_id, string memory question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce, uint256 min_bond, bytes32 reopens_question_id)
644         // stateNotCreated is enforced by the internal _askQuestion
645     public payable returns (bytes32) {
646 
647         require(isSettledTooSoon(reopens_question_id), "You can only reopen questions that resolved as settled too soon");
648 
649         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
650 
651         // A reopening must exactly match the original question, except for the nonce and the creator
652         require(content_hash == questions[reopens_question_id].content_hash, "content hash mismatch");
653         require(arbitrator == questions[reopens_question_id].arbitrator, "arbitrator mismatch");
654         require(timeout == questions[reopens_question_id].timeout, "timeout mismatch");
655         require(opening_ts == questions[reopens_question_id].opening_ts , "opening_ts mismatch");
656         require(min_bond == questions[reopens_question_id].min_bond, "min_bond mismatch");
657 
658         // If the the question was itself reopening some previous question, you'll have to re-reopen the previous question first.
659         // This ensures the bounty can be passed on to the next attempt of the original question.
660         require(!reopener_questions[reopens_question_id], "Question is already reopening a previous question");
661 
662         // A question can only be reopened once, unless the reopening was also settled too soon in which case it can be replaced
663         bytes32 existing_reopen_question_id = reopened_questions[reopens_question_id];
664 
665         // Normally when we reopen a question we will take its bounty and pass it on to the reopened version.
666         bytes32 take_bounty_from_question_id = reopens_question_id;
667         // If the question has already been reopened but was again settled too soon, we can transfer its bounty to the next attempt.
668         if (existing_reopen_question_id != bytes32(0)) {
669             require(isSettledTooSoon(existing_reopen_question_id), "Question has already been reopened");
670             // We'll overwrite the reopening with our new question and move the bounty.
671             // Once that's done we'll detach the failed reopener and you'll be able to reopen that too if you really want, but without the bounty.
672             reopener_questions[existing_reopen_question_id] = false;
673             take_bounty_from_question_id = existing_reopen_question_id;
674         }
675 
676         bytes32 question_id = askQuestionWithMinBond(template_id, question, arbitrator, timeout, opening_ts, nonce, min_bond);
677 
678         reopened_questions[reopens_question_id] = question_id;
679         reopener_questions[question_id] = true;
680 
681         questions[question_id].bounty = questions[take_bounty_from_question_id].bounty + questions[question_id].bounty;
682         questions[take_bounty_from_question_id].bounty = 0;
683 
684         emit LogReopenQuestion(question_id, reopens_question_id);
685 
686         return question_id;
687     }
688 
689     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
690     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
691     /// @param question_id The ID of the question
692     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
693     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
694     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
695     /// @param min_bond The bond sent with the final answer must be this high or higher
696     /// @return The answer formatted as a bytes32
697     function getFinalAnswerIfMatches(
698         bytes32 question_id, 
699         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
700     ) 
701         stateFinalized(question_id)
702     external view returns (bytes32) {
703         require(content_hash == questions[question_id].content_hash, "content hash must match");
704         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
705         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
706         require(min_bond <= questions[question_id].bond, "bond must be high enough");
707         return questions[question_id].best_answer;
708     }
709 
710     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
711     /// Caller must provide the answer history, in reverse order
712     /// @dev Works up the chain and assign bonds to the person who gave the right answer
713     /// If someone gave the winning answer earlier, they must get paid from the higher bond
714     /// That means we can't pay out the bond added at n until we have looked at n-1
715     /// The first answer is authenticated by checking against the stored history_hash.
716     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
717     /// Once we get to a null hash we'll know we're done and there are no more answers.
718     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
719     /// @param question_id The ID of the question
720     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
721     /// @param addrs Last-to-first, the address of each answerer or commitment sender
722     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
723     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
724     function claimWinnings(
725         bytes32 question_id, 
726         bytes32[] memory history_hashes, address[] memory addrs, uint256[] memory bonds, bytes32[] memory answers
727     ) 
728         stateFinalized(question_id)
729     public {
730 
731         require(history_hashes.length > 0, "at least one history hash entry must be provided");
732 
733         // These are only set if we split our claim over multiple transactions.
734         address payee = question_claims[question_id].payee; 
735         uint256 last_bond = question_claims[question_id].last_bond; 
736         uint256 queued_funds = question_claims[question_id].queued_funds; 
737 
738         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
739         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
740         bytes32 last_history_hash = questions[question_id].history_hash;
741 
742         bytes32 best_answer = questions[question_id].best_answer;
743 
744         uint256 i;
745         for (i = 0; i < history_hashes.length; i++) {
746         
747             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
748             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
749             
750             queued_funds = queued_funds + last_bond; 
751             (queued_funds, payee) = _processHistoryItem(
752                 question_id, best_answer, queued_funds, payee, 
753                 addrs[i], bonds[i], answers[i], is_commitment);
754  
755             // Line the bond up for next time, when it will be added to somebody's queued_funds
756             last_bond = bonds[i];
757 
758             // Burn (just leave in contract balance) a fraction of all bonds except the final one.
759             // This creates a cost to increasing your own bond, which could be used to delay resolution maliciously
760             if (last_bond != questions[question_id].bond) {
761                 last_bond = last_bond - last_bond / BOND_CLAIM_FEE_PROPORTION;
762             }
763 
764             last_history_hash = history_hashes[i];
765 
766         }
767  
768         if (last_history_hash != NULL_HASH) {
769             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
770             // Persist the details so we can pick up later where we left off later.
771 
772             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
773             // (We always know who to pay unless all we saw were unrevealed commits)
774             if (payee != NULL_ADDRESS) {
775                 _payPayee(question_id, payee, queued_funds);
776                 queued_funds = 0;
777             }
778 
779             question_claims[question_id].payee = payee;
780             question_claims[question_id].last_bond = last_bond;
781             question_claims[question_id].queued_funds = queued_funds;
782         } else {
783             // There is nothing left below us so the payee can keep what remains
784             _payPayee(question_id, payee, queued_funds + last_bond);
785             delete question_claims[question_id];
786         }
787 
788         questions[question_id].history_hash = last_history_hash;
789 
790     }
791 
792     function _payPayee(bytes32 question_id, address payee, uint256 value) 
793     internal {
794         balanceOf[payee] = balanceOf[payee] + value;
795         emit LogClaim(question_id, payee, value);
796     }
797 
798     function _verifyHistoryInputOrRevert(
799         bytes32 last_history_hash,
800         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
801     )
802     internal pure returns (bool) {
803         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
804             return true;
805         }
806         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
807             return false;
808         } 
809         revert("History input provided did not match the expected hash");
810     }
811 
812     function _processHistoryItem(
813         bytes32 question_id, bytes32 best_answer, 
814         uint256 queued_funds, address payee, 
815         address addr, uint256 bond, bytes32 answer, bool is_commitment
816     )
817     internal returns (uint256, address) {
818 
819         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
820         // We look at the referenced commitment ID and switch in the actual answer.
821         if (is_commitment) {
822             bytes32 commitment_id = answer;
823             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
824             if (!commitments[commitment_id].is_revealed) {
825                 delete commitments[commitment_id];
826                 return (queued_funds, payee);
827             } else {
828                 answer = commitments[commitment_id].revealed_answer;
829                 delete commitments[commitment_id];
830             }
831         }
832 
833         if (answer == best_answer) {
834 
835             if (payee == NULL_ADDRESS) {
836 
837                 // The entry is for the first payee we come to, ie the winner.
838                 // They get the question bounty.
839                 payee = addr;
840 
841                 if (best_answer != UNRESOLVED_ANSWER && questions[question_id].bounty > 0) {
842                     _payPayee(question_id, payee, questions[question_id].bounty);
843                     questions[question_id].bounty = 0;
844                 }
845 
846             } else if (addr != payee) {
847 
848                 // Answerer has changed, ie we found someone lower down who needs to be paid
849 
850                 // The lower answerer will take over receiving bonds from higher answerer.
851                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
852                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
853 
854                 // There should be enough for the fee, but if not, take what we have.
855                 // There's an edge case involving weird arbitrator behaviour where we may be short.
856                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
857                 // Settle up with the old (higher-bonded) payee
858                 _payPayee(question_id, payee, queued_funds - answer_takeover_fee);
859 
860                 // Now start queued_funds again for the new (lower-bonded) payee
861                 payee = addr;
862                 queued_funds = answer_takeover_fee;
863 
864             }
865 
866         }
867 
868         return (queued_funds, payee);
869 
870     }
871 
872     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
873     /// Caller must provide the answer history for each question, in reverse order
874     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
875     /// @param question_ids The IDs of the questions you want to claim for
876     /// @param lengths The number of history entries you will supply for each question ID
877     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
878     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
879     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
880     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
881     function claimMultipleAndWithdrawBalance(
882         bytes32[] memory question_ids, uint256[] memory lengths, 
883         bytes32[] memory hist_hashes, address[] memory addrs, uint256[] memory bonds, bytes32[] memory answers
884     ) 
885         stateAny() // The finalization checks are done in the claimWinnings function
886     public {
887         
888         uint256 qi;
889         uint256 i;
890         for (qi = 0; qi < question_ids.length; qi++) {
891             bytes32 qid = question_ids[qi];
892             uint256 ln = lengths[qi];
893             bytes32[] memory hh = new bytes32[](ln);
894             address[] memory ad = new address[](ln);
895             uint256[] memory bo = new uint256[](ln);
896             bytes32[] memory an = new bytes32[](ln);
897             uint256 j;
898             for (j = 0; j < ln; j++) {
899                 hh[j] = hist_hashes[i];
900                 ad[j] = addrs[i];
901                 bo[j] = bonds[i];
902                 an[j] = answers[i];
903                 i++;
904             }
905             claimWinnings(qid, hh, ad, bo, an);
906         }
907         withdraw();
908     }
909 
910     /// @notice Returns the questions's content hash, identifying the question content
911     /// @param question_id The ID of the question 
912     function getContentHash(bytes32 question_id) 
913     public view returns(bytes32) {
914         return questions[question_id].content_hash;
915     }
916 
917     /// @notice Returns the arbitrator address for the question
918     /// @param question_id The ID of the question 
919     function getArbitrator(bytes32 question_id) 
920     public view returns(address) {
921         return questions[question_id].arbitrator;
922     }
923 
924     /// @notice Returns the timestamp when the question can first be answered
925     /// @param question_id The ID of the question 
926     function getOpeningTS(bytes32 question_id) 
927     public view returns(uint32) {
928         return questions[question_id].opening_ts;
929     }
930 
931     /// @notice Returns the timeout in seconds used after each answer
932     /// @param question_id The ID of the question 
933     function getTimeout(bytes32 question_id) 
934     public view returns(uint32) {
935         return questions[question_id].timeout;
936     }
937 
938     /// @notice Returns the timestamp at which the question will be/was finalized
939     /// @param question_id The ID of the question 
940     function getFinalizeTS(bytes32 question_id) 
941     public view returns(uint32) {
942         return questions[question_id].finalize_ts;
943     }
944 
945     /// @notice Returns whether the question is pending arbitration
946     /// @param question_id The ID of the question 
947     function isPendingArbitration(bytes32 question_id) 
948     public view returns(bool) {
949         return questions[question_id].is_pending_arbitration;
950     }
951 
952     /// @notice Returns the current total unclaimed bounty
953     /// @dev Set back to zero once the bounty has been claimed
954     /// @param question_id The ID of the question 
955     function getBounty(bytes32 question_id) 
956     public view returns(uint256) {
957         return questions[question_id].bounty;
958     }
959 
960     /// @notice Returns the current best answer
961     /// @param question_id The ID of the question 
962     function getBestAnswer(bytes32 question_id) 
963     public view returns(bytes32) {
964         return questions[question_id].best_answer;
965     }
966 
967     /// @notice Returns the history hash of the question 
968     /// @param question_id The ID of the question 
969     /// @dev Updated on each answer, then rewound as each is claimed
970     function getHistoryHash(bytes32 question_id) 
971     public view returns(bytes32) {
972         return questions[question_id].history_hash;
973     }
974 
975     /// @notice Returns the highest bond posted so far for a question
976     /// @param question_id The ID of the question 
977     function getBond(bytes32 question_id) 
978     public view returns(uint256) {
979         return questions[question_id].bond;
980     }
981 
982     /// @notice Returns the minimum bond that can answer the question
983     /// @param question_id The ID of the question
984     function getMinBond(bytes32 question_id)
985     public view returns(uint256) {
986         return questions[question_id].min_bond;
987     }
988 
989 }