1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // Fantom Foundation FTM token public sale contract
6 //
7 // For details, please visit: http://fantom.foundation
8 //
9 //
10 // written by Alex Kampa - ak@sikoba.com
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 //
17 // SafeMath
18 //
19 // ----------------------------------------------------------------------------
20 
21 library SafeMath {
22 
23     function add(uint a, uint b) internal pure returns (uint c) {
24         c = a + b;
25         require(c >= a);
26     }
27 
28     function sub(uint a, uint b) internal pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32 
33     function mul(uint a, uint b) internal pure returns (uint c) {
34         c = a * b;
35         require(a == 0 || c / a == b);
36     }
37 
38 }
39 
40 // ----------------------------------------------------------------------------
41 //
42 // Owned
43 //
44 // ----------------------------------------------------------------------------
45 
46 contract Owned {
47 
48     address public owner;
49     address public newOwner;
50 
51     mapping(address => bool) public isAdmin;
52 
53     event OwnershipTransferProposed(address indexed _from, address indexed _to);
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55     event AdminChange(address indexed _admin, bool _status);
56 
57     modifier onlyOwner {require(msg.sender == owner); _;}
58     modifier onlyAdmin {require(isAdmin[msg.sender]); _;}
59 
60     constructor() public {
61         owner = msg.sender;
62         isAdmin[owner] = true;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         require(_newOwner != address(0x0));
67         emit OwnershipTransferProposed(owner, _newOwner);
68         newOwner = _newOwner;
69     }
70 
71     function acceptOwnership() public {
72         require(msg.sender == newOwner);
73         emit OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 
77     function addAdmin(address _a) public onlyOwner {
78         require(isAdmin[_a] == false);
79         isAdmin[_a] = true;
80         emit AdminChange(_a, true);
81     }
82 
83     function removeAdmin(address _a) public onlyOwner {
84         require(isAdmin[_a] == true);
85         isAdmin[_a] = false;
86         emit AdminChange(_a, false);
87     }
88 
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 //
94 // Wallet
95 //
96 // ----------------------------------------------------------------------------
97 
98 contract Wallet is Owned {
99 
100     address public wallet;
101 
102     event WalletUpdated(address newWallet);
103 
104     constructor() public {
105         wallet = owner;
106     }
107 
108     function setWallet(address _wallet) public onlyOwner {
109         require(_wallet != address(0x0));
110         wallet = _wallet;
111         emit WalletUpdated(_wallet);
112     }
113 
114 }
115 
116 
117 // ----------------------------------------------------------------------------
118 //
119 // ERC20Interface
120 //
121 // ----------------------------------------------------------------------------
122 
123 contract ERC20Interface {
124 
125     event Transfer(address indexed _from, address indexed _to, uint _value);
126     event Approval(address indexed _owner, address indexed _spender, uint _value);
127 
128     function totalSupply() public view returns (uint);
129     function balanceOf(address _owner) public view returns (uint balance);
130     function transfer(address _to, uint _value) public returns (bool success);
131     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
132     function approve(address _spender, uint _value) public returns (bool success);
133     function allowance(address _owner, address _spender) public view returns (uint remaining);
134 
135 }
136 
137 
138 // ----------------------------------------------------------------------------
139 //
140 // ERC Token Standard #20
141 //
142 // ----------------------------------------------------------------------------
143 
144 contract ERC20Token is ERC20Interface, Owned {
145 
146     using SafeMath for uint;
147 
148     uint public tokensIssuedTotal;
149     mapping(address => uint) balances;
150     mapping(address => mapping (address => uint)) allowed;
151 
152     function totalSupply() public view returns (uint) {
153         return tokensIssuedTotal;
154     }
155     // Includes BOTH locked AND unlocked tokens
156 
157     function balanceOf(address _owner) public view returns (uint) {
158         return balances[_owner];
159     }
160 
161     function transfer(address _to, uint _amount) public returns (bool) {
162         require(_to != 0x0);
163         balances[msg.sender] = balances[msg.sender].sub(_amount);
164         balances[_to] = balances[_to].add(_amount);
165         emit Transfer(msg.sender, _to, _amount);
166         return true;
167     }
168 
169     function approve(address _spender, uint _amount) public returns (bool) {
170         allowed[msg.sender][_spender] = _amount;
171         emit Approval(msg.sender, _spender, _amount);
172         return true;
173     }
174 
175     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
176         require(_to != 0x0);
177         balances[_from] = balances[_from].sub(_amount);
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
179         balances[_to] = balances[_to].add(_amount);
180         emit Transfer(_from, _to, _amount);
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) public view returns (uint) {
185         return allowed[_owner][_spender];
186     }
187 
188 }
189 
190 
191 // ----------------------------------------------------------------------------
192 //
193 // LockSlots
194 //
195 // ----------------------------------------------------------------------------
196 
197 contract LockSlots is ERC20Token {
198 
199     using SafeMath for uint;
200 
201     uint public constant LOCK_SLOTS = 5;
202     mapping(address => uint[LOCK_SLOTS]) public lockTerm;
203     mapping(address => uint[LOCK_SLOTS]) public lockAmnt;
204     mapping(address => bool) public mayHaveLockedTokens;
205 
206     event RegisteredLockedTokens(address indexed account, uint indexed idx, uint tokens, uint term);
207 
208     function registerLockedTokens(address _account, uint _tokens, uint _term) internal returns (uint idx) {
209         require(_term > now, "lock term must be in the future");
210 
211         // find a slot (clean up while doing this)
212         // use either the existing slot with the exact same term,
213         // of which there can be at most one, or the first empty slot
214         idx = 9999;
215         uint[LOCK_SLOTS] storage term = lockTerm[_account];
216         uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
217         for (uint i; i < LOCK_SLOTS; i++) {
218             if (term[i] < now) {
219                 term[i] = 0;
220                 amnt[i] = 0;
221                 if (idx == 9999) idx = i;
222             }
223             if (term[i] == _term) idx = i;
224         }
225 
226         // fail if no slot was found
227         require(idx != 9999, "registerLockedTokens: no available slot found");
228 
229         // register locked tokens
230         if (term[idx] == 0) term[idx] = _term;
231         amnt[idx] = amnt[idx].add(_tokens);
232         mayHaveLockedTokens[_account] = true;
233         emit RegisteredLockedTokens(_account, idx, _tokens, _term);
234     }
235 
236     // public view functions
237 
238     function lockedTokens(address _account) public view returns (uint) {
239         if (!mayHaveLockedTokens[_account]) return 0;
240         return pNumberOfLockedTokens(_account);
241     }
242 
243     function unlockedTokens(address _account) public view returns (uint) {
244         return balances[_account].sub(lockedTokens(_account));
245     }
246 
247     function isAvailableLockSlot(address _account, uint _term) public view returns (bool) {
248         if (!mayHaveLockedTokens[_account]) return true;
249         if (_term < now) return true;
250         uint[LOCK_SLOTS] storage term = lockTerm[_account];
251         for (uint i; i < LOCK_SLOTS; i++) {
252             if (term[i] < now || term[i] == _term) return true;
253         }
254         return false;
255     }
256 
257     // internal and private functions
258 
259     function unlockedTokensInternal(address _account) internal returns (uint) {
260         // updates mayHaveLockedTokens if necessary
261         if (!mayHaveLockedTokens[_account]) return balances[_account];
262         uint locked = pNumberOfLockedTokens(_account);
263         if (locked == 0) mayHaveLockedTokens[_account] = false;
264         return balances[_account].sub(locked);
265     }
266 
267     function pNumberOfLockedTokens(address _account) private view returns (uint locked) {
268         uint[LOCK_SLOTS] storage term = lockTerm[_account];
269         uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
270         for (uint i; i < LOCK_SLOTS; i++) {
271             if (term[i] >= now) locked = locked.add(amnt[i]);
272         }
273     }
274 
275 }
276 
277 
278 // ----------------------------------------------------------------------------
279 //
280 // FantomIcoDates
281 //
282 // ----------------------------------------------------------------------------
283 
284 contract FantomIcoDates is Owned {
285 
286     uint public dateMainStart = 1529053200; // 15-JUN-2018 09:00 GMT + 0
287     uint public dateMainEnd   = 1529658000; // 22-JUN-2018 09:00 GMT + 0
288 
289     uint public constant DATE_LIMIT = 1529658000 + 180 days;
290 
291     event IcoDateUpdated(uint id, uint unixts);
292 
293     // check dates
294 
295     modifier checkDateOrder {
296       _ ;
297       require ( dateMainStart < dateMainEnd ) ;
298       require ( dateMainEnd < DATE_LIMIT ) ;
299     }
300 
301     constructor() public checkDateOrder() {
302         require(now < dateMainStart);
303     }
304 
305     // set ico dates
306 
307     function setDateMainStart(uint _unixts) public onlyOwner checkDateOrder {
308         require(now < _unixts && now < dateMainStart);
309         dateMainStart = _unixts;
310         emit IcoDateUpdated(1, _unixts);
311     }
312 
313     function setDateMainEnd(uint _unixts) public onlyOwner checkDateOrder {
314         require(now < _unixts && now < dateMainEnd);
315         dateMainEnd = _unixts;
316         emit IcoDateUpdated(2, _unixts);
317     }
318 
319     // where are we? Passed first day or not?
320 
321     function isMainFirstDay() public view returns (bool) {
322         if (now > dateMainStart && now <= dateMainStart + 1 days) return true;
323         return false;
324     }
325 
326     function isMain() public view returns (bool) {
327         if (now > dateMainStart && now < dateMainEnd) return true;
328         return false;
329     }
330 
331 }
332 
333 // ----------------------------------------------------------------------------
334 //
335 // Fantom public token sale
336 //
337 // ----------------------------------------------------------------------------
338 
339 contract FantomToken is ERC20Token, Wallet, LockSlots, FantomIcoDates {
340 
341     // Utility variable
342 
343     uint constant E18 = 10**18;
344 
345     // Basic token data
346 
347     string public constant name = "Fantom Token";
348     string public constant symbol = "FTM";
349     uint8 public constant decimals = 18;
350 
351     // Token number of possible tokens in existance
352 
353     uint public constant MAX_TOTAL_TOKEN_SUPPLY = 3175000000 * E18;
354 
355 
356     // crowdsale parameters
357     // Opening ETH Rate: USD$463.28
358     // Therefore, 1 ETH = 11582 FTM
359 
360 
361     uint public tokensPerEth = 11582;
362 
363     // USD$2,000,000/463.28 = 4317.043668 ether
364     // 4317.043668 ether/2551 addresses = 1.692294656 ether per address for the first 24 hours
365 
366     uint public constant MINIMUM_CONTRIBUTION = 0.2 ether;
367     uint public constant MAXIMUM_FIRST_DAY_CONTRIBUTION = 1.692294656 ether;
368 
369     uint public constant TOKEN_MAIN_CAP = 50000000 * E18;
370 
371     bool public tokensTradeable;
372 
373     // whitelisting
374 
375     mapping(address => bool) public whitelist;
376     uint public numberWhitelisted;
377 
378     // track main sale
379 
380     uint public tokensMain;
381     mapping(address => uint) public balancesMain;
382 
383     uint public totalEthContributed;
384     mapping(address => uint) public ethContributed;
385 
386     // tracking tokens minted
387 
388     uint public tokensMinted;
389     mapping(address => uint) public balancesMinted;
390     mapping(address => mapping(uint => uint)) public balancesMintedByType;
391 
392     // migration variable
393 
394     bool public isMigrationPhaseOpen;
395 
396     // Events ---------------------------------------------
397 
398     event UpdatedTokensPerEth(uint tokensPerEth);
399     event Whitelisted(address indexed account, uint countWhitelisted);
400     event TokensMinted(uint indexed mintType, address indexed account, uint tokens, uint term);
401     event RegisterContribution(address indexed account, uint tokensIssued, uint ethContributed, uint ethReturned);
402     event TokenExchangeRequested(address indexed account, uint tokens);
403 
404     // Basic Functions ------------------------------------
405 
406     constructor() public {}
407 
408     function () public payable {
409         buyTokens();
410     }
411 
412     // Information functions
413 
414 
415     function availableToMint() public view returns (uint) {
416         return MAX_TOTAL_TOKEN_SUPPLY.sub(TOKEN_MAIN_CAP).sub(tokensMinted);
417     }
418 
419     function firstDayTokenLimit() public view returns (uint) {
420         return ethToTokens(MAXIMUM_FIRST_DAY_CONTRIBUTION);
421     }
422 
423     function ethToTokens(uint _eth) public view returns (uint tokens) {
424         tokens = _eth.mul(tokensPerEth);
425     }
426 
427     function tokensToEth(uint _tokens) public view returns (uint eth) {
428         eth = _tokens / tokensPerEth;
429     }
430 
431     // Admin functions
432 
433     function addToWhitelist(address _account) public onlyAdmin {
434         pWhitelist(_account);
435     }
436 
437     function addToWhitelistMultiple(address[] _addresses) public onlyAdmin {
438         for (uint i; i < _addresses.length; i++) {
439             pWhitelist(_addresses[i]);
440         }
441     }
442 
443     function pWhitelist(address _account) internal {
444         if (whitelist[_account]) return;
445         whitelist[_account] = true;
446         numberWhitelisted = numberWhitelisted.add(1);
447         emit Whitelisted(_account, numberWhitelisted);
448     }
449 
450     // Owner functions ------------------------------------
451 
452     function updateTokensPerEth(uint _tokens_per_eth) public onlyOwner {
453         require(now < dateMainStart);
454         tokensPerEth = _tokens_per_eth;
455         emit UpdatedTokensPerEth(tokensPerEth);
456     }
457 
458     // Only owner can make tokens tradable at any time, or if the date is
459     // greater than the end of the mainsale date plus 20 weeks, allow
460     // any caller to make tokensTradeable.
461 
462     function makeTradeable() public {
463         require(msg.sender == owner || now > dateMainEnd + 20 weeks);
464         tokensTradeable = true;
465     }
466 
467     function openMigrationPhase() public onlyOwner {
468         require(now > dateMainEnd);
469         isMigrationPhaseOpen = true;
470     }
471 
472     // Token minting --------------------------------------
473 
474     function mintTokens(uint _mint_type, address _account, uint _tokens) public onlyOwner {
475         pMintTokens(_mint_type, _account, _tokens, 0);
476     }
477 
478     function mintTokensMultiple(uint _mint_type, address[] _accounts, uint[] _tokens) public onlyOwner {
479         require(_accounts.length == _tokens.length);
480         for (uint i; i < _accounts.length; i++) {
481             pMintTokens(_mint_type, _accounts[i], _tokens[i], 0);
482         }
483     }
484 
485     function mintTokensLocked(uint _mint_type, address _account, uint _tokens, uint _term) public onlyOwner {
486         pMintTokens(_mint_type, _account, _tokens, _term);
487     }
488 
489     function mintTokensLockedMultiple(uint _mint_type, address[] _accounts, uint[] _tokens, uint[] _terms) public onlyOwner {
490         require(_accounts.length == _tokens.length);
491         require(_accounts.length == _terms.length);
492         for (uint i; i < _accounts.length; i++) {
493             pMintTokens(_mint_type, _accounts[i], _tokens[i], _terms[i]);
494         }
495     }
496 
497     function pMintTokens(uint _mint_type, address _account, uint _tokens, uint _term) private {
498         require(whitelist[_account]);
499         require(_account != 0x0);
500         require(_tokens > 0);
501         require(_tokens <= availableToMint(), "not enough tokens available to mint");
502         require(_term == 0 || _term > now, "either without lock term, or lock term must be in the future");
503 
504         // register locked tokens (will throw if no slot is found)
505         if (_term > 0) registerLockedTokens(_account, _tokens, _term);
506 
507         // update
508         balances[_account] = balances[_account].add(_tokens);
509         balancesMinted[_account] = balancesMinted[_account].add(_tokens);
510         balancesMintedByType[_account][_mint_type] = balancesMintedByType[_account][_mint_type].add(_tokens);
511         tokensMinted = tokensMinted.add(_tokens);
512         tokensIssuedTotal = tokensIssuedTotal.add(_tokens);
513 
514         // log event
515         emit Transfer(0x0, _account, _tokens);
516         emit TokensMinted(_mint_type, _account, _tokens, _term);
517     }
518 
519     // Main sale ------------------------------------------
520 
521     function buyTokens() private {
522 
523         require(isMain());
524         require(msg.value >= MINIMUM_CONTRIBUTION);
525         require(whitelist[msg.sender]);
526 
527         uint tokens_available = TOKEN_MAIN_CAP.sub(tokensMain);
528 
529         // adjust tokens_available on first day, if necessary
530         if (isMainFirstDay()) {
531             uint tokens_available_first_day = firstDayTokenLimit().sub(balancesMain[msg.sender]);
532             if (tokens_available_first_day < tokens_available) {
533                 tokens_available = tokens_available_first_day;
534             }
535         }
536 
537         require (tokens_available > 0);
538 
539         uint tokens_requested = ethToTokens(msg.value);
540         uint tokens_issued = tokens_requested;
541 
542         uint eth_contributed = msg.value;
543         uint eth_returned;
544 
545         if (tokens_requested > tokens_available) {
546             tokens_issued = tokens_available;
547             eth_returned = tokensToEth(tokens_requested.sub(tokens_available));
548             eth_contributed = msg.value.sub(eth_returned);
549         }
550 
551         balances[msg.sender] = balances[msg.sender].add(tokens_issued);
552         balancesMain[msg.sender] = balancesMain[msg.sender].add(tokens_issued);
553         tokensMain = tokensMain.add(tokens_issued);
554         tokensIssuedTotal = tokensIssuedTotal.add(tokens_issued);
555 
556         ethContributed[msg.sender] = ethContributed[msg.sender].add(eth_contributed);
557         totalEthContributed = totalEthContributed.add(eth_contributed);
558 
559         // ether transfers
560         if (eth_returned > 0) msg.sender.transfer(eth_returned);
561         wallet.transfer(eth_contributed);
562 
563         // log
564         emit Transfer(0x0, msg.sender, tokens_issued);
565         emit RegisterContribution(msg.sender, tokens_issued, eth_contributed, eth_returned);
566     }
567 
568     // Token exchange / migration to new platform ---------
569 
570     function requestTokenExchangeMax() public {
571         requestTokenExchange(unlockedTokensInternal(msg.sender));
572     }
573 
574     function requestTokenExchange(uint _tokens) public {
575         require(isMigrationPhaseOpen);
576         require(_tokens > 0 && _tokens <= unlockedTokensInternal(msg.sender));
577         balances[msg.sender] = balances[msg.sender].sub(_tokens);
578         tokensIssuedTotal = tokensIssuedTotal.sub(_tokens);
579         emit Transfer(msg.sender, 0x0, _tokens);
580         emit TokenExchangeRequested(msg.sender, _tokens);
581     }
582 
583     // ERC20 functions -------------------
584 
585     /* Transfer out any accidentally sent ERC20 tokens */
586 
587     function transferAnyERC20Token(address _token_address, uint _amount) public onlyOwner returns (bool success) {
588         return ERC20Interface(_token_address).transfer(owner, _amount);
589     }
590 
591     /* Override "transfer" */
592 
593     function transfer(address _to, uint _amount) public returns (bool success) {
594         require(tokensTradeable);
595         require(_amount <= unlockedTokensInternal(msg.sender));
596         return super.transfer(_to, _amount);
597     }
598 
599     /* Override "transferFrom" */
600 
601     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
602         require(tokensTradeable);
603         require(_amount <= unlockedTokensInternal(_from));
604         return super.transferFrom(_from, _to, _amount);
605     }
606 
607     /* Multiple token transfers from one address to save gas */
608 
609     function transferMultiple(address[] _addresses, uint[] _amounts) external {
610         require(_addresses.length <= 100);
611         require(_addresses.length == _amounts.length);
612 
613         // do the transfers
614         for (uint j; j < _addresses.length; j++) {
615             transfer(_addresses[j], _amounts[j]);
616         }
617 
618     }
619 
620 }