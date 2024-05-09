1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/Token.sol
4 
5 contract Token {
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 }
13 
14 // File: contracts/interfaces/TokenConverter.sol
15 
16 contract TokenConverter {
17     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
18     function getReturn(Token _fromToken, Token _toToken, uint256 _fromAmount) external view returns (uint256 amount);
19     function convert(Token _fromToken, Token _toToken, uint256 _fromAmount, uint256 _minReturn) external payable returns (uint256 amount);
20 }
21 
22 // File: contracts/vendors/rcn/NanoLoanEngine.sol
23 
24 contract Engine {
25     uint256 public VERSION;
26     string public VERSION_NAME;
27 
28     enum Status { initial, lent, paid, destroyed }
29     struct Approbation {
30         bool approved;
31         bytes data;
32         bytes32 checksum;
33     }
34 
35     function getTotalLoans() public view returns (uint256);
36     function getOracle(uint index) public view returns (Oracle);
37     function getBorrower(uint index) public view returns (address);
38     function getCosigner(uint index) public view returns (address);
39     function ownerOf(uint256) public view returns (address owner);
40     function getCreator(uint index) public view returns (address);
41     function getAmount(uint index) public view returns (uint256);
42     function getPaid(uint index) public view returns (uint256);
43     function getDueTime(uint index) public view returns (uint256);
44     function getApprobation(uint index, address _address) public view returns (bool);
45     function getStatus(uint index) public view returns (Status);
46     function isApproved(uint index) public view returns (bool);
47     function getPendingAmount(uint index) public returns (uint256);
48     function getCurrency(uint index) public view returns (bytes32);
49     function cosign(uint index, uint256 cost) external returns (bool);
50     function approveLoan(uint index) public returns (bool);
51     function transfer(address to, uint256 index) public returns (bool);
52     function takeOwnership(uint256 index) public returns (bool);
53     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
54 }
55 
56 /**
57     @dev Defines the interface of a standard RCN cosigner.
58 
59     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
60     of the insurance and the cost of the given are defined by the cosigner. 
61 
62     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
63     agent should be passed as params when the lender calls the "lend" method on the engine.
64     
65     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
66     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
67     call this method, like the transfer of the ownership of the loan.
68 */
69 contract Cosigner {
70     uint256 public constant VERSION = 2;
71     
72     /**
73         @return the url of the endpoint that exposes the insurance offers.
74     */
75     function url() public view returns (string);
76     
77     /**
78         @dev Retrieves the cost of a given insurance, this amount should be exact.
79 
80         @return the cost of the cosign, in RCN wei
81     */
82     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
83     
84     /**
85         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
86         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
87         does not return true to this method, the operation fails.
88 
89         @return true if the cosigner accepts the liability
90     */
91     function requestCosign(address engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
92     
93     /**
94         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
95         current lender of the loan.
96 
97         @return true if the claim was done correctly.
98     */
99     function claim(address engine, uint256 index, bytes oracleData) public returns (bool);
100 }
101 
102 contract ERC721 {
103    // ERC20 compatible functions
104    function name() public view returns (string _name);
105    function symbol() public view returns (string _symbol);
106    function totalSupply() public view returns (uint256 _totalSupply);
107    function balanceOf(address _owner) public view returns (uint _balance);
108    // Functions that define ownership
109    function ownerOf(uint256) public view returns (address owner);
110    function approve(address, uint256) public returns (bool);
111    function takeOwnership(uint256) public returns (bool);
112    function transfer(address, uint256) public returns (bool);
113    function setApprovalForAll(address _operator, bool _approved) public returns (bool);
114    function getApproved(uint256 _tokenId) public view returns (address);
115    function isApprovedForAll(address _owner, address _operator) public view returns (bool);
116    // Token metadata
117    function tokenMetadata(uint256 _tokenId) public view returns (string info);
118    // Events
119    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
120    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
121    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
122 }
123 
124 contract Ownable {
125     address public owner;
126 
127     modifier onlyOwner() {
128         require(msg.sender == owner);
129         _;
130     }
131 
132     function Ownable() public {
133         owner = msg.sender; 
134     }
135 
136     /**
137         @dev Transfers the ownership of the contract.
138 
139         @param _to Address of the new owner
140     */
141     function transferTo(address _to) public onlyOwner returns (bool) {
142         require(_to != address(0));
143         owner = _to;
144         return true;
145     } 
146 } 
147 
148 /**
149     @dev Defines the interface of a standard RCN oracle.
150 
151     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
152     it's primarily used by the exchange but could be used by any other agent.
153 */
154 contract Oracle is Ownable {
155     uint256 public constant VERSION = 3;
156 
157     event NewSymbol(bytes32 _currency, string _ticker);
158     
159     struct Symbol {
160         string ticker;
161         bool supported;
162     }
163 
164     mapping(bytes32 => Symbol) public currencies;
165 
166     /**
167         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
168     */
169     function url() public view returns (string);
170 
171     /**
172         @dev Returns a valid convertion rate from the currency given to RCN
173 
174         @param symbol Symbol of the currency
175         @param data Generic data field, could be used for off-chain signing
176     */
177     function getRate(bytes32 symbol, bytes data) public returns (uint256 rate, uint256 decimals);
178 
179     /**
180         @dev Adds a currency to the oracle, once added it cannot be removed
181 
182         @param ticker Symbol of the currency
183 
184         @return the hash of the currency, calculated keccak256(ticker)
185     */
186     function addCurrency(string ticker) public onlyOwner returns (bytes32) {
187         NewSymbol(currency, ticker);
188         bytes32 currency = keccak256(ticker);
189         currencies[currency] = Symbol(ticker, true);
190         return currency;
191     }
192 
193     /**
194         @return true If the currency is supported
195     */
196     function supported(bytes32 symbol) public view returns (bool) {
197         return currencies[symbol].supported;
198     }
199 }
200 
201 contract RpSafeMath {
202     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
203       uint256 z = x + y;
204       require((z >= x) && (z >= y));
205       return z;
206     }
207 
208     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
209       require(x >= y);
210       uint256 z = x - y;
211       return z;
212     }
213 
214     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
215       uint256 z = x * y;
216       require((x == 0)||(z/x == y));
217       return z;
218     }
219 
220     function min(uint256 a, uint256 b) internal pure returns(uint256) {
221         if (a < b) { 
222           return a;
223         } else { 
224           return b; 
225         }
226     }
227     
228     function max(uint256 a, uint256 b) internal pure returns(uint256) {
229         if (a > b) { 
230           return a;
231         } else { 
232           return b; 
233         }
234     }
235 }
236 
237 contract TokenLockable is RpSafeMath, Ownable {
238     mapping(address => uint256) public lockedTokens;
239 
240     /**
241         @dev Locked tokens cannot be withdrawn using the withdrawTokens function.
242     */
243     function lockTokens(address token, uint256 amount) internal {
244         lockedTokens[token] = safeAdd(lockedTokens[token], amount);
245     }
246 
247     /**
248         @dev Unlocks previusly locked tokens.
249     */
250     function unlockTokens(address token, uint256 amount) internal {
251         lockedTokens[token] = safeSubtract(lockedTokens[token], amount);
252     }
253 
254     /**
255         @dev Withdraws tokens from the contract.
256 
257         @param token Token to withdraw
258         @param to Destination of the tokens
259         @param amount Amount to withdraw 
260     */
261     function withdrawTokens(Token token, address to, uint256 amount) public onlyOwner returns (bool) {
262         require(safeSubtract(token.balanceOf(this), lockedTokens[token]) >= amount);
263         require(to != address(0));
264         return token.transfer(to, amount);
265     }
266 }
267 
268 contract NanoLoanEngine is Ownable, TokenLockable {
269     uint256 constant internal PRECISION = (10**18);
270     uint256 constant internal RCN_DECIMALS = 18;
271 
272     uint256 public constant VERSION = 232;
273     string public constant VERSION_NAME = "Basalt";
274 
275     uint256 private activeLoans = 0;
276     mapping(address => uint256) private lendersBalance;
277 
278     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
279     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
280     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
281 
282     function name() public view returns (string _name) {
283         _name = "RCN - Nano loan engine - Basalt 232";
284     }
285 
286     function symbol() public view returns (string _symbol) {
287         _symbol = "RCN-NLE-232";
288     }
289 
290     /**
291         @notice Returns the number of active loans in total, active loans are the loans with "lent" status.
292         @dev Required for ERC-721 compliance
293 
294         @return _totalSupply Total amount of loans
295     */
296     function totalSupply() public view returns (uint _totalSupply) {
297         _totalSupply = activeLoans;
298     }
299 
300     /**
301         @notice Returns the number of active loans that a lender possess; active loans are the loans with "lent" status.
302         @dev Required for ERC-721 compliance
303 
304         @param _owner The owner address to search
305         
306         @return _balance Amount of loans  
307     */
308     function balanceOf(address _owner) public view returns (uint _balance) {
309         _balance = lendersBalance[_owner];
310     }
311 
312     /**
313         @notice Returns all the loans that a lender possess
314         @dev This method MUST NEVER be called by smart contract code; 
315             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
316 
317         @param _owner The owner address
318 
319         @return ownerTokens List of all the loans of the _owner
320     */
321     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
322         uint256 tokenCount = balanceOf(_owner);
323 
324         if (tokenCount == 0) {
325             // Return an empty array
326             return new uint256[](0);
327         } else {
328             uint256[] memory result = new uint256[](tokenCount);
329             uint256 totalLoans = loans.length - 1;
330             uint256 resultIndex = 0;
331 
332             uint256 loanId;
333 
334             for (loanId = 0; loanId <= totalLoans; loanId++) {
335                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
336                     result[resultIndex] = loanId;
337                     resultIndex++;
338                 }
339             }
340 
341             return result;
342         }
343     }
344 
345     /**
346         @notice Returns the loan metadata, this field can be set by the creator of the loan with his own criteria.
347 
348         @param index Index of the loan
349 
350         @return The string with the metadata
351     */
352     function tokenMetadata(uint256 index) public view returns (string) {
353         return loans[index].metadata;
354     }
355 
356     /**
357         @notice Returns the loan metadata, hashed with keccak256.
358         @dev This emthod is useful to evaluate metadata from a smart contract.
359 
360         @param index Index of the loan
361 
362         @return The metadata hashed with keccak256
363     */
364     function tokenMetadataHash(uint256 index) public view returns (bytes32) {
365         return keccak256(loans[index].metadata);
366     }
367 
368     Token public rcn;
369     bool public deprecated;
370 
371     event CreatedLoan(uint _index, address _borrower, address _creator);
372     event ApprovedBy(uint _index, address _address);
373     event Lent(uint _index, address _lender, address _cosigner);
374     event DestroyedBy(uint _index, address _address);
375     event PartialPayment(uint _index, address _sender, address _from, uint256 _amount);
376     event TotalPayment(uint _index);
377 
378     function NanoLoanEngine(Token _rcn) public {
379         owner = msg.sender;
380         rcn = _rcn;
381         // The loan 0 is a Invalid loan
382         loans.length++;
383     }
384     enum Status { initial, lent, paid, destroyed }
385 
386     struct Loan {
387         Status status;
388         Oracle oracle;
389 
390         address borrower;
391         address lender;
392         address creator;
393         address cosigner;
394         
395         uint256 amount;
396         uint256 interest;
397         uint256 punitoryInterest;
398         uint256 interestTimestamp;
399         uint256 paid;
400         uint256 interestRate;
401         uint256 interestRatePunitory;
402         uint256 dueTime;
403         uint256 duesIn;
404 
405         bytes32 currency;
406         uint256 cancelableAt;
407         uint256 lenderBalance;
408 
409         address approvedTransfer;
410         uint256 expirationRequest;
411 
412         string metadata;
413         mapping(address => bool) approbations;
414     }
415 
416     mapping(bytes32 => uint256) public identifierToIndex;
417     Loan[] private loans;
418 
419     /**
420         @notice Creates a loan request, the loan can be generated with any borrower and conditions; if the borrower agrees
421         it must call the "approve" function. If the creator of the loan is the borrower the approve is done automatically.
422 
423         @dev The creator of the loan is the caller of this function; this is useful to track which wallet created the loan.
424             Two identical loans cannot exist, a clone of another loan will fail.
425 
426         @param _oracleContract Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
427         @param _borrower Address of the borrower
428         @param _currency The currency to use with the oracle, the currency code is generated with the following formula,
429             keccak256(ticker), is always stored as the minimum divisible amount. (Ej: ETH Wei, USD Cents)
430         @param _amount The requested amount; currency and unit are defined by the Oracle, if there is no Oracle present
431             the currency is RCN, and the unit is wei.
432         @param _interestRate The non-punitory interest rate by second, defined as a denominator of 10 000 000.
433         @param _interestRatePunitory The punitory interest rate by second, defined as a denominator of 10 000 000.
434             Ej: interestRate 11108571428571 = 28% Anual interest
435         @param _duesIn The time in seconds that the borrower has in order to pay the debt after the lender lends the money.
436         @param _cancelableAt Delta in seconds specifying how much interest should be added in advance, if the borrower pays 
437         entirely or partially the loan before this term, no extra interest will be deducted.
438         @param _expirationRequest Timestamp of when the loan request expires, if the loan is not filled before this date, 
439             the request is no longer valid.
440         @param _metadata String with loan metadata.
441     */
442     function createLoan(Oracle _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
443         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256) {
444 
445         require(!deprecated);
446         require(_cancelableAt <= _duesIn);
447         require(_oracleContract != address(0) || _currency == 0x0);
448         require(_borrower != address(0));
449         require(_amount != 0);
450         require(_interestRatePunitory != 0);
451         require(_interestRate != 0);
452         require(_expirationRequest > block.timestamp);
453 
454         var loan = Loan(Status.initial, _oracleContract, _borrower, 0x0, msg.sender, 0x0, _amount, 0, 0, 0, 0, _interestRate,
455             _interestRatePunitory, 0, _duesIn, _currency, _cancelableAt, 0, 0x0, _expirationRequest, _metadata);
456 
457         uint index = loans.push(loan) - 1;
458         CreatedLoan(index, _borrower, msg.sender);
459 
460         bytes32 identifier = getIdentifier(index);
461         require(identifierToIndex[identifier] == 0);
462         identifierToIndex[identifier] = index;
463 
464         if (msg.sender == _borrower) {
465             approveLoan(index);
466         }
467 
468         return index;
469     }
470     
471     function ownerOf(uint256 index) public view returns (address owner) { owner = loans[index].lender; }
472     function getTotalLoans() public view returns (uint256) { return loans.length; }
473     function getOracle(uint index) public view returns (Oracle) { return loans[index].oracle; }
474     function getBorrower(uint index) public view returns (address) { return loans[index].borrower; }
475     function getCosigner(uint index) public view returns (address) { return loans[index].cosigner; }
476     function getCreator(uint index) public view returns (address) { return loans[index].creator; }
477     function getAmount(uint index) public view returns (uint256) { return loans[index].amount; }
478     function getPunitoryInterest(uint index) public view returns (uint256) { return loans[index].punitoryInterest; }
479     function getInterestTimestamp(uint index) public view returns (uint256) { return loans[index].interestTimestamp; }
480     function getPaid(uint index) public view returns (uint256) { return loans[index].paid; }
481     function getInterestRate(uint index) public view returns (uint256) { return loans[index].interestRate; }
482     function getInterestRatePunitory(uint index) public view returns (uint256) { return loans[index].interestRatePunitory; }
483     function getDueTime(uint index) public view returns (uint256) { return loans[index].dueTime; }
484     function getDuesIn(uint index) public view returns (uint256) { return loans[index].duesIn; }
485     function getCancelableAt(uint index) public view returns (uint256) { return loans[index].cancelableAt; }
486     function getApprobation(uint index, address _address) public view returns (bool) { return loans[index].approbations[_address]; }
487     function getStatus(uint index) public view returns (Status) { return loans[index].status; }
488     function getLenderBalance(uint index) public view returns (uint256) { return loans[index].lenderBalance; }
489     function getApproved(uint index) public view returns (address) {return loans[index].approvedTransfer; }
490     function getCurrency(uint index) public view returns (bytes32) { return loans[index].currency; }
491     function getExpirationRequest(uint index) public view returns (uint256) { return loans[index].expirationRequest; }
492     function getInterest(uint index) public view returns (uint256) { return loans[index].interest; }
493 
494     function getIdentifier(uint index) public view returns (bytes32) {
495         Loan memory loan = loans[index];
496         return buildIdentifier(loan.oracle, loan.borrower, loan.creator, loan.currency, loan.amount, loan.interestRate,
497             loan.interestRatePunitory, loan.duesIn, loan.cancelableAt, loan.expirationRequest, loan.metadata);
498     }
499 
500     /**
501         @notice Used to reference a loan that is not yet created, and by that does not have an index
502 
503         @dev Two identical loans cannot exist, only one loan per signature is allowed
504 
505         @return The signature hash of the loan configuration
506     */
507     function buildIdentifier(Oracle oracle, address borrower, address creator, bytes32 currency, uint256 amount, uint256 interestRate,
508         uint256 interestRatePunitory, uint256 duesIn, uint256 cancelableAt, uint256 expirationRequest, string metadata) view returns (bytes32) {
509         return keccak256(this, oracle, borrower, creator, currency, amount, interestRate, interestRatePunitory, duesIn,
510                         cancelableAt, expirationRequest, metadata); 
511     }
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
544         @notice Approves a loan using the Identifier and not the index
545 
546         @param identifier Identifier of the loan
547 
548         @return true if the approve was done successfully
549     */
550     function approveLoanIdentifier(bytes32 identifier) public returns (bool) {
551         uint256 index = identifierToIndex[identifier];
552         require(index != 0);
553         return approveLoan(index);
554     }
555 
556     /**
557         @notice Register an approvation made by a borrower in the past
558 
559         @dev The loan should exist and have an index
560 
561         @param identifier Identifier of the loan
562 
563         @return true if the approve was done successfully
564     */
565     function registerApprove(bytes32 identifier, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
566         uint256 index = identifierToIndex[identifier];
567         require(index != 0);
568         Loan storage loan = loans[index];
569         require(loan.borrower == ecrecover(keccak256("\x19Ethereum Signed Message:\n32", identifier), v, r, s));
570         loan.approbations[loan.borrower] = true;
571         ApprovedBy(index, loan.borrower);
572         return true;
573     }
574 
575     /**
576         @notice Performs the lend of the RCN equivalent to the requested amount, and transforms the msg.sender in the new lender.
577 
578         @dev The loan must be previously approved by the borrower; before calling this function, the lender candidate must 
579         call the "approve" function on the RCN Token, specifying an amount sufficient enough to pay the equivalent of
580         the requested amount, and the cosigner fee.
581         
582         @param index Index of the loan
583         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
584             by the url exposed in the url() method of the oracle.
585         @param cosigner Address of the cosigner, 0x0 for lending without cosigner.
586         @param cosignerData Data required by the cosigner to process the request.
587 
588         @return true if the lend was done successfully
589     */
590     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool) {
591         Loan storage loan = loans[index];
592 
593         require(loan.status == Status.initial);
594         require(isApproved(index));
595         require(block.timestamp <= loan.expirationRequest);
596 
597         loan.lender = msg.sender;
598         loan.dueTime = safeAdd(block.timestamp, loan.duesIn);
599         loan.interestTimestamp = block.timestamp;
600         loan.status = Status.lent;
601 
602         // ERC721, create new loan and transfer it to the lender
603         Transfer(0x0, loan.lender, index);
604         activeLoans += 1;
605         lendersBalance[loan.lender] += 1;
606         
607         if (loan.cancelableAt > 0)
608             internalAddInterest(loan, safeAdd(block.timestamp, loan.cancelableAt));
609 
610         // Transfer the money to the borrower before handling the cosigner
611         // so the cosigner could require a specific usage for that money.
612         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, loan.amount);
613         require(rcn.transferFrom(msg.sender, loan.borrower, transferValue));
614         
615         if (cosigner != address(0)) {
616             // The cosigner it's temporary set to the next address (cosigner + 2), it's expected that the cosigner will
617             // call the method "cosign" to accept the conditions; that method also sets the cosigner to the right
618             // address. If that does not happen, the transaction fails.
619             loan.cosigner = address(uint256(cosigner) + 2);
620             require(cosigner.requestCosign(this, index, cosignerData, oracleData));
621             require(loan.cosigner == address(cosigner));
622         }
623                 
624         Lent(index, loan.lender, cosigner);
625 
626         return true;
627     }
628 
629     /**
630         @notice The cosigner must call this method to accept the conditions of a loan, this method pays the cosigner his fee.
631         
632         @dev If the cosigner does not call this method the whole "lend" call fails.
633 
634         @param index Index of the loan
635         @param cost Fee set by the cosigner
636 
637         @return true If the cosign was successfull
638     */
639     function cosign(uint index, uint256 cost) external returns (bool) {
640         Loan storage loan = loans[index];
641         require(loan.status == Status.lent && (loan.dueTime - loan.duesIn) == block.timestamp);
642         require(loan.cosigner != address(0));
643         require(loan.cosigner == address(uint256(msg.sender) + 2));
644         loan.cosigner = msg.sender;
645         require(rcn.transferFrom(loan.lender, msg.sender, cost));
646         return true;
647     }
648 
649     /**
650         @notice Destroys a loan, the borrower could call this method if they performed an accidental or regretted 
651         "approve" of the loan, this method only works for them if the loan is in "pending" status.
652 
653         The lender can call this method at any moment, in case of a loan with status "lent" the lender is pardoning 
654         the debt. 
655 
656         @param index Index of the loan
657 
658         @return true if the destroy was done successfully
659     */
660     function destroy(uint index) public returns (bool) {
661         Loan storage loan = loans[index];
662         require(loan.status != Status.destroyed);
663         require(msg.sender == loan.lender || (msg.sender == loan.borrower && loan.status == Status.initial));
664         DestroyedBy(index, msg.sender);
665 
666         // ERC721, remove loan from circulation
667         if (loan.status != Status.initial) {
668             lendersBalance[loan.lender] -= 1;
669             activeLoans -= 1;
670             Transfer(loan.lender, 0x0, index);
671         }
672 
673         loan.status = Status.destroyed;
674         return true;
675     }
676 
677     /**
678         @notice Destroys a loan using the signature and not the Index
679 
680         @param identifier Identifier of the loan
681 
682         @return true if the destroy was done successfully
683     */
684     function destroyIdentifier(bytes32 identifier) public returns (bool) {
685         uint256 index = identifierToIndex[identifier];
686         require(index != 0);
687         return destroy(index);
688     }
689 
690     /**
691         @notice Transfers a loan to a different lender, the caller must be the current lender or previously being
692         approved with the method "approveTransfer"; only loans with the Status.lent status can be transfered.
693 
694         @dev Required for ERC-721 compliance
695 
696         @param index Index of the loan
697         @param to New lender
698 
699         @return true if the transfer was done successfully
700     */
701     function transfer(address to, uint256 index) public returns (bool) {
702         Loan storage loan = loans[index];
703         
704         require(msg.sender == loan.lender || msg.sender == loan.approvedTransfer);
705         require(to != address(0));
706         loan.lender = to;
707         loan.approvedTransfer = address(0);
708 
709         // ERC721, transfer loan to another address
710         lendersBalance[msg.sender] -= 1;
711         lendersBalance[to] += 1;
712         Transfer(loan.lender, to, index);
713 
714         return true;
715     }
716 
717     /**
718         @notice Transfers the loan to the msg.sender, the msg.sender must be approved using the "approve" method.
719 
720         @dev Required for ERC-721 compliance
721 
722         @param _index Index of the loan
723 
724         @return true if the transfer was successfull
725     */
726     function takeOwnership(uint256 _index) public returns (bool) {
727         return transfer(msg.sender, _index);
728     }
729 
730     /**
731         @notice Transfers the loan to an address, only if the current owner is the "from" address
732 
733         @dev Required for ERC-721 compliance
734 
735         @param from Current owner of the loan
736         @param to New owner of the loan
737         @param index Index of the loan
738 
739         @return true if the transfer was successfull
740     */
741     function transferFrom(address from, address to, uint256 index) public returns (bool) {
742         require(loans[index].lender == from);
743         return transfer(to, index);
744     }
745 
746     /**
747         @notice Approves the transfer of a given loan in the name of the lender, the behavior of this function is similar to
748         "approve" in the ERC20 standard, but only one approved address is allowed at a time.
749 
750         The same method can be called passing 0x0 as parameter "to" to erase a previously approved address.
751 
752         @dev Required for ERC-721 compliance
753 
754         @param to Address allowed to transfer the loan or 0x0 to delete
755         @param index Index of the loan
756 
757         @return true if the approve was done successfully
758     */
759     function approve(address to, uint256 index) public returns (bool) {
760         Loan storage loan = loans[index];
761         require(msg.sender == loan.lender);
762         loan.approvedTransfer = to;
763         Approval(msg.sender, to, index);
764         return true;
765     }
766 
767     /**
768         @notice Returns the pending amount to complete de payment of the loan, keep in mind that this number increases 
769         every second.
770 
771         @dev This method also computes the interest and updates the loan
772 
773         @param index Index of the loan
774 
775         @return Aprox pending payment amount
776     */
777     function getPendingAmount(uint index) public returns (uint256) {
778         addInterest(index);
779         return getRawPendingAmount(index);
780     }
781 
782     /**
783         @notice Returns the pending amount up to the last time of the interest update. This is not the real pending amount
784 
785         @dev This method is exact only if "addInterest(loan)" was before and in the same block.
786 
787         @param index Index of the loan
788 
789         @return The past pending amount
790     */
791     function getRawPendingAmount(uint index) public view returns (uint256) {
792         Loan memory loan = loans[index];
793         return safeSubtract(safeAdd(safeAdd(loan.amount, loan.interest), loan.punitoryInterest), loan.paid);
794     }
795 
796     /**
797         @notice Calculates the interest of a given amount, interest rate and delta time.
798 
799         @param timeDelta Elapsed time
800         @param interestRate Interest rate expressed as the denominator of 10 000 000.
801         @param amount Amount to apply interest
802 
803         @return realDelta The real timeDelta applied
804         @return interest The interest gained in the realDelta time
805     */
806     function calculateInterest(uint256 timeDelta, uint256 interestRate, uint256 amount) internal pure returns (uint256 realDelta, uint256 interest) {
807         if (amount == 0) {
808             interest = 0;
809             realDelta = timeDelta;
810         } else {
811             interest = safeMult(safeMult(100000, amount), timeDelta) / interestRate;
812             realDelta = safeMult(interest, interestRate) / (amount * 100000);
813         }
814     }
815 
816     /**
817         @notice Computes loan interest
818 
819         Computes the punitory and non-punitory interest of a given loan and only applies the change.
820         
821         @param loan Loan to compute interest
822         @param timestamp Target absolute unix time to calculate interest.
823     */
824     function internalAddInterest(Loan storage loan, uint256 timestamp) internal {
825         if (timestamp > loan.interestTimestamp) {
826             uint256 newInterest = loan.interest;
827             uint256 newPunitoryInterest = loan.punitoryInterest;
828 
829             uint256 newTimestamp;
830             uint256 realDelta;
831             uint256 calculatedInterest;
832 
833             uint256 deltaTime;
834             uint256 pending;
835 
836             uint256 endNonPunitory = min(timestamp, loan.dueTime);
837             if (endNonPunitory > loan.interestTimestamp) {
838                 deltaTime = endNonPunitory - loan.interestTimestamp;
839 
840                 if (loan.paid < loan.amount) {
841                     pending = loan.amount - loan.paid;
842                 } else {
843                     pending = 0;
844                 }
845 
846                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRate, pending);
847                 newInterest = safeAdd(calculatedInterest, newInterest);
848                 newTimestamp = loan.interestTimestamp + realDelta;
849             }
850 
851             if (timestamp > loan.dueTime) {
852                 uint256 startPunitory = max(loan.dueTime, loan.interestTimestamp);
853                 deltaTime = timestamp - startPunitory;
854 
855                 uint256 debt = safeAdd(loan.amount, newInterest);
856                 pending = min(debt, safeSubtract(safeAdd(debt, newPunitoryInterest), loan.paid));
857 
858                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRatePunitory, pending);
859                 newPunitoryInterest = safeAdd(newPunitoryInterest, calculatedInterest);
860                 newTimestamp = startPunitory + realDelta;
861             }
862             
863             if (newInterest != loan.interest || newPunitoryInterest != loan.punitoryInterest) {
864                 loan.interestTimestamp = newTimestamp;
865                 loan.interest = newInterest;
866                 loan.punitoryInterest = newPunitoryInterest;
867             }
868         }
869     }
870 
871     /**
872         @notice Updates the loan accumulated interests up to the current Unix time.
873         
874         @param index Index of the loan
875     
876         @return true If the interest was updated
877     */
878     function addInterest(uint index) public returns (bool) {
879         Loan storage loan = loans[index];
880         require(loan.status == Status.lent);
881         internalAddInterest(loan, block.timestamp);
882     }
883     
884     /**
885         @notice Pay loan
886 
887         Does a payment of a given Loan, before performing the payment the accumulated
888         interest is computed and added to the total pending amount.
889 
890         Before calling this function, the msg.sender must call the "approve" function on the RCN Token, specifying an amount
891         sufficient enough to pay the equivalent of the desired payment and the oracle fee.
892 
893         If the paid pending amount equals zero, the loan changes status to "paid" and it is considered closed.
894 
895         @dev Because it is difficult or even impossible to know in advance how much RCN are going to be spent on the
896         transaction*, we recommend performing the "approve" using an amount 5% superior to the wallet estimated
897         spending. If the RCN spent results to be less, the extra tokens are never debited from the msg.sender.
898 
899         * The RCN rate can fluctuate on the same block, and it is impossible to know in advance the exact time of the
900         confirmation of the transaction. 
901 
902         @param index Index of the loan
903         @param _amount Amount to pay, specified in the loan currency; or in RCN if the loan has no oracle
904         @param _from The identity of the payer
905         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
906             by the url exposed in the url() method of the oracle.
907             
908         @return true if the payment was executed successfully
909     */
910     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool) {
911         Loan storage loan = loans[index];
912 
913         require(loan.status == Status.lent);
914         addInterest(index);
915         uint256 toPay = min(getPendingAmount(index), _amount);
916         PartialPayment(index, msg.sender, _from, toPay);
917 
918         loan.paid = safeAdd(loan.paid, toPay);
919 
920         if (getRawPendingAmount(index) == 0) {
921             TotalPayment(index);
922             loan.status = Status.paid;
923 
924             // ERC721, remove loan from circulation
925             lendersBalance[loan.lender] -= 1;
926             activeLoans -= 1;
927             Transfer(loan.lender, 0x0, index);
928         }
929 
930         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, toPay);
931         require(transferValue > 0 || toPay < _amount);
932 
933         lockTokens(rcn, transferValue);
934         require(rcn.transferFrom(msg.sender, this, transferValue));
935         loan.lenderBalance = safeAdd(transferValue, loan.lenderBalance);
936 
937         return true;
938     }
939 
940     /**
941         @notice Converts an amount to RCN using the loan oracle.
942         
943         @dev If the loan has no oracle the currency must be RCN so the rate is 1
944 
945         @return The result of the convertion
946     */
947     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public view returns (uint256) {
948         if (oracle == address(0)) {
949             return amount;
950         } else {
951             uint256 rate;
952             uint256 decimals;
953             
954             (rate, decimals) = oracle.getRate(currency, data);
955 
956             require(decimals <= RCN_DECIMALS);
957             return (safeMult(safeMult(amount, rate), (10**(RCN_DECIMALS-decimals)))) / PRECISION;
958         }
959     }
960 
961     /**
962         @notice Withdraw lender funds
963 
964         When a loan is paid, the funds are not transferred automatically to the lender, the funds are stored on the
965         engine contract, and the lender must call this function specifying the amount desired to transfer and the 
966         destination.
967 
968         @dev This behavior is defined to allow the temporary transfer of the loan to a smart contract, without worrying that
969         the contract will receive tokens that are not traceable; and it allows the development of decentralized 
970         autonomous organizations.
971 
972         @param index Index of the loan
973         @param to Destination of the wiwthdraw funds
974         @param amount Amount to withdraw, in RCN
975 
976         @return true if the withdraw was executed successfully
977     */
978     function withdrawal(uint index, address to, uint256 amount) public returns (bool) {
979         Loan storage loan = loans[index];
980         require(msg.sender == loan.lender);
981         loan.lenderBalance = safeSubtract(loan.lenderBalance, amount);
982         require(rcn.transfer(to, amount));
983         unlockTokens(rcn, amount);
984         return true;
985     }
986     
987     /**
988         @dev Deprecates the engine, locks the creation of new loans.
989     */
990     function setDeprecated(bool _deprecated) public onlyOwner {
991         deprecated = _deprecated;
992     }
993 }
994 
995 // File: contracts/utils/LrpSafeMath.sol
996 
997 library LrpSafeMath {
998     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
999         uint256 z = x + y;
1000         require((z >= x) && (z >= y));
1001         return z;
1002     }
1003 
1004     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
1005         require(x >= y);
1006         uint256 z = x - y;
1007         return z;
1008     }
1009 
1010     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
1011         uint256 z = x * y;
1012         require((x == 0)||(z/x == y));
1013         return z;
1014     }
1015 
1016     function min(uint256 a, uint256 b) internal pure returns(uint256) {
1017         if (a < b) { 
1018             return a;
1019         } else { 
1020             return b; 
1021         }
1022     }
1023     
1024     function max(uint256 a, uint256 b) internal pure returns(uint256) {
1025         if (a > b) { 
1026             return a;
1027         } else { 
1028             return b; 
1029         }
1030     }
1031 }
1032 
1033 // File: contracts/ConverterRamp.sol
1034 
1035 contract ConverterRamp is Ownable {
1036     using LrpSafeMath for uint256;
1037 
1038     address public constant ETH_ADDRESS = 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
1039     uint256 public constant AUTO_MARGIN = 1000001;
1040     // index of convert rules for pay and lend
1041     uint256 public constant I_MARGIN_SPEND = 0;    // Extra sell percent of amount, 100.000 = 100%
1042     uint256 public constant I_MAX_SPEND = 1;       // Max spend on perform a sell, 0 = maximum
1043     uint256 public constant I_REBUY_THRESHOLD = 2; // Threshold of rebuy change, 0 if want to rebuy always
1044     // index of loan parameters for pay and lend
1045     uint256 public constant I_ENGINE = 0;     // NanoLoanEngine contract
1046     uint256 public constant I_INDEX = 1;      // Loan index on Loans array of NanoLoanEngine
1047     // for pay
1048     uint256 public constant I_PAY_AMOUNT = 2; // Amount to pay of the loan
1049     uint256 public constant I_PAY_FROM = 3;   // The identity of the payer of loan
1050     // for lend
1051     uint256 public constant I_LEND_COSIGNER = 2; // Cosigner contract
1052 
1053     event RequiredRebuy(address token, uint256 amount);
1054     event Return(address token, address to, uint256 amount);
1055     event OptimalSell(address token, uint256 amount);
1056     event RequiredRcn(uint256 required);
1057     event RunAutoMargin(uint256 loops, uint256 increment);
1058 
1059     function pay(
1060         TokenConverter converter,
1061         Token fromToken,
1062         bytes32[4] loanParams,
1063         bytes oracleData,
1064         uint256[3] convertRules
1065     ) external payable returns (bool) {
1066         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
1067 
1068         uint256 initialBalance = rcn.balanceOf(this);
1069         uint256 requiredRcn = getRequiredRcnPay(loanParams, oracleData);
1070         emit RequiredRcn(requiredRcn);
1071 
1072         uint256 optimalSell = getOptimalSell(converter, fromToken, rcn, requiredRcn, convertRules[I_MARGIN_SPEND]);
1073         emit OptimalSell(fromToken, optimalSell);
1074 
1075         pullAmount(fromToken, optimalSell);
1076         uint256 bought = convertSafe(converter, fromToken, rcn, optimalSell);
1077 
1078         // Pay loan
1079         require(
1080             executeOptimalPay({
1081                 params: loanParams,
1082                 oracleData: oracleData,
1083                 rcnToPay: bought
1084             }),
1085             "Error paying the loan"
1086         );
1087 
1088         require(
1089             rebuyAndReturn({
1090                 converter: converter,
1091                 fromToken: rcn,
1092                 toToken: fromToken,
1093                 amount: rcn.balanceOf(this) - initialBalance,
1094                 spentAmount: optimalSell,
1095                 convertRules: convertRules
1096             }),
1097             "Error rebuying the tokens"
1098         );
1099 
1100         require(rcn.balanceOf(this) == initialBalance, "Converter balance has incremented");
1101         return true;
1102     }
1103 
1104     function requiredLendSell(
1105         TokenConverter converter,
1106         Token fromToken,
1107         bytes32[3] loanParams,
1108         bytes oracleData,
1109         bytes cosignerData,
1110         uint256[3] convertRules
1111     ) external view returns (uint256) {
1112         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
1113         return getOptimalSell(
1114             converter,
1115             fromToken,
1116             rcn,
1117             getRequiredRcnLend(loanParams, oracleData, cosignerData),
1118             convertRules[I_MARGIN_SPEND]
1119         );
1120     }
1121 
1122     function requiredPaySell(
1123         TokenConverter converter,
1124         Token fromToken,
1125         bytes32[4] loanParams,
1126         bytes oracleData,
1127         uint256[3] convertRules
1128     ) external view returns (uint256) {
1129         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
1130         return getOptimalSell(
1131             converter,
1132             fromToken,
1133             rcn,
1134             getRequiredRcnPay(loanParams, oracleData),
1135             convertRules[I_MARGIN_SPEND]
1136         );
1137     }
1138 
1139     function lend(
1140         TokenConverter converter,
1141         Token fromToken,
1142         bytes32[3] loanParams,
1143         bytes oracleData,
1144         bytes cosignerData,
1145         uint256[3] convertRules
1146     ) external payable returns (bool) {
1147         Token rcn = NanoLoanEngine(address(loanParams[I_ENGINE])).rcn();
1148         uint256 initialBalance = rcn.balanceOf(this);
1149         uint256 requiredRcn = getRequiredRcnLend(loanParams, oracleData, cosignerData);
1150         emit RequiredRcn(requiredRcn);
1151         
1152         uint256 optimalSell = getOptimalSell(converter, fromToken, rcn, requiredRcn, convertRules[I_MARGIN_SPEND]);
1153         emit OptimalSell(fromToken, optimalSell);
1154         
1155         pullAmount(fromToken, optimalSell);
1156         uint256 bought = convertSafe(converter, fromToken, rcn, optimalSell);
1157 
1158         // Lend loan
1159         require(rcn.approve(address(loanParams[0]), bought), "Error approving lend token transfer");
1160         require(executeLend(loanParams, oracleData, cosignerData), "Error lending the loan");
1161         require(rcn.approve(address(loanParams[0]), 0), "Error removing approve");
1162         require(executeTransfer(loanParams, msg.sender), "Error transfering the loan");
1163 
1164         require(
1165             rebuyAndReturn({
1166                 converter: converter,
1167                 fromToken: rcn,
1168                 toToken: fromToken,
1169                 amount: rcn.balanceOf(this) - initialBalance,
1170                 spentAmount: optimalSell,
1171                 convertRules: convertRules
1172             }),
1173             "Error rebuying the tokens"
1174         );
1175 
1176         require(rcn.balanceOf(this) == initialBalance, "The contract balance should not change");
1177         
1178         return true;
1179     }
1180 
1181     function pullAmount(
1182         Token token,
1183         uint256 amount
1184     ) private {
1185         if (token == ETH_ADDRESS) {
1186             require(msg.value >= amount, "Error pulling ETH amount");
1187             if (msg.value > amount) {
1188                 msg.sender.transfer(msg.value - amount);
1189             }
1190         } else {
1191             require(token.transferFrom(msg.sender, this, amount), "Error pulling Token amount");
1192         }
1193     }
1194 
1195     function transfer(
1196         Token token,
1197         address to,
1198         uint256 amount
1199     ) private {
1200         if (token == ETH_ADDRESS) {
1201             to.transfer(amount);
1202         } else {
1203             require(token.transfer(to, amount), "Error sending tokens");
1204         }
1205     }
1206 
1207     function rebuyAndReturn(
1208         TokenConverter converter,
1209         Token fromToken,
1210         Token toToken,
1211         uint256 amount,
1212         uint256 spentAmount,
1213         uint256[3] memory convertRules
1214     ) internal returns (bool) {
1215         uint256 threshold = convertRules[I_REBUY_THRESHOLD];
1216         uint256 bought = 0;
1217 
1218         if (amount != 0) {
1219             if (amount > threshold) {
1220                 bought = convertSafe(converter, fromToken, toToken, amount);
1221                 emit RequiredRebuy(toToken, amount);
1222                 emit Return(toToken, msg.sender, bought);
1223                 transfer(toToken, msg.sender, bought);
1224             } else {
1225                 emit Return(fromToken, msg.sender, amount);
1226                 transfer(fromToken, msg.sender, amount);
1227             }
1228         }
1229 
1230         uint256 maxSpend = convertRules[I_MAX_SPEND];
1231         require(spentAmount.safeSubtract(bought) <= maxSpend || maxSpend == 0, "Max spend exceeded");
1232         
1233         return true;
1234     }
1235 
1236     function getOptimalSell(
1237         TokenConverter converter,
1238         Token fromToken,
1239         Token toToken,
1240         uint256 requiredTo,
1241         uint256 extraSell
1242     ) internal returns (uint256 sellAmount) {
1243         uint256 sellRate = (10 ** 18 * converter.getReturn(toToken, fromToken, requiredTo)) / requiredTo;
1244         if (extraSell == AUTO_MARGIN) {
1245             uint256 expectedReturn = 0;
1246             uint256 optimalSell = applyRate(requiredTo, sellRate);
1247             uint256 increment = applyRate(requiredTo / 100000, sellRate);
1248             uint256 returnRebuy;
1249             uint256 cl;
1250 
1251             while (expectedReturn < requiredTo && cl < 10) {
1252                 optimalSell += increment;
1253                 returnRebuy = converter.getReturn(fromToken, toToken, optimalSell);
1254                 optimalSell = (optimalSell * requiredTo) / returnRebuy;
1255                 expectedReturn = returnRebuy;
1256                 cl++;
1257             }
1258             emit RunAutoMargin(cl, increment);
1259 
1260             return optimalSell;
1261         } else {
1262             return applyRate(requiredTo, sellRate).safeMult(uint256(100000).safeAdd(extraSell)) / 100000;
1263         }
1264     }
1265 
1266     function convertSafe(
1267         TokenConverter converter,
1268         Token fromToken,
1269         Token toToken,
1270         uint256 amount
1271     ) internal returns (uint256 bought) {
1272         if (fromToken != ETH_ADDRESS) require(fromToken.approve(converter, amount), "Error approving token transfer");
1273         uint256 prevBalance = toToken != ETH_ADDRESS ? toToken.balanceOf(this) : address(this).balance;
1274         uint256 sendEth = fromToken == ETH_ADDRESS ? amount : 0;
1275         uint256 boughtAmount = converter.convert.value(sendEth)(fromToken, toToken, amount, 1);
1276         require(
1277             boughtAmount == (toToken != ETH_ADDRESS ? toToken.balanceOf(this) : address(this).balance) - prevBalance,
1278             "Bought amound does does not match"
1279         );
1280         if (fromToken != ETH_ADDRESS) require(fromToken.approve(converter, 0), "Error removing token approve");
1281         return boughtAmount;
1282     }
1283 
1284     function executeOptimalPay(
1285         bytes32[4] memory params,
1286         bytes oracleData,
1287         uint256 rcnToPay
1288     ) internal returns (bool) {
1289         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1290         uint256 index = uint256(params[I_INDEX]);
1291         Oracle oracle = engine.getOracle(index);
1292 
1293         uint256 toPay;
1294 
1295         if (oracle == address(0)) {
1296             toPay = rcnToPay;
1297         } else {
1298             uint256 rate;
1299             uint256 decimals;
1300             bytes32 currency = engine.getCurrency(index);
1301 
1302             (rate, decimals) = oracle.getRate(currency, oracleData);
1303             toPay = ((rcnToPay * 1000000000000000000) / rate) / 10 ** (18 - decimals);
1304         }
1305 
1306         Token rcn = engine.rcn();
1307         require(rcn.approve(engine, rcnToPay), "Error on payment approve");
1308         require(engine.pay(index, toPay, address(params[I_PAY_FROM]), oracleData), "Error paying the loan");
1309         require(rcn.approve(engine, 0), "Error removing the payment approve");
1310         
1311         return true;
1312     }
1313 
1314     function executeLend(
1315         bytes32[3] memory params,
1316         bytes oracleData,
1317         bytes cosignerData
1318     ) internal returns (bool) {
1319         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1320         uint256 index = uint256(params[I_INDEX]);
1321         return engine.lend(index, oracleData, Cosigner(address(params[I_LEND_COSIGNER])), cosignerData);
1322     }
1323 
1324     function executeTransfer(
1325         bytes32[3] memory params,
1326         address to
1327     ) internal returns (bool) {
1328         return NanoLoanEngine(address(params[I_ENGINE])).transfer(to, uint256(params[1]));
1329     }
1330 
1331     function applyRate(
1332         uint256 amount,
1333         uint256 rate
1334     ) internal pure returns (uint256) {
1335         return amount.safeMult(rate) / 10 ** 18;
1336     }
1337 
1338     function getRequiredRcnLend(
1339         bytes32[3] memory params,
1340         bytes oracleData,
1341         bytes cosignerData
1342     ) internal view returns (uint256 required) {
1343         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1344         uint256 index = uint256(params[I_INDEX]);
1345         Cosigner cosigner = Cosigner(address(params[I_LEND_COSIGNER]));
1346 
1347         if (cosigner != address(0)) {
1348             required += cosigner.cost(engine, index, cosignerData, oracleData);
1349         }
1350         required += engine.convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, engine.getAmount(index));
1351     }
1352     
1353     function getRequiredRcnPay(
1354         bytes32[4] memory params,
1355         bytes oracleData
1356     ) internal view returns (uint256) {
1357         NanoLoanEngine engine = NanoLoanEngine(address(params[I_ENGINE]));
1358         uint256 index = uint256(params[I_INDEX]);
1359         uint256 amount = uint256(params[I_PAY_AMOUNT]);
1360         return engine.convertRate(engine.getOracle(index), engine.getCurrency(index), oracleData, amount);
1361     }
1362 
1363     function withdrawTokens(
1364         Token _token,
1365         address _to,
1366         uint256 _amount
1367     ) external onlyOwner returns (bool) {
1368         return _token.transfer(_to, _amount);
1369     }
1370 
1371     function withdrawEther(
1372         address _to,
1373         uint256 _amount
1374     ) external onlyOwner {
1375         _to.transfer(_amount);
1376     }
1377 
1378     function() external payable {}
1379     
1380 }