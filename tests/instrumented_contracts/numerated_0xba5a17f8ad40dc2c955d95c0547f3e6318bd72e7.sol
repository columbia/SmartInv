1 pragma solidity ^0.4.24;
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
260     uint256 public constant VERSION = 233;
261     string public constant VERSION_NAME = "Basalt";
262 
263     uint256 private activeLoans = 0;
264     mapping(address => uint256) private lendersBalance;
265 
266     function name() public view returns (string _name) {
267         _name = "RCN - Nano loan engine - Basalt 233";
268     }
269 
270     function symbol() public view returns (string _symbol) {
271         _symbol = "RCN-NLE-233";
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
297         @notice Returns all the loans that a lender possess
298         @dev This method MUST NEVER be called by smart contract code; 
299             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
300 
301         @param _owner The owner address
302 
303         @return ownerTokens List of all the loans of the _owner
304     */
305     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
306         uint256 tokenCount = balanceOf(_owner);
307 
308         if (tokenCount == 0) {
309             // Return an empty array
310             return new uint256[](0);
311         } else {
312             uint256[] memory result = new uint256[](tokenCount);
313             uint256 totalLoans = loans.length - 1;
314             uint256 resultIndex = 0;
315 
316             uint256 loanId;
317 
318             for (loanId = 0; loanId <= totalLoans; loanId++) {
319                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
320                     result[resultIndex] = loanId;
321                     resultIndex++;
322                 }
323             }
324 
325             return result;
326         }
327     }
328 
329     /**
330         @notice Returns true if the _operator can transfer the loans of the _owner
331 
332         @dev Required for ERC-721 compliance 
333     */
334     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
335         return operators[_owner][_operator];
336     }
337 
338     /**
339         @notice Returns the loan metadata, this field can be set by the creator of the loan with his own criteria.
340 
341         @param index Index of the loan
342 
343         @return The string with the metadata
344     */
345     function tokenMetadata(uint256 index) public view returns (string) {
346         return loans[index].metadata;
347     }
348 
349     /**
350         @notice Returns the loan metadata, hashed with keccak256.
351         @dev This emthod is useful to evaluate metadata from a smart contract.
352 
353         @param index Index of the loan
354 
355         @return The metadata hashed with keccak256
356     */
357     function tokenMetadataHash(uint256 index) public view returns (bytes32) {
358         return keccak256(loans[index].metadata);
359     }
360 
361     Token public rcn;
362     bool public deprecated;
363 
364     event CreatedLoan(uint _index, address _borrower, address _creator);
365     event ApprovedBy(uint _index, address _address);
366     event Lent(uint _index, address _lender, address _cosigner);
367     event DestroyedBy(uint _index, address _address);
368     event PartialPayment(uint _index, address _sender, address _from, uint256 _amount);
369     event TotalPayment(uint _index);
370 
371     function NanoLoanEngine(Token _rcn) public {
372         owner = msg.sender;
373         rcn = _rcn;
374         // The loan 0 is a Invalid loan
375         loans.length++;
376     }
377 
378     struct Loan {
379         Status status;
380         Oracle oracle;
381 
382         address borrower;
383         address lender;
384         address creator;
385         address cosigner;
386         
387         uint256 amount;
388         uint256 interest;
389         uint256 punitoryInterest;
390         uint256 interestTimestamp;
391         uint256 paid;
392         uint256 interestRate;
393         uint256 interestRatePunitory;
394         uint256 dueTime;
395         uint256 duesIn;
396 
397         bytes32 currency;
398         uint256 cancelableAt;
399         uint256 lenderBalance;
400 
401         address approvedTransfer;
402         uint256 expirationRequest;
403 
404         string metadata;
405         mapping(address => bool) approbations;
406     }
407 
408     mapping(address => mapping(address => bool)) private operators;
409 
410     mapping(bytes32 => uint256) public identifierToIndex;
411     Loan[] private loans;
412 
413     /**
414         @notice Creates a loan request, the loan can be generated with any borrower and conditions; if the borrower agrees
415         it must call the "approve" function. If the creator of the loan is the borrower the approve is done automatically.
416 
417         @dev The creator of the loan is the caller of this function; this is useful to track which wallet created the loan.
418             Two identical loans cannot exist, a clone of another loan will fail.
419 
420         @param _oracleContract Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
421         @param _borrower Address of the borrower
422         @param _currency The currency to use with the oracle, the currency code is generated with the following formula,
423             keccak256(ticker), is always stored as the minimum divisible amount. (Ej: ETH Wei, USD Cents)
424         @param _amount The requested amount; currency and unit are defined by the Oracle, if there is no Oracle present
425             the currency is RCN, and the unit is wei.
426         @param _interestRate The non-punitory interest rate by second, defined as a denominator of 10 000 000.
427         @param _interestRatePunitory The punitory interest rate by second, defined as a denominator of 10 000 000.
428             Ej: interestRate 11108571428571 = 28% Anual interest
429         @param _duesIn The time in seconds that the borrower has in order to pay the debt after the lender lends the money.
430         @param _cancelableAt Delta in seconds specifying how much interest should be added in advance, if the borrower pays 
431         entirely or partially the loan before this term, no extra interest will be deducted.
432         @param _expirationRequest Timestamp of when the loan request expires, if the loan is not filled before this date, 
433             the request is no longer valid.
434         @param _metadata String with loan metadata.
435     */
436     function createLoan(Oracle _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
437         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256) {
438 
439         require(!deprecated);
440         require(_cancelableAt <= _duesIn);
441         require(_oracleContract != address(0) || _currency == 0x0);
442         require(_borrower != address(0));
443         require(_amount != 0);
444         require(_interestRatePunitory != 0);
445         require(_interestRate != 0);
446         require(_expirationRequest > block.timestamp);
447 
448         var loan = Loan(Status.initial, _oracleContract, _borrower, 0x0, msg.sender, 0x0, _amount, 0, 0, 0, 0, _interestRate,
449             _interestRatePunitory, 0, _duesIn, _currency, _cancelableAt, 0, 0x0, _expirationRequest, _metadata);
450 
451         uint index = loans.push(loan) - 1;
452         CreatedLoan(index, _borrower, msg.sender);
453 
454         bytes32 identifier = getIdentifier(index);
455         require(identifierToIndex[identifier] == 0);
456         identifierToIndex[identifier] = index;
457 
458         if (msg.sender == _borrower) {
459             approveLoan(index);
460         }
461 
462         return index;
463     }
464     
465     function ownerOf(uint256 index) public view returns (address owner) { owner = loans[index].lender; }
466     function getTotalLoans() public view returns (uint256) { return loans.length; }
467     function getOracle(uint index) public view returns (Oracle) { return loans[index].oracle; }
468     function getBorrower(uint index) public view returns (address) { return loans[index].borrower; }
469     function getCosigner(uint index) public view returns (address) { return loans[index].cosigner; }
470     function getCreator(uint index) public view returns (address) { return loans[index].creator; }
471     function getAmount(uint index) public view returns (uint256) { return loans[index].amount; }
472     function getPunitoryInterest(uint index) public view returns (uint256) { return loans[index].punitoryInterest; }
473     function getInterestTimestamp(uint index) public view returns (uint256) { return loans[index].interestTimestamp; }
474     function getPaid(uint index) public view returns (uint256) { return loans[index].paid; }
475     function getInterestRate(uint index) public view returns (uint256) { return loans[index].interestRate; }
476     function getInterestRatePunitory(uint index) public view returns (uint256) { return loans[index].interestRatePunitory; }
477     function getDueTime(uint index) public view returns (uint256) { return loans[index].dueTime; }
478     function getDuesIn(uint index) public view returns (uint256) { return loans[index].duesIn; }
479     function getCancelableAt(uint index) public view returns (uint256) { return loans[index].cancelableAt; }
480     function getApprobation(uint index, address _address) public view returns (bool) { return loans[index].approbations[_address]; }
481     function getStatus(uint index) public view returns (Status) { return loans[index].status; }
482     function getLenderBalance(uint index) public view returns (uint256) { return loans[index].lenderBalance; }
483     function getApproved(uint index) public view returns (address) {return loans[index].approvedTransfer; }
484     function getCurrency(uint index) public view returns (bytes32) { return loans[index].currency; }
485     function getExpirationRequest(uint index) public view returns (uint256) { return loans[index].expirationRequest; }
486     function getInterest(uint index) public view returns (uint256) { return loans[index].interest; }
487 
488     function getIdentifier(uint index) public view returns (bytes32) {
489         Loan memory loan = loans[index];
490         return buildIdentifier(loan.oracle, loan.borrower, loan.creator, loan.currency, loan.amount, loan.interestRate,
491             loan.interestRatePunitory, loan.duesIn, loan.cancelableAt, loan.expirationRequest, loan.metadata);
492     }
493 
494     /**
495         @notice Used to reference a loan that is not yet created, and by that does not have an index
496 
497         @dev Two identical loans cannot exist, only one loan per signature is allowed
498 
499         @return The signature hash of the loan configuration
500     */
501     function buildIdentifier(Oracle oracle, address borrower, address creator, bytes32 currency, uint256 amount, uint256 interestRate,
502         uint256 interestRatePunitory, uint256 duesIn, uint256 cancelableAt, uint256 expirationRequest, string metadata) view returns (bytes32) {
503         return keccak256(this, oracle, borrower, creator, currency, amount, interestRate, interestRatePunitory, duesIn,
504                         cancelableAt, expirationRequest, metadata); 
505     }
506 
507     /**
508         @notice Used to know if a loan is ready to lend
509 
510         @param index Index of the loan
511 
512         @return true if the loan has been approved by the borrower and cosigner.
513     */
514     function isApproved(uint index) public view returns (bool) {
515         Loan storage loan = loans[index];
516         return loan.approbations[loan.borrower];
517     }
518 
519     /**
520         @notice Called by the members of the loan to show that they agree with the terms of the loan; the borrower
521         must call this method before any lender could call the method "lend".
522             
523         @dev Any address can call this method to be added to the "approbations" mapping.
524 
525         @param index Index of the loan
526 
527         @return true if the approve was done successfully
528     */
529     function approveLoan(uint index) public returns(bool) {
530         Loan storage loan = loans[index];
531         require(loan.status == Status.initial);
532         loan.approbations[msg.sender] = true;
533         ApprovedBy(index, msg.sender);
534         return true;
535     }
536 
537     /**
538         @notice Approves a loan using the Identifier and not the index
539 
540         @param identifier Identifier of the loan
541 
542         @return true if the approve was done successfully
543     */
544     function approveLoanIdentifier(bytes32 identifier) public returns (bool) {
545         uint256 index = identifierToIndex[identifier];
546         require(index != 0);
547         return approveLoan(index);
548     }
549 
550     /**
551         @notice Register an approvation made by a borrower in the past
552 
553         @dev The loan should exist and have an index
554 
555         @param identifier Identifier of the loan
556 
557         @return true if the approve was done successfully
558     */
559     function registerApprove(bytes32 identifier, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
560         uint256 index = identifierToIndex[identifier];
561         require(index != 0);
562         Loan storage loan = loans[index];
563         require(loan.borrower == ecrecover(keccak256("\x19Ethereum Signed Message:\n32", identifier), v, r, s));
564         loan.approbations[loan.borrower] = true;
565         ApprovedBy(index, loan.borrower);
566         return true;
567     }
568 
569     /**
570         @notice Performs the lend of the RCN equivalent to the requested amount, and transforms the msg.sender in the new lender.
571 
572         @dev The loan must be previously approved by the borrower; before calling this function, the lender candidate must 
573         call the "approve" function on the RCN Token, specifying an amount sufficient enough to pay the equivalent of
574         the requested amount, and the cosigner fee.
575         
576         @param index Index of the loan
577         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
578             by the url exposed in the url() method of the oracle.
579         @param cosigner Address of the cosigner, 0x0 for lending without cosigner.
580         @param cosignerData Data required by the cosigner to process the request.
581 
582         @return true if the lend was done successfully
583     */
584     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool) {
585         Loan storage loan = loans[index];
586 
587         require(loan.status == Status.initial);
588         require(isApproved(index));
589         require(block.timestamp <= loan.expirationRequest);
590 
591         loan.lender = msg.sender;
592         loan.dueTime = safeAdd(block.timestamp, loan.duesIn);
593         loan.interestTimestamp = block.timestamp;
594         loan.status = Status.lent;
595 
596         // ERC721, create new loan and transfer it to the lender
597         Transfer(0x0, loan.lender, index);
598         activeLoans += 1;
599         lendersBalance[loan.lender] += 1;
600         
601         if (loan.cancelableAt > 0)
602             internalAddInterest(loan, safeAdd(block.timestamp, loan.cancelableAt));
603 
604         // Transfer the money to the borrower before handling the cosigner
605         // so the cosigner could require a specific usage for that money.
606         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, loan.amount);
607         require(rcn.transferFrom(msg.sender, loan.borrower, transferValue));
608         
609         if (cosigner != address(0)) {
610             // The cosigner it's temporary set to the next address (cosigner + 2), it's expected that the cosigner will
611             // call the method "cosign" to accept the conditions; that method also sets the cosigner to the right
612             // address. If that does not happen, the transaction fails.
613             loan.cosigner = address(uint256(cosigner) + 2);
614             require(cosigner.requestCosign(this, index, cosignerData, oracleData));
615             require(loan.cosigner == address(cosigner));
616         }
617                 
618         Lent(index, loan.lender, cosigner);
619 
620         return true;
621     }
622 
623     /**
624         @notice The cosigner must call this method to accept the conditions of a loan, this method pays the cosigner his fee.
625         
626         @dev If the cosigner does not call this method the whole "lend" call fails.
627 
628         @param index Index of the loan
629         @param cost Fee set by the cosigner
630 
631         @return true If the cosign was successfull
632     */
633     function cosign(uint index, uint256 cost) external returns (bool) {
634         Loan storage loan = loans[index];
635         require(loan.status == Status.lent && (loan.dueTime - loan.duesIn) == block.timestamp);
636         require(loan.cosigner != address(0));
637         require(loan.cosigner == address(uint256(msg.sender) + 2));
638         loan.cosigner = msg.sender;
639         require(rcn.transferFrom(loan.lender, msg.sender, cost));
640         return true;
641     }
642 
643     /**
644         @notice Destroys a loan, the borrower could call this method if they performed an accidental or regretted 
645         "approve" of the loan, this method only works for them if the loan is in "pending" status.
646 
647         The lender can call this method at any moment, in case of a loan with status "lent" the lender is pardoning 
648         the debt. 
649 
650         @param index Index of the loan
651 
652         @return true if the destroy was done successfully
653     */
654     function destroy(uint index) public returns (bool) {
655         Loan storage loan = loans[index];
656         require(loan.status != Status.destroyed);
657         require(msg.sender == loan.lender || (msg.sender == loan.borrower && loan.status == Status.initial));
658         DestroyedBy(index, msg.sender);
659 
660         // ERC721, remove loan from circulation
661         if (loan.status != Status.initial) {
662             lendersBalance[loan.lender] -= 1;
663             activeLoans -= 1;
664             Transfer(loan.lender, 0x0, index);
665         }
666 
667         loan.status = Status.destroyed;
668         return true;
669     }
670 
671     /**
672         @notice Destroys a loan using the signature and not the Index
673 
674         @param identifier Identifier of the loan
675 
676         @return true if the destroy was done successfully
677     */
678     function destroyIdentifier(bytes32 identifier) public returns (bool) {
679         uint256 index = identifierToIndex[identifier];
680         require(index != 0);
681         return destroy(index);
682     }
683 
684     /**
685         @notice Transfers a loan to a different lender, the caller must be the current lender or previously being
686         approved with the method "approveTransfer"; only loans with the Status.lent status can be transfered.
687 
688         @dev Required for ERC-721 compliance
689 
690         @param index Index of the loan
691         @param to New lender
692 
693         @return true if the transfer was done successfully
694     */
695     function transfer(address to, uint256 index) public returns (bool) {
696         Loan storage loan = loans[index];
697         
698         require(msg.sender == loan.lender || msg.sender == loan.approvedTransfer || operators[loan.lender][msg.sender]);
699         require(to != address(0));
700 
701         // ERC721, transfer loan to another address
702         lendersBalance[loan.lender] -= 1;
703         lendersBalance[to] += 1;
704         Transfer(loan.lender, to, index);
705 
706         loan.lender = to;
707         loan.approvedTransfer = address(0);
708 
709         return true;
710     }
711 
712     /**
713         @notice Transfers the loan to the msg.sender, the msg.sender must be approved using the "approve" method.
714 
715         @dev Required for ERC-721 compliance
716 
717         @param _index Index of the loan
718 
719         @return true if the transfer was successfull
720     */
721     function takeOwnership(uint256 _index) public returns (bool) {
722         return transfer(msg.sender, _index);
723     }
724 
725     /**
726         @notice Transfers the loan to an address, only if the current owner is the "from" address
727 
728         @dev Required for ERC-721 compliance
729 
730         @param from Current owner of the loan
731         @param to New owner of the loan
732         @param index Index of the loan
733 
734         @return true if the transfer was successfull
735     */
736     function transferFrom(address from, address to, uint256 index) public returns (bool) {
737         require(loans[index].lender == from);
738         return transfer(to, index);
739     }
740 
741     /**
742         @notice Approves the transfer of a given loan in the name of the lender, the behavior of this function is similar to
743         "approve" in the ERC20 standard, but only one approved address is allowed at a time.
744 
745         The same method can be called passing 0x0 as parameter "to" to erase a previously approved address.
746 
747         @dev Required for ERC-721 compliance
748 
749         @param to Address allowed to transfer the loan or 0x0 to delete
750         @param index Index of the loan
751 
752         @return true if the approve was done successfully
753     */
754     function approve(address to, uint256 index) public returns (bool) {
755         Loan storage loan = loans[index];
756         require(msg.sender == loan.lender);
757         loan.approvedTransfer = to;
758         Approval(msg.sender, to, index);
759         return true;
760     }
761 
762     /**
763         @notice Enable or disable approval for a third party ("operator") to manage
764 
765         @param _approved True if the operator is approved, false to revoke approval
766         @param _operator Address to add to the set of authorized operators.
767     */
768     function setApprovalForAll(address _operator, bool _approved) public returns (bool) {
769         operators[msg.sender][_operator] = _approved;
770         ApprovalForAll(msg.sender, _operator, _approved);
771         return true;
772     }
773 
774     /**
775         @notice Returns the pending amount to complete de payment of the loan, keep in mind that this number increases 
776         every second.
777 
778         @dev This method also computes the interest and updates the loan
779 
780         @param index Index of the loan
781 
782         @return Aprox pending payment amount
783     */
784     function getPendingAmount(uint index) public returns (uint256) {
785         addInterest(index);
786         return getRawPendingAmount(index);
787     }
788 
789     /**
790         @notice Returns the pending amount up to the last time of the interest update. This is not the real pending amount
791 
792         @dev This method is exact only if "addInterest(loan)" was before and in the same block.
793 
794         @param index Index of the loan
795 
796         @return The past pending amount
797     */
798     function getRawPendingAmount(uint index) public view returns (uint256) {
799         Loan memory loan = loans[index];
800         return safeSubtract(safeAdd(safeAdd(loan.amount, loan.interest), loan.punitoryInterest), loan.paid);
801     }
802 
803     /**
804         @notice Calculates the interest of a given amount, interest rate and delta time.
805 
806         @param timeDelta Elapsed time
807         @param interestRate Interest rate expressed as the denominator of 10 000 000.
808         @param amount Amount to apply interest
809 
810         @return realDelta The real timeDelta applied
811         @return interest The interest gained in the realDelta time
812     */
813     function calculateInterest(uint256 timeDelta, uint256 interestRate, uint256 amount) internal pure returns (uint256 realDelta, uint256 interest) {
814         if (amount == 0) {
815             interest = 0;
816             realDelta = timeDelta;
817         } else {
818             interest = safeMult(safeMult(100000, amount), timeDelta) / interestRate;
819             realDelta = safeMult(interest, interestRate) / (amount * 100000);
820         }
821     }
822 
823     /**
824         @notice Computes loan interest
825 
826         Computes the punitory and non-punitory interest of a given loan and only applies the change.
827         
828         @param loan Loan to compute interest
829         @param timestamp Target absolute unix time to calculate interest.
830     */
831     function internalAddInterest(Loan storage loan, uint256 timestamp) internal {
832         if (timestamp > loan.interestTimestamp) {
833             uint256 newInterest = loan.interest;
834             uint256 newPunitoryInterest = loan.punitoryInterest;
835 
836             uint256 newTimestamp;
837             uint256 realDelta;
838             uint256 calculatedInterest;
839 
840             uint256 deltaTime;
841             uint256 pending;
842 
843             uint256 endNonPunitory = min(timestamp, loan.dueTime);
844             if (endNonPunitory > loan.interestTimestamp) {
845                 deltaTime = endNonPunitory - loan.interestTimestamp;
846 
847                 if (loan.paid < loan.amount) {
848                     pending = loan.amount - loan.paid;
849                 } else {
850                     pending = 0;
851                 }
852 
853                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRate, pending);
854                 newInterest = safeAdd(calculatedInterest, newInterest);
855                 newTimestamp = loan.interestTimestamp + realDelta;
856             }
857 
858             if (timestamp > loan.dueTime) {
859                 uint256 startPunitory = max(loan.dueTime, loan.interestTimestamp);
860                 deltaTime = timestamp - startPunitory;
861 
862                 uint256 debt = safeAdd(loan.amount, newInterest);
863                 pending = min(debt, safeSubtract(safeAdd(debt, newPunitoryInterest), loan.paid));
864 
865                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRatePunitory, pending);
866                 newPunitoryInterest = safeAdd(newPunitoryInterest, calculatedInterest);
867                 newTimestamp = startPunitory + realDelta;
868             }
869             
870             if (newInterest != loan.interest || newPunitoryInterest != loan.punitoryInterest) {
871                 loan.interestTimestamp = newTimestamp;
872                 loan.interest = newInterest;
873                 loan.punitoryInterest = newPunitoryInterest;
874             }
875         }
876     }
877 
878     /**
879         @notice Updates the loan accumulated interests up to the current Unix time.
880         
881         @param index Index of the loan
882     
883         @return true If the interest was updated
884     */
885     function addInterest(uint index) public returns (bool) {
886         Loan storage loan = loans[index];
887         require(loan.status == Status.lent);
888         internalAddInterest(loan, block.timestamp);
889     }
890     
891     /**
892         @notice Pay loan
893 
894         Does a payment of a given Loan, before performing the payment the accumulated
895         interest is computed and added to the total pending amount.
896 
897         Before calling this function, the msg.sender must call the "approve" function on the RCN Token, specifying an amount
898         sufficient enough to pay the equivalent of the desired payment and the oracle fee.
899 
900         If the paid pending amount equals zero, the loan changes status to "paid" and it is considered closed.
901 
902         @dev Because it is difficult or even impossible to know in advance how much RCN are going to be spent on the
903         transaction*, we recommend performing the "approve" using an amount 5% superior to the wallet estimated
904         spending. If the RCN spent results to be less, the extra tokens are never debited from the msg.sender.
905 
906         * The RCN rate can fluctuate on the same block, and it is impossible to know in advance the exact time of the
907         confirmation of the transaction. 
908 
909         @param index Index of the loan
910         @param _amount Amount to pay, specified in the loan currency; or in RCN if the loan has no oracle
911         @param _from The identity of the payer
912         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
913             by the url exposed in the url() method of the oracle.
914             
915         @return true if the payment was executed successfully
916     */
917     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool) {
918         Loan storage loan = loans[index];
919 
920         require(loan.status == Status.lent);
921         addInterest(index);
922         uint256 toPay = min(getPendingAmount(index), _amount);
923         PartialPayment(index, msg.sender, _from, toPay);
924 
925         loan.paid = safeAdd(loan.paid, toPay);
926 
927         if (getRawPendingAmount(index) == 0) {
928             TotalPayment(index);
929             loan.status = Status.paid;
930 
931             // ERC721, remove loan from circulation
932             lendersBalance[loan.lender] -= 1;
933             activeLoans -= 1;
934             Transfer(loan.lender, 0x0, index);
935         }
936 
937         uint256 transferValue = convertRate(loan.oracle, loan.currency, oracleData, toPay);
938         require(transferValue > 0 || toPay < _amount);
939 
940         lockTokens(rcn, transferValue);
941         require(rcn.transferFrom(msg.sender, this, transferValue));
942         loan.lenderBalance = safeAdd(transferValue, loan.lenderBalance);
943 
944         return true;
945     }
946 
947     /**
948         @notice Converts an amount to RCN using the loan oracle.
949         
950         @dev If the loan has no oracle the currency must be RCN so the rate is 1
951 
952         @return The result of the convertion
953     */
954     function convertRate(Oracle oracle, bytes32 currency, bytes data, uint256 amount) public returns (uint256) {
955         if (oracle == address(0)) {
956             return amount;
957         } else {
958             uint256 rate;
959             uint256 decimals;
960             
961             (rate, decimals) = oracle.getRate(currency, data);
962 
963             require(decimals <= RCN_DECIMALS);
964             return (safeMult(safeMult(amount, rate), (10**(RCN_DECIMALS-decimals)))) / PRECISION;
965         }
966     }
967 
968     /**
969         @notice Withdraw lender funds
970 
971         When a loan is paid, the funds are not transferred automatically to the lender, the funds are stored on the
972         engine contract, and the lender must call this function specifying the amount desired to transfer and the 
973         destination.
974 
975         @dev This behavior is defined to allow the temporary transfer of the loan to a smart contract, without worrying that
976         the contract will receive tokens that are not traceable; and it allows the development of decentralized 
977         autonomous organizations.
978 
979         @param index Index of the loan
980         @param to Destination of the wiwthdraw funds
981         @param amount Amount to withdraw, in RCN
982 
983         @return true if the withdraw was executed successfully
984     */
985     function withdrawal(uint index, address to, uint256 amount) public returns (bool) {
986         Loan storage loan = loans[index];
987         require(msg.sender == loan.lender);
988         loan.lenderBalance = safeSubtract(loan.lenderBalance, amount);
989         require(rcn.transfer(to, amount));
990         unlockTokens(rcn, amount);
991         return true;
992     }
993 
994     /**
995         @notice Withdraw lender funds in batch, it walks by all the loans passed to the function and withdraws all
996         the funds stored on that loans.
997 
998         @dev This batch withdraw method can be expensive in gas, it must be used with care.
999 
1000         @param loanIds Array of the loans to withdraw
1001         @param to Destination of the tokens
1002 
1003         @return the total withdrawed 
1004     */
1005     function withdrawalList(uint256[] memory loanIds, address to) public returns (uint256) {
1006         uint256 inputId;
1007         uint256 totalWithdraw = 0;
1008 
1009         for (inputId = 0; inputId < loanIds.length; inputId++) {
1010             Loan storage loan = loans[loanIds[inputId]];
1011             if (loan.lender == msg.sender) {
1012                 totalWithdraw += loan.lenderBalance;
1013                 loan.lenderBalance = 0;
1014             }
1015         }
1016 
1017         require(rcn.transfer(to, totalWithdraw));
1018         unlockTokens(rcn, totalWithdraw);
1019 
1020         return totalWithdraw;
1021     }
1022 
1023     /**
1024         @dev Deprecates the engine, locks the creation of new loans.
1025     */
1026     function setDeprecated(bool _deprecated) public onlyOwner {
1027         deprecated = _deprecated;
1028     }
1029 }