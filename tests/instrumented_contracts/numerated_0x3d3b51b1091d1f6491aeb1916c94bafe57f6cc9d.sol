1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 pragma solidity ^0.4.24;
25 
26 /**
27  * @title ReailtioSafeMath256
28  * @dev Math operations with safety checks that throw on error
29  */
30 library RealitioSafeMath256 {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 pragma solidity ^0.4.24;
59 
60 /**
61  * @title RealitioSafeMath32
62  * @dev Math operations with safety checks that throw on error
63  * @dev Copy of SafeMath but for uint32 instead of uint256
64  * @dev Deleted functions we don't use
65  */
66 library RealitioSafeMath32 {
67   function add(uint32 a, uint32 b) internal pure returns (uint32) {
68     uint32 c = a + b;
69     assert(c >= a);
70     return c;
71   }
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
285     constructor() 
286     public {
287         createTemplate('{"title": "%s", "type": "bool", "category": "%s", "lang": "%s"}');
288         createTemplate('{"title": "%s", "type": "uint", "decimals": 18, "category": "%s", "lang": "%s"}');
289         createTemplate('{"title": "%s", "type": "single-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
290         createTemplate('{"title": "%s", "type": "multiple-select", "outcomes": [%s], "category": "%s", "lang": "%s"}');
291         createTemplate('{"title": "%s", "type": "datetime", "category": "%s", "lang": "%s"}');
292     }
293 
294     /// @notice Function for arbitrator to set an optional per-question fee. 
295     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
296     /// @param fee The fee to be charged by the arbitrator when a question is asked
297     function setQuestionFee(uint256 fee) 
298         stateAny() 
299     external {
300         arbitrator_question_fees[msg.sender] = fee;
301         emit LogSetQuestionFee(msg.sender, fee);
302     }
303 
304     /// @notice Create a reusable template, which should be a JSON document.
305     /// Placeholders should use gettext() syntax, eg %s.
306     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
307     /// @param content The template content
308     /// @return The ID of the newly-created template, which is created sequentially.
309     function createTemplate(string content) 
310         stateAny()
311     public returns (uint256) {
312         uint256 id = nextTemplateID;
313         templates[id] = block.number;
314         template_hashes[id] = keccak256(abi.encodePacked(content));
315         emit LogNewTemplate(id, msg.sender, content);
316         nextTemplateID = id.add(1);
317         return id;
318     }
319 
320     /// @notice Create a new reusable template and use it to ask a question
321     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
322     /// @param content The template content
323     /// @param question A string containing the parameters that will be passed into the template to make the question
324     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
325     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
326     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
327     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
328     /// @return The ID of the newly-created template, which is created sequentially.
329     function createTemplateAndAskQuestion(
330         string content, 
331         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
332     ) 
333         // stateNotCreated is enforced by the internal _askQuestion
334     public returns (bytes32) {
335         uint256 template_id = createTemplate(content);
336         return askQuestion(template_id, question, arbitrator, timeout, opening_ts, nonce);
337     }
338 
339     /// @notice Ask a new question without a bounty and return the ID
340     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
341     /// @dev Calling without the token param will only work if there is no arbitrator-set question fee.
342     /// @dev This has the same function signature as askQuestion() in the non-ERC20 version, which is optionally payable.
343     /// @param template_id The ID number of the template the question will use
344     /// @param question A string containing the parameters that will be passed into the template to make the question
345     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
346     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
347     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
348     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
349     /// @return The ID of the newly-created question, created deterministically.
350     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
351         // stateNotCreated is enforced by the internal _askQuestion
352     public returns (bytes32) {
353 
354         require(templates[template_id] > 0, "template must exist");
355 
356         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
357         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
358 
359         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts, 0);
360         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
361 
362         return question_id;
363     }
364 
365     /// @notice Ask a new question with a bounty and return the ID
366     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
367     /// @param template_id The ID number of the template the question will use
368     /// @param question A string containing the parameters that will be passed into the template to make the question
369     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
370     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
371     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
372     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
373     /// @param tokens The combined initial question bounty and question fee
374     /// @return The ID of the newly-created question, created deterministically.
375     function askQuestionERC20(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce, uint256 tokens) 
376         // stateNotCreated is enforced by the internal _askQuestion
377     public returns (bytes32) {
378 
379         _deductTokensOrRevert(tokens);
380 
381         require(templates[template_id] > 0, "template must exist");
382 
383         bytes32 content_hash = keccak256(abi.encodePacked(template_id, opening_ts, question));
384         bytes32 question_id = keccak256(abi.encodePacked(content_hash, arbitrator, timeout, msg.sender, nonce));
385 
386         _askQuestion(question_id, content_hash, arbitrator, timeout, opening_ts, tokens);
387         emit LogNewQuestion(question_id, msg.sender, template_id, question, content_hash, arbitrator, timeout, opening_ts, nonce, now);
388 
389         return question_id;
390     }
391 
392     function _deductTokensOrRevert(uint256 tokens) 
393     internal {
394 
395         if (tokens == 0) {
396             return;
397         }
398 
399         uint256 bal = balanceOf[msg.sender];
400 
401         // Deduct any tokens you have in your internal balance first
402         if (bal > 0) {
403             if (bal >= tokens) {
404                 balanceOf[msg.sender] = bal.sub(tokens);
405                 return;
406             } else {
407                 tokens = tokens.sub(bal);
408                 balanceOf[msg.sender] = 0;
409             }
410         }
411         // Now we need to charge the rest from 
412         require(token.transferFrom(msg.sender, address(this), tokens), "Transfer of tokens failed, insufficient approved balance?");
413         return;
414 
415     }
416 
417     function _askQuestion(bytes32 question_id, bytes32 content_hash, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 tokens) 
418         stateNotCreated(question_id)
419     internal {
420 
421         uint256 bounty = tokens;
422 
423         // A timeout of 0 makes no sense, and we will use this to check existence
424         require(timeout > 0, "timeout must be positive"); 
425         require(timeout < 365 days, "timeout must be less than 365 days"); 
426         require(arbitrator != NULL_ADDRESS, "arbitrator must be set");
427 
428         // The arbitrator can set a fee for asking a question. 
429         // This is intended as an anti-spam defence.
430         // The fee is waived if the arbitrator is asking the question.
431         // This allows them to set an impossibly high fee and make users proxy the question through them.
432         // This would allow more sophisticated pricing, question whitelisting etc.
433         if (msg.sender != arbitrator) {
434             uint256 question_fee = arbitrator_question_fees[arbitrator];
435             require(bounty >= question_fee, "Tokens provided must cover question fee"); 
436             bounty = bounty.sub(question_fee);
437             balanceOf[arbitrator] = balanceOf[arbitrator].add(question_fee);
438         }
439 
440         questions[question_id].content_hash = content_hash;
441         questions[question_id].arbitrator = arbitrator;
442         questions[question_id].opening_ts = opening_ts;
443         questions[question_id].timeout = timeout;
444         questions[question_id].bounty = bounty;
445 
446     }
447 
448     /// @notice Add funds to the bounty for a question
449     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
450     /// @param question_id The ID of the question you wish to fund
451     /// @param tokens The number of tokens to fund
452     function fundAnswerBountyERC20(bytes32 question_id, uint256 tokens) 
453         stateOpen(question_id)
454     external {
455         _deductTokensOrRevert(tokens);
456         questions[question_id].bounty = questions[question_id].bounty.add(tokens);
457         emit LogFundAnswerBounty(question_id, tokens, questions[question_id].bounty, msg.sender);
458     }
459 
460     /// @notice Submit an answer for a question.
461     /// @dev Adds the answer to the history and updates the current "best" answer.
462     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
463     /// @param question_id The ID of the question
464     /// @param answer The answer, encoded into bytes32
465     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
466     /// @param tokens The amount of tokens to submit
467     function submitAnswerERC20(bytes32 question_id, bytes32 answer, uint256 max_previous, uint256 tokens) 
468         stateOpen(question_id)
469         bondMustDouble(question_id, tokens)
470         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
471     external {
472         _deductTokensOrRevert(tokens);
473         _addAnswerToHistory(question_id, answer, msg.sender, tokens, false);
474         _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
475     }
476 
477     // @notice Verify and store a commitment, including an appropriate timeout
478     // @param question_id The ID of the question to store
479     // @param commitment The ID of the commitment
480     function _storeCommitment(bytes32 question_id, bytes32 commitment_id) 
481     internal
482     {
483         require(commitments[commitment_id].reveal_ts == COMMITMENT_NON_EXISTENT, "commitment must not already exist");
484 
485         uint32 commitment_timeout = questions[question_id].timeout / COMMITMENT_TIMEOUT_RATIO;
486         commitments[commitment_id].reveal_ts = uint32(now).add(commitment_timeout);
487     }
488 
489     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
490     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
491     /// The commitment_id is stored in the answer history where the answer would normally go.
492     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
493     /// @param question_id The ID of the question
494     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
495     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
496     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
497     /// @param tokens Number of tokens sent
498     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
499     function submitAnswerCommitmentERC20(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer, uint256 tokens) 
500         stateOpen(question_id)
501         bondMustDouble(question_id, tokens)
502         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
503     external {
504 
505         _deductTokensOrRevert(tokens);
506 
507         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, tokens));
508         address answerer = (_answerer == NULL_ADDRESS) ? msg.sender : _answerer;
509 
510         _storeCommitment(question_id, commitment_id);
511         _addAnswerToHistory(question_id, commitment_id, answerer, tokens, true);
512 
513     }
514 
515     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
516     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
517     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
518     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
519     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
520     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
521     /// @param question_id The ID of the question
522     /// @param answer The answer, encoded as bytes32
523     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
524     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
525     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
526         stateOpenOrPendingArbitration(question_id)
527     external {
528 
529         bytes32 answer_hash = keccak256(abi.encodePacked(answer, nonce));
530         bytes32 commitment_id = keccak256(abi.encodePacked(question_id, answer_hash, bond));
531 
532         require(!commitments[commitment_id].is_revealed, "commitment must not have been revealed yet");
533         require(commitments[commitment_id].reveal_ts > uint32(now), "reveal deadline must not have passed");
534 
535         commitments[commitment_id].revealed_answer = answer;
536         commitments[commitment_id].is_revealed = true;
537 
538         if (bond == questions[question_id].bond) {
539             _updateCurrentAnswer(question_id, answer, questions[question_id].timeout);
540         }
541 
542         emit LogAnswerReveal(question_id, msg.sender, answer_hash, answer, nonce, bond);
543 
544     }
545 
546     function _addAnswerToHistory(bytes32 question_id, bytes32 answer_or_commitment_id, address answerer, uint256 bond, bool is_commitment) 
547     internal 
548     {
549         bytes32 new_history_hash = keccak256(abi.encodePacked(questions[question_id].history_hash, answer_or_commitment_id, bond, answerer, is_commitment));
550 
551         // Update the current bond level, if there's a bond (ie anything except arbitration)
552         if (bond > 0) {
553             questions[question_id].bond = bond;
554         }
555         questions[question_id].history_hash = new_history_hash;
556 
557         emit LogNewAnswer(answer_or_commitment_id, question_id, new_history_hash, answerer, bond, now, is_commitment);
558     }
559 
560     function _updateCurrentAnswer(bytes32 question_id, bytes32 answer, uint32 timeout_secs)
561     internal {
562         questions[question_id].best_answer = answer;
563         questions[question_id].finalize_ts = uint32(now).add(timeout_secs);
564     }
565 
566     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
567     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
568     /// @param question_id The ID of the question
569     /// @param requester The account that requested arbitration
570     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
571     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
572         onlyArbitrator(question_id)
573         stateOpen(question_id)
574         previousBondMustNotBeatMaxPrevious(question_id, max_previous)
575     external {
576         require(questions[question_id].bond > 0, "Question must already have an answer when arbitration is requested");
577         questions[question_id].is_pending_arbitration = true;
578         emit LogNotifyOfArbitrationRequest(question_id, requester);
579     }
580 
581     /// @notice Submit the answer for a question, for use by the arbitrator.
582     /// @dev Doesn't require (or allow) a bond.
583     /// If the current final answer is correct, the account should be whoever submitted it.
584     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
585     /// However, the answerer stipulations are not enforced by the contract.
586     /// @param question_id The ID of the question
587     /// @param answer The answer, encoded into bytes32
588     /// @param answerer The account credited with this answer for the purpose of bond claims
589     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
590         onlyArbitrator(question_id)
591         statePendingArbitration(question_id)
592     external {
593 
594         require(answerer != NULL_ADDRESS, "answerer must be provided");
595         emit LogFinalize(question_id, answer);
596 
597         questions[question_id].is_pending_arbitration = false;
598         _addAnswerToHistory(question_id, answer, answerer, 0, false);
599         _updateCurrentAnswer(question_id, answer, 0);
600 
601     }
602 
603     /// @notice Report whether the answer to the specified question is finalized
604     /// @param question_id The ID of the question
605     /// @return Return true if finalized
606     function isFinalized(bytes32 question_id) 
607     view public returns (bool) {
608         uint32 finalize_ts = questions[question_id].finalize_ts;
609         return ( !questions[question_id].is_pending_arbitration && (finalize_ts > UNANSWERED) && (finalize_ts <= uint32(now)) );
610     }
611 
612     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
613     /// @param question_id The ID of the question
614     /// @return The answer formatted as a bytes32
615     function getFinalAnswer(bytes32 question_id) 
616         stateFinalized(question_id)
617     external view returns (bytes32) {
618         return questions[question_id].best_answer;
619     }
620 
621     /// @notice Return the final answer to the specified question, or revert if there isn't one
622     /// @param question_id The ID of the question
623     /// @return The answer formatted as a bytes32
624     function resultFor(bytes32 question_id) 
625         stateFinalized(question_id)
626     external view returns (bytes32) {
627         return questions[question_id].best_answer;
628     }
629 
630 
631     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
632     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
633     /// @param question_id The ID of the question
634     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
635     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
636     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
637     /// @param min_bond The bond sent with the final answer must be this high or higher
638     /// @return The answer formatted as a bytes32
639     function getFinalAnswerIfMatches(
640         bytes32 question_id, 
641         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
642     ) 
643         stateFinalized(question_id)
644     external view returns (bytes32) {
645         require(content_hash == questions[question_id].content_hash, "content hash must match");
646         require(arbitrator == questions[question_id].arbitrator, "arbitrator must match");
647         require(min_timeout <= questions[question_id].timeout, "timeout must be long enough");
648         require(min_bond <= questions[question_id].bond, "bond must be high enough");
649         return questions[question_id].best_answer;
650     }
651 
652     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
653     /// Caller must provide the answer history, in reverse order
654     /// @dev Works up the chain and assign bonds to the person who gave the right answer
655     /// If someone gave the winning answer earlier, they must get paid from the higher bond
656     /// That means we can't pay out the bond added at n until we have looked at n-1
657     /// The first answer is authenticated by checking against the stored history_hash.
658     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
659     /// Once we get to a null hash we'll know we're done and there are no more answers.
660     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
661     /// @param question_id The ID of the question
662     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
663     /// @param addrs Last-to-first, the address of each answerer or commitment sender
664     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
665     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
666     function claimWinnings(
667         bytes32 question_id, 
668         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
669     ) 
670         stateFinalized(question_id)
671     public {
672 
673         require(history_hashes.length > 0, "at least one history hash entry must be provided");
674 
675         // These are only set if we split our claim over multiple transactions.
676         address payee = question_claims[question_id].payee; 
677         uint256 last_bond = question_claims[question_id].last_bond; 
678         uint256 queued_funds = question_claims[question_id].queued_funds; 
679 
680         // Starts as the hash of the final answer submitted. It'll be cleared when we're done.
681         // If we're splitting the claim over multiple transactions, it'll be the hash where we left off last time
682         bytes32 last_history_hash = questions[question_id].history_hash;
683 
684         bytes32 best_answer = questions[question_id].best_answer;
685 
686         uint256 i;
687         for (i = 0; i < history_hashes.length; i++) {
688         
689             // Check input against the history hash, and see which of 2 possible values of is_commitment fits.
690             bool is_commitment = _verifyHistoryInputOrRevert(last_history_hash, history_hashes[i], answers[i], bonds[i], addrs[i]);
691             
692             queued_funds = queued_funds.add(last_bond); 
693             (queued_funds, payee) = _processHistoryItem(
694                 question_id, best_answer, queued_funds, payee, 
695                 addrs[i], bonds[i], answers[i], is_commitment);
696  
697             // Line the bond up for next time, when it will be added to somebody's queued_funds
698             last_bond = bonds[i];
699             last_history_hash = history_hashes[i];
700 
701         }
702  
703         if (last_history_hash != NULL_HASH) {
704             // We haven't yet got to the null hash (1st answer), ie the caller didn't supply the full answer chain.
705             // Persist the details so we can pick up later where we left off later.
706 
707             // If we know who to pay we can go ahead and pay them out, only keeping back last_bond
708             // (We always know who to pay unless all we saw were unrevealed commits)
709             if (payee != NULL_ADDRESS) {
710                 _payPayee(question_id, payee, queued_funds);
711                 queued_funds = 0;
712             }
713 
714             question_claims[question_id].payee = payee;
715             question_claims[question_id].last_bond = last_bond;
716             question_claims[question_id].queued_funds = queued_funds;
717         } else {
718             // There is nothing left below us so the payee can keep what remains
719             _payPayee(question_id, payee, queued_funds.add(last_bond));
720             delete question_claims[question_id];
721         }
722 
723         questions[question_id].history_hash = last_history_hash;
724 
725     }
726 
727     function _payPayee(bytes32 question_id, address payee, uint256 value) 
728     internal {
729         balanceOf[payee] = balanceOf[payee].add(value);
730         emit LogClaim(question_id, payee, value);
731     }
732 
733     function _verifyHistoryInputOrRevert(
734         bytes32 last_history_hash,
735         bytes32 history_hash, bytes32 answer, uint256 bond, address addr
736     )
737     internal pure returns (bool) {
738         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, true)) ) {
739             return true;
740         }
741         if (last_history_hash == keccak256(abi.encodePacked(history_hash, answer, bond, addr, false)) ) {
742             return false;
743         } 
744         revert("History input provided did not match the expected hash");
745     }
746 
747     function _processHistoryItem(
748         bytes32 question_id, bytes32 best_answer, 
749         uint256 queued_funds, address payee, 
750         address addr, uint256 bond, bytes32 answer, bool is_commitment
751     )
752     internal returns (uint256, address) {
753 
754         // For commit-and-reveal, the answer history holds the commitment ID instead of the answer.
755         // We look at the referenced commitment ID and switch in the actual answer.
756         if (is_commitment) {
757             bytes32 commitment_id = answer;
758             // If it's a commit but it hasn't been revealed, it will always be considered wrong.
759             if (!commitments[commitment_id].is_revealed) {
760                 delete commitments[commitment_id];
761                 return (queued_funds, payee);
762             } else {
763                 answer = commitments[commitment_id].revealed_answer;
764                 delete commitments[commitment_id];
765             }
766         }
767 
768         if (answer == best_answer) {
769 
770             if (payee == NULL_ADDRESS) {
771 
772                 // The entry is for the first payee we come to, ie the winner.
773                 // They get the question bounty.
774                 payee = addr;
775                 queued_funds = queued_funds.add(questions[question_id].bounty);
776                 questions[question_id].bounty = 0;
777 
778             } else if (addr != payee) {
779 
780                 // Answerer has changed, ie we found someone lower down who needs to be paid
781 
782                 // The lower answerer will take over receiving bonds from higher answerer.
783                 // They should also be paid the takeover fee, which is set at a rate equivalent to their bond. 
784                 // (This is our arbitrary rule, to give consistent right-answerers a defence against high-rollers.)
785 
786                 // There should be enough for the fee, but if not, take what we have.
787                 // There's an edge case involving weird arbitrator behaviour where we may be short.
788                 uint256 answer_takeover_fee = (queued_funds >= bond) ? bond : queued_funds;
789 
790                 // Settle up with the old (higher-bonded) payee
791                 _payPayee(question_id, payee, queued_funds.sub(answer_takeover_fee));
792 
793                 // Now start queued_funds again for the new (lower-bonded) payee
794                 payee = addr;
795                 queued_funds = answer_takeover_fee;
796 
797             }
798 
799         }
800 
801         return (queued_funds, payee);
802 
803     }
804 
805     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
806     /// Caller must provide the answer history for each question, in reverse order
807     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
808     /// @param question_ids The IDs of the questions you want to claim for
809     /// @param lengths The number of history entries you will supply for each question ID
810     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
811     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
812     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
813     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
814     function claimMultipleAndWithdrawBalance(
815         bytes32[] question_ids, uint256[] lengths, 
816         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
817     ) 
818         stateAny() // The finalization checks are done in the claimWinnings function
819     public {
820         
821         uint256 qi;
822         uint256 i;
823         for (qi = 0; qi < question_ids.length; qi++) {
824             bytes32 qid = question_ids[qi];
825             uint256 ln = lengths[qi];
826             bytes32[] memory hh = new bytes32[](ln);
827             address[] memory ad = new address[](ln);
828             uint256[] memory bo = new uint256[](ln);
829             bytes32[] memory an = new bytes32[](ln);
830             uint256 j;
831             for (j = 0; j < ln; j++) {
832                 hh[j] = hist_hashes[i];
833                 ad[j] = addrs[i];
834                 bo[j] = bonds[i];
835                 an[j] = answers[i];
836                 i++;
837             }
838             claimWinnings(qid, hh, ad, bo, an);
839         }
840         withdraw();
841     }
842 
843     /// @notice Returns the questions's content hash, identifying the question content
844     /// @param question_id The ID of the question 
845     function getContentHash(bytes32 question_id) 
846     public view returns(bytes32) {
847         return questions[question_id].content_hash;
848     }
849 
850     /// @notice Returns the arbitrator address for the question
851     /// @param question_id The ID of the question 
852     function getArbitrator(bytes32 question_id) 
853     public view returns(address) {
854         return questions[question_id].arbitrator;
855     }
856 
857     /// @notice Returns the timestamp when the question can first be answered
858     /// @param question_id The ID of the question 
859     function getOpeningTS(bytes32 question_id) 
860     public view returns(uint32) {
861         return questions[question_id].opening_ts;
862     }
863 
864     /// @notice Returns the timeout in seconds used after each answer
865     /// @param question_id The ID of the question 
866     function getTimeout(bytes32 question_id) 
867     public view returns(uint32) {
868         return questions[question_id].timeout;
869     }
870 
871     /// @notice Returns the timestamp at which the question will be/was finalized
872     /// @param question_id The ID of the question 
873     function getFinalizeTS(bytes32 question_id) 
874     public view returns(uint32) {
875         return questions[question_id].finalize_ts;
876     }
877 
878     /// @notice Returns whether the question is pending arbitration
879     /// @param question_id The ID of the question 
880     function isPendingArbitration(bytes32 question_id) 
881     public view returns(bool) {
882         return questions[question_id].is_pending_arbitration;
883     }
884 
885     /// @notice Returns the current total unclaimed bounty
886     /// @dev Set back to zero once the bounty has been claimed
887     /// @param question_id The ID of the question 
888     function getBounty(bytes32 question_id) 
889     public view returns(uint256) {
890         return questions[question_id].bounty;
891     }
892 
893     /// @notice Returns the current best answer
894     /// @param question_id The ID of the question 
895     function getBestAnswer(bytes32 question_id) 
896     public view returns(bytes32) {
897         return questions[question_id].best_answer;
898     }
899 
900     /// @notice Returns the history hash of the question 
901     /// @param question_id The ID of the question 
902     /// @dev Updated on each answer, then rewound as each is claimed
903     function getHistoryHash(bytes32 question_id) 
904     public view returns(bytes32) {
905         return questions[question_id].history_hash;
906     }
907 
908     /// @notice Returns the highest bond posted so far for a question
909     /// @param question_id The ID of the question 
910     function getBond(bytes32 question_id) 
911     public view returns(uint256) {
912         return questions[question_id].bond;
913     }
914 
915 }