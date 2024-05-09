1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // SafeMath3
6 //
7 // Adapted from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
8 // (no need to implement division)
9 //
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath3 {
13 
14   function mul(uint a, uint b) internal constant returns (uint c) {
15     c = a * b;
16     assert( a == 0 || c / a == b );
17   }
18 
19   function sub(uint a, uint b) internal constant returns (uint) {
20     assert( b <= a );
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal constant returns (uint c) {
25     c = a + b;
26     assert( c >= a );
27   }
28 
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 //
34 // Owned contract
35 //
36 // ----------------------------------------------------------------------------
37 
38 contract Owned {
39 
40   address public owner;
41   address public newOwner;
42 
43   // Events ---------------------------
44 
45   event OwnershipTransferProposed(address indexed _from, address indexed _to);
46   event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48   // Modifier -------------------------
49 
50   modifier onlyOwner {
51     require( msg.sender == owner );
52     _;
53   }
54 
55   // Functions ------------------------
56 
57   function Owned() {
58     owner = msg.sender;
59   }
60 
61   function transferOwnership(address _newOwner) onlyOwner {
62     require( _newOwner != owner );
63     require( _newOwner != address(0x0) );
64     OwnershipTransferProposed(owner, _newOwner);
65     newOwner = _newOwner;
66   }
67 
68   function acceptOwnership() {
69     require(msg.sender == newOwner);
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 //
79 // ERC Token Standard #20 Interface
80 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
81 //
82 // ----------------------------------------------------------------------------
83 
84 contract ERC20Interface {
85 
86   // Events ---------------------------
87 
88   event Transfer(address indexed _from, address indexed _to, uint _value);
89   event Approval(address indexed _owner, address indexed _spender, uint _value);
90 
91   // Functions ------------------------
92 
93   function totalSupply() constant returns (uint);
94   function balanceOf(address _owner) constant returns (uint balance);
95   function transfer(address _to, uint _value) returns (bool success);
96   function transferFrom(address _from, address _to, uint _value) returns (bool success);
97   function approve(address _spender, uint _value) returns (bool success);
98   function allowance(address _owner, address _spender) constant returns (uint remaining);
99 
100 }
101 
102 
103 // ----------------------------------------------------------------------------
104 //
105 // ERC Token Standard #20
106 //
107 // ----------------------------------------------------------------------------
108 
109 contract ERC20Token is ERC20Interface, Owned {
110   
111   using SafeMath3 for uint;
112 
113   uint public tokensIssuedTotal = 0;
114   mapping(address => uint) balances;
115   mapping(address => mapping (address => uint)) allowed;
116 
117   // Functions ------------------------
118 
119   /* Total token supply */
120 
121   function totalSupply() constant returns (uint) {
122     return tokensIssuedTotal;
123   }
124 
125   /* Get the account balance for an address */
126 
127   function balanceOf(address _owner) constant returns (uint balance) {
128     return balances[_owner];
129   }
130 
131   /* Transfer the balance from owner's account to another account */
132 
133   function transfer(address _to, uint _amount) returns (bool success) {
134     // amount sent cannot exceed balance
135     require( balances[msg.sender] >= _amount );
136 
137     // update balances
138     balances[msg.sender] = balances[msg.sender].sub(_amount);
139     balances[_to]        = balances[_to].add(_amount);
140 
141     // log event
142     Transfer(msg.sender, _to, _amount);
143     return true;
144   }
145 
146   /* Allow _spender to withdraw from your account up to _amount */
147 
148   function approve(address _spender, uint _amount) returns (bool success) {
149     // approval amount cannot exceed the balance
150     require ( balances[msg.sender] >= _amount );
151       
152     // update allowed amount
153     allowed[msg.sender][_spender] = _amount;
154     
155     // log event
156     Approval(msg.sender, _spender, _amount);
157     return true;
158   }
159 
160   /* Spender of tokens transfers tokens from the owner's balance */
161   /* Must be pre-approved by owner */
162 
163   function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
164     // balance checks
165     require( balances[_from] >= _amount );
166     require( allowed[_from][msg.sender] >= _amount );
167 
168     // update balances and allowed amount
169     balances[_from]            = balances[_from].sub(_amount);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
171     balances[_to]              = balances[_to].add(_amount);
172 
173     // log event
174     Transfer(_from, _to, _amount);
175     return true;
176   }
177 
178   /* Returns the amount of tokens approved by the owner */
179   /* that can be transferred by spender */
180 
181   function allowance(address _owner, address _spender) constant returns (uint remaining) {
182     return allowed[_owner][_spender];
183   }
184 
185 }
186 
187 
188 
189 
190 contract ZZZToken is ERC20Token {
191 
192   /* Utility variable */
193   
194   uint constant E6 = 10**6;
195   
196   /* Basic token data */
197 
198   string public constant name     = "ZZZ Coin";
199   string public constant symbol   = "ZZZ";
200   uint8  public constant decimals = 6;
201 
202   /* Wallet addresses - initially set to owner at deployment */
203   
204   address public wallet;
205   address public adminWallet;
206 
207   /* ICO dates */
208 
209   uint public constant DATE_PRESALE_START = 1500153200; //
210   uint public constant DATE_PRESALE_END   = 1510758000; // 15-Nov-2017 15:00 UTC
211 
212   uint public constant DATE_ICO_START = 1511967600; // 29-Nov-2017 15:00 UTC
213   uint public constant DATE_ICO_END   = 1513782000; // 20-Dec-2017 15:00 UTC
214 
215   /* ICO tokens per ETH */
216   
217   uint public tokensPerEth = 3200 * E6; // rate during last ICO week
218 
219   uint public constant BONUS_PRESALE      = 40;
220   uint public constant BONUS_ICO_WEEK_ONE = 20;
221   uint public constant BONUS_ICO_WEEK_TWO = 10;
222 
223   /* Other ICO parameters */  
224   
225   uint public constant TOKEN_SUPPLY_TOTAL = 400 * E6 * E6; // 400 mm tokens
226   uint public constant TOKEN_SUPPLY_ICO   = 320 * E6 * E6; // 320 mm tokens
227   uint public constant TOKEN_SUPPLY_MKT   =  80 * E6 * E6; //  80 mm tokens
228 
229   uint public constant PRESALE_ETH_CAP =  15000 ether;
230 
231   uint public constant MIN_FUNDING_GOAL =  40 * E6 * E6; // 40 mm tokens
232   
233   uint public constant MIN_CONTRIBUTION = 1 ether / 200; // 0.005 Ether
234   uint public constant MAX_CONTRIBUTION = 300 ether;
235 
236   uint public constant COOLDOWN_PERIOD =  2 days;
237   uint public constant CLAWBACK_PERIOD = 90 days;
238 
239   /* Crowdsale variables */
240 
241   uint public icoEtherReceived = 0; // Ether actually received by the contract
242 
243   uint public tokensIssuedIco   = 0;
244   uint public tokensIssuedMkt   = 0;
245   
246   uint public tokensClaimedAirdrop = 0;
247   
248   /* Keep track of Ether contributed and tokens received during Crowdsale */
249   
250   mapping(address => uint) public icoEtherContributed;
251   mapping(address => uint) public icoTokensReceived;
252 
253   /* Keep track of participants who 
254   /* - have received their airdropped tokens after a successful ICO */
255   /* - or have reclaimed their contributions in case of failed Crowdsale */
256   /* - are locked */
257   
258   mapping(address => bool) public airdropClaimed;
259   mapping(address => bool) public refundClaimed;
260   mapping(address => bool) public locked;
261 
262   // Events ---------------------------
263   
264   event WalletUpdated(address _newWallet);
265   event AdminWalletUpdated(address _newAdminWallet);
266   event TokensPerEthUpdated(uint _tokensPerEth);
267   event TokensMinted(address indexed _owner, uint _tokens, uint _balance);
268   event TokensIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
269   event Refund(address indexed _owner, uint _amount, uint _tokens);
270   event Airdrop(address indexed _owner, uint _amount, uint _balance);
271   event LockRemoved(address indexed _participant);
272 
273   // Basic Functions ------------------
274 
275   /* Initialize (owner is set to msg.sender by Owned.Owned() */
276 
277   function ZZZToken() {
278     require( TOKEN_SUPPLY_ICO + TOKEN_SUPPLY_MKT == TOKEN_SUPPLY_TOTAL );
279     wallet = owner;
280     adminWallet = owner;
281   }
282 
283   /* Fallback */
284   
285   function () payable {
286     buyTokens();
287   }
288   
289   // Information functions ------------
290   
291   /* What time is it? */
292   
293   function atNow() constant returns (uint) {
294     return now;
295   }
296   
297   /* Has the minimum threshold been reached? */
298   
299   function icoThresholdReached() constant returns (bool thresholdReached) {
300      if (tokensIssuedIco < MIN_FUNDING_GOAL) return false;
301      return true;
302   }  
303   
304   /* Are tokens transferable? */
305 
306   function isTransferable() constant returns (bool transferable) {
307      if ( !icoThresholdReached() ) return false;
308      if ( atNow() < DATE_ICO_END + COOLDOWN_PERIOD ) return false;
309      return true;
310   }
311   
312   // Lock functions -------------------
313 
314   /* Manage locked */
315 
316   function removeLock(address _participant) {
317     require( msg.sender == adminWallet || msg.sender == owner );
318     locked[_participant] = false;
319     LockRemoved(_participant);
320   }
321 
322   function removeLockMultiple(address[] _participants) {
323     require( msg.sender == adminWallet || msg.sender == owner );
324     for (uint i = 0; i < _participants.length; i++) {
325       locked[_participants[i]] = false;
326       LockRemoved(_participants[i]);
327     }
328   }
329 
330   // Owner Functions ------------------
331   
332   /* Change the crowdsale wallet address */
333 
334   function setWallet(address _wallet) onlyOwner {
335     require( _wallet != address(0x0) );
336     wallet = _wallet;
337     WalletUpdated(wallet);
338   }
339 
340   /* Change the admin wallet address */
341 
342   function setAdminWallet(address _wallet) onlyOwner {
343     require( _wallet != address(0x0) );
344     adminWallet = _wallet;
345     AdminWalletUpdated(adminWallet);
346   }
347 
348   /* Change tokensPerEth before ICO start */
349   
350   function updateTokensPerEth(uint _tokensPerEth) onlyOwner {
351     require( atNow() < DATE_PRESALE_START );
352     tokensPerEth = _tokensPerEth;
353     TokensPerEthUpdated(_tokensPerEth);
354   }
355 
356   /* Minting of marketing tokens by owner */
357 
358   function mintMarketing(address _participant, uint _tokens) onlyOwner {
359     // check amount
360     require( _tokens <= TOKEN_SUPPLY_MKT.sub(tokensIssuedMkt) );
361     
362     // update balances
363     balances[_participant] = balances[_participant].add(_tokens);
364     tokensIssuedMkt        = tokensIssuedMkt.add(_tokens);
365     tokensIssuedTotal      = tokensIssuedTotal.add(_tokens);
366     
367     // locked
368     locked[_participant] = true;
369     
370     // log the miniting
371     Transfer(0x0, _participant, _tokens);
372     TokensMinted(_participant, _tokens, balances[_participant]);
373   }
374 
375   /* Owner clawback of remaining funds after clawback period */
376   /* (for use in case of a failed Crwodsale) */
377   
378   function ownerClawback() external onlyOwner {
379     require( atNow() > DATE_ICO_END + CLAWBACK_PERIOD );
380     wallet.transfer(this.balance);
381   }
382 
383   /* Transfer out any accidentally sent ERC20 tokens */
384 
385   function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success) {
386       return ERC20Interface(tokenAddress).transfer(owner, amount);
387   }
388 
389   // Private functions ----------------
390 
391   /* Accept ETH during crowdsale (called by default function) */
392 
393   function buyTokens() private {
394     uint ts = atNow();
395     bool isPresale = false;
396     bool isIco = false;
397     uint tokens = 0;
398     
399     // minimum contribution
400     require( msg.value >= MIN_CONTRIBUTION );
401     
402     // one address transfer hard cap
403     require( icoEtherContributed[msg.sender].add(msg.value) <= MAX_CONTRIBUTION );
404 
405     // check dates for presale or ICO
406     if (ts > DATE_PRESALE_START && ts < DATE_PRESALE_END) isPresale = true;  
407     if (ts > DATE_ICO_START && ts < DATE_ICO_END) isIco = true;  
408     require( isPresale || isIco );
409 
410     // presale cap in Ether
411     if (isPresale) require( icoEtherReceived.add(msg.value) <= PRESALE_ETH_CAP );
412     
413     // get baseline number of tokens
414     tokens = tokensPerEth.mul(msg.value) / 1 ether;
415     
416     // apply bonuses (none for last week)
417     if (isPresale) {
418       tokens = tokens.mul(100 + BONUS_PRESALE) / 100;
419     } else if (ts < DATE_ICO_START + 7 days) {
420       // first week ico bonus
421       tokens = tokens.mul(100 + BONUS_ICO_WEEK_ONE) / 100;
422     } else if (ts < DATE_ICO_START + 14 days) {
423       // second week ico bonus
424       tokens = tokens.mul(100 + BONUS_ICO_WEEK_TWO) / 100;
425     }
426     
427     // ICO token volume cap
428     require( tokensIssuedIco.add(tokens) <= TOKEN_SUPPLY_ICO );
429 
430     // register tokens
431     balances[msg.sender]          = balances[msg.sender].add(tokens);
432     icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(tokens);
433     tokensIssuedIco               = tokensIssuedIco.add(tokens);
434     tokensIssuedTotal             = tokensIssuedTotal.add(tokens);
435     
436     // register Ether
437     icoEtherReceived                = icoEtherReceived.add(msg.value);
438     icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
439     
440     // locked
441     locked[msg.sender] = true;
442     
443     // log token issuance
444     Transfer(0x0, msg.sender, tokens);
445     TokensIssued(msg.sender, tokens, balances[msg.sender], msg.value);
446 
447     // transfer Ether if we're over the threshold
448     if ( icoThresholdReached() ) wallet.transfer(this.balance);
449   }
450   
451   // ERC20 functions ------------------
452 
453   /* Override "transfer" (ERC20) */
454 
455   function transfer(address _to, uint _amount) returns (bool success) {
456     require( isTransferable() );
457     require( locked[msg.sender] == false );
458     require( locked[_to] == false );
459     return super.transfer(_to, _amount);
460   }
461   
462   /* Override "transferFrom" (ERC20) */
463 
464   function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
465     require( isTransferable() );
466     require( locked[_from] == false );
467     require( locked[_to] == false );
468     return super.transferFrom(_from, _to, _amount);
469   }
470 
471   // External functions ---------------
472 
473   /* Reclaiming of funds by contributors in case of a failed crowdsale */
474   /* (it will fail if account is empty after ownerClawback) */
475 
476   /* While there could not have been any token transfers yet, a contributor */
477   /* may have received minted tokens, so the token balance after a refund */ 
478   /* may still be positive */
479   
480   function reclaimFunds() external {
481     uint tokens; // tokens to destroy
482     uint amount; // refund amount
483     
484     // ico is finished and was not successful
485     require( atNow() > DATE_ICO_END && !icoThresholdReached() );
486     
487     // check if refund has already been claimed
488     require( !refundClaimed[msg.sender] );
489     
490     // check if there is anything to refund
491     require( icoEtherContributed[msg.sender] > 0 );
492     
493     // update variables affected by refund
494     tokens = icoTokensReceived[msg.sender];
495     amount = icoEtherContributed[msg.sender];
496 
497     balances[msg.sender] = balances[msg.sender].sub(tokens);
498     tokensIssuedTotal    = tokensIssuedTotal.sub(tokens);
499     
500     refundClaimed[msg.sender] = true;
501     
502     // transfer out refund
503     msg.sender.transfer(amount);
504     
505     // log
506     Transfer(msg.sender, 0x0, tokens);
507     Refund(msg.sender, amount, tokens);
508   }
509 
510   /* Claiming of "airdropped" tokens in case of successful crowdsale */
511   /* Can be done by token holder, or by adminWallet */ 
512 
513   function claimAirdrop() external {
514     doAirdrop(msg.sender);
515   }
516 
517   function adminClaimAirdrop(address _participant) external {
518     require( msg.sender == adminWallet );
519     doAirdrop(_participant);
520   }
521 
522   function adminClaimAirdropMultiple(address[] _addresses) external {
523     require( msg.sender == adminWallet );
524     for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i]);
525   }  
526   
527   function doAirdrop(address _participant) internal {
528     uint airdrop = computeAirdrop(_participant);
529 
530     require( airdrop > 0 );
531 
532     // update balances and token issue volume
533     airdropClaimed[_participant] = true;
534     balances[_participant] = balances[_participant].add(airdrop);
535     tokensIssuedTotal      = tokensIssuedTotal.add(airdrop);
536     tokensClaimedAirdrop   = tokensClaimedAirdrop.add(airdrop);
537     
538     // log
539     Airdrop(_participant, airdrop, balances[_participant]);
540     Transfer(0x0, _participant, airdrop);
541   }
542 
543   /* Function to estimate airdrop amount. For some accounts, the value of */
544   /* tokens received by calling claimAirdrop() may be less than gas costs */
545   
546   /* If an account has tokens from the ico, the amount after the airdrop */
547   /* will be newBalance = tokens * TOKEN_SUPPLY_ICO / tokensIssuedIco */
548       
549   function computeAirdrop(address _participant) constant returns (uint airdrop) {
550     // return 0 if it's too early or ico was not successful
551     if ( atNow() < DATE_ICO_END || !icoThresholdReached() ) return 0;
552     
553     // return  0 is the airdrop was already claimed
554     if( airdropClaimed[_participant] ) return 0;
555 
556     // return 0 if the account does not hold any crowdsale tokens
557     if( icoTokensReceived[_participant] == 0 ) return 0;
558     
559     // airdrop amount
560     uint tokens = icoTokensReceived[_participant];
561     uint newBalance = tokens.mul(TOKEN_SUPPLY_ICO) / tokensIssuedIco;
562     airdrop = newBalance - tokens;
563   }  
564 
565   /* Multiple token transfers from one address to save gas */
566   /* (longer _amounts array not accepted = sanity check) */
567 
568   function transferMultiple(address[] _addresses, uint[] _amounts) external {
569     require( isTransferable() );
570     require( locked[msg.sender] == false );
571     require( _addresses.length == _amounts.length );
572     for (uint i = 0; i < _addresses.length; i++) {
573       if (locked[_addresses[i]] == false) super.transfer(_addresses[i], _amounts[i]);
574     }
575   }  
576 
577 }