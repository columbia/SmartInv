1 pragma solidity ^0.4.17;
2 
3 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
4 contract ERC223ReceivingContract {
5 
6     /// @dev Function that is called when a user or another contract wants to transfer funds.
7     /// @param _from Transaction initiator, analogue of msg.sender
8     /// @param _value Number of tokens to transfer.
9     /// @param _data Data containig a function signature and/or parameters
10     function tokenFallback(address _from, uint256 _value, bytes _data) public;
11 }
12 
13 contract Token {
14     /*
15      * Implements ERC 20 standard.
16      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
17      * https://github.com/ethereum/EIPs/issues/20
18      *
19      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
20      *  https://github.com/ethereum/EIPs/issues/223
21      */
22 
23     /*
24      * This is a slight change to the ERC20 base standard.
25      * function totalSupply() constant returns (uint256 supply);
26      * is replaced with:
27      * uint256 public totalSupply;
28      * This automatically creates a getter function for the totalSupply.
29      * This is moved to the base contract since public getter functions are not
30      * currently recognised as an implementation of the matching abstract
31      * function by the compiler.
32      */
33     uint256 public totalSupply;
34 
35     /*
36      * ERC 20
37      */
38     function balanceOf(address _owner) public constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) public returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41     function approve(address _spender, uint256 _value) public returns (bool success);
42     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
43 
44     /*
45      * ERC 223
46      */
47     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
48 
49     /*
50      * Events
51      */
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 
55     // There is no ERC223 compatible Transfer event, with `_data` included.
56 }
57 
58 
59 /// @title Standard token contract - Standard token implementation.
60 contract StandardToken is Token {
61 
62     /*
63      * Data structures
64      */
65     mapping (address => uint256) balances;
66     mapping (address => mapping (address => uint256)) allowed;
67 
68     /*
69      * Public functions
70      */
71     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
72     /// @dev Transfers sender's tokens to a given address. Returns success.
73     /// @param _to Address of token receiver.
74     /// @param _value Number of tokens to transfer.
75     /// @return Returns success of function call.
76     function transfer(address _to, uint256 _value) public returns (bool) {
77         require(_to != 0x0);
78         require(_to != address(this));
79         require(balances[msg.sender] >= _value);
80         require(balances[_to] + _value >= balances[_to]);
81 
82         balances[msg.sender] -= _value;
83         balances[_to] += _value;
84 
85         Transfer(msg.sender, _to, _value);
86 
87         return true;
88     }
89 
90     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
91     /// tokenFallback if sender is a contract.
92     /// @dev Function that is called when a user or another contract wants to transfer funds.
93     /// @param _to Address of token receiver.
94     /// @param _value Number of tokens to transfer.
95     /// @param _data Data to be sent to tokenFallback
96     /// @return Returns success of function call.
97     function transfer(
98         address _to,
99         uint256 _value,
100         bytes _data)
101         public
102         returns (bool)
103     {
104         require(transfer(_to, _value));
105 
106         uint codeLength;
107 
108         assembly {
109             // Retrieve the size of the code on target address, this needs assembly.
110             codeLength := extcodesize(_to)
111         }
112 
113         if (codeLength > 0) {
114             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
115             receiver.tokenFallback(msg.sender, _value, _data);
116         }
117 
118         return true;
119     }
120 
121     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
122     /// @dev Allows for an approved third party to transfer tokens from one
123     /// address to another. Returns success.
124     /// @param _from Address from where tokens are withdrawn.
125     /// @param _to Address to where tokens are sent.
126     /// @param _value Number of tokens to transfer.
127     /// @return Returns success of function call.
128     function transferFrom(address _from, address _to, uint256 _value)
129         public
130         returns (bool)
131     {
132         require(_from != 0x0);
133         require(_to != 0x0);
134         require(_to != address(this));
135         require(balances[_from] >= _value);
136         require(allowed[_from][msg.sender] >= _value);
137         require(balances[_to] + _value >= balances[_to]);
138 
139         balances[_to] += _value;
140         balances[_from] -= _value;
141         allowed[_from][msg.sender] -= _value;
142 
143         Transfer(_from, _to, _value);
144 
145         return true;
146     }
147 
148     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
149     /// @dev Sets approved amount of tokens for spender. Returns success.
150     /// @param _spender Address of allowed account.
151     /// @param _value Number of approved tokens.
152     /// @return Returns success of function call.
153     function approve(address _spender, uint256 _value) public returns (bool) {
154         require(_spender != 0x0);
155 
156         // To change the approve amount you first have to reduce the addresses`
157         // allowance to zero by calling `approve(_spender, 0)` if it is not
158         // already 0 to mitigate the race condition described here:
159         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160         require(_value == 0 || allowed[msg.sender][_spender] == 0);
161 
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164         return true;
165     }
166 
167     /*
168      * Read functions
169      */
170     /// @dev Returns number of allowed tokens that a spender can transfer on
171     /// behalf of a token owner.
172     /// @param _owner Address of token owner.
173     /// @param _spender Address of token spender.
174     /// @return Returns remaining allowance for spender.
175     function allowance(address _owner, address _spender)
176         constant
177         public
178         returns (uint256)
179     {
180         return allowed[_owner][_spender];
181     }
182 
183     /// @dev Returns number of tokens owned by the given address.
184     /// @param _owner Address of token owner.
185     /// @return Returns balance of owner.
186     function balanceOf(address _owner) constant public returns (uint256) {
187         return balances[_owner];
188     }
189 }
190 
191 
192 /// @title Raiden Token
193 contract RaidenToken is StandardToken {
194 
195     /*
196      *  Terminology:
197      *  1 token unit = Rei
198      *  1 token = RDN = Rei * multiplier
199      *  multiplier set from token's number of decimals (i.e. 10 ** decimals)
200      */
201 
202     /*
203      *  Token metadata
204      */
205     string constant public name = "Raiden Token";
206     string constant public symbol = "RDN";
207     uint8 constant public decimals = 18;
208     uint constant multiplier = 10 ** uint(decimals);
209 
210     event Deployed(uint indexed _total_supply);
211     event Burnt(
212         address indexed _receiver,
213         uint indexed _num,
214         uint indexed _total_supply
215     );
216 
217     /*
218      *  Public functions
219      */
220     /// @dev Contract constructor function sets dutch auction contract address
221     /// and assigns all tokens to dutch auction.
222     /// @param auction_address Address of dutch auction contract.
223     /// @param wallet_address Address of wallet.
224     /// @param initial_supply Number of initially provided token units (Rei).
225     function RaidenToken(
226         address auction_address,
227         address wallet_address,
228         uint initial_supply)
229         public
230     {
231         // Auction address should not be null.
232         require(auction_address != 0x0);
233         require(wallet_address != 0x0);
234 
235         // Initial supply is in Rei
236         require(initial_supply > multiplier);
237 
238         // Total supply of Rei at deployment
239         totalSupply = initial_supply;
240 
241         balances[auction_address] = initial_supply / 2;
242         balances[wallet_address] = initial_supply / 2;
243 
244         Transfer(0x0, auction_address, balances[auction_address]);
245         Transfer(0x0, wallet_address, balances[wallet_address]);
246 
247         Deployed(totalSupply);
248 
249         assert(totalSupply == balances[auction_address] + balances[wallet_address]);
250     }
251 
252     /// @notice Allows `msg.sender` to simply destroy `num` token units (Rei). This means the total
253     /// token supply will decrease.
254     /// @dev Allows to destroy token units (Rei).
255     /// @param num Number of token units (Rei) to burn.
256     function burn(uint num) public {
257         require(num > 0);
258         require(balances[msg.sender] >= num);
259         require(totalSupply >= num);
260 
261         uint pre_balance = balances[msg.sender];
262 
263         balances[msg.sender] -= num;
264         totalSupply -= num;
265         Burnt(msg.sender, num, totalSupply);
266         Transfer(msg.sender, 0x0, num);
267 
268         assert(balances[msg.sender] == pre_balance - num);
269     }
270 
271 }
272 
273 
274 /// @title Dutch auction contract - distribution of a fixed number of tokens using an auction.
275 /// The contract code is inspired by the Gnosis auction contract. Main difference is that the
276 /// auction ends if a fixed number of tokens was sold.
277 contract DutchAuction {
278     /*
279      * Auction for the RDN Token.
280      *
281      * Terminology:
282      * 1 token unit = Rei
283      * 1 token = RDN = Rei * token_multiplier
284      * token_multiplier set from token's number of decimals (i.e. 10 ** decimals)
285      */
286 
287     // Wait 7 days after the end of the auction, before anyone can claim tokens
288     uint constant public token_claim_waiting_period = 7 days;
289 
290     // Bid value over which the address has to be whitelisted
291     // At deployment moment, less than 1k$
292     uint constant public bid_threshold = 2.5 ether;
293 
294     /*
295      * Storage
296      */
297 
298     RaidenToken public token;
299     address public owner_address;
300     address public wallet_address;
301     address public whitelister_address;
302 
303     // Price decay function parameters to be changed depending on the desired outcome
304 
305     // Starting price in WEI; e.g. 2 * 10 ** 18
306     uint public price_start;
307 
308     // Divisor constant; e.g. 524880000
309     uint public price_constant;
310 
311     // Divisor exponent; e.g. 3
312     uint32 public price_exponent;
313 
314     // For calculating elapsed time for price
315     uint public start_time;
316     uint public end_time;
317     uint public start_block;
318 
319     // Keep track of all ETH received in the bids
320     uint public received_wei;
321 
322     // Keep track of cumulative ETH funds for which the tokens have been claimed
323     uint public funds_claimed;
324 
325     uint public token_multiplier;
326 
327     // Total number of Rei (RDN * token_multiplier) that will be auctioned
328     uint public num_tokens_auctioned;
329 
330     // Wei per RDN (Rei * token_multiplier)
331     uint public final_price;
332 
333     // Bidder address => bid value
334     mapping (address => uint) public bids;
335 
336     // Whitelist for addresses that want to bid more than bid_threshold
337     mapping (address => bool) public whitelist;
338 
339     Stages public stage;
340 
341     /*
342      * Enums
343      */
344     enum Stages {
345         AuctionDeployed,
346         AuctionSetUp,
347         AuctionStarted,
348         AuctionEnded,
349         TokensDistributed
350     }
351 
352     /*
353      * Modifiers
354      */
355     modifier atStage(Stages _stage) {
356         require(stage == _stage);
357         _;
358     }
359 
360     modifier isOwner() {
361         require(msg.sender == owner_address);
362         _;
363     }
364 
365     modifier isWhitelister() {
366         require(msg.sender == whitelister_address);
367         _;
368     }
369 
370     /*
371      * Events
372      */
373 
374     event Deployed(
375         uint indexed _price_start,
376         uint indexed _price_constant,
377         uint32 indexed _price_exponent
378     );
379     event Setup();
380     event AuctionStarted(uint indexed _start_time, uint indexed _block_number);
381     event BidSubmission(
382         address indexed _sender,
383         uint _amount,
384         uint _missing_funds
385     );
386     event ClaimedTokens(address indexed _recipient, uint _sent_amount);
387     event AuctionEnded(uint _final_price);
388     event TokensDistributed();
389 
390     /*
391      * Public functions
392      */
393 
394     /// @dev Contract constructor function sets the starting price, divisor constant and
395     /// divisor exponent for calculating the Dutch Auction price.
396     /// @param _wallet_address Wallet address to which all contributed ETH will be forwarded.
397     /// @param _price_start High price in WEI at which the auction starts.
398     /// @param _price_constant Auction price divisor constant.
399     /// @param _price_exponent Auction price divisor exponent.
400     function DutchAuction(
401         address _wallet_address,
402         address _whitelister_address,
403         uint _price_start,
404         uint _price_constant,
405         uint32 _price_exponent)
406         public
407     {
408         require(_wallet_address != 0x0);
409         require(_whitelister_address != 0x0);
410         wallet_address = _wallet_address;
411         whitelister_address = _whitelister_address;
412 
413         owner_address = msg.sender;
414         stage = Stages.AuctionDeployed;
415         changeSettings(_price_start, _price_constant, _price_exponent);
416         Deployed(_price_start, _price_constant, _price_exponent);
417     }
418 
419     /// @dev Fallback function for the contract, which calls bid() if the auction has started.
420     function () public payable atStage(Stages.AuctionStarted) {
421         bid();
422     }
423 
424     /// @notice Set `_token_address` as the token address to be used in the auction.
425     /// @dev Setup function sets external contracts addresses.
426     /// @param _token_address Token address.
427     function setup(address _token_address) public isOwner atStage(Stages.AuctionDeployed) {
428         require(_token_address != 0x0);
429         token = RaidenToken(_token_address);
430 
431         // Get number of Rei (RDN * token_multiplier) to be auctioned from token auction balance
432         num_tokens_auctioned = token.balanceOf(address(this));
433 
434         // Set the number of the token multiplier for its decimals
435         token_multiplier = 10 ** uint(token.decimals());
436 
437         stage = Stages.AuctionSetUp;
438         Setup();
439     }
440 
441     /// @notice Set `_price_start`, `_price_constant` and `_price_exponent` as
442     /// the new starting price, price divisor constant and price divisor exponent.
443     /// @dev Changes auction price function parameters before auction is started.
444     /// @param _price_start Updated start price.
445     /// @param _price_constant Updated price divisor constant.
446     /// @param _price_exponent Updated price divisor exponent.
447     function changeSettings(
448         uint _price_start,
449         uint _price_constant,
450         uint32 _price_exponent)
451         internal
452     {
453         require(stage == Stages.AuctionDeployed || stage == Stages.AuctionSetUp);
454         require(_price_start > 0);
455         require(_price_constant > 0);
456 
457         price_start = _price_start;
458         price_constant = _price_constant;
459         price_exponent = _price_exponent;
460     }
461 
462     /// @notice Adds account addresses to whitelist.
463     /// @dev Adds account addresses to whitelist.
464     /// @param _bidder_addresses Array of addresses.
465     function addToWhitelist(address[] _bidder_addresses) public isWhitelister {
466         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
467             whitelist[_bidder_addresses[i]] = true;
468         }
469     }
470 
471     /// @notice Removes account addresses from whitelist.
472     /// @dev Removes account addresses from whitelist.
473     /// @param _bidder_addresses Array of addresses.
474     function removeFromWhitelist(address[] _bidder_addresses) public isWhitelister {
475         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
476             whitelist[_bidder_addresses[i]] = false;
477         }
478     }
479 
480     /// @notice Start the auction.
481     /// @dev Starts auction and sets start_time.
482     function startAuction() public isOwner atStage(Stages.AuctionSetUp) {
483         stage = Stages.AuctionStarted;
484         start_time = now;
485         start_block = block.number;
486         AuctionStarted(start_time, start_block);
487     }
488 
489     /// @notice Finalize the auction - sets the final RDN token price and changes the auction
490     /// stage after no bids are allowed anymore.
491     /// @dev Finalize auction and set the final RDN token price.
492     function finalizeAuction() public atStage(Stages.AuctionStarted)
493     {
494         // Missing funds should be 0 at this point
495         uint missing_funds = missingFundsToEndAuction();
496         require(missing_funds == 0);
497 
498         // Calculate the final price = WEI / RDN = WEI / (Rei / token_multiplier)
499         // Reminder: num_tokens_auctioned is the number of Rei (RDN * token_multiplier) that are auctioned
500         final_price = token_multiplier * received_wei / num_tokens_auctioned;
501 
502         end_time = now;
503         stage = Stages.AuctionEnded;
504         AuctionEnded(final_price);
505 
506         assert(final_price > 0);
507     }
508 
509     /// --------------------------------- Auction Functions ------------------
510 
511 
512     /// @notice Send `msg.value` WEI to the auction from the `msg.sender` account.
513     /// @dev Allows to send a bid to the auction.
514     function bid()
515         public
516         payable
517         atStage(Stages.AuctionStarted)
518     {
519         require(msg.value > 0);
520         require(bids[msg.sender] + msg.value <= bid_threshold || whitelist[msg.sender]);
521         assert(bids[msg.sender] + msg.value >= msg.value);
522 
523         // Missing funds without the current bid value
524         uint missing_funds = missingFundsToEndAuction();
525 
526         // We require bid values to be less than the funds missing to end the auction
527         // at the current price.
528         require(msg.value <= missing_funds);
529 
530         bids[msg.sender] += msg.value;
531         received_wei += msg.value;
532 
533         // Send bid amount to wallet
534         wallet_address.transfer(msg.value);
535 
536         BidSubmission(msg.sender, msg.value, missing_funds);
537 
538         assert(received_wei >= msg.value);
539     }
540 
541     /// @notice Claim auction tokens for `msg.sender` after the auction has ended.
542     /// @dev Claims tokens for `msg.sender` after auction. To be used if tokens can
543     /// be claimed by beneficiaries, individually.
544     function claimTokens() public atStage(Stages.AuctionEnded) returns (bool) {
545         return proxyClaimTokens(msg.sender);
546     }
547 
548     /// @notice Claim auction tokens for `receiver_address` after the auction has ended.
549     /// @dev Claims tokens for `receiver_address` after auction has ended.
550     /// @param receiver_address Tokens will be assigned to this address if eligible.
551     function proxyClaimTokens(address receiver_address)
552         public
553         atStage(Stages.AuctionEnded)
554         returns (bool)
555     {
556         // Waiting period after the end of the auction, before anyone can claim tokens
557         // Ensures enough time to check if auction was finalized correctly
558         // before users start transacting tokens
559         require(now > end_time + token_claim_waiting_period);
560         require(receiver_address != 0x0);
561 
562         if (bids[receiver_address] == 0) {
563             return false;
564         }
565 
566         // Number of Rei = bid_wei / Rei = bid_wei / (wei_per_RDN * token_multiplier)
567         uint num = (token_multiplier * bids[receiver_address]) / final_price;
568 
569         // Due to final_price floor rounding, the number of assigned tokens may be higher
570         // than expected. Therefore, the number of remaining unassigned auction tokens
571         // may be smaller than the number of tokens needed for the last claimTokens call
572         uint auction_tokens_balance = token.balanceOf(address(this));
573         if (num > auction_tokens_balance) {
574             num = auction_tokens_balance;
575         }
576 
577         // Update the total amount of funds for which tokens have been claimed
578         funds_claimed += bids[receiver_address];
579 
580         // Set receiver bid to 0 before assigning tokens
581         bids[receiver_address] = 0;
582 
583         require(token.transfer(receiver_address, num));
584 
585         ClaimedTokens(receiver_address, num);
586 
587         // After the last tokens are claimed, we change the auction stage
588         // Due to the above logic, rounding errors will not be an issue
589         if (funds_claimed == received_wei) {
590             stage = Stages.TokensDistributed;
591             TokensDistributed();
592         }
593 
594         assert(token.balanceOf(receiver_address) >= num);
595         assert(bids[receiver_address] == 0);
596         return true;
597     }
598 
599     /// @notice Get the RDN price in WEI during the auction, at the time of
600     /// calling this function. Returns `0` if auction has ended.
601     /// Returns `price_start` before auction has started.
602     /// @dev Calculates the current RDN token price in WEI.
603     /// @return Returns WEI per RDN (token_multiplier * Rei).
604     function price() public constant returns (uint) {
605         if (stage == Stages.AuctionEnded ||
606             stage == Stages.TokensDistributed) {
607             return 0;
608         }
609         return calcTokenPrice();
610     }
611 
612     /// @notice Get the missing funds needed to end the auction,
613     /// calculated at the current RDN price in WEI.
614     /// @dev The missing funds amount necessary to end the auction at the current RDN price in WEI.
615     /// @return Returns the missing funds amount in WEI.
616     function missingFundsToEndAuction() constant public returns (uint) {
617 
618         // num_tokens_auctioned = total number of Rei (RDN * token_multiplier) that is auctioned
619         uint required_wei_at_price = num_tokens_auctioned * price() / token_multiplier;
620         if (required_wei_at_price <= received_wei) {
621             return 0;
622         }
623 
624         // assert(required_wei_at_price - received_wei > 0);
625         return required_wei_at_price - received_wei;
626     }
627 
628     /*
629      *  Private functions
630      */
631 
632     /// @dev Calculates the token price (WEI / RDN) at the current timestamp
633     /// during the auction; elapsed time = 0 before auction starts.
634     /// Based on the provided parameters, the price does not change in the first
635     /// `price_constant^(1/price_exponent)` seconds due to rounding.
636     /// Rounding in `decay_rate` also produces values that increase instead of decrease
637     /// in the beginning; these spikes decrease over time and are noticeable
638     /// only in first hours. This should be calculated before usage.
639     /// @return Returns the token price - Wei per RDN.
640     function calcTokenPrice() constant private returns (uint) {
641         uint elapsed;
642         if (stage == Stages.AuctionStarted) {
643             elapsed = now - start_time;
644         }
645 
646         uint decay_rate = elapsed ** price_exponent / price_constant;
647         return price_start * (1 + elapsed) / (1 + elapsed + decay_rate);
648     }
649 }