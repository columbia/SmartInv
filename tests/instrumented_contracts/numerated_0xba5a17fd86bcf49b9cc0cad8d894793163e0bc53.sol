1 pragma solidity ^0.4.19;
2 
3 contract Engine {
4     uint256 public VERSION;
5     string public VERSION_NAME;
6 
7     enum Status { initial, lent, paid, destroyed }
8     struct Approbation {
9         bool approved;
10         bytes data;
11         bytes32 checksum;
12     }
13 
14     function getTotalLoans() public view returns (uint256);
15     function getOracle(uint index) public view returns (Oracle);
16     function getBorrower(uint index) public view returns (address);
17     function getCosigner(uint index) public view returns (address);
18     function ownerOf(uint256) public view returns (address owner);
19     function getCreator(uint index) public view returns (address);
20     function getAmount(uint index) public view returns (uint256);
21     function getPaid(uint index) public view returns (uint256);
22     function getDueTime(uint index) public view returns (uint256);
23     function getApprobation(uint index, address _address) public view returns (bool);
24     function getStatus(uint index) public view returns (Status);
25     function isApproved(uint index) public view returns (bool);
26     function getPendingAmount(uint index) public returns (uint256);
27     function getCurrency(uint index) public view returns (bytes32);
28     function cosign(uint index, uint256 cost) external returns (bool);
29     function approveLoan(uint index) public returns (bool);
30     function transfer(address to, uint256 index) public returns (bool);
31     function takeOwnership(uint256 index) public returns (bool);
32     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
33 }
34 
35 /**
36     @dev Defines the interface of a standard RCN cosigner.
37 
38     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
39     of the insurance and the cost of the given are defined by the cosigner. 
40 
41     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
42     agent should be passed as params when the lender calls the "lend" method on the engine.
43     
44     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
45     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
46     call this method, like the transfer of the ownership of the loan.
47 */
48 contract Cosigner {
49     uint256 public constant VERSION = 2;
50     
51     /**
52         @return the url of the endpoint that exposes the insurance offers.
53     */
54     function url() public view returns (string);
55     
56     /**
57         @dev Retrieves the cost of a given insurance, this amount should be exact.
58 
59         @return the cost of the cosign, in RCN wei
60     */
61     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
62     
63     /**
64         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
65         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
66         does not return true to this method, the operation fails.
67 
68         @return true if the cosigner accepts the liability
69     */
70     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
71     
72     /**
73         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
74         current lender of the loan.
75 
76         @return true if the claim was done correctly.
77     */
78     function claim(address engine, uint256 index, bytes oracleData) public returns (bool);
79 }
80 
81 contract ERC721 {
82    // ERC20 compatible functions
83    function name() public view returns (string _name);
84    function symbol() public view returns (string _symbol);
85    function totalSupply() public view returns (uint256 _totalSupply);
86    function balanceOf(address _owner) public view returns (uint _balance);
87    // Functions that define ownership
88    function ownerOf(uint256) public view returns (address owner);
89    function approve(address, uint256) public returns (bool);
90    function takeOwnership(uint256) public returns (bool);
91    function transfer(address, uint256) public returns (bool);
92    function setApprovalForAll(address _operator, bool _approved) public returns (bool);
93    function getApproved(uint256 _tokenId) public view returns (address);
94    function isApprovedForAll(address _owner, address _operator) public view returns (bool);
95    // Token metadata
96    function tokenMetadata(uint256 _tokenId) public view returns (string info);
97    // Events
98    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
99    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
100    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
101 }
102 
103 contract Token {
104     function transfer(address _to, uint _value) public returns (bool success);
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
107     function approve(address _spender, uint256 _value) public returns (bool success);
108     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
109     function balanceOf(address _owner) public view returns (uint256 balance);
110 }
111 
112 contract Ownable {
113     address public owner;
114 
115     modifier onlyOwner() {
116         require(msg.sender == owner);
117         _;
118     }
119 
120     function Ownable() public {
121         owner = msg.sender; 
122     }
123 
124     /**
125         @dev Transfers the ownership of the contract.
126 
127         @param _to Address of the new owner
128     */
129     function transferTo(address _to) public onlyOwner returns (bool) {
130         require(_to != address(0));
131         owner = _to;
132         return true;
133     } 
134 } 
135 
136 /**
137     @dev Defines the interface of a standard RCN oracle.
138 
139     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
140     it's primarily used by the exchange but could be used by any other agent.
141 */
142 contract Oracle is Ownable {
143     uint256 public constant VERSION = 3;
144 
145     event NewSymbol(bytes32 _currency, string _ticker);
146     
147     struct Symbol {
148         string ticker;
149         bool supported;
150     }
151 
152     mapping(bytes32 => Symbol) public currencies;
153 
154     /**
155         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
156     */
157     function url() public view returns (string);
158 
159     /**
160         @dev Returns a valid convertion rate from the currency given to RCN
161 
162         @param symbol Symbol of the currency
163         @param data Generic data field, could be used for off-chain signing
164     */
165     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
166 
167     /**
168         @dev Adds a currency to the oracle, once added it cannot be removed
169 
170         @param ticker Symbol of the currency
171 
172         @return the hash of the currency, calculated keccak256(ticker)
173     */
174     function addCurrency(string ticker) public onlyOwner returns (bytes32) {
175         NewSymbol(currency, ticker);
176         bytes32 currency = keccak256(ticker);
177         currencies[currency] = Symbol(ticker, true);
178         return currency;
179     }
180 
181     /**
182         @return true If the currency is supported
183     */
184     function supported(bytes32 symbol) public view returns (bool) {
185         return currencies[symbol].supported;
186     }
187 }
188 
189 contract RpSafeMath {
190     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
191       uint256 z = x + y;
192       require((z >= x) && (z >= y));
193       return z;
194     }
195 
196     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
197       require(x >= y);
198       uint256 z = x - y;
199       return z;
200     }
201 
202     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
203       uint256 z = x * y;
204       require((x == 0)||(z/x == y));
205       return z;
206     }
207 
208     function min(uint256 a, uint256 b) internal pure returns(uint256) {
209         if (a < b) { 
210           return a;
211         } else { 
212           return b; 
213         }
214     }
215     
216     function max(uint256 a, uint256 b) internal pure returns(uint256) {
217         if (a > b) { 
218           return a;
219         } else { 
220           return b; 
221         }
222     }
223 }
224 
225 contract TokenLockable is RpSafeMath, Ownable {
226     mapping(address => uint256) public lockedTokens;
227 
228     /**
229         @dev Locked tokens cannot be withdrawn using the withdrawTokens function.
230     */
231     function lockTokens(address token, uint256 amount) internal {
232         lockedTokens[token] = safeAdd(lockedTokens[token], amount);
233     }
234 
235     /**
236         @dev Unlocks previusly locked tokens.
237     */
238     function unlockTokens(address token, uint256 amount) internal {
239         lockedTokens[token] = safeSubtract(lockedTokens[token], amount);
240     }
241 
242     /**
243         @dev Withdraws tokens from the contract.
244 
245         @param token Token to withdraw
246         @param to Destination of the tokens
247         @param amount Amount to withdraw 
248     */
249     function withdrawTokens(Token token, address to, uint256 amount) public onlyOwner returns (bool) {
250         require(safeSubtract(token.balanceOf(this), lockedTokens[token]) >= amount);
251         require(to != address(0));
252         return token.transfer(to, amount);
253     }
254 }
255 
256 contract NanoLoanEngine is ERC721, Engine, Ownable, TokenLockable {
257     uint256 constant internal PRECISION = (10**18);
258     uint256 constant internal RCN_DECIMALS = 18;
259 
260     uint256 public constant VERSION = 212;
261     string public constant VERSION_NAME = "Basalt";
262 
263     uint256 private activeLoans = 0;
264     mapping(address => uint256) private lendersBalance;
265 
266     function name() public view returns (string _name) {
267         _name = "RCN - Nano loan engine - Basalt 212";
268     }
269 
270     function symbol() public view returns (string _symbol) {
271         _symbol = "RCN-NLE-212";
272     }
273 
274     /**
275         @notice Returns the number of active loans in total, active loans are the loans with "lent" status.
276         @dev Required for ERC-721 compliance
277 
278         @return _totalSupply Total amount of loans
279     */
280     function totalSupply() public view returns (uint _totalSupply) {
281         _totalSupply = activeLoans;
282     }
283 
284     /**
285         @notice Returns the number of active loans that a lender possess; active loans are the loans with "lent" status.
286         @dev Required for ERC-721 compliance
287 
288         @param _owner The owner address to search
289         
290         @return _balance Amount of loans  
291     */
292     function balanceOf(address _owner) public view returns (uint _balance) {
293         _balance = lendersBalance[_owner];
294     }
295 
296     /**
297         @notice Maps the indices of lenders loans to tokens ids
298         @dev Required for ERC-721 compliance, This method MUST NEVER be called by smart contract code.
299             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
300 
301         @param _owner The owner address
302         @param _index Loan index for the owner
303 
304         @return tokenId Real token id
305     */
306     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint tokenId) {
307         uint256 tokenCount = balanceOf(_owner);
308 
309         if (tokenCount == 0 || _index >= tokenCount) {
310             // Fail transaction
311             revert();
312         } else {
313             uint256 totalLoans = totalSupply();
314             uint256 resultIndex = 0;
315 
316             uint256 loanId;
317 
318             for (loanId = 0; loanId <= totalLoans; loanId++) {
319                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
320                     if (resultIndex == _index) {
321                         return loanId;
322                     }
323                     resultIndex++;
324                 }
325             }
326 
327             revert();
328         }
329     }
330 
331     /**
332         @notice Returns all the loans that a lender possess
333         @dev This method MUST NEVER be called by smart contract code; 
334             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
335 
336         @param _owner The owner address
337 
338         @return ownerTokens List of all the loans of the _owner
339     */
340     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
341         uint256 tokenCount = balanceOf(_owner);
342 
343         if (tokenCount == 0) {
344             // Return an empty array
345             return new uint256[](0);
346         } else {
347             uint256[] memory result = new uint256[](tokenCount);
348             uint256 totalLoans = totalSupply();
349             uint256 resultIndex = 0;
350 
351             uint256 loanId;
352 
353             for (loanId = 0; loanId <= totalLoans; loanId++) {
354                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
355                     result[resultIndex] = loanId;
356                     resultIndex++;
357                 }
358             }
359 
360             return result;
361         }
362     }
363 
364     /**
365         @notice Returns true if the _operator can transfer the loans of the _owner
366 
367         @dev Required for ERC-721 compliance 
368     */
369     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
370         return operators[_owner][_operator];
371     }
372 
373     /**
374         @notice Returns the loan metadata, this field can be set by the creator of the loan with his own criteria.
375 
376         @param index Index of the loan
377 
378         @return The string with the metadata
379     */
380     function tokenMetadata(uint256 index) public view returns (string) {
381         return loans[index].metadata;
382     }
383 
384     /**
385         @notice Returns the loan metadata, hashed with keccak256.
386         @dev This emthod is useful to evaluate metadata from a smart contract.
387 
388         @param index Index of the loan
389 
390         @return The metadata hashed with keccak256
391     */
392     function tokenMetadataHash(uint256 index) public view returns (bytes32) {
393         return keccak256(loans[index].metadata);
394     }
395 
396     Token public rcn;
397     bool public deprecated;
398 
399     event CreatedLoan(uint _index, address _borrower, address _creator);
400     event ApprovedBy(uint _index, address _address);
401     event Lent(uint _index, address _lender, address _cosigner);
402     event DestroyedBy(uint _index, address _address);
403     event PartialPayment(uint _index, address _sender, address _from, uint256 _amount);
404     event TotalPayment(uint _index);
405 
406     function NanoLoanEngine(Token _rcn) public {
407         owner = msg.sender;
408         rcn = _rcn;
409     }
410 
411     struct Loan {
412         Status status;
413         Oracle oracle;
414 
415         address borrower;
416         address lender;
417         address creator;
418         address cosigner;
419         
420         uint256 amount;
421         uint256 interest;
422         uint256 punitoryInterest;
423         uint256 interestTimestamp;
424         uint256 paid;
425         uint256 interestRate;
426         uint256 interestRatePunitory;
427         uint256 dueTime;
428         uint256 duesIn;
429 
430         bytes32 currency;
431         uint256 cancelableAt;
432         uint256 lenderBalance;
433 
434         address approvedTransfer;
435         uint256 expirationRequest;
436 
437         string metadata;
438         mapping(address => bool) approbations;
439     }
440 
441     mapping(address => mapping(address => bool)) private operators;
442     Loan[] private loans;
443 
444     /**
445         @notice Creates a loan request, the loan can be generated with any borrower and conditions; if the borrower agrees
446         it must call the "approve" function. If the creator of the loan is the borrower the approve is done automatically.
447 
448         @dev The creator of the loan is the caller of this function; this is useful to track which wallet created the loan.
449 
450         @param _oracleContract Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
451         @param _borrower Address of the borrower
452         @param _currency The currency to use with the oracle, the currency code is generated with the following formula,
453             keccak256(ticker), is always stored as the minimum divisible amount. (Ej: ETH Wei, USD Cents)
454         @param _amount The requested amount; currency and unit are defined by the Oracle, if there is no Oracle present
455             the currency is RCN, and the unit is wei.
456         @param _interestRate The non-punitory interest rate by second, defined as a denominator of 10 000 000.
457         @param _interestRatePunitory The punitory interest rate by second, defined as a denominator of 10 000 000.
458             Ej: interestRate 11108571428571 = 28% Anual interest
459         @param _duesIn The time in seconds that the borrower has in order to pay the debt after the lender lends the money.
460         @param _cancelableAt Delta in seconds specifying how much interest should be added in advance, if the borrower pays 
461         entirely or partially the loan before this term, no extra interest will be deducted.
462         @param _expirationRequest Timestamp of when the loan request expires, if the loan is not filled before this date, 
463             the request is no longer valid.
464         @param _metadata String with loan metadata.
465     */
466     function createLoan(Oracle _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
467         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256) {
468 
469         require(!deprecated);
470         require(_cancelableAt <= _duesIn);
471         require(_oracleContract != address(0) || _currency == 0x0);
472         require(_borrower != address(0));
473         require(_amount != 0);
474         require(_interestRatePunitory != 0);
475         require(_interestRate != 0);
476         require(_expirationRequest > block.timestamp);
477 
478         var loan = Loan(Status.initial, _oracleContract, _borrower, 0x0, msg.sender, 0x0, _amount, 0, 0, 0, 0, _interestRate,
479             _interestRatePunitory, 0, _duesIn, _currency, _cancelableAt, 0, 0x0, _expirationRequest, _metadata);
480         uint index = loans.push(loan) - 1;
481         CreatedLoan(index, _borrower, msg.sender);
482 
483         if (msg.sender == _borrower) {
484             approveLoan(index);
485         }
486 
487         return index;
488     }
489     
490     function ownerOf(uint256 index) public view returns (address owner) { owner = loans[index].lender; }
491     function getTotalLoans() public view returns (uint256) { return loans.length; }
492     function getOracle(uint index) public view returns (Oracle) { return loans[index].oracle; }
493     function getBorrower(uint index) public view returns (address) { return loans[index].borrower; }
494     function getCosigner(uint index) public view returns (address) { return loans[index].cosigner; }
495     function getCreator(uint index) public view returns (address) { return loans[index].creator; }
496     function getAmount(uint index) public view returns (uint256) { return loans[index].amount; }
497     function getPunitoryInterest(uint index) public view returns (uint256) { return loans[index].punitoryInterest; }
498     function getInterestTimestamp(uint index) public view returns (uint256) { return loans[index].interestTimestamp; }
499     function getPaid(uint index) public view returns (uint256) { return loans[index].paid; }
500     function getInterestRate(uint index) public view returns (uint256) { return loans[index].interestRate; }
501     function getInterestRatePunitory(uint index) public view returns (uint256) { return loans[index].interestRatePunitory; }
502     function getDueTime(uint index) public view returns (uint256) { return loans[index].dueTime; }
503     function getDuesIn(uint index) public view returns (uint256) { return loans[index].duesIn; }
504     function getCancelableAt(uint index) public view returns (uint256) { return loans[index].cancelableAt; }
505     function getApprobation(uint index, address _address) public view returns (bool) { return loans[index].approbations[_address]; }
506     function getStatus(uint index) public view returns (Status) { return loans[index].status; }
507     function getLenderBalance(uint index) public view returns (uint256) { return loans[index].lenderBalance; }
508     function getApproved(uint index) public view returns (address) {return loans[index].approvedTransfer; }
509     function getCurrency(uint index) public view returns (bytes32) { return loans[index].currency; }
510     function getExpirationRequest(uint index) public view returns (uint256) { return loans[index].expirationRequest; }
511     function getInterest(uint index) public view returns (uint256) { return loans[index].interest; }
512 
513     /**
514         @notice Used to know if a loan is ready to lend
515 
516         @param index Index of the loan
517 
518         @return true if the loan has been approved by the borrower and cosigner.
519     */
520     function isApproved(uint index) public view returns (bool) {
521         Loan storage loan = loans[index];
522         return loan.approbations[loan.borrower];
523     }
524 
525     /**
526         @notice Called by the members of the loan to show that they agree with the terms of the loan; the borrower
527         must call this method before any lender could call the method "lend".
528             
529         @dev Any address can call this method to be added to the "approbations" mapping.
530 
531         @param index Index of the loan
532 
533         @return true if the approve was done successfully
534     */
535     function approveLoan(uint index) public returns(bool) {
536         Loan storage loan = loans[index];
537         require(loan.status == Status.initial);
538         loan.approbations[msg.sender] = true;
539         ApprovedBy(index, msg.sender);
540         return true;
541     }
542 
543     /**
544         @notice Performs the lend of the RCN equivalent to the requested amount, and transforms the msg.sender in the new lender.
545 
546         @dev The loan must be previously approved by the borrower; before calling this function, the lender candidate must 
547         call the "approve" function on the RCN Token, specifying an amount sufficient enough to pay the equivalent of
548         the requested amount, and the cosigner fee.
549         
550         @param index Index of the loan
551         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
552             by the url exposed in the url() method of the oracle.
553         @param cosigner Address of the cosigner, 0x0 for lending without cosigner.
554         @param cosignerData Data required by the cosigner to process the request.
555 
556         @return true if the lend was done successfully
557     */
558     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool) {
559         Loan storage loan = loans[index];
560 
561         require(loan.status == Status.initial);
562         require(isApproved(index));
563         require(block.timestamp <= loan.expirationRequest);
564 
565         loan.lender = msg.sender;
566         loan.dueTime = safeAdd(block.timestamp, loan.duesIn);
567         loan.interestTimestamp = block.timestamp;
568         loan.status = Status.lent;
569 
570         // ERC721, create new loan and transfer it to the lender
571         Transfer(0x0, loan.lender, index);
572         activeLoans += 1;
573         lendersBalance[loan.lender] += 1;
574         
575         if (loan.cancelableAt > 0)
576             internalAddInterest(loan, safeAdd(block.timestamp, loan.cancelableAt));
577 
578         // Transfer the money to the borrower before handling the cosigner
579         // so the cosigner could require a specific usage for that money.
580         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, loan.amount);
581         require(rcn.transferFrom(msg.sender, loan.borrower, transferValue));
582         
583         if (cosigner != address(0)) {
584             // The cosigner it's temporary set to the next address (cosigner + 2), it's expected that the cosigner will
585             // call the method "cosign" to accept the conditions; that method also sets the cosigner to the right
586             // address. If that does not happen, the transaction fails.
587             loan.cosigner = address(uint256(cosigner) + 2);
588             require(cosigner.requestCosign(this, index, cosignerData, oracleData));
589             require(loan.cosigner == address(cosigner));
590         }
591                 
592         Lent(index, loan.lender, cosigner);
593 
594         return true;
595     }
596 
597     /**
598         @notice The cosigner must call this method to accept the conditions of a loan, this method pays the cosigner his fee.
599         
600         @dev If the cosigner does not call this method the whole "lend" call fails.
601 
602         @param index Index of the loan
603         @param cost Fee set by the cosigner
604 
605         @return true If the cosign was successfull
606     */
607     function cosign(uint index, uint256 cost) external returns (bool) {
608         Loan storage loan = loans[index];
609         require(loan.status == Status.lent && (loan.dueTime - loan.duesIn) == block.timestamp);
610         require(loan.cosigner != address(0));
611         require(loan.cosigner == address(uint256(msg.sender) + 2));
612         loan.cosigner = msg.sender;
613         require(rcn.transferFrom(loan.lender, msg.sender, cost));
614         return true;
615     }
616 
617     /**
618         @notice Destroys a loan, the borrower could call this method if they performed an accidental or regretted 
619         "approve" of the loan, this method only works for them if the loan is in "pending" status.
620 
621         The lender can call this method at any moment, in case of a loan with status "lent" the lender is pardoning 
622         the debt. 
623 
624         @param index Index of the loan
625 
626         @return true if the destroy was done successfully
627     */
628     function destroy(uint index) public returns (bool) {
629         Loan storage loan = loans[index];
630         require(loan.status != Status.destroyed);
631         require(msg.sender == loan.lender || (msg.sender == loan.borrower && loan.status == Status.initial));
632         DestroyedBy(index, msg.sender);
633 
634         // ERC721, remove loan from circulation
635         if (loan.status != Status.initial) {
636             lendersBalance[loan.lender] -= 1;
637             activeLoans -= 1;
638             Transfer(loan.lender, 0x0, index);
639         }
640 
641         loan.status = Status.destroyed;
642         return true;
643     }
644 
645     /**
646         @notice Transfers a loan to a different lender, the caller must be the current lender or previously being
647         approved with the method "approveTransfer"; only loans with the Status.lent status can be transfered.
648 
649         @dev Required for ERC-721 compliance
650 
651         @param index Index of the loan
652         @param to New lender
653 
654         @return true if the transfer was done successfully
655     */
656     function transfer(address to, uint256 index) public returns (bool) {
657         Loan storage loan = loans[index];
658         
659         require(msg.sender == loan.lender || msg.sender == loan.approvedTransfer || operators[loan.lender][msg.sender]);
660         require(to != address(0));
661         loan.lender = to;
662         loan.approvedTransfer = address(0);
663 
664         // ERC721, transfer loan to another address
665         lendersBalance[msg.sender] -= 1;
666         lendersBalance[to] += 1;
667         Transfer(loan.lender, to, index);
668 
669         return true;
670     }
671 
672     /**
673         @notice Transfers the loan to the msg.sender, the msg.sender must be approved using the "approve" method.
674 
675         @dev Required for ERC-721 compliance
676 
677         @param _index Index of the loan
678 
679         @return true if the transfer was successfull
680     */
681     function takeOwnership(uint256 _index) public returns (bool) {
682         return transfer(msg.sender, _index);
683     }
684 
685     /**
686         @notice Transfers the loan to an address, only if the current owner is the "from" address
687 
688         @dev Required for ERC-721 compliance
689 
690         @param from Current owner of the loan
691         @param to New owner of the loan
692         @param index Index of the loan
693 
694         @return true if the transfer was successfull
695     */
696     function transferFrom(address from, address to, uint256 index) public returns (bool) {
697         require(loans[index].lender == from);
698         return transfer(to, index);
699     }
700 
701     /**
702         @notice Approves the transfer of a given loan in the name of the lender, the behavior of this function is similar to
703         "approve" in the ERC20 standard, but only one approved address is allowed at a time.
704 
705         The same method can be called passing 0x0 as parameter "to" to erase a previously approved address.
706 
707         @dev Required for ERC-721 compliance
708 
709         @param to Address allowed to transfer the loan or 0x0 to delete
710         @param index Index of the loan
711 
712         @return true if the approve was done successfully
713     */
714     function approve(address to, uint256 index) public returns (bool) {
715         Loan storage loan = loans[index];
716         require(msg.sender == loan.lender);
717         loan.approvedTransfer = to;
718         Approval(msg.sender, to, index);
719         return true;
720     }
721 
722     /**
723         @notice Enable or disable approval for a third party ("operator") to manage
724 
725         @param _approved True if the operator is approved, false to revoke approval
726         @param _operator Address to add to the set of authorized operators.
727     */
728     function setApprovalForAll(address _operator, bool _approved) public returns (bool) {
729         operators[msg.sender][_operator] = _approved;
730         ApprovalForAll(msg.sender, _operator, _approved);
731         return true;
732     }
733 
734     /**
735         @notice Returns the pending amount to complete de payment of the loan, keep in mind that this number increases 
736         every second.
737 
738         @dev This method also computes the interest and updates the loan
739 
740         @param index Index of the loan
741 
742         @return Aprox pending payment amount
743     */
744     function getPendingAmount(uint index) public returns (uint256) {
745         addInterest(index);
746         return getRawPendingAmount(index);
747     }
748 
749     /**
750         @notice Returns the pending amount up to the last time of the interest update. This is not the real pending amount
751 
752         @dev This method is exact only if "addInterest(loan)" was before and in the same block.
753 
754         @param index Index of the loan
755 
756         @return The past pending amount
757     */
758     function getRawPendingAmount(uint index) public view returns (uint256) {
759         Loan memory loan = loans[index];
760         return safeSubtract(safeAdd(safeAdd(loan.amount, loan.interest), loan.punitoryInterest), loan.paid);
761     }
762 
763     /**
764         @notice Calculates the interest of a given amount, interest rate and delta time.
765 
766         @param timeDelta Elapsed time
767         @param interestRate Interest rate expressed as the denominator of 10 000 000.
768         @param amount Amount to apply interest
769 
770         @return realDelta The real timeDelta applied
771         @return interest The interest gained in the realDelta time
772     */
773     function calculateInterest(uint256 timeDelta, uint256 interestRate, uint256 amount) internal pure returns (uint256 realDelta, uint256 interest) {
774         if (amount == 0) {
775             interest = 0;
776             realDelta = timeDelta;
777         } else {
778             interest = safeMult(safeMult(100000, amount), timeDelta) / interestRate;
779             realDelta = safeMult(interest, interestRate) / (amount * 100000);
780         }
781     }
782 
783     /**
784         @notice Computes loan interest
785 
786         Computes the punitory and non-punitory interest of a given loan and only applies the change.
787         
788         @param loan Loan to compute interest
789         @param timestamp Target absolute unix time to calculate interest.
790     */
791     function internalAddInterest(Loan storage loan, uint256 timestamp) internal {
792         if (timestamp > loan.interestTimestamp) {
793             uint256 newInterest = loan.interest;
794             uint256 newPunitoryInterest = loan.punitoryInterest;
795 
796             uint256 newTimestamp;
797             uint256 realDelta;
798             uint256 calculatedInterest;
799 
800             uint256 deltaTime;
801             uint256 pending;
802 
803             uint256 endNonPunitory = min(timestamp, loan.dueTime);
804             if (endNonPunitory > loan.interestTimestamp) {
805                 deltaTime = endNonPunitory - loan.interestTimestamp;
806 
807                 if (loan.paid < loan.amount) {
808                     pending = loan.amount - loan.paid;
809                 } else {
810                     pending = 0;
811                 }
812 
813                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRate, pending);
814                 newInterest = safeAdd(calculatedInterest, newInterest);
815                 newTimestamp = loan.interestTimestamp + realDelta;
816             }
817 
818             if (timestamp > loan.dueTime) {
819                 uint256 startPunitory = max(loan.dueTime, loan.interestTimestamp);
820                 deltaTime = timestamp - startPunitory;
821 
822                 uint256 debt = safeAdd(loan.amount, newInterest);
823                 pending = min(debt, safeSubtract(safeAdd(debt, newPunitoryInterest), loan.paid));
824 
825                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRatePunitory, pending);
826                 newPunitoryInterest = safeAdd(newPunitoryInterest, calculatedInterest);
827                 newTimestamp = startPunitory + realDelta;
828             }
829             
830             if (newInterest != loan.interest || newPunitoryInterest != loan.punitoryInterest) {
831                 loan.interestTimestamp = newTimestamp;
832                 loan.interest = newInterest;
833                 loan.punitoryInterest = newPunitoryInterest;
834             }
835         }
836     }
837 
838     /**
839         @notice Updates the loan accumulated interests up to the current Unix time.
840         
841         @param index Index of the loan
842     
843         @return true If the interest was updated
844     */
845     function addInterest(uint index) public returns (bool) {
846         Loan storage loan = loans[index];
847         require(loan.status == Status.lent);
848         internalAddInterest(loan, block.timestamp);
849     }
850     
851     /**
852         @notice Pay loan
853 
854         Does a payment of a given Loan, before performing the payment the accumulated
855         interest is computed and added to the total pending amount.
856 
857         Before calling this function, the msg.sender must call the "approve" function on the RCN Token, specifying an amount
858         sufficient enough to pay the equivalent of the desired payment and the oracle fee.
859 
860         If the paid pending amount equals zero, the loan changes status to "paid" and it is considered closed.
861 
862         @dev Because it is difficult or even impossible to know in advance how much RCN are going to be spent on the
863         transaction*, we recommend performing the "approve" using an amount 5% superior to the wallet estimated
864         spending. If the RCN spent results to be less, the extra tokens are never debited from the msg.sender.
865 
866         * The RCN rate can fluctuate on the same block, and it is impossible to know in advance the exact time of the
867         confirmation of the transaction. 
868 
869         @param index Index of the loan
870         @param _amount Amount to pay, specified in the loan currency; or in RCN if the loan has no oracle
871         @param _from The identity of the payer
872         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
873             by the url exposed in the url() method of the oracle.
874             
875         @return true if the payment was executed successfully
876     */
877     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool) {
878         Loan storage loan = loans[index];
879 
880         require(loan.status == Status.lent);
881         addInterest(index);
882         uint256 toPay = min(getPendingAmount(index), _amount);
883         PartialPayment(index, msg.sender, _from, toPay);
884 
885         loan.paid = safeAdd(loan.paid, toPay);
886 
887         if (getRawPendingAmount(index) == 0) {
888             TotalPayment(index);
889             loan.status = Status.paid;
890 
891             // ERC721, remove loan from circulation
892             lendersBalance[loan.lender] -= 1;
893             activeLoans -= 1;
894             Transfer(loan.lender, 0x0, index);
895         }
896 
897         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, toPay);
898         require(transferValue > 0 || toPay < _amount);
899 
900         lockTokens(rcn, transferValue);
901         require(rcn.transferFrom(msg.sender, this, transferValue));
902         loan.lenderBalance = safeAdd(transferValue, loan.lenderBalance);
903 
904         return true;
905     }
906 
907     /**
908         @notice Converts an amount to RCN using the loan oracle.
909         
910         @dev If the loan has no oracle the currency must be RCN so the rate is 1
911 
912         @return The result of the convertion
913     */
914     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public returns (uint256) {
915         if (oracle == address(0)) {
916             return amount;
917         } else {
918             uint256 rate;
919             uint256 decimals;
920             
921             (rate, decimals) = oracle.getRate(currency, data);
922 
923             require(decimals <= RCN_DECIMALS);
924             return (safeMult(safeMult(amount, rate), (10**(RCN_DECIMALS-decimals)))) / PRECISION;
925         }
926     }
927 
928     /**
929         @notice Withdraw lender funds
930 
931         When a loan is paid, the funds are not transferred automatically to the lender, the funds are stored on the
932         engine contract, and the lender must call this function specifying the amount desired to transfer and the 
933         destination.
934 
935         @dev This behavior is defined to allow the temporary transfer of the loan to a smart contract, without worrying that
936         the contract will receive tokens that are not traceable; and it allows the development of decentralized 
937         autonomous organizations.
938 
939         @param index Index of the loan
940         @param to Destination of the wiwthdraw funds
941         @param amount Amount to withdraw, in RCN
942 
943         @return true if the withdraw was executed successfully
944     */
945     function withdrawal(uint index, address to, uint256 amount) public returns (bool) {
946         Loan storage loan = loans[index];
947         require(msg.sender == loan.lender);
948         loan.lenderBalance = safeSubtract(loan.lenderBalance, amount);
949         require(rcn.transfer(to, amount));
950         unlockTokens(rcn, amount);
951         return true;
952     }
953 
954     /**
955         @notice Withdraw lender funds in batch, it walks by all the loans between the two index, and withdraws all
956         the funds stored on that loans.
957 
958         @dev This batch withdraw method can be expensive in gas, it must be used with care.
959 
960         @param fromIndex Start index of the search
961         @param toIndex End index of the search
962         @param to Destination of the tokens
963 
964         @return the total withdrawed 
965     */
966     function withdrawalRange(uint256 fromIndex, uint256 toIndex, address to) public returns (uint256) {
967         uint256 loanId;
968         uint256 totalWithdraw = 0;
969 
970         for (loanId = fromIndex; loanId <= toIndex; loanId++) {
971             Loan storage loan = loans[loanId];
972             if (loan.lender == msg.sender) {
973                 totalWithdraw += loan.lenderBalance;
974                 loan.lenderBalance = 0;
975             }
976         }
977 
978         require(rcn.transfer(to, totalWithdraw));
979         unlockTokens(rcn, totalWithdraw);
980         
981         return totalWithdraw;
982     }
983 
984     /**
985         @notice Withdraw lender funds in batch, it walks by all the loans passed to the function and withdraws all
986         the funds stored on that loans.
987 
988         @dev This batch withdraw method can be expensive in gas, it must be used with care.
989 
990         @param loanIds Array of the loans to withdraw
991         @param to Destination of the tokens
992 
993         @return the total withdrawed 
994     */
995     function withdrawalList(uint256[] memory loanIds, address to) public returns (uint256) {
996         uint256 inputId;
997         uint256 totalWithdraw = 0;
998 
999         for (inputId = 0; inputId < loanIds.length; inputId++) {
1000             Loan storage loan = loans[loanIds[inputId]];
1001             if (loan.lender == msg.sender) {
1002                 totalWithdraw += loan.lenderBalance;
1003                 loan.lenderBalance = 0;
1004             }
1005         }
1006 
1007         require(rcn.transfer(to, totalWithdraw));
1008         unlockTokens(rcn, totalWithdraw);
1009 
1010         return totalWithdraw;
1011     }
1012 
1013     /**
1014         @dev Deprecates the engine, locks the creation of new loans.
1015     */
1016     function setDeprecated(bool _deprecated) public onlyOwner {
1017         deprecated = _deprecated;
1018     }
1019 }