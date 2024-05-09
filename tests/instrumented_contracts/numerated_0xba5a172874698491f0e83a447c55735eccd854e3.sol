1 pragma solidity ^0.4.19;
2 
3 contract ERC721 {
4    // ERC20 compatible functions
5    function name() public view returns (string _name);
6    function symbol() public view returns (string _symbol);
7    function totalSupply() public view returns (uint256 _totalSupply);
8    function balanceOf(address _owner) public view returns (uint _balance);
9    // Functions that define ownership
10    function ownerOf(uint256) public view returns (address owner);
11    function approve(address, uint256) public returns (bool);
12    function takeOwnership(uint256) public returns (bool);
13    function transfer(address, uint256) public returns (bool);
14    function getApproved(uint256 _tokenId) public view returns (address);
15    // Token metadata
16    function tokenMetadata(uint256 _tokenId) public view returns (string info);
17    // Events
18    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
19    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
20 }
21 
22 contract Token {
23     function transfer(address _to, uint _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
26     function approve(address _spender, uint256 _value) public returns (bool success);
27     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
28     function balanceOf(address _owner) public view returns (uint256 balance);
29 }
30 
31 /**
32     @dev Defines the interface of a standard RCN cosigner.
33 
34     The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
35     of the insurance and the cost of the given are defined by the cosigner. 
36 
37     The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
38     agent should be passed as params when the lender calls the "lend" method on the engine.
39     
40     When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
41     should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
42     call this method, like the transfer of the ownership of the loan.
43 */
44 contract Cosigner {
45     uint256 public constant VERSION = 2;
46     
47     /**
48         @return the url of the endpoint that exposes the insurance offers.
49     */
50     function url() public view returns (string);
51     
52     /**
53         @dev Retrieves the cost of a given insurance, this amount should be exact.
54 
55         @return the cost of the cosign, in RCN wei
56     */
57     function cost(address engine, uint256 index, bytes data, bytes oracleData) public view returns (uint256);
58     
59     /**
60         @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
61         the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
62         does not return true to this method, the operation fails.
63 
64         @return true if the cosigner accepts the liability
65     */
66     function requestCosign(Engine engine, uint256 index, bytes data, bytes oracleData) public returns (bool);
67     
68     /**
69         @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
70         current lender of the loan.
71 
72         @return true if the claim was done correctly.
73     */
74     function claim(address engine, uint256 index, bytes oracleData) public returns (bool);
75 }
76 
77 contract Ownable {
78     address public owner;
79 
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function Ownable() public {
86         owner = msg.sender; 
87     }
88 
89     /**
90         @dev Transfers the ownership of the contract.
91 
92         @param _to Address of the new owner
93     */
94     function transferTo(address _to) public onlyOwner returns (bool) {
95         require(_to != address(0));
96         owner = _to;
97         return true;
98     } 
99 } 
100 
101 /**
102     @dev Defines the interface of a standard RCN oracle.
103 
104     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
105     it's primarily used by the exchange but could be used by any other agent.
106 */
107 contract Oracle is Ownable {
108     uint256 public constant VERSION = 2;
109 
110     event NewSymbol(bytes32 _currency, string _ticker, uint8 _decimals);
111     
112     struct Symbol {
113         string ticker;
114         uint8 decimals;
115         bool supported;
116     }
117 
118     mapping(bytes32 => Symbol) public currencies;
119 
120     /**
121         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
122     */
123     function url() public view returns (string);
124 
125     /**
126         @dev Returns a valid convertion rate from the currency given to RCN
127 
128         @param symbol Symbol of the currency
129         @param data Generic data field, could be used for off-chain signing
130     */
131     function getRate(bytes32 symbol, bytes data) public returns (uint256);
132 
133     /**
134         @dev Adds a currency to the oracle, once added it cannot be removed
135 
136         @param ticker Symbol of the currency
137         @param decimals Decimals of the convertion
138 
139         @return the hash of the currency, calculated keccak256(ticker, decimals)
140     */
141     function addCurrency(string ticker, uint8 decimals) public onlyOwner returns (bytes32) {
142         NewSymbol(currency, ticker, decimals);
143         bytes32 currency = keccak256(ticker, decimals);
144         currencies[currency] = Symbol(ticker, decimals, true);
145         return currency;
146     }
147 
148     /**
149         @return The number of decimals of a given currency hash, only if registered
150     */
151     function decimals(bytes32 symbol) public view returns (uint8) {
152         return currencies[symbol].decimals;
153     }
154 
155     /**
156         @return true If the currency is supported
157     */
158     function supported(bytes32 symbol) public view returns (bool) {
159         return currencies[symbol].supported;
160     }
161 }
162 
163 contract Engine {
164     uint256 public VERSION;
165     string public VERSION_NAME;
166 
167     enum Status { initial, lent, paid, destroyed }
168     struct Approbation {
169         bool approved;
170         bytes data;
171         bytes32 checksum;
172     }
173 
174     function getTotalLoans() public view returns (uint256);
175     function getOracle(uint index) public view returns (Oracle);
176     function getBorrower(uint index) public view returns (address);
177     function getCosigner(uint index) public view returns (address);
178     function ownerOf(uint256) public view returns (address owner);
179     function getCreator(uint index) public view returns (address);
180     function getAmount(uint index) public view returns (uint256);
181     function getPaid(uint index) public view returns (uint256);
182     function getDueTime(uint index) public view returns (uint256);
183     function getApprobation(uint index, address _address) public view returns (bool);
184     function getStatus(uint index) public view returns (Status);
185     function isApproved(uint index) public view returns (bool);
186     function getPendingAmount(uint index) public returns (uint256);
187     function getCurrency(uint index) public view returns (bytes32);
188     function cosign(uint index, uint256 cost) external returns (bool);
189     function approveLoan(uint index) public returns (bool);
190     function transfer(address to, uint256 index) public returns (bool);
191     function takeOwnership(uint256 index) public returns (bool);
192     function withdrawal(uint index, address to, uint256 amount) public returns (bool);
193 }
194 
195 contract RpSafeMath {
196     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
197       uint256 z = x + y;
198       require((z >= x) && (z >= y));
199       return z;
200     }
201 
202     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
203       require(x >= y);
204       uint256 z = x - y;
205       return z;
206     }
207 
208     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
209       uint256 z = x * y;
210       require((x == 0)||(z/x == y));
211       return z;
212     }
213 
214     function min(uint256 a, uint256 b) internal pure returns(uint256) {
215         if (a < b) { 
216           return a;
217         } else { 
218           return b; 
219         }
220     }
221     
222     function max(uint256 a, uint256 b) internal pure returns(uint256) {
223         if (a > b) { 
224           return a;
225         } else { 
226           return b; 
227         }
228     }
229 }
230 
231 contract TokenLockable is RpSafeMath, Ownable {
232     mapping(address => uint256) public lockedTokens;
233 
234     /**
235         @dev Locked tokens cannot be withdrawn using the withdrawTokens function.
236     */
237     function lockTokens(address token, uint256 amount) internal {
238         lockedTokens[token] = safeAdd(lockedTokens[token], amount);
239     }
240 
241     /**
242         @dev Unlocks previusly locked tokens.
243     */
244     function unlockTokens(address token, uint256 amount) internal {
245         lockedTokens[token] = safeSubtract(lockedTokens[token], amount);
246     }
247 
248     /**
249         @dev Withdraws tokens from the contract.
250 
251         @param token Token to withdraw
252         @param to Destination of the tokens
253         @param amount Amount to withdraw 
254     */
255     function withdrawTokens(Token token, address to, uint256 amount) public onlyOwner returns (bool) {
256         require(safeSubtract(token.balanceOf(this), lockedTokens[token]) >= amount);
257         require(to != address(0));
258         return token.transfer(to, amount);
259     }
260 }
261 
262 contract NanoLoanEngine is ERC721, Engine, Ownable, TokenLockable {
263     uint256 public constant VERSION = 203;
264     string public constant VERSION_NAME = "Basalt";
265 
266     uint256 private activeLoans = 0;
267     mapping(address => uint256) private lendersBalance;
268 
269     function name() public view returns (string _name) {
270         _name = "RCN - Nano loan engine - Basalt 203";
271     }
272 
273     function symbol() public view returns (string _symbol) {
274         _symbol = "RCN-NLE-203";
275     }
276 
277     /**
278         @notice Returns the number of active loans in total, active loans are the loans with "lent" status.
279         @dev Required for ERC-721 compliance
280 
281         @return _totalSupply Total amount of loans
282     */
283     function totalSupply() public view returns (uint _totalSupply) {
284         _totalSupply = activeLoans;
285     }
286 
287     /**
288         @notice Returns the number of active loans that a lender possess; active loans are the loans with "lent" status.
289         @dev Required for ERC-721 compliance
290 
291         @param _owner The owner address to search
292         
293         @return _balance Amount of loans  
294     */
295     function balanceOf(address _owner) public view returns (uint _balance) {
296         _balance = lendersBalance[_owner];
297     }
298 
299     /**
300         @notice Maps the indices of lenders loans to tokens ids
301         @dev Required for ERC-721 compliance, This method MUST NEVER be called by smart contract code.
302             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
303 
304         @param _owner The owner address
305         @param _index Loan index for the owner
306 
307         @return tokenId Real token id
308     */
309     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint tokenId) {
310         uint256 tokenCount = balanceOf(_owner);
311 
312         if (tokenCount == 0 || _index >= tokenCount) {
313             // Fail transaction
314             revert();
315         } else {
316             uint256 totalLoans = totalSupply();
317             uint256 resultIndex = 0;
318 
319             uint256 loanId;
320 
321             for (loanId = 0; loanId <= totalLoans; loanId++) {
322                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
323                     if (resultIndex == _index) {
324                         return loanId;
325                     }
326                     resultIndex++;
327                 }
328             }
329 
330             revert();
331         }
332     }
333 
334     /**
335         @notice Returns all the loans that a lender possess
336         @dev This method MUST NEVER be called by smart contract code; 
337             it walks the entire loans array, and will probably create a transaction bigger than the gas limit.
338 
339         @param _owner The owner address
340 
341         @return ownerTokens List of all the loans of the _owner
342     */
343     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
344         uint256 tokenCount = balanceOf(_owner);
345 
346         if (tokenCount == 0) {
347             // Return an empty array
348             return new uint256[](0);
349         } else {
350             uint256[] memory result = new uint256[](tokenCount);
351             uint256 totalLoans = totalSupply();
352             uint256 resultIndex = 0;
353 
354             uint256 loanId;
355 
356             for (loanId = 0; loanId <= totalLoans; loanId++) {
357                 if (loans[loanId].lender == _owner && loans[loanId].status == Status.lent) {
358                     result[resultIndex] = loanId;
359                     resultIndex++;
360                 }
361             }
362 
363             return result;
364         }
365     }
366 
367     /**
368         @notice Returns the loan metadata, this field can be set by the creator of the loan with his own criteria.
369 
370         @param index Index of the loan
371 
372         @return The string with the metadata
373     */
374     function tokenMetadata(uint256 index) public view returns (string) {
375         return loans[index].metadata;
376     }
377 
378     /**
379         @notice Returns the loan metadata, hashed with keccak256.
380         @dev This emthod is useful to evaluate metadata from a smart contract.
381 
382         @param index Index of the loan
383 
384         @return The metadata hashed with keccak256
385     */
386     function tokenMetadataHash(uint256 index) public view returns (bytes32) {
387         return keccak256(loans[index].metadata);
388     }
389 
390     Token public rcn;
391     bool public deprecated;
392 
393     event CreatedLoan(uint _index, address _borrower, address _creator);
394     event ApprovedBy(uint _index, address _address);
395     event Lent(uint _index, address _lender, address _cosigner);
396     event DestroyedBy(uint _index, address _address);
397     event PartialPayment(uint _index, address _sender, address _from, uint256 _amount);
398     event TotalPayment(uint _index);
399 
400     function NanoLoanEngine(Token _rcn) public {
401         owner = msg.sender;
402         rcn = _rcn;
403     }
404 
405     struct Loan {
406         Status status;
407         Oracle oracle;
408 
409         address borrower;
410         address lender;
411         address creator;
412         address cosigner;
413         
414         uint256 amount;
415         uint256 interest;
416         uint256 punitoryInterest;
417         uint256 interestTimestamp;
418         uint256 paid;
419         uint256 interestRate;
420         uint256 interestRatePunitory;
421         uint256 dueTime;
422         uint256 duesIn;
423 
424         bytes32 currency;
425         uint256 cancelableAt;
426         uint256 lenderBalance;
427 
428         address approvedTransfer;
429         uint256 expirationRequest;
430 
431         string metadata;
432         mapping(address => bool) approbations;
433     }
434 
435     Loan[] private loans;
436 
437     /**
438         @notice Creates a loan request, the loan can be generated with any borrower and conditions; if the borrower agrees
439         it must call the "approve" function. If the creator of the loan is the borrower the approve is done automatically.
440 
441         @dev The creator of the loan is the caller of this function; this is useful to track which wallet created the loan.
442 
443         @param _oracleContract Address of the Oracle contract, if the loan does not use any oracle, this field should be 0x0.
444         @param _borrower Address of the borrower
445         @param _currency The currency to use with the oracle, the currency code is generated with the following formula,
446             keccak256(ticker,decimals).
447         @param _amount The requested amount; currency and unit are defined by the Oracle, if there is no Oracle present
448             the currency is RCN, and the unit is wei.
449         @param _interestRate The non-punitory interest rate by second, defined as a denominator of 10 000 000.
450         @param _interestRatePunitory The punitory interest rate by second, defined as a denominator of 10 000 000.
451             Ej: interestRate 11108571428571 = 28% Anual interest
452         @param _duesIn The time in seconds that the borrower has in order to pay the debt after the lender lends the money.
453         @param _cancelableAt Delta in seconds specifying how much interest should be added in advance, if the borrower pays 
454         entirely or partially the loan before this term, no extra interest will be deducted.
455         @param _expirationRequest Timestamp of when the loan request expires, if the loan is not filled before this date, 
456             the request is no longer valid.
457         @param _metadata String with loan metadata.
458     */
459     function createLoan(Oracle _oracleContract, address _borrower, bytes32 _currency, uint256 _amount, uint256 _interestRate,
460         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest, string _metadata) public returns (uint256) {
461 
462         require(!deprecated);
463         require(_cancelableAt <= _duesIn);
464         require(_oracleContract != address(0) || _currency == 0x0);
465         require(_borrower != address(0));
466         require(_amount != 0);
467         require(_interestRatePunitory != 0);
468         require(_interestRate != 0);
469         require(_expirationRequest > block.timestamp);
470 
471         var loan = Loan(Status.initial, _oracleContract, _borrower, 0x0, msg.sender, 0x0, _amount, 0, 0, 0, 0, _interestRate,
472             _interestRatePunitory, 0, _duesIn, _currency, _cancelableAt, 0, 0x0, _expirationRequest, _metadata);
473         uint index = loans.push(loan) - 1;
474         CreatedLoan(index, _borrower, msg.sender);
475 
476         if (msg.sender == _borrower) {
477             approveLoan(index);
478         }
479 
480         return index;
481     }
482     
483     function ownerOf(uint256 index) public view returns (address owner) { owner = loans[index].lender; }
484     function getTotalLoans() public view returns (uint256) { return loans.length; }
485     function getOracle(uint index) public view returns (Oracle) { return loans[index].oracle; }
486     function getBorrower(uint index) public view returns (address) { return loans[index].borrower; }
487     function getCosigner(uint index) public view returns (address) { return loans[index].cosigner; }
488     function getCreator(uint index) public view returns (address) { return loans[index].creator; }
489     function getAmount(uint index) public view returns (uint256) { return loans[index].amount; }
490     function getPunitoryInterest(uint index) public view returns (uint256) { return loans[index].punitoryInterest; }
491     function getInterestTimestamp(uint index) public view returns (uint256) { return loans[index].interestTimestamp; }
492     function getPaid(uint index) public view returns (uint256) { return loans[index].paid; }
493     function getInterestRate(uint index) public view returns (uint256) { return loans[index].interestRate; }
494     function getInterestRatePunitory(uint index) public view returns (uint256) { return loans[index].interestRatePunitory; }
495     function getDueTime(uint index) public view returns (uint256) { return loans[index].dueTime; }
496     function getDuesIn(uint index) public view returns (uint256) { return loans[index].duesIn; }
497     function getCancelableAt(uint index) public view returns (uint256) { return loans[index].cancelableAt; }
498     function getApprobation(uint index, address _address) public view returns (bool) { return loans[index].approbations[_address]; }
499     function getStatus(uint index) public view returns (Status) { return loans[index].status; }
500     function getLenderBalance(uint index) public view returns (uint256) { return loans[index].lenderBalance; }
501     function getApproved(uint index) public view returns (address) {return loans[index].approvedTransfer; }
502     function getCurrency(uint index) public view returns (bytes32) { return loans[index].currency; }
503     function getExpirationRequest(uint index) public view returns (uint256) { return loans[index].expirationRequest; }
504     function getInterest(uint index) public view returns (uint256) { return loans[index].interest; }
505 
506     /**
507         @notice Used to know if a loan is ready to lend
508 
509         @param index Index of the loan
510 
511         @return true if the loan has been approved by the borrower and cosigner.
512     */
513     function isApproved(uint index) public view returns (bool) {
514         Loan storage loan = loans[index];
515         return loan.approbations[loan.borrower];
516     }
517 
518     /**
519         @notice Called by the members of the loan to show that they agree with the terms of the loan; the borrower
520         must call this method before any lender could call the method "lend".
521             
522         @dev Any address can call this method to be added to the "approbations" mapping.
523 
524         @param index Index of the loan
525 
526         @return true if the approve was done successfully
527     */
528     function approveLoan(uint index) public returns(bool) {
529         Loan storage loan = loans[index];
530         require(loan.status == Status.initial);
531         loan.approbations[msg.sender] = true;
532         ApprovedBy(index, msg.sender);
533         return true;
534     }
535 
536     /**
537         @notice Performs the lend of the RCN equivalent to the requested amount, and transforms the msg.sender in the new lender.
538 
539         @dev The loan must be previously approved by the borrower; before calling this function, the lender candidate must 
540         call the "approve" function on the RCN Token, specifying an amount sufficient enough to pay the equivalent of
541         the requested amount, and the cosigner fee.
542         
543         @param index Index of the loan
544         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
545             by the url exposed in the url() method of the oracle.
546         @param cosigner Address of the cosigner, 0x0 for lending without cosigner.
547         @param cosignerData Data required by the cosigner to process the request.
548 
549         @return true if the lend was done successfully
550     */
551     function lend(uint index, bytes oracleData, Cosigner cosigner, bytes cosignerData) public returns (bool) {
552         Loan storage loan = loans[index];
553 
554         require(loan.status == Status.initial);
555         require(isApproved(index));
556         require(block.timestamp <= loan.expirationRequest);
557 
558         loan.lender = msg.sender;
559         loan.dueTime = safeAdd(block.timestamp, loan.duesIn);
560         loan.interestTimestamp = block.timestamp;
561         loan.status = Status.lent;
562         
563         if (loan.cancelableAt > 0)
564             internalAddInterest(loan, safeAdd(block.timestamp, loan.cancelableAt));
565 
566         uint256 rate = getRate(loan, oracleData);
567 
568         if (cosigner != address(0)) {
569             // The cosigner it's temporary set to the next address (cosigner + 2), it's expected that the cosigner will
570             // call the method "cosign" to accept the conditions; that method also sets the cosigner to the right
571             // address. If that does not happen, the transaction fails.
572             loan.cosigner = address(uint256(cosigner) + 2);
573             require(cosigner.requestCosign(this, index, cosignerData, oracleData));
574             require(loan.cosigner == address(cosigner));
575         }
576         
577         require(rcn.transferFrom(msg.sender, loan.borrower, safeMult(loan.amount, rate)));
578         
579         // ERC721, create new loan and transfer it to the lender
580         Transfer(0x0, loan.lender, index);
581         activeLoans += 1;
582         lendersBalance[loan.lender] += 1;
583         Lent(index, loan.lender, cosigner);
584 
585         return true;
586     }
587 
588     /**
589         @notice The cosigner must call this method to accept the conditions of a loan, this method pays the cosigner his fee.
590         
591         @dev If the cosigner does not call this method the whole "lend" call fails.
592 
593         @param index Index of the loan
594         @param cost Fee set by the cosigner
595 
596         @return true If the cosign was successfull
597     */
598     function cosign(uint index, uint256 cost) external returns (bool) {
599         Loan storage loan = loans[index];
600         require(loan.status == Status.lent && (loan.dueTime - loan.duesIn) == block.timestamp);
601         require(loan.cosigner != address(0));
602         require(loan.cosigner == address(uint256(msg.sender) + 2));
603         loan.cosigner = msg.sender;
604         require(rcn.transferFrom(loan.lender, msg.sender, cost));
605         return true;
606     }
607 
608     /**
609         @notice Destroys a loan, the borrower could call this method if they performed an accidental or regretted 
610         "approve" of the loan, this method only works for them if the loan is in "pending" status.
611 
612         The lender can call this method at any moment, in case of a loan with status "lent" the lender is pardoning 
613         the debt. 
614 
615         @param index Index of the loan
616 
617         @return true if the destroy was done successfully
618     */
619     function destroy(uint index) public returns (bool) {
620         Loan storage loan = loans[index];
621         require(loan.status != Status.destroyed);
622         require(msg.sender == loan.lender || (msg.sender == loan.borrower && loan.status == Status.initial));
623         DestroyedBy(index, msg.sender);
624 
625         // ERC721, remove loan from circulation
626         if (loan.status != Status.initial) {
627             lendersBalance[loan.lender] -= 1;
628             activeLoans -= 1;
629             Transfer(loan.lender, 0x0, index);
630         }
631 
632         loan.status = Status.destroyed;
633         return true;
634     }
635 
636     /**
637         @notice Transfers a loan to a different lender, the caller must be the current lender or previously being
638         approved with the method "approveTransfer"; only loans with the Status.lent status can be transfered.
639 
640         @dev Required for ERC-721 compliance
641 
642         @param index Index of the loan
643         @param to New lender
644 
645         @return true if the transfer was done successfully
646     */
647     function transfer(address to, uint256 index) public returns (bool) {
648         Loan storage loan = loans[index];
649         
650         require(loan.status != Status.destroyed && loan.status != Status.paid);
651         require(msg.sender == loan.lender || msg.sender == loan.approvedTransfer);
652         require(to != address(0));
653         loan.lender = to;
654         loan.approvedTransfer = address(0);
655 
656         // ERC721, transfer loan to another address
657         lendersBalance[msg.sender] -= 1;
658         lendersBalance[to] += 1;
659         Transfer(loan.lender, to, index);
660 
661         return true;
662     }
663 
664     /**
665         @notice Transfers the loan to the msg.sender, the msg.sender must be approved using the "approve" method.
666 
667         @dev Required for ERC-721 compliance
668 
669         @param _index Index of the loan
670 
671         @return true if the transfer was successfull
672     */
673     function takeOwnership(uint256 _index) public returns (bool) {
674         return transfer(msg.sender, _index);
675     }
676 
677     /**
678         @notice Transfers the loan to an address, only if the current owner is the "from" address
679 
680         @dev Required for ERC-721 compliance
681 
682         @param from Current owner of the loan
683         @param to New owner of the loan
684         @param index Index of the loan
685 
686         @return true if the transfer was successfull
687     */
688     function transferFrom(address from, address to, uint256 index) public returns (bool) {
689         require(loans[index].lender == from);
690         return transfer(to, index);
691     }
692 
693     /**
694         @notice Approves the transfer of a given loan in the name of the lender, the behavior of this function is similar to
695         "approve" in the ERC20 standard, but only one approved address is allowed at a time.
696 
697         The same method can be called passing 0x0 as parameter "to" to erase a previously approved address.
698 
699         @dev Required for ERC-721 compliance
700 
701         @param to Address allowed to transfer the loan or 0x0 to delete
702         @param index Index of the loan
703 
704         @return true if the approve was done successfully
705     */
706     function approve(address to, uint256 index) public returns (bool) {
707         Loan storage loan = loans[index];
708         require(msg.sender == loan.lender);
709         loan.approvedTransfer = to;
710         Approval(msg.sender, to, index);
711         return true;
712     }
713 
714     /**
715         @notice Returns the pending amount to complete de payment of the loan, keep in mind that this number increases 
716         every second.
717 
718         @dev This method also computes the interest and updates the loan
719 
720         @param index Index of the loan
721 
722         @return Aprox pending payment amount
723     */
724     function getPendingAmount(uint index) public returns (uint256) {
725         addInterest(index);
726         return getRawPendingAmount(index);
727     }
728 
729     /**
730         @notice Returns the pending amount up to the last time of the interest update. This is not the real pending amount
731 
732         @dev This method is exact only if "addInterest(loan)" was before and in the same block.
733 
734         @param index Index of the loan
735 
736         @return The past pending amount
737     */
738     function getRawPendingAmount(uint index) public view returns (uint256) {
739         Loan memory loan = loans[index];
740         return safeSubtract(safeAdd(safeAdd(loan.amount, loan.interest), loan.punitoryInterest), loan.paid);
741     }
742 
743     /**
744         @notice Calculates the interest of a given amount, interest rate and delta time.
745 
746         @param timeDelta Elapsed time
747         @param interestRate Interest rate expressed as the denominator of 10 000 000.
748         @param amount Amount to apply interest
749 
750         @return realDelta The real timeDelta applied
751         @return interest The interest gained in the realDelta time
752     */
753     function calculateInterest(uint256 timeDelta, uint256 interestRate, uint256 amount) internal pure returns (uint256 realDelta, uint256 interest) {
754         if (amount == 0) {
755             interest = 0;
756             realDelta = timeDelta;
757         } else {
758             interest = safeMult(safeMult(100000, amount), timeDelta) / interestRate;
759             realDelta = safeMult(interest, interestRate) / (amount * 100000);
760         }
761     }
762 
763     /**
764         @notice Computes loan interest
765 
766         Computes the punitory and non-punitory interest of a given loan and only applies the change.
767         
768         @param loan Loan to compute interest
769         @param timestamp Target absolute unix time to calculate interest.
770     */
771     function internalAddInterest(Loan storage loan, uint256 timestamp) internal {
772         if (timestamp > loan.interestTimestamp) {
773             uint256 newInterest = loan.interest;
774             uint256 newPunitoryInterest = loan.punitoryInterest;
775 
776             uint256 newTimestamp;
777             uint256 realDelta;
778             uint256 calculatedInterest;
779 
780             uint256 deltaTime;
781             uint256 pending;
782 
783             uint256 endNonPunitory = min(timestamp, loan.dueTime);
784             if (endNonPunitory > loan.interestTimestamp) {
785                 deltaTime = endNonPunitory - loan.interestTimestamp;
786 
787                 if (loan.paid < loan.amount) {
788                     pending = loan.amount - loan.paid;
789                 } else {
790                     pending = 0;
791                 }
792 
793                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRate, pending);
794                 newInterest = safeAdd(calculatedInterest, newInterest);
795                 newTimestamp = loan.interestTimestamp + realDelta;
796             }
797 
798             if (timestamp > loan.dueTime) {
799                 uint256 startPunitory = max(loan.dueTime, loan.interestTimestamp);
800                 deltaTime = timestamp - startPunitory;
801 
802                 uint256 debt = safeAdd(loan.amount, newInterest);
803                 pending = min(debt, safeSubtract(safeAdd(debt, newPunitoryInterest), loan.paid));
804 
805                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRatePunitory, pending);
806                 newPunitoryInterest = safeAdd(newPunitoryInterest, calculatedInterest);
807                 newTimestamp = startPunitory + realDelta;
808             }
809             
810             if (newInterest != loan.interest || newPunitoryInterest != loan.punitoryInterest) {
811                 loan.interestTimestamp = newTimestamp;
812                 loan.interest = newInterest;
813                 loan.punitoryInterest = newPunitoryInterest;
814             }
815         }
816     }
817 
818     /**
819         @notice Updates the loan accumulated interests up to the current Unix time.
820         
821         @param index Index of the loan
822     
823         @return true If the interest was updated
824     */
825     function addInterest(uint index) public returns (bool) {
826         Loan storage loan = loans[index];
827         require(loan.status == Status.lent);
828         internalAddInterest(loan, block.timestamp);
829     }
830     
831     /**
832         @notice Pay loan
833 
834         Does a payment of a given Loan, before performing the payment the accumulated
835         interest is computed and added to the total pending amount.
836 
837         Before calling this function, the msg.sender must call the "approve" function on the RCN Token, specifying an amount
838         sufficient enough to pay the equivalent of the desired payment and the oracle fee.
839 
840         If the paid pending amount equals zero, the loan changes status to "paid" and it is considered closed.
841 
842         @dev Because it is difficult or even impossible to know in advance how much RCN are going to be spent on the
843         transaction*, we recommend performing the "approve" using an amount 5% superior to the wallet estimated
844         spending. If the RCN spent results to be less, the extra tokens are never debited from the msg.sender.
845 
846         * The RCN rate can fluctuate on the same block, and it is impossible to know in advance the exact time of the
847         confirmation of the transaction. 
848 
849         @param index Index of the loan
850         @param _amount Amount to pay, specified in the loan currency; or in RCN if the loan has no oracle
851         @param _from The identity of the payer
852         @param oracleData Data required by the oracle to return the rate, the content of this field must be provided
853             by the url exposed in the url() method of the oracle.
854             
855         @return true if the payment was executed successfully
856     */
857     function pay(uint index, uint256 _amount, address _from, bytes oracleData) public returns (bool) {
858         Loan storage loan = loans[index];
859 
860         require(loan.status == Status.lent);
861         addInterest(index);
862         uint256 toPay = min(getPendingAmount(index), _amount);
863         PartialPayment(index, msg.sender, _from, toPay);
864 
865         loan.paid = safeAdd(loan.paid, toPay);
866 
867         if (getRawPendingAmount(index) == 0) {
868             TotalPayment(index);
869             loan.status = Status.paid;
870 
871             // ERC721, remove loan from circulation
872             lendersBalance[loan.lender] -= 1;
873             activeLoans -= 1;
874             Transfer(loan.lender, 0x0, index);
875         }
876 
877         uint256 rate = getRate(loan, oracleData);
878         uint256 transferValue = safeMult(toPay, rate);
879         lockTokens(rcn, transferValue);
880         require(rcn.transferFrom(msg.sender, this, transferValue));
881         loan.lenderBalance = safeAdd(transferValue, loan.lenderBalance);
882 
883         return true;
884     }
885 
886     /**
887         @notice Retrieves the rate corresponding of the loan oracle
888         
889         @dev If the loan has no oracle the currency must be RCN so the rate is 1
890 
891         @param loan The loan with the cosigner
892         @param data Data required by the oracle
893 
894         @return The rate of the oracle
895     */
896     function getRate(Loan loan, bytes data) internal returns (uint256) {
897         if (loan.oracle == address(0)) {
898             return 1;
899         } else {
900             return loan.oracle.getRate(loan.currency, data);
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