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
92    function getApproved(uint256 _tokenId) public view returns (address);
93    // Token metadata
94    function tokenMetadata(uint256 _tokenId) public view returns (string info);
95    // Events
96    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
97    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
98 }
99 
100 contract Token {
101     function transfer(address _to, uint _value) public returns (bool success);
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
103     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
104     function approve(address _spender, uint256 _value) public returns (bool success);
105     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
106     function balanceOf(address _owner) public view returns (uint256 balance);
107 }
108 
109 contract Ownable {
110     address public owner;
111 
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116 
117     function Ownable() public {
118         owner = msg.sender; 
119     }
120 
121     /**
122         @dev Transfers the ownership of the contract.
123 
124         @param _to Address of the new owner
125     */
126     function transferTo(address _to) public onlyOwner returns (bool) {
127         require(_to != address(0));
128         owner = _to;
129         return true;
130     } 
131 } 
132 
133 /**
134     @dev Defines the interface of a standard RCN oracle.
135 
136     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
137     it's primarily used by the exchange but could be used by any other agent.
138 */
139 contract Oracle is Ownable {
140     uint256 public constant VERSION = 3;
141 
142     event NewSymbol(bytes32 _currency, string _ticker);
143     
144     struct Symbol {
145         string ticker;
146         bool supported;
147     }
148 
149     mapping(bytes32 => Symbol) public currencies;
150 
151     /**
152         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
153     */
154     function url() public view returns (string);
155 
156     /**
157         @dev Returns a valid convertion rate from the currency given to RCN
158 
159         @param symbol Symbol of the currency
160         @param data Generic data field, could be used for off-chain signing
161     */
162     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
163 
164     /**
165         @dev Adds a currency to the oracle, once added it cannot be removed
166 
167         @param ticker Symbol of the currency
168 
169         @return the hash of the currency, calculated keccak256(ticker)
170     */
171     function addCurrency(string ticker) public onlyOwner returns (bytes32) {
172         NewSymbol(currency, ticker);
173         bytes32 currency = keccak256(ticker);
174         currencies[currency] = Symbol(ticker, true);
175         return currency;
176     }
177 
178     /**
179         @return true If the currency is supported
180     */
181     function supported(bytes32 symbol) public view returns (bool) {
182         return currencies[symbol].supported;
183     }
184 }
185 
186 contract RpSafeMath {
187     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
188       uint256 z = x + y;
189       require((z >= x) && (z >= y));
190       return z;
191     }
192 
193     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
194       require(x >= y);
195       uint256 z = x - y;
196       return z;
197     }
198 
199     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
200       uint256 z = x * y;
201       require((x == 0)||(z/x == y));
202       return z;
203     }
204 
205     function min(uint256 a, uint256 b) internal pure returns(uint256) {
206         if (a < b) { 
207           return a;
208         } else { 
209           return b; 
210         }
211     }
212     
213     function max(uint256 a, uint256 b) internal pure returns(uint256) {
214         if (a > b) { 
215           return a;
216         } else { 
217           return b; 
218         }
219     }
220 }
221 
222 contract TokenLockable is RpSafeMath, Ownable {
223     mapping(address => uint256) public lockedTokens;
224 
225     /**
226         @dev Locked tokens cannot be withdrawn using the withdrawTokens function.
227     */
228     function lockTokens(address token, uint256 amount) internal {
229         lockedTokens[token] = safeAdd(lockedTokens[token], amount);
230     }
231 
232     /**
233         @dev Unlocks previusly locked tokens.
234     */
235     function unlockTokens(address token, uint256 amount) internal {
236         lockedTokens[token] = safeSubtract(lockedTokens[token], amount);
237     }
238 
239     /**
240         @dev Withdraws tokens from the contract.
241 
242         @param token Token to withdraw
243         @param to Destination of the tokens
244         @param amount Amount to withdraw 
245     */
246     function withdrawTokens(Token token, address to, uint256 amount) public onlyOwner returns (bool) {
247         require(safeSubtract(token.balanceOf(this), lockedTokens[token]) >= amount);
248         require(to != address(0));
249         return token.transfer(to, amount);
250     }
251 }
252 
253 contract NanoLoanEngine is ERC721, Engine, Ownable, TokenLockable {
254     uint256 constant internal PRECISION = (10**18);
255     uint256 constant internal MAX_DECIMALS = 18;
256 
257     uint256 public constant VERSION = 210;
258     string public constant VERSION_NAME = "Basalt";
259 
260     uint256 private activeLoans = 0;
261     mapping(address => uint256) private lendersBalance;
262 
263     function name() public view returns (string _name) {
264         _name = "RCN - Nano loan engine - Basalt 210";
265     }
266 
267     function symbol() public view returns (string _symbol) {
268         _symbol = "RCN-NLE-210";
269     }
270 
271     /**
272         @notice Returns the number of active loans in total, active loans are the loans with "lent" status.
273         @dev Required for ERC-721 compliance
274 
275         @return _totalSupply Total amount of loans
276     */
277     function totalSupply() public view returns (uint _totalSupply) {
278         _totalSupply = activeLoans;
279     }
280 
281     /**
282         @notice Returns the number of active loans that a lender possess; active loans are the loans with "lent" status.
283         @dev Required for ERC-721 compliance
284 
285         @param _owner The owner address to search
286         
287         @return _balance Amount of loans  
288     */
289     function balanceOf(address _owner) public view returns (uint _balance) {
290         _balance = lendersBalance[_owner];
291     }
292 
293     /**
294         @notice Maps the indices of lenders loans to tokens ids
295         @dev Required for ERC-721 compliance, This method MUST NEVER be called by smart contract code.
296             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
297 
298         @param _owner The owner address
299         @param _index Loan index for the owner
300 
301         @return tokenId Real token id
302     */
303     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint tokenId) {
304         uint256 tokenCount = balanceOf(_owner);
305 
306         if (tokenCount == 0 || _index >= tokenCount) {
307             // Fail transaction
308             revert();
309         } else {
310             uint256 totalLoans = totalSupply();
311             uint256 resultIndex = 0;
312 
313             uint256 loanId;
314 
315             for (loanId = 0; loanId <= totalLoans; loanId++) {
316                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
317                     if (resultIndex == _index) {
318                         return loanId;
319                     }
320                     resultIndex++;
321                 }
322             }
323 
324             revert();
325         }
326     }
327 
328     /**
329         @notice Returns all the loans that a lender possess
330         @dev This method MUST NEVER be called by smart contract code; 
331             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
332 
333         @param _owner The owner address
334 
335         @return ownerTokens List of all the loans of the _owner
336     */
337     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
338         uint256 tokenCount = balanceOf(_owner);
339 
340         if (tokenCount == 0) {
341             // Return an empty array
342             return new uint256[](0);
343         } else {
344             uint256[] memory result = new uint256[](tokenCount);
345             uint256 totalLoans = totalSupply();
346             uint256 resultIndex = 0;
347 
348             uint256 loanId;
349 
350             for (loanId = 0; loanId <= totalLoans; loanId++) {
351                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
352                     result[resultIndex] = loanId;
353                     resultIndex++;
354                 }
355             }
356 
357             return result;
358         }
359     }
360 
361     /**
362         @notice Returns the loan metadata, this field can be set by the creator of the loan with his own criteria.
363 
364         @param index Index of the loan
365 
366         @return The string with the metadata
367     */
368     function tokenMetadata(uint256 index) public view returns (string) {
369         return loans[index].metadata;
370     }
371 
372     /**
373         @notice Returns the loan metadata, hashed with keccak256.
374         @dev This emthod is useful to evaluate metadata from a smart contract.
375 
376         @param index Index of the loan
377 
378         @return The metadata hashed with keccak256
379     */
380     function tokenMetadataHash(uint256 index) public view returns (bytes32) {
381         return keccak256(loans[index].metadata);
382     }
383 
384     Token public rcn;
385     bool public deprecated;
386 
387     event CreatedLoan(uint _index, address _borrower, address _creator);
388     event ApprovedBy(uint _index, address _address);
389     event Lent(uint _index, address _lender, address _cosigner);
390     event DestroyedBy(uint _index, address _address);
391     event PartialPayment(uint _index, address _sender, address _from, uint256 _amount);
392     event TotalPayment(uint _index);
393 
394     function NanoLoanEngine(Token _rcn) public {
395         owner = msg.sender;
396         rcn = _rcn;
397     }
398 
399     struct Loan {
400         Status status;
401         Oracle oracle;
402 
403         address borrower;
404         address lender;
405         address creator;
406         address cosigner;
407         
408         uint256 amount;
409         uint256 interest;
410         uint256 punitoryInterest;
411         uint256 interestTimestamp;
412         uint256 paid;
413         uint256 interestRate;
414         uint256 interestRatePunitory;
415         uint256 dueTime;
416         uint256 duesIn;
417 
418         bytes32 currency;
419         uint256 cancelableAt;
420         uint256 lenderBalance;
421 
422         address approvedTransfer;
423         uint256 expirationRequest;
424 
425         string metadata;
426         mapping(address => bool) approbations;
427     }
428 
429     Loan[] private loans;
430 
431     /**
432         @notice Creates a loan request, the loan can be generated with any borrower and conditions; if the borrower agrees
433         it must call the "approve" function. If the creator of the loan is the borrower the approve is done automatically.
434 
435         @dev The creator of the loan is the caller of this function; this is useful to track which wallet created the loan.
436 
437         @param _oracleContract Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
438         @param _borrower Address of the borrower
439         @param _currency The currency to use with the oracle, the currency code is generated with the following formula,
440             keccak256(ticker), is always stored as the minimum divisible amount. (Ej: ETH Wei, USD Cents)
441         @param _amount The requested amount; currency and unit are defined by the Oracle, if there is no Oracle present
442             the currency is RCN, and the unit is wei.
443         @param _interestRate The non-punitory interest rate by second, defined as a denominator of 10 000 000.
444         @param _interestRatePunitory The punitory interest rate by second, defined as a denominator of 10 000 000.
445             Ej: interestRate 11108571428571 = 28% Anual interest
446         @param _duesIn The time in seconds that the borrower has in order to pay the debt after the lender lends the money.
447         @param _cancelableAt Delta in seconds specifying how much interest should be added in advance, if the borrower pays 
448         entirely or partially the loan before this term, no extra interest will be deducted.
449         @param _expirationRequest Timestamp of when the loan request expires, if the loan is not filled before this date, 
450             the request is no longer valid.
451         @param _metadata String with loan metadata.
452     */
453     function createLoan(Oracle _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
454         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256) {
455 
456         require(!deprecated);
457         require(_cancelableAt <= _duesIn);
458         require(_oracleContract != address(0) || _currency == 0x0);
459         require(_borrower != address(0));
460         require(_amount != 0);
461         require(_interestRatePunitory != 0);
462         require(_interestRate != 0);
463         require(_expirationRequest > block.timestamp);
464 
465         var loan = Loan(Status.initial, _oracleContract, _borrower, 0x0, msg.sender, 0x0, _amount, 0, 0, 0, 0, _interestRate,
466             _interestRatePunitory, 0, _duesIn, _currency, _cancelableAt, 0, 0x0, _expirationRequest, _metadata);
467         uint index = loans.push(loan) - 1;
468         CreatedLoan(index, _borrower, msg.sender);
469 
470         if (msg.sender == _borrower) {
471             approveLoan(index);
472         }
473 
474         return index;
475     }
476     
477     function ownerOf(uint256 index) public view returns (address owner) { owner = loans[index].lender; }
478     function getTotalLoans() public view returns (uint256) { return loans.length; }
479     function getOracle(uint index) public view returns (Oracle) { return loans[index].oracle; }
480     function getBorrower(uint index) public view returns (address) { return loans[index].borrower; }
481     function getCosigner(uint index) public view returns (address) { return loans[index].cosigner; }
482     function getCreator(uint index) public view returns (address) { return loans[index].creator; }
483     function getAmount(uint index) public view returns (uint256) { return loans[index].amount; }
484     function getPunitoryInterest(uint index) public view returns (uint256) { return loans[index].punitoryInterest; }
485     function getInterestTimestamp(uint index) public view returns (uint256) { return loans[index].interestTimestamp; }
486     function getPaid(uint index) public view returns (uint256) { return loans[index].paid; }
487     function getInterestRate(uint index) public view returns (uint256) { return loans[index].interestRate; }
488     function getInterestRatePunitory(uint index) public view returns (uint256) { return loans[index].interestRatePunitory; }
489     function getDueTime(uint index) public view returns (uint256) { return loans[index].dueTime; }
490     function getDuesIn(uint index) public view returns (uint256) { return loans[index].duesIn; }
491     function getCancelableAt(uint index) public view returns (uint256) { return loans[index].cancelableAt; }
492     function getApprobation(uint index, address _address) public view returns (bool) { return loans[index].approbations[_address]; }
493     function getStatus(uint index) public view returns (Status) { return loans[index].status; }
494     function getLenderBalance(uint index) public view returns (uint256) { return loans[index].lenderBalance; }
495     function getApproved(uint index) public view returns (address) {return loans[index].approvedTransfer; }
496     function getCurrency(uint index) public view returns (bytes32) { return loans[index].currency; }
497     function getExpirationRequest(uint index) public view returns (uint256) { return loans[index].expirationRequest; }
498     function getInterest(uint index) public view returns (uint256) { return loans[index].interest; }
499 
500     /**
501         @notice Used to know if a loan is ready to lend
502 
503         @param index Index of the loan
504 
505         @return true if the loan has been approved by the borrower and cosigner.
506     */
507     function isApproved(uint index) public view returns (bool) {
508         Loan storage loan = loans[index];
509         return loan.approbations[loan.borrower];
510     }
511 
512     /**
513         @notice Called by the members of the loan to show that they agree with the terms of the loan; the borrower
514         must call this method before any lender could call the method "lend".
515             
516         @dev Any address can call this method to be added to the "approbations" mapping.
517 
518         @param index Index of the loan
519 
520         @return true if the approve was done successfully
521     */
522     function approveLoan(uint index) public returns(bool) {
523         Loan storage loan = loans[index];
524         require(loan.status == Status.initial);
525         loan.approbations[msg.sender] = true;
526         ApprovedBy(index, msg.sender);
527         return true;
528     }
529 
530     /**
531         @notice Performs the lend of the RCN equivalent to the requested amount, and transforms the msg.sender in the new lender.
532 
533         @dev The loan must be previously approved by the borrower; before calling this function, the lender candidate must 
534         call the "approve" function on the RCN Token, specifying an amount sufficient enough to pay the equivalent of
535         the requested amount, and the cosigner fee.
536         
537         @param index Index of the loan
538         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
539             by the url exposed in the url() method of the oracle.
540         @param cosigner Address of the cosigner, 0x0 for lending without cosigner.
541         @param cosignerData Data required by the cosigner to process the request.
542 
543         @return true if the lend was done successfully
544     */
545     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool) {
546         Loan storage loan = loans[index];
547 
548         require(loan.status == Status.initial);
549         require(isApproved(index));
550         require(block.timestamp <= loan.expirationRequest);
551 
552         loan.lender = msg.sender;
553         loan.dueTime = safeAdd(block.timestamp, loan.duesIn);
554         loan.interestTimestamp = block.timestamp;
555         loan.status = Status.lent;
556 
557         // ERC721, create new loan and transfer it to the lender
558         Transfer(0x0, loan.lender, index);
559         activeLoans += 1;
560         lendersBalance[loan.lender] += 1;
561         
562         if (loan.cancelableAt > 0)
563             internalAddInterest(loan, safeAdd(block.timestamp, loan.cancelableAt));
564 
565         // Transfer the money to the borrower before handling the cosigner
566         // so the cosigner could require a specific usage for that money.
567         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, loan.amount);
568         require(rcn.transferFrom(msg.sender, loan.borrower, transferValue));
569         
570         if (cosigner != address(0)) {
571             // The cosigner it's temporary set to the next address (cosigner + 2), it's expected that the cosigner will
572             // call the method "cosign" to accept the conditions; that method also sets the cosigner to the right
573             // address. If that does not happen, the transaction fails.
574             loan.cosigner = address(uint256(cosigner) + 2);
575             require(cosigner.requestCosign(this, index, cosignerData, oracleData));
576             require(loan.cosigner == address(cosigner));
577         }
578                 
579         Lent(index, loan.lender, cosigner);
580 
581         return true;
582     }
583 
584     /**
585         @notice The cosigner must call this method to accept the conditions of a loan, this method pays the cosigner his fee.
586         
587         @dev If the cosigner does not call this method the whole "lend" call fails.
588 
589         @param index Index of the loan
590         @param cost Fee set by the cosigner
591 
592         @return true If the cosign was successfull
593     */
594     function cosign(uint index, uint256 cost) external returns (bool) {
595         Loan storage loan = loans[index];
596         require(loan.status == Status.lent && (loan.dueTime - loan.duesIn) == block.timestamp);
597         require(loan.cosigner != address(0));
598         require(loan.cosigner == address(uint256(msg.sender) + 2));
599         loan.cosigner = msg.sender;
600         require(rcn.transferFrom(loan.lender, msg.sender, cost));
601         return true;
602     }
603 
604     /**
605         @notice Destroys a loan, the borrower could call this method if they performed an accidental or regretted 
606         "approve" of the loan, this method only works for them if the loan is in "pending" status.
607 
608         The lender can call this method at any moment, in case of a loan with status "lent" the lender is pardoning 
609         the debt. 
610 
611         @param index Index of the loan
612 
613         @return true if the destroy was done successfully
614     */
615     function destroy(uint index) public returns (bool) {
616         Loan storage loan = loans[index];
617         require(loan.status != Status.destroyed);
618         require(msg.sender == loan.lender || (msg.sender == loan.borrower && loan.status == Status.initial));
619         DestroyedBy(index, msg.sender);
620 
621         // ERC721, remove loan from circulation
622         if (loan.status != Status.initial) {
623             lendersBalance[loan.lender] -= 1;
624             activeLoans -= 1;
625             Transfer(loan.lender, 0x0, index);
626         }
627 
628         loan.status = Status.destroyed;
629         return true;
630     }
631 
632     /**
633         @notice Transfers a loan to a different lender, the caller must be the current lender or previously being
634         approved with the method "approveTransfer"; only loans with the Status.lent status can be transfered.
635 
636         @dev Required for ERC-721 compliance
637 
638         @param index Index of the loan
639         @param to New lender
640 
641         @return true if the transfer was done successfully
642     */
643     function transfer(address to, uint256 index) public returns (bool) {
644         Loan storage loan = loans[index];
645         
646         require(loan.status != Status.destroyed && loan.status != Status.paid);
647         require(msg.sender == loan.lender || msg.sender == loan.approvedTransfer);
648         require(to != address(0));
649         loan.lender = to;
650         loan.approvedTransfer = address(0);
651 
652         // ERC721, transfer loan to another address
653         lendersBalance[msg.sender] -= 1;
654         lendersBalance[to] += 1;
655         Transfer(loan.lender, to, index);
656 
657         return true;
658     }
659 
660     /**
661         @notice Transfers the loan to the msg.sender, the msg.sender must be approved using the "approve" method.
662 
663         @dev Required for ERC-721 compliance
664 
665         @param _index Index of the loan
666 
667         @return true if the transfer was successfull
668     */
669     function takeOwnership(uint256 _index) public returns (bool) {
670         return transfer(msg.sender, _index);
671     }
672 
673     /**
674         @notice Transfers the loan to an address, only if the current owner is the "from" address
675 
676         @dev Required for ERC-721 compliance
677 
678         @param from Current owner of the loan
679         @param to New owner of the loan
680         @param index Index of the loan
681 
682         @return true if the transfer was successfull
683     */
684     function transferFrom(address from, address to, uint256 index) public returns (bool) {
685         require(loans[index].lender == from);
686         return transfer(to, index);
687     }
688 
689     /**
690         @notice Approves the transfer of a given loan in the name of the lender, the behavior of this function is similar to
691         "approve" in the ERC20 standard, but only one approved address is allowed at a time.
692 
693         The same method can be called passing 0x0 as parameter "to" to erase a previously approved address.
694 
695         @dev Required for ERC-721 compliance
696 
697         @param to Address allowed to transfer the loan or 0x0 to delete
698         @param index Index of the loan
699 
700         @return true if the approve was done successfully
701     */
702     function approve(address to, uint256 index) public returns (bool) {
703         Loan storage loan = loans[index];
704         require(msg.sender == loan.lender);
705         loan.approvedTransfer = to;
706         Approval(msg.sender, to, index);
707         return true;
708     }
709 
710     /**
711         @notice Returns the pending amount to complete de payment of the loan, keep in mind that this number increases 
712         every second.
713 
714         @dev This method also computes the interest and updates the loan
715 
716         @param index Index of the loan
717 
718         @return Aprox pending payment amount
719     */
720     function getPendingAmount(uint index) public returns (uint256) {
721         addInterest(index);
722         return getRawPendingAmount(index);
723     }
724 
725     /**
726         @notice Returns the pending amount up to the last time of the interest update. This is not the real pending amount
727 
728         @dev This method is exact only if "addInterest(loan)" was before and in the same block.
729 
730         @param index Index of the loan
731 
732         @return The past pending amount
733     */
734     function getRawPendingAmount(uint index) public view returns (uint256) {
735         Loan memory loan = loans[index];
736         return safeSubtract(safeAdd(safeAdd(loan.amount, loan.interest), loan.punitoryInterest), loan.paid);
737     }
738 
739     /**
740         @notice Calculates the interest of a given amount, interest rate and delta time.
741 
742         @param timeDelta Elapsed time
743         @param interestRate Interest rate expressed as the denominator of 10 000 000.
744         @param amount Amount to apply interest
745 
746         @return realDelta The real timeDelta applied
747         @return interest The interest gained in the realDelta time
748     */
749     function calculateInterest(uint256 timeDelta, uint256 interestRate, uint256 amount) internal pure returns (uint256 realDelta, uint256 interest) {
750         if (amount == 0) {
751             interest = 0;
752             realDelta = timeDelta;
753         } else {
754             interest = safeMult(safeMult(100000, amount), timeDelta) / interestRate;
755             realDelta = safeMult(interest, interestRate) / (amount * 100000);
756         }
757     }
758 
759     /**
760         @notice Computes loan interest
761 
762         Computes the punitory and non-punitory interest of a given loan and only applies the change.
763         
764         @param loan Loan to compute interest
765         @param timestamp Target absolute unix time to calculate interest.
766     */
767     function internalAddInterest(Loan storage loan, uint256 timestamp) internal {
768         if (timestamp > loan.interestTimestamp) {
769             uint256 newInterest = loan.interest;
770             uint256 newPunitoryInterest = loan.punitoryInterest;
771 
772             uint256 newTimestamp;
773             uint256 realDelta;
774             uint256 calculatedInterest;
775 
776             uint256 deltaTime;
777             uint256 pending;
778 
779             uint256 endNonPunitory = min(timestamp, loan.dueTime);
780             if (endNonPunitory > loan.interestTimestamp) {
781                 deltaTime = endNonPunitory - loan.interestTimestamp;
782 
783                 if (loan.paid < loan.amount) {
784                     pending = loan.amount - loan.paid;
785                 } else {
786                     pending = 0;
787                 }
788 
789                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRate, pending);
790                 newInterest = safeAdd(calculatedInterest, newInterest);
791                 newTimestamp = loan.interestTimestamp + realDelta;
792             }
793 
794             if (timestamp > loan.dueTime) {
795                 uint256 startPunitory = max(loan.dueTime, loan.interestTimestamp);
796                 deltaTime = timestamp - startPunitory;
797 
798                 uint256 debt = safeAdd(loan.amount, newInterest);
799                 pending = min(debt, safeSubtract(safeAdd(debt, newPunitoryInterest), loan.paid));
800 
801                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRatePunitory, pending);
802                 newPunitoryInterest = safeAdd(newPunitoryInterest, calculatedInterest);
803                 newTimestamp = startPunitory + realDelta;
804             }
805             
806             if (newInterest != loan.interest || newPunitoryInterest != loan.punitoryInterest) {
807                 loan.interestTimestamp = newTimestamp;
808                 loan.interest = newInterest;
809                 loan.punitoryInterest = newPunitoryInterest;
810             }
811         }
812     }
813 
814     /**
815         @notice Updates the loan accumulated interests up to the current Unix time.
816         
817         @param index Index of the loan
818     
819         @return true If the interest was updated
820     */
821     function addInterest(uint index) public returns (bool) {
822         Loan storage loan = loans[index];
823         require(loan.status == Status.lent);
824         internalAddInterest(loan, block.timestamp);
825     }
826     
827     /**
828         @notice Pay loan
829 
830         Does a payment of a given Loan, before performing the payment the accumulated
831         interest is computed and added to the total pending amount.
832 
833         Before calling this function, the msg.sender must call the "approve" function on the RCN Token, specifying an amount
834         sufficient enough to pay the equivalent of the desired payment and the oracle fee.
835 
836         If the paid pending amount equals zero, the loan changes status to "paid" and it is considered closed.
837 
838         @dev Because it is difficult or even impossible to know in advance how much RCN are going to be spent on the
839         transaction*, we recommend performing the "approve" using an amount 5% superior to the wallet estimated
840         spending. If the RCN spent results to be less, the extra tokens are never debited from the msg.sender.
841 
842         * The RCN rate can fluctuate on the same block, and it is impossible to know in advance the exact time of the
843         confirmation of the transaction. 
844 
845         @param index Index of the loan
846         @param _amount Amount to pay, specified in the loan currency; or in RCN if the loan has no oracle
847         @param _from The identity of the payer
848         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
849             by the url exposed in the url() method of the oracle.
850             
851         @return true if the payment was executed successfully
852     */
853     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool) {
854         Loan storage loan = loans[index];
855 
856         require(loan.status == Status.lent);
857         addInterest(index);
858         uint256 toPay = min(getPendingAmount(index), _amount);
859         PartialPayment(index, msg.sender, _from, toPay);
860 
861         loan.paid = safeAdd(loan.paid, toPay);
862 
863         if (getRawPendingAmount(index) == 0) {
864             TotalPayment(index);
865             loan.status = Status.paid;
866 
867             // ERC721, remove loan from circulation
868             lendersBalance[loan.lender] -= 1;
869             activeLoans -= 1;
870             Transfer(loan.lender, 0x0, index);
871         }
872 
873         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, toPay);
874         require(transferValue > 0 || toPay < _amount);
875 
876         lockTokens(rcn, transferValue);
877         require(rcn.transferFrom(msg.sender, this, transferValue));
878         loan.lenderBalance = safeAdd(transferValue, loan.lenderBalance);
879 
880         return true;
881     }
882 
883     /**
884         @notice Converts an amount to RCN using the loan oracle.
885         
886         @dev If the loan has no oracle the currency must be RCN so the rate is 1
887 
888         @return The result of the convertion
889     */
890     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public returns (uint256) {
891         if (oracle == address(0)) {
892             return amount;
893         } else {
894             uint256 rate;
895             uint256 decimals;
896             
897             (rate, decimals) = oracle.getRate(currency, data);
898 
899             require(decimals <= MAX_DECIMALS);
900             return (safeMult(safeMult(amount, rate), (10**decimals))) / PRECISION;
901         }
902     }
903 
904     /**
905         @notice Withdraw lender funds
906 
907         When a loan is paid, the funds are not transferred automatically to the lender, the funds are stored on the
908         engine contract, and the lender must call this function specifying the amount desired to transfer and the 
909         destination.
910 
911         @dev This behavior is defined to allow the temporary transfer of the loan to a smart contract, without worrying that
912         the contract will receive tokens that are not traceable; and it allows the development of decentralized 
913         autonomous organizations.
914 
915         @param index Index of the loan
916         @param to Destination of the wiwthdraw funds
917         @param amount Amount to withdraw, in RCN
918 
919         @return true if the withdraw was executed successfully
920     */
921     function withdrawal(uint index, address to, uint256 amount) public returns (bool) {
922         Loan storage loan = loans[index];
923         require(msg.sender == loan.lender);
924         loan.lenderBalance = safeSubtract(loan.lenderBalance, amount);
925         require(rcn.transfer(to, amount));
926         unlockTokens(rcn, amount);
927         return true;
928     }
929 
930     /**
931         @notice Withdraw lender funds in batch, it walks by all the loans between the two index, and withdraws all
932         the funds stored on that loans.
933 
934         @dev This batch withdraw method can be expensive in gas, it must be used with care.
935 
936         @param fromIndex Start index of the search
937         @param toIndex End index of the search
938         @param to Destination of the tokens
939 
940         @return the total withdrawed 
941     */
942     function withdrawalRange(uint256 fromIndex, uint256 toIndex, address to) public returns (uint256) {
943         uint256 loanId;
944         uint256 totalWithdraw = 0;
945 
946         for (loanId = fromIndex; loanId <= toIndex; loanId++) {
947             Loan storage loan = loans[loanId];
948             if (loan.lender == msg.sender) {
949                 totalWithdraw += loan.lenderBalance;
950                 loan.lenderBalance = 0;
951             }
952         }
953 
954         require(rcn.transfer(to, totalWithdraw));
955         unlockTokens(rcn, totalWithdraw);
956         
957         return totalWithdraw;
958     }
959 
960     /**
961         @notice Withdraw lender funds in batch, it walks by all the loans passed to the function and withdraws all
962         the funds stored on that loans.
963 
964         @dev This batch withdraw method can be expensive in gas, it must be used with care.
965 
966         @param loanIds Array of the loans to withdraw
967         @param to Destination of the tokens
968 
969         @return the total withdrawed 
970     */
971     function withdrawalList(uint256[] memory loanIds, address to) public returns (uint256) {
972         uint256 inputId;
973         uint256 totalWithdraw = 0;
974 
975         for (inputId = 0; inputId < loanIds.length; inputId++) {
976             Loan storage loan = loans[loanIds[inputId]];
977             if (loan.lender == msg.sender) {
978                 totalWithdraw += loan.lenderBalance;
979                 loan.lenderBalance = 0;
980             }
981         }
982 
983         require(rcn.transfer(to, totalWithdraw));
984         unlockTokens(rcn, totalWithdraw);
985 
986         return totalWithdraw;
987     }
988 
989     /**
990         @dev Deprecates the engine, locks the creation of new loans.
991     */
992     function setDeprecated(bool _deprecated) public onlyOwner {
993         deprecated = _deprecated;
994     }
995 }