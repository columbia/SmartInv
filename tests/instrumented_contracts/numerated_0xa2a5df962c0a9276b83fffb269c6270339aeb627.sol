1 // produced by the Solididy File Flattener (c) David Appleton 2018
2 // contact : dave@akomba.com
3 // released under Apache 2.0 licence
4 // input  C:\Projects\BANKEX\bankex-arbitration-service\smart-contract\contracts\Board.sol
5 // flattened :  Wednesday, 05-Dec-18 11:16:27 UTC
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract EIP20 {
49     /* This is a slight change to the ERC20 base standard.
50     function totalSupply() constant returns (uint256 supply);
51     is replaced with:
52     uint256 public totalSupply;
53     This automatically creates a getter function for the totalSupply.
54     This is moved to the base contract since public getter functions are not
55     currently recognised as an implementation of the matching abstract
56     function by the compiler.
57     */
58     /// total amount of tokens
59     uint256 public totalSupply;
60 
61     /// @param _owner The address from which the balance will be retrieved
62     /// @return The balance
63     function balanceOf(address _owner) public view returns (uint256 balance);
64 
65     /// @notice send `_value` token to `_to` from `msg.sender`
66     /// @param _to The address of the recipient
67     /// @param _value The amount of token to be transferred
68     /// @return Whether the transfer was successful or not
69     function transfer(address _to, uint256 _value) public returns (bool success);
70 
71     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
72     /// @param _from The address of the sender
73     /// @param _to The address of the recipient
74     /// @param _value The amount of token to be transferred
75     /// @return Whether the transfer was successful or not
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
77 
78     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
79     /// @param _spender The address of the account able to transfer the tokens
80     /// @param _value The amount of tokens to be approved for transfer
81     /// @return Whether the approval was successful or not
82     function approve(address _spender, uint256 _value) public returns (bool success);
83 
84     /// @param _owner The address of the account owning tokens
85     /// @param _spender The address of the account able to transfer the tokens
86     /// @return Amount of remaining tokens allowed to spent
87     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
88 
89     // solhint-disable-next-line no-simple-event-func-name  
90     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92 }
93 
94 contract Ownable {
95   address public owner;
96 
97 
98   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100 
101   /**
102    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
103    * account.
104    */
105   function Ownable() public {
106     owner = msg.sender;
107   }
108 
109   /**
110    * @dev Throws if called by any account other than the owner.
111    */
112   modifier onlyOwner() {
113     require(msg.sender == owner);
114     _;
115   }
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address newOwner) public onlyOwner {
122     require(newOwner != address(0));
123     emit OwnershipTransferred(owner, newOwner);
124     owner = newOwner;
125   }
126 
127 }
128 
129 contract BkxToken is EIP20 {
130     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
131     function decreaseApproval (address _spender, uint _subtractedValue)public returns (bool success);
132 }
133 
134 library Utils {
135      /* Not secured random number generation, but it's enough for the perpose of implementaion particular case*/
136     function almostRnd(uint min, uint max) internal view returns(uint)
137     {
138         return uint(keccak256(block.timestamp, block.blockhash(block.number))) % (max - min) + min;
139     }
140 }
141 
142 contract Token {
143     function balanceOf(address owner) public view returns (uint256 balance);
144 
145     function transfer(address to, uint256 value) public returns (bool success);
146 
147     function transferFrom(address from, address to, uint256 value) public returns (bool success);
148 
149     function approve(address spender, uint256 value) public returns (bool success);
150 
151     function allowance(address owner, address spender) public view returns (uint256 remaining);
152 }
153 
154 contract EternalStorage {
155 
156     /**** Storage Types *******/
157 
158     address public owner;
159 
160     mapping(bytes32 => uint256)    private uIntStorage;
161     mapping(bytes32 => uint8)      private uInt8Storage;
162     mapping(bytes32 => string)     private stringStorage;
163     mapping(bytes32 => address)    private addressStorage;
164     mapping(bytes32 => bytes)      private bytesStorage;
165     mapping(bytes32 => bool)       private boolStorage;
166     mapping(bytes32 => int256)     private intStorage;
167     mapping(bytes32 => bytes32)    private bytes32Storage;
168 
169 
170     /*** Modifiers ************/
171 
172     /// @dev Only allow access from the latest version of a contract in the Rocket Pool network after deployment
173     modifier onlyLatestContract() {
174         require(addressStorage[keccak256("contract.address", msg.sender)] != 0x0 || msg.sender == owner);
175         _;
176     }
177 
178     /// @dev constructor
179     function EternalStorage() public {
180         owner = msg.sender;
181         addressStorage[keccak256("contract.address", msg.sender)] = msg.sender;
182     }
183 
184     function setOwner() public {
185         require(msg.sender == owner);
186         addressStorage[keccak256("contract.address", owner)] = 0x0;
187         owner = msg.sender;
188         addressStorage[keccak256("contract.address", msg.sender)] = msg.sender;
189     }
190 
191     /**** Get Methods ***********/
192 
193     /// @param _key The key for the record
194     function getAddress(bytes32 _key) external view returns (address) {
195         return addressStorage[_key];
196     }
197 
198     /// @param _key The key for the record
199     function getUint(bytes32 _key) external view returns (uint) {
200         return uIntStorage[_key];
201     }
202 
203       /// @param _key The key for the record
204     function getUint8(bytes32 _key) external view returns (uint8) {
205         return uInt8Storage[_key];
206     }
207 
208 
209     /// @param _key The key for the record
210     function getString(bytes32 _key) external view returns (string) {
211         return stringStorage[_key];
212     }
213 
214     /// @param _key The key for the record
215     function getBytes(bytes32 _key) external view returns (bytes) {
216         return bytesStorage[_key];
217     }
218 
219     /// @param _key The key for the record
220     function getBytes32(bytes32 _key) external view returns (bytes32) {
221         return bytes32Storage[_key];
222     }
223 
224     /// @param _key The key for the record
225     function getBool(bytes32 _key) external view returns (bool) {
226         return boolStorage[_key];
227     }
228 
229     /// @param _key The key for the record
230     function getInt(bytes32 _key) external view returns (int) {
231         return intStorage[_key];
232     }
233 
234     /**** Set Methods ***********/
235 
236     /// @param _key The key for the record
237     function setAddress(bytes32 _key, address _value) onlyLatestContract external {
238         addressStorage[_key] = _value;
239     }
240 
241     /// @param _key The key for the record
242     function setUint(bytes32 _key, uint _value) onlyLatestContract external {
243         uIntStorage[_key] = _value;
244     }
245 
246     /// @param _key The key for the record
247     function setUint8(bytes32 _key, uint8 _value) onlyLatestContract external {
248         uInt8Storage[_key] = _value;
249     }
250 
251     /// @param _key The key for the record
252     function setString(bytes32 _key, string _value) onlyLatestContract external {
253         stringStorage[_key] = _value;
254     }
255 
256     /// @param _key The key for the record
257     function setBytes(bytes32 _key, bytes _value) onlyLatestContract external {
258         bytesStorage[_key] = _value;
259     }
260 
261     /// @param _key The key for the record
262     function setBytes32(bytes32 _key, bytes32 _value) onlyLatestContract external {
263         bytes32Storage[_key] = _value;
264     }
265 
266     /// @param _key The key for the record
267     function setBool(bytes32 _key, bool _value) onlyLatestContract external {
268         boolStorage[_key] = _value;
269     }
270 
271     /// @param _key The key for the record
272     function setInt(bytes32 _key, int _value) onlyLatestContract external {
273         intStorage[_key] = _value;
274     }
275 
276     /**** Delete Methods ***********/
277 
278     /// @param _key The key for the record
279     function deleteAddress(bytes32 _key) onlyLatestContract external {
280         delete addressStorage[_key];
281     }
282 
283     /// @param _key The key for the record
284     function deleteUint(bytes32 _key) onlyLatestContract external {
285         delete uIntStorage[_key];
286     }
287 
288      /// @param _key The key for the record
289     function deleteUint8(bytes32 _key) onlyLatestContract external {
290         delete uInt8Storage[_key];
291     }
292 
293     /// @param _key The key for the record
294     function deleteString(bytes32 _key) onlyLatestContract external {
295         delete stringStorage[_key];
296     }
297 
298     /// @param _key The key for the record
299     function deleteBytes(bytes32 _key) onlyLatestContract external {
300         delete bytesStorage[_key];
301     }
302 
303     /// @param _key The key for the record
304     function deleteBytes32(bytes32 _key) onlyLatestContract external {
305         delete bytes32Storage[_key];
306     }
307 
308     /// @param _key The key for the record
309     function deleteBool(bytes32 _key) onlyLatestContract external {
310         delete boolStorage[_key];
311     }
312 
313     /// @param _key The key for the record
314     function deleteInt(bytes32 _key) onlyLatestContract external {
315         delete intStorage[_key];
316     }
317 }
318 
319 library RefereeCasesLib {
320 
321     function setRefereesToCase(address storageAddress, address[] referees, bytes32 caseId) public {
322         for (uint i = 0; i < referees.length; i++) {
323             setRefereeToCase(storageAddress, referees[i], caseId, i);
324         }
325         setRefereeCountForCase(storageAddress, caseId, referees.length);
326     }
327 
328     function isRefereeVoted(address storageAddress, address referee, bytes32 caseId) public view returns (bool) {
329         return EternalStorage(storageAddress).getBool(keccak256("case.referees.voted", caseId, referee));
330     }
331 
332     function setRefereeVote(address storageAddress, bytes32 caseId, address referee, bool forApplicant) public {
333         uint index = getRefereeVotesFor(storageAddress, caseId, forApplicant);
334         EternalStorage(storageAddress).setAddress(keccak256("case.referees.vote", caseId, forApplicant, index), referee);
335         setRefereeVotesFor(storageAddress, caseId,  forApplicant, index + 1);
336     }
337 
338     function getRefereeVoteForByIndex(address storageAddress, bytes32 caseId, bool forApplicant, uint index) public view returns (address) {
339         return EternalStorage(storageAddress).getAddress(keccak256("case.referees.vote", caseId, forApplicant, index));
340     }
341 
342     function getRefereeVotesFor(address storageAddress, bytes32 caseId, bool forApplicant) public view returns (uint) {
343         return EternalStorage(storageAddress).getUint(keccak256("case.referees.votes.count", caseId, forApplicant));
344     }
345 
346     function setRefereeVotesFor(address storageAddress, bytes32 caseId, bool forApplicant, uint votes) public {
347         EternalStorage(storageAddress).setUint(keccak256("case.referees.votes.count", caseId, forApplicant), votes);
348     }
349 
350     function getRefereeCountByCase(address storageAddress, bytes32 caseId) public view returns (uint) {
351         return EternalStorage(storageAddress).getUint(keccak256("case.referees.count", caseId));
352     }
353 
354     function setRefereeCountForCase(address storageAddress, bytes32 caseId, uint value) public {
355         EternalStorage(storageAddress).setUint(keccak256("case.referees.count", caseId), value);
356     }
357 
358     function getRefereeByCase(address storageAddress, bytes32 caseId, uint index) public view returns (address) {
359         return EternalStorage(storageAddress).getAddress(keccak256("case.referees", caseId, index));
360     }
361 
362     function isRefereeSetToCase(address storageAddress, address referee, bytes32 caseId) public view returns(bool) {
363         return EternalStorage(storageAddress).getBool(keccak256("case.referees", caseId, referee));
364     }
365     
366     function setRefereeToCase(address storageAddress, address referee, bytes32 caseId, uint index) public {
367         EternalStorage st = EternalStorage(storageAddress);
368         st.setAddress(keccak256("case.referees", caseId, index), referee);
369         st.setBool(keccak256("case.referees", caseId, referee), true);
370     }
371 
372     function getRefereeVoteHash(address storageAddress, bytes32 caseId, address referee) public view returns (bytes32) {
373         return EternalStorage(storageAddress).getBytes32(keccak256("case.referees.vote.hash", caseId, referee));
374     }
375 
376     function setRefereeVoteHash(address storageAddress, bytes32 caseId, address referee, bytes32 voteHash) public {
377         uint caseCount = getRefereeVoteHashCount(storageAddress, caseId);
378         EternalStorage(storageAddress).setBool(keccak256("case.referees.voted", caseId, referee), true);
379         EternalStorage(storageAddress).setBytes32(keccak256("case.referees.vote.hash", caseId, referee), voteHash);
380         EternalStorage(storageAddress).setUint(keccak256("case.referees.vote.hash.count", caseId), caseCount + 1);
381     }
382 
383     function getRefereeVoteHashCount(address storageAddress, bytes32 caseId) public view returns(uint) {
384         return EternalStorage(storageAddress).getUint(keccak256("case.referees.vote.hash.count", caseId));
385     }
386 
387     function getRefereesFor(address storageAddress, bytes32 caseId, bool forApplicant)
388     public view returns(address[]) {
389         uint n = getRefereeVotesFor(storageAddress, caseId, forApplicant);
390         address[] memory referees = new address[](n);
391         for (uint i = 0; i < n; i++) {
392             referees[i] = getRefereeVoteForByIndex(storageAddress, caseId, forApplicant, i);
393         }
394         return referees;
395     }
396 
397     function getRefereesByCase(address storageAddress, bytes32 caseId)
398     public view returns (address[]) {
399         uint n = getRefereeCountByCase(storageAddress, caseId);
400         address[] memory referees = new address[](n);
401         for (uint i = 0; i < n; i++) {
402             referees[i] = getRefereeByCase(storageAddress, caseId, i);
403         }
404         return referees;
405     }
406 
407 }
408 
409 library VoteTokenLib  {
410 
411     function getVotes(address storageAddress, address account) public view returns(uint) {
412         return EternalStorage(storageAddress).getUint(keccak256("vote.token.balance", account));
413     }
414 
415     function increaseVotes(address storageAddress, address account, uint256 diff) public {
416         setVotes(storageAddress, account, getVotes(storageAddress, account) + diff);
417     }
418 
419     function decreaseVotes(address storageAddress, address account, uint256 diff) public {
420         setVotes(storageAddress, account, getVotes(storageAddress, account) - diff);
421     }
422 
423     function setVotes(address storageAddress, address account, uint256 value) public {
424         EternalStorage(storageAddress).setUint(keccak256("vote.token.balance", account), value);
425     }
426 
427 }
428 
429 library RefereesLib {
430 
431     struct Referees {
432         address[] addresses;
433     }
434 
435     function addReferee(address storageAddress, address referee) public {
436         uint id = getRefereeCount(storageAddress);
437         setReferee(storageAddress, referee, id, true);
438         setRefereeCount(storageAddress, id + 1);
439     }
440 
441     function getRefereeCount(address storageAddress) public view returns(uint) {
442         return EternalStorage(storageAddress).getUint(keccak256("referee.count"));
443     }
444 
445     function setRefereeCount(address storageAddress, uint value) public {
446         EternalStorage(storageAddress).setUint(keccak256("referee.count"), value);
447     }
448 
449     function setReferee(address storageAddress, address referee, uint id, bool applied) public {
450         EternalStorage st = EternalStorage(storageAddress);
451         st.setBool(keccak256("referee.applied", referee), applied);
452         st.setAddress(keccak256("referee.address", id), referee);
453     }
454 
455     function isRefereeApplied(address storageAddress, address referee) public view returns(bool) {
456         return EternalStorage(storageAddress).getBool(keccak256("referee.applied", referee));
457     }
458 
459     function setRefereeApplied(address storageAddress, address referee, bool applied) public {
460         EternalStorage(storageAddress).setBool(keccak256("referee.applied", referee), applied);
461     }
462 
463     function getRefereeAddress(address storageAddress, uint id) public view returns(address) {
464         return EternalStorage(storageAddress).getAddress(keccak256("referee.address", id));
465     }
466     
467     function getRandomRefereesToCase(address storageAddress, address applicant, address respondent, uint256 targetCount) 
468     public view returns(address[] foundReferees)  {
469         uint refereesCount = getRefereeCount(storageAddress);
470         require(refereesCount >= targetCount);
471         foundReferees = new address[](targetCount);
472         uint id = Utils.almostRnd(0, refereesCount);
473         uint found = 0;
474         for (uint i = 0; i < refereesCount; i++) {
475             address referee = getRefereeAddress(storageAddress, id);
476             id = id + 1;
477             id = id % refereesCount;
478             uint voteBalance = VoteTokenLib.getVotes(storageAddress, referee);
479             if (referee != applicant && referee != respondent && voteBalance > 0) {
480                 foundReferees[found] = referee;
481                 found++;
482             }
483             if (found == targetCount) {
484                 break;
485             }
486         }
487         require(found == targetCount);
488     }
489 }
490 
491 contract IBoard is Ownable {
492 
493     event CaseOpened(bytes32 caseId, address applicant, address respondent, bytes32 deal, uint amount, uint refereeAward, bytes32 title, string applicantDescription, uint[] dates, uint refereeCountNeed, bool isEthRefereeAward);
494     event CaseCommentedByRespondent(bytes32 caseId, address respondent, string comment);
495     event CaseVoting(bytes32 caseId);
496     event CaseVoteCommitted(bytes32 caseId, address referee, bytes32 voteHash);
497     event CaseRevealingVotes(bytes32 caseId);
498     event CaseVoteRevealed(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt);
499     event CaseClosed(bytes32 caseId, bool won);
500     event CaseCanceled(bytes32 caseId, uint8 causeCode);
501 
502     event RefereesAssignedToCase(bytes32 caseId, address[] referees);
503     event RefereeVoteBalanceChanged(address referee, uint balance);
504     event RefereeAwarded(address referee, bytes32 caseId, uint award);
505 
506     address public lib;
507     uint public version;
508     IBoardConfig public config;
509     BkxToken public bkxToken;
510     address public admin;
511     address public paymentHolder;
512     address public refereePaymentHolder;
513 
514     modifier onlyOwnerOrAdmin() {
515         require(msg.sender == admin || msg.sender == owner);
516         _;
517     }
518 
519     function withdrawEth(uint value) external;
520 
521     function withdrawBkx(uint value) external;
522 
523     function setStorageAddress(address storageAddress) external;
524 
525     function setConfigAddress(address configAddress) external;
526 
527     function setBkxToken(address tokenAddress) external;
528 
529     function setPaymentHolder(address paymentHolder) external;
530 
531     function setRefereePaymentHolder(address referePaymentHolder) external;
532 
533     function setAdmin(address admin) external;
534 
535     function applyForReferee() external;
536 
537     function addVoteTokens(address referee) external;
538 
539     function openCase(address respondent, bytes32 deal, uint amount, uint refereeAward, bytes32 title, string description) external payable;
540 
541     function setRespondentDescription(bytes32 caseId, string description) external;
542 
543     function startVotingCase(bytes32 caseId) external;
544 
545     function createVoteHash(uint8 voteOption, bytes32 salt) public view returns(bytes32);
546 
547     function commitVote(bytes32 caseId, bytes32 voteHash) external;
548 
549     function verifyVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt) public view returns(bool);
550 
551     function startRevealingVotes(bytes32 caseId) external;
552 
553     function revealVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt) external;
554 
555     function revealVotes(bytes32 caseId, address[] referees, uint8[] voteOptions, bytes32[] salts) external;
556 
557     function verdict(bytes32 caseId) external;
558 }
559 
560 contract Withdrawable is Ownable {
561     function withdrawEth(uint value) external onlyOwner {
562         require(address(this).balance >= value);
563         msg.sender.transfer(value);
564     }
565 
566     function withdrawToken(address token, uint value) external onlyOwner {
567         require(Token(token).balanceOf(address(this)) >= value, "Not enough tokens");
568         require(Token(token).transfer(msg.sender, value));
569     }
570 }
571 
572 library CasesLib {
573 
574     enum CaseStatus {OPENED, VOTING, REVEALING, CLOSED, CANCELED}
575     enum CaseCanceledCode { NOT_ENOUGH_VOTES, EQUAL_NUMBER_OF_VOTES }
576 
577     function getCase(address storageAddress, bytes32 caseId)
578     public view returns ( address applicant, address respondent,
579         bytes32 deal, uint amount,
580         uint refereeAward,
581         bytes32 title, uint8 status, uint8 canceledCode,
582         bool won, bytes32 applicantDescriptionHash,
583         bytes32 respondentDescriptionHash, bool isEthRefereeAward)
584     {
585         EternalStorage st = EternalStorage(storageAddress);
586         applicant = st.getAddress(keccak256("case.applicant", caseId));
587         respondent = st.getAddress(keccak256("case.respondent", caseId));
588         deal = st.getBytes32(keccak256("case.deal", caseId));
589         amount = st.getUint(keccak256("case.amount", caseId));
590         won = st.getBool(keccak256("case.won", caseId));
591         status = st.getUint8(keccak256("case.status", caseId));
592         canceledCode = st.getUint8(keccak256("case.canceled.cause.code", caseId));
593         refereeAward = st.getUint(keccak256("case.referee.award", caseId));
594         title = st.getBytes32(keccak256("case.title", caseId));
595         applicantDescriptionHash = st.getBytes32(keccak256("case.applicant.description", caseId));
596         respondentDescriptionHash = st.getBytes32(keccak256("case.respondent.description", caseId));
597         isEthRefereeAward = st.getBool(keccak256("case.referee.award.eth", caseId));
598     }
599 
600     function getCaseDates(address storageAddress, bytes32 caseId)
601     public view returns (uint date, uint votingDate, uint revealingDate, uint closeDate)
602     {
603         EternalStorage st = EternalStorage(storageAddress);
604         date = st.getUint(keccak256("case.date", caseId));
605         votingDate = st.getUint(keccak256("case.date.voting", caseId));
606         revealingDate = st.getUint(keccak256("case.date.revealing", caseId));
607         closeDate = st.getUint(keccak256("case.date.close", caseId));
608     }
609 
610     function addCase(
611         address storageAddress, address applicant, 
612         address respondent, bytes32 deal, 
613         uint amount, uint refereeAward,
614         bytes32 title, string applicantDescription,
615         uint[] dates, uint refereeCountNeed, bool isEthRefereeAward
616     )
617     public returns(bytes32 caseId)
618     {
619         EternalStorage st = EternalStorage(storageAddress);
620         caseId = keccak256(applicant, respondent, deal, dates[0], title, amount);
621         st.setAddress(keccak256("case.applicant", caseId), applicant);
622         st.setAddress(keccak256("case.respondent", caseId), respondent);
623         st.setBytes32(keccak256("case.deal", caseId), deal);
624         st.setUint(keccak256("case.amount", caseId), amount);
625         st.setUint(keccak256("case.date", caseId), dates[0]);
626         st.setUint(keccak256("case.date.voting", caseId), dates[1]);
627         st.setUint(keccak256("case.date.revealing", caseId), dates[2]);
628         st.setUint(keccak256("case.date.close", caseId), dates[3]);
629         st.setUint8(keccak256("case.status", caseId), 0);//OPENED
630         st.setUint(keccak256("case.referee.award", caseId), refereeAward);
631         st.setBytes32(keccak256("case.title", caseId), title);
632         st.setBytes32(keccak256("case.applicant.description", caseId), keccak256(applicantDescription));
633         st.setBool(keccak256("case.referee.award.eth", caseId), isEthRefereeAward);
634         st.setUint(keccak256("case.referee.count.need", caseId), refereeCountNeed);
635     }
636 
637     function setCaseWon(address storageAddress, bytes32 caseId, bool won) public
638     {
639         EternalStorage st = EternalStorage(storageAddress);
640         st.setBool(keccak256("case.won", caseId), won);
641     }
642 
643     function setCaseStatus(address storageAddress, bytes32 caseId, CaseStatus status) public
644     {
645         uint8 statusCode = uint8(status);
646         require(statusCode >= 0 && statusCode <= uint8(CaseStatus.CANCELED));
647         EternalStorage(storageAddress).setUint8(keccak256("case.status", caseId), statusCode);
648     }
649 
650     function getCaseStatus(address storageAddress, bytes32 caseId) public view returns(CaseStatus) {
651         return CaseStatus(EternalStorage(storageAddress).getUint8(keccak256("case.status", caseId)));
652     }
653 
654     function setCaseCanceledCode(address storageAddress, bytes32 caseId, CaseCanceledCode cause) public
655     {
656         uint8 causeCode = uint8(cause);
657         require(causeCode >= 0 && causeCode <= uint8(CaseCanceledCode.EQUAL_NUMBER_OF_VOTES));
658         EternalStorage(storageAddress).setUint8(keccak256("case.canceled.cause.code", caseId), causeCode);
659     }
660 
661     function getCaseDate(address storageAddress, bytes32 caseId) public view returns(uint) {
662         return EternalStorage(storageAddress).getUint(keccak256("case.date", caseId));
663     }
664 
665     function getRespondentDescription(address storageAddress, bytes32 caseId) public view returns(bytes32) {
666         return EternalStorage(storageAddress).getBytes32(keccak256("case.respondent.description", caseId));
667     }
668 
669     function setRespondentDescription(address storageAddress, bytes32 caseId, string description) public {
670         EternalStorage(storageAddress).setBytes32(keccak256("case.respondent.description", caseId), keccak256(description));
671     }
672 
673     function getApplicant(address storageAddress, bytes32 caseId) public view returns(address) {
674         return EternalStorage(storageAddress).getAddress(keccak256("case.applicant", caseId));
675     }
676 
677     function getRespondent(address storageAddress, bytes32 caseId) public view returns(address) {
678         return EternalStorage(storageAddress).getAddress(keccak256("case.respondent", caseId));
679     }
680 
681     function getRefereeAward(address storageAddress, bytes32 caseId) public view returns(uint) {
682         return EternalStorage(storageAddress).getUint(keccak256("case.referee.award", caseId));
683     }
684 
685     function getVotingDate(address storageAddress, bytes32 caseId) public view returns(uint) {
686         return EternalStorage(storageAddress).getUint(keccak256("case.date.voting", caseId));
687     }
688 
689     function getRevealingDate(address storageAddress, bytes32 caseId) public view returns(uint) {
690         return EternalStorage(storageAddress).getUint(keccak256("case.date.revealing", caseId));
691     }
692 
693     function getCloseDate(address storageAddress, bytes32 caseId) public view returns(uint) {
694         return EternalStorage(storageAddress).getUint(keccak256("case.date.close", caseId));
695     }
696 
697     function getRefereeCountNeed(address storageAddress, bytes32 caseId) public view returns(uint) {
698         return EternalStorage(storageAddress).getUint(keccak256("case.referee.count.need", caseId));
699     }
700 
701     function isEthRefereeAward(address storageAddress, bytes32 caseId) public view returns(bool) {
702         return EternalStorage(storageAddress).getBool(keccak256("case.referee.award.eth", caseId));
703     }
704 }
705 
706 contract IBoardConfig is Ownable {
707 
708     uint constant decimals = 10 ** uint(18);
709     uint8 public version;
710 
711     function resetValuesToDefault() external;
712 
713     function setStorageAddress(address storageAddress) external;
714 
715     function getRefereeFee() external view returns (uint);
716     function getRefereeFeeEth() external view returns(uint);
717 
718     function getVoteTokenPrice() external view returns (uint);
719     function setVoteTokenPrice(uint value) external;
720 
721     function getVoteTokenPriceEth() external view returns (uint);
722     function setVoteTokenPriceEth(uint value) external;
723 
724     function getVoteTokensPerRequest() external view returns (uint);
725     function setVoteTokensPerRequest(uint voteTokens) external;
726 
727     function getTimeToStartVotingCase() external view returns (uint);
728     function setTimeToStartVotingCase(uint value) external;
729 
730     function getTimeToRevealVotesCase() external view returns (uint);
731     function setTimeToRevealVotesCase(uint value) external;
732 
733     function getTimeToCloseCase() external view returns (uint);
734     function setTimeToCloseCase(uint value) external;
735 
736     function getRefereeCountPerCase() external view returns(uint);
737     function setRefereeCountPerCase(uint refereeCount) external;
738 
739     function getRefereeNeedCountPerCase() external view returns(uint);
740     function setRefereeNeedCountPerCase(uint refereeCount) external;
741 
742     function getFullConfiguration()
743     external view returns(
744         uint voteTokenPrice, uint voteTokenPriceEth, uint voteTokenPerRequest,
745         uint refereeCountPerCase, uint refereeNeedCountPerCase,
746         uint timeToStartVoting, uint timeToRevealVotes, uint timeToClose
747     );
748 
749     function getCaseDatesFromNow() public view returns(uint[] dates);
750 
751 }
752 
753 contract PaymentHolder is Ownable {
754 
755     modifier onlyAllowed() {
756         require(allowed[msg.sender]);
757         _;
758     }
759 
760     modifier onlyUpdater() {
761         require(msg.sender == updater);
762         _;
763     }
764 
765     mapping(address => bool) public allowed;
766     address public updater;
767 
768     /*-----------------MAINTAIN METHODS------------------*/
769 
770     function setUpdater(address _updater)
771     external onlyOwner {
772         updater = _updater;
773     }
774 
775     function migrate(address newHolder, address[] tokens, address[] _allowed)
776     external onlyOwner {
777         require(PaymentHolder(newHolder).update.value(address(this).balance)(_allowed));
778         for (uint256 i = 0; i < tokens.length; i++) {
779             address token = tokens[i];
780             uint256 balance = Token(token).balanceOf(this);
781             if (balance > 0) {
782                 require(Token(token).transfer(newHolder, balance));
783             }
784         }
785     }
786 
787     function update(address[] _allowed)
788     external payable onlyUpdater returns(bool) {
789         for (uint256 i = 0; i < _allowed.length; i++) {
790             allowed[_allowed[i]] = true;
791         }
792         return true;
793     }
794 
795     /*-----------------OWNER FLOW------------------*/
796 
797     function allow(address to) 
798     external onlyOwner { allowed[to] = true; }
799 
800     function prohibit(address to)
801     external onlyOwner { allowed[to] = false; }
802 
803     /*-----------------ALLOWED FLOW------------------*/
804 
805     function depositEth()
806     public payable onlyAllowed returns (bool) {
807         //Default function to receive eth
808         return true;
809     }
810 
811     function withdrawEth(address to, uint256 amount)
812     public onlyAllowed returns(bool) {
813         require(address(this).balance >= amount, "Not enough ETH balance");
814         to.transfer(amount);
815         return true;
816     }
817 
818     function withdrawToken(address to, uint256 amount, address token)
819     public onlyAllowed returns(bool) {
820         require(Token(token).balanceOf(this) >= amount, "Not enough token balance");
821         require(Token(token).transfer(to, amount));
822         return true;
823     }
824 }
825 
826 contract Board is IBoard {
827 
828     using SafeMath for uint;
829     using VoteTokenLib for address;
830     using CasesLib for address;
831     using RefereesLib for address;
832     using RefereeCasesLib for address;
833 
834     modifier onlyRespondent(bytes32 caseId) {
835         require(msg.sender == lib.getRespondent(caseId));
836         _;
837     }
838 
839     modifier hasStatus(bytes32 caseId, CasesLib.CaseStatus state) {
840         require(state == lib.getCaseStatus(caseId));
841         _;
842     }
843 
844     modifier before(uint date) {
845         require(now <= date);
846         _;
847     }
848 
849     modifier laterOn(uint date) {
850         require(now >= date);
851         _;
852     }
853 
854     function Board(address storageAddress, address configAddress, address _paymentHolder) public {
855         version = 2;
856         config = IBoardConfig(configAddress);
857         lib = storageAddress;
858         //check real BKX address https://etherscan.io/token/0x45245bc59219eeaAF6cD3f382e078A461FF9De7B
859         bkxToken = BkxToken(0x45245bc59219eeaAF6cD3f382e078A461FF9De7B);
860         admin = 0xE0b6C095D722961C2C11E55b97fCd0C8bd7a1cD2;
861         paymentHolder = _paymentHolder;
862         refereePaymentHolder = msg.sender;
863     }
864 
865     function withdrawEth(uint value) external onlyOwner {
866         require(address(this).balance >= value);
867         msg.sender.transfer(value);
868     }
869 
870     function withdrawBkx(uint value) external onlyOwner {
871         require(bkxToken.balanceOf(address(this)) >= value);
872         require(bkxToken.transfer(msg.sender, value));
873     }
874 
875     /* configuration */
876     function setStorageAddress(address storageAddress) external onlyOwner {
877         lib = storageAddress;
878     }
879 
880     function setConfigAddress(address configAddress) external onlyOwner {
881         config = IBoardConfig(configAddress);
882     }
883 
884     /* dependency tokens */
885     function setBkxToken(address tokenAddress) external onlyOwner {
886         bkxToken = BkxToken(tokenAddress);
887     }
888 
889     function setPaymentHolder(address _paymentHolder) external onlyOwner {
890         paymentHolder = _paymentHolder;
891     }
892 
893     function setRefereePaymentHolder(address _refereePaymentHolder) external onlyOwner {
894         refereePaymentHolder = _refereePaymentHolder;
895     }
896 
897     function setAdmin(address newAdmin) external onlyOwner {
898         admin = newAdmin;
899     }
900 
901     function applyForReferee() external {
902         uint refereeFee = config.getRefereeFee();
903         require(bkxToken.allowance(msg.sender, address(this)) >= refereeFee);
904         require(bkxToken.balanceOf(msg.sender) >= refereeFee);
905         require(bkxToken.transferFrom(msg.sender, refereePaymentHolder, refereeFee));
906         addVotes(msg.sender);
907     }
908 
909     function addVoteTokens(address referee) external onlyOwnerOrAdmin {
910         addVotes(referee);
911     }
912 
913     function addVotes(address referee) private {
914         uint refereeTokens = config.getVoteTokensPerRequest();
915         if (!lib.isRefereeApplied(referee)) {
916             lib.addReferee(referee);
917         }
918         uint balance = refereeTokens.add(lib.getVotes(referee));
919         lib.setVotes(referee, balance);
920         emit RefereeVoteBalanceChanged(referee, balance);
921     }
922 
923     function openCase(address respondent, bytes32 deal, uint amount, uint refereeAward, bytes32 title, string description)
924     external payable {
925         require(msg.sender != respondent);
926         withdrawPayment(refereeAward);
927         uint[] memory dates = config.getCaseDatesFromNow();
928         uint refereeCountNeed = config.getRefereeNeedCountPerCase();
929         bytes32 caseId = lib.addCase(msg.sender, respondent, deal, amount, refereeAward, title, description, dates, refereeCountNeed, msg.value != 0);
930         emit CaseOpened(caseId, msg.sender, respondent, deal, amount, refereeAward, title, description, dates, refereeCountNeed, msg.value != 0);
931         assignRefereesToCase(caseId, msg.sender, respondent);
932     }
933 
934     function withdrawPayment(uint256 amount) private {
935         if(msg.value != 0) {
936             require(msg.value == amount, "ETH amount must be equal amount");
937             require(PaymentHolder(paymentHolder).depositEth.value(msg.value)());
938         } else {
939             require(bkxToken.allowance(msg.sender, address(this)) >= amount);
940             require(bkxToken.balanceOf(msg.sender) >= amount);
941             require(bkxToken.transferFrom(msg.sender, paymentHolder, amount));
942         }
943     }
944 
945     function assignRefereesToCase(bytes32 caseId, address applicant, address respondent) private  {
946         uint targetCount = config.getRefereeCountPerCase();
947         address[] memory foundReferees = lib.getRandomRefereesToCase(applicant, respondent, targetCount);
948         for (uint i = 0; i < foundReferees.length; i++) {
949             address referee = foundReferees[i];
950             uint voteBalance = lib.getVotes(referee);
951             voteBalance -= 1;
952             lib.setVotes(referee, voteBalance);
953             emit RefereeVoteBalanceChanged(referee, voteBalance);
954         }
955         lib.setRefereesToCase(foundReferees, caseId);
956         emit RefereesAssignedToCase(caseId, foundReferees);
957     }
958 
959     function setRespondentDescription(bytes32 caseId, string description)
960     external onlyRespondent(caseId) hasStatus(caseId, CasesLib.CaseStatus.OPENED) before(lib.getVotingDate(caseId)) {
961         require(lib.getRespondentDescription(caseId) == 0);
962         lib.setRespondentDescription(caseId, description);
963         lib.setCaseStatus(caseId, CasesLib.CaseStatus.VOTING);
964         emit CaseCommentedByRespondent(caseId, msg.sender, description);
965         emit CaseVoting(caseId);
966     }
967 
968     function startVotingCase(bytes32 caseId)
969     external hasStatus(caseId, CasesLib.CaseStatus.OPENED) laterOn(lib.getVotingDate(caseId)) {
970         lib.setCaseStatus(caseId, CasesLib.CaseStatus.VOTING);
971         emit CaseVoting(caseId);
972     }
973 
974     function commitVote(bytes32 caseId, bytes32 voteHash)
975     external hasStatus(caseId, CasesLib.CaseStatus.VOTING) before(lib.getRevealingDate(caseId))
976     {
977         require(lib.isRefereeSetToCase(msg.sender, caseId)); //referee must be set to case
978         require(!lib.isRefereeVoted(msg.sender, caseId)); //referee can not vote twice
979         lib.setRefereeVoteHash(caseId, msg.sender, voteHash);
980         emit CaseVoteCommitted(caseId, msg.sender, voteHash);
981         if (lib.getRefereeVoteHashCount(caseId) == lib.getRefereeCountByCase(caseId)) {
982             lib.setCaseStatus(caseId, CasesLib.CaseStatus.REVEALING);
983             emit CaseRevealingVotes(caseId);
984         }
985     }
986 
987     function startRevealingVotes(bytes32 caseId)
988     external hasStatus(caseId, CasesLib.CaseStatus.VOTING) laterOn(lib.getRevealingDate(caseId))
989     {
990         lib.setCaseStatus(caseId, CasesLib.CaseStatus.REVEALING);
991         emit CaseRevealingVotes(caseId);
992     }
993 
994     function revealVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt)
995     external hasStatus(caseId, CasesLib.CaseStatus.REVEALING) before(lib.getCloseDate(caseId))
996     {
997         doRevealVote(caseId, referee, voteOption, salt);
998         checkShouldMakeVerdict(caseId);
999     }
1000 
1001     function revealVotes(bytes32 caseId, address[] referees, uint8[] voteOptions, bytes32[] salts)
1002     external hasStatus(caseId, CasesLib.CaseStatus.REVEALING) before(lib.getCloseDate(caseId))
1003     {
1004         require((referees.length == voteOptions.length) && (referees.length == salts.length));
1005         for (uint i = 0; i < referees.length; i++) {
1006             doRevealVote(caseId, referees[i], voteOptions[i], salts[i]);
1007         }
1008         checkShouldMakeVerdict(caseId);
1009     }
1010 
1011     function checkShouldMakeVerdict(bytes32 caseId)
1012     private {
1013         if (lib.getRefereeVotesFor(caseId, true) + lib.getRefereeVotesFor(caseId, false) == lib.getRefereeVoteHashCount(caseId)) {
1014             makeVerdict(caseId);
1015         }
1016     }
1017 
1018     function doRevealVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt) private {
1019         require(verifyVote(caseId, referee, voteOption, salt));
1020         lib.setRefereeVote(caseId, referee,  voteOption == 0);
1021         emit CaseVoteRevealed(caseId, referee, voteOption, salt);
1022     }
1023 
1024     function createVoteHash(uint8 voteOption, bytes32 salt)
1025     public view returns(bytes32) {
1026         return keccak256(voteOption, salt);
1027     }
1028 
1029     function verifyVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt)
1030     public view returns(bool){
1031         return lib.getRefereeVoteHash(caseId, referee) == keccak256(voteOption, salt);
1032     }
1033 
1034     function verdict(bytes32 caseId)
1035     external hasStatus(caseId, CasesLib.CaseStatus.REVEALING) laterOn(lib.getCloseDate(caseId)) {
1036         makeVerdict(caseId);
1037     }
1038 
1039     function makeVerdict(bytes32 caseId)
1040     private {
1041         uint forApplicant = lib.getRefereeVotesFor(caseId, true);
1042         uint forRespondent = lib.getRefereeVotesFor(caseId, false);
1043         uint refereeAward = lib.getRefereeAward(caseId);
1044         bool isNotEnoughVotes = (forApplicant + forRespondent) < lib.getRefereeCountNeed(caseId);
1045         bool isEthRefereeAward = lib.isEthRefereeAward(caseId);
1046         if (isNotEnoughVotes || (forApplicant == forRespondent)) {
1047             withdrawTo(isEthRefereeAward, lib.getApplicant(caseId), refereeAward);
1048             lib.setCaseStatus(caseId, CasesLib.CaseStatus.CANCELED);
1049             CasesLib.CaseCanceledCode causeCode = isNotEnoughVotes ?
1050                 CasesLib.CaseCanceledCode.NOT_ENOUGH_VOTES : CasesLib.CaseCanceledCode.EQUAL_NUMBER_OF_VOTES;
1051             lib.setCaseCanceledCode(caseId, causeCode);
1052             emit CaseCanceled(caseId, uint8(causeCode));
1053             withdrawAllRefereeVotes(caseId);
1054             return;
1055         }
1056         bool won = false;
1057         uint awardPerReferee;
1058         if (forApplicant > forRespondent) {
1059             won = true;
1060             awardPerReferee = refereeAward / forApplicant;
1061         } else {
1062             awardPerReferee = refereeAward / forRespondent;
1063         }
1064         lib.setCaseStatus(caseId, CasesLib.CaseStatus.CLOSED);
1065         lib.setCaseWon(caseId, won);
1066         emit CaseClosed(caseId, won);
1067         address[] memory wonReferees = lib.getRefereesFor(caseId, won);
1068         for (uint i = 0; i < wonReferees.length; i++) {
1069             withdrawTo(isEthRefereeAward, wonReferees[i], awardPerReferee);
1070             emit RefereeAwarded(wonReferees[i], caseId, awardPerReferee);
1071         }
1072         withdrawRefereeVotes(caseId);
1073     }
1074 
1075     function withdrawTo(bool isEth, address to, uint amount) private {
1076         if (isEth) {
1077             require(PaymentHolder(paymentHolder).withdrawEth(to, amount));
1078         } else {
1079             require(PaymentHolder(paymentHolder).withdrawToken(to, amount, address(bkxToken)));
1080         }
1081     } 
1082 
1083     function withdrawAllRefereeVotes(bytes32 caseId) private {
1084         address[] memory referees = lib.getRefereesByCase(caseId);
1085         for (uint i = 0; i < referees.length; i++) {
1086             withdrawRefereeVote(referees[i]);
1087         }
1088     }
1089 
1090     function withdrawRefereeVotes(bytes32 caseId)
1091     private {
1092         address[] memory referees = lib.getRefereesByCase(caseId);
1093         for (uint i = 0; i < referees.length; i++) {
1094             if (!lib.isRefereeVoted(referees[i], caseId)) {
1095                 withdrawRefereeVote(referees[i]);
1096             }
1097         }
1098     }
1099 
1100     function withdrawRefereeVote(address referee)
1101     private {
1102         uint voteBalance = lib.getVotes(referee);
1103         voteBalance += 1;
1104         lib.setVotes(referee, voteBalance);
1105         emit RefereeVoteBalanceChanged(referee, voteBalance);
1106     }
1107 }