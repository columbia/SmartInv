1 contract Ownable {
2   address public owner;
3 
4 
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7 
8   /**
9    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10    * account.
11    */
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   /**
25    * @dev Allows the current owner to transfer control of the contract to a newOwner.
26    * @param newOwner The address to transfer ownership to.
27    */
28   function transferOwnership(address newOwner) public onlyOwner {
29     require(newOwner != address(0));
30     emit OwnershipTransferred(owner, newOwner);
31     owner = newOwner;
32   }
33 
34 }
35 
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, throws on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers, truncating the quotient.
52   */
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   /**
61   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62   */
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   /**
69   * @dev Adds two numbers, throws on overflow.
70   */
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 library Utils {
79      /* Not secured random number generation, but it's enough for the perpose of implementaion particular case*/
80     function almostRnd(uint min, uint max) internal view returns(uint)
81     {
82         return uint(keccak256(block.timestamp, block.blockhash(block.number))) % (max - min) + min;
83     }
84 }
85 contract EternalStorage {
86 
87     /**** Storage Types *******/
88 
89     address public owner;
90 
91     mapping(bytes32 => uint256)    private uIntStorage;
92     mapping(bytes32 => uint8)      private uInt8Storage;
93     mapping(bytes32 => string)     private stringStorage;
94     mapping(bytes32 => address)    private addressStorage;
95     mapping(bytes32 => bytes)      private bytesStorage;
96     mapping(bytes32 => bool)       private boolStorage;
97     mapping(bytes32 => int256)     private intStorage;
98     mapping(bytes32 => bytes32)    private bytes32Storage;
99 
100 
101     /*** Modifiers ************/
102 
103     /// @dev Only allow access from the latest version of a contract in the Rocket Pool network after deployment
104     modifier onlyLatestContract() {
105         require(addressStorage[keccak256("contract.address", msg.sender)] != 0x0 || msg.sender == owner);
106         _;
107     }
108 
109     /// @dev constructor
110     function EternalStorage() public {
111         owner = msg.sender;
112         addressStorage[keccak256("contract.address", msg.sender)] = msg.sender;
113     }
114 
115     function setOwner() public {
116         require(msg.sender == owner);
117         addressStorage[keccak256("contract.address", owner)] = 0x0;
118         owner = msg.sender;
119         addressStorage[keccak256("contract.address", msg.sender)] = msg.sender;
120     }
121 
122     /**** Get Methods ***********/
123 
124     /// @param _key The key for the record
125     function getAddress(bytes32 _key) external view returns (address) {
126         return addressStorage[_key];
127     }
128 
129     /// @param _key The key for the record
130     function getUint(bytes32 _key) external view returns (uint) {
131         return uIntStorage[_key];
132     }
133 
134       /// @param _key The key for the record
135     function getUint8(bytes32 _key) external view returns (uint8) {
136         return uInt8Storage[_key];
137     }
138 
139 
140     /// @param _key The key for the record
141     function getString(bytes32 _key) external view returns (string) {
142         return stringStorage[_key];
143     }
144 
145     /// @param _key The key for the record
146     function getBytes(bytes32 _key) external view returns (bytes) {
147         return bytesStorage[_key];
148     }
149 
150     /// @param _key The key for the record
151     function getBytes32(bytes32 _key) external view returns (bytes32) {
152         return bytes32Storage[_key];
153     }
154 
155     /// @param _key The key for the record
156     function getBool(bytes32 _key) external view returns (bool) {
157         return boolStorage[_key];
158     }
159 
160     /// @param _key The key for the record
161     function getInt(bytes32 _key) external view returns (int) {
162         return intStorage[_key];
163     }
164 
165     /**** Set Methods ***********/
166 
167     /// @param _key The key for the record
168     function setAddress(bytes32 _key, address _value) onlyLatestContract external {
169         addressStorage[_key] = _value;
170     }
171 
172     /// @param _key The key for the record
173     function setUint(bytes32 _key, uint _value) onlyLatestContract external {
174         uIntStorage[_key] = _value;
175     }
176 
177     /// @param _key The key for the record
178     function setUint8(bytes32 _key, uint8 _value) onlyLatestContract external {
179         uInt8Storage[_key] = _value;
180     }
181 
182     /// @param _key The key for the record
183     function setString(bytes32 _key, string _value) onlyLatestContract external {
184         stringStorage[_key] = _value;
185     }
186 
187     /// @param _key The key for the record
188     function setBytes(bytes32 _key, bytes _value) onlyLatestContract external {
189         bytesStorage[_key] = _value;
190     }
191 
192     /// @param _key The key for the record
193     function setBytes32(bytes32 _key, bytes32 _value) onlyLatestContract external {
194         bytes32Storage[_key] = _value;
195     }
196 
197     /// @param _key The key for the record
198     function setBool(bytes32 _key, bool _value) onlyLatestContract external {
199         boolStorage[_key] = _value;
200     }
201 
202     /// @param _key The key for the record
203     function setInt(bytes32 _key, int _value) onlyLatestContract external {
204         intStorage[_key] = _value;
205     }
206 
207     /**** Delete Methods ***********/
208 
209     /// @param _key The key for the record
210     function deleteAddress(bytes32 _key) onlyLatestContract external {
211         delete addressStorage[_key];
212     }
213 
214     /// @param _key The key for the record
215     function deleteUint(bytes32 _key) onlyLatestContract external {
216         delete uIntStorage[_key];
217     }
218 
219      /// @param _key The key for the record
220     function deleteUint8(bytes32 _key) onlyLatestContract external {
221         delete uInt8Storage[_key];
222     }
223 
224     /// @param _key The key for the record
225     function deleteString(bytes32 _key) onlyLatestContract external {
226         delete stringStorage[_key];
227     }
228 
229     /// @param _key The key for the record
230     function deleteBytes(bytes32 _key) onlyLatestContract external {
231         delete bytesStorage[_key];
232     }
233 
234     /// @param _key The key for the record
235     function deleteBytes32(bytes32 _key) onlyLatestContract external {
236         delete bytes32Storage[_key];
237     }
238 
239     /// @param _key The key for the record
240     function deleteBool(bytes32 _key) onlyLatestContract external {
241         delete boolStorage[_key];
242     }
243 
244     /// @param _key The key for the record
245     function deleteInt(bytes32 _key) onlyLatestContract external {
246         delete intStorage[_key];
247     }
248 }
249 
250 contract EIP20 {
251     /* This is a slight change to the ERC20 base standard.
252     function totalSupply() constant returns (uint256 supply);
253     is replaced with:
254     uint256 public totalSupply;
255     This automatically creates a getter function for the totalSupply.
256     This is moved to the base contract since public getter functions are not
257     currently recognised as an implementation of the matching abstract
258     function by the compiler.
259     */
260     /// total amount of tokens
261     uint256 public totalSupply;
262 
263     /// @param _owner The address from which the balance will be retrieved
264     /// @return The balance
265     function balanceOf(address _owner) public view returns (uint256 balance);
266 
267     /// @notice send `_value` token to `_to` from `msg.sender`
268     /// @param _to The address of the recipient
269     /// @param _value The amount of token to be transferred
270     /// @return Whether the transfer was successful or not
271     function transfer(address _to, uint256 _value) public returns (bool success);
272 
273     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
274     /// @param _from The address of the sender
275     /// @param _to The address of the recipient
276     /// @param _value The amount of token to be transferred
277     /// @return Whether the transfer was successful or not
278     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
279 
280     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
281     /// @param _spender The address of the account able to transfer the tokens
282     /// @param _value The amount of tokens to be approved for transfer
283     /// @return Whether the approval was successful or not
284     function approve(address _spender, uint256 _value) public returns (bool success);
285 
286     /// @param _owner The address of the account owning tokens
287     /// @param _spender The address of the account able to transfer the tokens
288     /// @return Amount of remaining tokens allowed to spent
289     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
290 
291     // solhint-disable-next-line no-simple-event-func-name  
292     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
293     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
294 }
295 contract Token {
296     function balanceOf(address owner) public view returns (uint256 balance);
297 
298     function transfer(address to, uint256 value) public returns (bool success);
299 
300     function transferFrom(address from, address to, uint256 value) public returns (bool success);
301 
302     function approve(address spender, uint256 value) public returns (bool success);
303 
304     function allowance(address owner, address spender) public view returns (uint256 remaining);
305 }
306 contract IBoardConfig is Ownable {
307 
308     uint constant decimals = 10 ** uint(18);
309     uint8 public version;
310 
311     function resetValuesToDefault() external;
312 
313     function setStorageAddress(address storageAddress) external;
314 
315     function getRefereeFee() external view returns (uint);
316     function getRefereeFeeEth() external view returns(uint);
317 
318     function getVoteTokenPrice() external view returns (uint);
319     function setVoteTokenPrice(uint value) external;
320 
321     function getVoteTokenPriceEth() external view returns (uint);
322     function setVoteTokenPriceEth(uint value) external;
323 
324     function getVoteTokensPerRequest() external view returns (uint);
325     function setVoteTokensPerRequest(uint voteTokens) external;
326 
327     function getTimeToStartVotingCase() external view returns (uint);
328     function setTimeToStartVotingCase(uint value) external;
329 
330     function getTimeToRevealVotesCase() external view returns (uint);
331     function setTimeToRevealVotesCase(uint value) external;
332 
333     function getTimeToCloseCase() external view returns (uint);
334     function setTimeToCloseCase(uint value) external;
335 
336     function getRefereeCountPerCase() external view returns(uint);
337     function setRefereeCountPerCase(uint refereeCount) external;
338 
339     function getRefereeNeedCountPerCase() external view returns(uint);
340     function setRefereeNeedCountPerCase(uint refereeCount) external;
341 
342     function getFullConfiguration()
343     external view returns(
344         uint voteTokenPrice, uint voteTokenPriceEth, uint voteTokenPerRequest,
345         uint refereeCountPerCase, uint refereeNeedCountPerCase,
346         uint timeToStartVoting, uint timeToRevealVotes, uint timeToClose
347     );
348 
349     function getCaseDatesFromNow() public view returns(uint[] dates);
350 
351 }
352 library RefereeCasesLib {
353 
354     function setRefereesToCase(address storageAddress, address[] referees, bytes32 caseId) public {
355         for (uint i = 0; i < referees.length; i++) {
356             setRefereeToCase(storageAddress, referees[i], caseId, i);
357         }
358         setRefereeCountForCase(storageAddress, caseId, referees.length);
359     }
360 
361     function isRefereeVoted(address storageAddress, address referee, bytes32 caseId) public view returns (bool) {
362         return EternalStorage(storageAddress).getBool(keccak256("case.referees.voted", caseId, referee));
363     }
364 
365     function setRefereeVote(address storageAddress, bytes32 caseId, address referee, bool forApplicant) public {
366         uint index = getRefereeVotesFor(storageAddress, caseId, forApplicant);
367         EternalStorage(storageAddress).setAddress(keccak256("case.referees.vote", caseId, forApplicant, index), referee);
368         setRefereeVotesFor(storageAddress, caseId,  forApplicant, index + 1);
369     }
370 
371     function getRefereeVoteForByIndex(address storageAddress, bytes32 caseId, bool forApplicant, uint index) public view returns (address) {
372         return EternalStorage(storageAddress).getAddress(keccak256("case.referees.vote", caseId, forApplicant, index));
373     }
374 
375     function getRefereeVotesFor(address storageAddress, bytes32 caseId, bool forApplicant) public view returns (uint) {
376         return EternalStorage(storageAddress).getUint(keccak256("case.referees.votes.count", caseId, forApplicant));
377     }
378 
379     function setRefereeVotesFor(address storageAddress, bytes32 caseId, bool forApplicant, uint votes) public {
380         EternalStorage(storageAddress).setUint(keccak256("case.referees.votes.count", caseId, forApplicant), votes);
381     }
382 
383     function getRefereeCountByCase(address storageAddress, bytes32 caseId) public view returns (uint) {
384         return EternalStorage(storageAddress).getUint(keccak256("case.referees.count", caseId));
385     }
386 
387     function setRefereeCountForCase(address storageAddress, bytes32 caseId, uint value) public {
388         EternalStorage(storageAddress).setUint(keccak256("case.referees.count", caseId), value);
389     }
390 
391     function getRefereeByCase(address storageAddress, bytes32 caseId, uint index) public view returns (address) {
392         return EternalStorage(storageAddress).getAddress(keccak256("case.referees", caseId, index));
393     }
394 
395     function isRefereeSetToCase(address storageAddress, address referee, bytes32 caseId) public view returns(bool) {
396         return EternalStorage(storageAddress).getBool(keccak256("case.referees", caseId, referee));
397     }
398     
399     function setRefereeToCase(address storageAddress, address referee, bytes32 caseId, uint index) public {
400         EternalStorage st = EternalStorage(storageAddress);
401         st.setAddress(keccak256("case.referees", caseId, index), referee);
402         st.setBool(keccak256("case.referees", caseId, referee), true);
403     }
404 
405     function getRefereeVoteHash(address storageAddress, bytes32 caseId, address referee) public view returns (bytes32) {
406         return EternalStorage(storageAddress).getBytes32(keccak256("case.referees.vote.hash", caseId, referee));
407     }
408 
409     function setRefereeVoteHash(address storageAddress, bytes32 caseId, address referee, bytes32 voteHash) public {
410         uint caseCount = getRefereeVoteHashCount(storageAddress, caseId);
411         EternalStorage(storageAddress).setBool(keccak256("case.referees.voted", caseId, referee), true);
412         EternalStorage(storageAddress).setBytes32(keccak256("case.referees.vote.hash", caseId, referee), voteHash);
413         EternalStorage(storageAddress).setUint(keccak256("case.referees.vote.hash.count", caseId), caseCount + 1);
414     }
415 
416     function getRefereeVoteHashCount(address storageAddress, bytes32 caseId) public view returns(uint) {
417         return EternalStorage(storageAddress).getUint(keccak256("case.referees.vote.hash.count", caseId));
418     }
419 
420     function getRefereesFor(address storageAddress, bytes32 caseId, bool forApplicant)
421     public view returns(address[]) {
422         uint n = getRefereeVotesFor(storageAddress, caseId, forApplicant);
423         address[] memory referees = new address[](n);
424         for (uint i = 0; i < n; i++) {
425             referees[i] = getRefereeVoteForByIndex(storageAddress, caseId, forApplicant, i);
426         }
427         return referees;
428     }
429 
430     function getRefereesByCase(address storageAddress, bytes32 caseId)
431     public view returns (address[]) {
432         uint n = getRefereeCountByCase(storageAddress, caseId);
433         address[] memory referees = new address[](n);
434         for (uint i = 0; i < n; i++) {
435             referees[i] = getRefereeByCase(storageAddress, caseId, i);
436         }
437         return referees;
438     }
439 
440 }
441 contract Withdrawable is Ownable {
442     function withdrawEth(uint value) external onlyOwner {
443         require(address(this).balance >= value);
444         msg.sender.transfer(value);
445     }
446 
447     function withdrawToken(address token, uint value) external onlyOwner {
448         require(Token(token).balanceOf(address(this)) >= value, "Not enough tokens");
449         require(Token(token).transfer(msg.sender, value));
450     }
451 }
452 
453 library CasesLib {
454 
455     enum CaseStatus {OPENED, VOTING, REVEALING, CLOSED, CANCELED}
456     enum CaseCanceledCode { NOT_ENOUGH_VOTES, EQUAL_NUMBER_OF_VOTES }
457 
458     function getCase(address storageAddress, bytes32 caseId)
459     public view returns ( address applicant, address respondent,
460         bytes32 deal, uint amount,
461         uint refereeAward,
462         bytes32 title, uint8 status, uint8 canceledCode,
463         bool won, bytes32 applicantDescriptionHash,
464         bytes32 respondentDescriptionHash, bool isEthRefereeAward)
465     {
466         EternalStorage st = EternalStorage(storageAddress);
467         applicant = st.getAddress(keccak256("case.applicant", caseId));
468         respondent = st.getAddress(keccak256("case.respondent", caseId));
469         deal = st.getBytes32(keccak256("case.deal", caseId));
470         amount = st.getUint(keccak256("case.amount", caseId));
471         won = st.getBool(keccak256("case.won", caseId));
472         status = st.getUint8(keccak256("case.status", caseId));
473         canceledCode = st.getUint8(keccak256("case.canceled.cause.code", caseId));
474         refereeAward = st.getUint(keccak256("case.referee.award", caseId));
475         title = st.getBytes32(keccak256("case.title", caseId));
476         applicantDescriptionHash = st.getBytes32(keccak256("case.applicant.description", caseId));
477         respondentDescriptionHash = st.getBytes32(keccak256("case.respondent.description", caseId));
478         isEthRefereeAward = st.getBool(keccak256("case.referee.award.eth", caseId));
479     }
480 
481     function getCaseDates(address storageAddress, bytes32 caseId)
482     public view returns (uint date, uint votingDate, uint revealingDate, uint closeDate)
483     {
484         EternalStorage st = EternalStorage(storageAddress);
485         date = st.getUint(keccak256("case.date", caseId));
486         votingDate = st.getUint(keccak256("case.date.voting", caseId));
487         revealingDate = st.getUint(keccak256("case.date.revealing", caseId));
488         closeDate = st.getUint(keccak256("case.date.close", caseId));
489     }
490 
491     function addCase(
492         address storageAddress, address applicant, 
493         address respondent, bytes32 deal, 
494         uint amount, uint refereeAward,
495         bytes32 title, string applicantDescription,
496         uint[] dates, uint refereeCountNeed, bool isEthRefereeAward
497     )
498     public returns(bytes32 caseId)
499     {
500         EternalStorage st = EternalStorage(storageAddress);
501         caseId = keccak256(applicant, respondent, deal, dates[0], title, amount);
502         st.setAddress(keccak256("case.applicant", caseId), applicant);
503         st.setAddress(keccak256("case.respondent", caseId), respondent);
504         st.setBytes32(keccak256("case.deal", caseId), deal);
505         st.setUint(keccak256("case.amount", caseId), amount);
506         st.setUint(keccak256("case.date", caseId), dates[0]);
507         st.setUint(keccak256("case.date.voting", caseId), dates[1]);
508         st.setUint(keccak256("case.date.revealing", caseId), dates[2]);
509         st.setUint(keccak256("case.date.close", caseId), dates[3]);
510         st.setUint8(keccak256("case.status", caseId), 0);//OPENED
511         st.setUint(keccak256("case.referee.award", caseId), refereeAward);
512         st.setBytes32(keccak256("case.title", caseId), title);
513         st.setBytes32(keccak256("case.applicant.description", caseId), keccak256(applicantDescription));
514         st.setBool(keccak256("case.referee.award.eth", caseId), isEthRefereeAward);
515         st.setUint(keccak256("case.referee.count.need", caseId), refereeCountNeed);
516     }
517 
518     function setCaseWon(address storageAddress, bytes32 caseId, bool won) public
519     {
520         EternalStorage st = EternalStorage(storageAddress);
521         st.setBool(keccak256("case.won", caseId), won);
522     }
523 
524     function setCaseStatus(address storageAddress, bytes32 caseId, CaseStatus status) public
525     {
526         uint8 statusCode = uint8(status);
527         require(statusCode >= 0 && statusCode <= uint8(CaseStatus.CANCELED));
528         EternalStorage(storageAddress).setUint8(keccak256("case.status", caseId), statusCode);
529     }
530 
531     function getCaseStatus(address storageAddress, bytes32 caseId) public view returns(CaseStatus) {
532         return CaseStatus(EternalStorage(storageAddress).getUint8(keccak256("case.status", caseId)));
533     }
534 
535     function setCaseCanceledCode(address storageAddress, bytes32 caseId, CaseCanceledCode cause) public
536     {
537         uint8 causeCode = uint8(cause);
538         require(causeCode >= 0 && causeCode <= uint8(CaseCanceledCode.EQUAL_NUMBER_OF_VOTES));
539         EternalStorage(storageAddress).setUint8(keccak256("case.canceled.cause.code", caseId), causeCode);
540     }
541 
542     function getCaseDate(address storageAddress, bytes32 caseId) public view returns(uint) {
543         return EternalStorage(storageAddress).getUint(keccak256("case.date", caseId));
544     }
545 
546     function getRespondentDescription(address storageAddress, bytes32 caseId) public view returns(bytes32) {
547         return EternalStorage(storageAddress).getBytes32(keccak256("case.respondent.description", caseId));
548     }
549 
550     function setRespondentDescription(address storageAddress, bytes32 caseId, string description) public {
551         EternalStorage(storageAddress).setBytes32(keccak256("case.respondent.description", caseId), keccak256(description));
552     }
553 
554     function getApplicant(address storageAddress, bytes32 caseId) public view returns(address) {
555         return EternalStorage(storageAddress).getAddress(keccak256("case.applicant", caseId));
556     }
557 
558     function getRespondent(address storageAddress, bytes32 caseId) public view returns(address) {
559         return EternalStorage(storageAddress).getAddress(keccak256("case.respondent", caseId));
560     }
561 
562     function getRefereeAward(address storageAddress, bytes32 caseId) public view returns(uint) {
563         return EternalStorage(storageAddress).getUint(keccak256("case.referee.award", caseId));
564     }
565 
566     function getVotingDate(address storageAddress, bytes32 caseId) public view returns(uint) {
567         return EternalStorage(storageAddress).getUint(keccak256("case.date.voting", caseId));
568     }
569 
570     function getRevealingDate(address storageAddress, bytes32 caseId) public view returns(uint) {
571         return EternalStorage(storageAddress).getUint(keccak256("case.date.revealing", caseId));
572     }
573 
574     function getCloseDate(address storageAddress, bytes32 caseId) public view returns(uint) {
575         return EternalStorage(storageAddress).getUint(keccak256("case.date.close", caseId));
576     }
577 
578     function getRefereeCountNeed(address storageAddress, bytes32 caseId) public view returns(uint) {
579         return EternalStorage(storageAddress).getUint(keccak256("case.referee.count.need", caseId));
580     }
581 
582     function isEthRefereeAward(address storageAddress, bytes32 caseId) public view returns(bool) {
583         return EternalStorage(storageAddress).getBool(keccak256("case.referee.award.eth", caseId));
584     }
585 }
586 library VoteTokenLib  {
587 
588     function getVotes(address storageAddress, address account) public view returns(uint) {
589         return EternalStorage(storageAddress).getUint(keccak256("vote.token.balance", account));
590     }
591 
592     function increaseVotes(address storageAddress, address account, uint256 diff) public {
593         setVotes(storageAddress, account, getVotes(storageAddress, account) + diff);
594     }
595 
596     function decreaseVotes(address storageAddress, address account, uint256 diff) public {
597         setVotes(storageAddress, account, getVotes(storageAddress, account) - diff);
598     }
599 
600     function setVotes(address storageAddress, address account, uint256 value) public {
601         EternalStorage(storageAddress).setUint(keccak256("vote.token.balance", account), value);
602     }
603 
604 }
605 contract PaymentHolder is Ownable {
606 
607     modifier onlyAllowed() {
608         require(allowed[msg.sender]);
609         _;
610     }
611 
612     modifier onlyUpdater() {
613         require(msg.sender == updater);
614         _;
615     }
616 
617     mapping(address => bool) public allowed;
618     address public updater;
619 
620     /*-----------------MAINTAIN METHODS------------------*/
621 
622     function setUpdater(address _updater)
623     external onlyOwner {
624         updater = _updater;
625     }
626 
627     function migrate(address newHolder, address[] tokens, address[] _allowed)
628     external onlyOwner {
629         require(PaymentHolder(newHolder).update.value(address(this).balance)(_allowed));
630         for (uint256 i = 0; i < tokens.length; i++) {
631             address token = tokens[i];
632             uint256 balance = Token(token).balanceOf(this);
633             if (balance > 0) {
634                 require(Token(token).transfer(newHolder, balance));
635             }
636         }
637     }
638 
639     function update(address[] _allowed)
640     external payable onlyUpdater returns(bool) {
641         for (uint256 i = 0; i < _allowed.length; i++) {
642             allowed[_allowed[i]] = true;
643         }
644         return true;
645     }
646 
647     /*-----------------OWNER FLOW------------------*/
648 
649     function allow(address to) 
650     external onlyOwner { allowed[to] = true; }
651 
652     function prohibit(address to)
653     external onlyOwner { allowed[to] = false; }
654 
655     /*-----------------ALLOWED FLOW------------------*/
656 
657     function depositEth()
658     public payable onlyAllowed returns (bool) {
659         //Default function to receive eth
660         return true;
661     }
662 
663     function withdrawEth(address to, uint256 amount)
664     public onlyAllowed returns(bool) {
665         require(address(this).balance >= amount, "Not enough ETH balance");
666         to.transfer(amount);
667         return true;
668     }
669 
670     function withdrawToken(address to, uint256 amount, address token)
671     public onlyAllowed returns(bool) {
672         require(Token(token).balanceOf(this) >= amount, "Not enough token balance");
673         require(Token(token).transfer(to, amount));
674         return true;
675     }
676 
677 }
678 library RefereesLib {
679 
680     struct Referees {
681         address[] addresses;
682     }
683 
684     function addReferee(address storageAddress, address referee) public {
685         uint id = getRefereeCount(storageAddress);
686         setReferee(storageAddress, referee, id, true);
687         setRefereeCount(storageAddress, id + 1);
688     }
689 
690     function getRefereeCount(address storageAddress) public view returns(uint) {
691         return EternalStorage(storageAddress).getUint(keccak256("referee.count"));
692     }
693 
694     function setRefereeCount(address storageAddress, uint value) public {
695         EternalStorage(storageAddress).setUint(keccak256("referee.count"), value);
696     }
697 
698     function setReferee(address storageAddress, address referee, uint id, bool applied) public {
699         EternalStorage st = EternalStorage(storageAddress);
700         st.setBool(keccak256("referee.applied", referee), applied);
701         st.setAddress(keccak256("referee.address", id), referee);
702     }
703 
704     function isRefereeApplied(address storageAddress, address referee) public view returns(bool) {
705         return EternalStorage(storageAddress).getBool(keccak256("referee.applied", referee));
706     }
707 
708     function setRefereeApplied(address storageAddress, address referee, bool applied) public {
709         EternalStorage(storageAddress).setBool(keccak256("referee.applied", referee), applied);
710     }
711 
712     function getRefereeAddress(address storageAddress, uint id) public view returns(address) {
713         return EternalStorage(storageAddress).getAddress(keccak256("referee.address", id));
714     }
715     
716     function getRandomRefereesToCase(address storageAddress, address applicant, address respondent, uint256 targetCount) 
717     public view returns(address[] foundReferees)  {
718         uint refereesCount = getRefereeCount(storageAddress);
719         require(refereesCount >= targetCount);
720         foundReferees = new address[](targetCount);
721         uint id = Utils.almostRnd(0, refereesCount);
722         uint found = 0;
723         for (uint i = 0; i < refereesCount; i++) {
724             address referee = getRefereeAddress(storageAddress, id);
725             id = id + 1;
726             id = id % refereesCount;
727             uint voteBalance = VoteTokenLib.getVotes(storageAddress, referee);
728             if (referee != applicant && referee != respondent && voteBalance > 0) {
729                 foundReferees[found] = referee;
730                 found++;
731             }
732             if (found == targetCount) {
733                 break;
734             }
735         }
736         require(found == targetCount);
737     }
738 }
739 contract BkxToken is EIP20 {
740     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
741     function decreaseApproval (address _spender, uint _subtractedValue)public returns (bool success);
742 }
743 
744 contract IBoard is Ownable {
745 
746     event CaseOpened(bytes32 caseId, address applicant, address respondent, bytes32 deal, uint amount, uint refereeAward, bytes32 title, string applicantDescription, uint[] dates, uint refereeCountNeed, bool isEthRefereeAward);
747     event CaseCommentedByRespondent(bytes32 caseId, address respondent, string comment);
748     event CaseVoting(bytes32 caseId);
749     event CaseVoteCommitted(bytes32 caseId, address referee, bytes32 voteHash);
750     event CaseRevealingVotes(bytes32 caseId);
751     event CaseVoteRevealed(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt);
752     event CaseClosed(bytes32 caseId, bool won);
753     event CaseCanceled(bytes32 caseId, uint8 causeCode);
754 
755     event RefereesAssignedToCase(bytes32 caseId, address[] referees);
756     event RefereeVoteBalanceChanged(address referee, uint balance);
757     event RefereeAwarded(address referee, bytes32 caseId, uint award);
758 
759     address public lib;
760     uint public version;
761     IBoardConfig public config;
762     BkxToken public bkxToken;
763     address public admin;
764     address public paymentHolder;
765 
766     modifier onlyOwnerOrAdmin() {
767         require(msg.sender == admin || msg.sender == owner);
768         _;
769     }
770 
771     function withdrawEth(uint value) external;
772 
773     function withdrawBkx(uint value) external;
774 
775     function setStorageAddress(address storageAddress) external;
776 
777     function setConfigAddress(address configAddress) external;
778 
779     function setBkxToken(address tokenAddress) external;
780 
781     function setPaymentHolder(address paymentHolder) external;
782 
783     function setAdmin(address admin) external;
784 
785     function applyForReferee() external payable;
786 
787     function addVoteTokens(address referee) external;
788 
789     function openCase(address respondent, bytes32 deal, uint amount, uint refereeAward, bytes32 title, string description) external payable;
790 
791     function setRespondentDescription(bytes32 caseId, string description) external;
792 
793     function startVotingCase(bytes32 caseId) external;
794 
795     function createVoteHash(uint8 voteOption, bytes32 salt) public view returns(bytes32);
796 
797     function commitVote(bytes32 caseId, bytes32 voteHash) external;
798 
799     function verifyVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt) public view returns(bool);
800 
801     function startRevealingVotes(bytes32 caseId) external;
802 
803     function revealVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt) external;
804 
805     function revealVotes(bytes32 caseId, address[] referees, uint8[] voteOptions, bytes32[] salts) external;
806 
807     function verdict(bytes32 caseId) external;
808 }
809 
810 
811 contract Board is IBoard {
812 
813     using SafeMath for uint;
814     using VoteTokenLib for address;
815     using CasesLib for address;
816     using RefereesLib for address;
817     using RefereeCasesLib for address;
818 
819     modifier onlyRespondent(bytes32 caseId) {
820         require(msg.sender == lib.getRespondent(caseId));
821         _;
822     }
823 
824     modifier hasStatus(bytes32 caseId, CasesLib.CaseStatus state) {
825         require(state == lib.getCaseStatus(caseId));
826         _;
827     }
828 
829     modifier before(uint date) {
830         require(now <= date);
831         _;
832     }
833 
834     modifier laterOn(uint date) {
835         require(now >= date);
836         _;
837     }
838 
839     function Board(address storageAddress, address configAddress, address _paymentHolder) public {
840         version = 2;
841         config = IBoardConfig(configAddress);
842         lib = storageAddress;
843         //check real BKX address https://etherscan.io/token/0x45245bc59219eeaAF6cD3f382e078A461FF9De7B
844         bkxToken = BkxToken(0x45245bc59219eeaAF6cD3f382e078A461FF9De7B);
845         admin = 0xE0b6C095D722961C2C11E55b97fCd0C8bd7a1cD2;
846         paymentHolder = _paymentHolder;
847     }
848 
849     function withdrawEth(uint value) external onlyOwner {
850         require(address(this).balance >= value);
851         msg.sender.transfer(value);
852     }
853 
854     function withdrawBkx(uint value) external onlyOwner {
855         require(bkxToken.balanceOf(address(this)) >= value);
856         require(bkxToken.transfer(msg.sender, value));
857     }
858 
859     /* configuration */
860     function setStorageAddress(address storageAddress) external onlyOwner {
861         lib = storageAddress;
862     }
863 
864     function setConfigAddress(address configAddress) external onlyOwner {
865         config = IBoardConfig(configAddress);
866     }
867 
868     /* dependency tokens */
869     function setBkxToken(address tokenAddress) external onlyOwner {
870         bkxToken = BkxToken(tokenAddress);
871     }
872 
873     function setPaymentHolder(address _paymentHolder) external onlyOwner {
874         paymentHolder = _paymentHolder;
875     }
876 
877     function setAdmin(address newAdmin) external onlyOwner {
878         admin = newAdmin;
879     }
880 
881     function applyForReferee() external payable {
882         uint refereeFee = msg.value == 0 ? config.getRefereeFee() : config.getRefereeFeeEth();
883         withdrawPayment(refereeFee);
884         addVotes(msg.sender);
885     }
886 
887     function addVoteTokens(address referee) external onlyOwnerOrAdmin {
888         addVotes(referee);
889     }
890 
891     function addVotes(address referee) private {
892         uint refereeTokens = config.getVoteTokensPerRequest();
893         if (!lib.isRefereeApplied(referee)) {
894             lib.addReferee(referee);
895         }
896         uint balance = refereeTokens.add(lib.getVotes(referee));
897         lib.setVotes(referee, balance);
898         emit RefereeVoteBalanceChanged(referee, balance);
899     }
900 
901     function openCase(address respondent, bytes32 deal, uint amount, uint refereeAward, bytes32 title, string description)
902     external payable {
903         require(msg.sender != respondent);
904         withdrawPayment(refereeAward);
905         uint[] memory dates = config.getCaseDatesFromNow();
906         uint refereeCountNeed = config.getRefereeNeedCountPerCase();
907         bytes32 caseId = lib.addCase(msg.sender, respondent, deal, amount, refereeAward, title, description, dates, refereeCountNeed, msg.value != 0);
908         emit CaseOpened(caseId, msg.sender, respondent, deal, amount, refereeAward, title, description, dates, refereeCountNeed, msg.value != 0);
909         assignRefereesToCase(caseId, msg.sender, respondent);
910     }
911 
912     function withdrawPayment(uint256 amount) private {
913         if(msg.value != 0) {
914             require(msg.value == amount, "ETH amount must be equal amount");
915             require(PaymentHolder(paymentHolder).depositEth.value(msg.value)());
916         } else {
917             require(bkxToken.allowance(msg.sender, address(this)) >= amount);
918             require(bkxToken.balanceOf(msg.sender) >= amount);
919             require(bkxToken.transferFrom(msg.sender, paymentHolder, amount));
920         }
921     }
922 
923     function assignRefereesToCase(bytes32 caseId, address applicant, address respondent) private  {
924         uint targetCount = config.getRefereeCountPerCase();
925         address[] memory foundReferees = lib.getRandomRefereesToCase(applicant, respondent, targetCount);
926         for (uint i = 0; i < foundReferees.length; i++) {
927             address referee = foundReferees[i];
928             uint voteBalance = lib.getVotes(referee);
929             voteBalance -= 1;
930             lib.setVotes(referee, voteBalance);
931             emit RefereeVoteBalanceChanged(referee, voteBalance);
932         }
933         lib.setRefereesToCase(foundReferees, caseId);
934         emit RefereesAssignedToCase(caseId, foundReferees);
935     }
936 
937     function setRespondentDescription(bytes32 caseId, string description)
938     external onlyRespondent(caseId) hasStatus(caseId, CasesLib.CaseStatus.OPENED) before(lib.getVotingDate(caseId)) {
939         require(lib.getRespondentDescription(caseId) == 0);
940         lib.setRespondentDescription(caseId, description);
941         lib.setCaseStatus(caseId, CasesLib.CaseStatus.VOTING);
942         emit CaseCommentedByRespondent(caseId, msg.sender, description);
943         emit CaseVoting(caseId);
944     }
945 
946     function startVotingCase(bytes32 caseId)
947     external hasStatus(caseId, CasesLib.CaseStatus.OPENED) laterOn(lib.getVotingDate(caseId)) {
948         lib.setCaseStatus(caseId, CasesLib.CaseStatus.VOTING);
949         emit CaseVoting(caseId);
950     }
951 
952     function commitVote(bytes32 caseId, bytes32 voteHash)
953     external hasStatus(caseId, CasesLib.CaseStatus.VOTING) before(lib.getRevealingDate(caseId))
954     {
955         require(lib.isRefereeSetToCase(msg.sender, caseId)); //referee must be set to case
956         require(!lib.isRefereeVoted(msg.sender, caseId)); //referee can not vote twice
957         lib.setRefereeVoteHash(caseId, msg.sender, voteHash);
958         emit CaseVoteCommitted(caseId, msg.sender, voteHash);
959         if (lib.getRefereeVoteHashCount(caseId) == lib.getRefereeCountByCase(caseId)) {
960             lib.setCaseStatus(caseId, CasesLib.CaseStatus.REVEALING);
961             emit CaseRevealingVotes(caseId);
962         }
963     }
964 
965     function startRevealingVotes(bytes32 caseId)
966     external hasStatus(caseId, CasesLib.CaseStatus.VOTING) laterOn(lib.getRevealingDate(caseId))
967     {
968         lib.setCaseStatus(caseId, CasesLib.CaseStatus.REVEALING);
969         emit CaseRevealingVotes(caseId);
970     }
971 
972     function revealVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt)
973     external hasStatus(caseId, CasesLib.CaseStatus.REVEALING) before(lib.getCloseDate(caseId))
974     {
975         doRevealVote(caseId, referee, voteOption, salt);
976         checkShouldMakeVerdict(caseId);
977     }
978 
979     function revealVotes(bytes32 caseId, address[] referees, uint8[] voteOptions, bytes32[] salts)
980     external hasStatus(caseId, CasesLib.CaseStatus.REVEALING) before(lib.getCloseDate(caseId))
981     {
982         require((referees.length == voteOptions.length) && (referees.length == salts.length));
983         for (uint i = 0; i < referees.length; i++) {
984             doRevealVote(caseId, referees[i], voteOptions[i], salts[i]);
985         }
986         checkShouldMakeVerdict(caseId);
987     }
988 
989     function checkShouldMakeVerdict(bytes32 caseId)
990     private {
991         if (lib.getRefereeVotesFor(caseId, true) + lib.getRefereeVotesFor(caseId, false) == lib.getRefereeVoteHashCount(caseId)) {
992             makeVerdict(caseId);
993         }
994     }
995 
996     function doRevealVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt) private {
997         require(verifyVote(caseId, referee, voteOption, salt));
998         lib.setRefereeVote(caseId, referee,  voteOption == 0);
999         emit CaseVoteRevealed(caseId, referee, voteOption, salt);
1000     }
1001 
1002     function createVoteHash(uint8 voteOption, bytes32 salt)
1003     public view returns(bytes32) {
1004         return keccak256(voteOption, salt);
1005     }
1006 
1007     function verifyVote(bytes32 caseId, address referee, uint8 voteOption, bytes32 salt)
1008     public view returns(bool){
1009         return lib.getRefereeVoteHash(caseId, referee) == keccak256(voteOption, salt);
1010     }
1011 
1012     function verdict(bytes32 caseId)
1013     external hasStatus(caseId, CasesLib.CaseStatus.REVEALING) laterOn(lib.getCloseDate(caseId)) {
1014         makeVerdict(caseId);
1015     }
1016 
1017     function makeVerdict(bytes32 caseId)
1018     private {
1019         uint forApplicant = lib.getRefereeVotesFor(caseId, true);
1020         uint forRespondent = lib.getRefereeVotesFor(caseId, false);
1021         uint refereeAward = lib.getRefereeAward(caseId);
1022         bool isNotEnoughVotes = (forApplicant + forRespondent) < lib.getRefereeCountNeed(caseId);
1023         bool isEthRefereeAward = lib.isEthRefereeAward(caseId);
1024         if (isNotEnoughVotes || (forApplicant == forRespondent)) {
1025             withdrawTo(isEthRefereeAward, lib.getApplicant(caseId), refereeAward);
1026             lib.setCaseStatus(caseId, CasesLib.CaseStatus.CANCELED);
1027             CasesLib.CaseCanceledCode causeCode = isNotEnoughVotes ?
1028                 CasesLib.CaseCanceledCode.NOT_ENOUGH_VOTES : CasesLib.CaseCanceledCode.EQUAL_NUMBER_OF_VOTES;
1029             lib.setCaseCanceledCode(caseId, causeCode);
1030             emit CaseCanceled(caseId, uint8(causeCode));
1031             withdrawAllRefereeVotes(caseId);
1032             return;
1033         }
1034         bool won = false;
1035         uint awardPerReferee;
1036         if (forApplicant > forRespondent) {
1037             won = true;
1038             awardPerReferee = refereeAward / forApplicant;
1039         } else {
1040             awardPerReferee = refereeAward / forRespondent;
1041         }
1042         lib.setCaseStatus(caseId, CasesLib.CaseStatus.CLOSED);
1043         lib.setCaseWon(caseId, won);
1044         emit CaseClosed(caseId, won);
1045         address[] memory wonReferees = lib.getRefereesFor(caseId, won);
1046         for (uint i = 0; i < wonReferees.length; i++) {
1047             withdrawTo(isEthRefereeAward, wonReferees[i], awardPerReferee);
1048             emit RefereeAwarded(wonReferees[i], caseId, awardPerReferee);
1049         }
1050         withdrawRefereeVotes(caseId);
1051     }
1052 
1053     function withdrawTo(bool isEth, address to, uint amount) private {
1054         if (isEth) {
1055             require(PaymentHolder(paymentHolder).withdrawEth(to, amount));
1056         } else {
1057             require(PaymentHolder(paymentHolder).withdrawToken(to, amount, address(bkxToken)));
1058         }
1059     } 
1060 
1061     function withdrawAllRefereeVotes(bytes32 caseId) private {
1062         address[] memory referees = lib.getRefereesByCase(caseId);
1063         for (uint i = 0; i < referees.length; i++) {
1064             withdrawRefereeVote(referees[i]);
1065         }
1066     }
1067 
1068     function withdrawRefereeVotes(bytes32 caseId)
1069     private {
1070         address[] memory referees = lib.getRefereesByCase(caseId);
1071         for (uint i = 0; i < referees.length; i++) {
1072             if (!lib.isRefereeVoted(referees[i], caseId)) {
1073                 withdrawRefereeVote(referees[i]);
1074             }
1075         }
1076     }
1077 
1078     function withdrawRefereeVote(address referee)
1079     private {
1080         uint voteBalance = lib.getVotes(referee);
1081         voteBalance += 1;
1082         lib.setVotes(referee, voteBalance);
1083         emit RefereeVoteBalanceChanged(referee, voteBalance);
1084     }
1085 }