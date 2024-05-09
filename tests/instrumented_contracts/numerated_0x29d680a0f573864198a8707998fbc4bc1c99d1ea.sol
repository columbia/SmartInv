1 pragma solidity >=0.4.10;
2 
3 contract Token {
4     function transferFrom(address from, address to, uint amount) returns(bool);
5     function transfer(address to, uint amount) returns(bool);
6     function balanceOf(address addr) constant returns(uint);
7 }
8 
9 contract Owned {
10     address public owner;
11     address public newOwner;
12 
13     /**
14      * Events
15      */
16     event ChangedOwner(address indexed new_owner);
17 
18     /**
19      * Functionality
20      */
21 
22     function Owned() {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function changeOwner(address _newOwner) onlyOwner external {
32         newOwner = _newOwner;
33     }
34 
35     function acceptOwnership() external {
36         if (msg.sender == newOwner) {
37             owner = newOwner;
38             newOwner = 0x0;
39             ChangedOwner(owner);
40         }
41     }
42 }
43 
44 contract IOwned {
45     function owner() returns (address);
46     function changeOwner(address);
47     function acceptOwnership();
48 }
49 
50 /**
51  * Savings is a contract that releases Tokens on a predefined
52  * schedule, and allocates bonus tokens upon withdrawal on a
53  * proportional basis, determined by the ratio of deposited tokens
54  * to total owned tokens.
55  *
56  * The distribution schedule consists of a monthly withdrawal schedule
57  * responsible for distribution 75% of the total savings, and a
58  * one-off withdrawal event available before or at the start of the
59  * withdrawal schedule, distributing 25% of the total savings.
60  *
61  * To be exact, upon contract deployment there may be a period of time in which
62  * only the one-off withdrawal event is available, define this period of time as:
63  * [timestamp(start), timestamp(startBlockTimestamp)),
64  *
65  * Then the periodic withdrawal range is defined as:
66  * [timestamp(startBlockTimestamp), +inf)
67  *
68  * DO NOT SEND TOKENS TO THIS CONTRACT. Use the deposit() or depositTo() method.
69  * As an exception, tokens transferred to this contract before locking are the
70  * bonus tokens that are distributed.
71  */
72 contract Savings is Owned {
73     /**
74      * Periods is the total monthly withdrawable amount, not counting the
75      * special withdrawal.
76      */
77     uint public periods;
78 
79     /**
80      * t0special is an additional multiplier that determines what
81      * fraction of the total distribution is distributed in the
82      * one-off withdrawal event. It is used in conjunction with
83      * a periodic multiplier (p) to determine the total savings withdrawable
84      * to the user at that point in time.
85      *
86      * The value is not set, it is calculated based on periods
87      */
88     uint public t0special;
89 
90     uint constant public intervalSecs = 30 days;
91     uint constant public precision = 10 ** 18;
92 
93 
94     /**
95      * Events
96      */
97     event Withdraws(address indexed who, uint amount);
98     event Deposit(address indexed who, uint amount);
99 
100     bool public inited;
101     bool public locked;
102     uint public startBlockTimestamp = 0;
103 
104     Token public token;
105 
106     // face value deposited by an address before locking
107     mapping (address => uint) public deposited;
108 
109     // total face value deposited; sum of deposited
110     uint public totalfv;
111 
112     // the total remaining value
113     uint public remainder;
114 
115     /**
116      * Total tokens owned by the contract after locking, and possibly
117      * updated by the foundation after subsequent sales.
118      */
119     uint public total;
120 
121     // the total value withdrawn
122     mapping (address => uint256) public withdrawn;
123 
124     bool public nullified;
125 
126     modifier isParticipant() {
127         require(
128             msg.sender == 0x4778bE92Dd5c51035bf80Fca564ba5E7Fad5FB6d ||
129             msg.sender == 0x8567462b8E8303637F0004B2E664993314e58BD7 ||
130             msg.sender == 0x0e24D8Fcdf0c319dF03998Cc53F4FBA035D9a4f9 ||
131             msg.sender == 0xb493c9C0C0aBfd9847baB53231774f13BF882eE9
132         );
133         _;
134     }
135 
136     modifier notNullified() { require(!nullified); _; }
137 
138     modifier preLock() { require(!locked && startBlockTimestamp == 0); _; }
139 
140     /**
141      * Lock called, deposits no longer available.
142      */
143     modifier postLock() { require(locked); _; }
144 
145     /**
146      * Prestart, state is after lock, before start
147      */
148     modifier preStart() { require(locked && startBlockTimestamp == 0); _; }
149 
150     /**
151      * Start called, the savings contract is now finalized, and withdrawals
152      * are now permitted.
153      */
154     modifier postStart() { require(locked && startBlockTimestamp != 0); _; }
155 
156     /**
157      * Uninitialized state, before init is called. Mainly used as a guard to
158      * finalize periods and t0special.
159      */
160     modifier notInitialized() { require(!inited); _; }
161 
162     /**
163      * Post initialization state, mainly used to guarantee that
164      * periods and t0special have been set properly before starting
165      * the withdrawal process.
166      */
167     modifier initialized() { require(inited); _; }
168 
169     /**
170      * Revert under all conditions for fallback, cheaper mistakes
171      * in the future?
172      */
173     function() {
174         revert();
175     }
176 
177     /**
178      * Nullify functionality is intended to disable the contract.
179      */
180     function nullify() onlyOwner {
181         nullified = true;
182     }
183 
184     /**
185      * Initialization function, should be called after contract deployment. The
186      * addition of this function allows contract compilation to be simplified
187      * to one contract, instead of two.
188      *
189      * periods and t0special are finalized, and effectively invariant, after
190      * init is called for the first time.
191      */
192     function init(uint _periods, uint _t0special) onlyOwner notInitialized {
193         require(_periods != 0);
194         periods = _periods;
195         t0special = _t0special;
196     }
197 
198     function finalizeInit() onlyOwner notInitialized {
199         inited = true;
200     }
201 
202     function setToken(address tok) onlyOwner {
203         token = Token(tok);
204     }
205 
206     /**
207      * Lock is called by the owner to lock the savings contract
208      * so that no more deposits may be made.
209      */
210     function lock() onlyOwner {
211         locked = true;
212     }
213 
214     /**
215      * Starts the distribution of savings, it should be called
216      * after lock(), once all of the bonus tokens are send to this contract,
217      * and multiMint has been called.
218      */
219     function start(uint _startBlockTimestamp) onlyOwner initialized preStart {
220         startBlockTimestamp = _startBlockTimestamp;
221         uint256 tokenBalance = token.balanceOf(this);
222         total = tokenBalance;
223         remainder = tokenBalance;
224     }
225 
226     /**
227      * Check withdrawal is live, useful for checking whether
228      * the savings contract is "live", withdrawal enabled, started.
229      */
230     function isStarted() constant returns(bool) {
231         return locked && startBlockTimestamp != 0;
232     }
233 
234     // if someone accidentally transfers tokens to this contract,
235     // the owner can return them as long as distribution hasn't started
236 
237     /**
238      * Used to refund users who accidentaly transferred tokens to this
239      * contract, only available before contract is locked
240      */
241     function refundTokens(address addr, uint amount) onlyOwner preLock {
242         token.transfer(addr, amount);
243     }
244 
245 
246     /**
247      * Update the total balance, to be called in case of subsequent sales. Updates
248      * the total recorded balance of the contract by the difference in expected
249      * remainder and the current balance. This means any positive difference will
250      * be "recorded" into the contract, and distributed within the remaining
251      * months of the TRS.
252      */
253     function updateTotal() onlyOwner postLock {
254         uint current = token.balanceOf(this);
255         require(current >= remainder); // for sanity
256 
257         uint difference = (current - remainder);
258         total += difference;
259         remainder = current;
260     }
261 
262     /**
263      * Calculates the monthly period, starting after the startBlockTimestamp,
264      * periodAt will return 0 for all timestamps before startBlockTimestamp.
265      *
266      * Therefore period 0 is the range of time in which we have called start(),
267      * but have not yet passed startBlockTimestamp. Period 1 is the
268      * first monthly period, and so-forth all the way until the last
269      * period == periods.
270      *
271      * NOTE: not guarded since no state modifications are made. However,
272      * it will return invalid data before the postStart state. It is
273      * up to the user to manually check that the contract is in
274      * postStart state.
275      */
276     function periodAt(uint _blockTimestamp) constant returns(uint) {
277         /**
278          * Lower bound, consider period 0 to be the time between
279          * start() and startBlockTimestamp
280          */
281         if (startBlockTimestamp > _blockTimestamp)
282             return 0;
283 
284         /**
285          * Calculate the appropriate period, and set an upper bound of
286          * periods - 1.
287          */
288         uint p = ((_blockTimestamp - startBlockTimestamp) / intervalSecs) + 1;
289         if (p > periods)
290             p = periods;
291         return p;
292     }
293 
294     // what withdrawal period are we in?
295     // returns the period number from [0, periods)
296     function period() constant returns(uint) {
297         return periodAt(block.timestamp);
298     }
299 
300     // deposit your tokens to be saved
301     //
302     // the despositor must have approve()'d the tokens
303     // to be transferred by this contract
304     function deposit(uint tokens) notNullified {
305         depositTo(msg.sender, tokens);
306     }
307 
308 
309     function depositTo(address beneficiary, uint tokens) isParticipant preLock notNullified {
310         require(token.transferFrom(msg.sender, this, tokens));
311         deposited[beneficiary] += tokens;
312         totalfv += tokens;
313         Deposit(beneficiary, tokens);
314     }
315 
316     // convenience function for owner: deposit on behalf of many
317     function bulkDepositTo(uint256[] bits) onlyOwner {
318         uint256 lomask = (1 << 96) - 1;
319         for (uint i=0; i<bits.length; i++) {
320             address a = address(bits[i]>>96);
321             uint val = bits[i]&lomask;
322             depositTo(a, val);
323         }
324     }
325 
326     // withdraw withdraws tokens to the sender
327     // withdraw can be called at most once per redemption period
328     function withdraw() notNullified returns(bool) {
329         return withdrawTo(msg.sender);
330     }
331 
332     /**
333      * Calculates the fraction of total (one-off + monthly) withdrawable
334      * given the current timestamp. No guards due to function being constant.
335      * Will output invalid data until the postStart state. It is up to the user
336      * to manually confirm contract is in postStart state.
337      */
338     function availableForWithdrawalAt(uint256 blockTimestamp) constant returns (uint256) {
339         /**
340          * Calculate the total withdrawable, giving a numerator with range:
341          * [0.25 * 10 ** 18, 1 * 10 ** 18]
342          */
343         return ((t0special + periodAt(blockTimestamp)) * precision) / (t0special + periods);
344     }
345 
346     /**
347      * Business logic of _withdrawTo, the code is separated this way mainly for
348      * testing. We can inject and test parameters freely without worrying about the
349      * blockchain model.
350      *
351      * NOTE: Since function is constant, no guards are applied. This function will give
352      * invalid outputs unless in postStart state. It is up to user to manually check
353      * that the correct state is given (isStart() == true)
354      */
355     function _withdrawTo(uint _deposit, uint _withdrawn, uint _blockTimestamp, uint _total) constant returns (uint) {
356         uint256 fraction = availableForWithdrawalAt(_blockTimestamp);
357 
358         /**
359          * There are concerns that the multiplication could possibly
360          * overflow, however this should not be the case if we calculate
361          * the upper bound based on our known parameters:
362          *
363          * Lets assume the minted token amount to be 500 million (reasonable),
364          * given a precision of 8 decimal places, we get:
365          * deposited[addr] = 5 * (10 ** 8) * (10 ** 8) = 5 * (10 ** 16)
366          *
367          * The max for fraction = 10 ** 18, and the max for total is
368          * also 5 * (10 ** 16).
369          *
370          * Therefore:
371          * deposited[addr] * fraction * total = 2.5 * (10 ** 51)
372          *
373          * The maximum for a uint256 is = 1.15 * (10 ** 77)
374          */
375         uint256 withdrawable = ((_deposit * fraction * _total) / totalfv) / precision;
376 
377         // check that we can withdraw something
378         if (withdrawable > _withdrawn) {
379             return withdrawable - _withdrawn;
380         }
381         return 0;
382     }
383 
384     /**
385      * Public facing withdrawTo, injects business logic with
386      * the correct model.
387      */
388     function withdrawTo(address addr) postStart notNullified returns (bool) {
389         uint _d = deposited[addr];
390         uint _w = withdrawn[addr];
391 
392         uint diff = _withdrawTo(_d, _w, block.timestamp, total);
393 
394         // no withdrawal could be made
395         if (diff == 0) {
396             return false;
397         }
398 
399         // check that we cannot withdraw more than max
400         require((diff + _w) <= ((_d * total) / totalfv));
401 
402         // transfer and increment
403         require(token.transfer(addr, diff));
404 
405         withdrawn[addr] += diff;
406         remainder -= diff;
407         Withdraws(addr, diff);
408         return true;
409     }
410 
411     // force withdrawal to many addresses
412     function bulkWithdraw(address[] addrs) notNullified {
413         for (uint i=0; i<addrs.length; i++)
414             withdrawTo(addrs[i]);
415     }
416 
417     // Code off the chain informs this contract about
418     // tokens that were minted to it on behalf of a depositor.
419     //
420     // Note: the function signature here is known to New Alchemy's
421     // tooling, which is why it is arguably misnamed.
422     uint public mintingNonce;
423     function multiMint(uint nonce, uint256[] bits) onlyOwner preLock {
424 
425         if (nonce != mintingNonce) return;
426         mintingNonce += 1;
427         uint256 lomask = (1 << 96) - 1;
428         uint sum = 0;
429         for (uint i=0; i<bits.length; i++) {
430             address a = address(bits[i]>>96);
431             uint value = bits[i]&lomask;
432             deposited[a] += value;
433             sum += value;
434             Deposit(a, value);
435         }
436         totalfv += sum;
437     }
438 }