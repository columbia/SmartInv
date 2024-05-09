1 pragma solidity ^0.4.18;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     function Owned() 
8     public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) 
18         onlyOwner 
19     public {
20         owner = newOwner;
21     }
22 }
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 library SafeMath32 {
59   function add(uint32 a, uint32 b) internal pure returns (uint32) {
60     uint32 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 }
65 
66 contract BalanceHolder {
67 
68     mapping(address => uint256) public balanceOf;
69 
70     event LogWithdraw(
71         address indexed user,
72         uint256 amount
73     );
74 
75     function withdraw() 
76     public {
77         uint256 bal = balanceOf[msg.sender];
78         balanceOf[msg.sender] = 0;
79         msg.sender.transfer(bal);
80         LogWithdraw(msg.sender, bal);
81     }
82 
83 }
84 
85 
86 contract RealityCheck is BalanceHolder {
87 
88     using SafeMath for uint256;
89     using SafeMath32 for uint32;
90 
91     address constant NULL_ADDRESS = address(0);
92 
93     // History hash when no history is created, or history has been cleared
94     bytes32 constant NULL_HASH = bytes32(0);
95 
96     // An unitinalized finalize_ts for a question will indicate an unanswered question.
97     uint32 constant UNANSWERED = 0;
98 
99     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
100     uint256 constant COMMITMENT_NON_EXISTENT = 0;
101 
102     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
103     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
104 
105     event LogSetQuestionFee(
106         address arbitrator,
107         uint256 amount
108     );
109 
110     event LogNewTemplate(
111         uint256 indexed template_id,
112         address indexed user, 
113         string question_text
114     );
115 
116     event LogNewQuestion(
117         bytes32 indexed question_id,
118         address indexed user, 
119         uint256 template_id,
120         string question,
121         bytes32 indexed content_hash,
122         address arbitrator, 
123         uint32 timeout,
124         uint32 opening_ts,
125         uint256 nonce,
126         uint256 created
127     );
128 
129     event LogFundAnswerBounty(
130         bytes32 indexed question_id,
131         uint256 bounty_added,
132         uint256 bounty,
133         address indexed user 
134     );
135 
136     event LogNewAnswer(
137         bytes32 answer,
138         bytes32 indexed question_id,
139         bytes32 history_hash,
140         address indexed user,
141         uint256 bond,
142         uint256 ts,
143         bool is_commitment
144     );
145 
146     event LogAnswerReveal(
147         bytes32 indexed question_id, 
148         address indexed user, 
149         bytes32 indexed answer_hash, 
150         bytes32 answer, 
151         uint256 nonce, 
152         uint256 bond
153     );
154 
155     event LogNotifyOfArbitrationRequest(
156         bytes32 indexed question_id,
157         address indexed user 
158     );
159 
160     event LogFinalize(
161         bytes32 indexed question_id,
162         bytes32 indexed answer
163     );
164 
165     event LogClaim(
166         bytes32 indexed question_id,
167         address indexed user,
168         uint256 amount
169     );
170 
171     struct Question {
172         bytes32 content_hash;
173         address arbitrator;
174         uint32 opening_ts;
175         uint32 timeout;
176         uint32 finalize_ts;
177         bool is_pending_arbitration;
178         uint256 bounty;
179         bytes32 best_answer;
180         bytes32 history_hash;
181         uint256 bond;
182     }
183 
184     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
185     struct Commitment {
186         uint32 reveal_ts;
187         bool is_revealed;
188         bytes32 revealed_answer;
189     }
190 
191     // Only used when claiming more bonds than fits into a transaction
192     // Stored in a mapping indexed by question_id.
193     struct Claim {
194         address payee;
195         uint256 last_bond;
196         uint256 queued_funds;
197     }
198 
199     uint256 nextTemplateID = 0;
200     mapping(uint256 => uint256) public templates;
201     mapping(bytes32 => Question) public questions;
202     mapping(bytes32 => Claim) question_claims;
203     mapping(bytes32 => Commitment) public commitments;
204     mapping(address => uint256) public arbitrator_question_fees; 
205 
206     modifier onlyArbitrator(bytes32 question_id) {
207         require(msg.sender == questions[question_id].arbitrator);
208         _;
209     }
210 
211     modifier stateAny() {
212         _;
213     }
214 
215     modifier stateNotCreated(bytes32 question_id) {
216         require(questions[question_id].timeout == 0);
217         _;
218     }
219 
220     modifier stateOpen(bytes32 question_id) {
221         require(questions[question_id].timeout > 0); // Check existence
222         require(!questions[question_id].is_pending_arbitration);
223         uint32 finalize_ts = questions[question_id].finalize_ts;
224         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now));
225         uint32 opening_ts = questions[question_id].opening_ts;
226         require(opening_ts == 0 || opening_ts <= uint32(now)); 
227         _;
228     }
229 
230     modifier statePendingArbitration(bytes32 question_id) {
231         require(questions[question_id].is_pending_arbitration);
232         _;
233     }
234 
235     modifier stateFinalized(bytes32 question_id) {
236         require(isFinalized(question_id));
237         _;
238     }
239 
240     modifier bondMustBeZero() {
241         require(msg.value == 0);
242         _;
243     }
244 
245     modifier bondMustDouble(bytes32 question_id) {
246         require(msg.value > 0); 
247         require(msg.value >= (questions[question_id].bond.mul(2)));
248         _;
249     }
250 
251     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
252         if (max_previous > 0) {
253             require(questions[question_id].bond <= max_previous);
254         }
255         _;
256     }
257 
258     /// @notice Constructor, sets up some initial templates
259     /// @dev Creates some generalized templates for different question types used in the DApp.
260     function RealityCheck() 
261     public {
262         createTemplate('{"title": "%s", "type": "bool", "category": "%s"}');
263         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s"}');
264         createTemplate('{"title": "%s", "type": "int", "decimals": 18, "category": "%s"}');
265         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s"}');
266         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s"}');
267         createTemplate('{"title": "%s", "type": "datetime", "category": "%s"}');
268     }
269 
270     /// @notice Function for arbitrator to set an optional per-question fee. 
271     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
272     /// @param fee The fee to be charged by the arbitrator when a question is asked
273     function setQuestionFee(uint256 fee) 
274         stateAny() 
275     external {
276         arbitrator_question_fees[msg.sender] = fee;
277         LogSetQuestionFee(msg.sender, fee);
278     }
279 
280     /// @notice Create a reusable template, which should be a JSON document.
281     /// Placeholders should use gettext() syntax, eg %s.
282     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
283     /// @param content The template content
284     /// @return The ID of the newly-created template, which is created sequentially.
285     function createTemplate(string content) 
286         stateAny()
287     public returns (uint256) {
288         uint256 id = nextTemplateID;
289         templates[id] = block.number;
290         LogNewTemplate(id, msg.sender, content);
291         nextTemplateID = id.add(1);
292         return id;
293     }
294 
295     /// @notice Create a new reusable template and use it to ask a question
296     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
297     /// @param content The template content
298     /// @param question A string containing the parameters that will be passed into the template to make the question
299     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
300     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
301     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
302     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
303     /// @return The ID of the newly-created template, which is created sequentially.
304     function createTemplateAndAskQuestion(
305         string content, 
306         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
307     ) 
308         // stateNotCreated is enforced by the internal _askQuestion
309     public payable returns (bytes32) {
310         uint256 template_id = createTemplate(content);
311         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
312     }
313 
314     /// @notice Ask a new question and return the ID
315     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
316     /// @param template_id The ID number of the template the question will use
317     /// @param question A string containing the parameters that will be passed into the template to make the question
318     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
319     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
320     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
321     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
322     /// @return The ID of the newly-created question, created deterministically.
323     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
324         // stateNotCreated is enforced by the internal _askQuestion
325     public payable returns (bytes32) {
326 
327         require(templates[template_id] > 0); // Template must exist
328 
329         bytes32 content_hash = keccak256(template_id, opening_ts, question);
330         bytes32 question_id = keccak256(content_hash, arbitrator, timeout, msg.sender, nonce);
331 
332         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
333         LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
334 
335         return question_id;
336     }
337 
338     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
339         stateNotCreated(question_id)
340     internal {
341 
342         // A timeout of 0 makes no sense, and we will use this to check existence
343         require(timeout > 0); 
344         require(timeout < 365 days); 
345         require(arbitrator != NULL_ADDRESS);
346 
347         uint256 bounty = msg.value;
348 
349         // The arbitrator can set a fee for asking a question. 
350         // This is intended as an anti-spam defence.
351         // The fee is waived if the arbitrator is asking the question.
352         // This allows them to set an impossibly high fee and make users proxy the question through them.
353         // This would allow more sophisticated pricing, question whitelisting etc.
354         if (msg.sender != arbitrator) {
355             uint256 question_fee = arbitrator_question_fees[arbitrator];
356             require(bounty >= question_fee); 
357             bounty = bounty.sub(question_fee);
358             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
359         }
360 
361         questions[question_id].content_hash = content_hash;
362         questions[question_id].arbitrator = arbitrator;
363         questions[question_id].opening_ts = opening_ts;
364         questions[question_id].timeout = timeout;
365         questions[question_id].bounty = bounty;
366 
367     }
368 
369     /// @notice Add funds to the bounty for a question
370     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
371     /// @param question_id The ID of the question you wish to fund
372     function fundAnswerBounty(bytes32 question_id) 
373         stateOpen(question_id)
374     external payable {
375         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
376         LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
377     }
378 
379     /// @notice Submit an answer for a question.
380     /// @dev Adds the answer to the history and updates the current "best" answer.
381     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
382     /// @param question_id The ID of the question
383     /// @param answer The answer, encoded into bytes32
384     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
385     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
386         stateOpen(question_id)
387         bondMustDouble(question_id)
388         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
389     external payable {
390         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
391         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
392     }
393 
394     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
395     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
396     /// The commitment_id is stored in the answer history where the answer would normally go.
397     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
398     /// @param question_id The ID of the question
399     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
400     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
401     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
402     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
403     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
404         stateOpen(question_id)
405         bondMustDouble(question_id)
406         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
407     external payable {
408 
409         bytes32 commitment_id = keccak256(question_id, answer_hash, msg.value);
410         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
411 
412         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT);
413 
414         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
415         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
416 
417         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
418 
419     }
420 
421     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
422     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
423     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
424     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
425     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
426     /// @param question_id The ID of the question
427     /// @param answer The answer, encoded as bytes32
428     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
429     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
430     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
431         stateOpen(question_id)
432     external {
433 
434         bytes32 answer_hash = keccak256(answer, nonce);
435         bytes32 commitment_id = keccak256(question_id, answer_hash, bond);
436 
437         require(!commitments[commitment_id].is_revealed);
438         require(commitments[commitment_id].reveal_ts > uint32(now)); // Reveal deadline must not have passed
439 
440         commitments[commitment_id].revealed_answer = answer;
441         commitments[commitment_id].is_revealed = true;
442 
443         if (bond == questions[question_id].bond) {
444             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
445         }
446 
447         LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
448 
449     }
450 
451     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
452     internal 
453     {
454         bytes32 new_history_hash = keccak256(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment);
455 
456         questions[question_id].bond = bond;
457         questions[question_id].history_hash = new_history_hash;
458 
459         LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
460     }
461 
462     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
463     internal {
464         questions[question_id].best_answer = answer;
465         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
466     }
467 
468     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
469     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
470     /// @param question_id The ID of the question
471     /// @param requester The account that requested arbitration
472     function notifyOfArbitrationRequest(bytes32 question_id, address requester) 
473         onlyArbitrator(question_id)
474         stateOpen(question_id)
475     external {
476         questions[question_id].is_pending_arbitration = true;
477         LogNotifyOfArbitrationRequest(question_id, requester);
478     }
479 
480     /// @notice Submit the answer for a question, for use by the arbitrator.
481     /// @dev Doesn't require (or allow) a bond.
482     /// If the current final answer is correct, the account should be whoever submitted it.
483     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
484     /// However, the answerer stipulations are not enforced by the contract.
485     /// @param question_id The ID of the question
486     /// @param answer The answer, encoded into bytes32
487     /// @param answerer The account credited with this answer for the purpose of bond claims
488     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
489         onlyArbitrator(question_id)
490         statePendingArbitration(question_id)
491         bondMustBeZero
492     external {
493 
494         require(answerer != NULL_ADDRESS);
495         LogFinalize(question_id, answer);
496 
497         questions[question_id].is_pending_arbitration = false;
498         _addAnswerToHistory(question_id, answer, answerer, 0, false);
499         _updateCurrentAnswer(question_id, answer, 0);
500 
501     }
502 
503     /// @notice Report whether the answer to the specified question is finalized
504     /// @param question_id The ID of the question
505     /// @return Return true if finalized
506     function isFinalized(bytes32 question_id) 
507     constant public returns (bool) {
508         uint32 finalize_ts = questions[question_id].finalize_ts;
509         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
510     }
511 
512     /// @notice Return the final answer to the specified question, or revert if there isn't one
513     /// @param question_id The ID of the question
514     /// @return The answer formatted as a bytes32
515     function getFinalAnswer(bytes32 question_id) 
516         stateFinalized(question_id)
517     external constant returns (bytes32) {
518         return questions[question_id].best_answer;
519     }
520 
521     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
522     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
523     /// @param question_id The ID of the question
524     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
525     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
526     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
527     /// @param min_bond The bond sent with the final answer must be this high or higher
528     /// @return The answer formatted as a bytes32
529     function getFinalAnswerIfMatches(
530         bytes32 question_id, 
531         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
532     ) 
533         stateFinalized(question_id)
534     external constant returns (bytes32) {
535         require(content_hash == questions[question_id].content_hash);
536         require(arbitrator == questions[question_id].arbitrator);
537         require(min_timeout <= questions[question_id].timeout);
538         require(min_bond <= questions[question_id].bond);
539         return questions[question_id].best_answer;
540     }
541 
542     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
543     /// Caller must provide the answer history, in reverse order
544     /// @dev Works up the chain and assign bonds to the person who gave the right answer
545     /// If someone gave the winning answer earlier, they must get paid from the higher bond
546     /// That means we can't pay out the bond added at n until we have looked at n-1
547     /// The first answer is authenticated by checking against the stored history_hash.
548     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
549     /// Once we get to a null hash we'll know we're done and there are no more answers.
550     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
551     /// @param question_id The ID of the question
552     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
553     /// @param addrs Last-to-first, the address of each answerer or commitment sender
554     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
555     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
556     function claimWinnings(
557         bytes32 question_id, 
558         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
559     ) 
560         stateFinalized(question_id)
561     public {
562 
563         require(history_hashes.length > 0);
564 
565         // These are only set if we split our claim over multiple transactions.
566         address payee = question_claims[question_id].payee; 
567         uint256 last_bond = question_claims[question_id].last_bond; 
568         uint256 queued_funds = question_claims[question_id].queued_funds; 
569 
570         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
571         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
572         bytes32 last_history_hash = questions[question_id].history_hash;
573 
574         bytes32 best_answer = questions[question_id].best_answer;
575 
576         uint256 i;
577         for (i = 0; i < history_hashes.length; i++) {
578         
579             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
580             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
581             
582             queued_funds = queued_funds.add(last_bond); 
583             (queued_funds, payee) = _processHistoryItem(
584                 question_id, best_answer, queued_funds, payee, 
585                 addrs[i], bonds[i], answers[i], is_commitment);
586  
587             // Line the bond up for next time, when it will be added to somebody's queued_funds
588             last_bond = bonds[i];
589             last_history_hash = history_hashes[i];
590 
591         }
592  
593         if (last_history_hash != NULL_HASH) {
594             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
595             // Persist the details so we can pick up later where we left off later.
596 
597             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
598             // (We always know who to pay unless all we saw were unrevealed commits)
599             if (payee != NULL_ADDRESS) {
600                 _payPayee(question_id, payee, queued_funds);
601                 queued_funds = 0;
602             }
603 
604             question_claims[question_id].payee = payee;
605             question_claims[question_id].last_bond = last_bond;
606             question_claims[question_id].queued_funds = queued_funds;
607         } else {
608             // There is nothing left below us so the payee can keep what remains
609             _payPayee(question_id, payee, queued_funds.add(last_bond));
610             delete question_claims[question_id];
611         }
612 
613         questions[question_id].history_hash = last_history_hash;
614 
615     }
616 
617     function _payPayee(bytes32 question_id, address payee, uint256 value) 
618     internal {
619         balanceOf[payee] = balanceOf[payee].add(value);
620         LogClaim(question_id, payee, value);
621     }
622 
623     function _verifyHistoryInputOrRevert(
624         bytes32 last_history_hash,
625         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
626     )
627     internal pure returns (bool) {
628         if (last_history_hash == keccak256(history_hash, answer, bond, addr, true) ) {
629             return true;
630         }
631         if (last_history_hash == keccak256(history_hash, answer, bond, addr, false) ) {
632             return false;
633         } 
634         revert();
635     }
636 
637     function _processHistoryItem(
638         bytes32 question_id, bytes32 best_answer, 
639         uint256 queued_funds, address payee, 
640         address addr, uint256 bond, bytes32 answer, bool is_commitment
641     )
642     internal returns (uint256, address) {
643 
644         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
645         // We look at the referenced commitment ID and switch in the actual answer.
646         if (is_commitment) {
647             bytes32 commitment_id = answer;
648             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
649             if (!commitments[commitment_id].is_revealed) {
650                 delete commitments[commitment_id];
651                 return (queued_funds, payee);
652             } else {
653                 answer = commitments[commitment_id].revealed_answer;
654                 delete commitments[commitment_id];
655             }
656         }
657 
658         if (answer == best_answer) {
659 
660             if (payee == NULL_ADDRESS) {
661 
662                 // The entry is for the first payee we come to, ie the winner.
663                 // They get the question bounty.
664                 payee = addr;
665                 queued_funds = queued_funds.add(questions[question_id].bounty);
666                 questions[question_id].bounty = 0;
667 
668             } else if (addr != payee) {
669 
670                 // Answerer has changed, ie we found someone lower down who needs to be paid
671 
672                 // The lower answerer will take over receiving bonds from higher answerer.
673                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
674                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
675 
676                 // There should be enough for the fee, but if not, take what we have.
677                 // There's an edge case involving weird arbitrator behaviour where we may be short.
678                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
679 
680                 // Settle up with the old (higher-bonded) payee
681                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
682 
683                 // Now start queued_funds again for the new (lower-bonded) payee
684                 payee = addr;
685                 queued_funds = answer_takeover_fee;
686 
687             }
688 
689         }
690 
691         return (queued_funds, payee);
692 
693     }
694 
695     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
696     /// Caller must provide the answer history for each question, in reverse order
697     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
698     /// @param question_ids The IDs of the questions you want to claim for
699     /// @param lengths The number of history entries you will supply for each question ID
700     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
701     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
702     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
703     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
704     function claimMultipleAndWithdrawBalance(
705         bytes32[] question_ids, uint256[] lengths, 
706         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
707     ) 
708         stateAny() // The finalization checks are done in the claimWinnings function
709     public {
710         
711         uint256 qi;
712         uint256 i;
713         for (qi = 0; qi < question_ids.length; qi++) {
714             bytes32 qid = question_ids[qi];
715             uint256 ln = lengths[qi];
716             bytes32[] memory hh = new bytes32[](ln);
717             address[] memory ad = new address[](ln);
718             uint256[] memory bo = new uint256[](ln);
719             bytes32[] memory an = new bytes32[](ln);
720             uint256 j;
721             for (j = 0; j < ln; j++) {
722                 hh[j] = hist_hashes[i];
723                 ad[j] = addrs[i];
724                 bo[j] = bonds[i];
725                 an[j] = answers[i];
726                 i++;
727             }
728             claimWinnings(qid, hh, ad, bo, an);
729         }
730         withdraw();
731     }
732 }
733 
734 
735 
736 
737 contract Arbitrator is Owned {
738 
739     RealityCheck public realitycheck;
740 
741     mapping(bytes32 => uint256) public arbitration_bounties;
742 
743     uint256 dispute_fee;
744     mapping(bytes32 => uint256) custom_dispute_fees;
745 
746     event LogRequestArbitration(
747         bytes32 indexed question_id,
748         uint256 fee_paid,
749         address requester,
750         uint256 remaining
751     );
752 
753     event LogSetRealityCheck(
754         address realitycheck
755     );
756 
757     event LogSetQuestionFee(
758         uint256 fee
759     );
760 
761 
762     event LogSetDisputeFee(
763         uint256 fee
764     );
765 
766     event LogSetCustomDisputeFee(
767         bytes32 indexed question_id,
768         uint256 fee
769     );
770 
771     /// @notice Constructor. Sets the deploying address as owner.
772     function Arbitrator() 
773     public {
774         owner = msg.sender;
775     }
776 
777     /// @notice Set the Reality Check contract address
778     /// @param addr The address of the Reality Check contract
779     function setRealityCheck(address addr) 
780         onlyOwner 
781     public {
782         realitycheck = RealityCheck(addr);
783         LogSetRealityCheck(addr);
784     }
785 
786     /// @notice Set the default fee
787     /// @param fee The default fee amount
788     function setDisputeFee(uint256 fee) 
789         onlyOwner 
790     public {
791         dispute_fee = fee;
792         LogSetDisputeFee(fee);
793     }
794 
795     /// @notice Set a custom fee for this particular question
796     /// @param question_id The question in question
797     /// @param fee The fee amount
798     function setCustomDisputeFee(bytes32 question_id, uint256 fee) 
799         onlyOwner 
800     public {
801         custom_dispute_fees[question_id] = fee;
802         LogSetCustomDisputeFee(question_id, fee);
803     }
804 
805     /// @notice Return the dispute fee for the specified question. 0 indicates that we won't arbitrate it.
806     /// @param question_id The question in question
807     /// @dev Uses a general default, but can be over-ridden on a question-by-question basis.
808     function getDisputeFee(bytes32 question_id) 
809     public constant returns (uint256) {
810         return (custom_dispute_fees[question_id] > 0) ? custom_dispute_fees[question_id] : dispute_fee;
811     }
812 
813     /// @notice Set a fee for asking a question with us as the arbitrator
814     /// @param fee The fee amount
815     /// @dev Default is no fee. Unlike the dispute fee, 0 is an acceptable setting.
816     /// You could set an impossibly high fee if you want to prevent us being used as arbitrator unless we submit the question.
817     /// (Submitting the question ourselves is not implemented here.)
818     /// This fee can be used as a revenue source, an anti-spam measure, or both.
819     function setQuestionFee(uint256 fee) 
820         onlyOwner 
821     public {
822         realitycheck.setQuestionFee(fee);
823         LogSetQuestionFee(fee);
824     }
825 
826     /// @notice Submit the arbitrator's answer to a question.
827     /// @param question_id The question in question
828     /// @param answer The answer
829     /// @param answerer The answerer. If arbitration changed the answer, it should be the payer. If not, the old answerer.
830     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
831         onlyOwner 
832     public {
833         delete arbitration_bounties[question_id];
834         realitycheck.submitAnswerByArbitrator(question_id, answer, answerer);
835     }
836 
837     /// @notice Request arbitration, freezing the question until we send submitAnswerByArbitrator
838     /// @dev The bounty can be paid only in part, in which case the last person to pay will be considered the payer
839     /// Will trigger an error if the notification fails, eg because the question has already been finalized
840     /// @param question_id The question in question
841     function requestArbitration(bytes32 question_id) 
842     external payable returns (bool) {
843 
844         uint256 arbitration_fee = getDisputeFee(question_id);
845         require(arbitration_fee > 0);
846 
847         arbitration_bounties[question_id] += msg.value;
848         uint256 paid = arbitration_bounties[question_id];
849 
850         if (paid >= arbitration_fee) {
851             realitycheck.notifyOfArbitrationRequest(question_id, msg.sender);
852             LogRequestArbitration(question_id, msg.value, msg.sender, 0);
853             return true;
854         } else {
855             require(!realitycheck.isFinalized(question_id));
856             LogRequestArbitration(question_id, msg.value, msg.sender, arbitration_fee - paid);
857             return false;
858         }
859 
860     }
861 
862     /// @notice Withdraw any accumulated fees to the specified address
863     /// @param addr The address to which the balance should be sent
864     function withdraw(address addr) 
865         onlyOwner 
866     public {
867         addr.transfer(this.balance); 
868     }
869 
870     function() 
871     public payable {
872     }
873 
874     /// @notice Withdraw any accumulated question fees from the specified address into this contract
875     /// @dev Funds can then be liberated from this contract with our withdraw() function
876     function callWithdraw() 
877         onlyOwner 
878     public {
879         realitycheck.withdraw(); 
880     }
881 
882 }