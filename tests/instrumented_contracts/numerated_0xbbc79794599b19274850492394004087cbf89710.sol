1 pragma solidity ^0.4.11;
2 
3 /*
4     Overflow protected math functions
5 */
6 contract SafeMath {
7     /**
8         constructor
9     */
10     function SafeMath() {
11     }
12 
13     /**
14         @dev returns the sum of _x and _y, asserts if the calculation overflows
15 
16         @param _x   value 1
17         @param _y   value 2
18 
19         @return sum
20     */
21     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
22         uint256 z = _x + _y;
23         assert(z >= _x);
24         return z;
25     }
26 
27     /**
28         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
29 
30         @param _x   minuend
31         @param _y   subtrahend
32 
33         @return difference
34     */
35     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
36         assert(_x >= _y);
37         return _x - _y;
38     }
39 
40     /**
41         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
42 
43         @param _x   factor 1
44         @param _y   factor 2
45 
46         @return product
47     */
48     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
49         uint256 z = _x * _y;
50         assert(_x == 0 || z / _x == _y);
51         return z;
52     }
53 }
54 
55 /*
56     Owned contract interface
57 */
58 contract IOwned {
59     // this function isn't abstract since the compiler emits automatically generated getter functions as external
60     function owner() public constant returns (address owner) { owner; }
61 
62     function transferOwnership(address _newOwner) public;
63     function acceptOwnership() public;
64 }
65 
66 /*
67     Provides support and utilities for contract ownership
68 */
69 contract Owned is IOwned {
70     address public owner;
71     address public newOwner;
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 
75     /**
76         @dev constructor
77     */
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     // allows execution by the owner only
83     modifier ownerOnly {
84         assert(msg.sender == owner);
85         _;
86     }
87 
88     /**
89         @dev allows transferring the contract ownership
90         the new owner still need to accept the transfer
91         can only be called by the contract owner
92 
93         @param _newOwner    new contract owner
94     */
95     function transferOwnership(address _newOwner) public ownerOnly {
96         require(_newOwner != owner);
97         newOwner = _newOwner;
98     }
99 
100     /**
101         @dev used by a new owner to accept an ownership transfer
102     */
103     function acceptOwnership() public {
104         require(msg.sender == newOwner);
105         OwnerUpdate(owner, newOwner);
106         owner = newOwner;
107         newOwner = 0x0;
108     }
109 }
110 
111 /*
112     ERC20 Standard Token interface
113 */
114 contract IERC20Token {
115     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
116     function name() public constant returns (string name) { name; }
117     function symbol() public constant returns (string symbol) { symbol; }
118     function decimals() public constant returns (uint8 decimals) { decimals; }
119     function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }
120     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
121     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
122 
123     function transfer(address _to, uint256 _value) public returns (bool success);
124     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
125     function approve(address _spender, uint256 _value) public returns (bool success);
126 }
127 
128 /*
129     Token Holder interface
130 */
131 contract ITokenHolder is IOwned {
132     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
133 }
134 
135 /*
136     We consider every contract to be a 'token holder' since it's currently not possible
137     for a contract to deny receiving tokens.
138 
139     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
140     the owner to send tokens that were sent to the contract by mistake back to their sender.
141 */
142 contract TokenHolder is ITokenHolder, Owned {
143     /**
144         @dev constructor
145     */
146     function TokenHolder() {
147     }
148 
149     // validates an address - currently only checks that it isn't null
150     modifier validAddress(address _address) {
151         require(_address != 0x0);
152         _;
153     }
154 
155     // verifies that the address is different than this contract address
156     modifier notThis(address _address) {
157         require(_address != address(this));
158         _;
159     }
160 
161     /**
162         @dev withdraws tokens held by the contract and sends them to an account
163         can only be called by the owner
164 
165         @param _token   ERC20 token contract address
166         @param _to      account to receive the new amount
167         @param _amount  amount to withdraw
168     */
169     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
170         public
171         ownerOnly
172         validAddress(_token)
173         validAddress(_to)
174         notThis(_to)
175     {
176         assert(_token.transfer(_to, _amount));
177     }
178 }
179 
180 /*
181     Smart Token interface
182 */
183 contract ISmartToken is ITokenHolder, IERC20Token {
184     function disableTransfers(bool _disable) public;
185     function issue(address _to, uint256 _amount) public;
186     function destroy(address _from, uint256 _amount) public;
187 }
188 
189 /*
190     The smart token controller is an upgradable part of the smart token that allows
191     more functionality as well as fixes for bugs/exploits.
192     Once it accepts ownership of the token, it becomes the token's sole controller
193     that can execute any of its functions.
194 
195     To upgrade the controller, ownership must be transferred to a new controller, along with
196     any relevant data.
197 
198     The smart token must be set on construction and cannot be changed afterwards.
199     Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
200 
201     Note that the controller can transfer token ownership to a new controller that
202     doesn't allow executing any function on the token, for a trustless solution.
203     Doing that will also remove the owner's ability to upgrade the controller.
204 */
205 contract SmartTokenController is TokenHolder {
206     ISmartToken public token;   // smart token
207 
208     /**
209         @dev constructor
210     */
211     function SmartTokenController(ISmartToken _token)
212         validAddress(_token)
213     {
214         token = _token;
215     }
216 
217     // ensures that the controller is the token's owner
218     modifier active() {
219         assert(token.owner() == address(this));
220         _;
221     }
222 
223     // ensures that the controller is not the token's owner
224     modifier inactive() {
225         assert(token.owner() != address(this));
226         _;
227     }
228 
229     /**
230         @dev allows transferring the token ownership
231         the new owner still need to accept the transfer
232         can only be called by the contract owner
233 
234         @param _newOwner    new token owner
235     */
236     function transferTokenOwnership(address _newOwner) public ownerOnly {
237         token.transferOwnership(_newOwner);
238     }
239 
240     /**
241         @dev used by a new owner to accept a token ownership transfer
242         can only be called by the contract owner
243     */
244     function acceptTokenOwnership() public ownerOnly {
245         token.acceptOwnership();
246     }
247 
248     /**
249         @dev disables/enables token transfers
250         can only be called by the contract owner
251 
252         @param _disable    true to disable transfers, false to enable them
253     */
254     function disableTokenTransfers(bool _disable) public ownerOnly {
255         token.disableTransfers(_disable);
256     }
257 
258     /**
259         @dev allows the owner to execute the token's issue function
260 
261         @param _to         account to receive the new amount
262         @param _amount     amount to increase the supply by
263     */
264     function issueTokens(address _to, uint256 _amount) public ownerOnly {
265         token.issue(_to, _amount);
266     }
267 
268     /**
269         @dev allows the owner to execute the token's destroy function
270 
271         @param _from       account to remove the amount from
272         @param _amount     amount to decrease the supply by
273     */
274     function destroyTokens(address _from, uint256 _amount) public ownerOnly {
275         token.destroy(_from, _amount);
276     }
277 
278     /**
279         @dev withdraws tokens held by the token and sends them to an account
280         can only be called by the owner
281 
282         @param _token   ERC20 token contract address
283         @param _to      account to receive the new amount
284         @param _amount  amount to withdraw
285     */
286     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
287         token.withdrawTokens(_token, _to, _amount);
288     }
289 }
290 
291 /*
292     Crowdsale v0.1
293 
294     The crowdsale version of the smart token controller, allows contributing ether in exchange for Bancor tokens
295     The price remains fixed for the entire duration of the crowdsale
296     Note that 20% of the contributions are the Bancor token's reserve
297 */
298 contract CrowdsaleController is SmartTokenController, SafeMath {
299     uint256 public constant DURATION = 14 days;                 // crowdsale duration
300     uint256 public constant TOKEN_PRICE_N = 1;                  // initial price in wei (numerator)
301     uint256 public constant TOKEN_PRICE_D = 100;                // initial price in wei (denominator)
302     uint256 public constant BTCS_ETHER_CAP = 50000 ether;       // maximum bitcoin suisse ether contribution
303     uint256 public constant MAX_GAS_PRICE = 50000000000 wei;    // maximum gas price for contribution transactions
304 
305     string public version = '0.1';
306 
307     uint256 public startTime = 0;                   // crowdsale start time (in seconds)
308     uint256 public endTime = 0;                     // crowdsale end time (in seconds)
309     uint256 public totalEtherCap = 1000000 ether;   // current ether contribution cap, initialized with a temp value as a safety mechanism until the real cap is revealed
310     uint256 public totalEtherContributed = 0;       // ether contributed so far
311     bytes32 public realEtherCapHash;                // ensures that the real cap is predefined on deployment and cannot be changed later
312     address public beneficiary = 0x0;               // address to receive all ether contributions
313     address public btcs = 0x0;                      // bitcoin suisse address
314 
315     // triggered on each contribution
316     event Contribution(address indexed _contributor, uint256 _amount, uint256 _return);
317 
318     /**
319         @dev constructor
320 
321         @param _token          smart token the crowdsale is for
322         @param _startTime      crowdsale start time
323         @param _beneficiary    address to receive all ether contributions
324         @param _btcs           bitcoin suisse address
325     */
326     function CrowdsaleController(ISmartToken _token, uint256 _startTime, address _beneficiary, address _btcs, bytes32 _realEtherCapHash)
327         SmartTokenController(_token)
328         validAddress(_beneficiary)
329         validAddress(_btcs)
330         earlierThan(_startTime)
331         validAmount(uint256(_realEtherCapHash))
332     {
333         startTime = _startTime;
334         endTime = startTime + DURATION;
335         beneficiary = _beneficiary;
336         btcs = _btcs;
337         realEtherCapHash = _realEtherCapHash;
338     }
339 
340     // verifies that an amount is greater than zero
341     modifier validAmount(uint256 _amount) {
342         require(_amount > 0);
343         _;
344     }
345 
346     // verifies that the gas price is lower than 50 gwei
347     modifier validGasPrice() {
348         assert(tx.gasprice <= MAX_GAS_PRICE);
349         _;
350     }
351 
352     // verifies that the ether cap is valid based on the key provided
353     modifier validEtherCap(uint256 _cap, uint256 _key) {
354         require(computeRealCap(_cap, _key) == realEtherCapHash);
355         _;
356     }
357 
358     // ensures that it's earlier than the given time
359     modifier earlierThan(uint256 _time) {
360         assert(now < _time);
361         _;
362     }
363 
364     // ensures that the current time is between _startTime (inclusive) and _endTime (exclusive)
365     modifier between(uint256 _startTime, uint256 _endTime) {
366         assert(now >= _startTime && now < _endTime);
367         _;
368     }
369 
370     // ensures that the sender is bitcoin suisse
371     modifier btcsOnly() {
372         assert(msg.sender == btcs);
373         _;
374     }
375 
376     // ensures that we didn't reach the ether cap
377     modifier etherCapNotReached(uint256 _contribution) {
378         assert(safeAdd(totalEtherContributed, _contribution) <= totalEtherCap);
379         _;
380     }
381 
382     // ensures that we didn't reach the bitcoin suisse ether cap
383     modifier btcsEtherCapNotReached(uint256 _ethContribution) {
384         assert(safeAdd(totalEtherContributed, _ethContribution) <= BTCS_ETHER_CAP);
385         _;
386     }
387 
388     /**
389         @dev computes the real cap based on the given cap & key
390 
391         @param _cap    cap
392         @param _key    key used to compute the cap hash
393 
394         @return computed real cap hash
395     */
396     function computeRealCap(uint256 _cap, uint256 _key) public constant returns (bytes32) {
397         return keccak256(_cap, _key);
398     }
399 
400     /**
401         @dev enables the real cap defined on deployment
402 
403         @param _cap    predefined cap
404         @param _key    key used to compute the cap hash
405     */
406     function enableRealCap(uint256 _cap, uint256 _key)
407         public
408         ownerOnly
409         active
410         between(startTime, endTime)
411         validEtherCap(_cap, _key)
412     {
413         require(_cap < totalEtherCap); // validate input
414         totalEtherCap = _cap;
415     }
416 
417     /**
418         @dev computes the number of tokens that should be issued for a given contribution
419 
420         @param _contribution    contribution amount
421 
422         @return computed number of tokens
423     */
424     function computeReturn(uint256 _contribution) public constant returns (uint256) {
425         return safeMul(_contribution, TOKEN_PRICE_D) / TOKEN_PRICE_N;
426     }
427 
428     /**
429         @dev ETH contribution
430         can only be called during the crowdsale
431 
432         @return tokens issued in return
433     */
434     function contributeETH()
435         public
436         payable
437         between(startTime, endTime)
438         returns (uint256 amount)
439     {
440         return processContribution();
441     }
442 
443     /**
444         @dev Contribution through BTCs (Bitcoin Suisse only)
445         can only be called before the crowdsale started
446 
447         @return tokens issued in return
448     */
449     function contributeBTCs()
450         public
451         payable
452         btcsOnly
453         btcsEtherCapNotReached(msg.value)
454         earlierThan(startTime)
455         returns (uint256 amount)
456     {
457         return processContribution();
458     }
459 
460     /**
461         @dev handles contribution logic
462         note that the Contribution event is triggered using the sender as the contributor, regardless of the actual contributor
463 
464         @return tokens issued in return
465     */
466     function processContribution() private
467         active
468         etherCapNotReached(msg.value)
469         validGasPrice
470         returns (uint256 amount)
471     {
472         uint256 tokenAmount = computeReturn(msg.value);
473         assert(beneficiary.send(msg.value)); // transfer the ether to the beneficiary account
474         totalEtherContributed = safeAdd(totalEtherContributed, msg.value); // update the total contribution amount
475         token.issue(msg.sender, tokenAmount); // issue new funds to the contributor in the smart token
476         token.issue(beneficiary, tokenAmount); // issue tokens to the beneficiary
477 
478         Contribution(msg.sender, msg.value, tokenAmount);
479         return tokenAmount;
480     }
481 
482     // fallback
483     function() payable {
484         contributeETH();
485     }
486 }