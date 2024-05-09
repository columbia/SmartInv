1 pragma solidity 0.4.23;
2 
3 /*
4 *DivvyUp for Goo
5 *
6 * ====================================================================*
7 *'||''|.    ||                                    '||'  '|'         
8 * ||   ||  ...  .... ... .... ... .... ...      ,  ||    |  ... ... 
9 * ||    ||  ||   '|.  |   '|.  |   '|.  |  <>  /   ||    |   ||'  ||
10 * ||    ||  ||    '|.|     '|.|     '|.|      /    ||    |   ||    |
11 *.||...|'  .||.    '|       '|       '|      /      '|..'    ||...' 
12 *                                 .. |      /                ||     
13 *                                  ''      /  <>            ''''    
14 * =====================================================================*
15 *
16 * A wealth redistribution smart contract cleverly disguised as a ERC20 token.
17 * Complete with a factory for making new verticals, and a fair launch contract
18 * to ensure a fair launch.
19 *
20 */
21 
22 
23 // ----------------------------------------------------------------------------
24 // ERC Token Standard #20 Interface
25 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint256);
29     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
31     function transfer(address to, uint256 tokens) public returns (bool success);
32     function approve(address spender, uint256 tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 // ----------------------------------------------------------------------------
40 // Contract function to receive approval and execute function in one call
41 // ----------------------------------------------------------------------------
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 // ----------------------------------------------------------------------------
47 // Owned contract
48 // ----------------------------------------------------------------------------
49 contract Owned {
50     address public owner;
51     address public ownerCandidate;
52 
53     function Owned() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61     
62     function changeOwner(address _newOwner) public onlyOwner {
63         ownerCandidate = _newOwner;
64     }
65     
66     function acceptOwnership() public {
67         require(msg.sender == ownerCandidate);  
68         owner = ownerCandidate;
69     }
70     
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79     /**
80     * @dev Multiplies two numbers, throws on overflow.
81     */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         if (a == 0) {
84             return 0;
85         }
86         uint256 c = a * b;
87         assert(c / a == b);
88         return c;
89     }
90 
91     /**
92     * @dev Integer division of two numbers, truncating the quotient.
93     */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         // assert(b > 0); // Solidity automatically throws when dividing by 0
96         uint256 c = a / b;
97         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98         return c;
99     }
100 
101     /**
102     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103     */
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         assert(b <= a);
106         return a - b;
107     }
108 
109     /**
110     * @dev Adds two numbers, throws on overflow.
111     */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         assert(c >= a);
115         return c;
116     }
117 }
118 
119 contract DivvyUpFactoryInterface {
120     function create(
121         bytes32 name, // Name of the DivvyUp
122         bytes32 symbol,  // ERC20 Symbol fo the DivvyUp
123         uint8 dividendDivisor, // Amount to divide incoming counter by as fees for dividens. Example: 3 for 33%, 10 for 10%, 100 for 1%
124         uint8 decimals, // Number of decimals the token has. Example: 18
125         uint256 initialPrice, // Starting price per token. Example: 0.0000001 ether
126         uint256 incrementPrice, // How much to increment the price by. Example: 0.00000001 ether
127         uint256 magnitude, //magnitude to multiply the fees by before distribution. Example: 2**64
128         address counter // The counter currency to accept. Example: 0x0 for ETH, otherwise the ERC20 token address.
129      )
130         public 
131         returns(address);
132 }
133 
134 
135 contract DivvyUpFactory is Owned {
136 
137     event Create(
138         bytes32 name,
139         bytes32 symbol,
140         uint8 dividendDivisor,
141         uint8 decimals,
142         uint256 initialPrice,
143         uint256 incrementPrice,
144         uint256 magnitude,
145         address creator
146     );
147 
148   
149     DivvyUp[] public registry;
150 
151     function create(
152         bytes32 name, // Name of the DivvyUp
153         bytes32 symbol,  // ERC20 Symbol fo the DivvyUp
154         uint8 dividendDivisor, // Amount to divide incoming counter by as fees for dividens. Example: 3 for 33%, 10 for 10%, 100 for 1%
155         uint8 decimals, // Number of decimals the token has. Example: 18
156         uint256 initialPrice, // Starting price per token. Example: 0.0000001 ether
157         uint256 incrementPrice, // How much to increment the price by. Example: 0.00000001 ether
158         uint256 magnitude, //magnitude to multiply the fees by before distribution. Example: 2**64
159         address counter // The counter currency to accept. Example: 0x0 for ETH, otherwise the ERC20 token address.
160      )
161         public 
162         returns(address)
163     {
164         DivvyUp divvyUp = new DivvyUp(name, symbol, dividendDivisor, decimals, initialPrice, incrementPrice, magnitude, counter);
165         divvyUp.changeOwner(msg.sender);
166         registry.push(divvyUp);
167         emit Create(name, symbol, dividendDivisor, decimals, initialPrice, incrementPrice, magnitude, msg.sender);
168         return divvyUp;
169     }
170 
171     function die() onlyOwner public {
172         selfdestruct(msg.sender);
173     }
174 
175     /**
176     * Owner can transfer out any accidentally sent ERC20 tokens
177     * 
178     * Implementation taken from ERC20 reference
179     * 
180     */
181     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
182         return ERC20Interface(tokenAddress).transfer(owner, tokens);
183     }
184 }
185 
186 contract DivvyUpInterface{
187     function purchaseTokens()
188         public
189         payable
190         returns(uint256);
191 
192     function purchaseTokensERC20(uint256 amount)
193         public
194         returns(uint256);
195 }
196 
197 contract DivvyUp is ERC20Interface, Owned, DivvyUpInterface {
198     using SafeMath for uint256;
199     /*=================================
200     =            MODIFIERS            =
201     =================================*/
202     // only people with tokens
203     modifier onlyTokenHolders() {
204         require(myTokens() > 0);
205         _;
206     }
207     
208     // only people with profits
209     modifier onlyDividendHolders() {
210         require(dividendDivisor > 0 && myDividends() > 0);
211         _;
212     }
213 
214     modifier erc20Destination(){
215         require(counter != 0x0);
216         _;
217     }
218     
219     /*==============================
220     =            EVENTS            =
221     ==============================*/
222     event Purchase(
223         address indexed customerAddress,
224         uint256 incomingCounter,
225         uint256 tokensMinted
226     );
227     
228     event Sell(
229         address indexed customerAddress,
230         uint256 tokensBurned,
231         uint256 counterEarned
232     );
233     
234     event Reinvestment(
235         address indexed customerAddress,
236         uint256 counterReinvested,
237         uint256 tokensMinted
238     );
239     
240     event Withdraw(
241         address indexed customerAddress,
242         uint256 counterWithdrawn
243     ); 
244     
245     /*=====================================
246     =            CONFIGURABLES            =
247     =====================================*/
248     bytes32 public name;
249     bytes32 public symbol;
250     uint8  public dividendDivisor;
251     uint8 public decimals;// = 18;
252     uint256 public tokenPriceInitial;// = 0.0000001 ether;
253     uint256 public tokenPriceIncremental;// = 0.00000001 ether;
254     uint256 public magnitude;// = 2**64;
255     address counter;
256 
257    /*================================
258     =            DATASETS            =
259     ================================*/
260     // amount of tokens for each address
261     mapping(address => uint256) internal tokenBalanceLedger;
262     // amount of eth withdrawn
263     mapping(address => int256) internal payoutsTo;
264     // amount of tokens allowed to someone else 
265     mapping(address => mapping(address => uint)) allowed;
266     // the actual amount of tokens
267     uint256 internal tokenSupply = 0;
268     // the amount of dividends per token
269     uint256 internal profitPerShare;
270     
271     /*=======================================
272     =            PUBLIC FUNCTIONS            =
273     =======================================*/
274     /**
275     * -- APPLICATION ENTRY POINTS --  
276     */
277     function DivvyUp(bytes32 aName, bytes32 aSymbol, uint8 aDividendDivisor, uint8 aDecimals, uint256 aTokenPriceInitial, uint256 aTokenPriceIncremental, uint256 aMagnitude, address aCounter) 
278     public {
279         require(aDividendDivisor < 100);
280         name = aName;
281         symbol = aSymbol;
282         dividendDivisor = aDividendDivisor;
283         decimals = aDecimals;
284         tokenPriceInitial = aTokenPriceInitial;
285         tokenPriceIncremental = aTokenPriceIncremental;
286         magnitude = aMagnitude;
287         counter = aCounter;    
288     }
289     
290     /**
291      * Allows the owner to change the name of the contract
292      */
293     function changeName(bytes32 newName) onlyOwner() public {
294         name = newName;
295         
296     }
297     
298     /**
299      * Allows the owner to change the symbol of the contract
300      */
301     function changeSymbol(bytes32 newSymbol) onlyOwner() public {
302         symbol = newSymbol;
303     }
304     
305     /**
306      * Converts all incoming counter to tokens for the caller
307      */
308     function purchaseTokens()
309         public
310         payable
311         returns(uint256)
312     {
313         if(msg.value > 0){
314             require(counter == 0x0);
315         }
316         return purchaseTokens(msg.value);
317     }
318     
319 
320     /**
321      * Converts all incoming counter to tokens for the caller
322      */
323     function purchaseTokensERC20(uint256 amount)
324         public
325         erc20Destination
326         returns(uint256)
327     {
328         require(ERC20Interface(counter).transferFrom(msg.sender, this, amount));
329         return purchaseTokens(amount);
330     }
331 
332 
333         /**
334      * Fallback function to handle counter that was send straight to the contract.
335      * Causes tokens to be purchased.
336      */
337     function()
338         payable
339         public
340     {
341         if(msg.value > 0){
342             require(counter == 0x0);
343         }
344         purchaseTokens(msg.value);
345     }
346     
347      
348     /**
349      * Converts all of caller's dividends to tokens.
350      */
351     function reinvestDividends()
352         onlyDividendHolders()
353         public
354         returns (uint256)
355     {
356         // fetch dividends
357         uint256 dividends = myDividends(); 
358        
359         // pay out the dividends virtually
360         address customerAddress = msg.sender;
361         payoutsTo[customerAddress] += (int256) (dividends * magnitude);
362         
363         // dispatch a buy order with the virtualized "withdrawn dividends" if we have dividends
364         uint256 tokens = purchaseTokens(dividends);
365         
366         // fire event
367         emit Reinvestment(customerAddress, dividends, tokens);
368         
369         return tokens;
370     }
371     
372     /**
373      * Alias of sell() and withdraw().
374      */
375     function exit()
376         public
377     {
378         // get token count for caller & sell them all
379         address customerAddress = msg.sender;
380         uint256 tokens = tokenBalanceLedger[customerAddress];
381         if(tokens > 0) {
382             sell(tokens);
383         }
384         // lambo delivery service
385         withdraw();
386     }
387 
388     /**
389      * Withdraws all of the callers earnings.
390      */
391     function withdraw()
392         onlyDividendHolders()
393         public
394     {
395         // setup data
396         address customerAddress = msg.sender;
397         uint256 dividends = myDividends(); 
398 
399         // update dividend tracker
400         payoutsTo[customerAddress] += (int256) (dividends * magnitude);
401                 
402         // fire event
403         emit Withdraw(customerAddress, dividends);
404     }
405     
406     /**
407      * Liquifies tokens to counter.
408      */
409     function sell(uint256 amountOfTokens)
410         onlyTokenHolders()
411         public
412     {
413         require(amountOfTokens > 0);
414         // setup data
415         address customerAddress = msg.sender;
416         // russian hackers BTFO
417         require(amountOfTokens <= tokenBalanceLedger[customerAddress]);
418         uint256 tokens = amountOfTokens;
419         uint256 counterAmount = tokensToCounter(tokens);
420         uint256 dividends = dividendDivisor > 0 ? SafeMath.div(counterAmount, dividendDivisor) : 0;
421         uint256 taxedCounter = SafeMath.sub(counterAmount, dividends);
422         
423         // burn the sold tokens
424         tokenSupply = SafeMath.sub(tokenSupply, tokens);
425         tokenBalanceLedger[customerAddress] = SafeMath.sub(tokenBalanceLedger[customerAddress], tokens);
426         
427         // update dividends tracker
428         int256 updatedPayouts = (int256) (profitPerShare * tokens + (taxedCounter * magnitude));
429         payoutsTo[customerAddress] -= updatedPayouts;       
430         
431         // dividing by zero is a bad idea
432         if (tokenSupply > 0 && dividendDivisor > 0) {
433             // update the amount of dividends per token
434             profitPerShare = SafeMath.add(profitPerShare, (dividends * magnitude) / tokenSupply);
435         }
436         
437         // fire event
438         emit Sell(customerAddress, tokens, taxedCounter);
439     }
440     
441     /**
442      * Transfer tokens from the caller to a new holder.
443      * Transfering ownership of tokens requires settling outstanding dividends
444      * and transfering them back. You can therefore send 0 tokens to this contract to
445      * trigger your withdraw.
446      */
447     function transfer(address toAddress, uint256 amountOfTokens)
448         onlyTokenHolders
449         public
450         returns(bool)
451     {
452 
453        // Sell on transfer in instad of transfering to
454         if(toAddress == address(this)){
455             // If we sent in tokens, destroy them and credit their account with ETH
456             if(amountOfTokens > 0){
457                 sell(amountOfTokens);
458             }
459             // Send them their ETH
460             withdraw();
461             // fire event
462             emit Transfer(0x0, msg.sender, amountOfTokens);
463 
464             return true;
465         }
466        
467         // Deal with outstanding dividends first
468         if(myDividends() > 0) {
469             withdraw();
470         }
471         
472         return _transfer(toAddress, amountOfTokens);
473     }
474 
475     function transferWithDividends(address toAddress, uint256 amountOfTokens) public onlyTokenHolders returns (bool) {
476         return _transfer(toAddress, amountOfTokens);
477     }
478 
479     function _transfer(address toAddress, uint256 amountOfTokens)
480         internal
481         onlyTokenHolders
482         returns(bool)
483     {
484         // setup
485         address customerAddress = msg.sender;
486         
487         // make sure we have the requested tokens
488         require(amountOfTokens <= tokenBalanceLedger[customerAddress]);
489        
490         // exchange tokens
491         tokenBalanceLedger[customerAddress] = SafeMath.sub(tokenBalanceLedger[customerAddress], amountOfTokens);
492         tokenBalanceLedger[toAddress] = SafeMath.add(tokenBalanceLedger[toAddress], amountOfTokens);
493         
494         // fire event
495         emit Transfer(customerAddress, toAddress, amountOfTokens);
496 
497 
498         return true;
499        
500     }
501 
502     // ERC20 
503 
504     function approve(address spender, uint tokens) public returns (bool success) {
505         allowed[msg.sender][spender] = tokens;
506         emit Approval(msg.sender, spender, tokens);
507         return true;
508     }
509 
510 
511     /**
512     * Transfer `tokens` from the `from` account to the `to` account
513     * 
514     * The calling account must already have sufficient tokens approve(...)-d
515     * for spending from the `from` account and
516     * - From account must have sufficient balance to transfer
517     * - Spender must have sufficient allowance to transfer
518     * - 0 value transfers are allowed
519     * 
520     * Implementation taken from ERC20 reference
521     * 
522     */
523     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
524         tokenBalanceLedger[from] = tokenBalanceLedger[from].sub(tokens);
525         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
526         tokenBalanceLedger[to] = tokenBalanceLedger[to].add(tokens);
527         emit Transfer(from, to, tokens);
528         return true;
529     }
530 
531     /**
532     * Returns the amount of tokens approved by the owner that can be
533     * transferred to the spender's account
534     * 
535     * Implementation taken from ERC20 reference
536     * 
537     */
538     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
539         return allowed[tokenOwner][spender];
540     }
541 
542     /**
543     * Token owner can approve for `spender` to transferFrom(...) `tokens`
544     * from the token owner's account. The `spender` contract function
545     * `receiveApproval(...)` is then executed
546     * 
547     */
548     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
549         allowed[msg.sender][spender] = tokens;
550         emit Approval(msg.sender, spender, tokens);
551         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
552         return true;
553     }
554 
555     /*----------  HELPERS AND CALCULATORS  ----------*/
556     /**
557      * Method to view the current Counter stored in the contract
558      * Example: totalDestinationBalance()
559      */
560     function totalDestinationBalance()
561         public
562         view
563         returns(uint256)
564     {
565         if(counter == 0x0){
566             return address(this).balance;
567         } else {
568             return ERC20Interface(counter).balanceOf(this);
569         }
570     }
571     
572     /**
573      * Retrieve the name of the token.
574      */
575     function name() 
576         public 
577         view 
578         returns(bytes32)
579     {
580         return name;
581     }
582      
583 
584     /**
585      * Retrieve the symbol of the token.
586      */
587     function symbol() 
588         public
589         view
590         returns(bytes32)
591     {
592         return symbol;
593     }
594      
595     /**
596      * Retrieve the total token supply.
597      */
598     function totalSupply()
599         public
600         view
601         returns(uint256)
602     {
603         return tokenSupply;
604     }
605     
606     /**
607      * Retrieve the tokens owned by the caller.
608      */
609     function myTokens()
610         public
611         view
612         returns(uint256)
613     {
614         address customerAddress = msg.sender;
615         return balanceOf(customerAddress);
616     }
617     
618     /**
619     * Retrieve the dividends owned by the caller.
620     */
621 
622     function myDividends() 
623         public 
624         view 
625         returns(uint256)
626     {
627         address customerAddress = msg.sender;
628 
629         return (uint256) ((int256)(profitPerShare * tokenBalanceLedger[customerAddress]) - payoutsTo[customerAddress]) / magnitude;
630     }
631     
632     /**
633      * Retrieve the token balance of any single address.
634      */
635     function balanceOf(address customerAddress)
636         view
637         public
638         returns(uint256)
639     {
640         return tokenBalanceLedger[customerAddress];
641     }
642     
643     
644     /**
645      * Return the buy price of 1 individual token.
646      */
647     function sellPrice() 
648         public 
649         view 
650         returns(uint256)
651     {
652         // our calculation relies on the token supply, so we need supply. Doh.
653         if(tokenSupply == 0){
654             return tokenPriceInitial - tokenPriceIncremental;
655         } else {
656             uint256 counterAmount = tokensToCounter(1e18);
657             uint256 dividends = SafeMath.div(counterAmount, dividendDivisor);
658             uint256 taxedCounter = SafeMath.sub(counterAmount, dividends);
659             return taxedCounter;
660         }
661     }
662     
663     /**
664      * Return the sell price of 1 individual token.
665      */
666     function buyPrice() 
667         public 
668         view 
669         returns(uint256)
670     {
671         // our calculation relies on the token supply, so we need supply. Doh.
672         if(tokenSupply == 0){
673             return tokenPriceInitial + tokenPriceIncremental;
674         } else {
675             uint256 counterAmount = tokensToCounter(1e18);
676             uint256 dividends = SafeMath.div(counterAmount, dividendDivisor);
677             uint256 taxedCounter = SafeMath.add(counterAmount, dividends);
678             return taxedCounter;
679         }
680     }
681     
682     /**
683      * Function for the frontend to dynamically retrieve the price scaling of buy orders.
684      */
685     function calculateTokensReceived(uint256 counterToSpend) 
686         public 
687         view 
688         returns(uint256)
689     {
690         uint256 dividends = SafeMath.div(counterToSpend, dividendDivisor);
691         uint256 taxedCounter = SafeMath.sub(counterToSpend, dividends);
692         uint256 amountOfTokens = counterToTokens(taxedCounter);
693         
694         return amountOfTokens;
695     }
696     
697     /**
698      * Function for the frontend to dynamically retrieve the price scaling of sell orders.
699      */
700     function calculateCounterReceived(uint256 tokensToSell) 
701         public 
702         view 
703         returns(uint256)
704     {
705         require(tokensToSell <= tokenSupply);
706         uint256 counterAmount = tokensToCounter(tokensToSell);
707         uint256 dividends = SafeMath.div(counterAmount, dividendDivisor);
708         uint256 taxedCounter = SafeMath.sub(counterAmount, dividends);
709         return taxedCounter;
710     }
711     
712     /*==========================================
713     =            INTERNAL FUNCTIONS            =
714     ==========================================*/
715     function purchaseTokens(uint256 incomingCounter)
716         internal
717         returns(uint256)
718     {
719         if(incomingCounter == 0){
720             return reinvestDividends();
721         }
722 
723 
724         
725         // book keeping
726         address customerAddress = msg.sender;
727 //     uint256 undividedDividends = dividendDivisor > 0 ? SafeMath.div(incomingCounter, dividendDivisor) : 0;
728 //this was ref bonus 
729         uint256 dividends = dividendDivisor > 0 ? SafeMath.div(incomingCounter, dividendDivisor) : 0;
730         uint256 taxedCounter = SafeMath.sub(incomingCounter, dividends);
731         uint256 amountOfTokens = counterToTokens(taxedCounter);
732         uint256 fee = dividends * magnitude;
733  
734         // prevents overflow
735         assert(amountOfTokens > 0 && (SafeMath.add(amountOfTokens,tokenSupply) > tokenSupply));
736                
737         // Start making sure we can do the math. No token holders means no dividends, yet.
738         if(tokenSupply > 0){
739             
740             // add tokens to the pool
741             tokenSupply = SafeMath.add(tokenSupply, amountOfTokens);
742  
743             // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
744             profitPerShare += (dividends * magnitude / (tokenSupply));
745             
746             // calculate the amount of tokens the customer receives 
747             fee = dividendDivisor > 0 ? fee - (fee-(amountOfTokens * (dividends * magnitude / (tokenSupply)))) : 0x0;
748         
749         } else {
750             // add tokens to the pool
751             tokenSupply = amountOfTokens;
752         }
753         
754         // update circulating supply & the ledger address for the customer
755         tokenBalanceLedger[customerAddress] = SafeMath.add(tokenBalanceLedger[customerAddress], amountOfTokens);
756         
757         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them
758         int256 updatedPayouts = (int256) ((profitPerShare * amountOfTokens) - fee);
759         payoutsTo[customerAddress] += updatedPayouts;
760         
761         // fire events
762         emit Purchase(customerAddress, incomingCounter, amountOfTokens);
763         emit Transfer(0x0, customerAddress, amountOfTokens);
764         return amountOfTokens;
765     }
766 
767     /**
768      * Calculate Token price based on an amount of incoming counter
769      */
770     function counterToTokens(uint256 counterAmount)
771         internal
772         view
773         returns(uint256)
774     {
775         uint256 tokenPrice = tokenPriceInitial * 1e18;
776         uint256 tokensReceived = ((SafeMath.sub((sqrt((tokenPrice**2)+(2*(tokenPriceIncremental * 1e18)*(counterAmount * 1e18))+(((tokenPriceIncremental)**2)*(tokenSupply**2))+(2*(tokenPriceIncremental)*tokenPrice*tokenSupply))), tokenPrice))/(tokenPriceIncremental))-(tokenSupply);  
777         return tokensReceived;
778     }
779     
780     /**
781      * Calculate token sell value.
782      */
783     function tokensToCounter(uint256 tokens)
784         internal
785         view
786         returns(uint256)
787     {
788 
789         uint256 theTokens = (tokens + 1e18);
790         uint256 theTokenSupply = (tokenSupply + 1e18);
791         // underflow attempts BTFO
792         uint256 etherReceived = (SafeMath.sub((((tokenPriceInitial + (tokenPriceIncremental * (theTokenSupply/1e18)))-tokenPriceIncremental)*(theTokens - 1e18)),(tokenPriceIncremental*((theTokens**2-theTokens)/1e18))/2)/1e18);
793         return etherReceived;
794     }
795     
796     //This is where all your gas goes, sorry
797     //Not sorry, you probably only paid 1 gwei
798     function sqrt(uint x) internal pure returns (uint y) {
799         uint z = (x + 1) / 2;
800         y = x;
801         while (z < y) {
802             y = z;
803             z = (x / z + z) / 2;
804         }
805     }
806 
807     /**
808     * Owner can transfer out any accidentally sent ERC20 tokens
809     * 
810     * Implementation taken from ERC20 reference
811     * 
812     */
813     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
814         require(tokenAddress != counter);
815         return ERC20Interface(tokenAddress).transfer(owner, tokens);
816     }
817 }