1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4 
5     function safeMul(uint256 a, uint256 b) internal returns (uint256 ) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint256 a, uint256 b) internal returns (uint256 ) {
12         assert(b > 0);
13         uint256 c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint256 a, uint256 b) internal returns (uint256 ) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint256 a, uint256 b) internal returns (uint256 ) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30         return a >= b ? a : b;
31     }
32 
33     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34         return a < b ? a : b;
35     }
36 
37     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38         return a >= b ? a : b;
39     }
40 
41     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42         return a < b ? a : b;
43     }
44 
45     function assert(bool assertion) internal {
46         if (!assertion) {
47             throw;
48         }
49     }
50 }
51 
52 contract ERC20 {
53 
54     /* This is a slight change to the ERC20 base standard.
55     function totalSupply() constant returns (uint256 supply);
56     is replaced with:
57     uint256 public totalSupply;
58     This automatically creates a getter function for the totalSupply.
59     This is moved to the base contract since public getter functions are not
60     currently recognised as an implementation of the matching abstract
61     function by the compiler.
62     */
63     /// total amount of tokens
64     uint256 public totalSupply;
65 
66     /// @param _owner The address from which the balance will be retrieved
67     /// @return The balance
68     function balanceOf(address _owner) constant returns (uint256 balance);
69 
70     /// @notice send `_value` token to `_to` from `msg.sender`
71     /// @param _to The address of the recipient
72     /// @param _value The amount of token to be transferred
73     /// @return Whether the transfer was successful or not
74     function transfer(address _to, uint256 _value) returns (bool success);
75 
76     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
77     /// @param _from The address of the sender
78     /// @param _to The address of the recipient
79     /// @param _value The amount of token to be transferred
80     /// @return Whether the transfer was successful or not
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
82 
83     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
84     /// @param _spender The address of the account able to transfer the tokens
85     /// @param _value The amount of tokens to be approved for transfer
86     /// @return Whether the approval was successful or not
87     function approve(address _spender, uint256 _value) returns (bool success);
88 
89     /// @param _owner The address of the account owning tokens
90     /// @param _spender The address of the account able to transfer the tokens
91     /// @return Amount of remaining tokens allowed to spent
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }
97 
98 contract StandardToken is ERC20, SafeMath {
99 
100     mapping(address => uint256) balances;
101     mapping(address => mapping(address => uint256)) allowed;
102 
103     /// @dev Returns number of tokens owned by given address.
104     /// @param _owner Address of token owner.
105     function balanceOf(address _owner) constant returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     /// @dev Transfers sender's tokens to a given address. Returns success.
110     /// @param _to Address of token receiver.
111     /// @param _value Number of tokens to transfer.
112     function transfer(address _to, uint256 _value) returns (bool) {
113         if (balances[msg.sender] >= _value && _value > 0) {
114             balances[msg.sender] = safeSub(balances[msg.sender], _value);
115             balances[_to] = safeAdd(balances[_to], _value);
116             Transfer(msg.sender, _to, _value);
117             return true;
118         } else return false;
119     }
120 
121     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
122     /// @param _from Address from where tokens are withdrawn.
123     /// @param _to Address to where tokens are sent.
124     /// @param _value Number of tokens to transfer.
125     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
126         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
127             balances[_to] = safeAdd(balances[_to], _value);
128             balances[_from] = safeSub(balances[_from], _value);
129             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
130             Transfer(_from, _to, _value);
131             return true;
132         } else return false;
133     }
134 
135     /// @dev Sets approved amount of tokens for spender. Returns success.
136     /// @param _spender Address of allowed account.
137     /// @param _value Number of approved tokens.
138     function approve(address _spender, uint256 _value) returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /// @dev Returns number of allowed tokens for given address.
145     /// @param _owner Address of token owner.
146     /// @param _spender Address of token spender.
147     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }
150 }
151 
152 contract Ownable {
153 
154     address public owner;
155     address public pendingOwner;
156 
157     function Ownable() {
158         owner = msg.sender;
159     }
160 
161     modifier onlyOwner() {
162         if (msg.sender != owner) throw;
163         _;
164     }
165 
166     // Safe transfer of ownership in 2 steps. Once called, a newOwner needs to call claimOwnership() to prove ownership.
167     function transferOwnership(address newOwner) onlyOwner {
168         pendingOwner = newOwner;
169     }
170 
171     function claimOwnership() {
172         if (msg.sender == pendingOwner) {
173             owner = pendingOwner;
174             pendingOwner = 0;
175         }
176     }
177 }
178 
179 contract MultiOwnable {
180 
181     mapping (address => bool) ownerMap;
182     address[] public owners;
183 
184     event OwnerAdded(address indexed _newOwner);
185     event OwnerRemoved(address indexed _oldOwner);
186 
187     modifier onlyOwner() {
188         if (!isOwner(msg.sender)) throw;
189         _;
190     }
191 
192     function MultiOwnable() {
193         // Add default owner
194         address owner = msg.sender;
195         ownerMap[owner] = true;
196         owners.push(owner);
197     }
198 
199     function ownerCount() constant returns (uint256) {
200         return owners.length;
201     }
202 
203     function isOwner(address owner) constant returns (bool) {
204         return ownerMap[owner];
205     }
206 
207     function addOwner(address owner) onlyOwner returns (bool) {
208         if (!isOwner(owner) && owner != 0) {
209             ownerMap[owner] = true;
210             owners.push(owner);
211 
212             OwnerAdded(owner);
213             return true;
214         } else return false;
215     }
216 
217     function removeOwner(address owner) onlyOwner returns (bool) {
218         if (isOwner(owner)) {
219             ownerMap[owner] = false;
220             for (uint i = 0; i < owners.length - 1; i++) {
221                 if (owners[i] == owner) {
222                     owners[i] = owners[owners.length - 1];
223                     break;
224                 }
225             }
226             owners.length -= 1;
227 
228             OwnerRemoved(owner);
229             return true;
230         } else return false;
231     }
232 }
233 
234 contract Pausable is Ownable {
235 
236     bool public paused;
237 
238     modifier ifNotPaused {
239         if (paused) throw;
240         _;
241     }
242 
243     modifier ifPaused {
244         if (!paused) throw;
245         _;
246     }
247 
248     // Called by the owner on emergency, triggers paused state
249     function pause() external onlyOwner {
250         paused = true;
251     }
252 
253     // Called by the owner on end of emergency, returns to normal state
254     function resume() external onlyOwner ifPaused {
255         paused = false;
256     }
257 }
258 
259 contract TokenSpender {
260     function receiveApproval(address _from, uint256 _value);
261 }
262 
263 contract BsToken is StandardToken, MultiOwnable {
264 
265     bool public locked;
266 
267     string public name;
268     string public symbol;
269     uint256 public totalSupply;
270     uint8 public decimals = 18;
271     string public version = 'v0.1';
272 
273     address public creator;
274     address public seller;
275     uint256 public tokensSold;
276     uint256 public totalSales;
277 
278     event Sell(address indexed _seller, address indexed _buyer, uint256 _value);
279     event SellerChanged(address indexed _oldSeller, address indexed _newSeller);
280 
281     modifier onlyUnlocked() {
282         if (!isOwner(msg.sender) && locked) throw;
283         _;
284     }
285 
286     function BsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {
287 
288         // Lock the transfer function during the presale/crowdsale to prevent speculations.
289         locked = true;
290 
291         creator = msg.sender;
292         seller = _seller;
293 
294         name = _name;
295         symbol = _symbol;
296         totalSupply = _totalSupplyNoDecimals * 1e18;
297 
298         balances[seller] = totalSupply;
299         Transfer(0x0, seller, totalSupply);
300     }
301 
302     function changeSeller(address newSeller) onlyOwner returns (bool) {
303         if (newSeller == 0x0 || seller == newSeller) throw;
304 
305         address oldSeller = seller;
306 
307         uint256 unsoldTokens = balances[oldSeller];
308         balances[oldSeller] = 0;
309         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
310         Transfer(oldSeller, newSeller, unsoldTokens);
311 
312         seller = newSeller;
313         SellerChanged(oldSeller, newSeller);
314         return true;
315     }
316 
317     function sellNoDecimals(address _to, uint256 _value) returns (bool) {
318         return sell(_to, _value * 1e18);
319     }
320 
321     function sell(address _to, uint256 _value) onlyOwner returns (bool) {
322         if (balances[seller] >= _value && _value > 0) {
323             balances[seller] = safeSub(balances[seller], _value);
324             balances[_to] = safeAdd(balances[_to], _value);
325             Transfer(seller, _to, _value);
326 
327             tokensSold = safeAdd(tokensSold, _value);
328             totalSales = safeAdd(totalSales, 1);
329             Sell(seller, _to, _value);
330             return true;
331         } else return false;
332     }
333 
334     function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
335         return super.transfer(_to, _value);
336     }
337 
338     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
339         return super.transferFrom(_from, _to, _value);
340     }
341 
342     function lock() onlyOwner {
343         locked = true;
344     }
345 
346     function unlock() onlyOwner {
347         locked = false;
348     }
349 
350     function burn(uint256 _value) returns (bool) {
351         if (balances[msg.sender] >= _value && _value > 0) {
352             balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
353             totalSupply = safeSub(totalSupply, _value);
354             Transfer(msg.sender, 0x0, _value);
355             return true;
356         } else return false;
357     }
358 
359     /* Approve and then communicate the approved contract in a single tx */
360     function approveAndCall(address _spender, uint256 _value) {
361         TokenSpender spender = TokenSpender(_spender);
362         if (approve(_spender, _value)) {
363             spender.receiveApproval(msg.sender, _value);
364         }
365     }
366 }
367 
368 /**
369  * In this presale We assume that ETH rate is 320 USD/ETH
370  */
371 contract BsPresale is SafeMath, Ownable, Pausable {
372 
373     struct Backer {
374         uint256 weiReceived; // Amount of wei given by backer
375         uint256 tokensSent;  // Amount of tokens received in return to the given amount of ETH.
376     }
377 
378     // TODO rename to buyers.
379     mapping(address => Backer) public backers; // backers indexed by their ETH address
380 
381     // (buyerEthAddr => (unixTs => tokensSold))
382     mapping (address => mapping (uint256 => uint256)) public externalSales;
383 
384     BsToken public token;           // Token contract reference.
385     address public beneficiary;     // Address that will receive ETH raised during this presale.
386     address public notifier;        // Address that can this presale about changed external conditions.
387 
388     uint256 public usdPerEth;
389     uint256 public usdPerEthMin = 200; // Lowest boundary of USD/ETH rate
390     uint256 public usdPerEthMax = 500; // Highest boundary of USD/ETH rate
391 
392     struct UsdPerEthLog {
393         uint256 rate;
394         uint256 time;
395         address changedBy;
396     }
397 
398     UsdPerEthLog[] public usdPerEthLog; // History of used rates of USD/ETH
399 
400     uint256 public minInvestCents = 1; // Because 1 token = 1 cent.
401     uint256 public tokensPerCents           = 1 * 1e18;    // Ordinary price is 1 token per 1 USD cent.
402     uint256 public tokensPerCents_gte5kUsd  = 1.15 * 1e18; // + 15% bonus during presale if >= 5k USD.
403     uint256 public tokensPerCents_gte50kUsd = 1.25 * 1e18; // + 25% bonus for contribution >= 50k USD during presale.
404     uint256 public amount5kUsdInCents  =  5 * 1000 * 100;  //  5k USD in cents.
405     uint256 public amount50kUsdInCents = 50 * 1000 * 100;  // 50k USD in cents.
406     uint256 public maxCapInCents       = 15 * 1e6 * 100;   // 15m USD in cents.
407 
408     // TODO do we have some amount of privately raised money at start of presale?
409     uint256 public totalWeiReceived = 0;   // Total amount of wei received during this presale smart contract.
410     uint256 public totalInCents = 41688175;       // Total amount of USD raised during this presale including (wei -> USD) + (external USD).
411     uint256 public totalTokensSold = 8714901250000000000000000;        // Total amount of tokens sold during this presale.
412     uint256 public totalEthSales = 134;          // Total amount of ETH contributions during this presale.
413     uint256 public totalExternalSales = 0;     // Total amount of external contributions (USD, BTC, etc.) during this presale.
414 
415     uint256 public startTime = 1504526400; // 2017-09-04 12:00:00Z
416     uint256 public endTime   = 1509451200; // 2017-10-31 12:00:00Z
417     uint256 public finalizedTime = 0;      // Unix timestamp when finalize() was called.
418 
419     bool public saleEnabled = false;       // if true, then contract will not sell tokens on payment received
420 
421     event BeneficiaryChanged(address indexed _oldAddress, address indexed _newAddress);
422     event NotifierChanged(address indexed _oldAddress, address indexed _newAddress);
423     event UsdPerEthChanged(uint256 _oldRate, uint256 _newRate);
424 
425     event EthReceived(address _buyer, uint256 _amountInWei);
426     event ExternalSale(address _buyer, uint256 _amountInUsd, uint256 _tokensSold, uint256 _unixTs);
427 
428     modifier respectTimeFrame() {
429         if (!isSaleOn()) throw;
430         _;
431     }
432 
433     modifier canNotify() {
434         if (msg.sender != owner && msg.sender != notifier) throw;
435         _;
436     }
437 
438     function BsPresale(address _token, address _beneficiary, uint256 _usdPerEth) {
439         token = BsToken(_token);
440 
441         owner = msg.sender;
442         notifier = 0x73E5B12017A141d41c1a14FdaB43a54A4f9BD490;
443         beneficiary = _beneficiary;
444 
445         setUsdPerEth(_usdPerEth);
446     }
447 
448     // Override this method to mock current time.
449     function getNow() constant returns (uint256) {
450         return now;
451     }
452 
453     function setSaleEnabled(bool _enabled) onlyOwner {
454         saleEnabled = _enabled;
455     }
456 
457     function setBeneficiary(address _beneficiary) onlyOwner {
458         BeneficiaryChanged(beneficiary, _beneficiary);
459         beneficiary = _beneficiary;
460     }
461 
462     function setNotifier(address _notifier) onlyOwner {
463         NotifierChanged(notifier, _notifier);
464         notifier = _notifier;
465     }
466 
467     function setUsdPerEth(uint256 _usdPerEth) canNotify {
468         if (_usdPerEth < usdPerEthMin || _usdPerEth > usdPerEthMax) throw;
469 
470         UsdPerEthChanged(usdPerEth, _usdPerEth);
471         usdPerEth = _usdPerEth;
472         usdPerEthLog.push(UsdPerEthLog({ rate: usdPerEth, time: getNow(), changedBy: msg.sender }));
473     }
474 
475     function usdPerEthLogSize() constant returns (uint256) {
476         return usdPerEthLog.length;
477     }
478 
479     /*
480      * The fallback function corresponds to a donation in ETH
481      */
482     function() payable {
483         if (saleEnabled) sellTokensForEth(msg.sender, msg.value);
484     }
485 
486     /// We don't need to use respectTimeFrame modifier here as we do for ETH contributions,
487     /// because foreign transaction can came with a delay thus it's a problem of outer server to manage time.
488     /// @param _buyer - ETH address of buyer where we will send tokens to.
489     function externalSale(address _buyer, uint256 _amountInUsd, uint256 _tokensSoldNoDecimals, uint256 _unixTs)
490             ifNotPaused canNotify {
491 
492         if (_buyer == 0 || _amountInUsd == 0 || _tokensSoldNoDecimals == 0) throw;
493         if (_unixTs == 0 || _unixTs > getNow()) throw; // Cannot accept timestamp of a sale from the future.
494 
495         // If this foreign transaction has been already processed in this contract.
496         if (externalSales[_buyer][_unixTs] > 0) throw;
497 
498         totalInCents = safeAdd(totalInCents, safeMul(_amountInUsd, 100));
499         if (totalInCents > maxCapInCents) throw; // If max cap reached.
500 
501         uint256 tokensSold = safeMul(_tokensSoldNoDecimals, 1e18);
502         if (!token.sell(_buyer, tokensSold)) throw; // Transfer tokens to buyer.
503 
504         totalTokensSold = safeAdd(totalTokensSold, tokensSold);
505         totalExternalSales++;
506 
507         externalSales[_buyer][_unixTs] = tokensSold;
508         ExternalSale(_buyer, _amountInUsd, tokensSold, _unixTs);
509     }
510 
511     function sellTokensForEth(address _buyer, uint256 _amountInWei) internal ifNotPaused respectTimeFrame {
512 
513         uint256 amountInCents = weiToCents(_amountInWei);
514         if (amountInCents < minInvestCents) throw;
515 
516         totalInCents = safeAdd(totalInCents, amountInCents);
517         if (totalInCents > maxCapInCents) throw; // If max cap reached.
518 
519         uint256 tokensSold = centsToTokens(amountInCents);
520         if (!token.sell(_buyer, tokensSold)) throw; // Transfer tokens to buyer.
521 
522         totalWeiReceived = safeAdd(totalWeiReceived, _amountInWei);
523         totalTokensSold = safeAdd(totalTokensSold, tokensSold);
524         totalEthSales++;
525 
526         Backer backer = backers[_buyer];
527         backer.tokensSent = safeAdd(backer.tokensSent, tokensSold);
528         backer.weiReceived = safeAdd(backer.weiReceived, _amountInWei);  // Update the total wei collected during the crowdfunding for this backer
529 
530         EthReceived(_buyer, _amountInWei);
531     }
532 
533     function totalSales() constant returns (uint256) {
534         return safeAdd(totalEthSales, totalExternalSales);
535     }
536 
537     function weiToCents(uint256 _amountInWei) constant returns (uint256) {
538         return safeDiv(safeMul(_amountInWei, usdPerEth * 100), 1 ether);
539     }
540 
541     function centsToTokens(uint256 _amountInCents) constant returns (uint256) {
542         uint256 rate = tokensPerCents;
543         // Give -25% discount if buyer sent more than 50k USD.
544         if (_amountInCents >= amount50kUsdInCents) {
545             rate = tokensPerCents_gte50kUsd;
546         } else if (_amountInCents >= amount5kUsdInCents) {
547             rate = tokensPerCents_gte5kUsd;
548         }
549         return safeMul(_amountInCents, rate);
550     }
551 
552     function isMaxCapReached() constant returns (bool) {
553         return totalInCents >= maxCapInCents;
554     }
555 
556     function isSaleOn() constant returns (bool) {
557         uint256 _now = getNow();
558         return startTime <= _now && _now <= endTime;
559     }
560 
561     function isSaleOver() constant returns (bool) {
562         return getNow() > endTime;
563     }
564 
565     function isFinalized() constant returns (bool) {
566         return finalizedTime > 0;
567     }
568 
569     /*
570     * Finalize the presale. Raised money can be sent to beneficiary only if presale hit end time or max cap (15m USD).
571     */
572     function finalize() onlyOwner {
573 
574         // Cannot finalise before end day of presale until max cap is reached.
575         if (!isMaxCapReached() && !isSaleOver()) throw;
576 
577         beneficiary.transfer(this.balance);
578 
579         finalizedTime = getNow();
580     }
581 }
582 
583 contract SnovWhitelist is BsPresale {
584 
585     function SnovWhitelist() BsPresale(
586         0xBDC5bAC39Dbe132B1E030e898aE3830017D7d969,
587         0x983F64a550CD9D733f2829275f94B1A3728Fe888,
588         310
589     ) {}
590 }