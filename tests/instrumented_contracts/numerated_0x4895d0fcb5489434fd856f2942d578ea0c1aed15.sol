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
222   uint public constant DATE_PRESALE_START = 1510151400; // 08-Nov-2017 14:30 UTC
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
246   uint public constant MIN_CONTRIBUTION = 1 ether / 20; // 0.05 Ether
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
268   /* - or have reclaimed their contributions in case of fialed Crowdsale */
269   
270   mapping(address => bool) public airdropClaimed;
271   mapping(address => bool) public refundClaimed;
272 
273   // Events ---------------------------
274   
275   event WalletUpdated(address _newWallet);
276   event AdminWalletUpdated(address _newAdminWallet);
277   event TokensPerEthUpdated(uint _tokensPerEth);
278   event TokensMinted(address indexed _owner, uint _tokens, uint _balance);
279   event TokensIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
280   event Refund(address indexed _owner, uint _amount, uint _tokens);
281   event Airdrop(address indexed _owner, uint _amount, uint _balance);
282 
283   // Basic Functions ------------------
284 
285   /* Initialize (owner is set to msg.sender by Owned.Owned() */
286 
287   function IndaHashToken() {
288     require( TOKEN_SUPPLY_ICO + TOKEN_SUPPLY_MKT == TOKEN_SUPPLY_TOTAL );
289     wallet = owner;
290     adminWallet = owner;
291   }
292 
293   /* Fallback */
294   
295   function () payable {
296     buyTokens();
297   }
298   
299   // Information functions ------------
300   
301   /* What time is it? */
302   
303   function atNow() constant returns (uint) {
304     return now;
305   }
306   
307   /* Has the minimum threshold been reached? */
308   
309   function icoThresholdReached() constant returns (bool thresholdReached) {
310      if (tokensIssuedIco < MIN_FUNDING_GOAL) return false;
311      return true;
312   }  
313   
314   /* Are tokens transferable? */
315 
316   function isTransferable() constant returns (bool transferable) {
317      if ( !icoThresholdReached() ) return false;
318      if ( atNow() < DATE_ICO_END + COOLDOWN_PERIOD ) return false;
319      return true;
320   }
321   
322   // Owner Functions ------------------
323   
324   /* Change the crowdsale wallet address */
325 
326   function setWallet(address _wallet) onlyOwner {
327     require( _wallet != address(0x0) );
328     wallet = _wallet;
329     WalletUpdated(wallet);
330   }
331 
332   /* Change the admin wallet address */
333 
334   function setAdminWallet(address _wallet) onlyOwner {
335     require( _wallet != address(0x0) );
336     adminWallet = _wallet;
337     AdminWalletUpdated(adminWallet);
338   }
339 
340   /* Change tokensPerEth before ICO start */
341   
342   function updateTokensPerEth(uint _tokensPerEth) onlyOwner {
343     require( atNow() < DATE_PRESALE_START );
344     tokensPerEth = _tokensPerEth;
345     TokensPerEthUpdated(_tokensPerEth);
346   }
347 
348   /* Minting of marketing tokens by owner */
349 
350   function mintMarketing(address _participant, uint _tokens) onlyOwner {
351     // check amount
352     require( _tokens <= TOKEN_SUPPLY_MKT.sub(tokensIssuedMkt) );
353     
354     // update balances
355     balances[_participant] = balances[_participant].add(_tokens);
356     tokensIssuedMkt        = tokensIssuedMkt.add(_tokens);
357     tokensIssuedTotal      = tokensIssuedTotal.add(_tokens);
358     
359     // log the miniting
360     Transfer(0x0, _participant, _tokens);
361     TokensMinted(_participant, _tokens, balances[_participant]);
362   }
363 
364   /* Owner clawback of remaining funds after clawback period */
365   /* (for use in case of a failed Crwodsale) */
366   
367   function ownerClawback() external onlyOwner {
368     require( atNow() > DATE_ICO_END + CLAWBACK_PERIOD );
369     wallet.transfer(this.balance);
370   }
371 
372   /* Transfer out any accidentally sent ERC20 tokens */
373 
374   function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) {
375       return ERC20Interface(tokenAddress).transfer(owner, amount);
376   }
377 
378   // Private functions ----------------
379 
380   /* Accept ETH during crowdsale (called by default function) */
381 
382   function buyTokens() private {
383     uint ts = atNow();
384     bool isPresale = false;
385     bool isIco = false;
386     uint tokens = 0;
387     
388     // minimum contribution
389     require( msg.value >= MIN_CONTRIBUTION );
390     
391     // one address transfer hard cap
392     require( icoEtherContributed[msg.sender].add(msg.value) <= MAX_CONTRIBUTION );
393 
394     // check dates for presale or ICO
395     if (ts > DATE_PRESALE_START && ts < DATE_PRESALE_END) isPresale = true;  
396     if (ts > DATE_ICO_START && ts < DATE_ICO_END) isIco = true;  
397     require( isPresale || isIco );
398 
399     // presale cap in Ether
400     if (isPresale) require( icoEtherReceived.add(msg.value) <= PRESALE_ETH_CAP );
401     
402     // get baseline number of tokens
403     tokens = tokensPerEth.mul(msg.value) / 1 ether;
404     
405     // apply bonuses (none for last week)
406     if (isPresale) {
407       tokens = tokens.mul(100 + BONUS_PRESALE) / 100;
408     } else if (ts < DATE_ICO_START + 7 days) {
409       // first week ico bonus
410       tokens = tokens.mul(100 + BONUS_ICO_WEEK_ONE) / 100;
411     } else if (ts < DATE_ICO_START + 14 days) {
412       // second week ico bonus
413       tokens = tokens.mul(100 + BONUS_ICO_WEEK_TWO) / 100;
414     }
415     
416     // ICO token volume cap
417     require( tokensIssuedIco.add(tokens) <= TOKEN_SUPPLY_ICO );
418 
419     // register tokens
420     balances[msg.sender]          = balances[msg.sender].add(tokens);
421     icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(tokens);
422     tokensIssuedIco               = tokensIssuedIco.add(tokens);
423     tokensIssuedTotal             = tokensIssuedTotal.add(tokens);
424     
425     // register Ether
426     icoEtherReceived                = icoEtherReceived.add(msg.value);
427     icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
428     
429     // log token issuance
430     Transfer(0x0, msg.sender, tokens);
431     TokensIssued(msg.sender, tokens, balances[msg.sender], msg.value);
432 
433     // transfer Ether if we're over the threshold
434     if ( icoThresholdReached() ) wallet.transfer(this.balance);
435   }
436   
437   // ERC20 functions ------------------
438 
439   /* Override "transfer" (ERC20) */
440 
441   function transfer(address _to, uint _amount) returns (bool success) {
442     require( isTransferable() );
443     return super.transfer(_to, _amount);
444   }
445   
446   /* Override "transferFrom" (ERC20) */
447 
448   function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
449     require( isTransferable() );
450     return super.transferFrom(_from, _to, _amount);
451   }
452 
453   // External functions ---------------
454 
455   /* Reclaiming of funds by contributors in case of a failed crowdsale */
456   /* (it will fail if account is empty after ownerClawback) */
457 
458   /* While there could not have been any token transfers yet, a contributor */
459   /* may have received minted tokens, so the token balance after a refund */ 
460   /* may still be positive */
461   
462   function reclaimFunds() external {
463     uint tokens; // tokens to destroy
464     uint amount; // refund amount
465     
466     // ico is finished and was not successful
467     require( atNow() > DATE_ICO_END && !icoThresholdReached() );
468     
469     // check if refund has already been claimed
470     require( !refundClaimed[msg.sender] );
471     
472     // check if there is anything to refund
473     require( icoEtherContributed[msg.sender] > 0 );
474     
475     // update variables affected by refund
476     tokens = icoTokensReceived[msg.sender];
477     amount = icoEtherContributed[msg.sender];
478 
479     balances[msg.sender] = balances[msg.sender].sub(tokens);
480     tokensIssuedTotal    = tokensIssuedTotal.sub(tokens);
481     
482     refundClaimed[msg.sender] = true;
483     
484     // transfer out refund
485     msg.sender.transfer(amount);
486     
487     // log
488     Transfer(msg.sender, 0x0, tokens);
489     Refund(msg.sender, amount, tokens);
490   }
491 
492   /* Claiming of "airdropped" tokens in case of successful crowdsale */
493   /* Can be done by token holder, or by adminWallet */ 
494 
495   function claimAirdrop() external {
496     doAirdrop(msg.sender);
497   }
498 
499   function adminClaimAirdrop(address _participant) external {
500     require( msg.sender == adminWallet );
501     doAirdrop(_participant);
502   }
503 
504   function adminClaimAirdropMultiple(address[] _addresses) external {
505     require( msg.sender == adminWallet );
506     for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i]);
507   }  
508   
509   function doAirdrop(address _participant) internal {
510     uint airdrop = computeAirdrop(_participant);
511 
512     require( airdrop > 0 );
513 
514     // update balances and token issue volume
515     airdropClaimed[_participant] = true;
516     balances[_participant] = balances[_participant].add(airdrop);
517     tokensIssuedTotal      = tokensIssuedTotal.add(airdrop);
518     tokensClaimedAirdrop   = tokensClaimedAirdrop.add(airdrop);
519     
520     // log
521     Airdrop(_participant, airdrop, balances[_participant]);
522     Transfer(0x0, _participant, airdrop);
523   }
524 
525   /* Function to estimate airdrop amount. For some accounts, the value of */
526   /* tokens received by calling claimAirdrop() may be less than gas costs */
527   
528   /* If an account has tokens from the ico, the amount after the airdrop */
529   /* will be newBalance = tokens * TOKEN_SUPPLY_ICO / tokensIssuedIco */
530       
531   function computeAirdrop(address _participant) constant returns (uint airdrop) {
532     // return 0 if it's too early or ico was not successful
533     if ( atNow() < DATE_ICO_END || !icoThresholdReached() ) return 0;
534     
535     // return  0 is the airdrop was already claimed
536     if( airdropClaimed[_participant] ) return 0;
537 
538     // return 0 if the account does not hold any crowdsale tokens
539     if( icoTokensReceived[_participant] == 0 ) return 0;
540     
541     // airdrop amount
542     uint tokens = icoTokensReceived[_participant];
543     uint newBalance = tokens.mul(TOKEN_SUPPLY_ICO) / tokensIssuedIco;
544     airdrop = newBalance - tokens;
545   }  
546 
547   /* Multiple token transfers from one address to save gas */
548   /* (longer _amounts array not accepted = sanity check) */
549 
550   function transferMultiple(address[] _addresses, uint[] _amounts) external {
551     require( isTransferable() );
552     require( _addresses.length == _amounts.length );
553     for (uint i = 0; i < _addresses.length; i++) super.transfer(_addresses[i], _amounts[i]);
554   }  
555 
556 }