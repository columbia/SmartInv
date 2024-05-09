1 pragma solidity ^0.4.11;
2 
3 // File: zeppelin-solidity/contracts/math/Math.sol
4 
5 /**
6  * @title Math
7  * @dev Assorted math operations
8  */
9 
10 library Math {
11   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
12     return a >= b ? a : b;
13   }
14 
15   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
16     return a < b ? a : b;
17   }
18 
19   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
20     return a >= b ? a : b;
21   }
22 
23   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
24     return a < b ? a : b;
25   }
26 }
27 
28 // File: zeppelin-solidity/contracts/math/SafeMath.sol
29 
30 /**
31  * @title SafeMath
32  * @dev Math operations with safety checks that throw on error
33  */
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 // File: contracts/StandingOrder.sol
61 
62 /**
63  * @title Standing order
64  * @dev Lifecycle of a standing order:
65  *  - the payment amount per interval is set at construction time and can not be changed afterwards
66  *  - the payee is set by the owner and can not be changed after creation
67  *  - at <startTime> (unix timestamp) the first payment is due
68  *  - every <intervall> seconds the next payment is due
69  *  - the owner can add funds to the order contract at any time
70  *  - the owner can withdraw only funds that do not (yet) belong to the payee
71  *  - the owner can terminate a standingorder anytime. Termination results in:
72  *    - No further funding being allowed
73  *    - order marked as "terminated" and not being displayed anymore in owner UI
74  *    - as long as there are uncollected funds entitled to the payee, it is still displayed in payee UI
75  *    - the payee can still collect funds owned to him
76  *
77  *   * Terminology *
78  *   "withdraw" -> performed by owner - transfer funds stored in contract back to owner
79  *   "collect"  -> performed by payee - transfer entitled funds from contract to payee
80  *
81  *   * How does a payment work? *
82  *   Since a contract can not trigger a payment by itself, it provides the method "collectFunds" for the payee.
83  *   The payee can always query the contract to determine how many funds he is entitled to collect.
84  *   The payee can call "collectFunds" to initiate transfer of entitled funds to his address.
85  */
86 contract StandingOrder {
87 
88     using SafeMath for uint;
89     using Math for uint;
90 
91     address public owner;        /** The owner of this order */
92     address public payee;        /** The payee is the receiver of funds */
93     uint public startTime;       /** Date and time (unix timestamp - seconds since 1970) when first payment can be claimed by payee */
94     uint public paymentInterval; /** Interval for payments (Unit: seconds) */
95     uint public paymentAmount;   /** How much can payee claim per period (Unit: Wei) */
96     uint public claimedFunds;    /** How much funds have been claimed already (Unit: Wei) */
97     string public ownerLabel;    /** Label (set by contract owner) */
98     bool public isTerminated;    /** Marks order as terminated */
99     uint public terminationTime; /** Date and time (unix timestamp - seconds since 1970) when order terminated */
100 
101     modifier onlyPayee() {
102         require(msg.sender == payee);
103         _;
104     }
105 
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111     /** Event triggered when payee collects funds */
112     event Collect(uint amount);
113     /** Event triggered when contract gets funded */
114     event Fund(uint amount);
115     /** Event triggered when owner withdraws funds */
116     event Withdraw(uint amount);
117 
118     /**
119      * Constructor
120      * @param _owner The owner of the contract
121      * @param _payee The payee - the account that can collect payments from this contract
122      * @param _paymentInterval Interval for payments, unit: seconds
123      * @param _paymentAmount The amount payee can claim per period, unit: wei
124      * @param _startTime Date and time (unix timestamp - seconds since 1970) when first payment can be claimed by payee
125      * @param _label Label for contract, e.g "rent" or "weekly paycheck"
126      */
127     function StandingOrder(
128         address _owner,
129         address _payee,
130         uint _paymentInterval,
131         uint _paymentAmount,
132         uint _startTime,
133         string _label
134     )
135         payable
136     {
137         // Sanity check parameters
138         require(_paymentInterval > 0);
139         require(_paymentAmount > 0);
140         // Following check is not exact for unicode strings, but here i just want to make sure that some label is provided
141         // See https://ethereum.stackexchange.com/questions/13862/is-it-possible-to-check-string-variables-length-inside-the-contract/13886
142         require(bytes(_label).length > 2);
143 
144         // Set owner to _owner, as msg.sender is the StandingOrderFactory contract
145         owner = _owner;
146 
147         payee = _payee;
148         paymentInterval = _paymentInterval;
149         paymentAmount = _paymentAmount;
150         ownerLabel = _label;
151         startTime = _startTime;
152         isTerminated = false;
153     }
154 
155     /**
156      * Fallback function.
157      * Allows adding funds to existing order. Will throw in case the order is terminated!
158      */
159     function() payable {
160         if (isTerminated) {
161             // adding funds not allowed for terminated orders
162             revert();
163         }
164         // Log Fund event
165         Fund(msg.value);
166     }
167 
168     /**
169      * Determine how much funds payee is entitled to collect
170      * Note that this might be more than actual funds available!
171      * @return Number of wei that payee is entitled to collect
172      */
173     function getEntitledFunds() constant returns (uint) {
174         // First check if the contract startTime has been reached at all
175         if (now < startTime) {
176             // startTime not yet reached
177             return 0;
178         }
179 
180         // startTime has been reached, so add first payment
181         uint entitledAmount = paymentAmount;
182 
183         // Determine endTime for calculation. If order has been terminated -> terminationTime, otherwise current time
184         uint endTime = isTerminated ? terminationTime : now;
185 
186         // calculate number of complete intervals since startTime
187         uint runtime = endTime.sub(startTime);
188         uint completeIntervals = runtime.div(paymentInterval); // Division always truncates, so implicitly rounding down here.
189         entitledAmount = entitledAmount.add(completeIntervals.mul(paymentAmount));
190 
191         // subtract already collected funds
192         return entitledAmount.sub(claimedFunds);
193     }
194 
195     /**
196      * Determine how much funds are available for payee to collect
197      * This can be less than the entitled amount if the contract does not have enough funds to cover the due payments,
198      * in other words: The owner has not put enough funds into the contract.
199      * @return Number of wei that payee can collect
200      */
201     function getUnclaimedFunds() constant returns (uint) {
202         // don't return more than available balance
203         return getEntitledFunds().min256(this.balance);
204     }
205 
206     /**
207      * Determine how much funds are still owned by owner (not yet reserved for payee)
208      * Note that this can be negative in case contract is not funded enough to cover entitled amount for payee!
209      * @return number of wei belonging owner, negative if contract is missing funds to cover payments
210      */
211     function getOwnerFunds() constant returns (int) {
212         // Conversion from unsigned int to int will produce unexpected results only for very large
213         // numbers (2^255 and greater). This is about 5.7e+58 ether.
214         // -> There will be no situation when the contract balance (this.balance) will hit this limit
215         // -> getEntitledFunds() might end up hitting this limit when the contract creator INTENTIONALLY sets
216         //    any combination of absurdly high payment rate, low interval or a startTime way in the past.
217         //    Being entitled to more than 5.7e+58 ether obviously will never be an expected usecase
218         // Therefor the conversion can be considered safe here.
219         return int256(this.balance) - int256(getEntitledFunds());
220     }
221 
222     /**
223      * Collect payment
224      * Can only be called by payee. This will transfer all available funds (see getUnclaimedFunds) to payee
225      * @return amount that has been transferred!
226      */
227     function collectFunds() onlyPayee returns(uint) {
228         uint amount = getUnclaimedFunds();
229         if (amount <= 0) {
230             // nothing to collect :-(
231             revert();
232         }
233 
234         // keep track of collected funds
235         claimedFunds = claimedFunds.add(amount);
236 
237         // create log entry
238         Collect(amount);
239 
240         // initiate transfer of unclaimed funds to payee
241         payee.transfer(amount);
242 
243         return amount;
244     }
245 
246     /**
247      * Withdraw requested amount back to owner.
248      * Only funds not (yet) reserved for payee can be withdrawn. So it is not possible for the owner
249      * to withdraw unclaimed funds - They can only be claimed by payee!
250      * Withdrawing funds does not terminate the order, at any time owner can fund it again!
251      * @param amount Number of wei owner wants to withdraw
252      */
253     function WithdrawOwnerFunds(uint amount) onlyOwner {
254         int intOwnerFunds = getOwnerFunds(); // this might be negative in case of underfunded contract!
255         if (intOwnerFunds <= 0) {
256             // nothing available to withdraw :-(
257             revert();
258         }
259         // conversion int -> uint is safe here as I'm checking <= 0 above!
260         uint256 ownerFunds = uint256(intOwnerFunds);
261 
262         if (amount > ownerFunds) {
263             // Trying to withdraw more than available!
264             revert();
265         }
266 
267         // Log Withdraw event
268         Withdraw(amount);
269 
270         owner.transfer(amount);
271     }
272 
273     /**
274      * Terminate order
275      * Marks the order as terminated.
276      * Can only be executed if no ownerfunds are left
277      */
278     function Terminate() onlyOwner {
279         assert(getOwnerFunds() <= 0);
280         terminationTime = now;
281         isTerminated = true;
282     }
283 }
284 
285 
286 /**
287  * @title StandingOrder factory
288  */
289 contract StandingOrderFactory {
290     // keep track who issued standing orders
291     mapping (address => StandingOrder[]) public standingOrdersByOwner;
292     // keep track of payees of standing orders
293     mapping (address => StandingOrder[]) public standingOrdersByPayee;
294 
295     // Events
296     event LogOrderCreated(
297         address orderAddress,
298         address indexed owner,
299         address indexed payee
300     );
301 
302     /**
303      * Create a new standing order
304      * The owner of the new order will be the address that called this function (msg.sender)
305      * @param _payee The payee - the account that can collect payments from this contract
306      * @param _paymentInterval Interval for payments, unit: seconds
307      * @param _paymentAmount The amount payee can claim per period, unit: wei
308      * @param _startTime Date and time (unix timestamp - seconds since 1970) when first payment can be claimed by payee
309      * @param _label Label for contract, e.g "rent" or "weekly paycheck"
310      * @return Address of new created standingOrder contract
311      */
312     function createStandingOrder(address _payee, uint _paymentAmount, uint _paymentInterval, uint _startTime, string _label) returns (StandingOrder) {
313         StandingOrder so = new StandingOrder(msg.sender, _payee, _paymentInterval, _paymentAmount, _startTime, _label);
314         standingOrdersByOwner[msg.sender].push(so);
315         standingOrdersByPayee[_payee].push(so);
316         LogOrderCreated(so, msg.sender, _payee);
317         return so;
318     }
319 
320     /**
321      * Determine how many orders are owned by caller (msg.sender)
322      * @return Number of orders
323      */
324     function getNumOrdersByOwner() constant returns (uint) {
325         return standingOrdersByOwner[msg.sender].length;
326     }
327 
328     /**
329      * Get order by index from the Owner mapping
330      * @param index Index of order
331      * @return standing order address
332      */
333     function getOwnOrderByIndex(uint index) constant returns (StandingOrder) {
334         return standingOrdersByOwner[msg.sender][index];
335     }
336 
337     /**
338      * Determine how many orders are paying to caller (msg.sender)
339      * @return Number of orders
340      */
341     function getNumOrdersByPayee() constant returns (uint) {
342         return standingOrdersByPayee[msg.sender].length;
343     }
344 
345     /**
346      * Get order by index from the Payee mapping
347      * @param index Index of order
348      * @return standing order address
349      */
350     function getPaidOrderByIndex(uint index) constant returns (StandingOrder) {
351         return standingOrdersByPayee[msg.sender][index];
352     }
353 }