1 pragma solidity ^0.4.20;
2 
3 // ----------------------------------------------------------------------------
4 //
5 // GZR 'Gizer Gaming' token public sale contract
6 //
7 // For details, please visit: http://www.gizer.io
8 //
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 //
14 // SafeMath
15 //
16 // ----------------------------------------------------------------------------
17 
18 library SafeMath {
19 
20   function add(uint a, uint b) internal pure returns (uint c) {
21     c = a + b;
22     require( c >= a );
23   }
24 
25   function sub(uint a, uint b) internal pure returns (uint c) {
26     require( b <= a );
27     c = a - b;
28   }
29 
30   function mul(uint a, uint b) internal pure returns (uint c) {
31     c = a * b;
32     require( a == 0 || c / a == b );
33   }
34 
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 //
40 // Owned contract
41 //
42 // ----------------------------------------------------------------------------
43 
44 contract Owned {
45 
46   address public owner;
47   address public newOwner;
48 
49   mapping(address => bool) public isAdmin;
50 
51   // Events ---------------------------
52 
53   event OwnershipTransferProposed(address indexed _from, address indexed _to);
54   event OwnershipTransferred(address indexed _from, address indexed _to);
55   event AdminChange(address indexed _admin, bool _status);
56 
57   // Modifiers ------------------------
58 
59   modifier onlyOwner { require( msg.sender == owner ); _; }
60   modifier onlyAdmin { require( isAdmin[msg.sender] ); _; }
61 
62   // Functions ------------------------
63 
64   function Owned() public {
65     owner = msg.sender;
66     isAdmin[owner] = true;
67   }
68 
69   function transferOwnership(address _newOwner) public onlyOwner {
70     require( _newOwner != address(0x0) );
71     OwnershipTransferProposed(owner, _newOwner);
72     newOwner = _newOwner;
73   }
74 
75   function acceptOwnership() public {
76     require(msg.sender == newOwner);
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80   
81   function addAdmin(address _a) public onlyOwner {
82     require( isAdmin[_a] == false );
83     isAdmin[_a] = true;
84     AdminChange(_a, true);
85   }
86 
87   function removeAdmin(address _a) public onlyOwner {
88     require( isAdmin[_a] == true );
89     isAdmin[_a] = false;
90     AdminChange(_a, false);
91   }
92   
93 }
94 
95 
96 // ----------------------------------------------------------------------------
97 //
98 // ERC Token Standard #20 Interface
99 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
100 //
101 // ----------------------------------------------------------------------------
102 
103 contract ERC20Interface {
104 
105   // Events ---------------------------
106 
107   event Transfer(address indexed _from, address indexed _to, uint _value);
108   event Approval(address indexed _owner, address indexed _spender, uint _value);
109 
110   // Functions ------------------------
111 
112   function totalSupply() public view returns (uint);
113   function balanceOf(address _owner) public view returns (uint balance);
114   function transfer(address _to, uint _value) public returns (bool success);
115   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
116   function approve(address _spender, uint _value) public returns (bool success);
117   function allowance(address _owner, address _spender) public view returns (uint remaining);
118 
119 }
120 
121 
122 // ----------------------------------------------------------------------------
123 //
124 // ERC Token Standard #20
125 //
126 // ----------------------------------------------------------------------------
127 
128 contract ERC20Token is ERC20Interface, Owned {
129   
130   using SafeMath for uint;
131 
132   uint public tokensIssuedTotal = 0;
133   mapping(address => uint) balances;
134   mapping(address => mapping (address => uint)) allowed;
135 
136   // Functions ------------------------
137 
138   /* Total token supply */
139 
140   function totalSupply() public view returns (uint) {
141     return tokensIssuedTotal;
142   }
143 
144   /* Get the account balance for an address */
145 
146   function balanceOf(address _owner) public view returns (uint balance) {
147     return balances[_owner];
148   }
149 
150   /* Transfer the balance from owner's account to another account */
151 
152   function transfer(address _to, uint _amount) public returns (bool success) {
153     // amount sent cannot exceed balance
154     require( balances[msg.sender] >= _amount );
155 
156     // update balances
157     balances[msg.sender] = balances[msg.sender].sub(_amount);
158     balances[_to]        = balances[_to].add(_amount);
159 
160     // log event
161     Transfer(msg.sender, _to, _amount);
162     return true;
163   }
164 
165   /* Allow _spender to withdraw from your account up to _amount */
166 
167   function approve(address _spender, uint _amount) public returns (bool success) {
168     // approval amount cannot exceed the balance
169     require( balances[msg.sender] >= _amount );
170       
171     // update allowed amount
172     allowed[msg.sender][_spender] = _amount;
173     
174     // log event
175     Approval(msg.sender, _spender, _amount);
176     return true;
177   }
178 
179   /* Spender of tokens transfers tokens from the owner's balance */
180   /* Must be pre-approved by owner */
181 
182   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
183     // balance checks
184     require( balances[_from] >= _amount );
185     require( allowed[_from][msg.sender] >= _amount );
186 
187     // update balances and allowed amount
188     balances[_from]            = balances[_from].sub(_amount);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
190     balances[_to]              = balances[_to].add(_amount);
191 
192     // log event
193     Transfer(_from, _to, _amount);
194     return true;
195   }
196 
197   /* Returns the amount of tokens approved by the owner */
198   /* that can be transferred by spender */
199 
200   function allowance(address _owner, address _spender) public view returns (uint remaining) {
201     return allowed[_owner][_spender];
202   }
203 
204 }
205 
206 
207 // ----------------------------------------------------------------------------
208 //
209 // GZR public token sale
210 //
211 // ----------------------------------------------------------------------------
212 
213 contract GizerToken is ERC20Token {
214 
215   /* Utility variable */
216   
217   uint constant E6  = 10**6;
218 
219   /* Basic token data */
220 
221   string public constant name     = "Gizer Gaming Token";
222   string public constant symbol   = "GZR";
223   uint8  public constant decimals = 6;
224 
225   /* Wallets */
226   
227   address public wallet;
228   address public redemptionWallet;
229   address public gizerItemsContract;
230 
231   /* Crowdsale parameters (constants) */
232 
233   uint public constant DATE_ICO_START = 1521122400; // 15-Mar-2018 14:00 UTC 10:00 EST
234 
235   uint public constant TOKEN_SUPPLY_TOTAL = 10000000 * E6;
236   uint public constant TOKEN_SUPPLY_CROWD =  6112926 * E6;
237   uint public constant TOKEN_SUPPLY_OWNER =  3887074 * E6; // 2,000,000 tokens reserve
238                                                            // 1,887,074 presale tokens
239 
240   uint public constant MIN_CONTRIBUTION = 1 ether / 100;  
241   
242   uint public constant TOKENS_PER_ETH = 1000;
243   
244   uint public constant DATE_TOKENS_UNLOCKED = 1539180000; // 10-OCT-2018 14:00 UTC 10:00 EST
245 
246   /* Crowdsale parameters (can be modified by owner) */
247   
248   uint public date_ico_end = 1523368800; // 10-Apr-2018 14:00 UTC 10:00 EST
249 
250   /* Crowdsale variables */
251 
252   uint public tokensIssuedCrowd  = 0;
253   uint public tokensIssuedOwner  = 0;
254   uint public tokensIssuedLocked = 0;
255   
256   uint public etherReceived = 0; // does not include presale ethers
257 
258   /* Keep track of + ethers contributed,
259                    + tokens received 
260                    + tokens locked during Crowdsale */
261   
262   mapping(address => uint) public etherContributed;
263   mapping(address => uint) public tokensReceived;
264   mapping(address => uint) public locked;
265   
266   // Events ---------------------------
267   
268   event WalletUpdated(address _newWallet);
269   event GizerItemsContractUpdated(address _GizerItemsContract);
270   event RedemptionWalletUpdated(address _newRedemptionWallet);
271   event DateIcoEndUpdated(uint _unixts);
272   event TokensIssuedCrowd(address indexed _recipient, uint _tokens, uint _ether);
273   event TokensIssuedOwner(address indexed _recipient, uint _tokens, bool _locked);
274   event ItemsBought(address indexed _recipient, uint _lastIdx, uint _number);
275 
276   // Basic Functions ------------------
277 
278   /* Initialize */
279 
280   function GizerToken() public {
281     require( TOKEN_SUPPLY_OWNER + TOKEN_SUPPLY_CROWD == TOKEN_SUPPLY_TOTAL );
282     wallet = owner;
283     redemptionWallet = owner;
284   }
285 
286   /* Fallback */
287   
288   function () public payable {
289     buyTokens();
290   }
291 
292   // Information Functions ------------
293   
294   /* What time is it? */
295   
296   function atNow() public view returns (uint) {
297     return now;
298   }
299 
300   /* Are tokens tradeable */
301   
302   function tradeable() public view returns (bool) {
303     if (atNow() > date_ico_end) return true ;
304     return false;
305   }
306   
307   /* Available to mint by owner */
308   
309   function availableToMint() public view returns (uint available) {
310     if (atNow() <= date_ico_end) {
311       available = TOKEN_SUPPLY_OWNER.sub(tokensIssuedOwner);
312     } else {
313       available = TOKEN_SUPPLY_TOTAL.sub(tokensIssuedTotal);
314     }
315   }
316   
317   /* Unlocked tokens in an account */
318   
319   function unlockedTokens(address _account) public view returns (uint _unlockedTokens) {
320     if (atNow() <= DATE_TOKENS_UNLOCKED) {
321       return balances[_account] - locked[_account];
322     } else {
323       return balances[_account];
324     }
325   }
326 
327   // Owner Functions ------------------
328   
329   /* Change the crowdsale wallet address */
330 
331   function setWallet(address _wallet) public onlyOwner {
332     require( _wallet != address(0x0) );
333     wallet = _wallet;
334     WalletUpdated(_wallet);
335   }
336 
337   /* Change the redemption wallet address */
338 
339   function setRedemptionWallet(address _wallet) public onlyOwner {
340     require( _wallet != address(0x0) );
341     redemptionWallet = _wallet;
342     RedemptionWalletUpdated(_wallet);
343   }
344   
345   /* Change the Gizer Items contract address */
346 
347   function setGizerItemsContract(address _contract) public onlyOwner {
348     require( _contract != address(0x0) );
349     gizerItemsContract = _contract;
350     GizerItemsContractUpdated(_contract);
351   }
352   
353   /* Change the ICO end date */
354 
355   function extendIco(uint _unixts) public onlyOwner {
356     require( _unixts > date_ico_end );
357     require( _unixts < 1530316800 ); // must be before 30-JUN-2018
358     date_ico_end = _unixts;
359     DateIcoEndUpdated(_unixts);
360   }
361   
362   /* Minting of tokens by owner */
363 
364   function mintTokens(address _account, uint _tokens) public onlyOwner {
365     // check token amount
366     require( _tokens <= availableToMint() );
367     
368     // update
369     balances[_account] = balances[_account].add(_tokens);
370     tokensIssuedOwner  = tokensIssuedOwner.add(_tokens);
371     tokensIssuedTotal  = tokensIssuedTotal.add(_tokens);
372     
373     // log event
374     Transfer(0x0, _account, _tokens);
375     TokensIssuedOwner(_account, _tokens, false);
376   }
377 
378   /* Minting of tokens by owner */
379 
380   function mintTokensLocked(address _account, uint _tokens) public onlyOwner {
381     // check token amount
382     require( _tokens <= availableToMint() );
383     
384     // update
385     balances[_account] = balances[_account].add(_tokens);
386     locked[_account]   = locked[_account].add(_tokens);
387     tokensIssuedOwner  = tokensIssuedOwner.add(_tokens);
388     tokensIssuedTotal  = tokensIssuedTotal.add(_tokens);
389     tokensIssuedLocked = tokensIssuedLocked.add(_tokens);
390     
391     // log event
392     Transfer(0x0, _account, _tokens);
393     TokensIssuedOwner(_account, _tokens, true);
394   }  
395   
396   /* Transfer out any accidentally sent ERC20 tokens */
397 
398   function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
399       return ERC20Interface(tokenAddress).transfer(owner, amount);
400   }
401 
402   // Private functions ----------------
403 
404   /* Accept ETH during crowdsale (called by default function) */
405 
406   function buyTokens() private {
407     
408     // basic checks
409     require( atNow() > DATE_ICO_START && atNow() < date_ico_end );
410     require( msg.value >= MIN_CONTRIBUTION );
411     
412     // check token volume
413     uint tokensAvailable = TOKEN_SUPPLY_CROWD.sub(tokensIssuedCrowd);
414     uint tokens = msg.value.mul(TOKENS_PER_ETH) / 10**12;
415     require( tokens <= tokensAvailable );
416     
417     // issue tokens
418     balances[msg.sender] = balances[msg.sender].add(tokens);
419     
420     // update global tracking variables
421     tokensIssuedCrowd  = tokensIssuedCrowd.add(tokens);
422     tokensIssuedTotal  = tokensIssuedTotal.add(tokens);
423     etherReceived      = etherReceived.add(msg.value);
424     
425     // update contributor tracking variables
426     etherContributed[msg.sender] = etherContributed[msg.sender].add(msg.value);
427     tokensReceived[msg.sender]   = tokensReceived[msg.sender].add(tokens);
428     
429     // transfer Ether out
430     if (this.balance > 0) wallet.transfer(this.balance);
431 
432     // log token issuance
433     TokensIssuedCrowd(msg.sender, tokens, msg.value);
434     Transfer(0x0, msg.sender, tokens);
435   }
436 
437   // ERC20 functions ------------------
438 
439   /* Override "transfer" */
440 
441   function transfer(address _to, uint _amount) public returns (bool success) {
442     require( tradeable() );
443     require( unlockedTokens(msg.sender) >= _amount );
444     return super.transfer(_to, _amount);
445   }
446   
447   /* Override "transferFrom" */
448 
449   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
450     require( tradeable() );
451     require( unlockedTokens(_from) >= _amount ); 
452     return super.transferFrom(_from, _to, _amount);
453   }
454 
455   // Bulk token transfer function -----
456 
457   /* Multiple token transfers from one address to save gas */
458 
459   function transferMultiple(address[] _addresses, uint[] _amounts) external {
460     require( tradeable() );
461     require( _addresses.length == _amounts.length );
462     require( _addresses.length <= 100 );
463     
464     // check token amounts
465     uint tokens_to_transfer = 0;
466     for (uint i = 0; i < _addresses.length; i++) {
467       tokens_to_transfer = tokens_to_transfer.add(_amounts[i]);
468     }
469     require( tokens_to_transfer <= unlockedTokens(msg.sender) );
470     
471     // do the transfers
472     for (i = 0; i < _addresses.length; i++) {
473       super.transfer(_addresses[i], _amounts[i]);
474     }
475   }
476   
477   // Functions to convert GZR to Gizer items -----------
478   
479   /* GZR token owner buys one Gizer Item */ 
480   
481   function buyItem() public returns (uint idx) {
482     super.transfer(redemptionWallet, E6);
483     idx = mintItem(msg.sender);
484 
485     // event
486     ItemsBought(msg.sender, idx, 1);
487   }
488   
489   /* GZR token owner buys several Gizer Items (max 100) */ 
490   
491   function buyMultipleItems(uint8 _items) public returns (uint idx) {
492     
493     // between 0 and 100 items
494     require( _items > 0 && _items <= 100 );
495 
496     // transfer GZR tokens to redemption wallet
497     super.transfer(redemptionWallet, _items * E6);
498     
499     // mint tokens, returning indexes of first and last item minted
500     for (uint i = 0; i < _items; i++) {
501       idx = mintItem(msg.sender);
502     }
503 
504     // event
505     ItemsBought(msg.sender, idx, _items);
506   }
507 
508   /* Internal function to call */
509   
510   function mintItem(address _owner) internal returns(uint idx) {
511     GizerItemsInterface g = GizerItemsInterface(gizerItemsContract);
512     idx = g.mint(_owner);
513   }
514   
515 }
516 
517 
518 // ----------------------------------------------------------------------------
519 //
520 // GZR Items interface
521 //
522 // ----------------------------------------------------------------------------
523 
524 contract GizerItemsInterface is Owned {
525 
526   function mint(address _to) public onlyAdmin returns (uint idx);
527 
528 }