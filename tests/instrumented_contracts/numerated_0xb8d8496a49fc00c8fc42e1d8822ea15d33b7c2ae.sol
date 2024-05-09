1 /// @title SafeMath
2 /// @dev Math operations with safety checks that throw on error
3 library SafeMath {
4     /// @dev Multiplies a times b
5     function mul(uint256 a, uint256 b) 
6     internal 
7     pure
8     returns (uint256) 
9     {
10         uint256 c = a * b;
11         require(a == 0 || c / a == b);
12         return c;
13     }
14 
15     /// @dev Divides a by b
16     function div(uint256 a, uint256 b) 
17     internal 
18     pure
19     returns (uint256) 
20     {
21         // require(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // require(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /// @dev Subtracts a from b
28     function sub(uint256 a, uint256 b) 
29     internal 
30     pure
31     returns (uint256) 
32     {
33         require(b <= a);
34         return a - b;
35     }
36 
37     /// @dev Adds a to b
38     function add(uint256 a, uint256 b) 
39     internal 
40     pure
41     returns (uint256) 
42     {
43         uint256 c = a + b;
44         require(c >= a);
45         return c;
46     }
47 }
48 
49 
50 
51 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
52 /// @title Abstract token contract - Functions to be implemented by token contracts
53 contract Token {
54     /*
55      * Events
56      */
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 
60     /*
61      * Public functions
62      */
63     function transfer(address to, uint256 value) public returns (bool);
64     function transferFrom(address from, address to, uint256 value) public returns (bool);
65     function approve(address spender, uint256 value) public returns (bool);
66     function balanceOf(address owner) public constant returns (uint256);
67     function allowance(address owner, address spender) public constant returns (uint256);
68     uint256 public totalSupply;
69 }
70 
71 
72 /// @title Standard token contract - Standard token interface implementation
73 contract StandardToken is Token {
74   using SafeMath for uint256;
75     /*
76      *  Storage
77      */
78     mapping (address => uint256) public balances;
79     mapping (address => mapping (address => uint256)) public allowances;
80     uint256 public totalSupply;
81 
82     /*
83      *  Public functions
84      */
85     /// @dev Transfers sender's tokens to a given address. Returns success
86     /// @param to Address of token receiver
87     /// @param value Number of tokens to transfer
88     /// @return Returns success of function call
89     function transfer(address to, uint256 value)
90         public
91         returns (bool)
92     {
93         require(to != address(0));
94         require(value <= balances[msg.sender]);
95         balances[msg.sender] = balances[msg.sender].sub(value);
96         balances[to] = balances[to].add(value);
97         Transfer(msg.sender, to, value);
98         return true;
99     }
100 
101     /// @dev Allows allowances third party to transfer tokens from one address to another. Returns success
102     /// @param from Address from where tokens are withdrawn
103     /// @param to Address to where tokens are sent
104     /// @param value Number of tokens to transfer
105     /// @return Returns success of function call
106     function transferFrom(address from, address to, uint256 value)
107         public
108         returns (bool)
109     {
110         // if (balances[from] < value || allowances[from][msg.sender] < value)
111         //     // Balance or allowance too low
112         //     revert();
113         require(to != address(0));
114         require(value <= balances[from]);
115         require(value <= allowances[from][msg.sender]);
116         balances[to] = balances[to].add(value);
117         balances[from] = balances[from].sub(value);
118         allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
119         Transfer(from, to, value);
120         return true;
121     }
122 
123     /// @dev Sets approved amount of tokens for spender. Returns success
124     /// @param _spender Address of allowances account
125     /// @param value Number of approved tokens
126     /// @return Returns success of function call
127     function approve(address _spender, uint256 value)
128         public
129         returns (bool success)
130     {
131         require((value == 0) || (allowances[msg.sender][_spender] == 0));
132         allowances[msg.sender][_spender] = value;
133         Approval(msg.sender, _spender, value);
134         return true;
135     }
136 
137  /**
138    * approve should be called when allowances[_spender] == 0. To increment
139    * allowances value is better to use this function to avoid 2 calls (and wait until
140    * the first transaction is mined)
141    * From MonolithDAO Token.sol
142    */
143     function increaseApproval(address _spender, uint _addedValue)
144         public
145         returns (bool)
146     {
147         allowances[msg.sender][_spender] = allowances[msg.sender][_spender].add(_addedValue);
148         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
149         return true;
150     }
151 
152     function decreaseApproval(address _spender, uint _subtractedValue)
153         public
154         returns (bool) 
155     {
156         uint oldValue = allowances[msg.sender][_spender];
157         if (_subtractedValue > oldValue) {
158             allowances[msg.sender][_spender] = 0;
159         } else {
160             allowances[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161         }
162         Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
163         return true;
164     }
165 
166     /// @dev Returns number of allowances tokens for given address
167     /// @param _owner Address of token owner
168     /// @param _spender Address of token spender
169     /// @return Returns remaining allowance for spender
170     function allowance(address _owner, address _spender)
171         public
172         constant
173         returns (uint256)
174     {
175         return allowances[_owner][_spender];
176     }
177 
178     /// @dev Returns number of tokens owned by given address
179     /// @param _owner Address of token owner
180     /// @return Returns balance of owner
181     function balanceOf(address _owner)
182         public
183         constant
184         returns (uint256)
185     {
186         return balances[_owner];
187     }
188 }
189 
190 
191 contract Balehubuck is StandardToken {
192     using SafeMath for uint256;
193     /*
194      *  Constants
195      */
196     string public constant name = "balehubuck";
197     string public constant symbol = "BUX";
198     uint8 public constant decimals = 18;
199     uint256 public constant TOTAL_SUPPLY = 1000000000 * 10**18;
200     // Presale Allocation = 500 * (5000 + 4500 + 4000 + 3500 + 3250 + 3000)
201     // Main Sale Allocation = 75000 * 2500
202     // Token Sale Allocation = Presale Allocation + Main Sale Allocation
203     uint256 public constant TOKEN_SALE_ALLOCATION = 199125000 * 10**18;
204     uint256 public constant WALLET_ALLOCATION = 800875000 * 10**18;
205 
206     function Balehubuck(address wallet)
207         public
208     {
209         totalSupply = TOTAL_SUPPLY;
210         balances[msg.sender] = TOKEN_SALE_ALLOCATION;
211         balances[wallet] = WALLET_ALLOCATION;
212         // Sanity check to make sure total allocations match total supply
213         require(TOKEN_SALE_ALLOCATION + WALLET_ALLOCATION == TOTAL_SUPPLY);
214     }
215 }
216 
217 
218 contract TokenSale {
219     using SafeMath for uint256;
220     /*
221      *  Events
222      */
223     event PresaleStart(uint256 indexed presaleStartTime);
224     event AllocatePresale(address indexed receiver, uint256 tokenQuantity);
225     event PresaleEnd(uint256 indexed presaleEndTime);
226     event MainSaleStart(uint256 indexed startMainSaleTime);
227     event AllocateMainSale(address indexed receiver, uint256 etherAmount);
228     event MainSaleEnd(uint256 indexed endMainSaleTime);
229     event TradingStart(uint256 indexed startTradingTime);
230     event Refund(address indexed receiver, uint256 etherAmount);
231 
232     /*
233      *  Constants
234      */
235     // Presale Allocation = 500 * (5000 + 4500 + 4000 + 3500 + 3250 + 3000) * 10**18
236     uint256 public constant PRESALE_TOKEN_ALLOCATION = 11625000 * 10**18;
237     uint256 public constant PRESALE_MAX_RAISE = 3000 * 10**18;
238 
239     /*
240      *  Storage
241      */
242     mapping (address => uint256) public presaleAllocations;
243     mapping (address => uint256) public mainSaleAllocations;
244     address public wallet;
245     Balehubuck public token;
246     uint256 public presaleEndTime;
247     uint256 public mainSaleEndTime;
248     uint256 public minTradingStartTime;
249     uint256 public maxTradingStartTime;
250     uint256 public totalReceived;
251     uint256 public minimumMainSaleRaise;
252     uint256 public maximumMainSaleRaise;
253     uint256 public maximumAllocationPerParticipant;
254     uint256 public mainSaleExchangeRate;
255     Stages public stage;
256 
257     enum Stages {
258         Deployed,
259         PresaleStarted,
260         PresaleEnded,
261         MainSaleStarted,
262         MainSaleEnded,
263         Refund,
264         Trading
265     }
266 
267     /*
268      *  Modifiers
269      */
270     modifier onlyWallet() {
271         require(wallet == msg.sender);
272         _;
273     }
274 
275     modifier atStage(Stages _stage) {
276         require(stage == _stage);
277         _;
278     }
279 
280     /*
281      *  Fallback function
282      */
283     function ()
284         external
285         payable
286     {
287         buy(msg.sender);
288     }
289 
290     /*
291      *  Constructor function
292      */
293     // @dev Constructor function that create the Balehubuck token and sets the initial variables
294     // @param _wallet sets the wallet state variable which will be used to start stages throughout the token sale
295     function TokenSale(address _wallet)
296         public
297     {
298         require(_wallet != 0x0);
299         wallet = _wallet;
300         token = new Balehubuck(wallet);
301         // Sets the default main sale values
302         minimumMainSaleRaise = 23000 * 10**18;
303         maximumMainSaleRaise = 78000 * 10**18;
304         maximumAllocationPerParticipant = 750 * 10**18;
305         mainSaleExchangeRate = 2500;
306         stage = Stages.Deployed;
307         totalReceived = 0;
308     }
309 
310     /*
311      *  Public functions
312      */
313     // @ev Allows buyers to buy tokens, throws if neither the presale or main sale is happening
314     // @param _receiver The address the will receive the tokens
315     function buy(address _receiver)
316         public
317         payable
318     {
319         require(msg.value > 0);
320         address receiver = _receiver;
321         if (receiver == 0x0)
322             receiver = msg.sender;
323         if (stage == Stages.PresaleStarted) {
324             buyPresale(receiver);
325         } else if (stage == Stages.MainSaleStarted) {
326             buyMainSale(receiver);
327         } else {
328             revert();
329         }
330     }
331 
332     /*
333      *  External functions
334      */
335     // @dev Starts the presale
336     function startPresale()
337         external
338         onlyWallet
339         atStage(Stages.Deployed)
340     {
341         stage = Stages.PresaleStarted;
342         presaleEndTime = now + 8 weeks;
343         PresaleStart(now);
344     }
345 
346     // @dev Sets the maximum and minimum raise amounts prior to the main sale
347     // @dev Use this method with extreme caution!
348     // @param _minimumMainSaleRaise Sets the minimium main sale raise
349     // @param _maximumMainSaleRaise Sets the maximum main sale raise
350     // @param _maximumAllocationPerParticipant sets the maximum main sale allocation per participant
351     function changeSettings(uint256 _minimumMainSaleRaise,
352                             uint256 _maximumMainSaleRaise,
353                             uint256 _maximumAllocationPerParticipant,
354                             uint256 _mainSaleExchangeRate)
355         external
356         onlyWallet
357         atStage(Stages.PresaleEnded)
358     {
359         // Checks the inputs for null values
360         require(_minimumMainSaleRaise > 0 &&
361                 _maximumMainSaleRaise > 0 &&
362                 _maximumAllocationPerParticipant > 0 &&
363                 _mainSaleExchangeRate > 0);
364         // Sanity check that requires the min raise to be less then the max
365         require(_minimumMainSaleRaise < _maximumMainSaleRaise);
366         // This check verifies that the token_sale contract has enough tokens to match the
367         // _maximumMainSaleRaiseAmount * _mainSaleExchangeRate (subtracts presale amounts first)
368         require(_maximumMainSaleRaise.sub(PRESALE_MAX_RAISE).mul(_mainSaleExchangeRate) <= token.balanceOf(this).sub(PRESALE_TOKEN_ALLOCATION));
369         minimumMainSaleRaise = _minimumMainSaleRaise;
370         maximumMainSaleRaise = _maximumMainSaleRaise;
371         mainSaleExchangeRate = _mainSaleExchangeRate;
372         maximumAllocationPerParticipant = _maximumAllocationPerParticipant;
373     }
374 
375     // @dev Starts the main sale
376     // @dev Make sure the main sale variables are correct before calling
377     function startMainSale()
378         external
379         onlyWallet
380         atStage(Stages.PresaleEnded)
381     {
382         stage = Stages.MainSaleStarted;
383         mainSaleEndTime = now + 8 weeks;
384         MainSaleStart(now);
385     }
386 
387     // @dev Starts the trading stage, allowing buyer to claim their tokens
388     function startTrading()
389         external
390         atStage(Stages.MainSaleEnded)
391     {
392         // Trading starts between two weeks (if called by the wallet) and two months (callable by anyone)
393         // after the main sale has ended
394         require((msg.sender == wallet && now >= minTradingStartTime) || now >= maxTradingStartTime);
395         stage = Stages.Trading;
396         TradingStart(now);
397     }
398 
399     // @dev Allows buyer to be refunded their ETH if the minimum presale raise amount hasn't been met
400     function refund() 
401         external
402         atStage(Stages.Refund)
403     {
404         uint256 amount = mainSaleAllocations[msg.sender];
405         mainSaleAllocations[msg.sender] = 0;
406         msg.sender.transfer(amount);
407         Refund(msg.sender, amount);
408     }
409 
410     // @dev Allows buyers to claim the tokens they've purchased
411     function claimTokens()
412         external
413         atStage(Stages.Trading)
414     {
415         uint256 tokenAllocation = presaleAllocations[msg.sender].add(mainSaleAllocations[msg.sender].mul(mainSaleExchangeRate));
416         presaleAllocations[msg.sender] = 0;
417         mainSaleAllocations[msg.sender] = 0;
418         token.transfer(msg.sender, tokenAllocation);
419     }
420 
421     /*
422      *  Private functions
423      */
424     // @dev Allocated tokens to the presale buyer at a rate based on the total received
425     // @param receiver The address presale balehubucks will be allocated to
426     function buyPresale(address receiver)
427         private
428     {
429         if (now >= presaleEndTime) {
430             endPresale();
431             return;
432         }
433         uint256 totalTokenAllocation = 0;
434         uint256 oldTotalReceived = totalReceived;
435         uint256 tokenAllocation = 0;
436         uint256 weiUsing = 0;
437         uint256 weiAmount = msg.value;
438         uint256 maxWeiForPresaleStage = 0;
439         uint256 buyerRefund = 0;
440         // Cycles through the presale phases conditional giving a different exchange rate for
441         // each phase of the presale until tokens have been allocated for all Ether sent or 
442         // until the presale cap of 3,000 Ether has been reached
443         while (true) {
444             // The EVM deals with division by rounding down, causing the below statement to
445             // round down to the correct stage
446             // stageAmount = totalReceived.add(500 * 10**18).div(500 * 10**18).mul(500 * 10**18);
447             // maxWeiForPresaleStage = stageAmount - totalReceived
448             maxWeiForPresaleStage = (totalReceived.add(500 * 10**18).div(500 * 10**18).mul(500 * 10**18)).sub(totalReceived);
449             if (weiAmount > maxWeiForPresaleStage) {
450                 weiUsing = maxWeiForPresaleStage;
451             } else {
452                 weiUsing = weiAmount;
453             }
454             weiAmount = weiAmount.sub(weiUsing);
455             if (totalReceived < 500 * 10**18) {
456             // Stage 1: up to 500 Ether, exchange rate of 1 ETH for 5000 BUX
457                 tokenAllocation = calcpresaleAllocations(weiUsing, 5000);
458             } else if (totalReceived < 1000 * 10**18) {
459             // Stage 2: up to 1000 Ether, exchange rate of 1 ETH for 4500 BUX
460                 tokenAllocation = calcpresaleAllocations(weiUsing, 4500);
461             } else if (totalReceived < 1500 * 10**18) {
462             // Stage 3: up to 1500 Ether, exchange rate of 1 ETH for 4000 BUX
463                 tokenAllocation = calcpresaleAllocations(weiUsing, 4000);
464             } else if (totalReceived < 2000 * 10**18) {
465             // Stage 4: up to 2000 Ether, exchange rate of 1 ETH for 3500 BUX
466                 tokenAllocation = calcpresaleAllocations(weiUsing, 3500);
467             } else if (totalReceived < 2500 * 10**18) {
468             // Stage 5: up to 2500 Ether, exchange rate of 1 ETH for 3250 BUX
469                 tokenAllocation = calcpresaleAllocations(weiUsing, 3250);
470             } else if (totalReceived < 3000 * 10**18) {
471             // Stage 6: up to 3000 Ether, exchange rate of 1 ETH for 3000 BUX
472                 tokenAllocation = calcpresaleAllocations(weiUsing, 3000);
473             } 
474             totalTokenAllocation = totalTokenAllocation.add(tokenAllocation);
475             totalReceived = totalReceived.add(weiUsing);
476             if (totalReceived >= PRESALE_MAX_RAISE) {
477                     buyerRefund = weiAmount;
478                     endPresale();
479             }
480             // Exits the for loops if the presale cap has been reached (changing the stage)
481             // or all of the wei send to the presale has been allocated
482             if (weiAmount == 0 || stage != Stages.PresaleStarted)
483                 break;
484         }
485         presaleAllocations[receiver] = presaleAllocations[receiver].add(totalTokenAllocation);
486         wallet.transfer(totalReceived.sub(oldTotalReceived));
487         msg.sender.transfer(buyerRefund);
488         AllocatePresale(receiver, totalTokenAllocation);
489     }
490 
491     // @dev Allocated tokens to the presale buyer at a rate based on the total received
492     // @param receiver The address main sale balehubucks will be allocated to
493     function buyMainSale(address receiver)
494         private
495     {
496         if (now >= mainSaleEndTime) {
497             endMainSale(msg.value);
498             msg.sender.transfer(msg.value);
499             return;
500         }
501         uint256 buyerRefund = 0;
502         uint256 weiAllocation = mainSaleAllocations[receiver].add(msg.value);
503         if (weiAllocation >= maximumAllocationPerParticipant) {
504             weiAllocation = maximumAllocationPerParticipant.sub(mainSaleAllocations[receiver]);
505             buyerRefund = msg.value.sub(weiAllocation);
506         }
507         uint256 potentialReceived = totalReceived.add(weiAllocation);
508         if (potentialReceived > maximumMainSaleRaise) {
509             weiAllocation = maximumMainSaleRaise.sub(totalReceived);
510             buyerRefund = buyerRefund.add(potentialReceived.sub(maximumMainSaleRaise));
511             endMainSale(buyerRefund);
512         }
513         totalReceived = totalReceived.add(weiAllocation);
514         mainSaleAllocations[receiver] = mainSaleAllocations[receiver].add(weiAllocation);
515         msg.sender.transfer(buyerRefund);
516         AllocateMainSale(receiver, weiAllocation);
517     }
518 
519     // @dev Calculates the amount of presale tokens to allocate
520     // @param weiUsing The amount of wei being used to for the given token allocation
521     // @param rate The eth/token exchange rate, this changes based on how much the presale has received so far
522     function calcpresaleAllocations(uint256 weiUsing, uint256 rate)
523         private
524         pure
525         returns (uint256)
526     {
527         return weiUsing.mul(rate);
528     }
529 
530     // @dev Ends the presale
531     function endPresale()
532         private
533     {
534         stage = Stages.PresaleEnded;
535         PresaleEnd(now);
536     }
537 
538     // @dev Ends the main sale triggering a refund if the minimum sale raise has no been met 
539     // @dev or passes funds raised to the wallet and starts the trading count down
540     function endMainSale(uint256 buyerRefund)
541         private
542     {
543         if (totalReceived < minimumMainSaleRaise) {
544             stage = Stages.Refund;
545         } else {
546             minTradingStartTime = now + 2 weeks;
547             maxTradingStartTime = now + 8 weeks;
548             stage = Stages.MainSaleEnded;
549             // Transfers all funds raised to the Balehu wallet minus the funds that need to be refunded
550             wallet.transfer(this.balance.sub(buyerRefund));
551             // All unsold tokens will remain within the token_sale contract
552             // and will be treated as burned
553         }
554         MainSaleEnd(now);
555     }
556 }