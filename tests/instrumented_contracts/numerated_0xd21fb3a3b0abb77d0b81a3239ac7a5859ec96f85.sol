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
35 pragma solidity ^0.4.24;
36 
37 /**
38  * @title RealitioSafeMath32
39  * @dev Math operations with safety checks that throw on error
40  * @dev Copy of SafeMath but for uint32 instead of uint256
41  * @dev Deleted functions we don't use
42  */
43 library RealitioSafeMath32 {
44   function add(uint32 a, uint32 b) internal pure returns (uint32) {
45     uint32 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 pragma solidity ^0.4.24;
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58 
59     function balanceOf(address who) external view returns (uint256);
60 
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     function transfer(address to, uint256 value) external returns (bool);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transferFrom(address from, address to, uint256 value) external returns (bool);
68 
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 pragma solidity ^0.4.18;
74 
75 
76 contract BalanceHolder {
77 
78     IERC20 public token;
79 
80     mapping(address => uint256) public balanceOf;
81 
82     event LogWithdraw(
83         address indexed user,
84         uint256 amount
85     );
86 
87     function withdraw() 
88     public {
89         uint256 bal = balanceOf[msg.sender];
90         balanceOf[msg.sender] = 0;
91         require(token.transfer(msg.sender, bal));
92         emit LogWithdraw(msg.sender, bal);
93     }
94 
95 }
96 pragma solidity ^0.4.24;
97 
98 
99 contract RealitioERC20 is BalanceHolder {
100 
101     using RealitioSafeMath256 for uint256;
102     using RealitioSafeMath32 for uint32;
103 
104     address constant NULL_ADDRESS = address(0);
105 
106     // History hash when no history is created, or history has been cleared
107     bytes32 constant NULL_HASH = bytes32(0);
108 
109     // An unitinalized finalize_ts for a question will indicate an unanswered question.
110     uint32 constant UNANSWERED = 0;
111 
112     // An unanswered reveal_ts for a commitment will indicate that it does not exist.
113     uint256 constant COMMITMENT_NON_EXISTENT = 0;
114 
115     // Commit->reveal timeout is 1/8 of the question timeout (rounded down).
116     uint32 constant COMMITMENT_TIMEOUT_RATIO = 8;
117 
118     event LogSetQuestionFee(
119         address arbitrator,
120         uint256 amount
121     );
122 
123     event LogNewTemplate(
124         uint256 indexed template_id,
125         address indexed user, 
126         string question_text
127     );
128 
129     event LogNewQuestion(
130         bytes32 indexed question_id,
131         address indexed user, 
132         uint256 template_id,
133         string question,
134         bytes32 indexed content_hash,
135         address arbitrator, 
136         uint32 timeout,
137         uint32 opening_ts,
138         uint256 nonce,
139         uint256 created
140     );
141 
142     event LogFundAnswerBounty(
143         bytes32 indexed question_id,
144         uint256 bounty_added,
145         uint256 bounty,
146         address indexed user 
147     );
148 
149     event LogNewAnswer(
150         bytes32 answer,
151         bytes32 indexed question_id,
152         bytes32 history_hash,
153         address indexed user,
154         uint256 bond,
155         uint256 ts,
156         bool is_commitment
157     );
158 
159     event LogAnswerReveal(
160         bytes32 indexed question_id, 
161         address indexed user, 
162         bytes32 indexed answer_hash, 
163         bytes32 answer, 
164         uint256 nonce, 
165         uint256 bond
166     );
167 
168     event LogNotifyOfArbitrationRequest(
169         bytes32 indexed question_id,
170         address indexed user 
171     );
172 
173     event LogFinalize(
174         bytes32 indexed question_id,
175         bytes32 indexed answer
176     );
177 
178     event LogClaim(
179         bytes32 indexed question_id,
180         address indexed user,
181         uint256 amount
182     );
183 
184     struct Question {
185         bytes32 content_hash;
186         address arbitrator;
187         uint32 opening_ts;
188         uint32 timeout;
189         uint32 finalize_ts;
190         bool is_pending_arbitration;
191         uint256 bounty;
192         bytes32 best_answer;
193         bytes32 history_hash;
194         uint256 bond;
195     }
196 
197     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
198     struct Commitment {
199         uint32 reveal_ts;
200         bool is_revealed;
201         bytes32 revealed_answer;
202     }
203 
204     // Only used when claiming more bonds than fits into a transaction
205     // Stored in a mapping indexed by question_id.
206     struct Claim {
207         address payee;
208         uint256 last_bond;
209         uint256 queued_funds;
210     }
211 
212     uint256 nextTemplateID = 0;
213     mapping(uint256 => uint256) public templates;
214     mapping(uint256 => bytes32) public template_hashes;
215     mapping(bytes32 => Question) public questions;
216     mapping(bytes32 => Claim) public question_claims;
217     mapping(bytes32 => Commitment) public commitments;
218     mapping(address => uint256) public arbitrator_question_fees; 
219 
220     modifier onlyArbitrator(bytes32 question_id) {
221         require(msg.sender == questions[question_id].arbitrator, "msg.sender must be arbitrator");
222         _;
223     }
224 
225     modifier stateAny() {
226         _;
227     }
228 
229     modifier stateNotCreated(bytes32 question_id) {
230         require(questions[question_id].timeout == 0, "question must not exist");
231         _;
232     }
233 
234     modifier stateOpen(bytes32 question_id) {
235         require(questions[question_id].timeout > 0, "question must exist");
236         require(!questions[question_id].is_pending_arbitration, "question must not be pending arbitration");
237         uint32 finalize_ts = questions[question_id].finalize_ts;
238         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization deadline must not have passed");
239         uint32 opening_ts = questions[question_id].opening_ts;
240         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
241         _;
242     }
243 
244     modifier statePendingArbitration(bytes32 question_id) {
245         require(questions[question_id].is_pending_arbitration, "question must be pending arbitration");
246         _;
247     }
248 
249     modifier stateOpenOrPendingArbitration(bytes32 question_id) {
250         require(questions[question_id].timeout > 0, "question must exist");
251         uint32 finalize_ts = questions[question_id].finalize_ts;
252         require(finalize_ts == UNANSWERED || finalize_ts > uint32(now), "finalization dealine must not have passed");
253         uint32 opening_ts = questions[question_id].opening_ts;
254         require(opening_ts == 0 || opening_ts <= uint32(now), "opening date must have passed"); 
255         _;
256     }
257 
258     modifier stateFinalized(bytes32 question_id) {
259         require(isFinalized(question_id), "question must be finalized");
260         _;
261     }
262 
263     modifier bondMustDouble(bytes32 question_id, uint256 tokens) {
264         require(tokens > 0, "bond must be positive"); 
265         require(tokens >= (questions[question_id].bond.mul(2)), "bond must be double at least previous bond");
266         _;
267     }
268 
269     modifier previousBondMustNotBeatMaxPrevious(bytes32 question_id, uint256 max_previous) {
270         if (max_previous > 0) {
271             require(questions[question_id].bond <= max_previous, "bond must exceed max_previous");
272         }
273         _;
274     }
275 
276     function setToken(IERC20 _token) 
277     public
278     {
279         require(token == IERC20(0x0), "Token can only be initialized once");
280         token = _token;
281     }
282 
283     /// @notice Constructor, sets up some initial templates
284     /// @dev Creates some generalized templates for different question types used in the DApp.
285     /// param _token The token used for everything except arbitration
286     constructor() 
287     public {
288         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
289         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
290         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
291         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
292         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
293     }
294 
295     /// @notice Function for arbitrator to set an optional per-question fee. 
296     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
297     /// @param fee The fee to be charged by the arbitrator when a question is asked
298     function setQuestionFee(uint256 fee) 
299         stateAny() 
300     external {
301         arbitrator_question_fees[msg.sender] = fee;
302         emit LogSetQuestionFee(msg.sender, fee);
303     }
304 
305     /// @notice Create a reusable template, which should be a JSON document.
306     /// Placeholders should use gettext() syntax, eg %s.
307     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
308     /// @param content The template content
309     /// @return The ID of the newly-created template, which is created sequentially.
310     function createTemplate(string content) 
311         stateAny()
312     public returns (uint256) {
313         uint256 id = nextTemplateID;
314         templates[id] = block.number;
315         template_hashes[id] = keccak256(abi.encodePacked(content));
316         emit LogNewTemplate(id, msg.sender, content);
317         nextTemplateID = id.add(1);
318         return id;
319     }
320 
321     /// @notice Create a new reusable template and use it to ask a question
322     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
323     /// @param content The template content
324     /// @param question A string containing the parameters that will be passed into the template to make the question
325     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
326     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
327     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
328     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
329     /// @return The ID of the newly-created template, which is created sequentially.
330     function createTemplateAndAskQuestion(
331         string content, 
332         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
333     ) 
334         // stateNotCreated is enforced by the internal _askQuestion
335     public returns (bytes32) {
336         uint256 template_id = createTemplate(content);
337         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
338     }
339 
340     /// @notice Ask a new question without a bounty and return the ID
341     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
342     /// @dev Calling without the token param will only work if there is no arbitrator-set question fee.
343     /// @dev This has the same function signature as askQuestion() in the non-ERC20 version, which is optionally payable.
344     /// @param template_id The ID number of the template the question will use
345     /// @param question A string containing the parameters that will be passed into the template to make the question
346     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
347     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
348     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
349     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
350     /// @return The ID of the newly-created question, created deterministically.
351     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
352         // stateNotCreated is enforced by the internal _askQuestion
353     public returns (bytes32) {
354 
355         require(templates[template_id] > 0, "template must exist");
356 
357         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
358         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
359 
360         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts, 0);
361         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
362 
363         return question_id;
364     }
365 
366     /// @notice Ask a new question with a bounty and return the ID
367     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
368     /// @param template_id The ID number of the template the question will use
369     /// @param question A string containing the parameters that will be passed into the template to make the question
370     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
371     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
372     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
373     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
374     /// @param tokens The combined initial question bounty and question fee
375     /// @return The ID of the newly-created question, created deterministically.
376     function askQuestionERC20(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce, uint256 tokens) 
377         // stateNotCreated is enforced by the internal _askQuestion
378     public returns (bytes32) {
379 
380         _deductTokensOrRevert(tokens);
381 
382         require(templates[template_id] > 0, "template must exist");
383 
384         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
385         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
386 
387         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts, tokens);
388         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
389 
390         return question_id;
391     }
392 
393     function _deductTokensOrRevert(uint256 tokens) 
394     internal {
395 
396         if (tokens == 0) {
397             return;
398         }
399 
400         uint256 bal = balanceOf[msg.sender];
401 
402         // Deduct any tokens you have in your internal balance first
403         if (bal > 0) {
404             if (bal >= tokens) {
405                 balanceOf[msg.sender] = bal.sub(tokens);
406                 return;
407             } else {
408                 tokens = tokens.sub(bal);
409                 balanceOf[msg.sender] = 0;
410             }
411         }
412         // Now we need to charge the rest from 
413         require(token.transferFrom(msg.sender, address(this), tokens), "Transfer of tokens failed, insufficient approved balance?");
414         return;
415 
416     }
417 
418     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 tokens) 
419         stateNotCreated(question_id)
420     internal {
421 
422         uint256 bounty = tokens;
423 
424         // A timeout of 0 makes no sense, and we will use this to check existence
425         require(timeout > 0, "timeout must be positive"); 
426         require(timeout < 365 days, "timeout must be less than 365 days"); 
427         require(arbitrator != NULL_ADDRESS, "arbitrator must be set");
428 
429         // The arbitrator can set a fee for asking a question. 
430         // This is intended as an anti-spam defence.
431         // The fee is waived if the arbitrator is asking the question.
432         // This allows them to set an impossibly high fee and make users proxy the question through them.
433         // This would allow more sophisticated pricing, question whitelisting etc.
434         if (msg.sender != arbitrator) {
435             uint256 question_fee = arbitrator_question_fees[arbitrator];
436             require(bounty >= question_fee, "ETH provided must cover question fee"); 
437             bounty = bounty.sub(question_fee);
438             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
439         }
440 
441         questions[question_id].content_hash = content_hash;
442         questions[question_id].arbitrator = arbitrator;
443         questions[question_id].opening_ts = opening_ts;
444         questions[question_id].timeout = timeout;
445         questions[question_id].bounty = bounty;
446 
447     }
448 
449     /// @notice Add funds to the bounty for a question
450     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
451     /// @param question_id The ID of the question you wish to fund
452     /// @param tokens The number of tokens to fund
453     function fundAnswerBountyERC20(bytes32 question_id, uint256 tokens) 
454         stateOpen(question_id)
455     external {
456         _deductTokensOrRevert(tokens);
457         questions[question_id].bounty = questions[question_id].bounty.add(tokens);
458         emit LogFundAnswerBounty(question_id, tokens, questions[question_id].bounty, msg.sender);
459     }
460 
461     /// @notice Submit an answer for a question.
462     /// @dev Adds the answer to the history and updates the current "best" answer.
463     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
464     /// @param question_id The ID of the question
465     /// @param answer The answer, encoded into bytes32
466     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
467     /// @param tokens The amount of tokens to submit
468     function submitAnswerERC20(bytes32 question_id, bytes32 answer, uint256 max_previous, uint256 tokens) 
469         stateOpen(question_id)
470         bondMustDouble(question_id, tokens)
471         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
472     external {
473         _deductTokensOrRevert(tokens);
474         _addAnswerToHistory(question_id, answer, msg.sender, tokens, false);
475         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
476     }
477 
478     // @notice Verify and store a commitment, including an appropriate timeout
479     // @param question_id The ID of the question to store
480     // @param commitment The ID of the commitment
481     function _storeCommitment(bytes32 question_id, bytes32 commitment_id) 
482     internal
483     {
484         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
485 
486         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
487         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
488     }
489 
490     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
491     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
492     /// The commitment_id is stored in the answer history where the answer would normally go.
493     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
494     /// @param question_id The ID of the question
495     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
496     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
497     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
498     /// @param tokens Number of tokens sent
499     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
500     function submitAnswerCommitmentERC20(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer, uint256 tokens) 
501         stateOpen(question_id)
502         bondMustDouble(question_id, tokens)
503         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
504     external {
505 
506         _deductTokensOrRevert(tokens);
507 
508         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, tokens));
509         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
510 
511         _storeCommitment(question_id, commitment_id);
512         _addAnswerToHistory(question_id, commitment_id, answerer, tokens, true);
513 
514     }
515 
516     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
517     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
518     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
519     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
520     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
521     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
522     /// @param question_id The ID of the question
523     /// @param answer The answer, encoded as bytes32
524     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
525     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
526     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
527         stateOpenOrPendingArbitration(question_id)
528     external {
529 
530         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
531         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
532 
533         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
534         require(commitments[commitment_id].reveal_ts > uint32(now), "reveal deadline must not have passed");
535 
536         commitments[commitment_id].revealed_answer = answer;
537         commitments[commitment_id].is_revealed = true;
538 
539         if (bond == questions[question_id].bond) {
540             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
541         }
542 
543         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
544 
545     }
546 
547     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
548     internal 
549     {
550         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
551 
552         // Update the current bond level, if there's a bond (ie anything except arbitration)
553         if (bond > 0) {
554             questions[question_id].bond = bond;
555         }
556         questions[question_id].history_hash = new_history_hash;
557 
558         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
559     }
560 
561     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
562     internal {
563         questions[question_id].best_answer = answer;
564         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
565     }
566 
567     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
568     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
569     /// @param question_id The ID of the question
570     /// @param requester The account that requested arbitration
571     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
572     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
573         onlyArbitrator(question_id)
574         stateOpen(question_id)
575         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
576     external {
577         require(questions[question_id].bond > 0, "Question must already have an answer when arbitration is requested");
578         questions[question_id].is_pending_arbitration = true;
579         emit LogNotifyOfArbitrationRequest(question_id, requester);
580     }
581 
582     /// @notice Submit the answer for a question, for use by the arbitrator.
583     /// @dev Doesn't require (or allow) a bond.
584     /// If the current final answer is correct, the account should be whoever submitted it.
585     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
586     /// However, the answerer stipulations are not enforced by the contract.
587     /// @param question_id The ID of the question
588     /// @param answer The answer, encoded into bytes32
589     /// @param answerer The account credited with this answer for the purpose of bond claims
590     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
591         onlyArbitrator(question_id)
592         statePendingArbitration(question_id)
593     external {
594 
595         require(answerer != NULL_ADDRESS, "answerer must be provided");
596         emit LogFinalize(question_id, answer);
597 
598         questions[question_id].is_pending_arbitration = false;
599         _addAnswerToHistory(question_id, answer, answerer, 0, false);
600         _updateCurrentAnswer(question_id, answer, 0);
601 
602     }
603 
604     /// @notice Report whether the answer to the specified question is finalized
605     /// @param question_id The ID of the question
606     /// @return Return true if finalized
607     function isFinalized(bytes32 question_id) 
608     view public returns (bool) {
609         uint32 finalize_ts = questions[question_id].finalize_ts;
610         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
611     }
612 
613     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
614     /// @param question_id The ID of the question
615     /// @return The answer formatted as a bytes32
616     function getFinalAnswer(bytes32 question_id) 
617         stateFinalized(question_id)
618     external view returns (bytes32) {
619         return questions[question_id].best_answer;
620     }
621 
622     /// @notice Return the final answer to the specified question, or revert if there isn't one
623     /// @param question_id The ID of the question
624     /// @return The answer formatted as a bytes32
625     function resultFor(bytes32 question_id) 
626         stateFinalized(question_id)
627     external view returns (bytes32) {
628         return questions[question_id].best_answer;
629     }
630 
631 
632     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
633     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
634     /// @param question_id The ID of the question
635     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
636     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
637     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
638     /// @param min_bond The bond sent with the final answer must be this high or higher
639     /// @return The answer formatted as a bytes32
640     function getFinalAnswerIfMatches(
641         bytes32 question_id, 
642         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
643     ) 
644         stateFinalized(question_id)
645     external view returns (bytes32) {
646         require(content_hash == questions[question_id].content_hash, "content hash must match");
647         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
648         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
649         require(min_bond <= questions[question_id].bond, "bond must be high enough");
650         return questions[question_id].best_answer;
651     }
652 
653     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
654     /// Caller must provide the answer history, in reverse order
655     /// @dev Works up the chain and assign bonds to the person who gave the right answer
656     /// If someone gave the winning answer earlier, they must get paid from the higher bond
657     /// That means we can't pay out the bond added at n until we have looked at n-1
658     /// The first answer is authenticated by checking against the stored history_hash.
659     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
660     /// Once we get to a null hash we'll know we're done and there are no more answers.
661     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
662     /// @param question_id The ID of the question
663     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
664     /// @param addrs Last-to-first, the address of each answerer or commitment sender
665     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
666     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
667     function claimWinnings(
668         bytes32 question_id, 
669         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
670     ) 
671         stateFinalized(question_id)
672     public {
673 
674         require(history_hashes.length > 0, "at least one history hash entry must be provided");
675 
676         // These are only set if we split our claim over multiple transactions.
677         address payee = question_claims[question_id].payee; 
678         uint256 last_bond = question_claims[question_id].last_bond; 
679         uint256 queued_funds = question_claims[question_id].queued_funds; 
680 
681         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
682         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
683         bytes32 last_history_hash = questions[question_id].history_hash;
684 
685         bytes32 best_answer = questions[question_id].best_answer;
686 
687         uint256 i;
688         for (i = 0; i < history_hashes.length; i++) {
689         
690             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
691             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
692             
693             queued_funds = queued_funds.add(last_bond); 
694             (queued_funds, payee) = _processHistoryItem(
695                 question_id, best_answer, queued_funds, payee, 
696                 addrs[i], bonds[i], answers[i], is_commitment);
697  
698             // Line the bond up for next time, when it will be added to somebody's queued_funds
699             last_bond = bonds[i];
700             last_history_hash = history_hashes[i];
701 
702         }
703  
704         if (last_history_hash != NULL_HASH) {
705             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
706             // Persist the details so we can pick up later where we left off later.
707 
708             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
709             // (We always know who to pay unless all we saw were unrevealed commits)
710             if (payee != NULL_ADDRESS) {
711                 _payPayee(question_id, payee, queued_funds);
712                 queued_funds = 0;
713             }
714 
715             question_claims[question_id].payee = payee;
716             question_claims[question_id].last_bond = last_bond;
717             question_claims[question_id].queued_funds = queued_funds;
718         } else {
719             // There is nothing left below us so the payee can keep what remains
720             _payPayee(question_id, payee, queued_funds.add(last_bond));
721             delete question_claims[question_id];
722         }
723 
724         questions[question_id].history_hash = last_history_hash;
725 
726     }
727 
728     function _payPayee(bytes32 question_id, address payee, uint256 value) 
729     internal {
730         balanceOf[payee] = balanceOf[payee].add(value);
731         emit LogClaim(question_id, payee, value);
732     }
733 
734     function _verifyHistoryInputOrRevert(
735         bytes32 last_history_hash,
736         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
737     )
738     internal pure returns (bool) {
739         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
740             return true;
741         }
742         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
743             return false;
744         } 
745         revert("History input provided did not match the expected hash");
746     }
747 
748     function _processHistoryItem(
749         bytes32 question_id, bytes32 best_answer, 
750         uint256 queued_funds, address payee, 
751         address addr, uint256 bond, bytes32 answer, bool is_commitment
752     )
753     internal returns (uint256, address) {
754 
755         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
756         // We look at the referenced commitment ID and switch in the actual answer.
757         if (is_commitment) {
758             bytes32 commitment_id = answer;
759             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
760             if (!commitments[commitment_id].is_revealed) {
761                 delete commitments[commitment_id];
762                 return (queued_funds, payee);
763             } else {
764                 answer = commitments[commitment_id].revealed_answer;
765                 delete commitments[commitment_id];
766             }
767         }
768 
769         if (answer == best_answer) {
770 
771             if (payee == NULL_ADDRESS) {
772 
773                 // The entry is for the first payee we come to, ie the winner.
774                 // They get the question bounty.
775                 payee = addr;
776                 queued_funds = queued_funds.add(questions[question_id].bounty);
777                 questions[question_id].bounty = 0;
778 
779             } else if (addr != payee) {
780 
781                 // Answerer has changed, ie we found someone lower down who needs to be paid
782 
783                 // The lower answerer will take over receiving bonds from higher answerer.
784                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
785                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
786 
787                 // There should be enough for the fee, but if not, take what we have.
788                 // There's an edge case involving weird arbitrator behaviour where we may be short.
789                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
790 
791                 // Settle up with the old (higher-bonded) payee
792                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
793 
794                 // Now start queued_funds again for the new (lower-bonded) payee
795                 payee = addr;
796                 queued_funds = answer_takeover_fee;
797 
798             }
799 
800         }
801 
802         return (queued_funds, payee);
803 
804     }
805 
806     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
807     /// Caller must provide the answer history for each question, in reverse order
808     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
809     /// @param question_ids The IDs of the questions you want to claim for
810     /// @param lengths The number of history entries you will supply for each question ID
811     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
812     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
813     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
814     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
815     function claimMultipleAndWithdrawBalance(
816         bytes32[] question_ids, uint256[] lengths, 
817         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
818     ) 
819         stateAny() // The finalization checks are done in the claimWinnings function
820     public {
821         
822         uint256 qi;
823         uint256 i;
824         for (qi = 0; qi < question_ids.length; qi++) {
825             bytes32 qid = question_ids[qi];
826             uint256 ln = lengths[qi];
827             bytes32[] memory hh = new bytes32[](ln);
828             address[] memory ad = new address[](ln);
829             uint256[] memory bo = new uint256[](ln);
830             bytes32[] memory an = new bytes32[](ln);
831             uint256 j;
832             for (j = 0; j < ln; j++) {
833                 hh[j] = hist_hashes[i];
834                 ad[j] = addrs[i];
835                 bo[j] = bonds[i];
836                 an[j] = answers[i];
837                 i++;
838             }
839             claimWinnings(qid, hh, ad, bo, an);
840         }
841         withdraw();
842     }
843 
844     /// @notice Returns the questions's content hash, identifying the question content
845     /// @param question_id The ID of the question 
846     function getContentHash(bytes32 question_id) 
847     public view returns(bytes32) {
848         return questions[question_id].content_hash;
849     }
850 
851     /// @notice Returns the arbitrator address for the question
852     /// @param question_id The ID of the question 
853     function getArbitrator(bytes32 question_id) 
854     public view returns(address) {
855         return questions[question_id].arbitrator;
856     }
857 
858     /// @notice Returns the timestamp when the question can first be answered
859     /// @param question_id The ID of the question 
860     function getOpeningTS(bytes32 question_id) 
861     public view returns(uint32) {
862         return questions[question_id].opening_ts;
863     }
864 
865     /// @notice Returns the timeout in seconds used after each answer
866     /// @param question_id The ID of the question 
867     function getTimeout(bytes32 question_id) 
868     public view returns(uint32) {
869         return questions[question_id].timeout;
870     }
871 
872     /// @notice Returns the timestamp at which the question will be/was finalized
873     /// @param question_id The ID of the question 
874     function getFinalizeTS(bytes32 question_id) 
875     public view returns(uint32) {
876         return questions[question_id].finalize_ts;
877     }
878 
879     /// @notice Returns whether the question is pending arbitration
880     /// @param question_id The ID of the question 
881     function isPendingArbitration(bytes32 question_id) 
882     public view returns(bool) {
883         return questions[question_id].is_pending_arbitration;
884     }
885 
886     /// @notice Returns the current total unclaimed bounty
887     /// @dev Set back to zero once the bounty has been claimed
888     /// @param question_id The ID of the question 
889     function getBounty(bytes32 question_id) 
890     public view returns(uint256) {
891         return questions[question_id].bounty;
892     }
893 
894     /// @notice Returns the current best answer
895     /// @param question_id The ID of the question 
896     function getBestAnswer(bytes32 question_id) 
897     public view returns(bytes32) {
898         return questions[question_id].best_answer;
899     }
900 
901     /// @notice Returns the history hash of the question 
902     /// @param question_id The ID of the question 
903     /// @dev Updated on each answer, then rewound as each is claimed
904     function getHistoryHash(bytes32 question_id) 
905     public view returns(bytes32) {
906         return questions[question_id].history_hash;
907     }
908 
909     /// @notice Returns the highest bond posted so far for a question
910     /// @param question_id The ID of the question 
911     function getBond(bytes32 question_id) 
912     public view returns(uint256) {
913         return questions[question_id].bond;
914     }
915 
916 }