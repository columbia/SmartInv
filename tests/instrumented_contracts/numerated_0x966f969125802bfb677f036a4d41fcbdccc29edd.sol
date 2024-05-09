1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract lendingManager {
50 
51 uint256 public REQUESTED_STATUS; 
52 uint256 public ACTIVE_STATUS; 
53 uint256 public REQUEST_CANCELED_BY_BORROWER_STATUS;
54 uint256 public REQUEST_CANCELED_BY_LENDER_STATUS;
55 uint256 public ACTIVE_LOAN_CANCELED_BY_LENDER_STATUS;
56 uint256 public COMPLETION_STATUS; 
57 uint256 public DEFAULTED_STATUS;
58 
59 uint256 public MAX_LOAN_AMOUNT;
60 uint256 public MAX_INTEREST_AMOUNT;
61 
62 uint256 public PERCENTAGE_PRECISION;
63 
64 address public ELIX_ADDRESS;
65 
66 event LoanRequestedAtIndex(uint256 index);
67 event LoanCanceledByBorrowerAtIndex(uint256 index); 
68 event LoanCanceledByLenderAtIndex(uint256 index); 
69 event Defaulted(uint256 index,address informer); 
70 event LoanBegunAtIndex(uint256 index); 
71 event LoanUpdatedByVolAddress(uint256 index,uint256 oldAmount,uint256 oldInterest,uint256 amount,uint256 interest);
72 event PaidBackPortionForLoanAtIndex(uint256 index,uint256 amount); 
73 event LoanPaidLateAtIndex(uint256 index,uint256 amount); 
74 event LoanRequestCanceledByLenderAtIndex(uint256 index);
75 event LoanCompletedWithFinalPortion(uint256 index, uint256 amount); 
76 event ActiveLoanUpdatedByVolAddressToCompletion(uint256 index);
77 event LenderClaimedLoanAtIndex(address lender,uint256 index);
78 
79 loan[] public loans; 
80 
81 struct loan   {
82     address borrower;
83     address lender;
84     address volAddress;
85     uint256 startBlock;
86     uint256 amount; 
87     uint256 paidBackBlock; 
88     uint256 status;
89     uint256 amountPaidBackSoFar; 
90     uint256 loanLength; 
91     uint256 interest; 
92     bool borrowerPaidLate;
93     bool requestCancel;
94     string message; 
95 }
96 
97 function lendingManager()  {
98     
99     REQUESTED_STATUS=1;
100     ACTIVE_STATUS=2;
101     REQUEST_CANCELED_BY_BORROWER_STATUS=3; 
102     REQUEST_CANCELED_BY_LENDER_STATUS=4; 
103     COMPLETION_STATUS=5;
104     ACTIVE_LOAN_CANCELED_BY_LENDER_STATUS=6;
105     DEFAULTED_STATUS=7;
106 
107     MAX_LOAN_AMOUNT = 100000000000000000000000000000;
108     MAX_INTEREST_AMOUNT = 100000000000000000000000000000;
109 
110     PERCENTAGE_PRECISION = 1000000000000000000;
111 
112 
113     ELIX_ADDRESS = 0xc8C6A31A4A806d3710A7B38b7B296D2fABCCDBA8;
114 }
115 
116 function loanCompleted(uint256 index, uint256 amount) private {
117 
118     loans[index].paidBackBlock=block.number;
119     
120     if (block.number>SafeMath.add(loans[index].startBlock,loans[index].loanLength)) {
121         loans[index].borrowerPaidLate=true;
122         emit LoanPaidLateAtIndex(index,amount); 
123     }
124 
125     loans[index].status=COMPLETION_STATUS; 
126     emit LoanCompletedWithFinalPortion(index, amount); 
127     if(amount > 0){ 
128         if (! elixir(ELIX_ADDRESS).transferFrom(loans[index].borrower,loans[index].lender, amount)) revert();
129     }
130 
131 }
132 
133 function adjustLoanParams(uint256 newPrincipal, uint256 newInterest, uint256 index) public {
134     require(newPrincipal > 0);
135     require(msg.sender == loans[index].volAddress);
136     require(loans[index].status == REQUESTED_STATUS || loans[index].status == ACTIVE_STATUS);
137     require(newPrincipal <= MAX_LOAN_AMOUNT);
138     require(newInterest <= MAX_INTEREST_AMOUNT);
139 
140     if (block.number==loans[index].startBlock) revert(); 
141 
142     if( SafeMath.add(newPrincipal,newInterest) > loans[index].amountPaidBackSoFar){  
143         
144         emit LoanUpdatedByVolAddress(index,loans[index].amount,loans[index].interest,newPrincipal,newInterest);
145         loans[index].amount = newPrincipal;
146         loans[index].interest = newInterest; 
147     } else {
148         uint256 adjustedTotalRatio = SafeMath.div( SafeMath.mul(PERCENTAGE_PRECISION,loans[index].amountPaidBackSoFar), SafeMath.add(newPrincipal,newInterest) );
149         loans[index].interest = SafeMath.div( SafeMath.mul(newInterest, adjustedTotalRatio), PERCENTAGE_PRECISION);
150         loans[index].amount = SafeMath.sub(loans[index].amountPaidBackSoFar, loans[index].interest);
151 		emit ActiveLoanUpdatedByVolAddressToCompletion(index);
152 		loanCompleted(index, 0);
153     }  
154 }
155 
156 
157 function requestLoan(address lender, address volAddress, uint256 amount,uint256 length,uint256 interest,bool requestCancel, string loanMessage) public returns(uint256)   {
158     if (msg.sender==lender) revert(); 
159     
160     
161     if (amount==0 || length<4 || length>225257143) revert(); 
162     
163    
164     require(amount <= MAX_LOAN_AMOUNT);
165     require(interest <= MAX_INTEREST_AMOUNT);    
166 
167     loans.push(loan(msg.sender,lender, volAddress,0,amount,0,REQUESTED_STATUS,0,length,interest,false,false,loanMessage));
168     
169     emit LoanRequestedAtIndex(loans.length-1); 
170     
171     return (loans.length-1);
172 }
173 
174 
175 function cancelLoanRequestAtIndexByLender(uint256 index) public {
176   if (loans[index].status==REQUESTED_STATUS && loans[index].lender==msg.sender)    {
177         
178         loans[index].status=REQUEST_CANCELED_BY_LENDER_STATUS; 
179         emit LoanRequestCanceledByLenderAtIndex(index); 
180   }
181 }
182 
183 
184 function cancelLoanRequestAtIndexByBorrower(uint256 index) public {
185   if (loans[index].status==REQUESTED_STATUS && loans[index].borrower==msg.sender)    {
186        
187         loans[index].status=REQUEST_CANCELED_BY_BORROWER_STATUS; 
188         emit LoanCanceledByBorrowerAtIndex(index); 
189   }
190 }
191 
192 
193 function cancelActiveLoanAtIndex(uint256 index) public  {
194   if (loans[index].status==ACTIVE_STATUS && loans[index].lender==msg.sender)   {
195 
196       loans[index].status = ACTIVE_LOAN_CANCELED_BY_LENDER_STATUS;
197       emit LoanCanceledByLenderAtIndex(index); 
198   }
199 }
200 
201 
202 function stateBorrowerDefaulted(uint256 index) public  {
203   if (loans[index].status==ACTIVE_STATUS && loans[index].lender==msg.sender)   {
204     if (block.number>SafeMath.add(loans[index].startBlock,loans[index].loanLength)){
205       emit Defaulted(index,msg.sender); 
206       loans[index].status=DEFAULTED_STATUS;
207     }
208   }
209 }
210 
211 
212 function declareDefaultAsBorrower(uint256 index) public  {
213   if (loans[index].status==ACTIVE_STATUS && loans[index].borrower==msg.sender)   {
214       emit Defaulted(index,msg.sender); 
215       loans[index].status=DEFAULTED_STATUS;
216   }
217 }
218 
219 
220 function attemptBeginLoanAtIndex(uint256 index) public returns(bool) {
221     if (loans[index].status==REQUESTED_STATUS)    {
222     	if (loans[index].lender==0x000000000000000000000000000000000000dEaD)	{
223 			
224 			if (msg.sender==loans[index].borrower) revert();
225 			loans[index].lender=msg.sender;
226 			
227 			emit LenderClaimedLoanAtIndex(msg.sender,index);
228 		} else	{
229 			if (!(msg.sender==loans[index].lender)) revert();
230 		}
231 		
232         
233         loans[index].status=ACTIVE_STATUS;
234         loans[index].startBlock = block.number;
235         emit LoanBegunAtIndex(index);
236         
237         if (! elixir(ELIX_ADDRESS).transferFrom(msg.sender, loans[index].borrower, loans[index].amount) ) revert();
238         return true;
239     }
240     return false;
241 }
242 
243 
244 function payAmountForLoanAtIndex(uint256 amount,uint256 index) public {
245 
246     if (loans[index].status==ACTIVE_STATUS && msg.sender==loans[index].borrower && amount>0)    {
247         require(amount <= SafeMath.add(MAX_LOAN_AMOUNT,MAX_INTEREST_AMOUNT));
248         require( SafeMath.add(amount, loans[index].amountPaidBackSoFar) <= SafeMath.add(loans[index].amount, loans[index].interest) );
249     
250         if (block.number==loans[index].startBlock) revert();
251     	        
252        
253         loans[index].amountPaidBackSoFar = SafeMath.add(loans[index].amountPaidBackSoFar,amount);
254         
255         if (loans[index].amountPaidBackSoFar == SafeMath.add(loans[index].amount,loans[index].interest))    {
256             loanCompleted(index, amount);
257         } else {
258             emit PaidBackPortionForLoanAtIndex(index,amount); 
259             
260             if (! elixir(ELIX_ADDRESS).transferFrom(msg.sender,loans[index].lender, amount)) revert();
261         }
262     }
263 }
264 
265 
266 
267 function returnBorrower(uint256 index) public returns(address)	{
268 	return loans[index].borrower;
269 }
270 
271 function returnLender(uint256 index) public returns(address)	{
272 	return loans[index].lender;
273 }
274 
275 function returnVolAdjuster(uint256 index) public returns(address)	{
276 	return loans[index].volAddress;
277 }
278 
279 function returnStartBlock(uint256 index) returns(uint256)	{
280 	return loans[index].startBlock;
281 }
282 
283 function returnAmount(uint256 index) returns(uint256)	{
284 	return loans[index].amount;
285 }
286 
287 function returnPaidBackBlock(uint256 index) returns(uint256)	{
288 	return loans[index].paidBackBlock;
289 }
290 
291 function returnLoanStatus(uint256 index) public returns(uint256)	{
292 	return loans[index].status;
293 }
294 
295 function returnAmountPaidBackSoFar(uint256 index) public returns(uint256)	{
296 	return loans[index].amountPaidBackSoFar;
297 }
298 
299 function returnLoanLength(uint256 index) public returns(uint256)	{
300 	return loans[index].loanLength;
301 }
302 
303 function returnInterest(uint256 index) public returns(uint256)	{
304 	return loans[index].interest;
305 }
306 
307 function returnBorrowerPaidLate(uint256 index) public returns(bool)	{
308 	return loans[index].borrowerPaidLate;
309 }
310 
311 function returnRequestCancel(uint256 index) public returns(bool)	{
312 	return loans[index].requestCancel;
313 }
314 
315 function returnMessage(uint256 index) public returns(string)	{
316 	return loans[index].message;
317 }
318 
319 function getLoansCount() public returns(uint256) {
320     return loans.length;
321 }
322 
323 function returnAmountPlusInterest(uint256 index) returns(uint256)	{
324 	return SafeMath.add(loans[index].amount,loans[index].interest);
325 }
326 
327 }
328 
329 contract elixir {
330     function transfer(address _to, uint256 _amount) returns (bool success);
331     function transferFrom(address _from,address _to,uint256 _amount) returns (bool success);
332 }