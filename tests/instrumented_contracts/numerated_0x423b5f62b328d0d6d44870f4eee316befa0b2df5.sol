1 pragma solidity ^0.4.18;
2 /*
3 ---------------------------------------------------------------------------------------------
4 ---------------------------------------------------------------------------------------------
5 GoToken, a highly scalable, low cost mobile first network infrastructure for Ethereum
6 ---------------------------------------------------------------------------------------------
7 ---------------------------------------------------------------------------------------------
8 */
9 
10 contract Token {
11 /*
12 ---------------------------------------------------------------------------------------------
13     ERC20 Token standard implementation
14     https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
15     https://github.com/ethereum/EIPs/issues/20
16 
17     We didn't implement a separate totalsupply() function. Instead the public variable
18     totalSupply will automatically create a getter function to access the supply
19     of the token.
20 ---------------------------------------------------------------------------------------------
21 */
22     uint256 public totalSupply;
23 
24 /*
25     ERC20 Token Model
26 */
27     function balanceOf(address _owner) public constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) public returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30     function approve(address _who, uint256 _value) public returns (bool success);
31     function allowance(address _owner, address _who) public constant returns (uint256 remaining);
32 
33 /*
34 ---------------------------------------------------------------------------------------------
35     Events
36 ---------------------------------------------------------------------------------------------
37 */
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 
44 /// @title Standard token contract - Standard token implementation.
45 contract StandardToken is Token {
46 
47 /*
48 ---------------------------------------------------------------------------------------------
49     Storage data structures
50 ---------------------------------------------------------------------------------------------
51 */
52     mapping (address => uint256) balances;
53     mapping (address => mapping (address => uint256)) allowed;
54 
55 /*
56 ---------------------------------------------------------------------------------------------
57     Public facing functions
58 ---------------------------------------------------------------------------------------------
59 */
60 
61     /// @notice Send "_value" tokens to "_to" from "msg.sender".
62     /// @dev Transfers sender's tokens to a given address. Returns success.
63     /// @param _to Address of token receiver.
64     /// @param _value Number of tokens to transfer.
65     /// @return Returns success of function call.
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != 0x0);
68         require(_to != address(this));
69         require(balances[msg.sender] >= _value);
70         require(balances[_to] + _value >= balances[_to]);
71 
72         balances[msg.sender] -= _value;
73         balances[_to] += _value;
74 
75         emit Transfer(msg.sender, _to, _value);
76 
77         return true;
78     }
79 
80     /// @notice Transfer "_value" tokens from "_from" to "_to" if "msg.sender" is allowed.
81     /// @dev Allows for an approved third party to transfer tokens from one
82     /// address to another. Returns success.
83     /// @param _from Address from where tokens are withdrawn.
84     /// @param _to Address to where tokens are sent.
85     /// @param _value Number of tokens to transfer.
86     /// @return Returns success of function call.
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
88     {
89         //Address shouldn't be null
90         require(_from != 0x0);
91         require(_to != 0x0);
92         require(_to != address(this));
93         require(balances[_from] >= _value);
94         require(allowed[_from][msg.sender] >= _value);
95         require(balances[_to] + _value >= balances[_to]);
96 
97         balances[_to] += _value;
98         balances[_from] -= _value;
99         allowed[_from][msg.sender] -= _value;
100 
101         emit Transfer(_from, _to, _value);
102 
103         return true;
104     }
105 
106     /// @notice Approves "_who" to transfer "_value" tokens from "msg.sender" to any address.
107     /// @dev Sets approved amount of tokens for the spender. Returns success.
108     /// @param _who Address of allowed account.
109     /// @param _value Number of approved tokens.
110     /// @return Returns success of function call.
111     function approve(address _who, uint256 _value) public returns (bool) {
112 
113         // Address shouldn't be null
114         require(_who != 0x0);
115 
116         // To change the approve amount you first have to reduce the addresses`
117         // allowance to zero by calling `approve(_who, 0)` if it is not
118         // already 0 to mitigate the race condition described here:
119         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120         require(_value == 0 || allowed[msg.sender][_who] == 0);
121 
122         allowed[msg.sender][_who] = _value;
123         emit Approval(msg.sender, _who, _value);
124         return true;
125     }
126 
127     /// @dev Returns number of allowed tokens that a spender can transfer on behalf of a token owner.
128     /// @param _owner Address of token owner.
129     /// @param _who Address of token spender.
130     /// @return Returns remaining allowance for spender.
131     function allowance(address _owner, address _who) constant public returns (uint256)
132     {
133         return allowed[_owner][_who];
134     }
135 
136     /// @dev Returns number of tokens owned by a given address.
137     /// @param _owner Address of token owner.
138     /// @return Returns balance of owner.
139     function balanceOf(address _owner) constant public returns (uint256) {
140         return balances[_owner];
141     }
142 }
143 
144 
145 /// @title GoToken, a highly scalable, low cost mobile first network infrastructure for Ethereum
146 contract GoToken is StandardToken {
147 /*
148 ---------------------------------------------------------------------------------------------
149       All GoToken balances are transferable.
150       Token name, ticker symbol and decimals
151       1 token (GOT) = 1 indivisible unit * multiplier
152       The multiplier is set dynamically from token's number of decimals (i.e. 10 ** decimals)
153 
154 ---------------------------------------------------------------------------------------------
155 */
156 
157 /*
158 ---------------------------------------------------------------------------------------------
159     Storage data structures
160 ---------------------------------------------------------------------------------------------
161 */
162     string constant public name = "GoToken";
163     string constant public symbol = "GOT";
164     uint256 constant public decimals = 18;
165     uint256 constant multiplier = 10 ** (decimals);
166 
167 /*
168 ---------------------------------------------------------------------------------------------
169     Events
170 ---------------------------------------------------------------------------------------------
171 */
172     event Deployed(uint256 indexed _total_supply);
173     //event Burnt(address indexed _receiver, uint256 indexed _num, uint256 indexed _total_supply);
174 
175 /*
176 ---------------------------------------------------------------------------------------------
177     Public facing functions
178 ---------------------------------------------------------------------------------------------
179 */
180 
181     /// @dev GoToken Contract constructor function sets GoToken dutch auction
182     /// contract address and assigns the tokens to the auction.
183     /// @param auction_address Address of dutch auction contract.
184     /// @param wallet_address Address of wallet.
185     /// @param initial_supply Number of initially provided token units (indivisible units).
186     function GoToken(address auction_address, address wallet_address, uint256 initial_supply) public
187     {
188         // Auction address should not be null.
189         require(auction_address != 0x0);
190         require(wallet_address != 0x0);
191 
192         // Initial supply is in indivisible units e.g. 50e24
193         require(initial_supply > multiplier);
194 
195         // Total supply of indivisible GOT units at deployment
196         totalSupply = initial_supply;
197 
198         // preallocation
199         balances[auction_address] = initial_supply / 2;
200         balances[wallet_address] = initial_supply / 2;
201 
202         // Record the events
203         emit Transfer(0x0, auction_address, balances[auction_address]);
204         emit Transfer(0x0, wallet_address, balances[wallet_address]);
205 
206         emit Deployed(totalSupply);
207 
208         assert(totalSupply == balances[auction_address] + balances[wallet_address]);
209     }
210 
211 }
212 
213 
214 /// @title GoToken Uniform Price Dutch auction contract - distribution of a fixed
215 /// number of tokens using second price auction, where everybody gets the same final
216 /// price when the auction ends i.e. the ending bid becomes the finalized
217 /// price per token for all participants.
218 contract GoTokenDutchAuction {
219 /*
220 ---------------------------------------------------------------------------------------------
221     GoToken Uniform Price Dutch auction contract - distribution of a fixed
222     number of tokens using seconprice auction, where everybody gets the lowest
223     price when the auction ends i.e. the ending bid becomes the finalized
224     price per token. This is the mechanism for price discovery.
225 
226     The uniform price Dutch auction is set up to discover a fair price for a
227     fixed amount of GOT tokens. It starts with a very high price which
228     continuously declines with every block over time, based on a predefined
229     formula. After the auction is started, participants can send in ETH to bid.
230     The auction ends once the price multiplied with the number of offered tokens
231     equals the total ETH amount sent to the auction. All participants receive
232     their tokens at the same final price.
233 
234     The main goals of the auction are to enable everyone to participate while
235     offering certainty about the maximum total value of all tokens at the time
236     of the bid.
237 
238     All token balances are transferable.
239     Token name, ticker symbol and decimals
240     1 token (GOT) = 1 indivisible unit * multiplier
241     multiplier set from token's number of decimals (i.e. 10 ** decimals)
242 
243 ---------------------------------------------------------------------------------------------
244 */
245 
246 /*
247 ---------------------------------------------------------------------------------------------
248     Data structures for Storage
249 ---------------------------------------------------------------------------------------------
250 */
251 
252     GoToken public token;
253     address public owner_address;
254     address public wallet_address;
255     address public whitelister_address;
256     address public distributor_address;
257 
258     // Minimum bid value during the auction
259     uint256 constant public bid_threshold = 10 finney;
260 
261     // Maximum contribution per ETH address during public sale
262     //uint256 constant public MAX_CONTRIBUTION_PUBLICSALE = 20 ether;
263 
264     // token multiplied derived out of decimals
265     uint256 public token_multiplier;
266 
267     // Total number of indivisible GoTokens (GOT * token_multiplier) that will be auctioned
268     uint256 public num_tokens_auctioned;
269 
270 /*
271 ---------------------------------------------------------------------------------------------
272     Price decay function parameters to be changed depending on the desired outcome
273     This is modeled based on composite exponentially decaying curve auction price model.
274     The price curves are mathematically modeled per the business needs. There are two
275     exponentially decaying curves for teh auction: curve 1 is for teh first eight days
276     and curve 2 is for the remaining days until the auction is finalized.
277 ---------------------------------------------------------------------------------------------
278 */
279 
280     // Starting price in WEI; e.g. 2 * 10 ** 18
281     uint256 public price_start;
282 
283     uint256 constant public CURVE_CUTOFF_DURATION = 8 days;
284 
285     // Price constant for first eight days of the price curve; e.g. 1728
286     uint256 public price_constant1;
287 
288     // Price exponent for first eight days of the price curve; e.g. 2
289     uint256 public price_exponent1;
290 
291     // Price constant for eight plus days of the price curve; e.g. 1257
292     uint256 public price_constant2;
293 
294     // Price exponent for eight plus days of the price curve; e.g. 2
295     uint256 public price_exponent2;
296 
297     // For private sale start time (same as auction deployement time)
298     uint256 public privatesale_start_time;
299 
300     // For calculating elapsed time for price auction
301     uint256 public auction_start_time;
302     uint256 public end_time;
303     uint256 public start_block;
304 
305     // All ETH received from the bids
306     uint256 public received_wei;
307     uint256 public received_wei_with_bonus;
308 
309     // Cumulative ETH funds for which the tokens have been claimed
310     uint256 public funds_claimed;
311 
312     // Wei per token (GOT * token_multiplier)
313     uint256 public final_price;
314 
315     struct Account {
316   		uint256 accounted;	// bid value including bonus
317   		uint256 received;	// the amount received, without bonus
318   	}
319 
320     // Address of the Bidder => bid value
321     mapping (address => Account) public bids;
322 
323     // privatesalewhitelist for private ETH addresses
324     mapping (address => bool) public privatesalewhitelist;
325 
326     // publicsalewhitelist for addresses that want to bid in public sale excluding private sale accounts
327     mapping (address => bool) public publicsalewhitelist;
328 
329 /*
330 ---------------------------------------------------------------------------------------------
331     Bonus tiers
332 ---------------------------------------------------------------------------------------------
333 */
334     // Maximum duration after sale begins that 15% bonus is active.
335   	uint256 constant public BONUS_DAY1_DURATION = 24 hours; ///24 hours;
336 
337   	// Maximum duration after sale begins that 10% bonus is active.
338   	uint256 constant public BONUS_DAY2_DURATION = 48 hours; ///48 hours;
339 
340   	// Maximum duration after sale begins that 5% bonus is active.
341   	uint256 constant public BONUS_DAY3_DURATION = 72 hours; ///72 hours;
342 
343     // The current percentage of bonus that contributors get.
344   	uint256 public currentBonus = 0;
345 
346     // Waiting time in days before a participant can claim tokens after the end of the auction
347     uint256 constant public TOKEN_CLAIM_WAIT_PERIOD = 0 days;
348 
349     // Keep track of stages during the auction and contract deployment process
350     Stages public stage;
351 
352     enum Stages {
353         AuctionDeployed,
354         AuctionSetUp,
355         AuctionStarted,
356         AuctionEnded,
357         TokensDistributed
358     }
359 
360 /*
361 ---------------------------------------------------------------------------------------------
362     Modifiers
363 ---------------------------------------------------------------------------------------------
364 */
365     // State of the auction
366     modifier atStage(Stages _stage) {
367         require(stage == _stage);
368         _;
369     }
370 
371     // Only owner of the contract
372     modifier isOwner() {
373         require(msg.sender == owner_address);
374         _;
375     }
376 
377     // Only who is allowed to whitelist the participant ETH addresses (specified
378     // during the contract deployment)
379     modifier isWhitelister() {
380         require(msg.sender == whitelister_address);
381         _;
382     }
383 
384     // Only who is allowed to distribute the GOT to the participant ETH addresses (specified
385     // during the contract deployment)
386     modifier isDistributor() {
387         require(msg.sender == distributor_address);
388         _;
389     }
390 /*
391 ---------------------------------------------------------------------------------------------
392     Events
393 ---------------------------------------------------------------------------------------------
394 */
395 
396     event Deployed(uint256 indexed _price_start, uint256 _price_constant1, uint256 _price_exponent1, uint256  _price_constant2, uint256 _price_exponent2);
397     event Setup();
398     event AuctionStarted(uint256 indexed _auction_start_time, uint256 indexed _block_number);
399     event BidSubmission(address indexed _sender,uint256 _amount, uint256 _amount_with_bonus, uint256 _remaining_funds_to_end_auction);
400     event ClaimedTokens(address indexed _recipient, uint256 _sent_amount);
401     event AuctionEnded(uint256 _final_price);
402     event TokensDistributed();
403 
404     /// whitelisting events for private sale and public sale ETH addresses
405   	event PrivateSaleWhitelisted(address indexed who);
406     event RemovedFromPrivateSaleWhitelist(address indexed who);
407     event PublicSaleWhitelisted(address indexed who);
408     event RemovedFromPublicSaleWhitelist(address indexed who);
409 
410 /*
411 ---------------------------------------------------------------------------------------------
412     Public facing functions
413 ---------------------------------------------------------------------------------------------
414 */
415 
416     /// @dev GoToken Contract constructor function sets the starting price,
417     /// price constant and price exponent for calculating the Dutch Auction price.
418     /// @param _wallet_address Wallet address to which all contributed ETH will be forwarded.
419     function GoTokenDutchAuction(
420         address _wallet_address,
421         address _whitelister_address,
422         address _distributor_address,
423         uint256 _price_start,
424         uint256 _price_constant1,
425         uint256 _price_exponent1,
426         uint256 _price_constant2,
427         uint256 _price_exponent2)
428         public
429     {
430         // Address shouldn't be null
431         require(_wallet_address != 0x0);
432         require(_whitelister_address != 0x0);
433         require(_distributor_address != 0x0);
434         wallet_address = _wallet_address;
435         whitelister_address = _whitelister_address;
436         distributor_address = _distributor_address;
437 
438         owner_address = msg.sender;
439         stage = Stages.AuctionDeployed;
440         changePriceCurveSettings(_price_start, _price_constant1, _price_exponent1, _price_constant2, _price_exponent2);
441         Deployed(_price_start, _price_constant1, _price_exponent1, _price_constant2, _price_exponent2);
442     }
443 
444     /// @dev Fallback function for the contract, which calls bid()
445     function () public payable {
446         bid();
447     }
448 
449     /// @notice Set "_token_address" as the token address to be used in the auction.
450     /// @dev Setup function sets external contracts addresses.
451     /// @param _token_address Token address.
452     function setup(address _token_address) public isOwner atStage(Stages.AuctionDeployed) {
453         require(_token_address != 0x0);
454         token = GoToken(_token_address);
455 
456         // Get number of GoToken indivisible tokens (GOT * token_multiplier)
457         // to be auctioned from token auction balance
458         num_tokens_auctioned = token.balanceOf(address(this));
459 
460         // Set the number of the token multiplier for its decimals
461         token_multiplier = 10 ** (token.decimals());
462 
463         // State is set to Auction Setup
464         stage = Stages.AuctionSetUp;
465         Setup();
466     }
467 
468     /// @notice Set "_price_start", "_price_constant1" and "_price_exponent1"
469     ///  "_price_constant2" and "_price_exponent2" as
470     /// the new starting price, price constant and price exponent for the auction price.
471     /// @dev Changes auction price function parameters before auction is started.
472     /// @param _price_start Updated start price.
473     /// @param _price_constant1 Updated price divisor constant.
474     /// @param _price_exponent1 Updated price divisor exponent.
475     /// @param _price_constant2 Updated price divisor constant.
476     /// @param _price_exponent2 Updated price divisor exponent.
477     function changePriceCurveSettings(
478         uint256 _price_start,
479         uint256 _price_constant1,
480         uint256 _price_exponent1,
481         uint256 _price_constant2,
482         uint256 _price_exponent2)
483         internal
484     {
485         // You can change the price curve settings only when either the auction is Deployed
486         // or the auction is setup. You can't change during the auction is running or ended.
487         require(stage == Stages.AuctionDeployed || stage == Stages.AuctionSetUp);
488         require(_price_start > 0);
489         require(_price_constant1 > 0);
490         require(_price_constant2 > 0);
491 
492         price_start = _price_start;
493         price_constant1 = _price_constant1;
494         price_exponent1 = _price_exponent1;
495         price_constant2 = _price_constant2;
496         price_exponent2 = _price_exponent2;
497     }
498 
499 /*
500 ---------------------------------------------------------------------------------------------
501     Functions related to whitelisting of presale and public sale ETH addresses.
502     The Whitelister must add the participant's ETH address before they can bid.
503 ---------------------------------------------------------------------------------------------
504 */
505     // @notice Adds account addresses to public sale ETH whitelist.
506     // @dev Adds account addresses to public sale ETH whitelist.
507     // @param _bidder_addresses Array of addresses. Use double quoted array.
508     function addToPublicSaleWhitelist(address[] _bidder_addresses) public isWhitelister {
509         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
510             require(!privatesalewhitelist[_bidder_addresses[i]]); //Can't be in public whitelist
511             publicsalewhitelist[_bidder_addresses[i]] = true;
512             PublicSaleWhitelisted(_bidder_addresses[i]);
513         }
514     }
515 
516     // @notice Removes account addresses from public sale ETH whitelist.
517     // @dev Removes account addresses from public sale ETH whitelist.
518     // @param _bidder_addresses Array of addresses.  Use double quoted array.
519     function removeFromPublicSaleWhitelist(address[] _bidder_addresses) public isWhitelister {
520         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
521             publicsalewhitelist[_bidder_addresses[i]] = false;
522             RemovedFromPublicSaleWhitelist(_bidder_addresses[i]);
523         }
524     }
525 
526     // Private sale contributors whitelist. Only Admin can add or remove
527 
528   	// @notice Adds presale account addresses to privatesalewhitelist.
529     // @ Admin Adds presale account addresses to privatesalewhitelist.
530     // @param _bidder_addresses Array of addresses.
531     function addToPrivateSaleWhitelist(address[] _bidder_addresses) public isOwner {
532         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
533               privatesalewhitelist[_bidder_addresses[i]] = true;
534   						PrivateSaleWhitelisted(_bidder_addresses[i]);
535           }
536       }
537 
538       // @notice Removes presale account addresses from privatesalewhitelist.
539       // @ Admin Removes presale account addresses from privatesalewhitelist.
540       // @param _bidder_addresses Array of addresses.
541       function removeFromPrivateSaleWhitelist(address[] _bidder_addresses) public isOwner {
542           for (uint32 i = 0; i < _bidder_addresses.length; i++) {
543               privatesalewhitelist[_bidder_addresses[i]] = false;
544   						RemovedFromPrivateSaleWhitelist(_bidder_addresses[i]);
545           }
546       }
547 
548     // @notice Start the auction.
549     // @dev Starts auction and sets auction_start_time.
550     function startAuction() public isOwner atStage(Stages.AuctionSetUp) {
551         stage = Stages.AuctionStarted;
552         auction_start_time = now;
553         start_block = block.number;
554         AuctionStarted(auction_start_time, start_block);
555     }
556 
557     /// @notice Send "msg.value" WEI to the auction from the "msg.sender" account.
558     /// @dev Allows to send a bid to the auction.
559     function bid() public payable
560     {
561         // Address shouldn't be null and the minimum bid amount of contribution is met.
562         // Private sale contributor can submit a bid at AuctionSetUp before AuctionStarted
563         // When AuctionStarted only private sale and public sale whitelisted ETH addresses can participate
564         require(stage == Stages.AuctionSetUp || stage == Stages.AuctionStarted);
565         require(privatesalewhitelist[msg.sender] || publicsalewhitelist[msg.sender]);
566         if (stage == Stages.AuctionSetUp){
567           require(privatesalewhitelist[msg.sender]);
568         }
569         require(msg.value > 0);
570         require(bids[msg.sender].received + msg.value >= bid_threshold);
571         assert(bids[msg.sender].received + msg.value >= msg.value);
572 
573         // Maximum public sale contribution per ETH account
574         //if (stage == Stages.AuctionStarted && publicsalewhitelist[msg.sender]) {
575         //  require (bids[msg.sender].received + msg.value <= MAX_CONTRIBUTION_PUBLICSALE);
576         //}
577 
578         // Remaining funds without the current bid value to end the auction
579         uint256 remaining_funds_to_end_auction = remainingFundsToEndAuction();
580 
581         // The bid value must be less than the funds remaining to end the auction
582         // at the current price.
583         require(msg.value <= remaining_funds_to_end_auction);
584 
585 /*
586 ---------------------------------------------------------------------------------------------
587         Bonus period settings
588 ---------------------------------------------------------------------------------------------
589 */
590         //Private sale bids before Auction starts
591         if (stage == Stages.AuctionSetUp){
592           require(privatesalewhitelist[msg.sender]);
593           currentBonus = 25; //private sale bonus before AuctionStarted
594         }
595         else if (stage == Stages.AuctionStarted) {
596           // private sale contributors bonus period settings
597       		if (privatesalewhitelist[msg.sender] && now >= auction_start_time  && now < auction_start_time + BONUS_DAY1_DURATION) {
598       				currentBonus = 25; //private sale contributor Day 1 bonus
599       		}
600           else if (privatesalewhitelist[msg.sender] && now >= auction_start_time + BONUS_DAY1_DURATION && now < auction_start_time + BONUS_DAY2_DURATION ) {
601       				currentBonus = 25; //private sale contributor Day 2 bonus
602       		}
603       		else if (privatesalewhitelist[msg.sender] && now >= auction_start_time + BONUS_DAY2_DURATION && now < auction_start_time + BONUS_DAY3_DURATION) {
604       				currentBonus = 25; //private sale contributor Day 3 bonus
605       		}
606           else if (privatesalewhitelist[msg.sender] && now >= auction_start_time + BONUS_DAY3_DURATION) {
607               currentBonus = 25; //private sale contributor Day 4+ bonus
608           }
609           else if (publicsalewhitelist[msg.sender] && now >= auction_start_time  && now < auction_start_time + BONUS_DAY1_DURATION) {
610       				currentBonus = 15; //private sale contributor Day 1 bonus
611       		}
612           else if (publicsalewhitelist[msg.sender] && now >= auction_start_time + BONUS_DAY1_DURATION && now < auction_start_time + BONUS_DAY2_DURATION ) {
613       				currentBonus = 10; //private sale contributor Day 2 bonus
614       		}
615       		else if (publicsalewhitelist[msg.sender] && now >= auction_start_time + BONUS_DAY2_DURATION && now < auction_start_time + BONUS_DAY3_DURATION) {
616       				currentBonus = 5; //private sale contributor Day 3 bonus
617       		}
618           else if (publicsalewhitelist[msg.sender] && now >= auction_start_time + BONUS_DAY3_DURATION) {
619               currentBonus = 0; //private sale contributor Day 4+ bonus
620           }
621       		else {
622       				currentBonus = 0;
623       		}
624         }
625         else {
626           currentBonus = 0;
627         }
628 
629         // amount raised including bonus
630         uint256 accounted = msg.value + msg.value * (currentBonus) / 100;
631 
632         // Save the bid amount received with and without bonus.
633     		bids[msg.sender].accounted += accounted; //including bonus
634     		bids[msg.sender].received += msg.value;
635 
636         // keep track of total amount raised and with bonus
637         received_wei += msg.value;
638         received_wei_with_bonus += accounted;
639 
640         // Send bid amount to wallet
641         wallet_address.transfer(msg.value);
642 
643         //Log the bid
644         BidSubmission(msg.sender, msg.value, accounted, remaining_funds_to_end_auction);
645 
646         assert(received_wei >= msg.value);
647         assert(received_wei_with_bonus >= accounted);
648     }
649 
650     // @notice Finalize the auction - sets the final GoToken price and
651     // changes the auction stage after no bids are allowed. Only owner can finalize the auction.
652     // The owner can end the auction anytime after either the auction is deployed or started.
653     // @dev Finalize auction and set the final GOT token price.
654     function finalizeAuction() public isOwner
655     {
656         // The owner can end the auction anytime during the stages
657         // AuctionSetUp and AuctionStarted
658         require(stage == Stages.AuctionSetUp || stage == Stages.AuctionStarted);
659 
660         // Calculate the final price = WEI / (GOT / token_multiplier)
661         final_price = token_multiplier * received_wei_with_bonus / num_tokens_auctioned;
662 
663         // End the auction
664         end_time = now;
665         stage = Stages.AuctionEnded;
666         AuctionEnded(final_price);
667 
668         assert(final_price > 0);
669     }
670 
671     // @notice Distribute GoTokens for "receiver_address" after the auction has ended by the owner.
672     // @dev Distribute GoTokens for "receiver_address" after auction has ended by the owner.
673     // @param receiver_address GoTokens will be assigned to this address if eligible.
674     function distributeGoTokens(address receiver_address)
675         public isDistributor atStage(Stages.AuctionEnded) returns (bool)
676     {
677         // Waiting period in days after the end of the auction, before anyone can claim GoTokens.
678         // Ensures enough time to check if auction was finalized correctly
679         // before users start transacting tokens
680         require(now > end_time + TOKEN_CLAIM_WAIT_PERIOD);
681         require(receiver_address != 0x0);
682         require(bids[receiver_address].received > 0);
683 
684         if (bids[receiver_address].received == 0 || bids[receiver_address].accounted == 0) {
685             return false;
686         }
687 
688         // Number of GOT = bid_wei_with_bonus / (wei_per_GOT * token_multiplier)
689         // Includes the bonus
690         uint256 num = (token_multiplier * bids[receiver_address].accounted) / final_price;
691 
692         // Due to final_price rounding, the number of assigned tokens may be higher
693         // than expected. Therefore, the number of remaining unassigned auction tokens
694         // may be smaller than the number of tokens needed for the last claimTokens call
695         uint256 auction_tokens_balance = token.balanceOf(address(this));
696         if (num > auction_tokens_balance) {
697             num = auction_tokens_balance;
698         }
699 
700         // Update the total amount of funds for which tokens have been claimed
701         funds_claimed += bids[receiver_address].received;
702 
703         // Set receiver bid to 0 before assigning tokens
704         bids[receiver_address].accounted = 0;
705         bids[receiver_address].received = 0;
706 
707         // Send the GoTokens to the receiver address including the qualified bonus
708         require(token.transfer(receiver_address, num));
709 
710         // Log the event for claimed GoTokens
711         ClaimedTokens(receiver_address, num);
712 
713         // After the last tokens are claimed, change the auction stage
714         // Due to the above logic described, rounding errors will not be an issue here.
715         if (funds_claimed == received_wei) {
716             stage = Stages.TokensDistributed;
717             TokensDistributed();
718         }
719 
720         assert(token.balanceOf(receiver_address) >= num);
721         assert(bids[receiver_address].accounted == 0);
722         assert(bids[receiver_address].received == 0);
723         return true;
724     }
725 
726     /// @notice Get the GOT price in WEI during the auction, at the time of
727     /// calling this function. Returns 0 if auction has ended.
728     /// Returns "price_start" before auction has started.
729     /// @dev Calculates the current GOT token price in WEI.
730     /// @return Returns WEI per indivisible GOT (token_multiplier * GOT).
731     function price() public constant returns (uint256) {
732         if (stage == Stages.AuctionEnded ||
733             stage == Stages.TokensDistributed) {
734             return 0;
735         }
736         return calcTokenPrice();
737     }
738 
739     /// @notice Get the remaining funds needed to end the auction, calculated at
740     /// the current GOT price in WEI.
741     /// @dev The remaining funds necessary to end the auction at the current GOT price in WEI.
742     /// @return Returns the remaining funds to end the auction in WEI.
743     function remainingFundsToEndAuction() constant public returns (uint256) {
744 
745         // num_tokens_auctioned = total number of indivisible GOT (GOT * token_multiplier) that is auctioned
746         uint256 required_wei_at_price = num_tokens_auctioned * price() / token_multiplier;
747         if (required_wei_at_price <= received_wei) {
748             return 0;
749         }
750 
751         return required_wei_at_price - received_wei;
752     }
753 
754 /*
755 ---------------------------------------------------------------------------------------------
756     Private function for calcuclating current token price
757 ---------------------------------------------------------------------------------------------
758 */
759 
760     // @dev Calculates the token price (WEI / GOT) at the current timestamp
761     // during the auction; elapsed time = 0 before auction starts.
762     // This is a composite exponentially decaying curve (two curves combined).
763     // The curve 1 is for the first 8 days and the curve 2 is for the remaining days.
764     // They are of the form:
765     //         current_price  = price_start * (1 + elapsed) / (1 + elapsed + decay_rate);
766     //          where, decay_rate = elapsed ** price_exponent / price_constant;
767     // Based on the provided parameters, the price does not change in the first
768     // price_constant^(1/price_exponent) seconds due to rounding.
769     // Rounding in `decay_rate` also produces values that increase instead of decrease
770     // in the beginning of the auction; these spikes decrease over time and are noticeable
771     // only in first hours. This should be calculated before usage.
772     // @return Returns the token price - WEI per GOT.
773 
774     function calcTokenPrice() constant private returns (uint256) {
775         uint256 elapsed;
776         uint256 decay_rate1;
777         uint256 decay_rate2;
778         if (stage == Stages.AuctionDeployed || stage == Stages.AuctionSetUp){
779           return price_start;
780         }
781         if (stage == Stages.AuctionStarted) {
782             elapsed = now - auction_start_time;
783             // The first eight days auction price curve
784             if (now >= auction_start_time && now < auction_start_time + CURVE_CUTOFF_DURATION){
785               decay_rate1 = elapsed ** price_exponent1 / price_constant1;
786               return price_start * (1 + elapsed) / (1 + elapsed + decay_rate1);
787             }
788             // The remaining days auction price curve
789             else if (now >= auction_start_time && now >= auction_start_time + CURVE_CUTOFF_DURATION){
790               decay_rate2 = elapsed ** price_exponent2 / price_constant2;
791               return price_start * (1 + elapsed) / (1 + elapsed + decay_rate2);
792             }
793             else {
794               return price_start;
795             }
796 
797         }
798     }
799 
800 }