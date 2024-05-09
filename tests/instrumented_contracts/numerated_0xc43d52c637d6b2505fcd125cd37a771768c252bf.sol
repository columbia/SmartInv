1 pragma solidity 0.4.18;
2 /**
3  * @title Masterium Token [MTI]
4  * @author primeRev
5  * @notice masterium [mti] token contract (tokensale, (cummulated) interest payouts, masternodes
6  */
7 
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a * b; assert(a == 0 || c / a == b); return c;}
15     //unused:: function div(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a / b; return c;}
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b <= a); return a - b;}
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b; assert(c >= a); return c;}
18 }
19 
20 /**
21  * @title ReentryProtected
22  * @dev Mutex based reentry protection
23  */
24 contract ReentryProtected {
25     /*
26     file:   ReentryProtection.sol (https://github.com/o0ragman0o/ReentryProtected)
27     ver:    0.3.0
28     updated:6-April-2016
29     author: Darryl Morris
30     email:  o0ragman0o AT gmail.com
31 
32     Mutex based reentry protection protect.
33 
34     This software is distributed in the hope that it will be useful,
35     but WITHOUT ANY WARRANTY; without even the implied warranty of
36     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
37     GNU lesser General Public License for more details.
38     <http://www.gnu.org/licenses/>.
39     */
40     // The reentry protection state mutex.
41     bool __reMutex;
42 
43     // This modifier can be used on functions with external calls to
44     // prevent reentry attacks.
45     // Constraints:
46     //   Protected functions must have only one point of exit.
47     //   Protected functions cannot use the `return` keyword
48     //   Protected functions return values must be through return parameters.
49     modifier preventReentry() {
50         require(!__reMutex);
51         __reMutex = true;
52         _;
53         delete __reMutex;
54         return;
55     }
56     /* unused::
57     // This modifier can be applied to public access state mutation functions
58     // to protect against reentry if a `preventReentry` function has already
59     // set the mutex. This prevents the contract from being reenter under a
60     // different memory context which can break state variable integrity.
61     modifier noReentry() {
62         require(!__reMutex);
63         _;
64     }
65     */
66 }
67 
68 /**
69  * @title Masterium Token [MTI]
70  * @author primeRev
71  * @notice masterium [mti] token contract (tokensale, (cummulated) interest payouts, masternodes
72  * @dev code is heavily commented, feel free to check it
73  */
74 contract MasteriumToken is ReentryProtected  {
75     using SafeMath for uint256;
76 
77     string public name;
78     string public symbol;
79     uint8  public decimals;
80     string public version;
81 
82     // used to scale token amounts to 18 decimals
83     uint256 internal constant TOKEN_MULTIPLIER = 1e18;
84 
85     address internal contractOwner;
86 
87     // DEBUG
88     bool    internal debug = false;
89 
90     // in debugging mode
91     uint256 internal constant DEBUG_SALEFACTOR = 1; // 100 -> additional factor for ETH to Token calculation
92     uint256 internal constant DEBUG_STARTDELAY = 1 minutes;
93     uint256 internal constant DEBUG_INTERVAL   = 1 days;
94 
95     // in production mode
96     uint256 internal constant PRODUCTION_SALEFACTOR = 1;           // additional tokensale exchange rate factor Tokens per ETH: production = 1
97     uint256 internal constant PRODUCTION_START      = 1511611200;  // tokensale starts at unittimestamp: 1511611200 = 11/25/2017 @ 12:00pm (UTC) (approx. +/-900 sec.)
98     uint256 internal constant PRODUCTION_INTERVAL   = 30 days;
99 
100     event DebugValue(string text, uint256 value);
101 
102 
103 
104     struct Account {
105         uint256 balance;                        // balance including already payed out interest
106         uint256 lastPayoutInterval;             // interval-index of last payout
107     }
108 
109     mapping(address => Account)                      internal accounts;
110     mapping(address => mapping(address => uint256))  public allowed;
111 
112 
113     uint256 internal _supplyTotal;
114     uint256 internal _supplyLastPayoutInterval; // interval of last processed interest payout
115 
116 
117     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
118     // +
119     // + interest stuff
120     // +
121     // + interest is payed out every 30 days (interval)
122     // + interest-rate is a function of interval-index % periodicity
123     // +
124     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
125     struct InterestConfig {
126         uint256 interval;           // interest is paid every x seconds (default: 30 days)
127         uint256 periodicity;        // interest-rate change by time and restart after "periodicity"
128         uint256 stopAtInterval;     // no more interest after stop-index
129         uint256 startAtTimestamp;   // time the interval-index starts increasing
130     }
131 
132     InterestConfig internal interestConfig; // set in constructor:: = InterestConfig(30 days,12,48,0);
133 
134     uint256[12] internal interestRates;
135     uint256[4]  internal stageFactors;
136 
137 
138 
139     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
140     // +
141     // + masternode stuff
142     // +
143     // + every token-transaction costs a fee, payed in tokens (0.01)
144     // + Masternodes earn the fees
145     // + Masternodes get double interest
146     // +
147     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
148     struct StructMasternode {
149         uint8   activeMasternodes;              // count of registered MN
150         uint256 totalBalanceWei;                // in the contract deposited ether (in wei)
151         uint256 rewardPool;                     // only used if no masternode is registered -> all transaction fees will be added to the rewardPool and payed out to the first masternode registering
152         uint256 rewardsPayedTotal;              // log all payouts for MN-statistics
153 
154         uint256 miningRewardInTokens;           // masternodes can mine x tokens per interval
155         uint256 totalTokensMinedRaw1e18;        // logging: total tokens mined till now
156 
157         uint256 transactionRewardInSubtokensRaw1e18;//fee, subtracted from token sender on every transaction
158 
159         uint256 minBalanceRequiredInTokens;     // to register a masternode -> a balance of 100000 tokens is required
160         uint256 minBalanceRequiredInSubtokensRaw1e18;// (*1e18 for internal integer calculations)
161 
162         uint256 minDepositRequiredInEther;      // to register a masternode a deposit in ether is required -> is a function of count: "activeMasternodes"
163         uint256 minDepositRequiredInWei;        // ... same in wei (for internal use)
164         uint8   maxMasternodesAllowed;          // no more than x masternodes allowed, default: 22
165     }
166 
167     struct Masternode {
168         address addr;           // 160 bit      // wallet-addresses of masternode owner
169         uint256 balanceWei;     //  96 bit      // amount ether deposited in the contract
170         uint256 sinceInterval;                  // MN created at this interval-index
171         uint256 lastMiningInterval;             // last interval a MN mined new coins
172     }
173 
174     StructMasternode public masternode; // = StructMasternode(0,0,0,0,100000 ether, 0.01 ether,1,1 ether,22);
175     Masternode[22]   public masternodes;
176     uint8 internal constant maxMasternodes = 22;
177     uint256 internal miningRewardInSubtokensRaw1e18; // (*1e18 for internal integer calculations)
178 
179 
180     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
181     // +
182     // + tokensale stuff
183     // +
184     // + 20 Mio. Tokens created at contract start (admin wallet)
185     // + contributers can buy by "Buy"-function -> ETH send to adminWallet
186     // + contributers can buy by failsave-function -> ETH send to contract, admin can withdraw
187     // +
188     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
189 
190     struct Structtokensale { // compiler limit: max. 16 vars -> stack too deep
191         // 1 token = 1e18 subTokens (smallest token unit, used for internal integer processing)
192         uint256 initialTokenSupplyRAW1e18;      // Tokens internal resolution: 1e18 = 1 Ether = 1e18 Wei
193         uint256 initialTokenSupplyAmount;
194         uint256 initialTokenSupplyFraction;
195 
196         uint256 minPaymentRequiredUnitWei;      // min. payment required for buying tokens, default: 0.0001 ETH
197         uint256 maxPaymentAllowedUnitWei;       // limit max. allowed payment per buy to 100 ETH
198 
199         uint256 startAtTimestamp;               // unixtime the tokensale starts
200 
201         bool    tokenSaleClosed;                // set to true by admin (manually) or contract (automatically if max. supply reached) if sale is closed
202         bool    tokenSalePaused;                // admin can temp. pause tokensale
203 
204         uint256 totalWeiRaised;                 // by tokensale
205         uint256 totalWeiInFallback;       // if someone send ether directly to contract -> admin can withdraw this balance
206 
207         uint256 totalTokensDistributedRAW1e18;
208         uint256 totalTokensDistributedAmount;
209         uint256 totalTokensDistributedFraction;
210     }
211 
212     Structtokensale public tokensale;
213     address adminWallet;        // 160 bit
214     bool    sendFundsToWallet;  // 1 bit    // default:true -> transfer eth on buy; false -> admin must withdraw
215     uint256 internal contractCreationTimestamp;      // (approx.) creation time of contract -> base for interval-index calculation
216     uint256[20] tokensaleFactor;
217 
218     /*  // debug only: log all contibuters */
219     struct Contributor {
220         address addr;
221         uint256 amountWei;
222         uint256 amountTokensUnit1e18;
223         uint256 sinceInterval;
224     }
225 
226     Contributor[] public tokensaleContributors; // array of all contributors
227     /* */
228 
229 
230 
231     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
232     // +
233     // + contract constructor -> init default values
234     // +
235     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
236     function MasteriumToken() payable public { // constructor
237         // contract creation: 3993317
238         name     = (debug) ? "Masterium_Testnet" : "Masterium";
239         symbol   = (debug) ? "MTITestnet1" : "MTI";
240         version  = (debug) ? "1.00.01.Testnet" : "1.00.01";
241         decimals = 18; // internal resolution = 1e18 = 1 Wei
242 
243         contractOwner = msg.sender;
244 
245         adminWallet = 0xAb942256b49F0c841D371DC3dFe78beFea447a27;
246 
247         sendFundsToWallet = true;
248 
249         contractCreationTimestamp = _getTimestamp();
250 
251         // tokenSALE: 20 mio tokens created; all to sell;
252         tokensale.initialTokenSupplyRAW1e18 = 20000000 * TOKEN_MULTIPLIER; // 20 mio tokens == 20 mio * 10^18 subtokens (smallest unit for internal processing);
253         tokensale.initialTokenSupplyAmount  = tokensale.initialTokenSupplyRAW1e18 / TOKEN_MULTIPLIER;
254         tokensale.initialTokenSupplyFraction= tokensale.initialTokenSupplyRAW1e18 % TOKEN_MULTIPLIER;
255 
256         // limit buy amount (per transaction) during tokensale to a range from 0.0001 to 100 ether per "buytokens"-command.
257         tokensale.minPaymentRequiredUnitWei = 0.0001 ether; // translates to 0.0001 * 1e18
258         tokensale.maxPaymentAllowedUnitWei  = 100 ether;    // translates to 100.00 * 1e18
259 
260         require(adminWallet != address(0));
261         require(tokensale.initialTokenSupplyRAW1e18 > 0);
262         require(tokensale.minPaymentRequiredUnitWei > 0);
263         require(tokensale.maxPaymentAllowedUnitWei > tokensale.minPaymentRequiredUnitWei);
264 
265         tokensale.tokenSalePaused = false;
266         tokensale.tokenSaleClosed = false;
267 
268         tokensale.totalWeiRaised = 0;               // total amount of tokens buyed during tokensale
269         tokensale.totalWeiInFallback = 0;     // the faction of total amount which was done by failsafe = direct ether send to contract
270 
271         tokensale.totalTokensDistributedRAW1e18 = 0;
272         tokensale.totalTokensDistributedAmount  = 0;
273         tokensale.totalTokensDistributedFraction= 0;
274 
275         tokensale.startAtTimestamp = (debug) ? contractCreationTimestamp + _addTime(DEBUG_STARTDELAY) : PRODUCTION_START;// tokensale starts at x
276 
277         tokensaleFactor[0] = 2000;
278         tokensaleFactor[1] = 1000;
279         tokensaleFactor[2] = 800;
280         tokensaleFactor[3] = 500;
281         tokensaleFactor[4] = 500;
282         tokensaleFactor[5] = 500;
283         tokensaleFactor[6] = 500;
284         tokensaleFactor[7] = 500;
285         tokensaleFactor[8] = 500;
286         tokensaleFactor[9] = 400;
287         tokensaleFactor[10] = 400;
288         tokensaleFactor[11] = 400;
289         tokensaleFactor[12] = 200;
290         tokensaleFactor[13] = 200;
291         tokensaleFactor[14] = 200;
292         tokensaleFactor[15] = 400;
293         tokensaleFactor[16] = 500;
294         tokensaleFactor[17] = 800;
295         tokensaleFactor[18] = 1000;
296         tokensaleFactor[19] = 2500;
297 
298         _supplyTotal = tokensale.initialTokenSupplyRAW1e18;
299         _supplyLastPayoutInterval = 0;                                // interval (index) of last processed interest-payout (initiated by a gas operation)
300 
301         accounts[contractOwner].balance = tokensale.initialTokenSupplyRAW1e18;
302         accounts[contractOwner].lastPayoutInterval = 0;
303         //accounts[contractOwner].lastAction = contractCreationTimestamp;
304 
305         // MASTERNODE: masternodes earn all transaction fees from balance transfers and can mine new tokens
306         masternode.transactionRewardInSubtokensRaw1e18 = 0.01 * (1 ether); // 0.01 * 1e18 subtokens = 0.01 token
307 
308         masternode.miningRewardInTokens = 50000; // 50'000 tokens to mine per masternode per interval
309         miningRewardInSubtokensRaw1e18 = masternode.miningRewardInTokens * TOKEN_MULTIPLIER; // used for internal integer calculation
310 
311         masternode.totalTokensMinedRaw1e18 = 0; // logs the amount of tokens mined by masternodes
312 
313         masternode.minBalanceRequiredInTokens = 100000; //to register a masternode -> a balance of 100000 tokens is required
314         masternode.minBalanceRequiredInSubtokensRaw1e18 = masternode.minBalanceRequiredInTokens * TOKEN_MULTIPLIER; // used for internal integer calculation
315 
316         masternode.maxMasternodesAllowed = uint8(maxMasternodes);
317         masternode.activeMasternodes= 0;
318         masternode.totalBalanceWei  = 0;
319         masternode.rewardPool       = 0;
320         masternode.rewardsPayedTotal= 0;
321 
322         masternode.minDepositRequiredInEther= requiredBalanceForMasternodeInEther();// to register a masternode -> a deposit of ether is required (a function of numMasternodes)
323         masternode.minDepositRequiredInWei  = requiredBalanceForMasternodeInWei(); // used for internal integer calculation
324 
325 
326         // INTEREST: every tokenholder earn interest (% of balance) at a fixed interval (once per 30 days)
327         interestConfig.interval = _addTime( (debug) ? DEBUG_INTERVAL : PRODUCTION_INTERVAL ); // interest payout interval in seconds, default: every 30 days
328         interestConfig.periodicity      = 12;    // interestIntervalCapped = intervalIDX % periodicity
329         interestConfig.stopAtInterval   = 4 * interestConfig.periodicity;  // stop paying interest after x intervals (performance reasons)
330         interestConfig.startAtTimestamp = tokensale.startAtTimestamp; // first payout is after one interval
331 
332         // interest is reduced every 30 days and reset to 1st every stage (after 12 intervals)
333         interestRates[ 0] = 1000000000000; // interval 1 = 100%
334         interestRates[ 1] =  800000000000; // 80%
335         interestRates[ 2] =  600000000000;
336         interestRates[ 3] =  400000000000;
337         interestRates[ 4] =  200000000000;
338         interestRates[ 5] =  100000000000;
339         interestRates[ 6] =   50000000000;
340         interestRates[ 7] =   50000000000;
341         interestRates[ 8] =   30000000000;
342         interestRates[ 9] =   40000000000;
343         interestRates[10] =   20000000000;
344         interestRates[11] =   10000000000; //   1%
345 
346         // interestRates are reduced by factor every 12 intervals = 1 stage
347         stageFactors[0] =  1000000000000; // interval  1..12 = factor 1
348         stageFactors[1] =  4000000000000; // interval 13..24 = factor 4
349         stageFactors[2] =  8000000000000;
350         stageFactors[3] = 16000000000000;
351     }
352 
353 
354 
355 
356     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
357     // +
358     // + ERC20 stuff
359     // +
360     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
361 
362     event Transfer(address indexed from, address indexed to, uint256 value);
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364     //event InterestPayed(address indexed owner, uint256 interestPayed);
365 
366     // erc20: tramsferFrom:: Allow _spender to withdraw from your account, multiple times, up to the _value amount.
367     function approve(address _spender, uint256 _value) public returns (bool) {
368         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
369         allowed[msg.sender][_spender] = _value;
370 
371         Approval(msg.sender, _spender, _value);
372         return true;
373     }
374 
375     // erc20: tramsferFrom:: Returns the amount which _spender is still allowed to withdraw from _owner
376     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
377         return allowed[_owner][_spender];
378     }
379 
380     // erc20: tramsferFrom
381     function increaseApproval (address _spender, uint256 _addedValue) public returns (bool success) {
382         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
383 
384         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385         return true;
386     }
387 
388     // erc20: tramsferFrom
389     function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool success) {
390         uint256 oldValue = allowed[msg.sender][_spender];
391         if (_subtractedValue > oldValue) {
392             allowed[msg.sender][_spender] = 0;
393         } else {
394             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
395         }
396 
397         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398         return true;
399     }
400 
401     // erc20: public (command): token transfer by owner to someone
402     // attn: total = _value + transactionFee !!! -> account-balance >= _value + transactionFee
403     function transfer(address _to, uint256 _value) public returns (bool) {
404         require(_to != address(0));
405         _setBalances(msg.sender, _to, _value); // will fail if not enough balance
406         _sendFeesToMasternodes(masternode.transactionRewardInSubtokensRaw1e18);
407 
408         Transfer(msg.sender, _to, _value);
409         return true;
410     }
411 
412     // erc20: public (command): Send _value amount of tokens from address _from to address _to
413     // attn: total = _value + transactionFee !!! -> account-balance >= _value + transactionFee
414     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
415         require(_to != address(0));
416         var _allowance = allowed[_from][msg.sender];
417         allowed[_from][msg.sender] = _allowance.sub(_value); // will fail if no (not enough) allowance
418         _setBalances(_from, _to, _value);  // will fail if not enough balance
419         _sendFeesToMasternodes(masternode.transactionRewardInSubtokensRaw1e18);
420 
421         Transfer(_from, _to, _value);
422         return true;
423     }
424 
425     // erc20: public (read only)
426     function totalSupply() public constant returns (uint256 /*totalSupply*/) {
427         return _calcBalance(_supplyTotal, _supplyLastPayoutInterval, intervalNow());
428     }
429 
430     // erc20
431     function balanceOf(address _owner) public constant returns (uint256 balance) {
432         return _calcBalance(accounts[_owner].balance, accounts[_owner].lastPayoutInterval, intervalNow());
433     }
434 
435     // public (read only): just to look pretty -> split 1e18 reolution to mainunits and the fraction part, just for direct enduser lookylooky at contract variables
436     function totalSupplyPretty() public constant returns (uint256 tokens, uint256 fraction) {
437         uint256 _raw = totalSupply();
438         tokens  = _raw / TOKEN_MULTIPLIER;
439         fraction= _raw % TOKEN_MULTIPLIER;
440     }
441 
442     // public (read only): just to look pretty -> split 1e18 reolution to mainunits and the fraction part, just for direct enduser lookylooky at contract variables
443     function balanceOfPretty(address _owner) public constant returns (uint256 tokens, uint256 fraction) {
444         uint256 _raw = balanceOf(_owner);
445         tokens  = _raw / TOKEN_MULTIPLIER;
446         fraction= _raw % TOKEN_MULTIPLIER;
447     }
448 
449 
450     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
451     // +
452     // + Interest stuff
453     // +
454     // + every token holder receives interest (based on token balance) at fixed intervals (by default: 30 days)
455     // +
456     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
457 
458     // public (read only): stage = how many interval cycles completed; increase every 12 intervals by 1; 1 stage = approx. 1 year
459     // stage is unsed in interest calculation -> yearly factor
460     // unnecessary -> just for enduser lookylooky
461     function stageNow() public constant returns (uint256) {
462         return intervalNow() / interestConfig.periodicity;
463     }
464 
465     // public (read only): interval = index of the active interest interval. first interval = 0; increase every 30 days by 1; 1 interval = approx 1 month
466     // interval is used for interest payouts and validating masternode mining interval
467     function intervalNow() public constant returns (uint256) {
468         uint256 timestamp = _getTimestamp();
469         return (timestamp < interestConfig.startAtTimestamp) ? 0 : (timestamp - interestConfig.startAtTimestamp) / interestConfig.interval;
470     }
471 
472     // public (read only): unixtime to next interest payout
473     // unnecessary -> just for enduser lookylooky
474     function secToNextInterestPayout() public constant returns (uint256) {
475         if (intervalNow() > interestConfig.stopAtInterval) return 0; // no interest after x intervals
476         //shortcutted to return:
477         //uint256 timestamp = _getTimestamp();
478         //uint256 intNow = intervalNow();
479         //uint256 nextPayoutTimestamp = interestConfig.startAtTimestamp + (intNow +1)* interestConfig.interval;
480         //return nextPayoutTimestamp - timestamp;
481         return (interestConfig.startAtTimestamp + (intervalNow() + 1) * interestConfig.interval) - _getTimestamp();
482     }
483 
484     // public (read only): next interest payout rate in percent
485     // unnecessary -> just for enduser lookylooky
486     function interestNextInPercent() public constant returns (uint256 mainUnit, uint256 fraction) {
487         uint256 _now = intervalNow();
488         uint256 _raw = _calcBalance(100 * TOKEN_MULTIPLIER, _now, _now+1);
489         mainUnit = (_raw - 100 * TOKEN_MULTIPLIER) / TOKEN_MULTIPLIER;
490         fraction = (_raw - 100 * TOKEN_MULTIPLIER) % TOKEN_MULTIPLIER;
491         return;
492     }
493 
494     // internal (gas operation): triggered before any (gas costy operation) balance transaction -> account interest to balance of address
495     // its for performance reasons: use a gas operation to add new (cumulated) interest to account-balance to reduce interest-calc-loop (balanceOf)
496     function _requestInterestPayoutToTotalSupply() internal {
497         // payout interest to balance and set new payout index
498         uint256 oldbal = _supplyTotal;   // read last known balance == balance at timeindex: "_supplyLastPayoutInterval"
499         uint256 newbal = totalSupply();                                 // do interest calculation loop from "lastPayoutInterval" to now
500         if (oldbal < newbal) {  // if balance changed because of new interest ...
501             _supplyTotal = newbal;
502         }
503         // set new lastPayoutInterval for use in calculation loop
504         _supplyLastPayoutInterval = intervalNow(); // interest already payed out to _supplyTotal until this index (now)
505     }
506 
507     // internal (gas operation): triggered before any (gas costy operation) balance transaction -> account interest to balance of address
508     // its for performance reasons: use a gas operation to add new (cumulated) interest to account-balance to reduce interest-calc-loop (balanceOf)
509     function _requestInterestPayoutToAccountBalance(address _owner) internal {
510         // payout interest to balance and set new payout index
511         uint256 oldbal = accounts[_owner].balance;  // read last known balance == balance at timeindex: "accounts[_owner].lastPayoutInterval"
512         uint256 newbal = balanceOf(_owner);         // do interest calculation loop from "lastPayoutInterval" to now
513         if (oldbal < newbal) {  // if balance changed because of new interest ...
514             accounts[_owner].balance = newbal;
515 
516             //no need for logging this:: InterestPayed(_owner, newbal - oldbal);
517         }
518         // set new lastPayoutInterval for use in calculation loop
519         accounts[_owner].lastPayoutInterval = intervalNow(); // interest already payed out to [owner].balance until this index (now)
520     }
521 
522     // internal (gas operation): triggered by a transation-function -> pay interest to both addr; subtract transaction fee; do token-transfer
523     // every call triggers the interest payout loop and adds the new balance internaly -> next loop can save cpu-cycles
524     function _setBalances(address _from, address _to, uint256 _value) internal {
525         require(_from != _to);
526         require(_value > 0);
527 
528         // set new balance (and new "last payout index") including interest for both parties before transfer
529         _requestInterestPayoutToAccountBalance(_from);   // set new balance including interest
530         _requestInterestPayoutToAccountBalance(_to);     // set new balance including interest
531         _requestInterestPayoutToTotalSupply();
532 
533         // there must be enough balance for transfer AND transaction-fee
534         require(_value.add(masternode.transactionRewardInSubtokensRaw1e18) <= accounts[_from].balance);
535 
536         // if sender is a masternode: freeze 100k of tokens balance -> to release the balance it is required to deregister the masternode first
537         if (masternodeIsValid(_from)) {
538             require(accounts[_from].balance >= masternode.minBalanceRequiredInSubtokensRaw1e18.add(_value)); // masternodes: 100k balance is freezed
539         }
540 
541         // SafeMath.sub will throw if there is not enough balance.
542         accounts[_from].balance = accounts[_from].balance.sub(_value).sub(masternode.transactionRewardInSubtokensRaw1e18);
543         accounts[_to].balance   = accounts[_to].balance.add(_value);
544     }
545 
546     // internal (no gas): calc interest as a function of interval-index (loop from-interval to to-interval)
547     function _calcBalance(uint256 _balance, uint256 _from, uint256 _to) internal constant returns (uint256) {
548         // attn.: significant integer capping for balances < 1e-16 -> acceptable limitation
549         uint256 _newbalance = _balance;
550         if (_to > interestConfig.stopAtInterval) _to = interestConfig.stopAtInterval; // no (more) interest after x intervals (default: 48)
551         if (_from < _to) { // interest index since last payout (storage operation in transfers) -> calc new balance
552             for (uint256 idx = _from; idx < _to; idx++) { // loop over unpayed intervals (since last payout-operation till now)
553                 if (idx > 48) break; // hardcap: just for ... you know
554 
555                 _newbalance += (_newbalance * interestRates[idx % interestConfig.periodicity]) / stageFactors[(idx / interestConfig.periodicity) % 4];
556             }
557             if (_newbalance < _balance) { _newbalance = _balance; } // failsave if some math goes wrong (overflow). who knows...
558         }
559         return _newbalance;
560         /*  interest by time (1 interval == 30 days)
561             stagefactor	interval	interest	 total supply	 sum %
562             1           0             0.0000%    20'000'000.00   100.00%
563             after 30 days
564             1	        1	        100.0000%    40'000'000.00	 200.00%
565             1	        2	         80.0000%	 72'000'000.00	 360.00%
566             1	        3	         60.0000%	115'200'000.00	 576.00%
567             1	        4	         40.0000%	161'280'000.00	 806.40%
568             1	        5	         20.0000%	193'536'000.00	 967.68%
569             1	        6	         10.0000%	212'889'600.00	1064.45%
570             1	        7	          5.0000%	223'534'080.00	1117.67%
571             1	        8	          5.0000%	234'710'784.00	1173.55%
572             1	        9	          3.0000%	241'752'107.52	1208.76%
573             1	        10	          3.0000%	249'004'670.75	1245.02%
574             1	        11	          2.0000%	253'984'764.16	1269.92%
575             1	        12	          1.0000%	256'524'611.80	1282.62%
576             after 1 year: 1282.62% pa in year 1
577             4	        13	         25.0000%	320'655'764.75	1603.28%
578             4	        14	         20.0000%	384'786'917.70	1923.93%
579             4	        15	         15.0000%	442'504'955.36	2212.52%
580             4	        16	         10.0000%	486'755'450.89	2433.78%
581             4	        17	          5.0000%	511'093'223.44	2555.47%
582             4	        18	          2.5000%	523'870'554.03	2619.35%
583             4	        19	          1.2500%	530'418'935.95	2652.09%
584             4	        20	          1.2500%	537'049'172.65	2685.25%
585             4	        21	          0.7500%	541'077'041.44	2705.39%
586             4	        22	          0.7500%	545'135'119.26	2725.68%
587             4	        23	          0.5000%	547'860'794.85	2739.30%
588             4	        24	          0.2500%	549'230'446.84	2746.15%
589             after 2 years: 214.10% pa in year 2
590             8	        25	         12.5000%	617'884'252.69	3089.42%
591             8	        26	         10.0000%	679'672'677.96	3398.36%
592             8	        27	          7.5000%	730'648'128.81	3653.24%
593             8	        28	          5.0000%	767'180'535.25	3835.90%
594             8	        29	          2.5000%	786'360'048.63	3931.80%
595             8	        30	          1.2500%	796'189'549.24	3980.95%
596             8	        31	          0.6250%	801'165'733.92	4005.83%
597             8	        32	          0.6250%	806'173'019.76	4030.87%
598             8	        33	          0.3750%	809'196'168.58	4045.98%
599             8	        34	          0.3750%	812'230'654.22	4061.15%
600             8	        35	          0.2500%	814'261'230.85	4071.31%
601             8	        36	          0.1250%	815'279'057.39	4076.40%
602             after 3 years: 148.44% pa in year 3
603             16	        37	          6.2500%	866'233'998.48	4331.17%
604             16	        38	          5.0000%	909'545'698.40	4547.73%
605             16	        39	          3.7500%	943'653'662.09	4718.27%
606             16	        40	          2.5000%	967'245'003.64	4836.23%
607             16	        41	          1.2500%	979'335'566.19	4896.68%
608             16	        42	          0.6250%	985'456'413.48	4927.28%
609             16	        43	          0.3125%	988'535'964.77	4942.68%
610             16	        44	          0.3125%	991'625'139.66	4958.13%
611             16	        45	          0.1875%	993'484'436.80	4967.42%
612             16	        46	          0.1875%	995'347'220.12	4976.74%
613             16	        47	          0.1250%	996'591'404.14	4982.96%
614             16	        48	          0.0625%	997'214'273.77	4986.07%
615             after 4 years: 122.32% pa in year 4
616             16	        49 .. inf     0.0000%	997'214'273.77	4986.07%
617         */
618     }
619 
620 
621 
622 
623 
624 
625     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
626     // +
627     // + Masternode stuff
628     // +
629     // + every registered masternodes receives a part of the transaction fee
630     // + every masternode can mine 50´000 once every interval (30 days)
631     // +
632     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
633     event MasternodeRegistered(address indexed addr, uint256 amount);
634     event MasternodeDeregistered(address indexed addr, uint256 amount);
635     event MasternodeMinedTokens(address indexed addr, uint256 amount);
636     event MasternodeTransferred(address fromAddr, address toAddr);
637     event MasternodeRewardSend(uint256 amount);
638     event MasternodeRewardAddedToRewardPool(uint256 amount);
639     event MaxMasternodesAllowedChanged(uint8 newNumMaxMasternodesAllowed);
640     event TransactionFeeChanged(uint256 newTransactionFee);
641     event MinerRewardChanged(uint256 newMinerReward);
642 
643     // public (read only): unixtime to next interest payout
644     // unnecessary -> just for enduser lookylooky
645     function secToNextMiningInterval() public constant returns (uint256) {
646         return secToNextInterestPayout();
647     }
648 
649     // internal (read only):
650     // unnecessary -> just for enduser lookylooky
651     function requiredBalanceForMasternodeInEther() constant internal returns (uint256) {
652         // 1st masternode = 1 ether required to deposit in contract
653         // 2nd masternode = 4 ether
654         // 3rd masternode = 9 ether
655         // 4th masternode = 16 ether
656         // 5th masternode = 25 ether
657         // 6th masternode = 36 ether
658         // 22th           = 484 ether
659         return (masternode.activeMasternodes + 1) ** 2;
660     }
661 
662     // internal (read only): used in masternodeRegister and Deregister
663     function requiredBalanceForMasternodeInWei() constant internal returns (uint256) {
664         return (1 ether) * (masternode.activeMasternodes + 1) ** 2;
665     }
666 
667     // public (command): send ETH (requiredBalanceForMasternodeInEther) to contract to become a masternode
668     function masternodeRegister() payable public {
669         // gas: 104'000 / max: 140k
670         require(msg.sender != address(0));
671         require(masternode.activeMasternodes < masternode.maxMasternodesAllowed);       // max. masternodes allowed
672         require(msg.value == requiredBalanceForMasternodeInWei() );                     // eth deposit
673         require(_getMasternodeSlot(msg.sender) >= maxMasternodes);                      // only one masternode per address
674 
675         _requestInterestPayoutToTotalSupply();
676         _requestInterestPayoutToAccountBalance(msg.sender); // do interest payout before checking balance
677         require(accounts[msg.sender].balance >= masternode.minBalanceRequiredInSubtokensRaw1e18); // required token balance of 100k at addr to register a masternode
678         //was: require(balanceOf(msg.sender) >= masternode.minBalanceRequiredInSubtokensRaw1e18); // required token balance of 100k at addr to register a masternode
679 
680         uint8 slot = _findEmptyMasternodeSlot();
681         require(slot < maxMasternodes); // should never trigger
682 
683         masternodes[slot].addr = msg.sender;
684         masternodes[slot].balanceWei = msg.value;
685         masternodes[slot].sinceInterval = intervalNow();
686         masternodes[slot].lastMiningInterval = intervalNow();
687 
688         masternode.activeMasternodes++;
689 
690         masternode.minDepositRequiredInEther= requiredBalanceForMasternodeInEther(); // attn: first inc activeMN
691         masternode.minDepositRequiredInWei  = requiredBalanceForMasternodeInWei(); // attn: first inc activeMN
692 
693         masternode.totalBalanceWei = masternode.totalBalanceWei.add(msg.value);    // this balance could never be withdrawn by contract admin
694 
695         MasternodeRegistered(msg.sender, msg.value);
696     }
697 
698     // public (command): close masternode and send deposited ETH back to owner
699     function masternodeDeregister() public preventReentry returns (bool _success) {
700         require(msg.sender != address(0));
701         require(masternode.activeMasternodes > 0);
702         require(masternode.totalBalanceWei > 0);
703         require(this.balance >= masternode.totalBalanceWei + tokensale.totalWeiInFallback);
704 
705         uint8 slot = _getMasternodeSlot(msg.sender);
706         require(slot < maxMasternodes); // masternode found in list?
707 
708         uint256 balanceWei = masternodes[slot].balanceWei;
709         require(masternode.totalBalanceWei >= balanceWei);
710 
711         _requestInterestPayoutToTotalSupply();
712         _requestInterestPayoutToAccountBalance(msg.sender); // do interest payout before checking balance
713 
714         masternodes[slot].addr = address(0);
715         masternodes[slot].balanceWei = 0;
716         masternodes[slot].sinceInterval = 0;
717         masternodes[slot].lastMiningInterval = 0;
718 
719         masternode.totalBalanceWei = masternode.totalBalanceWei.sub(balanceWei);
720 
721         masternode.activeMasternodes--;
722 
723         masternode.minDepositRequiredInEther = requiredBalanceForMasternodeInEther(); // attn: first dec activeMN
724         masternode.minDepositRequiredInWei   = requiredBalanceForMasternodeInWei(); // attn: first dec activeMN
725 
726         //if (!addr.send(balanceWei)) revert(); // send back ether to wallet of sender
727         msg.sender.transfer(balanceWei); // send back ether to wallet of sender
728 
729         MasternodeDeregistered(msg.sender, balanceWei);
730         _success = true;
731         }
732 
733     // public (command): close masternode and send deposited ETH back to owner
734     function masternodeMineTokens() public {
735         // gas: up to 105000
736         require(msg.sender != address(0));
737         require(masternode.activeMasternodes > 0);
738 
739         uint256 _inow = intervalNow();
740         require(_inow <= interestConfig.stopAtInterval); // mining stops after approx. 4 years (48 intervals by 30 days)
741 
742         uint8 slot = _getMasternodeSlot(msg.sender);
743         require(slot < maxMasternodes); // masternode found in list?
744         require(masternodes[slot].lastMiningInterval < _inow); // masternode did not already mine this interval?
745 
746         _requestInterestPayoutToTotalSupply();
747         _requestInterestPayoutToAccountBalance(msg.sender);   // set new balance including interest
748         require(accounts[msg.sender].balance >= masternode.minBalanceRequiredInSubtokensRaw1e18); // required token balance at addr to register a masternode
749         //was: require(balanceOf(msg.sender) >= masternode.minBalanceRequiredInSubtokensRaw1e18); // required token balance of 100k at addr to register a masternode
750 
751         masternodes[slot].lastMiningInterval = _inow;
752 
753         uint256 _minedTokens = miningRewardInSubtokensRaw1e18;
754 
755         // SafeMath.sub will throw if there is not enough balance.
756         accounts[msg.sender].balance = accounts[msg.sender].balance.add(_minedTokens);
757 
758         // attn.: _requestInterestPayoutToTotalSupply() must be called first to set lastPayoutInterval correctly
759         _supplyTotal = _supplyTotal.add(_minedTokens);
760         //_supplyMined = _supplyMined.add(_minedTokens);
761 
762         masternode.totalTokensMinedRaw1e18 = masternode.totalTokensMinedRaw1e18.add(_minedTokens);
763 
764         MasternodeMinedTokens(msg.sender, _minedTokens);
765     }
766 
767     // public (command): owner of a masternode can transfer the mn (and the value in ETH) to another wallet address
768     function masternodeTransferOwnership(address newAddr) public {
769         require(masternode.activeMasternodes > 0);
770         require(msg.sender != address(0));
771         require(newAddr != address(0));
772         require(newAddr != msg.sender);
773 
774         uint8 slot = _getMasternodeSlot(msg.sender);
775         require(slot < maxMasternodes); // masternode found in list? only the owner of a masternode can transfer a masternode to a new address
776 
777         _requestInterestPayoutToTotalSupply();
778         _requestInterestPayoutToAccountBalance(msg.sender); // do interest payout before moving masternode
779         _requestInterestPayoutToAccountBalance(newAddr); // do interest payout before moving masternode
780         require(accounts[newAddr].balance >= masternode.minBalanceRequiredInSubtokensRaw1e18); // required token balance at addr to register a masternode
781         //was: require(balanceOf(newAddr) >= masternode.minBalanceRequiredInSubtokensRaw1e18); // required token balance at addr to register a masternode
782 
783         masternodes[slot].addr = newAddr;
784 
785         MasternodeTransferred(msg.sender, newAddr);
786     }
787 
788     // public (read only): check if addr is a masternode
789     function masternodeIsValid(address addr) public constant returns (bool) {
790         return (_getMasternodeSlot(addr) < maxMasternodes) && (balanceOf(addr) >= masternode.minBalanceRequiredInSubtokensRaw1e18);
791     }
792 
793     // internal (read only):
794     function _getMasternodeSlot(address addr) internal constant returns (uint8) {
795         uint8 idx = maxMasternodes; // masternode.maxMasternodesAllowed;
796         for (uint8 i = 0; i < maxMasternodes; i++) {
797             if (masternodes[i].addr == addr) { // if sender is a registered masternode
798                 idx = i;
799                 break;
800             }
801         }
802         return idx; // if idx == maxMasternodes (22) -> no entry found; valid masternode slots: 0 .. 21
803     }
804 
805     // internal (read only): faster than push / pop operations on arrays
806     function _findEmptyMasternodeSlot() internal constant returns (uint8) {
807         uint8 idx = maxMasternodes; // masternode.maxMasternodesAllowed;
808 
809         if (masternode.activeMasternodes < maxMasternodes)
810         for (uint8 i = 0; i < maxMasternodes; i++) {
811             if (masternodes[i].addr == address(0) && masternodes[i].sinceInterval == 0) { // if slot empty
812                 idx = i;
813                 break;
814             }
815         }
816         return idx; // if idx == maxMasternodes -> no entry found
817     }
818 
819     // internal (command):
820     function _sendFeesToMasternodes(uint256 _fee) internal {
821         uint256 _pool = masternode.rewardPool;
822         if (_fee + _pool > 0 && masternode.activeMasternodes > 0) { // if min. 1 masternode exists
823             masternode.rewardPool = 0;
824             uint256 part = (_fee + _pool) / masternode.activeMasternodes;
825             uint256 sum = 0;
826             address addr;
827             for (uint8 i = 0; i < maxMasternodes; i++) {
828                 addr = masternodes[i].addr;
829                 if (addr != address(0)) {
830                     accounts[addr].balance = (accounts[addr].balance).add(part); // send fee as reward
831                     sum += part;
832                 }
833             }
834             if (sum < part) masternode.rewardPool = part - sum; // do not loose integer-div-roundings
835             masternode.rewardsPayedTotal += sum;
836             MasternodeRewardSend(sum);
837         } else { // no masternodes -> collect fees for the first masternode registering
838             masternode.rewardPool = masternode.rewardPool.add(_fee);
839             MasternodeRewardAddedToRewardPool(_fee);
840         }
841     }
842 
843 
844 
845     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
846     // +
847     // + tokensale stuff
848     // +
849     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
850     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
851     event TokenSaleFinished();
852     event TokenSaleClosed();
853     event TokenSaleOpened();
854     event TokenSalePaused(bool paused);
855 
856     // public (command): fallback function - can be used to buy tokens (attn.: can fail silently if not enough gas is provided)
857     /* deactivated for user-safety */
858     function () payable public {
859         // gas used: 170000 to 251371 gaslimit: provide 500000 or more!!!
860         _buyTokens(msg.sender, true); // triggers failsafe -> no direct transfer to contract-owner wallet to safe gas
861     }
862     /* */
863     
864     // public (command): official function to buy tokens during tokensale
865     function tokensaleBuyTokens() payable public {
866         _buyTokens(msg.sender, false); // direct transfer to contract-owner
867     }
868 
869     // public (read only): calc the active sale stage as a function of already selled amount
870     function tokensaleStageNow() public constant returns (uint256) {
871         return tokensaleStageAt(tokensale.totalTokensDistributedRAW1e18);
872     }
873 
874     // public (read only): calc the active sale stage as a function of any amount
875     function tokensaleStageAt(uint256 _tokensdistibutedRAW1e18) public pure returns (uint256) {
876         return _tokensdistibutedRAW1e18 / (1000000 * TOKEN_MULTIPLIER);
877     }
878 
879     // public (read only): calc the active exchange factor (tokens per ETH) as a function of already selled amount
880     function tokensaleTokensPerEtherNow() public constant returns (uint256) {
881         return _tokensaleTokensPerEther(tokensale.totalTokensDistributedRAW1e18);
882     }
883 
884     /*
885     // public (read only): calc the active exchange factor (tokens per ETH) as a function of any amount
886     function tokensaleTokensPerEtherAtAmount(uint256 _tokensdistibutedRAW1e18) public constant returns (uint256) {
887         return _tokensaleTokensPerEther(_tokensdistibutedRAW1e18);
888     }
889     */
890     /*
891     // public (read only): calc the active exchange factor (tokens per ETH) as a function of any stage
892     function tokensaleTokensPerEtherAtStage(uint256 _stage) public constant returns (uint256) {
893         return _tokensaleTokensPerEther(_stage * 1000000 * TOKEN_MULTIPLIER);
894     }
895     */
896 
897     // internal (read only): calculate current exchange rate -> ether payed * factor = tokens distributed
898     function _tokensaleTokensPerEther(uint256 _tokensdistibuted) internal constant returns (uint256) {
899         uint256 factor = tokensaleFactor[tokensaleStageAt(_tokensdistibuted) % 20]; // % 20 == prevent array overflow on unexpected error
900         return factor * ( (debug) ? DEBUG_SALEFACTOR : PRODUCTION_SALEFACTOR ); // debug only stuff
901 
902         // total tokens: 20 Mio
903         // total ETH to buy all tokens: approx. 44400 ETH (444 in debug mode)
904         /*
905         stage tokens   tokens     ether     1 token      usd per stage                  1 token
906             per stage per ether	per stage	in ether	 (300 usd/ETH)	sum usd	        in usd
907         1	1'000'000	2'000	  500.00	0.00050000	  150'000.00	  150'000.00	0.1500
908         2	1'000'000	1'000	1'000.00	0.00100000	  300'000.00	  450'000.00	0.3000
909         3	1'000'000	  800	1'250.00	0.00125000	  375'000.00	  825'000.00	0.3750
910         4	1'000'000	  500	2'000.00	0.00200000	  600'000.00	1'425'000.00	0.6000
911         5	1'000'000	  500	2'000.00	0.00200000	  600'000.00	2'025'000.00	0.6000
912         6	1'000'000	  500	2'000.00	0.00200000	  600'000.00	2'625'000.00	0.6000
913         7	1'000'000	  500	2'000.00	0.00200000	  600'000.00	3'225'000.00	0.6000
914         8	1'000'000	  500	2'000.00	0.00200000	  600'000.00	3'825'000.00	0.6000
915         9	1'000'000	  500	2'000.00	0.00200000	  600'000.00	4'425'000.00	0.6000
916         10	1'000'000	  400	2'500.00	0.00250000	  750'000.00	5'175'000.00	0.7500
917         11	1'000'000	  400	2'500.00	0.00250000	  750'000.00	5'925'000.00	0.7500
918         12	1'000'000	  400	2'500.00	0.00250000	  750'000.00	6'675'000.00	0.7500
919         13	1'000'000	  200	5'000.00	0.00500000	1'500'000.00	8'175'000.00	1.5000
920         14	1'000'000	  200	5'000.00	0.00500000	1'500'000.00	9'675'000.00	1.5000
921         15	1'000'000	  200	5'000.00	0.00500000	1'500'000.00	11'175'000.00	1.5000
922         16	1'000'000	  400	2'500.00	0.00250000	  750'000.00	11'925'000.00	0.7500
923         17	1'000'000	  500	2'000.00	0.00200000	  600'000.00	12'525'000.00	0.6000
924         18	1'000'000	  800	1'250.00	0.00125000	  375'000.00	12'900'000.00	0.3750
925         19	1'000'000	1'000	1'000.00	0.00100000	  300'000.00	13'200'000.00	0.3000
926         20	1'000'000	2'500	  400.00	0.00040000	  120'000.00	13'320'000.00	0.1200
927            20'000'000	       44'400.00 ETH	       13'320'000.00	      average:	0.6700
928 	    */
929     }
930 
931     // internal: token purchase function
932     function _buyTokens(address addr, bool failsafe) internal {
933         require(addr != address(0));
934         require(msg.value > 0);
935         require(msg.value >= tokensale.minPaymentRequiredUnitWei); // min. payment required
936         require(msg.value <= tokensale.maxPaymentAllowedUnitWei); // max. payment allowed
937         require(tokensaleStarted() && !tokensaleFinished() && !tokensalePaused());
938 
939         uint256 amountTokens;
940         uint256 actExchangeRate = _tokensaleTokensPerEther(tokensale.totalTokensDistributedRAW1e18);
941         uint256 amountTokensToBuyAtThisRate = msg.value * actExchangeRate;
942         uint256 availableAtThisRate = (1000000 * TOKEN_MULTIPLIER) - ((tokensale.totalTokensDistributedRAW1e18) % (1000000 * TOKEN_MULTIPLIER));
943 
944         if (amountTokensToBuyAtThisRate <= availableAtThisRate) { // wei fits in this exchangerate-stage
945             amountTokens = amountTokensToBuyAtThisRate;
946         } else { // on border crossing (no more than 1 border crossing possible, because of max. buy limit of 100 ETH = 100 * 5000 = 0.5 mio)
947             amountTokens = availableAtThisRate;
948             //uint256 nextExchangeRate = _tokensaleTokensPerEther(tokensale.totalTokensDistributedRAW1e18 + amountTokens);
949             //uint256 amountTokensToBuyAtNextRate = (msg.value - availableAtThisRate / actExchangeRate) * nextExchangeRate;
950 
951             amountTokens += (msg.value - availableAtThisRate / actExchangeRate) * _tokensaleTokensPerEther(tokensale.totalTokensDistributedRAW1e18 + amountTokens); //amountTokensToBuyAtNextRate;
952         }
953 
954         require(amountTokens > 0);
955         require(tokensale.totalTokensDistributedRAW1e18.add(amountTokens) <= tokensale.initialTokenSupplyRAW1e18); // check limit
956 
957         _requestInterestPayoutToTotalSupply();
958         _requestInterestPayoutToAccountBalance(contractOwner); // do interest payout before changing balances
959         _requestInterestPayoutToAccountBalance(addr); // do interest payout before changing balances
960 
961         tokensale.totalWeiRaised = tokensale.totalWeiRaised.add(msg.value);
962         if (!sendFundsToWallet || failsafe) tokensale.totalWeiInFallback = tokensale.totalWeiInFallback.add(msg.value);
963 
964         tokensale.totalTokensDistributedRAW1e18 = tokensale.totalTokensDistributedRAW1e18.add(amountTokens);
965         tokensale.totalTokensDistributedAmount = tokensale.totalTokensDistributedRAW1e18 / TOKEN_MULTIPLIER;
966         tokensale.totalTokensDistributedFraction = tokensale.totalTokensDistributedRAW1e18 % TOKEN_MULTIPLIER;
967 
968         // SafeMath.sub will throw if there is not enough balance.
969         accounts[contractOwner].balance = accounts[contractOwner].balance.sub(amountTokens);
970         accounts[addr].balance = accounts[addr].balance.add(amountTokens);
971 
972 
973         /* debug only */
974         if (debug) {
975             // update list of all contributors
976             Contributor memory newcont;
977             newcont.addr = addr;
978             newcont.amountWei = msg.value;
979             newcont.amountTokensUnit1e18 = amountTokens;
980             newcont.sinceInterval = intervalNow();
981             tokensaleContributors.push( newcont );
982         }
983         /* */
984 
985         // send tokens to wallet of sender from ether
986         if (sendFundsToWallet && !failsafe) adminWallet.transfer(msg.value); // req. more gas
987 
988         TokensPurchased(contractOwner, addr, msg.value, amountTokens);
989     }
990 
991     // public (read only): unixtime to next interest payout
992     function tokensaleSecondsToStart() public constant returns (uint256) {
993         //uint256 timestamp = _getTimestamp();
994         return (tokensale.startAtTimestamp <= _getTimestamp()) ? 0 : tokensale.startAtTimestamp - _getTimestamp();
995     }
996 
997 
998     // @return true if tokensale has started
999     function tokensaleStarted() internal constant returns (bool) {
1000         return _getTimestamp() >= tokensale.startAtTimestamp;
1001     }
1002 
1003     // @return true if tokensale ended
1004     function tokensaleFinished() internal constant returns (bool) {
1005         return (tokensale.totalTokensDistributedRAW1e18 >= tokensale.initialTokenSupplyRAW1e18 || tokensale.tokenSaleClosed);
1006     }
1007 
1008     // @return true if tokensale is paused
1009     function tokensalePaused() internal constant returns (bool) {
1010         return tokensale.tokenSalePaused;
1011     }
1012 
1013 
1014     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1015     // +
1016     // + admin only stuff
1017     // +
1018     // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1019     event AdminTransferredOwnership(address indexed previousOwner, address indexed newOwner);
1020     event AdminChangedFundingWallet(address oldAddr, address newAddr);
1021 
1022     // public (admin only): contact control functions; contract creator only; all in one
1023     function adminCommand(uint8 command, address addr, uint256 fee) onlyOwner public returns (bool) {
1024         require(command >= 0 && command <= 255);
1025         if (command == 1) { // (EnumAdminCommand(command) == EnumAdminCommand.SendAllFailsafeEtherToAdminWallet
1026             // contract stores ETH:
1027             // - masternode.totalBalanceWei == never withdrawable by contract owner (only by each MN owner)
1028             // - tokensale.totalWeiInFallback
1029             // - maybe: locked ether by unforseen errors
1030 
1031             require(this.balance >= tokensale.totalWeiInFallback);
1032 
1033             uint256 _withdrawBalance = this.balance.sub(masternode.totalBalanceWei);
1034             require(_withdrawBalance > 0);
1035 
1036             adminWallet.transfer(_withdrawBalance);
1037             tokensale.totalWeiInFallback = 0;
1038             return true;
1039         } else
1040 
1041         if (command == 15) { // (EnumAdminCommand(command) == EnumAdminCommand.RecalculateTotalSupply
1042             // speed up realtime request to balance functions by periodic call this gas cost operation
1043             _requestInterestPayoutToTotalSupply();
1044             _requestInterestPayoutToAccountBalance(contractOwner); // do interest payout before changing balances
1045         } else
1046 
1047         if (command == 22) { // (EnumAdminCommand(command) == EnumAdminCommand.changeTransactionFee) {
1048             require(fee >= 0 && fee <= (9999 * TOKEN_MULTIPLIER) && fee != masternode.transactionRewardInSubtokensRaw1e18);
1049             masternode.transactionRewardInSubtokensRaw1e18 = fee;
1050 
1051             TransactionFeeChanged(fee);
1052             return true;
1053         } else
1054         if (command == 33) { // (EnumAdminCommand(command) == EnumAdminCommand.ChangeMinerReward) {
1055             require(fee >= 0 && fee <= (999999) && fee != masternode.miningRewardInTokens);
1056 
1057             masternode.miningRewardInTokens = fee;                              // 50'000 tokens to mine per masternode per interval
1058             miningRewardInSubtokensRaw1e18 = fee * TOKEN_MULTIPLIER; // used for internal integer calculation
1059 
1060             MinerRewardChanged(fee);
1061             return true;
1062         } else
1063 
1064         if (command == 111) { // (EnumAdminCommand(command) == EnumAdminCommand.CloseTokensale) {
1065             tokensale.tokenSaleClosed = true;
1066 
1067             TokenSaleClosed();
1068             return true;
1069         } else
1070         if (command == 112) { // (EnumAdminCommand(command) == EnumAdminCommand.OpenTokensale) {
1071             tokensale.tokenSaleClosed = false;
1072 
1073             TokenSaleOpened();
1074             return true;
1075         } else
1076         if (command == 113) { // (EnumAdminCommand(command) == EnumAdminCommand.PauseTokensale) {
1077             tokensale.tokenSalePaused = true;
1078 
1079             TokenSalePaused(true);
1080             return true;
1081         } else
1082         if (command == 114) { // (EnumAdminCommand(command) == EnumAdminCommand.UnpauseTokensale) {
1083             tokensale.tokenSalePaused = false;
1084 
1085             TokenSalePaused(false);
1086             return true;
1087         } else
1088 
1089         if (command == 150) { // (EnumAdminCommand(command) == EnumAdminCommand.TransferOwnership) {
1090             require(addr != address(0));
1091             address oldOwner = contractOwner;
1092             contractOwner = addr;
1093 
1094             AdminTransferredOwnership(oldOwner, addr);
1095             return true;
1096         } else
1097         if (command == 152) { // (EnumAdminCommand(command) == EnumAdminCommand.ChangeAdminWallet) {
1098             require(addr != address(0));
1099             require(addr != adminWallet);
1100             address oldAddr = adminWallet;
1101             adminWallet = addr;
1102 
1103             AdminChangedFundingWallet(oldAddr, addr);
1104             return true;
1105         } else
1106 
1107         if (command == 225) { // (EnumAdminCommand(command) == EnumAdminCommand.SelfDestuct) { // enabled during debug only!
1108             require(debug || PRODUCTION_START>_getTimestamp()); // only allowed in debugging mode = during development and in production mode before sale starts
1109 
1110             DebugValue("debug: suicide", this.balance);
1111             selfdestruct(contractOwner);
1112             return true;
1113         }
1114         /*else
1115 
1116         if (command == 236) { // (EnumAdminCommand(command) == EnumAdminCommand.SendAllEther) { // enabled during debug only!
1117             require(debug); // only allowed in debugging mode = during development
1118 
1119             DebugValue("debug: send all ether to admin", this.balance);
1120             contractOwner.transfer(this.balance);
1121             return true;
1122         } else
1123         if (command == 247) { // (EnumAdminCommand(command) == EnumAdminCommand.DisableDebugMode) { // re-enabling is impossible
1124             require(debug); // only allowed in debugging mode = during development
1125 
1126             DebugValue("debug: debug mode disabled - unreverable operation", this.balance);
1127             debug = false;
1128             return true;
1129         }*/
1130         return false;
1131     }
1132 
1133     modifier onlyOwner() {
1134         require(msg.sender == contractOwner);
1135         _;
1136     }
1137 
1138     function _getTimestamp() internal constant returns (uint256) {
1139         return now; // alias for block.timestamp;
1140         // eth-miner manipulation of timestamp (possible in a range up to 900 seconds) is acceptable because interval-functions are in a range from 7 to 30 days.
1141     }
1142 
1143     function _addTime(uint256 _sec) internal pure returns (uint256) {
1144         return _sec * (1 seconds); // in unittime
1145     }
1146 }