1 pragma solidity 0.4.18;
2 
3 library SafeMath32 {
4   function add(uint32 a, uint32 b) internal pure returns (uint32) {
5     uint32 c = a + b;
6     assert(c >= a);
7     return c;
8   }
9 }
10 
11 library SafeMath {
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
39 
40 contract BalanceHolder {
41 
42     mapping(address => uint256) public balanceOf;
43 
44     event LogWithdraw(
45         address indexed user,
46         uint256 amount
47     );
48 
49     function withdraw() 
50     public {
51         uint256 bal = balanceOf[msg.sender];
52         balanceOf[msg.sender] = 0;
53         msg.sender.transfer(bal);
54         LogWithdraw(msg.sender, bal);
55     }
56 
57 }
58 
59 contract RealityCheck is BalanceHolder {
60 
61     using SafeMath for uint256;
62     using SafeMath32 for uint32;
63 
64     address constant NULL_ADDRESS = address(0);
65 
66     // History hash when no history is created, or history has been cleared
67     bytes32 constant NULL_HASH = bytes32(0);
68 
69     // An unitinalized finalize_ts for a question will indicate an unanswered question.
70     uint32 constant UNANSWERED = 0;
71 
72     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
73     uint256 constant COMMITMENT_NON_EXISTENT = 0;
74 
75     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
76     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
77 
78     event LogSetQuestionFee(
79         address arbitrator,
80         uint256 amount
81     );
82 
83     event LogNewTemplate(
84         uint256 indexed template_id,
85         address indexed user, 
86         string question_text
87     );
88 
89     event LogNewQuestion(
90         bytes32 indexed question_id,
91         address indexed user, 
92         uint256 template_id,
93         string question,
94         bytes32 indexed content_hash,
95         address arbitrator, 
96         uint32 timeout,
97         uint32 opening_ts,
98         uint256 nonce,
99         uint256 created
100     );
101 
102     event LogFundAnswerBounty(
103         bytes32 indexed question_id,
104         uint256 bounty_added,
105         uint256 bounty,
106         address indexed user 
107     );
108 
109     event LogNewAnswer(
110         bytes32 answer,
111         bytes32 indexed question_id,
112         bytes32 history_hash,
113         address indexed user,
114         uint256 bond,
115         uint256 ts,
116         bool is_commitment
117     );
118 
119     event LogAnswerReveal(
120         bytes32 indexed question_id, 
121         address indexed user, 
122         bytes32 indexed answer_hash, 
123         bytes32 answer, 
124         uint256 nonce, 
125         uint256 bond
126     );
127 
128     event LogNotifyOfArbitrationRequest(
129         bytes32 indexed question_id,
130         address indexed user 
131     );
132 
133     event LogFinalize(
134         bytes32 indexed question_id,
135         bytes32 indexed answer
136     );
137 
138     event LogClaim(
139         bytes32 indexed question_id,
140         address indexed user,
141         uint256 amount
142     );
143 
144     struct Question {
145         bytes32 content_hash;
146         address arbitrator;
147         uint32 opening_ts;
148         uint32 timeout;
149         uint32 finalize_ts;
150         bool is_pending_arbitration;
151         uint256 bounty;
152         bytes32 best_answer;
153         bytes32 history_hash;
154         uint256 bond;
155     }
156 
157     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
158     struct Commitment {
159         uint32 reveal_ts;
160         bool is_revealed;
161         bytes32 revealed_answer;
162     }
163 
164     // Only used when claiming more bonds than fits into a transaction
165     // Stored in a mapping indexed by question_id.
166     struct Claim {
167         address payee;
168         uint256 last_bond;
169         uint256 queued_funds;
170     }
171 
172     uint256 nextTemplateID = 0;
173     mapping(uint256 => uint256) public templates;
174     mapping(uint256 => bytes32) public template_hashes;
175     mapping(bytes32 => Question) public questions;
176     mapping(bytes32 => Claim) question_claims;
177     mapping(bytes32 => Commitment) public commitments;
178     mapping(address => uint256) public arbitrator_question_fees; 
179 
180     modifier onlyArbitrator(bytes32 question_id) {
181         require(msg.sender == questions[question_id].arbitrator);
182         _;
183     }
184 
185     modifier stateAny() {
186         _;
187     }
188 
189     modifier stateNotCreated(bytes32 question_id) {
190         require(questions[question_id].timeout == 0);
191         _;
192     }
193 
194     modifier stateOpen(bytes32 question_id) {
195         require(questions[question_id].timeout > 0); // Check existence
196         require(!questions[question_id].is_pending_arbitration);
197         uint32 finalize_ts = questions[question_id].finalize_ts;
198         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now));
199         uint32 opening_ts = questions[question_id].opening_ts;
200         require(opening_ts == 0 || opening_ts <= uint32(now)); 
201         _;
202     }
203 
204     modifier statePendingArbitration(bytes32 question_id) {
205         require(questions[question_id].is_pending_arbitration);
206         _;
207     }
208 
209     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
210         require(questions[question_id].timeout > 0); // Check existence
211         uint32 finalize_ts = questions[question_id].finalize_ts;
212         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now));
213         uint32 opening_ts = questions[question_id].opening_ts;
214         require(opening_ts == 0 || opening_ts <= uint32(now)); 
215         _;
216     }
217 
218     modifier stateFinalized(bytes32 question_id) {
219         require(isFinalized(question_id));
220         _;
221     }
222 
223     modifier bondMustBeZero() {
224         require(msg.value == 0);
225         _;
226     }
227 
228     modifier bondMustDouble(bytes32 question_id) {
229         require(msg.value > 0); 
230         require(msg.value >= (questions[question_id].bond.mul(2)));
231         _;
232     }
233 
234     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
235         if (max_previous > 0) {
236             require(questions[question_id].bond <= max_previous);
237         }
238         _;
239     }
240 
241     /// @notice Constructor, sets up some initial templates
242     /// @dev Creates some generalized templates for different question types used in the DApp.
243     function RealityCheck() 
244     public {
245         createTemplate('{"title": "%s", "type": "bool", "category": "%s"}');
246         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s"}');
247         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s"}');
248         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s"}');
249         createTemplate('{"title": "%s", "type": "datetime", "category": "%s"}');
250     }
251 
252     /// @notice Function for arbitrator to set an optional per-question fee. 
253     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
254     /// @param fee The fee to be charged by the arbitrator when a question is asked
255     function setQuestionFee(uint256 fee) 
256         stateAny() 
257     external {
258         arbitrator_question_fees[msg.sender] = fee;
259         LogSetQuestionFee(msg.sender, fee);
260     }
261 
262     /// @notice Create a reusable template, which should be a JSON document.
263     /// Placeholders should use gettext() syntax, eg %s.
264     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
265     /// @param content The template content
266     /// @return The ID of the newly-created template, which is created sequentially.
267     function createTemplate(string content) 
268         stateAny()
269     public returns (uint256) {
270         uint256 id = nextTemplateID;
271         templates[id] = block.number;
272         template_hashes[id] = keccak256(content);
273         LogNewTemplate(id, msg.sender, content);
274         nextTemplateID = id.add(1);
275         return id;
276     }
277 
278     /// @notice Create a new reusable template and use it to ask a question
279     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
280     /// @param content The template content
281     /// @param question A string containing the parameters that will be passed into the template to make the question
282     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
283     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
284     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
285     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
286     /// @return The ID of the newly-created template, which is created sequentially.
287     function createTemplateAndAskQuestion(
288         string content, 
289         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
290     ) 
291         // stateNotCreated is enforced by the internal _askQuestion
292     public payable returns (bytes32) {
293         uint256 template_id = createTemplate(content);
294         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
295     }
296 
297     /// @notice Ask a new question and return the ID
298     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
299     /// @param template_id The ID number of the template the question will use
300     /// @param question A string containing the parameters that will be passed into the template to make the question
301     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
302     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
303     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
304     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
305     /// @return The ID of the newly-created question, created deterministically.
306     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
307         // stateNotCreated is enforced by the internal _askQuestion
308     public payable returns (bytes32) {
309 
310         require(templates[template_id] > 0); // Template must exist
311 
312         bytes32 content_hash = keccak256(template_id, opening_ts, question);
313         bytes32 question_id = keccak256(content_hash, arbitrator, timeout, msg.sender, nonce);
314 
315         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
316         LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
317 
318         return question_id;
319     }
320 
321     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
322         stateNotCreated(question_id)
323     internal {
324 
325         // A timeout of 0 makes no sense, and we will use this to check existence
326         require(timeout > 0); 
327         require(timeout < 365 days); 
328         require(arbitrator != NULL_ADDRESS);
329 
330         uint256 bounty = msg.value;
331 
332         // The arbitrator can set a fee for asking a question. 
333         // This is intended as an anti-spam defence.
334         // The fee is waived if the arbitrator is asking the question.
335         // This allows them to set an impossibly high fee and make users proxy the question through them.
336         // This would allow more sophisticated pricing, question whitelisting etc.
337         if (msg.sender != arbitrator) {
338             uint256 question_fee = arbitrator_question_fees[arbitrator];
339             require(bounty >= question_fee); 
340             bounty = bounty.sub(question_fee);
341             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
342         }
343 
344         questions[question_id].content_hash = content_hash;
345         questions[question_id].arbitrator = arbitrator;
346         questions[question_id].opening_ts = opening_ts;
347         questions[question_id].timeout = timeout;
348         questions[question_id].bounty = bounty;
349 
350     }
351 
352     /// @notice Add funds to the bounty for a question
353     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
354     /// @param question_id The ID of the question you wish to fund
355     function fundAnswerBounty(bytes32 question_id) 
356         stateOpen(question_id)
357     external payable {
358         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
359         LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
360     }
361 
362     /// @notice Submit an answer for a question.
363     /// @dev Adds the answer to the history and updates the current "best" answer.
364     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
365     /// @param question_id The ID of the question
366     /// @param answer The answer, encoded into bytes32
367     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
368     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
369         stateOpen(question_id)
370         bondMustDouble(question_id)
371         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
372     external payable {
373         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
374         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
375     }
376 
377     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
378     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
379     /// The commitment_id is stored in the answer history where the answer would normally go.
380     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
381     /// @param question_id The ID of the question
382     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
383     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
384     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
385     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
386     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
387         stateOpen(question_id)
388         bondMustDouble(question_id)
389         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
390     external payable {
391 
392         bytes32 commitment_id = keccak256(question_id, answer_hash, msg.value);
393         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
394 
395         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT);
396 
397         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
398         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
399 
400         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
401 
402     }
403 
404     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
405     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
406     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
407     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
408     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
409     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
410     /// @param question_id The ID of the question
411     /// @param answer The answer, encoded as bytes32
412     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
413     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
414     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
415         stateOpenOrPendingArbitration(question_id)
416     external {
417 
418         bytes32 answer_hash = keccak256(answer, nonce);
419         bytes32 commitment_id = keccak256(question_id, answer_hash, bond);
420 
421         require(!commitments[commitment_id].is_revealed);
422         require(commitments[commitment_id].reveal_ts > uint32(now)); // Reveal deadline must not have passed
423 
424         commitments[commitment_id].revealed_answer = answer;
425         commitments[commitment_id].is_revealed = true;
426 
427         if (bond == questions[question_id].bond) {
428             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
429         }
430 
431         LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
432 
433     }
434 
435     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
436     internal 
437     {
438         bytes32 new_history_hash = keccak256(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment);
439 
440         questions[question_id].bond = bond;
441         questions[question_id].history_hash = new_history_hash;
442 
443         LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
444     }
445 
446     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
447     internal {
448         questions[question_id].best_answer = answer;
449         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
450     }
451 
452     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
453     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
454     /// @param question_id The ID of the question
455     /// @param requester The account that requested arbitration
456     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
457     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
458         onlyArbitrator(question_id)
459         stateOpen(question_id)
460         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
461     external {
462         questions[question_id].is_pending_arbitration = true;
463         LogNotifyOfArbitrationRequest(question_id, requester);
464     }
465 
466     /// @notice Submit the answer for a question, for use by the arbitrator.
467     /// @dev Doesn't require (or allow) a bond.
468     /// If the current final answer is correct, the account should be whoever submitted it.
469     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
470     /// However, the answerer stipulations are not enforced by the contract.
471     /// @param question_id The ID of the question
472     /// @param answer The answer, encoded into bytes32
473     /// @param answerer The account credited with this answer for the purpose of bond claims
474     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
475         onlyArbitrator(question_id)
476         statePendingArbitration(question_id)
477         bondMustBeZero
478     external {
479 
480         require(answerer != NULL_ADDRESS);
481         LogFinalize(question_id, answer);
482 
483         questions[question_id].is_pending_arbitration = false;
484         _addAnswerToHistory(question_id, answer, answerer, 0, false);
485         _updateCurrentAnswer(question_id, answer, 0);
486 
487     }
488 
489     /// @notice Report whether the answer to the specified question is finalized
490     /// @param question_id The ID of the question
491     /// @return Return true if finalized
492     function isFinalized(bytes32 question_id) 
493     constant public returns (bool) {
494         uint32 finalize_ts = questions[question_id].finalize_ts;
495         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
496     }
497 
498     /// @notice Return the final answer to the specified question, or revert if there isn't one
499     /// @param question_id The ID of the question
500     /// @return The answer formatted as a bytes32
501     function getFinalAnswer(bytes32 question_id) 
502         stateFinalized(question_id)
503     external constant returns (bytes32) {
504         return questions[question_id].best_answer;
505     }
506 
507     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
508     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
509     /// @param question_id The ID of the question
510     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
511     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
512     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
513     /// @param min_bond The bond sent with the final answer must be this high or higher
514     /// @return The answer formatted as a bytes32
515     function getFinalAnswerIfMatches(
516         bytes32 question_id, 
517         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
518     ) 
519         stateFinalized(question_id)
520     external constant returns (bytes32) {
521         require(content_hash == questions[question_id].content_hash);
522         require(arbitrator == questions[question_id].arbitrator);
523         require(min_timeout <= questions[question_id].timeout);
524         require(min_bond <= questions[question_id].bond);
525         return questions[question_id].best_answer;
526     }
527 
528     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
529     /// Caller must provide the answer history, in reverse order
530     /// @dev Works up the chain and assign bonds to the person who gave the right answer
531     /// If someone gave the winning answer earlier, they must get paid from the higher bond
532     /// That means we can't pay out the bond added at n until we have looked at n-1
533     /// The first answer is authenticated by checking against the stored history_hash.
534     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
535     /// Once we get to a null hash we'll know we're done and there are no more answers.
536     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
537     /// @param question_id The ID of the question
538     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
539     /// @param addrs Last-to-first, the address of each answerer or commitment sender
540     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
541     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
542     function claimWinnings(
543         bytes32 question_id, 
544         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
545     ) 
546         stateFinalized(question_id)
547     public {
548 
549         require(history_hashes.length > 0);
550 
551         // These are only set if we split our claim over multiple transactions.
552         address payee = question_claims[question_id].payee; 
553         uint256 last_bond = question_claims[question_id].last_bond; 
554         uint256 queued_funds = question_claims[question_id].queued_funds; 
555 
556         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
557         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
558         bytes32 last_history_hash = questions[question_id].history_hash;
559 
560         bytes32 best_answer = questions[question_id].best_answer;
561 
562         uint256 i;
563         for (i = 0; i < history_hashes.length; i++) {
564         
565             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
566             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
567             
568             queued_funds = queued_funds.add(last_bond); 
569             (queued_funds, payee) = _processHistoryItem(
570                 question_id, best_answer, queued_funds, payee, 
571                 addrs[i], bonds[i], answers[i], is_commitment);
572  
573             // Line the bond up for next time, when it will be added to somebody's queued_funds
574             last_bond = bonds[i];
575             last_history_hash = history_hashes[i];
576 
577         }
578  
579         if (last_history_hash != NULL_HASH) {
580             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
581             // Persist the details so we can pick up later where we left off later.
582 
583             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
584             // (We always know who to pay unless all we saw were unrevealed commits)
585             if (payee != NULL_ADDRESS) {
586                 _payPayee(question_id, payee, queued_funds);
587                 queued_funds = 0;
588             }
589 
590             question_claims[question_id].payee = payee;
591             question_claims[question_id].last_bond = last_bond;
592             question_claims[question_id].queued_funds = queued_funds;
593         } else {
594             // There is nothing left below us so the payee can keep what remains
595             _payPayee(question_id, payee, queued_funds.add(last_bond));
596             delete question_claims[question_id];
597         }
598 
599         questions[question_id].history_hash = last_history_hash;
600 
601     }
602 
603     function _payPayee(bytes32 question_id, address payee, uint256 value) 
604     internal {
605         balanceOf[payee] = balanceOf[payee].add(value);
606         LogClaim(question_id, payee, value);
607     }
608 
609     function _verifyHistoryInputOrRevert(
610         bytes32 last_history_hash,
611         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
612     )
613     internal pure returns (bool) {
614         if (last_history_hash == keccak256(history_hash, answer, bond, addr, true) ) {
615             return true;
616         }
617         if (last_history_hash == keccak256(history_hash, answer, bond, addr, false) ) {
618             return false;
619         } 
620         revert();
621     }
622 
623     function _processHistoryItem(
624         bytes32 question_id, bytes32 best_answer, 
625         uint256 queued_funds, address payee, 
626         address addr, uint256 bond, bytes32 answer, bool is_commitment
627     )
628     internal returns (uint256, address) {
629 
630         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
631         // We look at the referenced commitment ID and switch in the actual answer.
632         if (is_commitment) {
633             bytes32 commitment_id = answer;
634             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
635             if (!commitments[commitment_id].is_revealed) {
636                 delete commitments[commitment_id];
637                 return (queued_funds, payee);
638             } else {
639                 answer = commitments[commitment_id].revealed_answer;
640                 delete commitments[commitment_id];
641             }
642         }
643 
644         if (answer == best_answer) {
645 
646             if (payee == NULL_ADDRESS) {
647 
648                 // The entry is for the first payee we come to, ie the winner.
649                 // They get the question bounty.
650                 payee = addr;
651                 queued_funds = queued_funds.add(questions[question_id].bounty);
652                 questions[question_id].bounty = 0;
653 
654             } else if (addr != payee) {
655 
656                 // Answerer has changed, ie we found someone lower down who needs to be paid
657 
658                 // The lower answerer will take over receiving bonds from higher answerer.
659                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
660                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
661 
662                 // There should be enough for the fee, but if not, take what we have.
663                 // There's an edge case involving weird arbitrator behaviour where we may be short.
664                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
665 
666                 // Settle up with the old (higher-bonded) payee
667                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
668 
669                 // Now start queued_funds again for the new (lower-bonded) payee
670                 payee = addr;
671                 queued_funds = answer_takeover_fee;
672 
673             }
674 
675         }
676 
677         return (queued_funds, payee);
678 
679     }
680 
681     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
682     /// Caller must provide the answer history for each question, in reverse order
683     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
684     /// @param question_ids The IDs of the questions you want to claim for
685     /// @param lengths The number of history entries you will supply for each question ID
686     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
687     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
688     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
689     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
690     function claimMultipleAndWithdrawBalance(
691         bytes32[] question_ids, uint256[] lengths, 
692         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
693     ) 
694         stateAny() // The finalization checks are done in the claimWinnings function
695     public {
696         
697         uint256 qi;
698         uint256 i;
699         for (qi = 0; qi < question_ids.length; qi++) {
700             bytes32 qid = question_ids[qi];
701             uint256 ln = lengths[qi];
702             bytes32[] memory hh = new bytes32[](ln);
703             address[] memory ad = new address[](ln);
704             uint256[] memory bo = new uint256[](ln);
705             bytes32[] memory an = new bytes32[](ln);
706             uint256 j;
707             for (j = 0; j < ln; j++) {
708                 hh[j] = hist_hashes[i];
709                 ad[j] = addrs[i];
710                 bo[j] = bonds[i];
711                 an[j] = answers[i];
712                 i++;
713             }
714             claimWinnings(qid, hh, ad, bo, an);
715         }
716         withdraw();
717     }
718 }