1 pragma solidity ^0.4.25;
2 
3 contract BalanceHolder {
4 
5     mapping(address => uint256) public balanceOf;
6 
7     event LogWithdraw(
8         address indexed user,
9         uint256 amount
10     );
11 
12     function withdraw() 
13     public {
14         uint256 bal = balanceOf[msg.sender];
15         balanceOf[msg.sender] = 0;
16         msg.sender.transfer(bal);
17         emit LogWithdraw(msg.sender, bal);
18     }
19 
20 }
21 
22 contract IBalanceHolder {
23 
24     mapping(address => uint256) public balanceOf;
25 
26     function withdraw() 
27     public {
28     }
29 
30 }
31 
32 contract IRealitio is IBalanceHolder {
33 
34     struct Question {
35         bytes32 content_hash;
36         address arbitrator;
37         uint32 opening_ts;
38         uint32 timeout;
39         uint32 finalize_ts;
40         bool is_pending_arbitration;
41         uint256 bounty;
42         bytes32 best_answer;
43         bytes32 history_hash;
44         uint256 bond;
45     }
46 
47     // Stored in a mapping indexed by commitment_id, a hash of commitment hash, question, bond. 
48     struct Commitment {
49         uint32 reveal_ts;
50         bool is_revealed;
51         bytes32 revealed_answer;
52     }
53 
54     // Only used when claiming more bonds than fits into a transaction
55     // Stored in a mapping indexed by question_id.
56     struct Claim {
57         address payee;
58         uint256 last_bond;
59         uint256 queued_funds;
60     }
61 
62     uint256 nextTemplateID = 0;
63     mapping(uint256 => uint256) public templates;
64     mapping(uint256 => bytes32) public template_hashes;
65     mapping(bytes32 => Question) public questions;
66     mapping(bytes32 => Claim) public question_claims;
67     mapping(bytes32 => Commitment) public commitments;
68     mapping(address => uint256) public arbitrator_question_fees; 
69 
70     /// @notice Function for arbitrator to set an optional per-question fee. 
71     /// @dev The per-question fee, charged when a question is asked, is intended as an anti-spam measure.
72     /// @param fee The fee to be charged by the arbitrator when a question is asked
73     function setQuestionFee(uint256 fee) 
74     external {
75     }
76 
77     /// @notice Create a reusable template, which should be a JSON document.
78     /// Placeholders should use gettext() syntax, eg %s.
79     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
80     /// @param content The template content
81     /// @return The ID of the newly-created template, which is created sequentially.
82     function createTemplate(string content) 
83     public returns (uint256) {
84     }
85 
86     /// @notice Create a new reusable template and use it to ask a question
87     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
88     /// @param content The template content
89     /// @param question A string containing the parameters that will be passed into the template to make the question
90     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
91     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
92     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
93     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
94     /// @return The ID of the newly-created template, which is created sequentially.
95     function createTemplateAndAskQuestion(
96         string content, 
97         string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce 
98     ) 
99         // stateNotCreated is enforced by the internal _askQuestion
100     public payable returns (bytes32) {
101     }
102 
103     /// @notice Ask a new question and return the ID
104     /// @dev Template data is only stored in the event logs, but its block number is kept in contract storage.
105     /// @param template_id The ID number of the template the question will use
106     /// @param question A string containing the parameters that will be passed into the template to make the question
107     /// @param arbitrator The arbitration contract that will have the final word on the answer if there is a dispute
108     /// @param timeout How long the contract should wait after the answer is changed before finalizing on that answer
109     /// @param opening_ts If set, the earliest time it should be possible to answer the question.
110     /// @param nonce A user-specified nonce used in the question ID. Change it to repeat a question.
111     /// @return The ID of the newly-created question, created deterministically.
112     function askQuestion(uint256 template_id, string question, address arbitrator, uint32 timeout, uint32 opening_ts, uint256 nonce) 
113         // stateNotCreated is enforced by the internal _askQuestion
114     public payable returns (bytes32) {
115     }
116 
117     /// @notice Add funds to the bounty for a question
118     /// @dev Add bounty funds after the initial question creation. Can be done any time until the question is finalized.
119     /// @param question_id The ID of the question you wish to fund
120     function fundAnswerBounty(bytes32 question_id) 
121     external payable {
122     }
123 
124     /// @notice Submit an answer for a question.
125     /// @dev Adds the answer to the history and updates the current "best" answer.
126     /// May be subject to front-running attacks; Substitute submitAnswerCommitment()->submitAnswerReveal() to prevent them.
127     /// @param question_id The ID of the question
128     /// @param answer The answer, encoded into bytes32
129     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
130     function submitAnswer(bytes32 question_id, bytes32 answer, uint256 max_previous) 
131     external payable {
132     }
133 
134     /// @notice Submit the hash of an answer, laying your claim to that answer if you reveal it in a subsequent transaction.
135     /// @dev Creates a hash, commitment_id, uniquely identifying this answer, to this question, with this bond.
136     /// The commitment_id is stored in the answer history where the answer would normally go.
137     /// Does not update the current best answer - this is left to the later submitAnswerReveal() transaction.
138     /// @param question_id The ID of the question
139     /// @param answer_hash The hash of your answer, plus a nonce that you will later reveal
140     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
141     /// @param _answerer If specified, the address to be given as the question answerer. Defaults to the sender.
142     /// @dev Specifying the answerer is useful if you want to delegate the commit-and-reveal to a third-party.
143     function submitAnswerCommitment(bytes32 question_id, bytes32 answer_hash, uint256 max_previous, address _answerer) 
144     external payable {
145     }
146 
147     /// @notice Submit the answer whose hash you sent in a previous submitAnswerCommitment() transaction
148     /// @dev Checks the parameters supplied recreate an existing commitment, and stores the revealed answer
149     /// Updates the current answer unless someone has since supplied a new answer with a higher bond
150     /// msg.sender is intentionally not restricted to the user who originally sent the commitment; 
151     /// For example, the user may want to provide the answer+nonce to a third-party service and let them send the tx
152     /// NB If we are pending arbitration, it will be up to the arbitrator to wait and see any outstanding reveal is sent
153     /// @param question_id The ID of the question
154     /// @param answer The answer, encoded as bytes32
155     /// @param nonce The nonce that, combined with the answer, recreates the answer_hash you gave in submitAnswerCommitment()
156     /// @param bond The bond that you paid in your submitAnswerCommitment() transaction
157     function submitAnswerReveal(bytes32 question_id, bytes32 answer, uint256 nonce, uint256 bond) 
158     external {
159     }
160 
161     /// @notice Notify the contract that the arbitrator has been paid for a question, freezing it pending their decision.
162     /// @dev The arbitrator contract is trusted to only call this if they've been paid, and tell us who paid them.
163     /// @param question_id The ID of the question
164     /// @param requester The account that requested arbitration
165     /// @param max_previous If specified, reverts if a bond higher than this was submitted after you sent your transaction.
166     function notifyOfArbitrationRequest(bytes32 question_id, address requester, uint256 max_previous) 
167     external {
168     }
169 
170     /// @notice Submit the answer for a question, for use by the arbitrator.
171     /// @dev Doesn't require (or allow) a bond.
172     /// If the current final answer is correct, the account should be whoever submitted it.
173     /// If the current final answer is wrong, the account should be whoever paid for arbitration.
174     /// However, the answerer stipulations are not enforced by the contract.
175     /// @param question_id The ID of the question
176     /// @param answer The answer, encoded into bytes32
177     /// @param answerer The account credited with this answer for the purpose of bond claims
178     function submitAnswerByArbitrator(bytes32 question_id, bytes32 answer, address answerer) 
179     external {
180     }
181 
182     /// @notice Report whether the answer to the specified question is finalized
183     /// @param question_id The ID of the question
184     /// @return Return true if finalized
185     function isFinalized(bytes32 question_id) 
186     view public returns (bool) {
187     }
188 
189     /// @notice (Deprecated) Return the final answer to the specified question, or revert if there isn't one
190     /// @param question_id The ID of the question
191     /// @return The answer formatted as a bytes32
192     function getFinalAnswer(bytes32 question_id) 
193     external view returns (bytes32) {
194     }
195 
196     /// @notice Return the final answer to the specified question, or revert if there isn't one
197     /// @param question_id The ID of the question
198     /// @return The answer formatted as a bytes32
199     function resultFor(bytes32 question_id) 
200     external view returns (bytes32) {
201     }
202 
203 
204     /// @notice Return the final answer to the specified question, provided it matches the specified criteria.
205     /// @dev Reverts if the question is not finalized, or if it does not match the specified criteria.
206     /// @param question_id The ID of the question
207     /// @param content_hash The hash of the question content (template ID + opening time + question parameter string)
208     /// @param arbitrator The arbitrator chosen for the question (regardless of whether they are asked to arbitrate)
209     /// @param min_timeout The timeout set in the initial question settings must be this high or higher
210     /// @param min_bond The bond sent with the final answer must be this high or higher
211     /// @return The answer formatted as a bytes32
212     function getFinalAnswerIfMatches(
213         bytes32 question_id, 
214         bytes32 content_hash, address arbitrator, uint32 min_timeout, uint256 min_bond
215     ) 
216     external view returns (bytes32) {
217     }
218 
219     /// @notice Assigns the winnings (bounty and bonds) to everyone who gave the accepted answer
220     /// Caller must provide the answer history, in reverse order
221     /// @dev Works up the chain and assign bonds to the person who gave the right answer
222     /// If someone gave the winning answer earlier, they must get paid from the higher bond
223     /// That means we can't pay out the bond added at n until we have looked at n-1
224     /// The first answer is authenticated by checking against the stored history_hash.
225     /// One of the inputs to history_hash is the history_hash before it, so we use that to authenticate the next entry, etc
226     /// Once we get to a null hash we'll know we're done and there are no more answers.
227     /// Usually you would call the whole thing in a single transaction, but if not then the data is persisted to pick up later.
228     /// @param question_id The ID of the question
229     /// @param history_hashes Second-last-to-first, the hash of each history entry. (Final one should be empty).
230     /// @param addrs Last-to-first, the address of each answerer or commitment sender
231     /// @param bonds Last-to-first, the bond supplied with each answer or commitment
232     /// @param answers Last-to-first, each answer supplied, or commitment ID if the answer was supplied with commit->reveal
233     function claimWinnings(
234         bytes32 question_id, 
235         bytes32[] history_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
236     ) 
237     public {
238     }
239 
240     /// @notice Convenience function to assign bounties/bonds for multiple questions in one go, then withdraw all your funds.
241     /// Caller must provide the answer history for each question, in reverse order
242     /// @dev Can be called by anyone to assign bonds/bounties, but funds are only withdrawn for the user making the call.
243     /// @param question_ids The IDs of the questions you want to claim for
244     /// @param lengths The number of history entries you will supply for each question ID
245     /// @param hist_hashes In a single list for all supplied questions, the hash of each history entry.
246     /// @param addrs In a single list for all supplied questions, the address of each answerer or commitment sender
247     /// @param bonds In a single list for all supplied questions, the bond supplied with each answer or commitment
248     /// @param answers In a single list for all supplied questions, each answer supplied, or commitment ID 
249     function claimMultipleAndWithdrawBalance(
250         bytes32[] question_ids, uint256[] lengths, 
251         bytes32[] hist_hashes, address[] addrs, uint256[] bonds, bytes32[] answers
252     ) 
253     public {
254     }
255 
256     /// @notice Returns the questions's content hash, identifying the question content
257     /// @param question_id The ID of the question 
258     function getContentHash(bytes32 question_id) 
259     public view returns(bytes32) {
260     }
261 
262     /// @notice Returns the arbitrator address for the question
263     /// @param question_id The ID of the question 
264     function getArbitrator(bytes32 question_id) 
265     public view returns(address) {
266     }
267 
268     /// @notice Returns the timestamp when the question can first be answered
269     /// @param question_id The ID of the question 
270     function getOpeningTS(bytes32 question_id) 
271     public view returns(uint32) {
272     }
273 
274     /// @notice Returns the timeout in seconds used after each answer
275     /// @param question_id The ID of the question 
276     function getTimeout(bytes32 question_id) 
277     public view returns(uint32) {
278     }
279 
280     /// @notice Returns the timestamp at which the question will be/was finalized
281     /// @param question_id The ID of the question 
282     function getFinalizeTS(bytes32 question_id) 
283     public view returns(uint32) {
284     }
285 
286     /// @notice Returns whether the question is pending arbitration
287     /// @param question_id The ID of the question 
288     function isPendingArbitration(bytes32 question_id) 
289     public view returns(bool) {
290     }
291 
292     /// @notice Returns the current total unclaimed bounty
293     /// @dev Set back to zero once the bounty has been claimed
294     /// @param question_id The ID of the question 
295     function getBounty(bytes32 question_id) 
296     public view returns(uint256) {
297     }
298 
299     /// @notice Returns the current best answer
300     /// @param question_id The ID of the question 
301     function getBestAnswer(bytes32 question_id) 
302     public view returns(bytes32) {
303     }
304 
305     /// @notice Returns the history hash of the question 
306     /// @param question_id The ID of the question 
307     /// @dev Updated on each answer, then rewound as each is claimed
308     function getHistoryHash(bytes32 question_id) 
309     public view returns(bytes32) {
310     }
311 
312     /// @notice Returns the highest bond posted so far for a question
313     /// @param question_id The ID of the question 
314     function getBond(bytes32 question_id) 
315     public view returns(uint256) {
316     }
317 
318 }
319 /*
320  * @title String & slice utility library for Solidity contracts.
321  * @author Nick Johnson <arachnid@notdot.net>
322  *
323  * @dev Functionality in this library is largely implemented using an
324  *      abstraction called a 'slice'. A slice represents a part of a string -
325  *      anything from the entire string to a single character, or even no
326  *      characters at all (a 0-length slice). Since a slice only has to specify
327  *      an offset and a length, copying and manipulating slices is a lot less
328  *      expensive than copying and manipulating the strings they reference.
329  *
330  *      To further reduce gas costs, most functions on slice that need to return
331  *      a slice modify the original one instead of allocating a new one; for
332  *      instance, `s.split(".")` will return the text up to the first '.',
333  *      modifying s to only contain the remainder of the string after the '.'.
334  *      In situations where you do not want to modify the original slice, you
335  *      can make a copy first with `.copy()`, for example:
336  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
337  *      Solidity has no memory management, it will result in allocating many
338  *      short-lived slices that are later discarded.
339  *
340  *      Functions that return two slices come in two versions: a non-allocating
341  *      version that takes the second slice as an argument, modifying it in
342  *      place, and an allocating version that allocates and returns the second
343  *      slice; see `nextRune` for example.
344  *
345  *      Functions that have to copy string data will return strings rather than
346  *      slices; these can be cast back to slices for further processing if
347  *      required.
348  *
349  *      For convenience, some functions are provided with non-modifying
350  *      variants that create a new slice and return both; for instance,
351  *      `s.splitNew('.')` leaves s unmodified, and returns two values
352  *      corresponding to the left and right parts of the string.
353  */
354 
355 
356 library strings {
357     struct slice {
358         uint _len;
359         uint _ptr;
360     }
361 
362     function memcpy(uint dest, uint src, uint len) private pure {
363         // Copy word-length chunks while possible
364         for(; len >= 32; len -= 32) {
365             assembly {
366                 mstore(dest, mload(src))
367             }
368             dest += 32;
369             src += 32;
370         }
371 
372         // Copy remaining bytes
373         uint mask = 256 ** (32 - len) - 1;
374         assembly {
375             let srcpart := and(mload(src), not(mask))
376             let destpart := and(mload(dest), mask)
377             mstore(dest, or(destpart, srcpart))
378         }
379     }
380 
381     /*
382      * @dev Returns a slice containing the entire string.
383      * @param self The string to make a slice from.
384      * @return A newly allocated slice containing the entire string.
385      */
386     function toSlice(string memory self) internal pure returns (slice memory) {
387         uint ptr;
388         assembly {
389             ptr := add(self, 0x20)
390         }
391         return slice(bytes(self).length, ptr);
392     }
393 
394     /*
395      * @dev Returns the length of a null-terminated bytes32 string.
396      * @param self The value to find the length of.
397      * @return The length of the string, from 0 to 32.
398      */
399     function len(bytes32 self) internal pure returns (uint) {
400         uint ret;
401         if (self == 0)
402             return 0;
403         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
404             ret += 16;
405             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
406         }
407         if (self & 0xffffffffffffffff == 0) {
408             ret += 8;
409             self = bytes32(uint(self) / 0x10000000000000000);
410         }
411         if (self & 0xffffffff == 0) {
412             ret += 4;
413             self = bytes32(uint(self) / 0x100000000);
414         }
415         if (self & 0xffff == 0) {
416             ret += 2;
417             self = bytes32(uint(self) / 0x10000);
418         }
419         if (self & 0xff == 0) {
420             ret += 1;
421         }
422         return 32 - ret;
423     }
424 
425     /*
426      * @dev Returns a slice containing the entire bytes32, interpreted as a
427      *      null-terminated utf-8 string.
428      * @param self The bytes32 value to convert to a slice.
429      * @return A new slice containing the value of the input argument up to the
430      *         first null.
431      */
432     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
433         // Allocate space for `self` in memory, copy it there, and point ret at it
434         assembly {
435             let ptr := mload(0x40)
436             mstore(0x40, add(ptr, 0x20))
437             mstore(ptr, self)
438             mstore(add(ret, 0x20), ptr)
439         }
440         ret._len = len(self);
441     }
442 
443     /*
444      * @dev Returns a new slice containing the same data as the current slice.
445      * @param self The slice to copy.
446      * @return A new slice containing the same data as `self`.
447      */
448     function copy(slice memory self) internal pure returns (slice memory) {
449         return slice(self._len, self._ptr);
450     }
451 
452     /*
453      * @dev Copies a slice to a new string.
454      * @param self The slice to copy.
455      * @return A newly allocated string containing the slice's text.
456      */
457     function toString(slice memory self) internal pure returns (string memory) {
458         string memory ret = new string(self._len);
459         uint retptr;
460         assembly { retptr := add(ret, 32) }
461 
462         memcpy(retptr, self._ptr, self._len);
463         return ret;
464     }
465 
466     /*
467      * @dev Returns the length in runes of the slice. Note that this operation
468      *      takes time proportional to the length of the slice; avoid using it
469      *      in loops, and call `slice.empty()` if you only need to know whether
470      *      the slice is empty or not.
471      * @param self The slice to operate on.
472      * @return The length of the slice in runes.
473      */
474     function len(slice memory self) internal pure returns (uint l) {
475         // Starting at ptr-31 means the LSB will be the byte we care about
476         uint ptr = self._ptr - 31;
477         uint end = ptr + self._len;
478         for (l = 0; ptr < end; l++) {
479             uint8 b;
480             assembly { b := and(mload(ptr), 0xFF) }
481             if (b < 0x80) {
482                 ptr += 1;
483             } else if(b < 0xE0) {
484                 ptr += 2;
485             } else if(b < 0xF0) {
486                 ptr += 3;
487             } else if(b < 0xF8) {
488                 ptr += 4;
489             } else if(b < 0xFC) {
490                 ptr += 5;
491             } else {
492                 ptr += 6;
493             }
494         }
495     }
496 
497     /*
498      * @dev Returns true if the slice is empty (has a length of 0).
499      * @param self The slice to operate on.
500      * @return True if the slice is empty, False otherwise.
501      */
502     function empty(slice memory self) internal pure returns (bool) {
503         return self._len == 0;
504     }
505 
506     /*
507      * @dev Returns a positive number if `other` comes lexicographically after
508      *      `self`, a negative number if it comes before, or zero if the
509      *      contents of the two slices are equal. Comparison is done per-rune,
510      *      on unicode codepoints.
511      * @param self The first slice to compare.
512      * @param other The second slice to compare.
513      * @return The result of the comparison.
514      */
515     function compare(slice memory self, slice memory other) internal pure returns (int) {
516         uint shortest = self._len;
517         if (other._len < self._len)
518             shortest = other._len;
519 
520         uint selfptr = self._ptr;
521         uint otherptr = other._ptr;
522         for (uint idx = 0; idx < shortest; idx += 32) {
523             uint a;
524             uint b;
525             assembly {
526                 a := mload(selfptr)
527                 b := mload(otherptr)
528             }
529             if (a != b) {
530                 // Mask out irrelevant bytes and check again
531                 uint256 mask = uint256(-1); // 0xffff...
532                 if(shortest < 32) {
533                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
534                 }
535                 uint256 diff = (a & mask) - (b & mask);
536                 if (diff != 0)
537                     return int(diff);
538             }
539             selfptr += 32;
540             otherptr += 32;
541         }
542         return int(self._len) - int(other._len);
543     }
544 
545     /*
546      * @dev Returns true if the two slices contain the same text.
547      * @param self The first slice to compare.
548      * @param self The second slice to compare.
549      * @return True if the slices are equal, false otherwise.
550      */
551     function equals(slice memory self, slice memory other) internal pure returns (bool) {
552         return compare(self, other) == 0;
553     }
554 
555     /*
556      * @dev Extracts the first rune in the slice into `rune`, advancing the
557      *      slice to point to the next rune and returning `self`.
558      * @param self The slice to operate on.
559      * @param rune The slice that will contain the first rune.
560      * @return `rune`.
561      */
562     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
563         rune._ptr = self._ptr;
564 
565         if (self._len == 0) {
566             rune._len = 0;
567             return rune;
568         }
569 
570         uint l;
571         uint b;
572         // Load the first byte of the rune into the LSBs of b
573         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
574         if (b < 0x80) {
575             l = 1;
576         } else if(b < 0xE0) {
577             l = 2;
578         } else if(b < 0xF0) {
579             l = 3;
580         } else {
581             l = 4;
582         }
583 
584         // Check for truncated codepoints
585         if (l > self._len) {
586             rune._len = self._len;
587             self._ptr += self._len;
588             self._len = 0;
589             return rune;
590         }
591 
592         self._ptr += l;
593         self._len -= l;
594         rune._len = l;
595         return rune;
596     }
597 
598     /*
599      * @dev Returns the first rune in the slice, advancing the slice to point
600      *      to the next rune.
601      * @param self The slice to operate on.
602      * @return A slice containing only the first rune from `self`.
603      */
604     function nextRune(slice memory self) internal pure returns (slice memory ret) {
605         nextRune(self, ret);
606     }
607 
608     /*
609      * @dev Returns the number of the first codepoint in the slice.
610      * @param self The slice to operate on.
611      * @return The number of the first codepoint in the slice.
612      */
613     function ord(slice memory self) internal pure returns (uint ret) {
614         if (self._len == 0) {
615             return 0;
616         }
617 
618         uint word;
619         uint length;
620         uint divisor = 2 ** 248;
621 
622         // Load the rune into the MSBs of b
623         assembly { word:= mload(mload(add(self, 32))) }
624         uint b = word / divisor;
625         if (b < 0x80) {
626             ret = b;
627             length = 1;
628         } else if(b < 0xE0) {
629             ret = b & 0x1F;
630             length = 2;
631         } else if(b < 0xF0) {
632             ret = b & 0x0F;
633             length = 3;
634         } else {
635             ret = b & 0x07;
636             length = 4;
637         }
638 
639         // Check for truncated codepoints
640         if (length > self._len) {
641             return 0;
642         }
643 
644         for (uint i = 1; i < length; i++) {
645             divisor = divisor / 256;
646             b = (word / divisor) & 0xFF;
647             if (b & 0xC0 != 0x80) {
648                 // Invalid UTF-8 sequence
649                 return 0;
650             }
651             ret = (ret * 64) | (b & 0x3F);
652         }
653 
654         return ret;
655     }
656 
657     /*
658      * @dev Returns the keccak-256 hash of the slice.
659      * @param self The slice to hash.
660      * @return The hash of the slice.
661      */
662     function keccak(slice memory self) internal pure returns (bytes32 ret) {
663         assembly {
664             ret := keccak256(mload(add(self, 32)), mload(self))
665         }
666     }
667 
668     /*
669      * @dev Returns true if `self` starts with `needle`.
670      * @param self The slice to operate on.
671      * @param needle The slice to search for.
672      * @return True if the slice starts with the provided text, false otherwise.
673      */
674     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
675         if (self._len < needle._len) {
676             return false;
677         }
678 
679         if (self._ptr == needle._ptr) {
680             return true;
681         }
682 
683         bool equal;
684         assembly {
685             let length := mload(needle)
686             let selfptr := mload(add(self, 0x20))
687             let needleptr := mload(add(needle, 0x20))
688             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
689         }
690         return equal;
691     }
692 
693     /*
694      * @dev If `self` starts with `needle`, `needle` is removed from the
695      *      beginning of `self`. Otherwise, `self` is unmodified.
696      * @param self The slice to operate on.
697      * @param needle The slice to search for.
698      * @return `self`
699      */
700     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
701         if (self._len < needle._len) {
702             return self;
703         }
704 
705         bool equal = true;
706         if (self._ptr != needle._ptr) {
707             assembly {
708                 let length := mload(needle)
709                 let selfptr := mload(add(self, 0x20))
710                 let needleptr := mload(add(needle, 0x20))
711                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
712             }
713         }
714 
715         if (equal) {
716             self._len -= needle._len;
717             self._ptr += needle._len;
718         }
719 
720         return self;
721     }
722 
723     /*
724      * @dev Returns true if the slice ends with `needle`.
725      * @param self The slice to operate on.
726      * @param needle The slice to search for.
727      * @return True if the slice starts with the provided text, false otherwise.
728      */
729     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
730         if (self._len < needle._len) {
731             return false;
732         }
733 
734         uint selfptr = self._ptr + self._len - needle._len;
735 
736         if (selfptr == needle._ptr) {
737             return true;
738         }
739 
740         bool equal;
741         assembly {
742             let length := mload(needle)
743             let needleptr := mload(add(needle, 0x20))
744             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
745         }
746 
747         return equal;
748     }
749 
750     /*
751      * @dev If `self` ends with `needle`, `needle` is removed from the
752      *      end of `self`. Otherwise, `self` is unmodified.
753      * @param self The slice to operate on.
754      * @param needle The slice to search for.
755      * @return `self`
756      */
757     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
758         if (self._len < needle._len) {
759             return self;
760         }
761 
762         uint selfptr = self._ptr + self._len - needle._len;
763         bool equal = true;
764         if (selfptr != needle._ptr) {
765             assembly {
766                 let length := mload(needle)
767                 let needleptr := mload(add(needle, 0x20))
768                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
769             }
770         }
771 
772         if (equal) {
773             self._len -= needle._len;
774         }
775 
776         return self;
777     }
778 
779     // Returns the memory address of the first byte of the first occurrence of
780     // `needle` in `self`, or the first byte after `self` if not found.
781     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
782         uint ptr = selfptr;
783         uint idx;
784 
785         if (needlelen <= selflen) {
786             if (needlelen <= 32) {
787                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
788 
789                 bytes32 needledata;
790                 assembly { needledata := and(mload(needleptr), mask) }
791 
792                 uint end = selfptr + selflen - needlelen;
793                 bytes32 ptrdata;
794                 assembly { ptrdata := and(mload(ptr), mask) }
795 
796                 while (ptrdata != needledata) {
797                     if (ptr >= end)
798                         return selfptr + selflen;
799                     ptr++;
800                     assembly { ptrdata := and(mload(ptr), mask) }
801                 }
802                 return ptr;
803             } else {
804                 // For long needles, use hashing
805                 bytes32 hash;
806                 assembly { hash := keccak256(needleptr, needlelen) }
807 
808                 for (idx = 0; idx <= selflen - needlelen; idx++) {
809                     bytes32 testHash;
810                     assembly { testHash := keccak256(ptr, needlelen) }
811                     if (hash == testHash)
812                         return ptr;
813                     ptr += 1;
814                 }
815             }
816         }
817         return selfptr + selflen;
818     }
819 
820     // Returns the memory address of the first byte after the last occurrence of
821     // `needle` in `self`, or the address of `self` if not found.
822     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
823         uint ptr;
824 
825         if (needlelen <= selflen) {
826             if (needlelen <= 32) {
827                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
828 
829                 bytes32 needledata;
830                 assembly { needledata := and(mload(needleptr), mask) }
831 
832                 ptr = selfptr + selflen - needlelen;
833                 bytes32 ptrdata;
834                 assembly { ptrdata := and(mload(ptr), mask) }
835 
836                 while (ptrdata != needledata) {
837                     if (ptr <= selfptr)
838                         return selfptr;
839                     ptr--;
840                     assembly { ptrdata := and(mload(ptr), mask) }
841                 }
842                 return ptr + needlelen;
843             } else {
844                 // For long needles, use hashing
845                 bytes32 hash;
846                 assembly { hash := keccak256(needleptr, needlelen) }
847                 ptr = selfptr + (selflen - needlelen);
848                 while (ptr >= selfptr) {
849                     bytes32 testHash;
850                     assembly { testHash := keccak256(ptr, needlelen) }
851                     if (hash == testHash)
852                         return ptr + needlelen;
853                     ptr -= 1;
854                 }
855             }
856         }
857         return selfptr;
858     }
859 
860     /*
861      * @dev Modifies `self` to contain everything from the first occurrence of
862      *      `needle` to the end of the slice. `self` is set to the empty slice
863      *      if `needle` is not found.
864      * @param self The slice to search and modify.
865      * @param needle The text to search for.
866      * @return `self`.
867      */
868     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
869         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
870         self._len -= ptr - self._ptr;
871         self._ptr = ptr;
872         return self;
873     }
874 
875     /*
876      * @dev Modifies `self` to contain the part of the string from the start of
877      *      `self` to the end of the first occurrence of `needle`. If `needle`
878      *      is not found, `self` is set to the empty slice.
879      * @param self The slice to search and modify.
880      * @param needle The text to search for.
881      * @return `self`.
882      */
883     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
884         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
885         self._len = ptr - self._ptr;
886         return self;
887     }
888 
889     /*
890      * @dev Splits the slice, setting `self` to everything after the first
891      *      occurrence of `needle`, and `token` to everything before it. If
892      *      `needle` does not occur in `self`, `self` is set to the empty slice,
893      *      and `token` is set to the entirety of `self`.
894      * @param self The slice to split.
895      * @param needle The text to search for in `self`.
896      * @param token An output parameter to which the first token is written.
897      * @return `token`.
898      */
899     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
900         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
901         token._ptr = self._ptr;
902         token._len = ptr - self._ptr;
903         if (ptr == self._ptr + self._len) {
904             // Not found
905             self._len = 0;
906         } else {
907             self._len -= token._len + needle._len;
908             self._ptr = ptr + needle._len;
909         }
910         return token;
911     }
912 
913     /*
914      * @dev Splits the slice, setting `self` to everything after the first
915      *      occurrence of `needle`, and returning everything before it. If
916      *      `needle` does not occur in `self`, `self` is set to the empty slice,
917      *      and the entirety of `self` is returned.
918      * @param self The slice to split.
919      * @param needle The text to search for in `self`.
920      * @return The part of `self` up to the first occurrence of `delim`.
921      */
922     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
923         split(self, needle, token);
924     }
925 
926     /*
927      * @dev Splits the slice, setting `self` to everything before the last
928      *      occurrence of `needle`, and `token` to everything after it. If
929      *      `needle` does not occur in `self`, `self` is set to the empty slice,
930      *      and `token` is set to the entirety of `self`.
931      * @param self The slice to split.
932      * @param needle The text to search for in `self`.
933      * @param token An output parameter to which the first token is written.
934      * @return `token`.
935      */
936     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
937         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
938         token._ptr = ptr;
939         token._len = self._len - (ptr - self._ptr);
940         if (ptr == self._ptr) {
941             // Not found
942             self._len = 0;
943         } else {
944             self._len -= token._len + needle._len;
945         }
946         return token;
947     }
948 
949     /*
950      * @dev Splits the slice, setting `self` to everything before the last
951      *      occurrence of `needle`, and returning everything after it. If
952      *      `needle` does not occur in `self`, `self` is set to the empty slice,
953      *      and the entirety of `self` is returned.
954      * @param self The slice to split.
955      * @param needle The text to search for in `self`.
956      * @return The part of `self` after the last occurrence of `delim`.
957      */
958     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
959         rsplit(self, needle, token);
960     }
961 
962     /*
963      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
964      * @param self The slice to search.
965      * @param needle The text to search for in `self`.
966      * @return The number of occurrences of `needle` found in `self`.
967      */
968     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
969         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
970         while (ptr <= self._ptr + self._len) {
971             cnt++;
972             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
973         }
974     }
975 
976     /*
977      * @dev Returns True if `self` contains `needle`.
978      * @param self The slice to search.
979      * @param needle The text to search for in `self`.
980      * @return True if `needle` is found in `self`, false otherwise.
981      */
982     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
983         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
984     }
985 
986     /*
987      * @dev Returns a newly allocated string containing the concatenation of
988      *      `self` and `other`.
989      * @param self The first slice to concatenate.
990      * @param other The second slice to concatenate.
991      * @return The concatenation of the two strings.
992      */
993     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
994         string memory ret = new string(self._len + other._len);
995         uint retptr;
996         assembly { retptr := add(ret, 32) }
997         memcpy(retptr, self._ptr, self._len);
998         memcpy(retptr + self._len, other._ptr, other._len);
999         return ret;
1000     }
1001 
1002     /*
1003      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1004      *      newly allocated string.
1005      * @param self The delimiter to use.
1006      * @param parts A list of slices to join.
1007      * @return A newly allocated string containing all the slices in `parts`,
1008      *         joined with `self`.
1009      */
1010     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1011         if (parts.length == 0)
1012             return "";
1013 
1014         uint length = self._len * (parts.length - 1);
1015         for(uint i = 0; i < parts.length; i++)
1016             length += parts[i]._len;
1017 
1018         string memory ret = new string(length);
1019         uint retptr;
1020         assembly { retptr := add(ret, 32) }
1021 
1022         for(i = 0; i < parts.length; i++) {
1023             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1024             retptr += parts[i]._len;
1025             if (i < parts.length - 1) {
1026                 memcpy(retptr, self._ptr, self._len);
1027                 retptr += self._len;
1028             }
1029         }
1030 
1031         return ret;
1032     }
1033 }
1034 
1035 contract ICash{}
1036 
1037 contract IMarket {
1038     function getWinningPayoutNumerator(uint256 _outcome) public view returns (uint256);
1039     function isFinalized() public view returns (bool);
1040     function isInvalid() public view returns (bool);
1041 }
1042 
1043 contract IUniverse {
1044     function getWinningChildUniverse() public view returns (IUniverse);
1045     function createYesNoMarket(uint256 _endTime, uint256 _feePerEthInWei, ICash _denominationToken, address _designatedReporterAddress, bytes32 _topic, string _description, string _extraInfo) public 
1046     payable returns (IMarket _newMarket); 
1047 }
1048 
1049 contract RealitioAugurArbitrator is BalanceHolder {
1050 
1051     using strings for *;
1052 
1053     IRealitio public realitio;
1054     uint256 public template_id;
1055     uint256 dispute_fee;
1056 
1057     ICash public market_token;
1058     IUniverse public latest_universe;
1059 
1060     bytes32 constant REALITIO_INVALID = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
1061     bytes32 constant REALITIO_YES     = 0x0000000000000000000000000000000000000000000000000000000000000001;
1062     bytes32 constant REALITIO_NO      = 0x0000000000000000000000000000000000000000000000000000000000000000;
1063     uint256 constant AUGUR_YES_INDEX  = 1;
1064     uint256 constant AUGUR_NO_INDEX   = 0;
1065     string constant REALITIO_DELIMITER = '␟';
1066 
1067     event LogRequestArbitration(
1068         bytes32 indexed question_id,
1069         uint256 fee_paid,
1070         address requester,
1071         uint256 remaining
1072     );
1073 
1074     struct RealitioQuestion {
1075         uint256 bounty;
1076         address disputer;
1077         IMarket augur_market;
1078         address owner;
1079     }
1080 
1081     mapping(bytes32 => RealitioQuestion) public realitio_questions;
1082 
1083     modifier onlyInitialized() { 
1084         require(dispute_fee > 0, "The contract cannot be used until a dispute fee has been set");
1085         _;
1086     }
1087 
1088     modifier onlyUninitialized() { 
1089         require(dispute_fee == 0, "The contract can only be initialized once");
1090         _;
1091     }
1092 
1093     /// @notice Initialize a new contract
1094     /// @param _realitio The address of the realitio contract you arbitrate for
1095     /// @param _template_id The ID of the realitio template we support. 
1096     /// @param _dispute_fee The fee this contract will charge for resolution
1097     /// @param _genesis_universe The earliest supported Augur universe
1098     /// @param _market_token The token used by the market we create, typically Augur's wrapped ETH
1099     function initialize(IRealitio _realitio, uint256 _template_id, uint256 _dispute_fee, IUniverse _genesis_universe, ICash _market_token) 
1100         onlyUninitialized
1101     external {
1102 
1103         require(_dispute_fee > 0, "You must provide a dispute fee");
1104         require(_realitio != IRealitio(0x0), "You must provide a realitio address");
1105         require(_genesis_universe != IUniverse(0x0), "You must provide a genesis universe");
1106         require(_market_token != ICash(0x0), "You must provide an augur cash token");
1107 
1108         dispute_fee = _dispute_fee;
1109         template_id = _template_id;
1110         realitio = _realitio;
1111         latest_universe = _genesis_universe;
1112         market_token = _market_token;
1113 
1114     }
1115 
1116     /// @notice Register a new child universe after a fork
1117     /// @dev Anyone can create Augur universes but the "correct" ones should be in a single line from the official genesis universe
1118     /// @dev If a universe goes into a forking state, someone will need to call this before you can create new markets.
1119     function addForkedUniverse() 
1120         onlyInitialized
1121     external {
1122         IUniverse child_universe = IUniverse(latest_universe).getWinningChildUniverse();
1123         latest_universe = child_universe;
1124     }
1125 
1126     /// @notice Trim the realitio question content to the part before the initial delimiter.
1127     /// @dev The Realitio question is a list of parameters for a template.
1128     /// @dev We throw away the subsequent parameters of the question.
1129     /// @dev The first item in the (supported) template must be the title.
1130     /// @dev Subsequent items (category, lang) aren't needed in Augur.
1131     /// @dev This does not support more complex templates, eg selects which also need a list of answrs.
1132     function _trimQuestion(string q) 
1133     internal pure returns (string) {
1134         return q.toSlice().split(REALITIO_DELIMITER.toSlice()).toString();
1135     }
1136 
1137     function _callAugurMarketCreate(bytes32 question_id, string question, address designated_reporter) 
1138     internal {
1139         realitio_questions[question_id].augur_market = latest_universe.createYesNoMarket.value(msg.value)( now, 0, market_token, designated_reporter, 0x0, _trimQuestion(question), "");
1140         realitio_questions[question_id].owner = msg.sender;
1141     }
1142 
1143     /// @notice Create a market in Augur and store the creator as its owner
1144     /// @dev Anyone can call this, and calling this will give them the rights to claim the bounty
1145     /// @dev They will need have sent this contract some REP for the no-show bond.
1146     /// @param question The question content (a delimited parameter list)
1147     /// @param timeout The timeout between rounds, set when the question was created
1148     /// @param opening_ts The opening timestamp for the question, set when the question was created
1149     /// @param asker The address that created the question, ie the msg.sender of the original realitio.askQuestion call
1150     /// @param nonce The nonce for the question, set when the question was created
1151     /// @param designated_reporter The Augur designated reporter. We let the market creator choose this, if it's bad the Augur dispute resolution should sort it out
1152     function createMarket(
1153         string question, uint32 timeout, uint32 opening_ts, address asker, uint256 nonce,
1154         address designated_reporter
1155     ) 
1156         onlyInitialized
1157     external payable {
1158         // Reconstruct the question ID from the content
1159         bytes32 question_id = keccak256(keccak256(template_id, opening_ts, question), this, timeout, asker, nonce);
1160 
1161         require(realitio_questions[question_id].bounty > 0, "Arbitration must have been requested (paid for)");
1162         require(realitio_questions[question_id].augur_market == IMarket(0x0), "The market must not have been created yet");
1163 
1164         // Create a market in Augur
1165         _callAugurMarketCreate(question_id, question, designated_reporter);
1166     }
1167 
1168     /// @notice Return data needed to verify the last history item
1169     /// @dev Filters the question struct from Realitio to stuff we need
1170     /// @dev Broken out into its own function to avoid stack depth limitations
1171     /// @param question_id The realitio question
1172     /// @param last_history_hash The history hash when you gave your answer 
1173     /// @param last_answer_or_commitment_id The last answer given, or its commitment ID if it was a commitment 
1174     /// @param last_bond The bond paid in the last answer given
1175     /// @param last_answerer The account that submitted the last answer (or its commitment)
1176     /// @param is_commitment Whether the last answer was submitted with commit->reveal
1177     function _verifyInput(
1178         bytes32 question_id, 
1179         bytes32 last_history_hash, bytes32 last_answer_or_commitment_id, uint256 last_bond, address last_answerer, bool is_commitment
1180     ) internal view returns (bool, bytes32) {
1181         require(realitio.isPendingArbitration(question_id), "The question must be pending arbitration in realitio");
1182         bytes32 history_hash = realitio.getHistoryHash(question_id);
1183         
1184         require(history_hash == keccak256(last_history_hash, last_answer_or_commitment_id, last_bond, last_answerer, is_commitment), "The history parameters supplied must match the history hash in the realitio contract");
1185 
1186     }
1187 
1188     /// @notice Given the last history entry, get whether they had a valid answer if so what it was
1189     /// @dev These just need to be fetched from Realitio, but they can't be fetched directly because we don't store them to save gas
1190     /// @dev To get the final answer, we need to reconstruct the final answer using the history hash
1191     /// @dev TODO: This should probably be in a library offered by Realitio
1192     /// @param question_id The ID of the realitio question
1193     /// @param last_history_hash The history hash when you gave your answer 
1194     /// @param last_answer_or_commitment_id The last answer given, or its commitment ID if it was a commitment 
1195     /// @param last_bond The bond paid in the last answer given
1196     /// @param last_answerer The account that submitted the last answer (or its commitment)
1197     /// @param is_commitment Whether the last answer was submitted with commit->reveal
1198     function _answerData(
1199         bytes32 question_id, 
1200         bytes32 last_history_hash, bytes32 last_answer_or_commitment_id, uint256 last_bond, address last_answerer, bool is_commitment
1201     ) internal view returns (bool, bytes32) {
1202     
1203         bool is_pending_arbitration;
1204         bytes32 history_hash;
1205 
1206         // If the question hasn't been answered, nobody is ever right
1207         if (last_bond == 0) {
1208             return (false, bytes32(0));
1209         }
1210 
1211         bytes32 last_answer;
1212         bool is_answered;
1213 
1214         if (is_commitment) {
1215             uint256 reveal_ts;
1216             bool is_revealed;
1217             bytes32 revealed_answer;
1218             (reveal_ts, is_revealed, revealed_answer) = realitio.commitments(last_answer_or_commitment_id);
1219 
1220             if (is_revealed) {
1221                 last_answer = revealed_answer;
1222                 is_answered = true;
1223             } else {
1224                 // Shouldn't normally happen, but if the last answerer might still reveal when we are called, bail out and wait for them.
1225                 require(reveal_ts < uint32(now), "Arbitration cannot be done until the last answerer has had time to reveal their commitment");
1226                 is_answered = false;
1227             }
1228         } else {
1229             last_answer = last_answer_or_commitment_id;
1230             is_answered = true;
1231         }
1232 
1233         return (is_answered, last_answer);
1234 
1235     }
1236 
1237     /// @notice Get the answer from the Augur market and map it to a Realitio value
1238     /// @param market The Augur market
1239     function realitioAnswerFromAugurMarket(
1240        IMarket market
1241     ) 
1242         onlyInitialized
1243     public view returns (bytes32) {
1244         bytes32 answer;
1245         if (market.isInvalid()) {
1246             answer = REALITIO_INVALID;
1247         } else {
1248             uint256 no_val = market.getWinningPayoutNumerator(AUGUR_NO_INDEX);
1249             uint256 yes_val = market.getWinningPayoutNumerator(AUGUR_YES_INDEX);
1250             if (yes_val == no_val) {
1251                 answer = REALITIO_INVALID;
1252             } else {
1253                 if (yes_val > no_val) {
1254                     answer = REALITIO_YES;
1255                 } else {
1256                     answer = REALITIO_NO;
1257                 }
1258             }
1259         }
1260         return answer;
1261     }
1262 
1263     /// @notice Report the answer from a finalized Augur market to a Realitio contract with a question awaiting arbitration
1264     /// @dev Pays the arbitration bounty to whoever created the Augur market. Probably the same person will call this function, but they don't have to.
1265     /// @dev We need to know who gave the final answer and what it was, as they need to be supplied as the arbitration winner if the last answer is right
1266     /// @dev These just need to be fetched from Realitio, but they can't be fetched directly because to save gas, Realitio doesn't store them 
1267     /// @dev To get the final answer, we need to reconstruct the final answer using the history hash
1268     /// @param question_id The ID of the question you're reporting on
1269     /// @param last_history_hash The history hash when you gave your answer 
1270     /// @param last_answer_or_commitment_id The last answer given, or its commitment ID if it was a commitment 
1271     /// @param last_bond The bond paid in the last answer given
1272     /// @param last_answerer The account that submitted the last answer (or its commitment)
1273     /// @param is_commitment Whether the last answer was submitted with commit->reveal
1274     function reportAnswer(
1275         bytes32 question_id,
1276         bytes32 last_history_hash, bytes32 last_answer_or_commitment_id, uint256 last_bond, address last_answerer, bool is_commitment
1277     ) 
1278         onlyInitialized
1279     public {
1280 
1281         IMarket market = realitio_questions[question_id].augur_market;
1282 
1283         // There must be an open bounty
1284         require(realitio_questions[question_id].bounty > 0, "Arbitration must have been requested for this question");
1285 
1286         bool is_answered; // the answer was provided, not just left as an unrevealed commit
1287         bytes32 last_answer;
1288 
1289         _verifyInput(question_id, last_history_hash, last_answer_or_commitment_id, last_bond, last_answerer, is_commitment);
1290 
1291         (is_answered, last_answer) = _answerData(question_id, last_history_hash, last_answer_or_commitment_id, last_bond, last_answerer, is_commitment);  
1292 
1293         require(market.isFinalized(), "The augur market must have been finalized");
1294 
1295         bytes32 answer = realitioAnswerFromAugurMarket(market);
1296         address winner;
1297         if (is_answered && last_answer == answer) {
1298             winner = last_answerer;
1299         } else {
1300             // If the final answer is wrong, we assign the person who paid for arbitration.
1301             // See https://realitio.github.io/docs/html/arbitrators.html for why.
1302             winner = realitio_questions[question_id].disputer;
1303         }
1304 
1305         realitio.submitAnswerByArbitrator(question_id, answer, winner);
1306 
1307         address owner = realitio_questions[question_id].owner;
1308         balanceOf[owner] += realitio_questions[question_id].bounty;
1309 
1310         delete realitio_questions[question_id];
1311 
1312     }
1313 
1314     /// @notice Return the dispute fee for the specified question. 0 indicates that we won't arbitrate it.
1315     /// @dev Uses a general default, but can be over-ridden on a question-by-question basis.
1316     function getDisputeFee(bytes32) 
1317     external view returns (uint256) {
1318         return dispute_fee;
1319     }
1320 
1321 
1322     /// @notice Request arbitration, freezing the question until we send submitAnswerByArbitrator
1323     /// @dev The bounty can be paid only in part, in which case the last person to pay will be considered the payer
1324     /// @dev Will trigger an error if the notification fails, eg because the question has already been finalized
1325     /// @param question_id The question in question
1326     /// @param max_previous The highest bond level we should accept (used to check the state hasn't changed)
1327     function requestArbitration(bytes32 question_id, uint256 max_previous) 
1328         onlyInitialized
1329     external payable returns (bool) {
1330 
1331         require(msg.value >= dispute_fee, "The payment must cover the fee");
1332 
1333         realitio.notifyOfArbitrationRequest(question_id, msg.sender, max_previous);
1334 
1335         realitio_questions[question_id].bounty = msg.value;
1336         realitio_questions[question_id].disputer = msg.sender;
1337 
1338         LogRequestArbitration(question_id, msg.value, msg.sender, 0);
1339 
1340     }
1341 
1342 }