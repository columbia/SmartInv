1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 pragma solidity ^0.4.11;
57 
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() {
76     owner = msg.sender;
77   }
78 
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) onlyOwner public {
94     require(newOwner != address(0));
95     OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 
102 contract DebtToken {
103   using SafeMath for uint256;
104   /**
105   Recognition data
106   */
107   string public name;
108   string public symbol;
109   string public version = 'DT0.1';
110   uint256 public decimals = 18;
111 
112   /**
113   ERC20 properties
114   */
115   uint256 public totalSupply;
116   mapping(address => uint256) public balances;
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 
119   /**
120   Mintable Token properties
121   */
122   bool public mintingFinished = true;
123   event Mint(address indexed to, uint256 amount);
124   event MintFinished();
125 
126   /**
127   Actual logic data
128   */
129   uint256 public dayLength;//Number of seconds in a day
130   uint256 public loanTerm;//Loan term in days
131   uint256 public exchangeRate; //Exchange rate for Ether to loan coins
132   uint256 public initialSupply; //Keep record of Initial value of Loan
133   uint256 public loanActivation; //Timestamp the loan was funded
134   
135   uint256 public interestRatePerCycle; //Interest rate per interest cycle
136   uint256 public interestCycleLength; //Total number of days per interest cycle
137   
138   uint256 public totalInterestCycles; //Total number of interest cycles completed
139   uint256 public lastInterestCycle; //Keep record of Initial value of Loan
140   
141   address public lender; //The address from which the loan will be funded, and to which the refund will be directed
142   address public borrower;
143   
144   uint256 public constant PERCENT_DIVISOR = 100;
145   
146   function DebtToken(
147       string _tokenName,
148       string _tokenSymbol,
149       uint256 _initialAmount,
150       uint256 _exchangeRate,
151       uint256 _dayLength,
152       uint256 _loanTerm,
153       uint256 _loanCycle,
154       uint256 _interestRatePerCycle,
155       address _lender,
156       address _borrower
157       ) {
158 
159       require(_exchangeRate > 0);
160       require(_initialAmount > 0);
161       require(_dayLength > 0);
162       require(_loanCycle > 0);
163 
164       require(_lender != 0x0);
165       require(_borrower != 0x0);
166       
167       exchangeRate = _exchangeRate;                           // Exchange rate for the coins
168       initialSupply = _initialAmount.mul(exchangeRate);            // Update initial supply
169       totalSupply = initialSupply;                           //Update total supply
170       balances[_borrower] = initialSupply;                 // Give the creator all initial tokens
171 
172       name = _tokenName;                                    // Amount of decimals for display purposes
173       symbol = _tokenSymbol;                              // Set the symbol for display purposes
174       
175       dayLength = _dayLength;                             //Set the length of each day in seconds...For dev purposes
176       loanTerm = _loanTerm;                               //Set the number of days, for loan maturity
177       interestCycleLength = _loanCycle;                   //set the Interest cycle period
178       interestRatePerCycle = _interestRatePerCycle;                      //Set the Interest rate per cycle
179       lender = _lender;                             //set lender address
180       borrower = _borrower;
181 
182       Transfer(0,_borrower,totalSupply);//Allow funding be tracked
183   }
184 
185   /**
186   Debt token functionality
187    */
188   function actualTotalSupply() public constant returns(uint) {
189     uint256 coins;
190     uint256 cycle;
191     (coins,cycle) = calculateInterestDue();
192     return totalSupply.add(coins);
193   }
194 
195   /**
196   Fetch total value of loan in wei (Initial +interest)
197   */
198   function getLoanValue(bool initial) public constant returns(uint){
199     //TODO get a more dynamic way to calculate
200     if(initial == true)
201       return initialSupply.div(exchangeRate);
202     else{
203       uint totalTokens = actualTotalSupply().sub(balances[borrower]);
204       return totalTokens.div(exchangeRate);
205     }
206   }
207 
208   /**
209   Fetch total coins gained from interest
210   */
211   function getInterest() public constant returns (uint){
212     return actualTotalSupply().sub(initialSupply);
213   }
214 
215   /**
216   Checks that caller's address is the lender
217   */
218   function isLender() private constant returns(bool){
219     return msg.sender == lender;
220   }
221 
222   /**
223   Check that caller's address is the borrower
224   */
225   function isBorrower() private constant returns (bool){
226     return msg.sender == borrower;
227   }
228 
229   function isLoanFunded() public constant returns(bool) {
230     return balances[lender] > 0 && balances[borrower] == 0;
231   }
232 
233   /**
234   Check if the loan is mature for interest
235   */
236   function isTermOver() public constant returns (bool){
237     if(loanActivation == 0)
238       return false;
239     else
240       return now >= loanActivation.add( dayLength.mul(loanTerm) );
241   }
242 
243   /**
244   Check if updateInterest() needs to be called before refundLoan()
245   */
246   function isInterestStatusUpdated() public constant returns(bool){
247     if(!isTermOver())
248       return true;
249     else
250       return !( now >= lastInterestCycle.add( interestCycleLength.mul(dayLength) ) );
251   }
252 
253   /**
254   calculate the total number of passed interest cycles and coin value
255   */
256   function calculateInterestDue() public constant returns(uint256 _coins,uint256 _cycle){
257     if(!isTermOver() || !isLoanFunded())
258       return (0,0);
259     else{
260       uint timeDiff = now.sub(lastInterestCycle);
261       _cycle = timeDiff.div(dayLength.mul(interestCycleLength) );
262       _coins = _cycle.mul( interestRatePerCycle.mul(initialSupply) ).div(PERCENT_DIVISOR);//Delayed division to avoid too early floor
263     }
264   }
265 
266   /**
267   Update the interest of the contract
268   */
269   function updateInterest() public {
270     require( isTermOver() );
271     uint interest_coins;
272     uint256 interest_cycle;
273     (interest_coins,interest_cycle) = calculateInterestDue();
274     assert(interest_coins > 0 && interest_cycle > 0);
275     totalInterestCycles =  totalInterestCycles.add(interest_cycle);
276     lastInterestCycle = lastInterestCycle.add( interest_cycle.mul( interestCycleLength.mul(dayLength) ) );
277     mint(lender , interest_coins);
278   }
279 
280   /**
281   Make payment to inititate loan
282   */
283   function fundLoan() public payable{
284     require(isLender());
285     require(msg.value == getLoanValue(true)); //Ensure input available
286     require(!isLoanFunded()); //Avoid double payment
287 
288     loanActivation = now;  //store the time loan was activated
289     lastInterestCycle = now.add(dayLength.mul(loanTerm) ) ; //store the date interest matures
290     mintingFinished = false;                 //Enable minting
291     transferFrom(borrower,lender,totalSupply);
292 
293     borrower.transfer(msg.value);
294   }
295 
296   /**
297   Make payment to refund loan
298   */
299   function refundLoan() onlyBorrower public payable{
300     if(! isInterestStatusUpdated() )
301         updateInterest(); //Ensure Interest is updated
302 
303     require(msg.value == getLoanValue(false));
304     require(isLoanFunded());
305 
306     finishMinting() ;//Prevent further Minting
307     transferFrom(lender,borrower,totalSupply);
308 
309     lender.transfer(msg.value);
310   }
311 
312   /**
313   Partial ERC20 functionality
314    */
315 
316   function balanceOf(address _owner) public constant returns (uint256 balance) {
317     return balances[_owner];
318   }
319 
320   function transferFrom(address _from, address _to, uint256 _value) internal {
321     require(_to != address(0));
322 
323     balances[_from] = balances[_from].sub(_value);
324     balances[_to] = balances[_to].add(_value);
325     Transfer(_from, _to, _value);
326   }
327 
328   /**
329   MintableToken functionality
330    */
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(address _to, uint256 _amount) canMint internal returns (bool) {
344     totalSupply = totalSupply.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     Mint(_to, _amount);
347     Transfer(0x0, _to, _amount);
348     return true;
349   }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355   function finishMinting() onlyBorrower internal returns (bool) {
356     mintingFinished = true;
357     MintFinished();
358     return true;
359   }
360 
361 
362   /**
363   Fallback function
364   */
365   function() public payable{
366     require(initialSupply > 0);//Stop the whole process if initialSupply not set
367     if(isBorrower())
368       refundLoan();
369     else if(isLender())
370       fundLoan();
371     else revert(); //Throw if neither of cases apply, ensure no free money
372   }
373 
374   /**
375   Modifiers
376   */
377   modifier onlyBorrower() {
378     require(isBorrower());
379     _;
380   }
381 }
382 
383 contract DebtTokenDeployer is Ownable{
384 
385     address public dayTokenAddress;
386     uint public dayTokenFees; //DAY tokens to be paid for deploying custom DAY contract
387     ERC20 dayToken;
388 
389     event FeeUpdated(uint _fee, uint _time);
390     event DebtTokenCreated(address  _creator, address _debtTokenAddress, uint256 _time);
391 
392     function DebtTokenDeployer(address _dayTokenAddress, uint _dayTokenFees){
393         dayTokenAddress = _dayTokenAddress;
394         dayTokenFees = _dayTokenFees;
395         dayToken = ERC20(dayTokenAddress);
396     }
397 
398     function updateDayTokenFees(uint _dayTokenFees) onlyOwner public {
399         dayTokenFees = _dayTokenFees;
400         FeeUpdated(dayTokenFees, now);
401     }
402 
403     function createDebtToken(string _tokenName,
404         string _tokenSymbol,
405         uint256 _initialAmount,
406         uint256 _exchangeRate,
407         uint256 _dayLength,
408         uint256 _loanTerm,
409         uint256 _loanCycle,
410         uint256 _intrestRatePerCycle,
411         address _lender)
412     public
413     {
414         if(dayToken.transferFrom(msg.sender, this, dayTokenFees)){
415             DebtToken newDebtToken = new DebtToken(_tokenName, _tokenSymbol, _initialAmount, _exchangeRate,
416                  _dayLength, _loanTerm, _loanCycle,
417                 _intrestRatePerCycle, _lender, msg.sender);
418             DebtTokenCreated(msg.sender, address(newDebtToken), now);
419         }
420     }
421 
422     // to collect all fees paid till now
423     function fetchDayTokens() onlyOwner public {
424         dayToken.transfer(owner, dayToken.balanceOf(this));
425     }
426 }