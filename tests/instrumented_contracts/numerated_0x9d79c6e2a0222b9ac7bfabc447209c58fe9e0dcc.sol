1 pragma solidity ^0.4.24;
2 
3 // File: contracts/PeriodUtil.sol
4 
5 /**
6  * @title PeriodUtil
7  * 
8  * Interface used for Period calculation to allow better automated testing of Fees Contract
9  *
10  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
11  */
12 contract PeriodUtil {
13     /**
14     * @dev calculates the Period index for the given timestamp
15     * @return Period count since EPOCH
16     * @param timestamp The time in seconds since EPOCH (blocktime)
17     */
18     function getPeriodIdx(uint256 timestamp) public pure returns (uint256);
19     
20     /**
21     * @dev Timestamp of the period start
22     * @return Time in seconds since EPOCH of the Period Start
23     * @param periodIdx Period Index to find the start timestamp of
24     */
25     function getPeriodStartTimestamp(uint256 periodIdx) public pure returns (uint256);
26 
27     /**
28     * @dev Returns the Cycle count of the given Periods. A set of time creates a cycle, eg. If period is weeks the cycle can be years.
29     * @return The Cycle Index
30     * @param timestamp The time in seconds since EPOCH (blocktime)
31     */
32     function getPeriodCycle(uint256 timestamp) public pure returns (uint256);
33 
34     /**
35     * @dev Amount of Tokens per time unit since the start of the given periodIdx
36     * @return Tokens per Time Unit from the given periodIdx start till now
37     * @param tokens Total amount of tokens from periodIdx start till now (blocktime)
38     * @param periodIdx Period IDX to use for time start
39     */
40     function getRatePerTimeUnits(uint256 tokens, uint256 periodIdx) public view returns (uint256);
41 
42     /**
43     * @dev Amount of time units in each Period, for exampe if units is hour and period is week it will be 168
44     * @return Amount of time units per period
45     */
46     function getUnitsPerPeriod() public pure returns (uint256);
47 }
48 
49 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * See https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address _who) public view returns (uint256);
59   function transfer(address _to, uint256 _value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 // File: contracts/ERC20Burnable.sol
64 
65 /**
66  * @title BurnableToken
67  * 
68  * Interface for Basic ERC20 interactions and allowing burning  of tokens
69  *
70  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
71  */
72 contract ERC20Burnable is ERC20Basic {
73 
74     function burn(uint256 _value) public;
75 }
76 
77 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
78 
79 /**
80  * @title SafeMath
81  * @dev Math operations with safety checks that throw on error
82  */
83 library SafeMath {
84 
85   /**
86   * @dev Multiplies two numbers, throws on overflow.
87   */
88   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
89     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
90     // benefit is lost if 'b' is also tested.
91     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92     if (_a == 0) {
93       return 0;
94     }
95 
96     c = _a * _b;
97     assert(c / _a == _b);
98     return c;
99   }
100 
101   /**
102   * @dev Integer division of two numbers, truncating the quotient.
103   */
104   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     // assert(_b > 0); // Solidity automatically throws when dividing by 0
106     // uint256 c = _a / _b;
107     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
108     return _a / _b;
109   }
110 
111   /**
112   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
113   */
114   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
115     assert(_b <= _a);
116     return _a - _b;
117   }
118 
119   /**
120   * @dev Adds two numbers, throws on overflow.
121   */
122   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
123     c = _a + _b;
124     assert(c >= _a);
125     return c;
126   }
127 }
128 
129 // File: contracts/ZCFees.sol
130 
131 /**
132  * @title ZCFees
133  * 
134  * Used to process transaction
135  *
136  * (c) Philip Louw / Zero Carbon Project 2018. The MIT Licence.
137  */
138 contract ZCFees {
139 
140     using SafeMath for uint256;
141 
142     struct PaymentHistory {
143         // If set 
144         bool paid;
145         // Payment to Fees
146         uint256 fees;
147         // Payment to Reward
148         uint256 reward;
149         // End of period token balance
150         uint256 endBalance;
151     }
152 
153     uint256 public totalRewards;
154     uint256 public totalFees;
155 
156     mapping (uint256 => PaymentHistory) payments;
157     address public tokenAddress;
158     PeriodUtil public periodUtil;
159     // Last week that has been executed
160     uint256 public lastPeriodExecIdx;
161     // Last Year that has been processed
162     uint256 public lastPeriodCycleExecIdx;
163     // Amount of time in seconds grase processing time
164     uint256 grasePeriod;
165 
166     // Wallet for Fees payments
167     address public feesWallet;
168     // Wallet for Reward payments
169     address public rewardWallet;
170     
171     // Fees 1 : % tokens taken per week
172     uint256 internal constant FEES1_PER = 10;
173     // Fees 1 : Max token payout per week
174     uint256 internal constant FEES1_MAX_AMOUNT = 400000 * (10**18);
175     // Fees 2 : % tokens taken per week
176     uint256 internal constant FEES2_PER = 10;
177     // Fees 2 : Max token payout per week
178     uint256 internal constant FEES2_MAX_AMOUNT = 800000 * (10**18);
179     // Min Amount of Fees to pay out per week
180     uint256 internal constant FEES_TOKEN_MIN_AMOUNT = 24000 * (10**18);
181     // Min Percentage Prev Week to pay out per week
182     uint256 internal constant FEES_TOKEN_MIN_PERPREV = 95;
183     // Rewards Percentage of Period Received
184     uint256 internal constant REWARD_PER = 70;
185     // % Amount of remaining tokens to burn at end of year
186     uint256 internal constant BURN_PER = 25;
187     
188     /**
189      * @param _tokenAdr The Address of the Token
190      * @param _periodUtilAdr The Address of the PeriodUtil
191      * @param _grasePeriod The time in seconds you allowed to process payments before avg is calculated into next period(s)
192      * @param _feesWallet Where the fees are sent in tokens
193      * @param _rewardWallet Where the rewards are sent in tokens
194      */
195     constructor (address _tokenAdr, address _periodUtilAdr, uint256 _grasePeriod, address _feesWallet, address _rewardWallet) public {
196         assert(_tokenAdr != address(0));
197         assert(_feesWallet != address(0));
198         assert(_rewardWallet != address(0));
199         assert(_periodUtilAdr != address(0));
200         tokenAddress = _tokenAdr;
201         feesWallet = _feesWallet;
202         rewardWallet = _rewardWallet;
203         periodUtil = PeriodUtil(_periodUtilAdr);
204 
205         grasePeriod = _grasePeriod;
206         assert(grasePeriod > 0);
207         // GrasePeriod must be less than period
208         uint256 va1 = periodUtil.getPeriodStartTimestamp(1);
209         uint256 va2 = periodUtil.getPeriodStartTimestamp(0);
210         assert(grasePeriod < (va1 - va2));
211 
212         // Set the previous period values;
213         lastPeriodExecIdx = getWeekIdx() - 1;
214         lastPeriodCycleExecIdx = getYearIdx();
215         PaymentHistory storage prevPayment = payments[lastPeriodExecIdx];
216         prevPayment.fees = 0;
217         prevPayment.reward = 0;
218         prevPayment.paid = true;
219         prevPayment.endBalance = 0;
220     }
221 
222     /**
223      * @dev Call when Fees processing needs to happen. Can only be called by the contract Owner
224      */
225     function process() public {
226         uint256 currPeriodIdx = getWeekIdx();
227 
228         // Has the previous period been calculated?
229         if (lastPeriodExecIdx == (currPeriodIdx - 1)) {
230             // Nothing to do previous week has Already been processed
231             return;
232         }
233 
234         if ((currPeriodIdx - lastPeriodExecIdx) == 2) {
235             paymentOnTime(currPeriodIdx);
236             // End Of Year Payment
237             if (lastPeriodCycleExecIdx < getYearIdx()) {
238                 processEndOfYear(currPeriodIdx - 1);
239             }
240         }
241         else {
242             uint256 availableTokens = currentBalance();
243             // Missed Full Period! Very Bad!
244             PaymentHistory memory lastExecPeriod = payments[lastPeriodExecIdx];
245             uint256 tokensReceived = availableTokens.sub(lastExecPeriod.endBalance);
246             // Average amount of tokens received per hour till now
247             uint256 tokenHourlyRate = periodUtil.getRatePerTimeUnits(tokensReceived, lastPeriodExecIdx + 1);
248 
249             PaymentHistory memory prePeriod;
250 
251             for (uint256 calcPeriodIdx = lastPeriodExecIdx + 1; calcPeriodIdx < currPeriodIdx; calcPeriodIdx++) {
252                 prePeriod = payments[calcPeriodIdx - 1];
253                 uint256 periodTokenReceived = periodUtil.getUnitsPerPeriod().mul(tokenHourlyRate);
254                 makePayments(prePeriod, payments[calcPeriodIdx], periodTokenReceived, prePeriod.endBalance.add(periodTokenReceived), calcPeriodIdx);
255 
256                 if (periodUtil.getPeriodCycle(periodUtil.getPeriodStartTimestamp(calcPeriodIdx + 1)) > lastPeriodCycleExecIdx) {
257                     processEndOfYear(calcPeriodIdx);
258                 }
259             }
260         }
261 
262         assert(payments[currPeriodIdx - 1].paid);
263         lastPeriodExecIdx = currPeriodIdx - 1;
264     }
265 
266     /**
267      * @dev Internal function to process end of year Clearance
268      * @param yearEndPeriodCycle The Last Period Idx (Week Idx) of the year
269      */
270     function processEndOfYear(uint256 yearEndPeriodCycle) internal {
271         PaymentHistory storage lastYearPeriod = payments[yearEndPeriodCycle];
272         uint256 availableTokens = currentBalance();
273         uint256 tokensToClear = min256(availableTokens,lastYearPeriod.endBalance);
274 
275         // Burn some of tokens
276         uint256 tokensToBurn = tokensToClear.mul(BURN_PER).div(100);
277         ERC20Burnable(tokenAddress).burn(tokensToBurn);
278 
279         uint256 tokensToFeesWallet = tokensToClear.sub(tokensToBurn);
280         totalFees = totalFees.add(tokensToFeesWallet);
281         assert(ERC20Burnable(tokenAddress).transfer(feesWallet, tokensToFeesWallet));
282         lastPeriodCycleExecIdx = lastPeriodCycleExecIdx + 1;
283         lastYearPeriod.endBalance = 0;
284 
285         emit YearEndClearance(lastPeriodCycleExecIdx, tokensToFeesWallet, tokensToBurn);
286     }
287 
288     /**
289      * @dev Called when Payments are call within a week of last payment
290      * @param currPeriodIdx Current Period Idx (Week)
291      */
292     function paymentOnTime(uint256 currPeriodIdx) internal {
293     
294         uint256 availableTokens = currentBalance();
295         PaymentHistory memory prePeriod = payments[currPeriodIdx - 2];
296 
297         uint256 tokensRecvInPeriod = availableTokens.sub(prePeriod.endBalance);
298 
299         if (tokensRecvInPeriod <= 0) {
300             tokensRecvInPeriod = 0;
301         }
302         else if ((now - periodUtil.getPeriodStartTimestamp(currPeriodIdx)) > grasePeriod) {
303             tokensRecvInPeriod = periodUtil.getRatePerTimeUnits(tokensRecvInPeriod, currPeriodIdx - 1).mul(periodUtil.getUnitsPerPeriod());
304             if (tokensRecvInPeriod <= 0) {
305                 tokensRecvInPeriod = 0;
306             }
307             assert(availableTokens >= tokensRecvInPeriod);
308         }   
309 
310         makePayments(prePeriod, payments[currPeriodIdx - 1], tokensRecvInPeriod, prePeriod.endBalance + tokensRecvInPeriod, currPeriodIdx - 1);
311     }
312 
313     /**
314     * @dev Process a payment period
315     * @param prevPayment Previous periods payment records
316     * @param currPayment Current periods payment records to be updated
317     * @param tokensRaised Tokens received for the period
318     * @param availableTokens Contract available balance including the tokens received for the period
319     */
320     function makePayments(PaymentHistory memory prevPayment, PaymentHistory storage currPayment, uint256 tokensRaised, uint256 availableTokens, uint256 weekIdx) internal {
321 
322         assert(prevPayment.paid);
323         assert(!currPayment.paid);
324         assert(availableTokens >= tokensRaised);
325 
326         // Fees 1 Payment
327         uint256 fees1Pay = tokensRaised == 0 ? 0 : tokensRaised.mul(FEES1_PER).div(100);
328         if (fees1Pay >= FEES1_MAX_AMOUNT) {
329             fees1Pay = FEES1_MAX_AMOUNT;
330         }
331         // Fees 2 Payment
332         uint256 fees2Pay = tokensRaised == 0 ? 0 : tokensRaised.mul(FEES2_PER).div(100);
333         if (fees2Pay >= FEES2_MAX_AMOUNT) {
334             fees2Pay = FEES2_MAX_AMOUNT;
335         }
336 
337         uint256 feesPay = fees1Pay.add(fees2Pay);
338         if (feesPay >= availableTokens) {
339             feesPay = availableTokens;
340         } else {
341             // Calculates the Min percentage of previous month to pay
342             uint256 prevFees95 = prevPayment.fees.mul(FEES_TOKEN_MIN_PERPREV).div(100);
343             // Minimum amount of fees that is required
344             uint256 minFeesPay = max256(FEES_TOKEN_MIN_AMOUNT, prevFees95);
345             feesPay = max256(feesPay, minFeesPay);
346             feesPay = min256(feesPay, availableTokens);
347         }
348 
349         // Rewards Payout
350         uint256 rewardPay = 0;
351         if (feesPay < tokensRaised) {
352             // There is money left for reward pool
353             rewardPay = tokensRaised.mul(REWARD_PER).div(100);
354             rewardPay = min256(rewardPay, availableTokens.sub(feesPay));
355         }
356 
357         currPayment.fees = feesPay;
358         currPayment.reward = rewardPay;
359 
360         totalFees = totalFees.add(feesPay);
361         totalRewards = totalRewards.add(rewardPay);
362 
363         assert(ERC20Burnable(tokenAddress).transfer(rewardWallet, rewardPay));
364         assert(ERC20Burnable(tokenAddress).transfer(feesWallet, feesPay));
365 
366         currPayment.endBalance = availableTokens - feesPay - rewardPay;
367         currPayment.paid = true;
368 
369         emit Payment(weekIdx, rewardPay, feesPay);
370     }
371 
372     /**
373     * @dev Event when payment was made
374     * @param weekIdx Week Idx since EPOCH for payment
375     * @param rewardPay Amount of tokens paid to the reward pool
376     * @param feesPay Amount of tokens paid in fees
377     */
378     event Payment(uint256 weekIdx, uint256 rewardPay, uint256 feesPay);
379 
380     /**
381     * @dev Event when year end clearance happens
382     * @param yearIdx Year the clearance happend for
383     * @param feesPay Amount of tokens paid in fees
384     * @param burned Amount of tokens burned
385     */
386     event YearEndClearance(uint256 yearIdx, uint256 feesPay, uint256 burned);
387 
388 
389     /**
390     * @dev Returns the token balance of the Fees contract
391     */
392     function currentBalance() internal view returns (uint256) {
393         return ERC20Burnable(tokenAddress).balanceOf(address(this));
394     }
395 
396     /**
397     * @dev Returns the amount of weeks since EPOCH
398     * @return Week count since EPOCH
399     */
400     function getWeekIdx() public view returns (uint256) {
401         return periodUtil.getPeriodIdx(now);
402     }
403 
404     /**
405     * @dev Returns the Year
406     */
407     function getYearIdx() public view returns (uint256) {
408         return periodUtil.getPeriodCycle(now);
409     }
410 
411     /**
412     * @dev Returns true if the week has been processed and paid out
413     * @param weekIdx Weeks since EPOCH
414     * @return true if week has been paid out
415     */
416     function weekProcessed(uint256 weekIdx) public view returns (bool) {
417         return payments[weekIdx].paid;
418     }
419 
420     /**
421     * @dev Returns the amounts paid out for the given week
422     * @param weekIdx Weeks since EPOCH
423     */
424     function paymentForWeek(uint256 weekIdx) public view returns (uint256 fees, uint256 reward) {
425         PaymentHistory storage history = payments[weekIdx];
426         fees = history.fees;
427         reward = history.reward;
428     }
429 
430     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
431         return a >= b ? a : b;
432     }
433 
434     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
435         return a < b ? a : b;
436     }
437 }