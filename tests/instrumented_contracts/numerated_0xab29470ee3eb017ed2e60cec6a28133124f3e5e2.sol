1 pragma solidity ^0.4.19;
2 
3 /*
4 * LooksCoin token sale contract
5 *
6 * Refer to https://lookscoin.com for more information.
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
30 library SafeMath {
31     /**
32      * Add two uint256 values, revert in case of overflow.
33      *
34      * @param a first value to add
35      * @param b second value to add
36      * @return a + b
37      */
38     function add(uint256 a, uint256 b) internal returns (uint256) {
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
51     function sub(uint256 a, uint256 b) internal returns (uint256) {
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
63     function mul(uint256 a, uint256 b) internal returns (uint256) {
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
77     function div(uint256 a, uint256 b) internal returns (uint256) {
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
117      */
118     function acceptOwnership() {
119         require(msg.sender == newOwner);
120         owner = newOwner;
121         OwnershipTransferred(owner, newOwner);
122         newOwner = 0x0;
123     }
124     event OwnershipTransferred(address indexed _from, address indexed _to);
125 }
126 
127 /**
128 * Standard Token Smart Contract
129 */
130 contract StandardToken is ERC20 {
131     using SafeMath for uint256;
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
152      * Mapping of the addition of patrons.
153      */
154     mapping (address => bool) patronAppended;
155 
156     /**
157      * Mapping of the addresses of patrons.
158      */
159     address[] patrons;
160 
161     /**
162      * Mapping of the addresses of VIP token holders.
163      */
164     address[] vips;
165 
166     /**
167     * Mapping for VIP rank for qualified token holders
168     * Higher VIP rank (with earlier timestamp) has higher bidding priority when
169     * competing for the same product or service on platform.
170     */
171     mapping (address => uint256) viprank;
172 
173     /**
174      * Get number of tokens currently belonging to given owner.
175      *
176      * @param _owner address to get number of tokens currently belonging to its owner
177      *
178      * @return number of tokens currently belonging to the owner of given address
179      */
180     function balanceOf(address _owner) constant returns (uint256 balance) {
181         return balances[_owner];
182     }
183 
184     /**
185      * Transfer given number of tokens from message sender to given recipient.
186      *
187      * @param _to address to transfer tokens to the owner of
188      * @param _value number of tokens to transfer to the owner of given address
189      * @return true if tokens were transferred successfully, false otherwise
190      */
191     function transfer(address _to, uint256 _value) returns (bool success) {
192         require(_to != 0x0);
193         if (balances[msg.sender] < _value) return false;
194         balances[msg.sender] = balances[msg.sender].sub(_value);
195         balances[_to] = balances[_to].add(_value);
196         Transfer(msg.sender, _to, _value);
197         return true;
198     }
199 
200     /**
201      * Transfer given number of tokens from given owner to given recipient.
202      *
203      * @param _from address to transfer tokens from the owner of
204      * @param _to address to transfer tokens to the owner of
205      * @param _value number of tokens to transfer from given owner to given
206      *        recipient
207      * @return true if tokens were transferred successfully, false otherwise
208      */
209     function transferFrom(address _from, address _to, uint256 _value) 
210         returns (bool success) {
211         require(_to != 0x0);
212         if(_from == _to) return false;
213         if (balances[_from] < _value) return false;
214         if (_value > allowed[_from][msg.sender]) return false;
215 
216         balances[_from] = balances[_from].sub(_value);
217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         Transfer(_from, _to, _value);
220         return true;
221     }
222 
223     /**
224      * Allow given spender to transfer given number of tokens from message sender.
225      *
226      * @param _spender address to allow the owner of to transfer tokens from
227      *        message sender
228      * @param _value number of tokens to allow to transfer
229      * @return true if token transfer was successfully approved, false otherwise
230      */
231     function approve(address _spender, uint256 _value) returns (bool success) {
232 
233         // To change the approve amount you first have to reduce the addresses`
234         //  allowance to zero by calling approve(_spender, 0) if it is not
235         //  already 0 to mitigate the race condition described here:
236         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
238            return false;
239         }
240         if (balances[msg.sender] < _value) {
241             return false;
242         }
243         allowed[msg.sender][_spender] = _value;
244         Approval(msg.sender, _spender, _value);
245         return true;
246      }
247 
248     /**
249      * Tell how many tokens given spender is currently allowed to transfer from
250      * given owner.
251      *
252      * @param _owner address to get number of tokens allowed to be transferred
253      *        from the owner of
254      * @param _spender address to get number of tokens allowed to be transferred
255      *        by the owner of
256      * @return number of tokens given spender is currently allowed to transfer
257      *         from given owner
258      */
259      function allowance(address _owner, address _spender) constant 
260         returns (uint256 remaining) {
261        return allowed[_owner][_spender];
262      }
263 }
264 
265 /**
266  * LooksCoin Token
267  *
268  * LooksCoin Token is an utility token that can be purchased through crowdsale or earned on
269  * the LookRev platform. It can be spent to purchase creative products and services on
270  * LookRev platform.
271  *
272  * VIP rank is used to calculate priority when competing with other bids
273  * for the same product or service on the platform. 
274  * Higher VIP rank (with earlier timestamp) has higher priority.
275  * Higher VIP rank wallet address owner can outbid other lower ranking owners only once
276  * per selling window or promotion period.
277  * VIP rank is recorded at the time when the wallet address first reach VIP LooksCoin 
278  * holding level for a token purchaser.
279  * VIP rank is valid for the lifetime of a wallet address on the platform, as long as it 
280  * meets the VIP holding level.
281 
282  * Usage of the LooksCoin, VIP rank and token utilities are described on the website
283  * https://lookscoin.com.
284  *
285  */
286 contract LooksCoin is StandardToken, Ownable {
287 
288     /**
289      * Number of decimals of the smallest unit
290      */
291     uint256 public constant decimals = 18;
292 
293     /**
294      * VIP Holding Level. Minimium token holding amount to record a VIP rank.
295      * Token holding address needs have at least 24000 LooksCoin to be ranked as VIP
296      * VIP rank can only be set through purchasing tokens
297      */
298     uint256 public constant VIP_MINIMUM = 24000e18;
299 
300     /**
301      * Initial number of tokens.
302      */
303     uint256 constant INITIAL_TOKENS_COUNT = 100000000e18;
304 
305     /**
306      * Crowdsale contract address.
307      */
308     address public tokenSaleContract = 0x0;
309 
310     /**
311      * Init Placeholder
312      */
313     address coinmaster = address(0xd3c79e4AD654436d59AfD61363Bc2B927d2fb680);
314 
315     /**
316      * Create new LooksCoin token smart contract.
317      */
318     function LooksCoin() {
319         owner = coinmaster;
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
343      * @dev Set new token sale contract.
344      * May only be called by owner.
345      *
346      * @param _newTokenSaleContract new token sale manage contract.
347      */
348     function setTokenSaleContract(address _newTokenSaleContract) {
349         require(msg.sender == owner);
350         assert(_newTokenSaleContract != 0x0);
351         tokenSaleContract = _newTokenSaleContract;
352     }
353 
354     /**
355      * Get VIP rank of a given owner.
356      * VIP rank is valid for the lifetime of a token wallet address, 
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
371      * Contribution timestamp is recorded for VIP rank.
372      * Recorded timestamp for VIP rank should always be earlier than the current time.
373      *
374      * @param _to address to check the vip rank.
375      * @return rank vip rank of the owner of given address if any
376      */
377     function updateVIPRank(address _to) returns (uint256 rank) {
378         // Contribution timestamp is recorded for VIP rank
379         // Recorded timestamp for VIP rank should always be earlier than current time
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
401         balances[_to] = balances[_to].add(_value);
402         totalSupply = totalSupply.add(_value);
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
420         balances[msg.sender] = balances[msg.sender].sub(_value);
421         balances[_to] = balances[_to].add(_value);
422         spentamount[msg.sender][_to] = spentamount[msg.sender][_to].add(_value);
423 
424         SpentTokens(msg.sender, _to, _value);
425         if(!patronAppended[msg.sender]) {
426             patronAppended[msg.sender] = true;
427             patrons.push(msg.sender);
428         }
429         return true;
430     }
431 
432     event Burn(address indexed burner, uint256 value);
433     /**
434      * Burn given number of tokens belonging to message sender.
435      * It can be applied by account with address this.tokensaleContract
436      *
437      * @param _value number of tokens to burn
438      * @return true on success, false on error
439      */
440     function burnTokens(address burner, uint256 _value) public returns (bool success) {
441         require(msg.sender == burner || msg.sender == owner);
442         assert(burner != 0x0);
443         if (_value > totalSupply) return false;
444         if (_value > balances[burner]) return false;
445         
446         balances[burner] = balances[burner].sub(_value);
447         totalSupply = totalSupply.sub(_value);
448         Burn(burner, _value);
449         return true;
450     }
451 
452     /**
453      * Get the VIP owner at the index.
454      *
455      * @param index of the VIP owner on the VIP list
456      * @return address of the VIP owner
457      */
458     function getVIPOwner(uint256 index) constant returns (address vipowner) {
459         return (vips[index]);
460     }
461 
462     /**
463      * Get the count of VIP owners.
464      *
465      * @return count of VIP owners list.
466      */
467     function getVIPCount() constant returns (uint256 count) {
468         return vips.length;
469     }
470 
471     /**
472      * Get the patron at the index.
473      *
474      * @param index of the patron on the patron list
475      * @return address of the patron
476      */
477     function getPatron(uint256 index) constant returns (address patron) {
478         return (patrons[index]);
479     }
480 
481     /**
482      * Get the count of patrons.
483      *
484      * @return number of patrons.
485      */
486     function getPatronsCount() constant returns (uint256 count) {
487         return patrons.length;
488     }
489 }
490 
491 /**
492  * LooksCoin CrowdSale Contract
493  *
494  * The token sale controller, allows contributing ether in exchange for LooksCoin.
495  * The price (exchange rate with ETH) is 2400 LooksCoin per ETH at crowdsale.
496  *
497  * VIP rank is used to calculate priority when competing with other bids
498  * for the same product or service on the platform. 
499  * Higher VIP rank (with earlier timestamp) has higher priority.
500  * Higher VIP rank wallet address owner can outbid other lower ranking owners only once
501  * per selling window or promotion period.
502  * VIP rank is recorded at the time when the wallet address first reach VIP LooksCoin 
503  * holding level for a token purchaser.
504  * VIP rank is valid for the lifetime of a wallet address on the platform, as long as it 
505  * meets the VIP holding level.
506  *
507  *
508  * LooksCoin CrowdSale Bonus
509  *******************************************************************************************************************
510  * First Ten (1st to 10th) VIP owners get 20% bonus LooksCoin in their VIP wallet addresses
511  * Eleven (11th) to Fifty (50th) VIP owners get 10% bonus of the LooksCoin in their VIP wallet addresses
512  * Fifty One (51th) to One Hundred (100th) VIP owners get 5% bonus of the LooksCoin in their VIP wallet addresses
513  *******************************************************************************************************************
514  *
515  * Bonus LooksCoin will be distributed by coin master when LooksCoin has 100 VIP wallet addresses
516  * Bonus is calculated as:
517  *   Percentage of Bonus * Amount of LooksCoin at the wallet address at the time recorded on the VIP rank timestamp
518  * 
519  */
520 contract LooksCoinCrowdSale {
521     LooksCoin public looksCoin;
522     ERC20 public preSaleToken;
523 
524     // initial price in wei (numerator)
525     uint256 public constant TOKEN_PRICE_N = 1;
526     // initial price in wei (denominator)
527     uint256 public constant TOKEN_PRICE_D = 2400;
528     // 1 ETH = 2,400 LOOKS tokens
529 
530     address public saleController = 0x0;
531 
532     // Amount of imported tokens from preSale
533     uint256 public importedTokens = 0;
534 
535     // Amount of tokens sold
536     uint256 public tokensSold = 0;
537 
538     /**
539      * Address of the owner of this smart contract.
540      */
541     address fundstorage = 0x0;
542 
543     /**
544      * States of the crowdsale contract.
545      */
546     enum State{
547         Pause,
548         Init,
549         Running,
550         Stopped,
551         Migrated
552     }
553 
554     State public currentState = State.Running;    
555 
556     /**
557      * Modifier.
558      */
559     modifier onCrowdSaleRunning() {
560         // Checks, if CrowdSale is running and has not been paused
561         require(currentState == State.Running);
562         _;
563     }
564 
565     /**
566      * Create new crowdsale smart contract, make message sender to be the
567      * owner of smart contract.
568      */
569     function LooksCoinCrowdSale() {
570         saleController = msg.sender;
571         fundstorage = msg.sender;
572 
573         preSaleToken = ERC20(0x253C7dd074f4BaCb305387F922225A4f737C08bd);
574     }
575 
576     /**
577     * @dev Set new state
578     * @param _newState Value of new state
579     */
580     function setState(State _newState)
581     {
582         require(msg.sender == saleController);
583         currentState = _newState;
584     }
585 
586     /**
587     * @dev Set token contract address
588     * @param _tokenContract address of LooksCoin token contract
589     */
590     function setTokenContract(address _tokenContract)
591     {
592         require(msg.sender == saleController);
593         assert(_tokenContract != 0x0);
594         looksCoin = LooksCoin(_tokenContract);
595     }
596 
597     /**
598     * @dev Set token contract address for migration
599     * @param _prevTokenContract address of token contract for migration
600     */
601     function setMigrateTokenContract(address _prevTokenContract)
602     {
603         require(msg.sender == saleController);
604         assert(_prevTokenContract != 0x0);
605         preSaleToken = ERC20(_prevTokenContract);
606     }
607 
608     /**
609      * @dev Set new token sale controller.
610      * May only be called by sale controller.
611      *
612      * @param _newSaleController new token sale controller.
613      */
614     function setSaleController(address _newSaleController) {
615         require(msg.sender == saleController);
616         assert(_newSaleController != 0x0);
617         saleController = _newSaleController;
618     }
619 
620     /**
621      * Set new wallet address for the smart contract.
622      * May only be called by smart contract owner.
623      *
624      * @param _fundstorage new wallet address of the smart contract.
625      */
626     function setWallet(address _fundstorage) {
627         require(msg.sender == saleController);
628         assert(_fundstorage != 0x0);
629         fundstorage = _fundstorage;
630     }
631 
632     /**
633     * saves info if account's tokens were imported from previous sale.
634     */
635     mapping (address => bool) private importedFromPreSale;
636 
637     event TokensImport(address indexed participant, uint256 tokens, uint256 totalImport);
638     /**
639     * Imports account's tokens from previous sale
640     * It can be done only by account owner or sale controller
641     * @param _account Address of account which tokens will be imported
642     */
643     function importTokens(address _account) returns (bool success) {
644         // only token holder or sale controller can do import
645         require(currentState == State.Running);
646         require(msg.sender == saleController || msg.sender == _account);
647         require(!importedFromPreSale[_account]);
648 
649         uint256 preSaleBalance = preSaleToken.balanceOf(_account);
650 
651         if (preSaleBalance == 0) return false;
652 
653         looksCoin.rewardTokens(_account, preSaleBalance);
654         importedTokens = importedTokens + preSaleBalance;
655         importedFromPreSale[_account] = true;
656         TokensImport(_account, preSaleBalance, importedTokens);
657         return true;
658     }
659 
660     // fallback
661     function() public payable {
662         buyTokens();
663     }
664 
665     event Transfer(address indexed _from, address indexed _to, uint _value);
666     event TokensBought(address indexed buyer, uint256 ethers, uint256 tokens, uint256 tokensSold);
667     /**
668      * Accept ethers to buy tokens during the token sale
669      * Minimium holdings to receive a VIP rank is 24000 LooksCoin
670      */
671     function buyTokens() payable returns (uint256 amount)
672     {
673         require(currentState == State.Running);
674         assert(msg.sender != 0x0);
675         require(msg.value > 0);
676 
677         // Calculate number of tokens for contributed wei
678         uint256 tokens = msg.value * TOKEN_PRICE_D / TOKEN_PRICE_N;
679         if (tokens == 0) return 0;
680 
681         looksCoin.rewardTokens(msg.sender, tokens);
682         tokensSold = tokensSold + tokens;
683 
684         // Log the tokens purchased 
685         Transfer(0x0, msg.sender, tokens);
686         TokensBought(msg.sender, msg.value, tokens, tokensSold);
687 
688         assert(fundstorage.send(msg.value));
689         return tokens;
690     }
691 }