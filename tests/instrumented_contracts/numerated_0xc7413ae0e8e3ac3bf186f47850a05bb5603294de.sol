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
44 /**
45  * Savings is a contract that releases Tokens on a predefined
46  * schedule, and allocates bonus tokens upon withdrawal on a
47  * proportional basis, determined by the ratio of deposited tokens
48  * to total owned tokens.
49  *
50  * The distribution schedule consists of a monthly withdrawal schedule
51  * responsible for distribution 75% of the total savings, and a
52  * one-off withdrawal event available before or at the start of the
53  * withdrawal schedule, distributing 25% of the total savings.
54  *
55  * To be exact, upon contract deployment there may be a period of time in which
56  * only the one-off withdrawal event is available, define this period of time as:
57  * [timestamp(start), timestamp(startBlockTimestamp)),
58  *
59  * Then the periodic withdrawal range is defined as:
60  * [timestamp(startBlockTimestamp), +inf)
61  *
62  * DO NOT SEND TOKENS TO THIS CONTRACT. Use the deposit() or depositTo() method.
63  * As an exception, tokens transferred to this contract before locking are the
64  * bonus tokens that are distributed.
65  */
66 contract Savings is Owned {
67     /**
68      * Periods is the total monthly withdrawable amount, not counting the
69      * special withdrawal.
70      */
71     uint public periods;
72 
73     /**
74      * t0special is an additional multiplier that determines what
75      * fraction of the total distribution is distributed in the
76      * one-off withdrawal event. It is used in conjunction with
77      * a periodic multiplier (p) to determine the total savings withdrawable
78      * to the user at that point in time.
79      *
80      * The value is not set, it is calculated based on periods
81      */
82     uint public t0special;
83 
84     uint constant public intervalSecs = 30 days;
85     uint constant public precision = 10 ** 18;
86 
87 
88     /**
89      * Events
90      */
91     event Withdraws(address indexed who, uint amount);
92     event Deposit(address indexed who, uint amount);
93 
94     bool public inited;
95     bool public locked;
96     uint public startBlockTimestamp = 0;
97 
98     Token public token;
99 
100     // face value deposited by an address before locking
101     mapping (address => uint) public deposited;
102 
103     // total face value deposited; sum of deposited
104     uint public totalfv;
105 
106     // the total remaining value
107     uint public remainder;
108 
109     /**
110      * Total tokens owned by the contract after locking, and possibly
111      * updated by the foundation after subsequent sales.
112      */
113     uint public total;
114 
115     // the total value withdrawn
116     mapping (address => uint256) public withdrawn;
117 
118     bool public nullified;
119 
120     modifier notNullified() { require(!nullified); _; }
121 
122     modifier preLock() { require(!locked && startBlockTimestamp == 0); _; }
123 
124     /**
125      * Lock called, deposits no longer available.
126      */
127     modifier postLock() { require(locked); _; }
128 
129     /**
130      * Prestart, state is after lock, before start
131      */
132     modifier preStart() { require(locked && startBlockTimestamp == 0); _; }
133 
134     /**
135      * Start called, the savings contract is now finalized, and withdrawals
136      * are now permitted.
137      */
138     modifier postStart() { require(locked && startBlockTimestamp != 0); _; }
139 
140     /**
141      * Uninitialized state, before init is called. Mainly used as a guard to
142      * finalize periods and t0special.
143      */
144     modifier notInitialized() { require(!inited); _; }
145 
146     /**
147      * Post initialization state, mainly used to guarantee that
148      * periods and t0special have been set properly before starting
149      * the withdrawal process.
150      */
151     modifier initialized() { require(inited); _; }
152 
153     /**
154      * Revert under all conditions for fallback, cheaper mistakes
155      * in the future?
156      */
157     function() {
158         revert();
159     }
160 
161     /**
162      * Nullify functionality is intended to disable the contract.
163      */
164     function nullify() onlyOwner {
165         nullified = true;
166     }
167 
168     /**
169      * Initialization function, should be called after contract deployment. The
170      * addition of this function allows contract compilation to be simplified
171      * to one contract, instead of two.
172      *
173      * periods and t0special are finalized, and effectively invariant, after
174      * init is called for the first time.
175      */
176     function init(uint _periods, uint _t0special) onlyOwner notInitialized {
177         require(_periods != 0);
178         periods = _periods;
179         t0special = _t0special;
180     }
181 
182     function finalizeInit() onlyOwner notInitialized {
183         inited = true;
184     }
185 
186     function setToken(address tok) onlyOwner {
187         token = Token(tok);
188     }
189 
190     /**
191      * Lock is called by the owner to lock the savings contract
192      * so that no more deposits may be made.
193      */
194     function lock() onlyOwner {
195         locked = true;
196     }
197 
198     /**
199      * Starts the distribution of savings, it should be called
200      * after lock(), once all of the bonus tokens are send to this contract,
201      * and multiMint has been called.
202      */
203     function start(uint _startBlockTimestamp) onlyOwner initialized preStart {
204         startBlockTimestamp = _startBlockTimestamp;
205         uint256 tokenBalance = token.balanceOf(this);
206         total = tokenBalance;
207         remainder = tokenBalance;
208     }
209 
210     /**
211      * Check withdrawal is live, useful for checking whether
212      * the savings contract is "live", withdrawal enabled, started.
213      */
214     function isStarted() constant returns(bool) {
215         return locked && startBlockTimestamp != 0;
216     }
217 
218     // if someone accidentally transfers tokens to this contract,
219     // the owner can return them as long as distribution hasn't started
220 
221     /**
222      * Used to refund users who accidentaly transferred tokens to this
223      * contract, only available before contract is locked
224      */
225     function refundTokens(address addr, uint amount) onlyOwner preLock {
226         token.transfer(addr, amount);
227     }
228 
229 
230     /**
231      * Update the total balance, to be called in case of subsequent sales. Updates
232      * the total recorded balance of the contract by the difference in expected
233      * remainder and the current balance. This means any positive difference will
234      * be "recorded" into the contract, and distributed within the remaining
235      * months of the TRS.
236      */
237     function updateTotal() onlyOwner postLock {
238         uint current = token.balanceOf(this);
239         require(current >= remainder); // for sanity
240 
241         uint difference = (current - remainder);
242         total += difference;
243         remainder = current;
244     }
245 
246     /**
247      * Calculates the monthly period, starting after the startBlockTimestamp,
248      * periodAt will return 0 for all timestamps before startBlockTimestamp.
249      *
250      * Therefore period 0 is the range of time in which we have called start(),
251      * but have not yet passed startBlockTimestamp. Period 1 is the
252      * first monthly period, and so-forth all the way until the last
253      * period == periods.
254      *
255      * NOTE: not guarded since no state modifications are made. However,
256      * it will return invalid data before the postStart state. It is
257      * up to the user to manually check that the contract is in
258      * postStart state.
259      */
260     function periodAt(uint _blockTimestamp) constant returns(uint) {
261         /**
262          * Lower bound, consider period 0 to be the time between
263          * start() and startBlockTimestamp
264          */
265         if (startBlockTimestamp > _blockTimestamp)
266             return 0;
267 
268         /**
269          * Calculate the appropriate period, and set an upper bound of
270          * periods - 1.
271          */
272         uint p = ((_blockTimestamp - startBlockTimestamp) / intervalSecs) + 1;
273         if (p > periods)
274             p = periods;
275         return p;
276     }
277 
278     // what withdrawal period are we in?
279     // returns the period number from [0, periods)
280     function period() constant returns(uint) {
281         return periodAt(block.timestamp);
282     }
283 
284     // deposit your tokens to be saved
285     //
286     // the despositor must have approve()'d the tokens
287     // to be transferred by this contract
288     function deposit(uint tokens) notNullified {
289         depositTo(msg.sender, tokens);
290     }
291 
292 
293     function depositTo(address beneficiary, uint tokens) preLock notNullified {
294         require(token.transferFrom(msg.sender, this, tokens));
295         deposited[beneficiary] += tokens;
296         totalfv += tokens;
297         Deposit(beneficiary, tokens);
298     }
299 
300     // convenience function for owner: deposit on behalf of many
301     function bulkDepositTo(uint256[] bits) onlyOwner {
302         uint256 lomask = (1 << 96) - 1;
303         for (uint i=0; i<bits.length; i++) {
304             address a = address(bits[i]>>96);
305             uint val = bits[i]&lomask;
306             depositTo(a, val);
307         }
308     }
309 
310     // withdraw withdraws tokens to the sender
311     // withdraw can be called at most once per redemption period
312     function withdraw() notNullified returns(bool) {
313         return withdrawTo(msg.sender);
314     }
315 
316     /**
317      * Calculates the fraction of total (one-off + monthly) withdrawable
318      * given the current timestamp. No guards due to function being constant.
319      * Will output invalid data until the postStart state. It is up to the user
320      * to manually confirm contract is in postStart state.
321      */
322     function availableForWithdrawalAt(uint256 blockTimestamp) constant returns (uint256) {
323         /**
324          * Calculate the total withdrawable, giving a numerator with range:
325          * [0.25 * 10 ** 18, 1 * 10 ** 18]
326          */
327         return ((t0special + periodAt(blockTimestamp)) * precision) / (t0special + periods);
328     }
329 
330     /**
331      * Business logic of _withdrawTo, the code is separated this way mainly for
332      * testing. We can inject and test parameters freely without worrying about the
333      * blockchain model.
334      *
335      * NOTE: Since function is constant, no guards are applied. This function will give
336      * invalid outputs unless in postStart state. It is up to user to manually check
337      * that the correct state is given (isStart() == true)
338      */
339     function _withdrawTo(uint _deposit, uint _withdrawn, uint _blockTimestamp, uint _total) constant returns (uint) {
340         uint256 fraction = availableForWithdrawalAt(_blockTimestamp);
341 
342         /**
343          * There are concerns that the multiplication could possibly
344          * overflow, however this should not be the case if we calculate
345          * the upper bound based on our known parameters:
346          *
347          * Lets assume the minted token amount to be 500 million (reasonable),
348          * given a precision of 8 decimal places, we get:
349          * deposited[addr] = 5 * (10 ** 8) * (10 ** 8) = 5 * (10 ** 16)
350          *
351          * The max for fraction = 10 ** 18, and the max for total is
352          * also 5 * (10 ** 16).
353          *
354          * Therefore:
355          * deposited[addr] * fraction * total = 2.5 * (10 ** 51)
356          *
357          * The maximum for a uint256 is = 1.15 * (10 ** 77)
358          */
359         uint256 withdrawable = ((_deposit * fraction * _total) / totalfv) / precision;
360 
361         // check that we can withdraw something
362         if (withdrawable > _withdrawn) {
363             return withdrawable - _withdrawn;
364         }
365         return 0;
366     }
367 
368     /**
369      * Public facing withdrawTo, injects business logic with
370      * the correct model.
371      */
372     function withdrawTo(address addr) postStart notNullified returns (bool) {
373         uint _d = deposited[addr];
374         uint _w = withdrawn[addr];
375 
376         uint diff = _withdrawTo(_d, _w, block.timestamp, total);
377 
378         // no withdrawal could be made
379         if (diff == 0) {
380             return false;
381         }
382 
383         // check that we cannot withdraw more than max
384         require((diff + _w) <= ((_d * total) / totalfv));
385 
386         // transfer and increment
387         require(token.transfer(addr, diff));
388 
389         withdrawn[addr] += diff;
390         remainder -= diff;
391         Withdraws(addr, diff);
392         return true;
393     }
394 
395     // force withdrawal to many addresses
396     function bulkWithdraw(address[] addrs) notNullified {
397         for (uint i=0; i<addrs.length; i++)
398             withdrawTo(addrs[i]);
399     }
400 
401     // Code off the chain informs this contract about
402     // tokens that were minted to it on behalf of a depositor.
403     //
404     // Note: the function signature here is known to New Alchemy's
405     // tooling, which is why it is arguably misnamed.
406     uint public mintingNonce;
407     function multiMint(uint nonce, uint256[] bits) onlyOwner preLock {
408 
409         if (nonce != mintingNonce) return;
410         mintingNonce += 1;
411         uint256 lomask = (1 << 96) - 1;
412         uint sum = 0;
413         for (uint i=0; i<bits.length; i++) {
414             address a = address(bits[i]>>96);
415             uint value = bits[i]&lomask;
416             deposited[a] += value;
417             sum += value;
418             Deposit(a, value);
419         }
420         totalfv += sum;
421     }
422 }