1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // BULB TulipMania token public sale contract
6 //
7 // For details, please visit: https://tulipmania.co
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
199 // TulipMania public token sale
200 //
201 // ----------------------------------------------------------------------------
202 
203 contract TulipMania is ERC20Token {
204 
205   /* Utility variable */
206   
207   uint constant E6 = 10**6;
208   
209   /* Basic token data */
210 
211   string public constant name     = "Tulip Mania";
212   string public constant symbol   = "BULB";
213   uint8  public constant decimals = 6;
214 
215   /* Wallet addresses - initially set to owner at deployment */
216   
217   address public wallet;
218   address public adminWallet;
219 
220   /* ICO dates */
221 
222   uint public constant DATE_PRESALE_START = 1510758000; // 15-Nov-2017 15:00 UTC
223   uint public constant DATE_PRESALE_END   = 1511362800; // 22-Nov-2017 15:00 UTC
224 
225   uint public constant DATE_ICO_START = 1511362801; // 22-Nov-2017 15:00:01 UTC
226   uint public constant DATE_ICO_END   = 1513868400; // 21-Dec-2017 15:00 UTC
227 
228   /* ICO tokens per ETH */
229   
230   uint public tokensPerEth = 336 * E6;
231   uint public constant BONUS_PRESALE = 100;
232 
233   /* Other ICO parameters */  
234   
235   uint public constant TOKEN_SUPPLY_TOTAL = 10000000 * E6; // 10M tokens
236   uint public constant TOKEN_SUPPLY_ICO   = 8500000 * E6; // 8.5M tokens
237   uint public constant TOKEN_SUPPLY_MKT   =  1500000 * E6; //  1.5M tokens
238 
239   uint public constant PRESALE_ETH_CAP =  750 ether;
240 
241   uint public constant MIN_CONTRIBUTION = 1 ether / 500; // 0.002 Ether
242   uint public constant MAX_CONTRIBUTION = 300 ether;
243 
244   uint public constant COOLDOWN_PERIOD =  2 days;
245   uint public constant CLAWBACK_PERIOD = 2 days;
246 
247   /* Crowdsale variables */
248 
249   uint public icoEtherReceived = 0; // Ether actually received by the contract
250 
251   uint public tokensIssuedIco   = 0;
252   uint public tokensIssuedMkt   = 0;
253   
254   uint public tokensClaimedAirdrop = 0;
255   
256   /* Keep track of Ether contributed and tokens received during Crowdsale */
257   
258   mapping(address => uint) public icoEtherContributed;
259   mapping(address => uint) public icoTokensReceived;
260 
261   /* Keep track of participants who 
262   /* - have received their airdropped tokens after a successful ICO */
263   /* - or have reclaimed their contributions in case of failed Crowdsale */
264   /* - are locked */
265   
266   mapping(address => bool) public airdropClaimed;
267   mapping(address => bool) public refundClaimed;
268   mapping(address => bool) public locked;
269 
270   // Events ---------------------------
271   
272   event WalletUpdated(address _newWallet);
273   event AdminWalletUpdated(address _newAdminWallet);
274   event TokensPerEthUpdated(uint _tokensPerEth);
275   event TokensMinted(address indexed _owner, uint _tokens, uint _balance);
276   event TokensIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
277   event Refund(address indexed _owner, uint _amount, uint _tokens);
278   event Airdrop(address indexed _owner, uint _amount, uint _balance);
279   event LockRemoved(address indexed _participant);
280 
281   // Basic Functions ------------------
282 
283   /* Initialize (owner is set to msg.sender by Owned.Owned() */
284 
285   function TulipMania() {
286     require( TOKEN_SUPPLY_ICO + TOKEN_SUPPLY_MKT == TOKEN_SUPPLY_TOTAL );
287     wallet = owner;
288     adminWallet = owner;
289   }
290 
291   /* Fallback */
292   
293   function () payable {
294     buyTokens();
295   }
296   
297   // Information functions ------------
298   
299   /* What time is it? */
300   
301   function atNow() constant returns (uint) {
302     return now;
303   }
304   
305   /* Are tokens transferable? */
306 
307   function isTransferable() constant returns (bool transferable) {
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
370     // log the minting
371     Transfer(0x0, _participant, _tokens);
372     TokensMinted(_participant, _tokens, balances[_participant]);
373   }
374 
375   /* Owner clawback of remaining funds after clawback period */
376   /* (for use in case of a failed Crowdsale) */
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
416     // apply presale bonus
417     if (isPresale) {
418       tokens = tokens.mul(100 + BONUS_PRESALE) / 100;
419     }
420     
421     // ICO token volume cap
422     require( tokensIssuedIco.add(tokens) <= TOKEN_SUPPLY_ICO );
423 
424     // register tokens
425     balances[msg.sender]          = balances[msg.sender].add(tokens);
426     icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(tokens);
427     tokensIssuedIco               = tokensIssuedIco.add(tokens);
428     tokensIssuedTotal             = tokensIssuedTotal.add(tokens);
429     
430     // register Ether
431     icoEtherReceived                = icoEtherReceived.add(msg.value);
432     icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
433     
434     // locked
435     locked[msg.sender] = true;
436     
437     // log token issuance
438     Transfer(0x0, msg.sender, tokens);
439     TokensIssued(msg.sender, tokens, balances[msg.sender], msg.value);
440 
441     wallet.transfer(this.balance);
442   }
443   
444   // ERC20 functions ------------------
445 
446   /* Override "transfer" (ERC20) */
447 
448   function transfer(address _to, uint _amount) returns (bool success) {
449     require( isTransferable() );
450     require( locked[msg.sender] == false );
451     require( locked[_to] == false );
452     return super.transfer(_to, _amount);
453   }
454   
455   /* Override "transferFrom" (ERC20) */
456 
457   function transferFrom(address _from, address _to, uint _amount) returns (bool success) {
458     require( isTransferable() );
459     require( locked[_from] == false );
460     require( locked[_to] == false );
461     return super.transferFrom(_from, _to, _amount);
462   }
463 
464   // External functions ---------------
465 
466   /* Reclaiming of funds by contributors in case of a failed crowdsale */
467   /* (it will fail if account is empty after ownerClawback) */
468 
469   /* While there could not have been any token transfers yet, a contributor */
470   /* may have received minted tokens, so the token balance after a refund */ 
471   /* may still be positive */
472   
473   function reclaimFunds() external {
474     uint tokens; // tokens to destroy
475     uint amount; // refund amount
476     
477     // ico is finished
478     require( atNow() > DATE_ICO_END);
479     
480     // check if refund has already been claimed
481     require( !refundClaimed[msg.sender] );
482     
483     // check if there is anything to refund
484     require( icoEtherContributed[msg.sender] > 0 );
485     
486     // update variables affected by refund
487     tokens = icoTokensReceived[msg.sender];
488     amount = icoEtherContributed[msg.sender];
489 
490     balances[msg.sender] = balances[msg.sender].sub(tokens);
491     tokensIssuedTotal    = tokensIssuedTotal.sub(tokens);
492     
493     refundClaimed[msg.sender] = true;
494     
495     // transfer out refund
496     msg.sender.transfer(amount);
497     
498     // log
499     Transfer(msg.sender, 0x0, tokens);
500     Refund(msg.sender, amount, tokens);
501   }
502 
503   /* Claiming of "airdropped" tokens in case of successful crowdsale */
504   /* Can be done by token holder, or by adminWallet */ 
505 
506   function claimAirdrop() external {
507     doAirdrop(msg.sender);
508   }
509 
510   function adminClaimAirdrop(address _participant) external {
511     require( msg.sender == adminWallet );
512     doAirdrop(_participant);
513   }
514 
515   function adminClaimAirdropMultiple(address[] _addresses) external {
516     require( msg.sender == adminWallet );
517     for (uint i = 0; i < _addresses.length; i++) doAirdrop(_addresses[i]);
518   }  
519   
520   function doAirdrop(address _participant) internal {
521     uint airdrop = computeAirdrop(_participant);
522 
523     require( airdrop > 0 );
524 
525     // update balances and token issue volume
526     airdropClaimed[_participant] = true;
527     balances[_participant] = balances[_participant].add(airdrop);
528     tokensIssuedTotal      = tokensIssuedTotal.add(airdrop);
529     tokensClaimedAirdrop   = tokensClaimedAirdrop.add(airdrop);
530     
531     // log
532     Airdrop(_participant, airdrop, balances[_participant]);
533     Transfer(0x0, _participant, airdrop);
534   }
535 
536   /* Function to estimate airdrop amount. For some accounts, the value of */
537   /* tokens received by calling claimAirdrop() may be less than gas costs */
538   
539   /* If an account has tokens from the ico, the amount after the airdrop */
540   /* will be newBalance = tokens * TOKEN_SUPPLY_ICO / tokensIssuedIco */
541       
542   function computeAirdrop(address _participant) constant returns (uint airdrop) {
543     // return 0 if it's too early
544     if ( atNow() < DATE_ICO_END ) return 0;
545     
546     // return 0 if the airdrop was already claimed
547     if( airdropClaimed[_participant] ) return 0;
548 
549     // return 0 if the account does not hold any crowdsale tokens
550     if( icoTokensReceived[_participant] == 0 ) return 0;
551     
552     // airdrop amount
553     uint tokens = icoTokensReceived[_participant];
554     uint newBalance = tokens.mul(TOKEN_SUPPLY_ICO) / tokensIssuedIco;
555     airdrop = newBalance - tokens;
556   }  
557 
558   /* Multiple token transfers from one address to save gas */
559   /* (longer _amounts array not accepted = sanity check) */
560 
561   function transferMultiple(address[] _addresses, uint[] _amounts) external {
562     require( isTransferable() );
563     require( locked[msg.sender] == false );
564     require( _addresses.length == _amounts.length );
565     for (uint i = 0; i < _addresses.length; i++) {
566       if (locked[_addresses[i]] == false) super.transfer(_addresses[i], _amounts[i]);
567     }
568   }  
569 
570 }