1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // ZAB token public sale contract
6 //
7 // For details, please visit: http://ZAB.io
8 //
9 //
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 //
15 // SafeMath
16 //
17 // ----------------------------------------------------------------------------
18 
19 library SafeMath {
20 
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25 
26     function sub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30 
31     function mul(uint a, uint b) internal pure returns (uint c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35 
36 }
37 
38 // ----------------------------------------------------------------------------
39 //
40 // Owned
41 //
42 // ----------------------------------------------------------------------------
43 
44 contract Owned {
45 
46     address public owner;
47     address public newOwner;
48 
49     mapping(address => bool) public isAdmin;
50 
51     event OwnershipTransferProposed(address indexed _from, address indexed _to);
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53     event AdminChange(address indexed _admin, bool _status);
54 
55     modifier onlyOwner {require(msg.sender == owner); _;}
56     modifier onlyAdmin {require(isAdmin[msg.sender]); _;}
57 
58     constructor() public {
59         owner = msg.sender;
60         isAdmin[owner] = true;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         require(_newOwner != address(0x0));
65         emit OwnershipTransferProposed(owner, _newOwner);
66         newOwner = _newOwner;
67     }
68 
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 
75     function addAdmin(address _a) public onlyOwner {
76         require(isAdmin[_a] == false);
77         isAdmin[_a] = true;
78         emit AdminChange(_a, true);
79     }
80 
81     function removeAdmin(address _a) public onlyOwner {
82         require(isAdmin[_a] == true);
83         isAdmin[_a] = false;
84         emit AdminChange(_a, false);
85     }
86 
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 //
92 // Wallet
93 //
94 // ----------------------------------------------------------------------------
95 
96 contract Wallet is Owned {
97 
98     address public wallet;
99 
100     event WalletUpdated(address newWallet);
101 
102     constructor() public {
103         wallet = owner;
104     }
105 
106     function setWallet(address _wallet) public onlyOwner {
107         require(_wallet != address(0x0));
108         wallet = _wallet;
109         emit WalletUpdated(_wallet);
110     }
111 
112 }
113 
114 
115 // ----------------------------------------------------------------------------
116 //
117 // ERC20Interface
118 //
119 // ----------------------------------------------------------------------------
120 
121 contract ERC20Interface {
122 
123     event Transfer(address indexed _from, address indexed _to, uint _value);
124     event Approval(address indexed _owner, address indexed _spender, uint _value);
125 
126     function totalSupply() public view returns (uint);
127     function balanceOf(address _owner) public view returns (uint balance);
128     function transfer(address _to, uint _value) public returns (bool success);
129     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
130     function approve(address _spender, uint _value) public returns (bool success);
131     function allowance(address _owner, address _spender) public view returns (uint remaining);
132 
133 }
134 
135 
136 // ----------------------------------------------------------------------------
137 //
138 // ERC Token Standard #20
139 //
140 // ----------------------------------------------------------------------------
141 
142 contract ERC20Token is ERC20Interface, Owned {
143 
144     using SafeMath for uint;
145 
146     uint public tokensIssuedTotal;
147     mapping(address => uint) balances;
148     mapping(address => mapping (address => uint)) allowed;
149 
150     function totalSupply() public view returns (uint) {
151         return tokensIssuedTotal;
152     }
153     // Includes BOTH locked AND unlocked tokens
154 
155     function balanceOf(address _owner) public view returns (uint) {
156         return balances[_owner];
157     }
158 
159     function transfer(address _to, uint _amount) public returns (bool) {
160         require(_to != 0x0);
161         balances[msg.sender] = balances[msg.sender].sub(_amount);
162         balances[_to] = balances[_to].add(_amount);
163         emit Transfer(msg.sender, _to, _amount);
164         return true;
165     }
166 
167     function approve(address _spender, uint _amount) public returns (bool) {
168         allowed[msg.sender][_spender] = _amount;
169         emit Approval(msg.sender, _spender, _amount);
170         return true;
171     }
172 
173     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
174         require(_to != 0x0);
175         balances[_from] = balances[_from].sub(_amount);
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
177         balances[_to] = balances[_to].add(_amount);
178         emit Transfer(_from, _to, _amount);
179         return true;
180     }
181 
182     function allowance(address _owner, address _spender) public view returns (uint) {
183         return allowed[_owner][_spender];
184     }
185 
186 }
187 
188 
189 // ----------------------------------------------------------------------------
190 //
191 // LockSlots
192 //
193 // ----------------------------------------------------------------------------
194 
195 contract LockSlots is ERC20Token {
196 
197     using SafeMath for uint;
198 
199     uint public constant LOCK_SLOTS = 5;
200     mapping(address => uint[LOCK_SLOTS]) public lockTerm;
201     mapping(address => uint[LOCK_SLOTS]) public lockAmnt;
202     mapping(address => bool) public mayHaveLockedTokens;
203 
204     event RegisteredLockedTokens(address indexed account, uint indexed idx, uint tokens, uint term);
205 
206     function registerLockedTokens(address _account, uint _tokens, uint _term) internal returns (uint idx) {
207         require(_term > now, "lock term must be in the future");
208 
209         // find a slot (clean up while doing this)
210         // use either the existing slot with the exact same term,
211         // of which there can be at most one, or the first empty slot
212         idx = 9999;
213         uint[LOCK_SLOTS] storage term = lockTerm[_account];
214         uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
215         for (uint i; i < LOCK_SLOTS; i++) {
216             if (term[i] < now) {
217                 term[i] = 0;
218                 amnt[i] = 0;
219                 if (idx == 9999) idx = i;
220             }
221             if (term[i] == _term) idx = i;
222         }
223 
224         // fail if no slot was found
225         require(idx != 9999, "registerLockedTokens: no available slot found");
226 
227         // register locked tokens
228         if (term[idx] == 0) term[idx] = _term;
229         amnt[idx] = amnt[idx].add(_tokens);
230         mayHaveLockedTokens[_account] = true;
231         emit RegisteredLockedTokens(_account, idx, _tokens, _term);
232     }
233 
234     // public view functions
235 
236     function lockedTokens(address _account) public view returns (uint) {
237         if (!mayHaveLockedTokens[_account]) return 0;
238         return pNumberOfLockedTokens(_account);
239     }
240 
241     function unlockedTokens(address _account) public view returns (uint) {
242         return balances[_account].sub(lockedTokens(_account));
243     }
244 
245     function isAvailableLockSlot(address _account, uint _term) public view returns (bool) {
246         if (!mayHaveLockedTokens[_account]) return true;
247         if (_term < now) return true;
248         uint[LOCK_SLOTS] storage term = lockTerm[_account];
249         for (uint i; i < LOCK_SLOTS; i++) {
250             if (term[i] < now || term[i] == _term) return true;
251         }
252         return false;
253     }
254 
255     // internal and private functions
256 
257     function unlockedTokensInternal(address _account) internal returns (uint) {
258         // updates mayHaveLockedTokens if necessary
259         if (!mayHaveLockedTokens[_account]) return balances[_account];
260         uint locked = pNumberOfLockedTokens(_account);
261         if (locked == 0) mayHaveLockedTokens[_account] = false;
262         return balances[_account].sub(locked);
263     }
264 
265     function pNumberOfLockedTokens(address _account) private view returns (uint locked) {
266         uint[LOCK_SLOTS] storage term = lockTerm[_account];
267         uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
268         for (uint i; i < LOCK_SLOTS; i++) {
269             if (term[i] >= now) locked = locked.add(amnt[i]);
270         }
271     }
272 
273 }
274 
275 
276 // ----------------------------------------------------------------------------
277 //
278 // ZabIcoDates
279 //
280 // ----------------------------------------------------------------------------
281 
282 contract ZabIcoDates is Owned {
283 
284     uint public dateMainStart = 1556524800; // 04/29/2019 @ 8:00am (UTC)
285     uint public dateMainEnd   = 1556611200; // 04/30/2019 @ 8:00am (UTC)
286     uint public constant DATE_LIMIT = 1556524800 + 180 days; ///AFTER DME
287 
288     event IcoDateUpdated(uint id, uint unixts);
289 
290     // check dates
291 
292     modifier checkDateOrder {
293       _ ;
294       require ( dateMainStart < dateMainEnd ) ;
295       require ( dateMainEnd < DATE_LIMIT ) ;
296     }
297 
298     constructor() public checkDateOrder() {
299         require(now < dateMainStart);
300     }
301 
302     // set ico dates
303 
304     function setDateMainStart(uint _unixts) public onlyOwner checkDateOrder {
305         require(now < _unixts && now < dateMainStart);
306         dateMainStart = _unixts;
307         emit IcoDateUpdated(1, _unixts);
308     }
309 
310     function setDateMainEnd(uint _unixts) public onlyOwner checkDateOrder {
311         require(now < _unixts && now < dateMainEnd);
312         dateMainEnd = _unixts;
313         emit IcoDateUpdated(2, _unixts);
314     }
315 
316     // where are we? Passed first day or not?
317 
318     function isMainFirstDay() public view returns (bool) {
319         if (now > dateMainStart && now <= dateMainStart + 1 days) return true;
320         return false;
321     }
322 
323     function isMain() public view returns (bool) {
324         if (now > dateMainStart && now < dateMainEnd) return true;
325         return false;
326     }
327 
328 }
329 
330 // ----------------------------------------------------------------------------
331 //
332 // Zab public token sale
333 //
334 // ----------------------------------------------------------------------------
335 
336 contract ZabToken is ERC20Token, Wallet, LockSlots, ZabIcoDates {
337 
338     // Utility variable
339 
340     uint constant E18 = 10**18;
341 
342     // Basic token data
343 
344     string public constant name = "ZAB Token";
345     string public constant symbol = "ZAB";
346     uint8 public constant decimals = 18;
347 
348     // Token number of possible tokens in existance
349 
350     uint public constant MAX_TOTAL_TOKEN_SUPPLY = 100 * E18;
351 
352 
353     // crowdsale parameters
354     // Opening ETH Rate: USD$463.28
355     // Therefore, 1 ETH = 11582 ZAB
356 
357 
358     uint public tokensPerEth = 100;
359 
360     // USD$2,000,000/463.28 = 4317.043668 ether
361     // 4317.043668 ether/2551 addresses = 1.692294656 ether per address for the first 24 hours
362 
363     uint public constant MINIMUM_CONTRIBUTION = 0.02 ether;
364     uint public constant MAXIMUM_FIRST_DAY_CONTRIBUTION = 0.05 ether; /// amount token per bayer
365 
366     uint public constant TOKEN_MAIN_CAP = 20 * E18; /// How much you would sale in token sale
367 
368     bool public tokensTradeable;
369 
370     // whitelisting
371 
372     mapping(address => bool) public whitelist;
373     uint public numberWhitelisted;
374 
375     // track main sale
376 
377     uint public tokensMain;
378     mapping(address => uint) public balancesMain;
379 
380     uint public totalEthContributed;
381     mapping(address => uint) public ethContributed;
382 
383     // tracking tokens minted
384 
385     uint public tokensMinted;
386     mapping(address => uint) public balancesMinted;
387     mapping(address => mapping(uint => uint)) public balancesMintedByType;
388 
389     // migration variable
390 
391     bool public isMigrationPhaseOpen;
392 
393     // Events ---------------------------------------------
394 
395     event UpdatedTokensPerEth(uint tokensPerEth);
396     event Whitelisted(address indexed account, uint countWhitelisted);
397     event TokensMinted(uint indexed mintType, address indexed account, uint tokens, uint term);
398     event RegisterContribution(address indexed account, uint tokensIssued, uint ethContributed, uint ethReturned);
399     event TokenExchangeRequested(address indexed account, uint tokens);
400 
401     // Basic Functions ------------------------------------
402 
403     constructor() public {}
404 
405     function () public payable {
406         buyTokens();
407     }
408 
409     // Information functions
410 
411 
412     function availableToMint() public view returns (uint) {
413         return MAX_TOTAL_TOKEN_SUPPLY.sub(TOKEN_MAIN_CAP).sub(tokensMinted);
414     }
415 
416     function firstDayTokenLimit() public view returns (uint) {
417         return ethToTokens(MAXIMUM_FIRST_DAY_CONTRIBUTION);
418     }
419 
420     function ethToTokens(uint _eth) public view returns (uint tokens) {
421         tokens = _eth.mul(tokensPerEth);
422     }
423 
424     function tokensToEth(uint _tokens) public view returns (uint eth) {
425         eth = _tokens / tokensPerEth;
426     }
427 
428     // Admin functions
429 
430     function addToWhitelist(address _account) public onlyAdmin {
431         pWhitelist(_account);
432     }
433 
434     function addToWhitelistMultiple(address[] _addresses) public onlyAdmin {
435         for (uint i; i < _addresses.length; i++) {
436             pWhitelist(_addresses[i]);
437         }
438     }
439 
440     function pWhitelist(address _account) internal {
441         if (whitelist[_account]) return;
442         whitelist[_account] = true;
443         numberWhitelisted = numberWhitelisted.add(1);
444         emit Whitelisted(_account, numberWhitelisted);
445     }
446 
447     // Owner functions ------------------------------------
448 
449     function updateTokensPerEth(uint _tokens_per_eth) public onlyOwner {
450         require(now < dateMainStart);
451         tokensPerEth = _tokens_per_eth;
452         emit UpdatedTokensPerEth(tokensPerEth);
453     }
454 
455     // Only owner can make tokens tradable at any time, or if the date is
456     // greater than the end of the mainsale date plus 20 weeks, allow
457     // any caller to make tokensTradeable.
458 
459     function makeTradeable() public {
460         require(msg.sender == owner || now > dateMainEnd + 20 weeks);
461         tokensTradeable = true;
462     }
463 
464     function openMigrationPhase() public onlyOwner {
465         require(now > dateMainEnd);
466         isMigrationPhaseOpen = true;
467     }
468 
469     // Token minting --------------------------------------
470 
471     function mintTokens(uint _mint_type, address _account, uint _tokens) public onlyOwner {
472         pMintTokens(_mint_type, _account, _tokens, 0);
473     }
474 
475     function mintTokensMultiple(uint _mint_type, address[] _accounts, uint[] _tokens) public onlyOwner {
476         require(_accounts.length == _tokens.length);
477         for (uint i; i < _accounts.length; i++) {
478             pMintTokens(_mint_type, _accounts[i], _tokens[i], 0);
479         }
480     }
481 
482     function mintTokensLocked(uint _mint_type, address _account, uint _tokens, uint _term) public onlyOwner {
483         pMintTokens(_mint_type, _account, _tokens, _term);
484     }
485 
486     function mintTokensLockedMultiple(uint _mint_type, address[] _accounts, uint[] _tokens, uint[] _terms) public onlyOwner {
487         require(_accounts.length == _tokens.length);
488         require(_accounts.length == _terms.length);
489         for (uint i; i < _accounts.length; i++) {
490             pMintTokens(_mint_type, _accounts[i], _tokens[i], _terms[i]);
491         }
492     }
493 
494     function pMintTokens(uint _mint_type, address _account, uint _tokens, uint _term) private {
495         require(whitelist[_account]);
496         require(_account != 0x0);
497         require(_tokens > 0);
498         require(_tokens <= availableToMint(), "not enough tokens available to mint");
499         require(_term == 0 || _term > now, "either without lock term, or lock term must be in the future");
500 
501         // register locked tokens (will throw if no slot is found)
502         if (_term > 0) registerLockedTokens(_account, _tokens, _term);
503 
504         // update
505         balances[_account] = balances[_account].add(_tokens);
506         balancesMinted[_account] = balancesMinted[_account].add(_tokens);
507         balancesMintedByType[_account][_mint_type] = balancesMintedByType[_account][_mint_type].add(_tokens);
508         tokensMinted = tokensMinted.add(_tokens);
509         tokensIssuedTotal = tokensIssuedTotal.add(_tokens);
510 
511         // log event
512         emit Transfer(0x0, _account, _tokens);
513         emit TokensMinted(_mint_type, _account, _tokens, _term);
514     }
515 
516     // Main sale ------------------------------------------
517 
518     function buyTokens() private {
519 
520         require(isMain());
521         require(msg.value >= MINIMUM_CONTRIBUTION);
522         require(whitelist[msg.sender]);
523 
524         uint tokens_available = TOKEN_MAIN_CAP.sub(tokensMain);
525 
526         // adjust tokens_available on first day, if necessary
527         if (isMainFirstDay()) {
528             uint tokens_available_first_day = firstDayTokenLimit().sub(balancesMain[msg.sender]);
529             if (tokens_available_first_day < tokens_available) {
530                 tokens_available = tokens_available_first_day;
531             }
532         }
533 
534         require (tokens_available > 0);
535 
536         uint tokens_requested = ethToTokens(msg.value);
537         uint tokens_issued = tokens_requested;
538 
539         uint eth_contributed = msg.value;
540         uint eth_returned;
541 
542         if (tokens_requested > tokens_available) {
543             tokens_issued = tokens_available;
544             eth_returned = tokensToEth(tokens_requested.sub(tokens_available));
545             eth_contributed = msg.value.sub(eth_returned);
546         }
547 
548         balances[msg.sender] = balances[msg.sender].add(tokens_issued);
549         balancesMain[msg.sender] = balancesMain[msg.sender].add(tokens_issued);
550         tokensMain = tokensMain.add(tokens_issued);
551         tokensIssuedTotal = tokensIssuedTotal.add(tokens_issued);
552 
553         ethContributed[msg.sender] = ethContributed[msg.sender].add(eth_contributed);
554         totalEthContributed = totalEthContributed.add(eth_contributed);
555 
556         // ether transfers
557         if (eth_returned > 0) msg.sender.transfer(eth_returned);
558         wallet.transfer(eth_contributed);
559 
560         // log
561         emit Transfer(0x0, msg.sender, tokens_issued);
562         emit RegisterContribution(msg.sender, tokens_issued, eth_contributed, eth_returned);
563     }
564 
565     // Token exchange / migration to new platform ---------
566 
567     function requestTokenExchangeMax() public {
568         requestTokenExchange(unlockedTokensInternal(msg.sender));
569     }
570 
571     function requestTokenExchange(uint _tokens) public {
572         require(isMigrationPhaseOpen);
573         require(_tokens > 0 && _tokens <= unlockedTokensInternal(msg.sender));
574         balances[msg.sender] = balances[msg.sender].sub(_tokens);
575         tokensIssuedTotal = tokensIssuedTotal.sub(_tokens);
576         emit Transfer(msg.sender, 0x0, _tokens);
577         emit TokenExchangeRequested(msg.sender, _tokens);
578     }
579 
580     // ERC20 functions -------------------
581 
582     /* Transfer out any accidentally sent ERC20 tokens */
583 
584     function transferAnyERC20Token(address _token_address, uint _amount) public onlyOwner returns (bool success) {
585         return ERC20Interface(_token_address).transfer(owner, _amount);
586     }
587 
588     /* Override "transfer" */
589 
590     function transfer(address _to, uint _amount) public returns (bool success) {
591         require(tokensTradeable);
592         require(_amount <= unlockedTokensInternal(msg.sender));
593         return super.transfer(_to, _amount);
594     }
595 
596     /* Multiple token transfers from one address to save gas */
597 
598     function transferMultiple(address[] _addresses, uint[] _amounts) external {
599         require(_addresses.length <= 100);
600         require(_addresses.length == _amounts.length);
601 
602         // do the transfers
603         for (uint j; j < _addresses.length; j++) {
604             transfer(_addresses[j], _amounts[j]);
605         }
606 
607     }
608 
609 }