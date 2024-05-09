1 pragma solidity ^0.4.15;
2 
3 contract Oracle {
4     event NewSymbol(string _symbol, uint8 _decimals);
5     function getTimestamp(string symbol) constant returns(uint256);
6     function getRateFor(string symbol) returns (uint256);
7     function getCost(string symbol) constant returns (uint256);
8     function getDecimals(string symbol) constant returns (uint256);
9 }
10 
11 contract Token {
12     function transfer(address _to, uint _value) returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 }
19 
20 contract RpSafeMath {
21     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
22       uint256 z = x + y;
23       assert((z >= x) && (z >= y));
24       return z;
25     }
26 
27     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
28       assert(x >= y);
29       uint256 z = x - y;
30       return z;
31     }
32 
33     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
34       uint256 z = x * y;
35       assert((x == 0)||(z/x == y));
36       return z;
37     }
38 
39     function min(uint256 a, uint256 b) internal returns(uint256) {
40         if (a < b) { 
41           return a;
42         } else { 
43           return b; 
44         }
45     }
46     
47     function max(uint256 a, uint256 b) internal returns(uint256) {
48         if (a > b) { 
49           return a;
50         } else { 
51           return b; 
52         }
53     }
54 }
55 
56 
57 contract NanoLoanEngine is RpSafeMath {
58     uint256 public constant VERSION = 15;
59     
60     Token public token;
61 
62     enum Status { initial, lent, paid, destroyed }
63 
64     address public owner;
65     bool public deprecated;
66     uint256 public totalLenderBalance;
67 
68     event CreatedLoan(uint _index, address _borrower, address _creator);
69     event ApprovedBy(uint _index, address _address);
70     event Lent(uint _index, address _lender);
71     event CreatedDebt(uint _index, address _lend);
72     event DestroyedBy(uint _index, address _address);
73     event PartialPayment(uint _index, address _sender, address _from, uint256 _amount);
74     event Transfer(uint _index, address _from, address _to);
75     event TotalPayment(uint _index);
76 
77     function NanoLoanEngine(Token _token) {
78         owner = msg.sender;
79         token = _token;
80     }
81 
82     struct Loan {
83         Oracle oracle;
84 
85         Status status;
86 
87         address borrower;
88         address cosigner;
89         address lender;
90         address creator;
91         
92         uint256 amount;
93         uint256 interest;
94         uint256 punitoryInterest;
95         uint256 interestTimestamp;
96         uint256 paid;
97         uint256 cosignerFee;
98         uint256 interestRate;
99         uint256 interestRatePunitory;
100         uint256 dueTime;
101         uint256 duesIn;
102 
103         string currency;
104         uint256 cancelableAt;
105         uint256 lenderBalance;
106 
107         address approvedTransfer;
108         uint256 expirationRequest;
109 
110         mapping(address => bool) approbations;
111     }
112 
113     Loan[] private loans;
114 
115     // _oracleContract: Address of the Oracle contract, must implement OracleInterface. 0x0 for no oracle
116     // _cosigner: Responsable of the payment of the loan if the lender does not pay. 0x0 for no cosigner
117     // _cosignerFee: absolute amount in currency
118     // _interestRate: 100 000 / interest; ej 100 000 = 100 %; 10 000 000 = 1% (by second)
119     function createLoan(Oracle _oracleContract, address _borrower, address _cosigner,
120         uint256 _cosignerFee, string _currency, uint256 _amount, uint256 _interestRate,
121         uint256 _interestRatePunitory, uint256 _duesIn, uint256 _cancelableAt, uint256 _expirationRequest) returns (uint256) {
122 
123         require(!deprecated);
124         require(_cancelableAt <= _duesIn);
125         require(_oracleContract != address(0) || bytes(_currency).length == 0);
126         require(_cosigner != address(0) || _cosignerFee == 0);
127         require(_borrower != address(0));
128         require(_amount != 0);
129         require(_interestRatePunitory != 0);
130         require(_interestRate != 0);
131         require(_expirationRequest > block.timestamp);
132 
133         var loan = Loan(_oracleContract, Status.initial, _borrower, _cosigner, 0x0, msg.sender, _amount,
134             0, 0, 0, 0, _cosignerFee, _interestRate, _interestRatePunitory, 0, _duesIn, _currency, _cancelableAt, 0, 0x0, _expirationRequest);
135         uint index = loans.push(loan) - 1;
136         CreatedLoan(index, _borrower, msg.sender);
137         return index;
138     }
139     
140     function getLoanConfig(uint index) constant returns (address oracle, address borrower, address lender, address creator, uint amount, 
141         uint cosignerFee, uint interestRate, uint interestRatePunitory, uint duesIn, uint cancelableAt, uint decimals, bytes32 currencyHash, uint256 expirationRequest) {
142         Loan storage loan = loans[index];
143         oracle = loan.oracle;
144         borrower = loan.borrower;
145         lender = loan.lender;
146         creator = loan.creator;
147         amount = loan.amount;
148         cosignerFee = loan.cosignerFee;
149         interestRate = loan.interestRate;
150         interestRatePunitory = loan.interestRatePunitory;
151         duesIn = loan.duesIn;
152         cancelableAt = loan.cancelableAt;
153         decimals = loan.oracle.getDecimals(loan.currency);
154         currencyHash = keccak256(loan.currency); 
155         expirationRequest = loan.expirationRequest;
156     }
157 
158     function getLoanState(uint index) constant returns (uint interest, uint punitoryInterest, uint interestTimestamp,
159         uint paid, uint dueTime, Status status, uint lenderBalance, address approvedTransfer, bool approved) {
160         Loan storage loan = loans[index];
161         interest = loan.interest;
162         punitoryInterest = loan.punitoryInterest;
163         interestTimestamp = loan.interestTimestamp;
164         paid = loan.paid;
165         dueTime = loan.dueTime;
166         status = loan.status;
167         lenderBalance = loan.lenderBalance;
168         approvedTransfer = loan.approvedTransfer;
169         approved = isApproved(index);
170     }
171     
172     function getTotalLoans() constant returns (uint256) { return loans.length; }
173     function getOracle(uint index) constant returns (Oracle) { return loans[index].oracle; }
174     function getBorrower(uint index) constant returns (address) { return loans[index].borrower; }
175     function getCosigner(uint index) constant returns (address) { return loans[index].cosigner; }
176     function getLender(uint index) constant returns (address) { return loans[index].lender; }
177     function getCreator(uint index) constant returns (address) { return loans[index].creator; }
178     function getAmount(uint index) constant returns (uint256) { return loans[index].amount; }
179     function getInterest(uint index) constant returns (uint256) { return loans[index].interest; }
180     function getPunitoryInterest(uint index) constant returns (uint256) { return loans[index].punitoryInterest; }
181     function getInterestTimestamp(uint index) constant returns (uint256) { return loans[index].interestTimestamp; }
182     function getPaid(uint index) constant returns (uint256) { return loans[index].paid; }
183     function getCosignerFee(uint index) constant returns (uint256) { return loans[index].cosignerFee; }
184     function getInterestRate(uint index) constant returns (uint256) { return loans[index].interestRate; }
185     function getInterestRatePunitory(uint index) constant returns (uint256) { return loans[index].interestRatePunitory; }
186     function getDueTime(uint index) constant returns (uint256) { return loans[index].dueTime; }
187     function getDuesIn(uint index) constant returns (uint256) { return loans[index].duesIn; }
188     function getCurrency(uint index) constant returns (string) { return loans[index].currency; }
189     function getCancelableAt(uint index) constant returns (uint256) { return loans[index].cancelableAt; }
190     function getApprobation(uint index, address _address) constant returns (bool) { return loans[index].approbations[_address]; }
191     function getStatus(uint index) constant returns (Status) { return loans[index].status; }
192     function getLenderBalance(uint index) constant returns (uint256) { return loans[index].lenderBalance; }
193     function getCurrencyLength(uint index) constant returns (uint256) { return bytes(loans[index].currency).length; }
194     function getCurrencyByte(uint index, uint cindex) constant returns (bytes1) { return bytes(loans[index].currency)[cindex]; }
195     function getApprovedTransfer(uint index) constant returns (address) {return loans[index].approvedTransfer; }
196     function getCurrencyHash(uint index) constant returns (bytes32) { return keccak256(loans[index].currency); }
197     function getCurrencyDecimals(uint index) constant returns (uint256) { return loans[index].oracle.getDecimals(loans[index].currency); }
198     function getExpirationRequest(uint index) constant returns (uint256) { return loans[index].expirationRequest; }
199 
200     function isApproved(uint index) constant returns (bool) {
201         Loan storage loan = loans[index];
202         return loan.approbations[loan.borrower] && (loan.approbations[loan.cosigner] || loan.cosigner == address(0));
203     }
204 
205     function approve(uint index) public returns(bool) {
206         Loan storage loan = loans[index];
207         require(loan.status == Status.initial);
208         loan.approbations[msg.sender] = true;
209         ApprovedBy(index, msg.sender);
210         return true;
211     }
212 
213     function lend(uint index) public returns (bool) {
214         Loan storage loan = loans[index];
215         require(loan.status == Status.initial);
216         require(isApproved(index));
217         require(block.timestamp <= loan.expirationRequest);
218 
219         loan.lender = msg.sender;
220         loan.dueTime = safeAdd(block.timestamp, loan.duesIn);
221         loan.interestTimestamp = block.timestamp;
222         loan.status = Status.lent;
223 
224         if (loan.cancelableAt > 0)
225             internalAddInterest(index, safeAdd(block.timestamp, loan.cancelableAt));
226 
227         uint256 rate = getOracleRate(index);
228         require(token.transferFrom(msg.sender, loan.borrower, safeMult(loan.amount, rate)));
229 
230         if (loan.cosigner != address(0))
231             require(token.transferFrom(msg.sender, loan.cosigner, safeMult(loan.cosignerFee, rate)));
232         
233         Lent(index, loan.lender);
234         return true;
235     }
236 
237     function destroy(uint index) public returns (bool) {
238         Loan storage loan = loans[index];
239         require(loan.status != Status.destroyed);
240         require(msg.sender == loan.lender || ((msg.sender == loan.borrower || msg.sender == loan.cosigner) && loan.status == Status.initial));
241         DestroyedBy(index, msg.sender);
242         loan.status = Status.destroyed;
243         return true;
244     }
245 
246     function transfer(uint index, address to) public returns (bool) {
247         Loan storage loan = loans[index];
248         require(loan.status != Status.destroyed);
249         require(msg.sender == loan.lender || msg.sender == loan.approvedTransfer);
250         require(to != address(0));
251         Transfer(index, loan.lender, to);
252         loan.lender = to;
253         loan.approvedTransfer = address(0);
254         return true;
255     }
256 
257     function approveTransfer(uint index, address to) public returns (bool) {
258         Loan storage loan = loans[index];
259         require(msg.sender == loan.lender);
260         loan.approvedTransfer = to;
261         return true;
262     }
263 
264     function getPendingAmount(uint index) public constant returns (uint256) {
265         Loan storage loan = loans[index];
266         return safeSubtract(safeAdd(safeAdd(loan.amount, loan.interest), loan.punitoryInterest), loan.paid);
267     }
268 
269     function calculateInterest(uint256 timeDelta, uint256 interestRate, uint256 amount) public constant returns (uint256 realDelta, uint256 interest) {
270         interest = safeMult(safeMult(100000, amount), timeDelta) / interestRate;
271         realDelta = safeMult(interest, interestRate) / (amount * 100000);
272     }
273 
274     function internalAddInterest(uint index, uint256 timestamp) internal {
275         Loan storage loan = loans[index];
276         if (timestamp > loan.interestTimestamp) {
277             uint256 newInterest = loan.interest;
278             uint256 newPunitoryInterest = loan.punitoryInterest;
279 
280             uint256 newTimestamp;
281             uint256 realDelta;
282             uint256 calculatedInterest;
283 
284             uint256 deltaTime;
285             uint256 pending;
286 
287             uint256 endNonPunitory = min(timestamp, loan.dueTime);
288             if (endNonPunitory > loan.interestTimestamp) {
289                 deltaTime = safeSubtract(endNonPunitory, loan.interestTimestamp);
290                 pending = safeSubtract(loan.amount, loan.paid);
291                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRate, pending);
292                 newInterest = safeAdd(calculatedInterest, newInterest);
293                 newTimestamp = loan.interestTimestamp + realDelta;
294             }
295 
296             if (timestamp > loan.dueTime) {
297                 uint256 startPunitory = max(loan.dueTime, loan.interestTimestamp);
298                 deltaTime = safeSubtract(timestamp, startPunitory);
299                 pending = safeSubtract(safeAdd(loan.amount, newInterest), loan.paid);
300                 (realDelta, calculatedInterest) = calculateInterest(deltaTime, loan.interestRatePunitory, pending);
301                 newPunitoryInterest = safeAdd(newPunitoryInterest, calculatedInterest);
302                 newTimestamp = startPunitory + realDelta;
303             }
304             
305             if (newInterest != loan.interest || newPunitoryInterest != loan.punitoryInterest) {
306                 loan.interestTimestamp = newTimestamp;
307                 loan.interest = newInterest;
308                 loan.punitoryInterest = newPunitoryInterest;
309             }
310         }
311     }
312 
313     function addInterestUpTo(uint index, uint256 timestamp) internal {
314         Loan storage loan = loans[index];
315         require(loan.status == Status.lent);
316         if (timestamp <= block.timestamp) {
317             internalAddInterest(index, timestamp);
318         }
319     }
320 
321     function addInterest(uint index) public {
322         addInterestUpTo(index, block.timestamp);
323     }
324     
325     function pay(uint index, uint256 _amount, address _from) public returns (bool) {
326         Loan storage loan = loans[index];
327         require(loan.status == Status.lent);
328         addInterest(index);
329         uint256 toPay = min(getPendingAmount(index), _amount);
330 
331         loan.paid = safeAdd(loan.paid, toPay);
332         if (getPendingAmount(index) == 0) {
333             TotalPayment(index);
334             loan.status = Status.paid;
335         }
336 
337         uint256 transferValue = safeMult(toPay, getOracleRate(index));
338         require(token.transferFrom(msg.sender, this, transferValue));
339         loan.lenderBalance = safeAdd(transferValue, loan.lenderBalance);
340         totalLenderBalance = safeAdd(transferValue, totalLenderBalance);
341         PartialPayment(index, msg.sender, _from, toPay);
342 
343         return true;
344     }
345 
346     function withdrawal(uint index, address to, uint256 amount) public returns (bool) {
347         Loan storage loan = loans[index];
348         require(to != address(0));
349         if (msg.sender == loan.lender && loan.lenderBalance >= amount) {
350             loan.lenderBalance = safeSubtract(loan.lenderBalance, amount);
351             totalLenderBalance = safeSubtract(totalLenderBalance, amount);
352             require(token.transfer(to, amount));
353             return true;
354         }
355     }
356 
357     function changeOwner(address to) public {
358         require(msg.sender == owner);
359         require(to != address(0));
360         owner = to;
361     }
362 
363     function setDeprecated(bool _deprecated) public {
364         require(msg.sender == owner);
365         deprecated = _deprecated;
366     }
367 
368     function getOracleRate(uint index) internal returns (uint256) {
369         Loan storage loan = loans[index];
370         if (loan.oracle == address(0)) 
371             return 1;
372 
373         uint256 costOracle = loan.oracle.getCost(loan.currency);
374         require(token.transferFrom(msg.sender, this, costOracle));
375         require(token.approve(loan.oracle, costOracle));
376         uint256 rate = loan.oracle.getRateFor(loan.currency);
377         require(rate != 0);
378         return rate;
379     }
380 
381     function emergencyWithdrawal(Token _token, address to, uint256 amount) returns (bool) {
382         require(msg.sender == owner);
383         require(_token != token || safeSubtract(token.balanceOf(this), totalLenderBalance) >= amount);
384         require(to != address(0));
385         return _token.transfer(to, amount);
386     }
387 }