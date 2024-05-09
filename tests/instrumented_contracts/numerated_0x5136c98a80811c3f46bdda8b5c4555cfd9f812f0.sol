1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // IDH indaHash token public sale contract
6 //
7 // For details, please visit: https://indahash.com/ico
8 //
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 //
14 // SafeMath3
15 //
16 // Adapted from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
17 // (no need to implement division)
18 //
19 // ----------------------------------------------------------------------------
20 
21 library SafeMath3 {
22 
23   function mul(uint a, uint b) internal constant returns (uint c) {
24     c = a * b;
25     assert( a == 0 || c / a == b );
26   }
27 
28   function sub(uint a, uint b) internal constant returns (uint) {
29     assert( b <= a );
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal constant returns (uint c) {
34     c = a + b;
35     assert( c >= a );
36   }
37 
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 //
43 // Owned contract
44 //
45 // ----------------------------------------------------------------------------
46 
47 contract Owned {
48 
49   address public owner;
50   address public newOwner;
51 
52   // Events ---------------------------
53 
54   event OwnershipTransferProposed(address indexed _from, address indexed _to);
55   event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57   // Modifier -------------------------
58 
59   modifier onlyOwner {
60     require( msg.sender == owner );
61     _;
62   }
63 
64   // Functions ------------------------
65 
66   function Owned() {
67     owner = msg.sender;
68   }
69 
70   function transferOwnership(address _newOwner) onlyOwner {
71     require( _newOwner != owner );
72     require( _newOwner != address(0x0) );
73     OwnershipTransferProposed(owner, _newOwner);
74     newOwner = _newOwner;
75   }
76 
77   function acceptOwnership() {
78     require(msg.sender == newOwner);
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 //
88 // ERC Token Standard #20 Interface
89 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
90 //
91 // ----------------------------------------------------------------------------
92 
93 contract ERC20Interface {
94 
95   // Events ---------------------------
96 
97   event Transfer(address indexed _from, address indexed _to, uint _value);
98   event Approval(address indexed _owner, address indexed _spender, uint _value);
99 
100   // Functions ------------------------
101 
102   function totalSupply() constant returns (uint);
103   function balanceOf(address _owner) constant returns (uint balance);
104   function transfer(address _to, uint _value) returns (bool success);
105   function transferFrom(address _from, address _to, uint _value) returns (bool success);
106   function approve(address _spender, uint _value) returns (bool success);
107   function allowance(address _owner, address _spender) constant returns (uint remaining);
108 
109 }
110 
111 
112 // ----------------------------------------------------------------------------
113 //
114 // ERC Token Standard #20
115 //
116 // ----------------------------------------------------------------------------
117 
118 contract ERC20Token is ERC20Interface, Owned {
119   
120   using SafeMath3 for uint;
121 
122   uint public tokensIssuedTotal = 0;
123   mapping(address => uint) balances;
124   mapping(address => mapping (address => uint)) allowed;
125 
126   // Functions ------------------------
127 
128   /* Total token supply */
129 
130   function totalSupply() constant returns (uint) {
131     return tokensIssuedTotal;
132   }
133 
134   /* Get the account balance for an address */
135 
136   function balanceOf(address _owner) constant returns (uint balance) {
137     return balances[_owner];
138   }
139 
140   /* Transfer the balance from owner's account to another account */
141 
142   function transfer(address _to, uint _amount) returns (bool success) {
143     // amount sent cannot exceed balance
144     require( balances[msg.sender] >= _amount );
145 
146     // update balances
147     balances[msg.sender] = balances[msg.sender].sub(_amount);
148     balances[_to]        = balances[_to].add(_amount);
149 
150     // log event
151     Transfer(msg.sender, _to, _amount);
152     return true;
153   }
154 
155   /* Allow _spender to withdraw from your account up to _amount */
156 
157   function approve(address _spender, uint _amount) returns (bool success) {
158     // approval amount cannot exceed the balance
159     require ( balances[msg.sender] >= _amount );
160       
161     // update allowed amount
162     allowed[msg.sender][_spender] = _amount;
163     
164     // log event
165     Approval(msg.sender, _spender, _amount);
166     return true;
167   }
168 
169   /* Spender of tokens transfers tokens from the owner's balance */
170   /* Must be pre-approved by owner */
171 
172   function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
173     // balance checks
174     require( balances[_from] >= _amount );
175     require( allowed[_from][msg.sender] >= _amount );
176 
177     // update balances and allowed amount
178     balances[_from]            = balances[_from].sub(_amount);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
180     balances[_to]              = balances[_to].add(_amount);
181 
182     // log event
183     Transfer(_from, _to, _amount);
184     return true;
185   }
186 
187   /* Returns the amount of tokens approved by the owner */
188   /* that can be transferred by spender */
189 
190   function allowance(address _owner, address _spender) constant returns (uint remaining) {
191     return allowed[_owner][_spender];
192   }
193 
194 }
195 
196 
197 // ----------------------------------------------------------------------------
198 //
199 // IDH public token sale
200 //
201 // ----------------------------------------------------------------------------
202 
203 contract IndaHashToken is ERC20Token {
204 
205   /* Utility variable */
206   
207   uint constant E6 = 10**6;
208   
209   /* Basic token data */
210 
211   string public constant name     = "indaHash Coin";
212   string public constant symbol   = "IDH";
213   uint8  public constant decimals = 6;
214 
215   /* Wallet addresses - initially set to owner at deployment */
216   
217   address public wallet;
218   address public adminWallet;
219 
220   /* ICO dates */
221 
222   uint public constant DATE_PRESALE_START = 1510153200; // 08-Nov-2017 15:00 UTC
223   uint public constant DATE_PRESALE_END   = 1510758000; // 15-Nov-2017 15:00 UTC
224 
225   uint public constant DATE_ICO_START = 1511967600; // 29-Nov-2017 15:00 UTC
226   uint public constant DATE_ICO_END   = 1513782000; // 20-Dec-2017 15:00 UTC
227 
228   /* ICO tokens per ETH */
229   
230   uint public tokensPerEth = 3200 * E6; // rate during last ICO week
231 
232   uint public constant BONUS_PRESALE      = 40;
233   uint public constant BONUS_ICO_WEEK_ONE = 20;
234   uint public constant BONUS_ICO_WEEK_TWO = 10;
235 
236   /* Other ICO parameters */  
237   
238   uint public constant TOKEN_SUPPLY_TOTAL = 400 * E6 * E6; // 400 mm tokens
239   uint public constant TOKEN_SUPPLY_ICO   = 320 * E6 * E6; // 320 mm tokens
240   uint public constant TOKEN_SUPPLY_MKT   =  80 * E6 * E6; //  80 mm tokens
241 
242   uint public constant PRESALE_ETH_CAP =  15000 ether;
243 
244   uint public constant MIN_FUNDING_GOAL =  40 * E6 * E6; // 40 mm tokens
245   
246   uint public constant MIN_CONTRIBUTION = 1 ether / 2; // 0.5 Ether
247   uint public constant MAX_CONTRIBUTION = 300 ether;
248 
249   uint public constant COOLDOWN_PERIOD =  2 days;
250   uint public constant CLAWBACK_PERIOD = 90 days;
251 
252   /* Crowdsale variables */
253 
254   uint public icoEtherReceived = 0; // Ether actually received by the contract
255 
256   uint public tokensIssuedIco   = 0;
257   uint public tokensIssuedMkt   = 0;
258   
259   uint public tokensClaimedAirdrop = 0;
260   
261   /* Keep track of Ether contributed and tokens received during Crowdsale */
262   
263   mapping(address => uint) public icoEtherContributed;
264   mapping(address => uint) public icoTokensReceived;
265 
266   /* Keep track of participants who 
267   /* - have received their airdropped tokens after a successful ICO */
268   /* - or have reclaimed their contributions in case of failed Crowdsale */
269   /* - are locked */
270   
271   mapping(address => bool) public airdropClaimed;
272   mapping(address => bool) public refundClaimed;
273   mapping(address => bool) public locked;
274 
275   // Events ---------------------------
276   
277   event WalletUpdated(address _newWallet);
278   event AdminWalletUpdated(address _newAdminWallet);
279   event TokensPerEthUpdated(uint _tokensPerEth);
280   event TokensMinted(address indexed _owner, uint _tokens, uint _balance);
281   event TokensIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
282   event Refund(address indexed _owner, uint _amount, uint _tokens);
283   event Airdrop(address indexed _owner, uint _amount, uint _balance);
284   event LockRemoved(address indexed _participant);
285 
286   // Basic Functions ------------------
287 
288   /* Initialize (owner is set to msg.sender by Owned.Owned() */
289 
290   function IndaHashToken() {
291     require( TOKEN_SUPPLY_ICO + TOKEN_SUPPLY_MKT == TOKEN_SUPPLY_TOTAL );
292     wallet = owner;
293     adminWallet = owner;
294   }
295 
296   /* Fallback */
297   
298   function () payable {
299     buyTokens();
300   }
301   
302   // Information functions ------------
303   
304   /* What time is it? */
305   
306   function atNow() constant returns (uint) {
307     return now;
308   }
309   
310   /* Has the minimum threshold been reached? */
311   
312   function icoThresholdReached() constant returns (bool thresholdReached) {
313      if (tokensIssuedIco < MIN_FUNDING_GOAL) return false;
314      return true;
315   }  
316   
317   /* Are tokens transferable? */
318 
319   function isTransferable() constant returns (bool transferable) {
320      if ( !icoThresholdReached() ) return false;
321      if ( atNow() < DATE_ICO_END + COOLDOWN_PERIOD ) return false;
322      return true;
323   }
324   
325   // Lock functions -------------------
326 
327   /* Manage locked */
328 
329   function removeLock(address _participant) {
330     require( msg.sender == adminWallet || msg.sender == owner );
331     locked[_participant] = false;
332     LockRemoved(_participant);
333   }
334 
335   function removeLockMultiple(address[] _participants) {
336     require( msg.sender == adminWallet || msg.sender == owner );
337     for (uint i = 0; i < _participants.length; i++) {
338       locked[_participants[i]] = false;
339       LockRemoved(_participants[i]);
340     }
341   }
342 
343   // Owner Functions ------------------
344   
345   /* Change the crowdsale wallet address */
346 
347   function setWallet(address _wallet) onlyOwner {
348     require( _wallet != address(0x0) );
349     wallet = _wallet;
350     WalletUpdated(wallet);
351   }
352 
353   /* Change the admin wallet address */
354 
355   function setAdminWallet(address _wallet) onlyOwner {
356     require( _wallet != address(0x0) );
357     adminWallet = _wallet;
358     AdminWalletUpdated(adminWallet);
359   }
360 
361   /* Change tokensPerEth before ICO start */
362   
363   function updateTokensPerEth(uint _tokensPerEth) onlyOwner {
364     require( atNow() < DATE_PRESALE_START );
365     tokensPerEth = _tokensPerEth;
366     TokensPerEthUpdated(_tokensPerEth);
367   }
368 
369   /* Minting of marketing tokens by owner */
370 
371   function mintMarketing(address _participant, uint _tokens) onlyOwner {
372     // check amount
373     require( _tokens <= TOKEN_SUPPLY_MKT.sub(tokensIssuedMkt) );
374     
375     // update balances
376     balances[_participant] = balances[_participant].add(_tokens);
377     tokensIssuedMkt        = tokensIssuedMkt.add(_tokens);
378     tokensIssuedTotal      = tokensIssuedTotal.add(_tokens);
379     
380     // locked
381     locked[_participant] = true;
382     
383     // log the miniting
384     Transfer(0x0, _participant, _tokens);
385     TokensMinted(_participant, _tokens, balances[_participant]);
386   }
387 
388   /* Owner clawback of remaining funds after clawback period */
389   /* (for use in case of a failed Crwodsale) */
390   
391   function ownerClawback() external onlyOwner {
392     require( atNow() > DATE_ICO_END + CLAWBACK_PERIOD );
393     wallet.transfer(this.balance);
394   }
395 
396   /* Transfer out any accidentally sent ERC20 tokens */
397 
398   function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) {
399       return ERC20Interface(tokenAddress).transfer(owner, amount);
400   }
401 
402   // Private functions ----------------
403 
404   /* Accept ETH during crowdsale (called by default function) */
405 
406   function buyTokens() private {
407     uint ts = atNow();
408     bool isPresale = false;
409     bool isIco = false;
410     uint tokens = 0;
411     
412     // minimum contribution
413     require( msg.value >= MIN_CONTRIBUTION );
414     
415     // one address transfer hard cap
416     require( icoEtherContributed[msg.sender].add(msg.value) <= MAX_CONTRIBUTION );
417 
418     // check dates for presale or ICO
419     if (ts > DATE_PRESALE_START && ts < DATE_PRESALE_END) isPresale = true;  
420     if (ts > DATE_ICO_START && ts < DATE_ICO_END) isIco = true;  
421     require( isPresale || isIco );
422 
423     // presale cap in Ether
424     if (isPresale) require( icoEtherReceived.add(msg.value) <= PRESALE_ETH_CAP );
425     
426     // get baseline number of tokens
427     tokens = tokensPerEth.mul(msg.value) / 1 ether;
428     
429     // apply bonuses (none for last week)
430     if (isPresale) {
431       tokens = tokens.mul(100 + BONUS_PRESALE) / 100;
432     } else if (ts < DATE_ICO_START + 7 days) {
433       // first week ico bonus
434       tokens = tokens.mul(100 + BONUS_ICO_WEEK_ONE) / 100;
435     } else if (ts < DATE_ICO_START + 14 days) {
436       // second week ico bonus
437       tokens = tokens.mul(100 + BONUS_ICO_WEEK_TWO) / 100;
438     }
439     
440     // ICO token volume cap
441     require( tokensIssuedIco.add(tokens) <= TOKEN_SUPPLY_ICO );
442 
443     // register tokens
444     balances[msg.sender]          = balances[msg.sender].add(tokens);
445     icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(tokens);
446     tokensIssuedIco               = tokensIssuedIco.add(tokens);
447     tokensIssuedTotal             = tokensIssuedTotal.add(tokens);
448     
449     // register Ether
450     icoEtherReceived                = icoEtherReceived.add(msg.value);
451     icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
452     
453     // locked
454     locked[msg.sender] = true;
455     
456     // log token issuance
457     Transfer(0x0, msg.sender, tokens);
458     TokensIssued(msg.sender, tokens, balances[msg.sender], msg.value);
459 
460     // transfer Ether if we're over the threshold
461     if ( icoThresholdReached() ) wallet.transfer(this.balance);
462   }
463   
464   // ERC20 functions ------------------
465 
466   /* Override "transfer" (ERC20) */
467 
468   function transfer(address _to, uint _amount) returns (bool success) {
469     require( isTransferable() );
470     require( locked[msg.sender] == false );
471     require( locked[_to] == false );
472     return super.transfer(_to, _amount);
473   }
474   
475   /* Override "transferFrom" (ERC20) */
476 
477   function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
478     require( isTransferable() );
479     require( locked[_from] == false );
480     require( locked[_to] == false );
481     return super.transferFrom(_from, _to, _amount);
482   }
483 
484   // External functions ---------------
485 
486   /* Reclaiming of funds by contributors in case of a failed crowdsale */
487   /* (it will fail if account is empty after ownerClawback) */
488 
489   /* While there could not have been any token transfers yet, a contributor */
490   /* may have received minted tokens, so the token balance after a refund */ 
491   /* may still be positive */
492   
493   function reclaimFunds() external {
494     uint tokens; // tokens to destroy
495     uint amount; // refund amount
496     
497     // ico is finished and was not successful
498     require( atNow() > DATE_ICO_END && !icoThresholdReached() );
499     
500     // check if refund has already been claimed
501     require( !refundClaimed[msg.sender] );
502     
503     // check if there is anything to refund
504     require( icoEtherContributed[msg.sender] > 0 );
505     
506     // update variables affected by refund
507     tokens = icoTokensReceived[msg.sender];
508     amount = icoEtherContributed[msg.sender];
509 
510     balances[msg.sender] = balances[msg.sender].sub(tokens);
511     tokensIssuedTotal    = tokensIssuedTotal.sub(tokens);
512     
513     refundClaimed[msg.sender] = true;
514     
515     // transfer out refund
516     msg.sender.transfer(amount);
517     
518     // log
519     Transfer(msg.sender, 0x0, tokens);
520     Refund(msg.sender, amount, tokens);
521   }
522 
523   /* Claiming of "airdropped" tokens in case of successful crowdsale */
524   /* Can be done by token holder, or by adminWallet */ 
525 
526   function claimAirdrop() external {
527     doAirdrop(msg.sender);
528   }
529 
530   function adminClaimAirdrop(address _participant) external {
531     require( msg.sender == adminWallet );
532     doAirdrop(_participant);
533   }
534 
535   function adminClaimAirdropMultiple(address[] _addresses) external {
536     require( msg.sender == adminWallet );
537     for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i]);
538   }  
539   
540   function doAirdrop(address _participant) internal {
541     uint airdrop = computeAirdrop(_participant);
542 
543     require( airdrop > 0 );
544 
545     // update balances and token issue volume
546     airdropClaimed[_participant] = true;
547     balances[_participant] = balances[_participant].add(airdrop);
548     tokensIssuedTotal      = tokensIssuedTotal.add(airdrop);
549     tokensClaimedAirdrop   = tokensClaimedAirdrop.add(airdrop);
550     
551     // log
552     Airdrop(_participant, airdrop, balances[_participant]);
553     Transfer(0x0, _participant, airdrop);
554   }
555 
556   /* Function to estimate airdrop amount. For some accounts, the value of */
557   /* tokens received by calling claimAirdrop() may be less than gas costs */
558   
559   /* If an account has tokens from the ico, the amount after the airdrop */
560   /* will be newBalance = tokens * TOKEN_SUPPLY_ICO / tokensIssuedIco */
561       
562   function computeAirdrop(address _participant) constant returns (uint airdrop) {
563     // return 0 if it's too early or ico was not successful
564     if ( atNow() < DATE_ICO_END || !icoThresholdReached() ) return 0;
565     
566     // return  0 is the airdrop was already claimed
567     if( airdropClaimed[_participant] ) return 0;
568 
569     // return 0 if the account does not hold any crowdsale tokens
570     if( icoTokensReceived[_participant] == 0 ) return 0;
571     
572     // airdrop amount
573     uint tokens = icoTokensReceived[_participant];
574     uint newBalance = tokens.mul(TOKEN_SUPPLY_ICO) / tokensIssuedIco;
575     airdrop = newBalance - tokens;
576   }  
577 
578   /* Multiple token transfers from one address to save gas */
579   /* (longer _amounts array not accepted = sanity check) */
580 
581   function transferMultiple(address[] _addresses, uint[] _amounts) external {
582     require( isTransferable() );
583     require( locked[msg.sender] == false );
584     require( _addresses.length == _amounts.length );
585     for (uint i = 0; i < _addresses.length; i++) {
586       if (locked[_addresses[i]] == false) super.transfer(_addresses[i], _amounts[i]);
587     }
588   }  
589 
590 }