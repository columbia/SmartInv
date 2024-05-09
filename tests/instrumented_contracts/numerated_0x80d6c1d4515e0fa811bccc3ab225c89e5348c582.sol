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
286     uint public dateMainStart = 1529053200; // 15-JUN-2018 09:00 UTC
287     uint public dateMainEnd   = 1529658000; // 22-JUN-2018 09:00 UTC
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
319     // where are we?
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
357 
358     uint public tokensPerEth = 15000;
359 
360     uint public constant MINIMUM_CONTRIBUTION = 0.2 ether;
361     uint public constant MAXIMUM_FIRST_DAY_CONTRIBUTION = 1.5 ether;
362 
363     uint public constant TOKEN_MAIN_CAP = 50000000 * E18;
364 
365     bool public tokensTradeable;
366 
367     // whitelisting
368 
369     mapping(address => bool) public whitelist;
370     uint public numberWhitelisted;
371 
372     // track main sale
373 
374     uint public tokensMain;
375     mapping(address => uint) public balancesMain;
376 
377     uint public totalEthContributed;
378     mapping(address => uint) public ethContributed;
379 
380     // tracking tokens minted
381 
382     uint public tokensMinted;
383     mapping(address => uint) public balancesMinted;
384     mapping(address => mapping(uint => uint)) public balancesMintedByType;
385 
386     // migration variable
387 
388     bool public isMigrationPhaseOpen;
389 
390     // Events ---------------------------------------------
391 
392     event UpdatedTokensPerEth(uint tokensPerEth);
393     event Whitelisted(address indexed account, uint countWhitelisted);
394     event TokensMinted(uint indexed mintType, address indexed account, uint tokens, uint term);
395     event RegisterContribution(address indexed account, uint tokensIssued, uint ethContributed, uint ethReturned);
396     event TokenExchangeRequested(address indexed account, uint tokens);
397 
398     // Basic Functions ------------------------------------
399 
400     constructor() public {}
401 
402     function () public payable {
403         buyTokens();
404     }
405 
406     // Information functions
407 
408 
409     function availableToMint() public view returns (uint) {
410         return MAX_TOTAL_TOKEN_SUPPLY.sub(TOKEN_MAIN_CAP).sub(tokensMinted);
411     }
412 
413     function firstDayTokenLimit() public view returns (uint) {
414         return ethToTokens(MAXIMUM_FIRST_DAY_CONTRIBUTION);
415     }
416 
417     function ethToTokens(uint _eth) public view returns (uint tokens) {
418         tokens = _eth.mul(tokensPerEth);
419     }
420 
421     function tokensToEth(uint _tokens) public view returns (uint eth) {
422         eth = _tokens / tokensPerEth;
423     }
424 
425     // Admin functions
426 
427     function addToWhitelist(address _account) public onlyAdmin {
428         pWhitelist(_account);
429     }
430 
431     function addToWhitelistMultiple(address[] _addresses) public onlyAdmin {
432         for (uint i; i < _addresses.length; i++) {
433             pWhitelist(_addresses[i]);
434         }
435     }
436 
437     function pWhitelist(address _account) internal {
438         if (whitelist[_account]) return;
439         whitelist[_account] = true;
440         numberWhitelisted = numberWhitelisted.add(1);
441         emit Whitelisted(_account, numberWhitelisted);
442     }
443 
444     // Owner functions ------------------------------------
445 
446     function updateTokensPerEth(uint _tokens_per_eth) public onlyOwner {
447         require(now < dateMainStart);
448         tokensPerEth = _tokens_per_eth;
449         emit UpdatedTokensPerEth(tokensPerEth);
450     }
451 
452     // Only owner can make tokens tradable at any time, or if the date is
453     // greater than the end of the mainsale date plus 20 weeks, allow
454     // any caller to make tokensTradeable.
455 
456     function makeTradeable() public {
457         require(msg.sender == owner || now > dateMainEnd + 20 weeks);
458         tokensTradeable = true;
459     }
460 
461     function openMigrationPhase() public onlyOwner {
462         require(now > dateMainEnd);
463         isMigrationPhaseOpen = true;
464     }
465 
466     // Token minting --------------------------------------
467 
468     function mintTokens(uint _mint_type, address _account, uint _tokens) public onlyOwner {
469         pMintTokens(_mint_type, _account, _tokens, 0);
470     }
471 
472     function mintTokensMultiple(uint _mint_type, address[] _accounts, uint[] _tokens) public onlyOwner {
473         require(_accounts.length == _tokens.length);
474         for (uint i; i < _accounts.length; i++) {
475             pMintTokens(_mint_type, _accounts[i], _tokens[i], 0);
476         }
477     }
478 
479     function mintTokensLocked(uint _mint_type, address _account, uint _tokens, uint _term) public onlyOwner {
480         pMintTokens(_mint_type, _account, _tokens, _term);
481     }
482 
483     function mintTokensLockedMultiple(uint _mint_type, address[] _accounts, uint[] _tokens, uint[] _terms) public onlyOwner {
484         require(_accounts.length == _tokens.length);
485         require(_accounts.length == _terms.length);
486         for (uint i; i < _accounts.length; i++) {
487             pMintTokens(_mint_type, _accounts[i], _tokens[i], _terms[i]);
488         }
489     }
490 
491     function pMintTokens(uint _mint_type, address _account, uint _tokens, uint _term) private {
492         require(whitelist[_account]);
493         require(_account != 0x0);
494         require(_tokens > 0);
495         require(_tokens <= availableToMint(), "not enough tokens available to mint");
496         require(_term == 0 || _term > now, "either without lock term, or lock term must be in the future");
497 
498         // register locked tokens (will throw if no slot is found)
499         if (_term > 0) registerLockedTokens(_account, _tokens, _term);
500 
501         // update
502         balances[_account] = balances[_account].add(_tokens);
503         balancesMinted[_account] = balancesMinted[_account].add(_tokens);
504         balancesMintedByType[_account][_mint_type] = balancesMintedByType[_account][_mint_type].add(_tokens);
505         tokensMinted = tokensMinted.add(_tokens);
506         tokensIssuedTotal = tokensIssuedTotal.add(_tokens);
507 
508         // log event
509         emit Transfer(0x0, _account, _tokens);
510         emit TokensMinted(_mint_type, _account, _tokens, _term);
511     }
512 
513     // Main sale ------------------------------------------
514 
515     function buyTokens() private {
516 
517         require(isMain());
518         require(msg.value >= MINIMUM_CONTRIBUTION);
519         require(whitelist[msg.sender]);
520 
521         uint tokens_available = TOKEN_MAIN_CAP.sub(tokensMain);
522 
523         // adjust tokens_available on first day, if necessary
524         if (isMainFirstDay()) {
525             uint tokens_available_first_day = firstDayTokenLimit().sub(balancesMain[msg.sender]);
526             if (tokens_available_first_day < tokens_available) {
527                 tokens_available = tokens_available_first_day;
528             }
529         }
530 
531         require (tokens_available > 0);
532 
533         uint tokens_requested = ethToTokens(msg.value);
534         uint tokens_issued = tokens_requested;
535 
536         uint eth_contributed = msg.value;
537         uint eth_returned;
538 
539         if (tokens_requested > tokens_available) {
540             tokens_issued = tokens_available;
541             eth_returned = tokensToEth(tokens_requested.sub(tokens_available));
542             eth_contributed = msg.value.sub(eth_returned);
543         }
544 
545         balances[msg.sender] = balances[msg.sender].add(tokens_issued);
546         balancesMain[msg.sender] = balancesMain[msg.sender].add(tokens_issued);
547         tokensMain = tokensMain.add(tokens_issued);
548         tokensIssuedTotal = tokensIssuedTotal.add(tokens_issued);
549 
550         ethContributed[msg.sender] = ethContributed[msg.sender].add(eth_contributed);
551         totalEthContributed = totalEthContributed.add(eth_contributed);
552 
553         // ether transfers
554         if (eth_returned > 0) msg.sender.transfer(eth_returned);
555         wallet.transfer(eth_contributed);
556 
557         // log
558         emit Transfer(0x0, msg.sender, tokens_issued);
559         emit RegisterContribution(msg.sender, tokens_issued, eth_contributed, eth_returned);
560     }
561 
562     // Token exchange / migration to new platform ---------
563 
564     function requestTokenExchangeMax() public {
565         requestTokenExchange(unlockedTokensInternal(msg.sender));
566     }
567 
568     function requestTokenExchange(uint _tokens) public {
569         require(isMigrationPhaseOpen);
570         require(_tokens > 0 && _tokens <= unlockedTokensInternal(msg.sender));
571         balances[msg.sender] = balances[msg.sender].sub(_tokens);
572         tokensIssuedTotal = tokensIssuedTotal.sub(_tokens);
573         emit Transfer(msg.sender, 0x0, _tokens);
574         emit TokenExchangeRequested(msg.sender, _tokens);
575     }
576 
577     // ERC20 functions -------------------
578 
579     /* Transfer out any accidentally sent ERC20 tokens */
580 
581     function transferAnyERC20Token(address _token_address, uint _amount) public onlyOwner returns (bool success) {
582         return ERC20Interface(_token_address).transfer(owner, _amount);
583     }
584 
585     /* Override "transfer" */
586 
587     function transfer(address _to, uint _amount) public returns (bool success) {
588         require(tokensTradeable);
589         require(_amount <= unlockedTokensInternal(msg.sender));
590         return super.transfer(_to, _amount);
591     }
592 
593     /* Override "transferFrom" */
594 
595     function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
596         require(tokensTradeable);
597         require(_amount <= unlockedTokensInternal(_from));
598         return super.transferFrom(_from, _to, _amount);
599     }
600 
601     /* Multiple token transfers from one address to save gas */
602 
603     function transferMultiple(address[] _addresses, uint[] _amounts) external {
604         require(_addresses.length <= 100);
605         require(_addresses.length == _amounts.length);
606 
607         // do the transfers
608         for (uint j; j < _addresses.length; j++) {
609             transfer(_addresses[j], _amounts[j]);
610         }
611 
612     }
613 
614 }