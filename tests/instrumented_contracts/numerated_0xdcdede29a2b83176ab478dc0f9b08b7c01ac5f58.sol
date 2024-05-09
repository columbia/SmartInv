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
40 contract Owned {
41     address public owner;
42 
43     function Owned() 
44     public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address newOwner) 
54         onlyOwner 
55     public {
56         owner = newOwner;
57     }
58 }
59 
60 contract BalanceHolder {
61 
62     mapping(address => uint256) public balanceOf;
63 
64     event LogWithdraw(
65         address indexed user,
66         uint256 amount
67     );
68 
69     function withdraw() 
70     public {
71         uint256 bal = balanceOf[msg.sender];
72         balanceOf[msg.sender] = 0;
73         msg.sender.transfer(bal);
74         LogWithdraw(msg.sender, bal);
75     }
76 
77 }
78 contract RealityCheck is BalanceHolder {
79 
80     using SafeMath for uint256;
81     using SafeMath32 for uint32;
82 
83     address constant NULL_ADDRESS = address(0);
84 
85     // History hash when no history is created, or history has been cleared
86     bytes32 constant NULL_HASH = bytes32(0);
87 
88     // An unitinalized finalize_ts for a question will indicate an unanswered question.
89     uint32 constant UNANSWERED = 0;
90 
91     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
92     uint256 constant COMMITMENT_NON_EXISTENT = 0;
93 
94     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
95     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
96 
97     event LogSetQuestionFee(
98         address arbitrator,
99         uint256 amount
100     );
101 
102     event LogNewTemplate(
103         uint256 indexed template_id,
104         address indexed user, 
105         string question_text
106     );
107 
108     event LogNewQuestion(
109         bytes32 indexed question_id,
110         address indexed user, 
111         uint256 template_id,
112         string question,
113         bytes32 indexed content_hash,
114         address arbitrator, 
115         uint32 timeout,
116         uint32 opening_ts,
117         uint256 nonce,
118         uint256 created
119     );
120 
121     event LogFundAnswerBounty(
122         bytes32 indexed question_id,
123         uint256 bounty_added,
124         uint256 bounty,
125         address indexed user 
126     );
127 
128     event LogNewAnswer(
129         bytes32 answer,
130         bytes32 indexed question_id,
131         bytes32 history_hash,
132         address indexed user,
133         uint256 bond,
134         uint256 ts,
135         bool is_commitment
136     );
137 
138     event LogAnswerReveal(
139         bytes32 indexed question_id, 
140         address indexed user, 
141         bytes32 indexed answer_hash, 
142         bytes32 answer, 
143         uint256 nonce, 
144         uint256 bond
145     );
146 
147     event LogNotifyOfArbitrationRequest(
148         bytes32 indexed question_id,
149         address indexed user 
150     );
151 
152     event LogFinalize(
153         bytes32 indexed question_id,
154         bytes32 indexed answer
155     );
156 
157     event LogClaim(
158         bytes32 indexed question_id,
159         address indexed user,
160         uint256 amount
161     );
162 
163     struct Question {
164         bytes32 content_hash;
165         address arbitrator;
166         uint32 opening_ts;
167         uint32 timeout;
168         uint32 finalize_ts;
169         bool is_pending_arbitration;
170         uint256 bounty;
171         bytes32 best_answer;
172         bytes32 history_hash;
173         uint256 bond;
174     }
175 
176     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
177     struct Commitment {
178         uint32 reveal_ts;
179         bool is_revealed;
180         bytes32 revealed_answer;
181     }
182 
183     // Only used when claiming more bonds than fits into a transaction
184     // Stored in a mapping indexed by question_id.
185     struct Claim {
186         address payee;
187         uint256 last_bond;
188         uint256 queued_funds;
189     }
190 
191     uint256 nextTemplateID = 0;
192     mapping(uint256 => uint256) public templates;
193     mapping(uint256 => bytes32) public template_hashes;
194     mapping(bytes32 => Question) public questions;
195     mapping(bytes32 => Claim) question_claims;
196     mapping(bytes32 => Commitment) public commitments;
197     mapping(address => uint256) public arbitrator_question_fees; 
198 
199     modifier onlyArbitrator(bytes32 question_id) {
200         require(msg.sender == questions[question_id].arbitrator);
201         _;
202     }
203 
204     modifier stateAny() {
205         _;
206     }
207 
208     modifier stateNotCreated(bytes32 question_id) {
209         require(questions[question_id].timeout == 0);
210         _;
211     }
212 
213     modifier stateOpen(bytes32 question_id) {
214         require(questions[question_id].timeout > 0); // Check existence
215         require(!questions[question_id].is_pending_arbitration);
216         uint32 finalize_ts = questions[question_id].finalize_ts;
217         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now));
218         uint32 opening_ts = questions[question_id].opening_ts;
219         require(opening_ts == 0 || opening_ts <= uint32(now)); 
220         _;
221     }
222 
223     modifier statePendingArbitration(bytes32 question_id) {
224         require(questions[question_id].is_pending_arbitration);
225         _;
226     }
227 
228     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
229         require(questions[question_id].timeout > 0); // Check existence
230         uint32 finalize_ts = questions[question_id].finalize_ts;
231         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now));
232         uint32 opening_ts = questions[question_id].opening_ts;
233         require(opening_ts == 0 || opening_ts <= uint32(now)); 
234         _;
235     }
236 
237     modifier stateFinalized(bytes32 question_id) {
238         require(isFinalized(question_id));
239         _;
240     }
241 
242     modifier bondMustBeZero() {
243         require(msg.value == 0);
244         _;
245     }
246 
247     modifier bondMustDouble(bytes32 question_id) {
248         require(msg.value > 0); 
249         require(msg.value >= (questions[question_id].bond.mul(2)));
250         _;
251     }
252 
253     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
254         if (max_previous > 0) {
255             require(questions[question_id].bond <= max_previous);
256         }
257         _;
258     }
259 
260     /// @notice Constructor, sets up some initial templates
261     /// @dev Creates some generalized templates for different question types used in the DApp.
262     function RealityCheck() 
263     public {
264         createTemplate('{"title": "%s", "type": "bool", "category": "%s"}');
265         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s"}');
266         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s"}');
267         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s"}');
268         createTemplate('{"title": "%s", "type": "datetime", "category": "%s"}');
269     }
270 
271     /// @notice Function for arbitrator to set an optional per-question fee. 
272     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
273     /// @param fee The fee to be charged by the arbitrator when a question is asked
274     function setQuestionFee(uint256 fee) 
275         stateAny() 
276     external {
277         arbitrator_question_fees[msg.sender] = fee;
278         LogSetQuestionFee(msg.sender, fee);
279     }
280 
281     /// @notice Create a reusable template, which should be a JSON document.
282     /// Placeholders should use gettext() syntax, eg %s.
283     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
284     /// @param content The template content
285     /// @return The ID of the newly-created template, which is created sequentially.
286     function createTemplate(string content) 
287         stateAny()
288     public returns (uint256) {
289         uint256 id = nextTemplateID;
290         templates[id] = block.number;
291         template_hashes[id] = keccak256(content);
292         LogNewTemplate(id, msg.sender, content);
293         nextTemplateID = id.add(1);
294         return id;
295     }
296 
297     /// @notice Create a new reusable template and use it to ask a question
298     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
299     /// @param content The template content
300     /// @param question A string containing the parameters that will be passed into the template to make the question
301     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
302     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
303     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
304     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
305     /// @return The ID of the newly-created template, which is created sequentially.
306     function createTemplateAndAskQuestion(
307         string content, 
308         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
309     ) 
310         // stateNotCreated is enforced by the internal _askQuestion
311     public payable returns (bytes32) {
312         uint256 template_id = createTemplate(content);
313         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
314     }
315 
316     /// @notice Ask a new question and return the ID
317     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
318     /// @param template_id The ID number of the template the question will use
319     /// @param question A string containing the parameters that will be passed into the template to make the question
320     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
321     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
322     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
323     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
324     /// @return The ID of the newly-created question, created deterministically.
325     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
326         // stateNotCreated is enforced by the internal _askQuestion
327     public payable returns (bytes32) {
328 
329         require(templates[template_id] > 0); // Template must exist
330 
331         bytes32 content_hash = keccak256(template_id, opening_ts, question);
332         bytes32 question_id = keccak256(content_hash, arbitrator, timeout, msg.sender, nonce);
333 
334         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts);
335         LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
336 
337         return question_id;
338     }
339 
340     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts) 
341         stateNotCreated(question_id)
342     internal {
343 
344         // A timeout of 0 makes no sense, and we will use this to check existence
345         require(timeout > 0); 
346         require(timeout < 365 days); 
347         require(arbitrator != NULL_ADDRESS);
348 
349         uint256 bounty = msg.value;
350 
351         // The arbitrator can set a fee for asking a question. 
352         // This is intended as an anti-spam defence.
353         // The fee is waived if the arbitrator is asking the question.
354         // This allows them to set an impossibly high fee and make users proxy the question through them.
355         // This would allow more sophisticated pricing, question whitelisting etc.
356         if (msg.sender != arbitrator) {
357             uint256 question_fee = arbitrator_question_fees[arbitrator];
358             require(bounty >= question_fee); 
359             bounty = bounty.sub(question_fee);
360             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
361         }
362 
363         questions[question_id].content_hash = content_hash;
364         questions[question_id].arbitrator = arbitrator;
365         questions[question_id].opening_ts = opening_ts;
366         questions[question_id].timeout = timeout;
367         questions[question_id].bounty = bounty;
368 
369     }
370 
371     /// @notice Add funds to the bounty for a question
372     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
373     /// @param question_id The ID of the question you wish to fund
374     function fundAnswerBounty(bytes32 question_id) 
375         stateOpen(question_id)
376     external payable {
377         questions[question_id].bounty = questions[question_id].bounty.add(msg.value);
378         LogFundAnswerBounty(question_id, msg.value, questions[question_id].bounty, msg.sender);
379     }
380 
381     /// @notice Submit an answer for a question.
382     /// @dev Adds the answer to the history and updates the current "best" answer.
383     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
384     /// @param question_id The ID of the question
385     /// @param answer The answer, encoded into bytes32
386     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
387     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
388         stateOpen(question_id)
389         bondMustDouble(question_id)
390         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
391     external payable {
392         _addAnswerToHistory(question_id, answer, msg.sender, msg.value, false);
393         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
394     }
395 
396     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
397     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
398     /// The commitment_id is stored in the answer history where the answer would normally go.
399     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
400     /// @param question_id The ID of the question
401     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
402     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
403     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
404     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
405     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
406         stateOpen(question_id)
407         bondMustDouble(question_id)
408         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
409     external payable {
410 
411         bytes32 commitment_id = keccak256(question_id, answer_hash, msg.value);
412         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
413 
414         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT);
415 
416         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
417         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
418 
419         _addAnswerToHistory(question_id, commitment_id, answerer, msg.value, true);
420 
421     }
422 
423     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
424     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
425     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
426     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
427     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
428     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
429     /// @param question_id The ID of the question
430     /// @param answer The answer, encoded as bytes32
431     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
432     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
433     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
434         stateOpenOrPendingArbitration(question_id)
435     external {
436 
437         bytes32 answer_hash = keccak256(answer, nonce);
438         bytes32 commitment_id = keccak256(question_id, answer_hash, bond);
439 
440         require(!commitments[commitment_id].is_revealed);
441         require(commitments[commitment_id].reveal_ts > uint32(now)); // Reveal deadline must not have passed
442 
443         commitments[commitment_id].revealed_answer = answer;
444         commitments[commitment_id].is_revealed = true;
445 
446         if (bond == questions[question_id].bond) {
447             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
448         }
449 
450         LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
451 
452     }
453 
454     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
455     internal 
456     {
457         bytes32 new_history_hash = keccak256(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment);
458 
459         questions[question_id].bond = bond;
460         questions[question_id].history_hash = new_history_hash;
461 
462         LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
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
481         questions[question_id].is_pending_arbitration = true;
482         LogNotifyOfArbitrationRequest(question_id, requester);
483     }
484 
485     /// @notice Submit the answer for a question, for use by the arbitrator.
486     /// @dev Doesn't require (or allow) a bond.
487     /// If the current final answer is correct, the account should be whoever submitted it.
488     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
489     /// However, the answerer stipulations are not enforced by the contract.
490     /// @param question_id The ID of the question
491     /// @param answer The answer, encoded into bytes32
492     /// @param answerer The account credited with this answer for the purpose of bond claims
493     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
494         onlyArbitrator(question_id)
495         statePendingArbitration(question_id)
496         bondMustBeZero
497     external {
498 
499         require(answerer != NULL_ADDRESS);
500         LogFinalize(question_id, answer);
501 
502         questions[question_id].is_pending_arbitration = false;
503         _addAnswerToHistory(question_id, answer, answerer, 0, false);
504         _updateCurrentAnswer(question_id, answer, 0);
505 
506     }
507 
508     /// @notice Report whether the answer to the specified question is finalized
509     /// @param question_id The ID of the question
510     /// @return Return true if finalized
511     function isFinalized(bytes32 question_id) 
512     constant public returns (bool) {
513         uint32 finalize_ts = questions[question_id].finalize_ts;
514         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
515     }
516 
517     /// @notice Return the final answer to the specified question, or revert if there isn't one
518     /// @param question_id The ID of the question
519     /// @return The answer formatted as a bytes32
520     function getFinalAnswer(bytes32 question_id) 
521         stateFinalized(question_id)
522     external constant returns (bytes32) {
523         return questions[question_id].best_answer;
524     }
525 
526     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
527     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
528     /// @param question_id The ID of the question
529     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
530     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
531     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
532     /// @param min_bond The bond sent with the final answer must be this high or higher
533     /// @return The answer formatted as a bytes32
534     function getFinalAnswerIfMatches(
535         bytes32 question_id, 
536         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
537     ) 
538         stateFinalized(question_id)
539     external constant returns (bytes32) {
540         require(content_hash == questions[question_id].content_hash);
541         require(arbitrator == questions[question_id].arbitrator);
542         require(min_timeout <= questions[question_id].timeout);
543         require(min_bond <= questions[question_id].bond);
544         return questions[question_id].best_answer;
545     }
546 
547     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
548     /// Caller must provide the answer history, in reverse order
549     /// @dev Works up the chain and assign bonds to the person who gave the right answer
550     /// If someone gave the winning answer earlier, they must get paid from the higher bond
551     /// That means we can't pay out the bond added at n until we have looked at n-1
552     /// The first answer is authenticated by checking against the stored history_hash.
553     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
554     /// Once we get to a null hash we'll know we're done and there are no more answers.
555     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
556     /// @param question_id The ID of the question
557     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
558     /// @param addrs Last-to-first, the address of each answerer or commitment sender
559     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
560     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
561     function claimWinnings(
562         bytes32 question_id, 
563         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
564     ) 
565         stateFinalized(question_id)
566     public {
567 
568         require(history_hashes.length > 0);
569 
570         // These are only set if we split our claim over multiple transactions.
571         address payee = question_claims[question_id].payee; 
572         uint256 last_bond = question_claims[question_id].last_bond; 
573         uint256 queued_funds = question_claims[question_id].queued_funds; 
574 
575         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
576         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
577         bytes32 last_history_hash = questions[question_id].history_hash;
578 
579         bytes32 best_answer = questions[question_id].best_answer;
580 
581         uint256 i;
582         for (i = 0; i < history_hashes.length; i++) {
583         
584             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
585             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
586             
587             queued_funds = queued_funds.add(last_bond); 
588             (queued_funds, payee) = _processHistoryItem(
589                 question_id, best_answer, queued_funds, payee, 
590                 addrs[i], bonds[i], answers[i], is_commitment);
591  
592             // Line the bond up for next time, when it will be added to somebody's queued_funds
593             last_bond = bonds[i];
594             last_history_hash = history_hashes[i];
595 
596         }
597  
598         if (last_history_hash != NULL_HASH) {
599             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
600             // Persist the details so we can pick up later where we left off later.
601 
602             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
603             // (We always know who to pay unless all we saw were unrevealed commits)
604             if (payee != NULL_ADDRESS) {
605                 _payPayee(question_id, payee, queued_funds);
606                 queued_funds = 0;
607             }
608 
609             question_claims[question_id].payee = payee;
610             question_claims[question_id].last_bond = last_bond;
611             question_claims[question_id].queued_funds = queued_funds;
612         } else {
613             // There is nothing left below us so the payee can keep what remains
614             _payPayee(question_id, payee, queued_funds.add(last_bond));
615             delete question_claims[question_id];
616         }
617 
618         questions[question_id].history_hash = last_history_hash;
619 
620     }
621 
622     function _payPayee(bytes32 question_id, address payee, uint256 value) 
623     internal {
624         balanceOf[payee] = balanceOf[payee].add(value);
625         LogClaim(question_id, payee, value);
626     }
627 
628     function _verifyHistoryInputOrRevert(
629         bytes32 last_history_hash,
630         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
631     )
632     internal pure returns (bool) {
633         if (last_history_hash == keccak256(history_hash, answer, bond, addr, true) ) {
634             return true;
635         }
636         if (last_history_hash == keccak256(history_hash, answer, bond, addr, false) ) {
637             return false;
638         } 
639         revert();
640     }
641 
642     function _processHistoryItem(
643         bytes32 question_id, bytes32 best_answer, 
644         uint256 queued_funds, address payee, 
645         address addr, uint256 bond, bytes32 answer, bool is_commitment
646     )
647     internal returns (uint256, address) {
648 
649         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
650         // We look at the referenced commitment ID and switch in the actual answer.
651         if (is_commitment) {
652             bytes32 commitment_id = answer;
653             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
654             if (!commitments[commitment_id].is_revealed) {
655                 delete commitments[commitment_id];
656                 return (queued_funds, payee);
657             } else {
658                 answer = commitments[commitment_id].revealed_answer;
659                 delete commitments[commitment_id];
660             }
661         }
662 
663         if (answer == best_answer) {
664 
665             if (payee == NULL_ADDRESS) {
666 
667                 // The entry is for the first payee we come to, ie the winner.
668                 // They get the question bounty.
669                 payee = addr;
670                 queued_funds = queued_funds.add(questions[question_id].bounty);
671                 questions[question_id].bounty = 0;
672 
673             } else if (addr != payee) {
674 
675                 // Answerer has changed, ie we found someone lower down who needs to be paid
676 
677                 // The lower answerer will take over receiving bonds from higher answerer.
678                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
679                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
680 
681                 // There should be enough for the fee, but if not, take what we have.
682                 // There's an edge case involving weird arbitrator behaviour where we may be short.
683                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
684 
685                 // Settle up with the old (higher-bonded) payee
686                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
687 
688                 // Now start queued_funds again for the new (lower-bonded) payee
689                 payee = addr;
690                 queued_funds = answer_takeover_fee;
691 
692             }
693 
694         }
695 
696         return (queued_funds, payee);
697 
698     }
699 
700     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
701     /// Caller must provide the answer history for each question, in reverse order
702     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
703     /// @param question_ids The IDs of the questions you want to claim for
704     /// @param lengths The number of history entries you will supply for each question ID
705     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
706     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
707     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
708     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
709     function claimMultipleAndWithdrawBalance(
710         bytes32[] question_ids, uint256[] lengths, 
711         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
712     ) 
713         stateAny() // The finalization checks are done in the claimWinnings function
714     public {
715         
716         uint256 qi;
717         uint256 i;
718         for (qi = 0; qi < question_ids.length; qi++) {
719             bytes32 qid = question_ids[qi];
720             uint256 ln = lengths[qi];
721             bytes32[] memory hh = new bytes32[](ln);
722             address[] memory ad = new address[](ln);
723             uint256[] memory bo = new uint256[](ln);
724             bytes32[] memory an = new bytes32[](ln);
725             uint256 j;
726             for (j = 0; j < ln; j++) {
727                 hh[j] = hist_hashes[i];
728                 ad[j] = addrs[i];
729                 bo[j] = bonds[i];
730                 an[j] = answers[i];
731                 i++;
732             }
733             claimWinnings(qid, hh, ad, bo, an);
734         }
735         withdraw();
736     }
737 }
738 contract Arbitrator is Owned {
739 
740     RealityCheck public realitycheck;
741 
742     mapping(bytes32 => uint256) public arbitration_bounties;
743 
744     uint256 dispute_fee;
745     mapping(bytes32 => uint256) custom_dispute_fees;
746 
747     event LogRequestArbitration(
748         bytes32 indexed question_id,
749         uint256 fee_paid,
750         address requester,
751         uint256 remaining
752     );
753 
754     event LogSetRealityCheck(
755         address realitycheck
756     );
757 
758     event LogSetQuestionFee(
759         uint256 fee
760     );
761 
762 
763     event LogSetDisputeFee(
764         uint256 fee
765     );
766 
767     event LogSetCustomDisputeFee(
768         bytes32 indexed question_id,
769         uint256 fee
770     );
771 
772     /// @notice Constructor. Sets the deploying address as owner.
773     function Arbitrator() 
774     public {
775         owner = msg.sender;
776     }
777 
778     /// @notice Set the Reality Check contract address
779     /// @param addr The address of the Reality Check contract
780     function setRealityCheck(address addr) 
781         onlyOwner 
782     public {
783         realitycheck = RealityCheck(addr);
784         LogSetRealityCheck(addr);
785     }
786 
787     /// @notice Set the default fee
788     /// @param fee The default fee amount
789     function setDisputeFee(uint256 fee) 
790         onlyOwner 
791     public {
792         dispute_fee = fee;
793         LogSetDisputeFee(fee);
794     }
795 
796     /// @notice Set a custom fee for this particular question
797     /// @param question_id The question in question
798     /// @param fee The fee amount
799     function setCustomDisputeFee(bytes32 question_id, uint256 fee) 
800         onlyOwner 
801     public {
802         custom_dispute_fees[question_id] = fee;
803         LogSetCustomDisputeFee(question_id, fee);
804     }
805 
806     /// @notice Return the dispute fee for the specified question. 0 indicates that we won't arbitrate it.
807     /// @param question_id The question in question
808     /// @dev Uses a general default, but can be over-ridden on a question-by-question basis.
809     function getDisputeFee(bytes32 question_id) 
810     public constant returns (uint256) {
811         return (custom_dispute_fees[question_id] > 0) ? custom_dispute_fees[question_id] : dispute_fee;
812     }
813 
814     /// @notice Set a fee for asking a question with us as the arbitrator
815     /// @param fee The fee amount
816     /// @dev Default is no fee. Unlike the dispute fee, 0 is an acceptable setting.
817     /// You could set an impossibly high fee if you want to prevent us being used as arbitrator unless we submit the question.
818     /// (Submitting the question ourselves is not implemented here.)
819     /// This fee can be used as a revenue source, an anti-spam measure, or both.
820     function setQuestionFee(uint256 fee) 
821         onlyOwner 
822     public {
823         realitycheck.setQuestionFee(fee);
824         LogSetQuestionFee(fee);
825     }
826 
827     /// @notice Submit the arbitrator's answer to a question.
828     /// @param question_id The question in question
829     /// @param answer The answer
830     /// @param answerer The answerer. If arbitration changed the answer, it should be the payer. If not, the old answerer.
831     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
832         onlyOwner 
833     public {
834         delete arbitration_bounties[question_id];
835         realitycheck.submitAnswerByArbitrator(question_id, answer, answerer);
836     }
837 
838     /// @notice Request arbitration, freezing the question until we send submitAnswerByArbitrator
839     /// @dev The bounty can be paid only in part, in which case the last person to pay will be considered the payer
840     /// Will trigger an error if the notification fails, eg because the question has already been finalized
841     /// @param question_id The question in question
842     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
843     function requestArbitration(bytes32 question_id, uint256 max_previous) 
844     external payable returns (bool) {
845 
846         uint256 arbitration_fee = getDisputeFee(question_id);
847         require(arbitration_fee > 0);
848 
849         arbitration_bounties[question_id] += msg.value;
850         uint256 paid = arbitration_bounties[question_id];
851 
852         if (paid >= arbitration_fee) {
853             realitycheck.notifyOfArbitrationRequest(question_id, msg.sender, max_previous);
854             LogRequestArbitration(question_id, msg.value, msg.sender, 0);
855             return true;
856         } else {
857             require(!realitycheck.isFinalized(question_id));
858             LogRequestArbitration(question_id, msg.value, msg.sender, arbitration_fee - paid);
859             return false;
860         }
861 
862     }
863 
864     /// @notice Withdraw any accumulated fees to the specified address
865     /// @param addr The address to which the balance should be sent
866     function withdraw(address addr) 
867         onlyOwner 
868     public {
869         addr.transfer(this.balance); 
870     }
871 
872     function() 
873     public payable {
874     }
875 
876     /// @notice Withdraw any accumulated question fees from the specified address into this contract
877     /// @dev Funds can then be liberated from this contract with our withdraw() function
878     function callWithdraw() 
879         onlyOwner 
880     public {
881         realitycheck.withdraw(); 
882     }
883 
884 }