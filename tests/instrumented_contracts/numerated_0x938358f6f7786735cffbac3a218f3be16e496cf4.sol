1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 //
5 //  HODLwin sale contract
6 //
7 //  For details, please visit: https://www.HODLwin.com
8 //
9 //  There is a clue to our 5% token giveaway contest in this code  
10 //  and also a couple of other surprises, good luck
11 //  Remember to win the prize you and get the remaining clues you
12 //  must be a token holder and registered for the contest on our
13 //  webpage. https://www.hodlwin.com
14 //
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 //
20 // SafeMath3
21 //
22 // Adapted from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
23 // (no need to implement division)
24 //
25 // ----------------------------------------------------------------------------
26 
27 library SafeMath3 {
28 
29   function mul(uint a, uint b) internal pure returns (uint c) {
30     c = a * b;
31     assert(a == 0 || c / a == b);
32   }
33 
34   function sub(uint a, uint b) internal pure returns (uint) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint a, uint b) internal pure returns (uint c) {
40     c = a + b;
41     assert(c >= a);
42   }
43 
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 //
49 // Owned contract
50 //
51 // ----------------------------------------------------------------------------
52 
53 contract Owned {
54 
55   address public owner;
56   address public newOwner;
57 
58   // Events ---------------------------
59 
60   event OwnershipTransferProposed(address indexed _from, address indexed _to);
61   event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63   // Modifier -------------------------
64 
65   modifier onlyOwner {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   // Functions ------------------------
71 
72   function Owned() public {
73     owner = msg.sender;
74   }
75 
76   function transferOwnership(address _newOwner) public onlyOwner {
77     require(_newOwner != owner);
78     require(_newOwner != address(0x0));
79     OwnershipTransferProposed(owner, _newOwner);
80     newOwner = _newOwner;
81   }
82 
83   function acceptOwnership() public {
84     require(msg.sender == newOwner);
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 //
94 // ERC Token Standard #20 Interface
95 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
96 // Clue-1 the password is a quote from a famous person, for more clues
97 // read the comments in this code carefully, register for the competion for the 
98 // easier clues on our website www.hodlwin.com, plus keep an eye out for other 
99 // bounties below.
100 // ----------------------------------------------------------------------------
101 
102 contract ERC20Interface {
103 
104   // Events ---------------------------
105 
106   event Transfer(address indexed _from, address indexed _to, uint _value);
107   event Approval(address indexed _owner, address indexed _spender, uint _value);
108 
109   // Functions ------------------------
110 
111   function totalSupply() public constant returns (uint);
112   function balanceOf(address _owner) public constant returns (uint balance);
113   function transfer(address _to, uint _value) public returns (bool success);
114   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
115   function approve(address _spender, uint _value) public returns (bool success);
116   function allowance(address _owner, address _spender) public constant returns (uint remaining);
117 
118 }
119 
120 
121 // ----------------------------------------------------------------------------
122 //
123 // ERC Token Standard #20
124 //
125 // ----------------------------------------------------------------------------
126 
127 contract ERC20Token is ERC20Interface, Owned {
128   
129   using SafeMath3 for uint;
130 
131   uint public tokensIssuedTotal = 0;
132   mapping(address => uint) balances;
133   mapping(address => mapping (address => uint)) allowed;
134 
135   // Functions ------------------------
136 
137   /* Total token supply */
138 
139   function totalSupply() public constant returns (uint) {
140     return tokensIssuedTotal;
141   }
142 
143   /* Get the account balance for an address */
144 
145   function balanceOf(address _owner) public constant returns (uint balance) {
146     return balances[_owner];
147   }
148 
149   /* Transfer the balance from owner's account to another account */
150 
151   function transfer(address _to, uint _amount) public returns (bool success) {
152     // amount sent cannot exceed balance
153     require(balances[msg.sender] >= _amount);
154 
155     // update balances
156     balances[msg.sender] = balances[msg.sender].sub(_amount);
157     balances[_to] = balances[_to].add(_amount);
158 
159     // log event
160     Transfer(msg.sender, _to, _amount);
161     return true;
162   }
163 
164   /* Allow _spender to withdraw from your account up to _amount */
165 
166   function approve(address _spender, uint _amount) public returns (bool success) {
167     // approval amount cannot exceed the balance
168     require(balances[msg.sender] >= _amount);
169       
170     // update allowed amount
171     allowed[msg.sender][_spender] = _amount;
172     
173     // log event
174     Approval(msg.sender, _spender, _amount);
175     return true;
176   }
177 
178   /* Spender of tokens transfers tokens from the owner's balance */
179   /* Must be pre-approved by owner */
180 
181   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
182     // balance checks
183     require(balances[_from] >= _amount);
184     require(allowed[_from][msg.sender] >= _amount);
185 
186     // update balances and allowed amount
187     balances[_from] = balances[_from].sub(_amount);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
189     balances[_to] = balances[_to].add(_amount);
190 
191     // log event
192     Transfer(_from, _to, _amount);
193     return true;
194   }
195 
196   /* Returns the amount of tokens approved by the owner */
197   /* that can be transferred by spender */
198 
199   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
200     return allowed[_owner][_spender];
201   }
202 
203 }
204 
205 
206 // ----------------------------------------------------------------------------
207 //
208 // WIN public token sale
209 //
210 // ----------------------------------------------------------------------------
211 
212 contract HODLwin is ERC20Token {
213 
214   /* Utility variable */
215   
216   
217   /* Basic token data */
218 
219   string public constant name = "HODLwin";
220   string public constant symbol = "WIN";
221   uint8  public constant decimals = 18;
222 
223   /* Wallet addresses - initially set to owner at deployment */
224   
225   address public wallet;
226   address public adminWallet;
227 
228   /* ICO dates */
229 
230   uint public constant DATE_PRESALE_START = 1518105804; // (GMT): Thursday, 8 February 2018 14:24:58
231   uint public constant DATE_PRESALE_END   = 1523019600; // (GMT): Friday, 6 April 2018 13:00:00
232 
233   uint public constant DATE_ICO_START = 1523019600; // (GMT): Friday, 6 April 2018 13:00:00
234   uint public constant DATE_ICO_END   = 1530882000; // (GMT): Friday, 6 July 2018 13:00:00
235 
236   /* ICO tokens per ETH */
237   
238   uint public tokensPerEth = 1000 * 10**18; // rate during public ICO after bonus period
239                                                 //-------------------------
240   uint public constant BONUS_PRESALE      = 50;// Clue-2 pyethrecover may 
241   uint public constant BONUS_ICO_PERIOD_ONE = 20;// be useful once you receive
242   uint public constant BONUS_ICO_PERIOD_TWO = 10;// further clues                
243                                                 //-------------------------
244   /* Other ICO parameters */  
245   
246   uint public constant TOKEN_SUPPLY_TOTAL = 100000000 * 10**18; // 100 mm tokens
247   uint public constant TOKEN_SUPPLY_ICO   = 50000000 * 10**18; // 50 mm tokens avalibale for presale and public
248   uint public constant TOKEN_SUPPLY_AIR   = 50000000 * 10**18; //  50 mm tokens, all team tokens, airdrop, bounties will be sent publicly using this so everything is transparent
249 
250   uint public constant PRESALE_ETH_CAP =  10000 ether;
251 
252   uint public constant MIN_FUNDING_GOAL =  100 * 10**18 ; //
253   
254   uint public constant MIN_CONTRIBUTION = 1 ether / 20; // 0.05 Ether
255   uint public constant MAX_CONTRIBUTION = 10000 ether;
256 
257   uint public constant COOLDOWN_PERIOD =  1 days;
258   uint public constant CLAWBACK_PERIOD = 90 days;
259 
260   /* Crowdsale variables */
261 
262   uint public icoEtherReceived = 0; // Ether actually received by the contract
263 
264   uint public tokensIssuedIco   = 0;
265   uint public tokensIssuedAir   = 0;
266   
267 
268   /* Keep track of Ether contributed and tokens received during Crowdsale */
269   
270   mapping(address => uint) public icoEtherContributed;
271   mapping(address => uint) public icoTokensReceived;
272 
273   /* Keep track of participants who 
274    /* have reclaimed their contributions in case of failed Crowdsale */
275 
276    mapping(address => bool) public refundClaimed;
277  
278 
279   // Events ---------------------------
280   
281   event WalletUpdated(address _newWallet);
282   event AdminWalletUpdated(address _newAdminWallet);
283   event TokensPerEthUpdated(uint _tokensPerEth);
284   event TokensMinted(address indexed _owner, uint _tokens, uint _balance);
285   event TokensIssued(address indexed _owner, uint _tokens, uint _balance, uint _etherContributed);
286   event Refund(address indexed _owner, uint _amount, uint _tokens);
287  
288 
289   // Basic Functions ------------------
290 
291   /* Initialize (owner is set to msg.sender by Owned.Owned() */
292 
293   function HODLwin () public {
294     require(TOKEN_SUPPLY_ICO + TOKEN_SUPPLY_AIR == TOKEN_SUPPLY_TOTAL);
295     wallet = owner;
296     adminWallet = owner;
297   }
298 
299   /* Fallback */
300   
301   function () public payable {
302     buyTokens();
303   }
304   
305   // Information functions ------------
306   
307   /* What time is it? */
308   
309   function atNow() public constant returns (uint) {
310     return now;
311   }
312   
313   /* Has the minimum threshold been reached? */
314   
315   function icoThresholdReached() public constant returns (bool thresholdReached) {
316      if (icoEtherReceived < MIN_FUNDING_GOAL) {
317         return false; 
318      }
319      return true;
320   }  
321   
322   /* Are tokens transferable? */
323 
324   function isTransferable() public constant returns (bool transferable) {
325      if (!icoThresholdReached()) { 
326          return false;
327          }
328      if (atNow() < DATE_ICO_END + COOLDOWN_PERIOD) {
329           return false; 
330           }
331      return true;
332   }
333   
334   // Owner Functions ------------------
335   
336   /* Change the crowdsale wallet address */
337 
338   function setWallet(address _wallet) public onlyOwner {
339     require(_wallet != address(0x0));
340     wallet = _wallet;
341     WalletUpdated(wallet);
342   }
343 
344   /* Change the admin wallet address */
345 
346   function setAdminWallet(address _wallet) public onlyOwner {
347     require(_wallet != address(0x0));
348     adminWallet = _wallet;
349     AdminWalletUpdated(adminWallet);
350   }
351 
352   /* Change tokensPerEth before ICO start */
353   
354   function updateTokensPerEth(uint _tokensPerEth) public onlyOwner {
355     require(atNow() < DATE_PRESALE_START);
356     tokensPerEth = _tokensPerEth;
357     TokensPerEthUpdated(_tokensPerEth);
358   }
359 
360   /* Minting of airdrop tokens by owner */
361 
362   function mintAirdrop(address _participant, uint _tokens) public onlyOwner {
363     // check amount
364     require(_tokens <= TOKEN_SUPPLY_AIR.sub(tokensIssuedAir));
365     require(_tokens.mul(10) <= TOKEN_SUPPLY_AIR);//to prevent mistakenly sending too many tokens to one address in airdrop
366     // update balances
367     balances[_participant] = balances[_participant].add(_tokens);
368     tokensIssuedAir = tokensIssuedAir.add(_tokens);
369     tokensIssuedTotal = tokensIssuedTotal.add(_tokens);
370 
371     // log the miniting
372     Transfer(0x0, _participant, _tokens);
373     TokensMinted(_participant, _tokens, balances[_participant]);
374   }
375 
376 function mintMultiple(address[] _addresses, uint _tokens) public onlyOwner {
377     require(msg.sender == adminWallet);
378     require(_tokens.mul(10) <= TOKEN_SUPPLY_AIR);//to prevent mistakenly sending all tokens to one address in airdrop
379     for (uint i = 0; i < _addresses.length; i++) {
380      mintAirdrop(_addresses[i], _tokens);
381         }
382     
383   }  
384   
385   /* Owner clawback of remaining funds after clawback period */
386   /* (for use in case of a failed Crwodsale) */
387   
388   function ownerClawback() external onlyOwner {
389     require(atNow() > DATE_ICO_END + CLAWBACK_PERIOD);
390     wallet.transfer(this.balance);
391   }
392 
393   /* Transfer out any accidentally sent ERC20 tokens */
394 
395   function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
396       return ERC20Interface(tokenAddress).transfer(owner, amount);
397   }
398 
399   // Private functions ----------------
400 
401 //caspsareimportant
402 //---------------------------------------------------------------------
403 // the first PeRson to send an email to hodlwin at (info@hodlwin.com) with the
404 // subject title as "first" and also in the Email State the wallet address
405 // used to buy theIr hodlwin tokens will win 1000 hodlwin tkns and 0.1 eth
406 // these will be sent as soon as we verify that you are a hoDlwin token hodlr
407 // the tokEns and 0.1 eth will be seNT to the address you used for the token
408 // sale.you must have conrtibuted the minimum 0.05eth to the token sale to 
409 // win this competetion.when its won it will be announced on our website in
410 // the Updates section. Or you can watch the blockchain and See the pAyment
411 //------------------------------------------------------------------------
412 
413   /* Accept ETH during crowdsale (called by default function) */
414   function buyTokens() private {
415     uint ts = atNow();
416     bool isPresale = false;
417     bool isIco = false;
418     uint tokens = 0;
419     
420     // minimum contribution
421     require(msg.value >= MIN_CONTRIBUTION);
422     
423     // one address transfer hard cap
424     require(icoEtherContributed[msg.sender].add(msg.value) <= MAX_CONTRIBUTION);
425 
426     // check dates for presale or ICO
427     if (ts > DATE_PRESALE_START && ts < DATE_PRESALE_END) {
428          isPresale = true; 
429          }
430     if (ts > DATE_ICO_START && ts < DATE_ICO_END) {
431          isIco = true; 
432          }
433     if (ts > DATE_PRESALE_START && ts < DATE_ICO_END && icoEtherReceived >= PRESALE_ETH_CAP) { 
434         isIco = true; 
435         }
436     if (ts > DATE_PRESALE_START && ts < DATE_ICO_END && icoEtherReceived >= PRESALE_ETH_CAP) {
437          isPresale = false;
438           }
439 
440     require(isPresale || isIco);
441 
442     // presale cap in Ether
443     if (isPresale) {
444         require(icoEtherReceived.add(msg.value) <= PRESALE_ETH_CAP);
445     }
446     
447     // get baseline number of tokens
448     tokens = tokensPerEth.mul(msg.value) / 1 ether;
449     
450     // apply bonuses (none for last PERIOD)
451     if (isPresale) {
452       tokens = tokens.mul(100 + BONUS_PRESALE) / 100;
453     } else if (ts < DATE_ICO_START + 21 days) {
454       // first PERIOD ico bonus
455       tokens = tokens.mul(100 + BONUS_ICO_PERIOD_ONE) / 100;
456     } else if (ts < DATE_ICO_START + 42 days) {
457       // second PERIOD ico bonus
458       tokens = tokens.mul(100 + BONUS_ICO_PERIOD_TWO) / 100;
459     }
460     
461     // ICO token volume cap
462     require(tokensIssuedIco.add(tokens) <= TOKEN_SUPPLY_ICO );
463 
464     // register tokens
465     balances[msg.sender] = balances[msg.sender].add(tokens);
466     icoTokensReceived[msg.sender] = icoTokensReceived[msg.sender].add(tokens);
467     tokensIssuedIco = tokensIssuedIco.add(tokens);
468     tokensIssuedTotal = tokensIssuedTotal.add(tokens);
469     
470     // register Ether
471     icoEtherReceived = icoEtherReceived.add(msg.value);
472     icoEtherContributed[msg.sender] = icoEtherContributed[msg.sender].add(msg.value);
473     
474     
475     // log token issuance
476     Transfer(0x0, msg.sender, tokens);
477     TokensIssued(msg.sender, tokens, balances[msg.sender], msg.value);
478 
479     // transfer Ether if we're over the threshold
480     if (icoThresholdReached()) {
481         wallet.transfer(this.balance);
482      }
483   }
484   
485   // ERC20 functions ------------------
486 
487   /* Override "transfer" (ERC20) */
488 
489   function transfer(address _to, uint _amount) public returns (bool success) {
490     require(isTransferable());
491       return super.transfer(_to, _amount);
492   }
493   
494   /* Override "transferFrom" (ERC20) */
495 
496   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
497     require(isTransferable());
498     return super.transferFrom(_from, _to, _amount);
499   }
500 ////caspsareimportant
501 //---------------------------------------------------------------------
502 // the next 20 people to send an email to hodlwin at (info@hodlwin.com) with the
503 // subject title as "second" and also in the email state the Wallet address
504 // used to buy their hOdlLwin tokens will win 1000 hODlwin tkns 
505 // these will be sent as soon as we veRify that you are a hOdlwin token hodlr
506 // the tokens will be sent to the address you used for the token
507 // sale. you must have conrtibuted the minimum 0.05eth to the token sale to 
508 // Win this competetion. when its won it will be announced on our website in
509 // the updates section. or you can look at the blockchain
510 //------------------------------------------------------------------------
511   // External functions ---------------
512 
513   /* Reclaiming of funds by contributors in case of a failed crowdsale */
514   /* (it will fail if account is empty after ownerClawback) */
515 
516   /* While there could not have been any token transfers yet, a contributor */
517   /* may have received minted tokens, so the token balance after a refund */ 
518   /* may still be positive */
519   
520   function reclaimFunds() external {
521     uint tokens; // tokens to destroy
522     uint amount; // refund amount
523     
524     // ico is finished and was not successful
525     require(atNow() > DATE_ICO_END && !icoThresholdReached());
526     
527     // check if refund has already been claimed
528     require(!refundClaimed[msg.sender]);
529     
530     // check if there is anything to refund
531     require(icoEtherContributed[msg.sender] > 0);
532     
533     // update variables affected by refund
534     tokens = icoTokensReceived[msg.sender];
535     amount = icoEtherContributed[msg.sender];
536    
537     balances[msg.sender] = balances[msg.sender].sub(tokens);
538     tokensIssuedTotal = tokensIssuedTotal.sub(tokens);
539     
540     refundClaimed[msg.sender] = true;
541     
542     // transfer out refund
543     msg.sender.transfer(amount);
544     
545     // log
546     Transfer(msg.sender, 0x0, tokens);
547     Refund(msg.sender, amount, tokens);
548   }
549 
550   function transferMultiple(address[] _addresses, uint[] _amounts) external {
551     require(isTransferable());
552   
553     require(_addresses.length == _amounts.length);
554     for (uint i = 0; i < _addresses.length; i++) {
555      super.transfer(_addresses[i], _amounts[i]);
556     }
557   }  
558 
559 }