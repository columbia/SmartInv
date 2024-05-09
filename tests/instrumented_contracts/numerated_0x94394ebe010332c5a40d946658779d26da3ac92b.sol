1 pragma solidity ^0.4.19;
2 
3 /*
4 * LooksCoin token sale contract
5 *
6 * Refer to https://lookrev.com/tokensale/ for more information.
7 * 
8 * Developer: LookRev
9 *
10 */
11 
12 /*
13  * ERC20 Token Standard
14  */
15 contract ERC20 {
16 event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19 uint256 public totalSupply;
20 function balanceOf(address _owner) constant public returns (uint256 balance);
21 function transfer(address _to, uint256 _value) public returns (bool success);
22 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
23 function approve(address _spender, uint256 _value) public returns (bool success);
24 function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
25 }
26 
27 /**
28 * Provides methods to safely add, subtract and multiply uint256 numbers.
29 */
30 contract SafeMath {
31     /**
32      * Add two uint256 values, revert in case of overflow.
33      *
34      * @param a first value to add
35      * @param b second value to add
36      * @return a + b
37      */
38     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 
44     /**
45      * Subtract one uint256 value from another, throw in case of underflow.
46      *
47      * @param a value to subtract from
48      * @param b value to subtract
49      * @return a - b
50      */
51     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
52         assert(a >= b);
53         return a - b;
54     }
55 
56     /**
57      * Multiply two uint256 values, throw in case of overflow.
58      *
59      * @param a first value to multiply
60      * @param b second value to multiply
61      * @return a * b
62      */
63     function safeMul(uint256 a, uint256 b) internal returns (uint256) {
64         if (a == 0 || b == 0) return 0;
65         uint256 c = a * b;
66         assert(c / a == b);
67         return c;
68     }
69 
70     /**
71      * Divid uint256 values, throw in case of overflow.
72      *
73      * @param a first value numerator
74      * @param b second value denominator
75      * @return a / b
76      */
77     function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
78         assert(b != 0); // Solidity automatically throws when dividing by 0
79         uint256 c = a / b;
80         assert(a == b * c + a % b); // There is no case in which this doesn't hold
81         return c;
82     }
83 }
84 
85 /*
86     Provides support and utilities for contract ownership
87 */
88 contract Ownable {
89     address owner;
90     address newOwner;
91 
92     function Ownable() {
93         owner = msg.sender;
94     }
95 
96     /**
97      * Allows execution by the owner only.
98      */
99     modifier onlyOwner {
100         require(msg.sender == owner);
101         _;
102     }
103 
104     /**
105      * Transferring the contract ownership to the new owner.
106      *
107      * @param _newOwner new contractor owner
108      */
109     function transferOwnership(address _newOwner) onlyOwner {
110         if (_newOwner != 0x0) {
111           newOwner = _newOwner;
112         }
113     }
114 
115     /**
116      * Accept the contract ownership by the new owner.
117      *
118      */
119     function acceptOwnership() {
120         require(msg.sender == newOwner);
121         owner = newOwner;
122         OwnershipTransferred(owner, newOwner);
123         newOwner = 0x0;
124     }
125     event OwnershipTransferred(address indexed _from, address indexed _to);
126 }
127 
128 /**
129 * Standard Token Smart Contract
130 */
131 contract StandardToken is ERC20, SafeMath {
132 
133     /**
134      * Mapping from addresses of token holders to the numbers of tokens belonging
135      * to these token holders.
136      */
137     mapping (address => uint256) balances;
138 
139     /**
140      * Mapping from addresses of token holders to the mapping of addresses of
141      * spenders to the allowances set by these token holders to these spenders.
142      */
143     mapping (address => mapping (address => uint256)) internal allowed;
144 
145     /**
146      * Mapping from addresses of token holders to the mapping of token amount spent.
147      * Use by the token holders to spend their utility tokens.
148      */
149     mapping (address => mapping (address => uint256)) spentamount;
150 
151     /**
152      * Mapping of the addition of the addresse of buyers.
153      */
154     mapping (address => bool) buyerAppended;
155 
156     /**
157      * Mapping of the addition of addresses of buyers.
158      */
159     address[] buyers;
160 
161     /**
162      * Mapping of the addresses of VIP token holders.
163      */
164     address[] vips;
165 
166     /**
167     * Mapping for VIP rank for qualified token holders
168     * Higher VIP ranking (with earlier timestamp) has higher bidding priority when
169     * competing for the same product or service on platform. 
170     * Higher VIP ranking address can outbid other lower ranking addresses only once per 
171     * selling window or promotion period.
172     * Usage of the VIP ranking and bid priority will be described on token website.
173     */
174     mapping (address => uint256) viprank;
175 
176     /**
177      * Get number of tokens currently belonging to given owner.
178      *
179      * @param _owner address to get number of tokens currently belonging to the
180      *        owner of
181      * @return number of tokens currently belonging to the owner of given address
182      */
183     function balanceOf(address _owner) constant returns (uint256 balance) {
184         return balances[_owner];
185     }
186 
187     /**
188      * Transfer given number of tokens from message sender to given recipient.
189      *
190      * @param _to address to transfer tokens to the owner of
191      * @param _value number of tokens to transfer to the owner of given address
192      * @return true if tokens were transferred successfully, false otherwise
193      */
194     function transfer(address _to, uint256 _value) returns (bool success) {
195         require(_to != 0x0);
196         if (balances[msg.sender] < _value) return false;
197         balances[msg.sender] = safeSub(balances[msg.sender],_value);
198         balances[_to] = safeAdd(balances[_to],_value);
199         Transfer(msg.sender, _to, _value);
200         return true;
201     }
202 
203     /**
204      * Transfer given number of tokens from given owner to given recipient.
205      *
206      * @param _from address to transfer tokens from the owner of
207      * @param _to address to transfer tokens to the owner of
208      * @param _value number of tokens to transfer from given owner to given
209      *        recipient
210      * @return true if tokens were transferred successfully, false otherwise
211      */
212     function transferFrom(address _from, address _to, uint256 _value) 
213         returns (bool success) {
214         require(_to != 0x0);
215         if(_from == _to) return false;
216         if (balances[_from] < _value) return false;
217         if (_value > allowed[_from][msg.sender]) return false;
218 
219         balances[_from] = safeSub(balances[_from],_value);
220         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
221         balances[_to] = safeAdd(balances[_to],_value);
222         Transfer(_from, _to, _value);
223         return true;
224     }
225 
226     /**
227      * Allow given spender to transfer given number of tokens from message sender.
228      *
229      * @param _spender address to allow the owner of to transfer tokens from
230      *        message sender
231      * @param _value number of tokens to allow to transfer
232      * @return true if token transfer was successfully approved, false otherwise
233      */
234     function approve(address _spender, uint256 _value) returns (bool success) {
235 
236         // To change the approve amount you first have to reduce the addresses`
237         //  allowance to zero by calling `approve(_spender, 0)` if it is not
238         //  already 0 to mitigate the race condition described here:
239         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
241            return false;
242         }
243         if (balances[msg.sender] < _value) {
244             return false;
245         }
246         allowed[msg.sender][_spender] = _value;
247         Approval(msg.sender, _spender, _value);
248         return true;
249      }
250 
251     /**
252      * Tell how many tokens given spender is currently allowed to transfer from
253      * given owner.
254      *
255      * @param _owner address to get number of tokens allowed to be transferred
256      *        from the owner of
257      * @param _spender address to get number of tokens allowed to be transferred
258      *        by the owner of
259      * @return number of tokens given spender is currently allowed to transfer
260      *         from given owner
261      */
262      function allowance(address _owner, address _spender) constant 
263         returns (uint256 remaining) {
264        return allowed[_owner][_spender];
265      }
266 }
267 
268 /**
269  * LooksCoin Token
270  *
271  * VIP ranking is recorded at the time when the token holding address first meet VIP coin 
272  * holding level.
273  * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets 
274  * VIP coin holding level.
275  * VIP ranking is used to calculate priority when competing with other bids for the
276  * same product or service on the platform. 
277  * Higher VIP ranking (with earlier timestamp) has higher priority.
278  * Higher VIP ranking address can outbid other lower ranking wallet addresse owners only once
279  * per selling window or promotion period.
280  * Usage of the LooksCoin, VIP ranking and bid priority will be described on token website.
281  *
282  */
283 contract LooksCoin is StandardToken, Ownable {
284 
285     uint256 public constant decimals = 0;
286 
287     /**
288      * Minimium contribution to record a VIP rank
289      * Token holding address needs have at least 24000 LooksCoin to be ranked as VIP
290      * VIP rank can only be set through purchasing tokens
291     */
292     uint256 public constant VIP_MINIMUM = 24000;
293 
294     /**
295      * Initial number of tokens.
296      */
297     uint256 constant INITIAL_TOKENS_COUNT = 100000000;
298 
299     /**
300      * Crowdsale contract address.
301      */
302     address public tokenSaleContract = 0x0;
303 
304     /**
305      * Init Placeholder
306      */
307     address coinmaster = address(0x33169f40d18c6c2590901db23000D84052a11F54);
308 
309     /**
310      * Create new LooksCoin token Smart Contract.
311      * Contract is needed in _tokenSaleContract address.
312      *
313      * @param _tokenSaleContract of crowdsale contract
314      *
315      */
316     function LooksCoin(address _tokenSaleContract) {
317         assert(_tokenSaleContract != 0x0);
318         owner = coinmaster;
319         tokenSaleContract = _tokenSaleContract;
320         balances[owner] = INITIAL_TOKENS_COUNT;
321         totalSupply = INITIAL_TOKENS_COUNT;
322     }
323 
324     /**
325      * Get name of this token.
326      *
327      * @return name of this token
328      */
329     function name() constant returns (string name) {
330       return "LooksCoin";
331     }
332 
333     /**
334      * Get symbol of this token.
335      *
336      * @return symbol of this token
337      */
338     function symbol() constant returns (string symbol) {
339       return "LOOKS";
340     }
341 
342     /**
343      * @dev Set new sale manage contract.
344      * May only be called by owner.
345      *
346      * @param _newSaleManageContract new token sale manage contract.
347      */
348     function setSaleManageContract(address _newSaleManageContract) {
349         require(msg.sender == owner);
350         assert(_newSaleManageContract != 0x0);
351         tokenSaleContract = _newSaleManageContract;
352     }
353 
354     /**
355      * Get VIP rank of a given owner.
356      * VIP ranking is valid for the lifetime of a token wallet address, 
357      * as long as it meets VIP holding level.
358      *
359      * @param _to participant address to get the vip rank
360      * @return vip rank of the owner of given address
361      */
362     function getVIPRank(address _to) constant public returns (uint256 rank) {
363         if (balances[_to] < VIP_MINIMUM) {
364             return 0;
365         }
366         return viprank[_to];
367     }
368 
369     /**
370      * Check and update VIP rank of a given token buyer.
371      * Contribution timestamp is recorded for VIP rank
372      * Recorded timestamp for VIP ranking should always be earlier than the current time
373      *
374      * @param _to address to check the vip rank
375      * @return rank vip rank of the owner of given address if any
376      */
377     function updateVIPRank(address _to) returns (uint256 rank) {
378         // Contribution timestamp is recorded for VIP rank
379         // Recorded timestamp for VIP ranking should always be earlier than current time
380         if (balances[_to] >= VIP_MINIMUM && viprank[_to] == 0) {
381             viprank[_to] = now;
382             vips.push(_to);
383         }
384         return viprank[_to];
385     }
386 
387     event TokenRewardsAdded(address indexed participant, uint256 balance);
388     /**
389      * Reward participant the tokens they purchased or earned
390      *
391      * @param _to address to credit tokens to the 
392      * @param _value number of tokens to transfer to given recipient
393      *
394      * @return true if tokens were transferred successfully, false otherwise
395      */
396     function rewardTokens(address _to, uint256 _value) {
397         require(msg.sender == tokenSaleContract || msg.sender == owner);
398         assert(_to != 0x0);
399         require(_value > 0);
400 
401         balances[_to] = safeAdd(balances[_to], _value);
402         totalSupply = safeAdd(totalSupply, _value);
403         updateVIPRank(_to);
404         TokenRewardsAdded(_to, _value);
405     }
406 
407     event SpentTokens(address indexed participant, address indexed recipient, uint256 amount);
408     /**
409      * Spend given number of tokens for a usage.
410      *
411      * @param _to address to spend utility tokens at
412      * @param _value number of tokens to spend
413      * @return true on success, false on error
414      */
415     function spend(address _to, uint256 _value) public returns (bool success) {
416         require(_value > 0);
417         assert(_to != 0x0);
418         if (balances[msg.sender] < _value) return false;
419 
420         balances[msg.sender] = safeSub(balances[msg.sender],_value);
421         balances[_to] = safeAdd(balances[_to],_value);
422         spentamount[msg.sender][_to] = safeAdd(spentamount[msg.sender][_to], _value);
423 
424         SpentTokens(msg.sender, _to, _value);
425         if(!buyerAppended[msg.sender]) {
426             buyerAppended[msg.sender] = true;
427             buyers.push(msg.sender);
428         }
429         return true;
430     }
431 
432     function getSpentAmount(address _who, address _to) constant returns (uint256) {
433         return spentamount[_who][_to];
434     }
435 
436     event Burn(address indexed burner, uint256 value);
437     /**
438      * Burn given number of tokens belonging to message sender.
439      * It can be applied by account with address this.tokensaleContract
440      *
441      * @param _value number of tokens to burn
442      * @return true on success, false on error
443      */
444     function burnTokens(address burner, uint256 _value) public returns (bool success) {
445         require(msg.sender == burner || msg.sender == owner);
446         assert(burner != 0x0);
447         if (_value > totalSupply) return false;
448         if (_value > balances[burner]) return false;
449         
450         balances[burner] = safeSub(balances[burner],_value);
451         totalSupply = safeSub(totalSupply,_value);
452         Burn(burner, _value);
453         return true;
454     }
455 
456     function getVIPOwner(uint256 index) constant returns (address) {
457         return (vips[index]);
458     }
459 
460     function getVIPCount() constant returns (uint256) {
461         return vips.length;
462     }
463 
464     function getBuyer(uint256 index) constant returns (address) {
465         return (buyers[index]);
466     }
467 
468     function getBuyersCount() constant returns (uint256) {
469         return buyers.length;
470     }
471 }
472 
473 /**
474  * LooksCoin CrowdSale Contract
475  *
476  * The token sale controller, allows contributing ether in exchange for LooksCoin.
477  * The price (exchange rate with ETH) is 2400 LOOKS per ETH at crowdsale.
478  * VIP ranking is recorded at the time when the token holding address first meet VIP coin holding level.
479  * VIP ranking is valid for the lifetime of a token wallet address, as long as it meets VIP coin holding level.
480  * VIP ranking is used to calculate priority when competing with other bids for the
481  * same product or service on the platform. 
482  * Higher VIP ranking (with earlier timestamp) has higher priority.
483  * Higher VIP ranking address can outbid other lower ranking addresses only once per selling window 
484  * or promotion period.
485  * Usage of the LooksCoin, VIP ranking and bid priority will be described on token website.
486  *
487  * LooksCoin CrowdSale Bonus
488  *******************************************************************************************************************
489  * First Ten (10) VIP token holders get 20% bonus of the LOOKS tokens in their VIP addresses
490  * Eleven (11th) to Fifty (50th) VIP token holders get 10% bonus of the LOOKS tokens in their VIP addresses
491  * Fifty One (51th) to One Hundred (100th) VIP token holders get 5% bonus of the LOOKS tokens in their VIP addresses
492  *******************************************************************************************************************
493  *
494  * Bonus tokens will be distributed by coin master when LooksCoin has 100 VIP rank token wallet addresses
495  *
496  */
497 contract LooksCoinCrowdSale {
498     LooksCoin public looksCoin;
499     ERC20 public preSaleToken;
500 
501     // initial price in wei (numerator)
502     uint256 public constant TOKEN_PRICE_N = 1e18;
503     // initial price in wei (denominator)
504     uint256 public constant TOKEN_PRICE_D = 2400;
505     // 1 ETH = 2,400 LOOKS tokens
506 
507     address saleController = 0x0;
508 
509     // Amount of imported tokens from preSale
510     uint256 public importedTokens = 0;
511 
512     // Amount of tokens sold
513     uint256 public tokensSold = 0;
514 
515     /**
516      * Address of the owner of this smart contract.
517      */
518     address fundstorage = 0x0;
519 
520     /**
521      * States of the crowdsale contract.
522      */
523     enum State{
524         Pause,
525         Init,
526         Running,
527         Stopped,
528         Migrated
529     }
530 
531     State public currentState = State.Running;    
532 
533     /**
534      * Modifier.
535      */
536     modifier onCrowdSaleRunning() {
537         // Checks, if CrowdSale is running and has not been paused
538         require(currentState == State.Running);
539         _;
540     }
541 
542     /**
543      * Create new LOOKS token Smart Contract, make message sender to be the
544      * owner of smart contract, issue given number of tokens and give them to
545      * message sender.
546      */
547     function LooksCoinCrowdSale() {
548         saleController = msg.sender;
549         fundstorage = msg.sender;
550         looksCoin = new LooksCoin(this);
551 
552         preSaleToken = ERC20(0x253C7dd074f4BaCb305387F922225A4f737C08bd);
553     }
554 
555     /**
556     * @dev Set new state
557     * @param _newState Value of new state
558     */
559     function setState(State _newState)
560     {
561         require(msg.sender == saleController);
562         currentState = _newState;
563     }
564 
565     /**
566      * @dev Set new token sale controller.
567      * May only be called by sale controller.
568      *
569      * @param _newSaleController new token sale controller.
570      */
571     function setSaleController(address _newSaleController) {
572         require(msg.sender == saleController);
573         assert(_newSaleController != 0x0);
574         saleController = _newSaleController;
575     }
576 
577     /**
578      * Set new wallet address for the smart contract.
579      * May only be called by smart contract owner.
580      *
581      * @param _fundstorage new wallet address of the smart contract
582      */
583     function setWallet(address _fundstorage) {
584         require(msg.sender == saleController);
585         assert(_fundstorage != 0x0);
586         fundstorage = _fundstorage;
587         WalletUpdated(fundstorage);
588     }
589     event WalletUpdated(address newWallet);
590 
591     /**
592     * saves info if account's tokens were imported from pre-CrowdSale
593     */
594     mapping (address => bool) private importedFromPreSale;
595 
596     event TokensImport(address indexed participant, uint256 tokens, uint256 totalImport);
597     /**
598     * Imports account's tokens from pre-Sale. 
599     * It can be done only by account owner or CrowdSale manager
600     * @param _account Address of account which tokens will be imported
601     */
602     function importTokens(address _account) returns (bool success) {
603         // only token holder or manager can do import
604         require(currentState == State.Running);
605         require(msg.sender == saleController || msg.sender == _account);
606         require(!importedFromPreSale[_account]);
607 
608         // Token decimals in PreSale was 18
609         uint256 preSaleBalance = preSaleToken.balanceOf(_account) / TOKEN_PRICE_N;
610 
611         if (preSaleBalance == 0) return false;
612 
613         looksCoin.rewardTokens(_account, preSaleBalance);
614         importedTokens = importedTokens + preSaleBalance;
615         importedFromPreSale[_account] = true;
616         TokensImport(_account, preSaleBalance, importedTokens);
617         return true;
618     }
619 
620     // fallback
621     function() public payable {
622         buyTokens();
623     }
624 
625     event TokensBought(address indexed buyer, uint256 ethers, uint256 tokens, uint256 tokensSold);
626     /**
627      * Accept ethers to buy tokens during the token sale
628      * Minimium holdings to receive a VIP rank is 24000 LooksCoin
629      */
630     function buyTokens() payable returns (uint256 amount)
631     {
632         require(currentState == State.Running);
633         assert(msg.sender != 0x0);
634         require(msg.value > 0);
635 
636         // Calculate number of tokens for contributed wei
637         uint256 tokens = msg.value * TOKEN_PRICE_D / TOKEN_PRICE_N;
638         if (tokens == 0) return 0;
639 
640         looksCoin.rewardTokens(msg.sender, tokens);
641         tokensSold = tokensSold + tokens;
642 
643         // Transfer the contributed ethers to the crowdsale fundstorage
644         assert(fundstorage.send(msg.value));
645         TokensBought(msg.sender, msg.value, tokens, tokensSold);
646         return tokens;
647     }
648 }