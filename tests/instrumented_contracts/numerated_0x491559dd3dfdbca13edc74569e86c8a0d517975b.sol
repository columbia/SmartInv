1 pragma solidity ^0.4.15;
2 
3 /**
4 * assert(2 + 2 is 4 - 1 thats 3) Quick Mafs 
5 */
6 library QuickMafs {
7     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
8         uint256 c = _a * _b;
9         assert(_a == 0 || c / _a == _b);
10         return c;
11     }
12 
13     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
14         assert(_b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = _a / _b;
16         return c;
17     }
18 
19     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
20         assert(_b <= _a);
21         return _a - _b;
22     }
23 
24     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
25         uint256 c = _a + _b;
26         assert(c >= _a);
27         return c;
28     }
29 }
30 
31 
32 /** 
33 * The ownable contract contains an owner address. This give us simple ownership privledges and can allow ownship transfer. 
34 */
35 contract Ownable {
36 
37      /** 
38      * The owner/admin of the contract
39      */ 
40      address public owner;
41     
42      /**
43      * Constructor for contract. Sets The contract creator to the default owner.
44      */
45      function Ownable() public {
46          owner = msg.sender;
47      }
48     
49     /**
50     * Modifier to apply to methods to restrict access to the owner
51     */
52      modifier onlyOwner(){
53          require(msg.sender == owner);
54          _; //Placeholder for method content
55      }
56     
57     /**
58     * Transfer the ownership to a new owner can only be done by the current owner. 
59     */
60     function transferOwnership(address _newOwner) public onlyOwner {
61     
62         //Only make the change if required
63         if (_newOwner != address(0)) {
64             owner = _newOwner;
65         }
66     }
67 }
68 
69 
70 /**
71 *  ERC Token Standard #20 Interface
72 */
73 contract ERC20 {
74     
75     /**
76     * Get the total token supply
77     */
78     function totalSupply() public constant returns (uint256 _totalSupply);
79     
80     /**
81     * Get the account balance of another account with address _owner
82     */
83     function balanceOf(address _owner) public constant returns (uint256 balance);
84     
85     /**
86     * Send _amount of tokens to address _to
87     */
88     function transfer(address _to, uint256 _amount) public returns (bool success);
89     
90     /**
91     * Send _amount of tokens from address _from to address _to
92     */
93     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
94     
95     /**
96     * Allow _spender to withdraw from your account, multiple times, up to the _amount.
97     * If this function is called again it overwrites the current allowance with _amount.
98     * this function is required for some DEX functionality
99     */
100     function approve(address _spender, uint256 _amount) public returns (bool success);
101     
102     /**
103     * Returns the amount which _spender is still allowed to withdraw from _owner
104     */
105     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
106     
107     /**
108     * Triggered when tokens are transferred.
109     */
110     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
111     
112     /**
113     * Triggered whenever approve(address _spender, uint256 _amount) is called.
114     */
115     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
116 }
117 
118 
119 /**
120 * The CTN Token
121 */
122 contract Token is ERC20, Ownable {
123 
124     using QuickMafs for uint256;
125     
126     string public constant SYMBOL = "CTN";
127     string public constant NAME = "Crypto Trust Network";
128     uint8 public constant DECIMALS = 18;
129     
130     /**
131     * Total supply of tokens
132     */
133     uint256 totalTokens;
134     
135     /**
136     * The initial supply of coins before minting
137      */
138     uint256 initialSupply;
139     
140     /**
141     * Balances for each account
142     */
143     mapping(address => uint256) balances;
144     
145     /**
146     * Whos allowed to withdrawl funds from which accounts
147     */
148     mapping(address => mapping (address => uint256)) allowed;
149     
150     /**
151      * If the token is tradable
152      */ 
153      bool tradable;
154      
155     /**
156     * The address to store the initialSupply
157     */
158     address public vault;
159     
160     /**
161     * If the coin can be minted
162     */
163     bool public mintingFinished = false;
164     
165     /**
166      * Event for when new coins are created 
167      */
168     event Mint(address indexed _to, uint256 _value);
169     
170     /**
171     * Event that is fired when token sale is over
172     */
173     event MintFinished();
174     
175     /**
176      * Tokens can now be traded
177      */ 
178     event TradableTokens(); 
179     
180     /**
181      * Allows this coin to be traded between users
182      */ 
183     modifier isTradable(){
184         require(tradable);
185         _;
186     }
187     
188     /**
189      * If this coin can be minted modifier
190      */
191     modifier canMint() {
192         require(!mintingFinished);
193         _;
194     }
195     
196     /**
197     * Initializing the token, setting the owner, initial supply & vault
198     */
199     function Token() public {
200         initialSupply = 4500000 * 1 ether;
201         totalTokens = initialSupply;
202         tradable = false;
203         vault = 0x6e794AAA2db51fC246b1979FB9A9849f53919D1E; 
204         balances[vault] = balances[vault].add(initialSupply); //Set initial supply to the vault
205     }
206     
207     /**
208     * Obtain current total supply of CTN tokens 
209     */
210     function totalSupply() public constant returns (uint256 totalAmount) {
211           totalAmount = totalTokens;
212     }
213     
214     /**
215     * Get the initial supply of CTN coins 
216     */
217     function baseSupply() public constant returns (uint256 initialAmount) {
218           initialAmount = initialSupply;
219     }
220     
221     /**
222     * Returns the balance of a wallet
223     */ 
224     function balanceOf(address _address) public constant returns (uint256 balance) {
225         return balances[_address];
226     }
227     
228     /**
229     * Transfer CTN between wallets
230     */ 
231     function transfer(address _to, uint256 _amount) public isTradable returns (bool) {
232         balances[msg.sender] = balances[msg.sender].sub(_amount);
233         balances[_to] = balances[_to].add(_amount);
234         Transfer(msg.sender, _to, _amount);
235         return true;
236     }
237 
238     /**
239     * Send _amount of tokens from address _from to address _to
240     * The transferFrom method is used for a withdraw workflow, allowing contracts to send
241     * tokens on your behalf, for example to "deposit" to a contract address and/or to charge
242     * fees in sub-currencies; the command should fail unless the _from account has
243     * deliberately authorized the sender of the message via some mechanism; we propose
244     * these standardized APIs for approval:
245     */
246     function transferFrom(
247         address _from,
248         address _to,
249         uint256 _amount
250     ) public isTradable returns (bool success) 
251     {
252         var _allowance = allowed[_from][msg.sender];
253     
254         /** 
255         *   QuickMaf will roll back any changes so no need to check before these operations
256         */
257         balances[_to] = balances[_to].add(_amount);
258         balances[_from] = balances[_from].sub(_amount);
259         allowed[_from][msg.sender] = _allowance.sub(_amount);
260         Transfer(_from, _to, _amount);
261         return true;  
262     }
263 
264     /**
265     * Allows an address to transfer money out this is administered by the contract owner who can specify how many coins an account can take.
266     * Needs to be called to feault the amount to 0 first -> https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267     */
268     function approve(address _spender, uint256 _amount) public returns (bool) {
269         /**
270         *Set the amount they are able to spend to 0 first so that transaction ordering cannot allow multiple withdrawls asyncly
271         *This function always requires to calls if a user has an amount they can withdrawl.
272         */
273         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
274     
275         allowed[msg.sender][_spender] = _amount;
276         Approval(msg.sender, _spender, _amount);
277         return true;
278     }
279 
280 
281     /**
282      * Check the amount of tokens the owner has allowed to a spender
283      */
284     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
285          return allowed[_owner][_spender];
286     }
287 
288     /**
289      * Makes the coin tradable between users cannot be undone
290      */
291     function makeTradable() public onlyOwner {
292         tradable = true;
293         TradableTokens();
294     }
295     
296     /**
297     * Mint tokens to users
298     */
299     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
300         totalTokens = totalTokens.add(_amount);
301         balances[_to] = balances[_to].add(_amount);
302         Mint(_to, _amount);
303         return true;
304     }
305 
306     /**
307     * Function to stop minting tokens irreversable
308     */
309     function finishMinting() public onlyOwner returns (bool) {
310         mintingFinished = true;
311         MintFinished();
312         return true;
313     }
314 }
315 
316 
317 /**
318 * The initial crowdsale of the token
319 */
320 contract Sale is Ownable {
321 
322 
323     using QuickMafs for uint256;
324     
325     /**
326      * The hard cap of the token sale
327      */
328     uint256 hardCap;
329     
330     /**
331      * The soft cap of the token sale
332      */
333     uint256 softCap;
334     
335     /**
336      * The bonus cap for the token sale
337      */
338     uint256 bonusCap;
339     
340     /**
341      * How many tokens you get per ETH
342      */
343     uint256 tokensPerETH;
344     
345     /** 
346     * //the start time of the sale (new Date("Jan 22 2018 18:00:00 GMT").getTime() / 1000)
347     */
348     uint256 public start = 1516644000;
349                 
350     
351     /**
352      * The end time of the sale (new Date("Feb 22 2018 18:00:00 GMT").getTime() / 1000)
353      */ 
354     uint256 public end = 1519322400;
355     
356     /**
357      * Two months after the sale ends used to retrieve unclaimed refunds (new Date("Apr 22 2018 18:00:00 GMT").getTime() / 1000)
358      */
359     uint256 public twoMonthsLater = 1524420000;
360     
361     /**
362     * Token for minting purposes
363     */
364     Token public token;
365     
366     /**
367     * The address to store eth in during sale 
368     */
369     address public vault;
370     
371     
372     /**
373     * How much ETH each user has sent to this contract. For softcap unmet refunds
374     */
375     mapping(address => uint256) investments;
376     
377     
378     /**
379     * Every purchase during the sale
380     */
381     event TokenSold(address recipient, uint256 etherAmount, uint256 ctnAmount, bool preSale, bool bonus);
382     
383     
384     /**
385     * Triggered when tokens are transferred.
386     */
387     event PriceUpdated(uint256 amount);
388     
389     /**
390     * Only make certain changes before the sale starts
391     */
392     modifier isPreSale(){
393          require(now < start);
394         _;
395     }
396     
397     /**
398     * Is the sale still on
399     */
400     modifier isSaleOn() {
401         require(now >= start && now <= end);
402         _;
403     }
404     
405     /**
406     * Has the sale completed
407     */
408     modifier isSaleFinished() {
409         
410         bool hitHardCap = token.totalSupply().sub(token.baseSupply()) >= hardCap;
411         require(now > end || hitHardCap);
412         
413         _;
414     }
415     
416     /**
417     * Has the sale completed
418     */
419     modifier isTwoMonthsLater() {
420         require(now > twoMonthsLater);
421         _;
422     }
423     
424     /**
425     * Make sure we are under the hardcap
426     */
427     modifier isUnderHardCap() {
428     
429         bool underHard = token.totalSupply().sub(token.baseSupply()) <= hardCap;
430         require(underHard);
431         _;
432     }
433     
434     /**
435     * Make sure we are over the soft cap
436     */
437     modifier isOverSoftCap() {
438         bool overSoft = token.totalSupply().sub(token.baseSupply()) >= softCap;
439         require(overSoft);
440         _;
441     }
442     
443     /**
444     * Make sure we are over the soft cap
445     */
446     modifier isUnderSoftCap() {
447         bool underSoft = token.totalSupply().sub(token.baseSupply()) < softCap;
448         require(underSoft);
449         _;
450     }
451     
452     /** 
453     *   The token sale constructor
454     */
455     function Sale() public {
456         hardCap = 10500000 * 1 ether;
457         softCap = 500000 * 1 ether;
458         bonusCap = 2000000 * 1 ether;
459         tokensPerETH = 630; //Tokens per 1 ETH
460         token = new Token();
461         vault = 0x6e794AAA2db51fC246b1979FB9A9849f53919D1E; 
462     }
463     
464     /**
465     * Fallback function which receives ether and created the appropriate number of tokens for the 
466     * msg.sender.
467     */
468     function() external payable {
469         //If we can not purchase tokens presale then try purchase them normally
470         if ( now < start ) {
471             purchaseTokensPreSale(msg.sender);
472         } else {
473             purchaseTokens(msg.sender);
474         }
475     }
476        
477     /**
478     * If the soft cap has not been reached and the sale is over investors can reclaim their funds
479     */ 
480     function refund() public isSaleFinished isUnderSoftCap {
481         uint256 amount = investments[msg.sender];
482         investments[msg.sender] = investments[msg.sender].sub(amount);
483         msg.sender.transfer(amount);
484     }
485     
486     /**
487     * Withdrawl the funds from the contract.
488     * Make the token tradeable and finish minting
489     */ 
490     function withdrawl() public isSaleFinished isOverSoftCap {
491         vault.transfer(this.balance);
492         
493         //Stop minting of the token and make the token tradeable
494         token.finishMinting();
495         token.makeTradable();
496     }
497     
498     /**
499     * Update the ETH price for the token sale
500     */
501     function updatePrice(uint256 _newPrice) public onlyOwner isPreSale {
502         tokensPerETH = _newPrice;
503         PriceUpdated(_newPrice);
504     }
505 
506     /**
507     * Temp function for change start times for debuging
508      */
509     function updateStart(uint256 _newStart) public onlyOwner {
510         start = _newStart;
511     }
512     
513     /**
514     * The pre sale purchase of tokens. Is avaliable up until the soft cap is hit.
515      */
516     function purchaseTokensPreSale(address recipient) public isUnderSoftCap isPreSale payable {    
517         uint256 amount = msg.value;
518         uint256 tokens = tokensPerETH.mul(amount);
519 
520         //Tokens purchased pre sale get an additional 25% CTN
521         tokens = tokens.add(tokens.div(4));
522      
523         //Add the amount to a users investment total
524         investments[msg.sender] = investments[msg.sender].add(msg.value);
525         
526         token.mint(recipient, tokens);
527         
528         TokenSold(recipient, amount, tokens, true, true);
529     }
530     
531     /**
532     * Allows user to buy coins if we are under the hardcap also adds a bonus if under the bonus amount
533     */
534     function purchaseTokens(address recipient) public isUnderHardCap isSaleOn payable {
535         uint256 amount = msg.value;
536         uint256 tokens = tokensPerETH.mul(amount);
537         bool bonus = false;
538         
539         if (token.totalSupply().sub(token.baseSupply()) < bonusCap) {          
540             bonus = true;
541 
542             //Tokens purchased before the bonus cap get an additional 20% CTN
543             tokens = tokens.add(tokens.div(5));
544         }
545 
546         //Add the amount to user investment total
547         investments[msg.sender] = investments[msg.sender].add(msg.value);
548         
549         token.mint(recipient, tokens);
550         
551         TokenSold(recipient, amount, tokens, false, bonus);
552     }
553     
554     /**
555      * Withdrawl the funds from the contract.
556      * Make the token tradeable and finish minting
557      */ 
558     function cleanup() public isTwoMonthsLater {
559         vault.transfer(this.balance);
560         token.finishMinting();
561         token.makeTradable();
562     }
563     
564     function destroy() public onlyOwner isTwoMonthsLater {
565          token.finishMinting();
566          token.makeTradable();
567          token.transferOwnership(owner);
568          selfdestruct(vault);
569     }
570     
571     /**
572      * Get the ETH balance of this contract
573      */ 
574     function getBalance() public constant returns (uint256 totalAmount) {
575           totalAmount = this.balance;
576     }
577 }