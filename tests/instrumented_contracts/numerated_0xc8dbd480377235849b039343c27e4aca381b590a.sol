1 pragma solidity ^0.4.17;
2 
3  /*
4  * Contract that is working with ERC223 tokens
5  * https://github.com/ethereum/EIPs/issues/223
6  */
7 
8 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
9 contract ERC223ReceivingContract {
10 
11     /// @dev Function that is called when a user or another contract wants to transfer funds.
12     /// @param _from Transaction initiator, analogue of msg.sender
13     /// @param _value Number of tokens to transfer.
14     /// @param _data Data containig a function signature and/or parameters
15     function tokenFallback(address _from, uint256 _value, bytes _data) public;
16 }
17 
18 /// @title Base Token contract - Functions to be implemented by token contracts.
19 contract Token {
20     /*
21      * Implements ERC 20 standard.
22      * https://github.com/ethereum/EIPs/blob/f90864a3d2b2b45c4decf95efd26b3f0c276051a/EIPS/eip-20-token-standard.md
23      * https://github.com/ethereum/EIPs/issues/20
24      *
25      *  Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
26      *  https://github.com/ethereum/EIPs/issues/223
27      */
28 
29     /*
30      * This is a slight change to the ERC20 base standard.
31      * function totalSupply() constant returns (uint256 supply);
32      * is replaced with:
33      * uint256 public totalSupply;
34      * This automatically creates a getter function for the totalSupply.
35      * This is moved to the base contract since public getter functions are not
36      * currently recognised as an implementation of the matching abstract
37      * function by the compiler.
38      */
39     uint256 public totalSupply;
40 
41     /*
42      * ERC 20
43      */
44     function balanceOf(address _owner) public constant returns (uint256 balance);
45     function transfer(address _to, uint256 _value) public returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47     function approve(address _spender, uint256 _value) public returns (bool success);
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 
50     /*
51      * ERC 223
52      */
53     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
54 
55     /*
56      * Events
57      */
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     // There is no ERC223 compatible Transfer event, with `_data` included.
62 }
63 
64 
65 /// @title Standard token contract - Standard token implementation.
66 contract StandardToken is Token {
67 
68     /*
69      * Data structures
70      */
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowed;
73 
74     /*
75      * Public functions
76      */
77     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
78     /// @dev Transfers sender's tokens to a given address. Returns success.
79     /// @param _to Address of token receiver.
80     /// @param _value Number of tokens to transfer.
81     /// @return Returns success of function call.
82     function transfer(address _to, uint256 _value) public returns (bool) {
83         require(_to != 0x0);
84         require(_to != address(this));
85         require(balances[msg.sender] >= _value);
86         require(balances[_to] + _value >= balances[_to]);
87 
88         balances[msg.sender] -= _value;
89         balances[_to] += _value;
90 
91         Transfer(msg.sender, _to, _value);
92 
93         return true;
94     }
95 
96     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
97     /// tokenFallback if sender is a contract.
98     /// @dev Function that is called when a user or another contract wants to transfer funds.
99     /// @param _to Address of token receiver.
100     /// @param _value Number of tokens to transfer.
101     /// @param _data Data to be sent to tokenFallback
102     /// @return Returns success of function call.
103     function transfer(
104         address _to,
105         uint256 _value,
106         bytes _data)
107         public
108         returns (bool)
109     {
110         require(transfer(_to, _value));
111 
112         uint codeLength;
113 
114         assembly {
115             // Retrieve the size of the code on target address, this needs assembly.
116             codeLength := extcodesize(_to)
117         }
118 
119         if (codeLength > 0) {
120             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
121             receiver.tokenFallback(msg.sender, _value, _data);
122         }
123 
124         return true;
125     }
126 
127     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
128     /// @dev Allows for an approved third party to transfer tokens from one
129     /// address to another. Returns success.
130     /// @param _from Address from where tokens are withdrawn.
131     /// @param _to Address to where tokens are sent.
132     /// @param _value Number of tokens to transfer.
133     /// @return Returns success of function call.
134     function transferFrom(address _from, address _to, uint256 _value)
135         public
136         returns (bool)
137     {
138         require(_from != 0x0);
139         require(_to != 0x0);
140         require(_to != address(this));
141         require(balances[_from] >= _value);
142         require(allowed[_from][msg.sender] >= _value);
143         require(balances[_to] + _value >= balances[_to]);
144 
145         balances[_to] += _value;
146         balances[_from] -= _value;
147         allowed[_from][msg.sender] -= _value;
148 
149         Transfer(_from, _to, _value);
150 
151         return true;
152     }
153 
154     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
155     /// @dev Sets approved amount of tokens for spender. Returns success.
156     /// @param _spender Address of allowed account.
157     /// @param _value Number of approved tokens.
158     /// @return Returns success of function call.
159     function approve(address _spender, uint256 _value) public returns (bool) {
160         require(_spender != 0x0);
161 
162         // To change the approve amount you first have to reduce the addresses`
163         // allowance to zero by calling `approve(_spender, 0)` if it is not
164         // already 0 to mitigate the race condition described here:
165         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166         require(_value == 0 || allowed[msg.sender][_spender] == 0);
167 
168         allowed[msg.sender][_spender] = _value;
169         Approval(msg.sender, _spender, _value);
170         return true;
171     }
172 
173     /*
174      * Read functions
175      */
176     /// @dev Returns number of allowed tokens that a spender can transfer on
177     /// behalf of a token owner.
178     /// @param _owner Address of token owner.
179     /// @param _spender Address of token spender.
180     /// @return Returns remaining allowance for spender.
181     function allowance(address _owner, address _spender)
182         constant
183         public
184         returns (uint256)
185     {
186         return allowed[_owner][_spender];
187     }
188 
189     /// @dev Returns number of tokens owned by the given address.
190     /// @param _owner Address of token owner.
191     /// @return Returns balance of owner.
192     function balanceOf(address _owner) constant public returns (uint256) {
193         return balances[_owner];
194     }
195 }
196 
197 
198 /// @title Raiden Token
199 contract RaidenToken is StandardToken {
200 
201     /*
202      *  Terminology:
203      *  1 token unit = Rei
204      *  1 token = RDN = Rei * multiplier
205      *  multiplier set from token's number of decimals (i.e. 10 ** decimals)
206      */
207 
208     /*
209      *  Token metadata
210      */
211     string constant public name = "Raiden Token";
212     string constant public symbol = "RDN";
213     uint8 constant public decimals = 18;
214     uint constant multiplier = 10 ** uint(decimals);
215 
216     event Deployed(uint indexed _total_supply);
217     event Burnt(
218         address indexed _receiver,
219         uint indexed _num,
220         uint indexed _total_supply
221     );
222 
223     /*
224      *  Public functions
225      */
226     /// @dev Contract constructor function sets dutch auction contract address
227     /// and assigns all tokens to dutch auction.
228     /// @param auction_address Address of dutch auction contract.
229     /// @param wallet_address Address of wallet.
230     /// @param initial_supply Number of initially provided token units (Rei).
231     function RaidenToken(
232         address auction_address,
233         address wallet_address,
234         uint initial_supply)
235         public
236     {
237         // Auction address should not be null.
238         require(auction_address != 0x0);
239         require(wallet_address != 0x0);
240 
241         // Initial supply is in Rei
242         require(initial_supply > multiplier);
243 
244         // Total supply of Rei at deployment
245         totalSupply = initial_supply;
246 
247         balances[auction_address] = initial_supply / 2;
248         balances[wallet_address] = initial_supply / 2;
249 
250         Transfer(0x0, auction_address, balances[auction_address]);
251         Transfer(0x0, wallet_address, balances[wallet_address]);
252 
253         Deployed(totalSupply);
254 
255         assert(totalSupply == balances[auction_address] + balances[wallet_address]);
256     }
257 
258     /// @notice Allows `msg.sender` to simply destroy `num` token units (Rei). This means the total
259     /// token supply will decrease.
260     /// @dev Allows to destroy token units (Rei).
261     /// @param num Number of token units (Rei) to burn.
262     function burn(uint num) public {
263         require(num > 0);
264         require(balances[msg.sender] >= num);
265         require(totalSupply >= num);
266 
267         uint pre_balance = balances[msg.sender];
268 
269         balances[msg.sender] -= num;
270         totalSupply -= num;
271         Burnt(msg.sender, num, totalSupply);
272         Transfer(msg.sender, 0x0, num);
273 
274         assert(balances[msg.sender] == pre_balance - num);
275     }
276 
277 }
278 
279 
280 /// @title Dutch auction contract - distribution of a fixed number of tokens using an auction.
281 /// The contract code is inspired by the Gnosis auction contract. Main difference is that the
282 /// auction ends if a fixed number of tokens was sold.
283 contract DutchAuction {
284     /*
285      * Auction for the RDN Token.
286      *
287      * Terminology:
288      * 1 token unit = Rei
289      * 1 token = RDN = Rei * token_multiplier
290      * token_multiplier set from token's number of decimals (i.e. 10 ** decimals)
291      */
292 
293     // Wait 7 days after the end of the auction, before ayone can claim tokens
294     uint constant public token_claim_waiting_period = 5 minutes;
295 
296     // Bid value over which the address has to be whitelisted
297     // At deployment moment, equivalent with $15,000
298     uint constant public bid_threshold = 9 ether;
299 
300     /*
301      * Storage
302      */
303 
304     RaidenToken public token;
305     address public owner_address;
306     address public wallet_address;
307 
308     // Price decay function parameters to be changed depending on the desired outcome
309 
310     // Starting price in WEI; e.g. 2 * 10 ** 18
311     uint public price_start;
312 
313     // Divisor constant; e.g. 524880000
314     uint public price_constant;
315 
316     // Divisor exponent; e.g. 3
317     uint32 public price_exponent;
318 
319     // For calculating elapsed time for price
320     uint public start_time;
321     uint public end_time;
322     uint public start_block;
323 
324     // Keep track of all ETH received in the bids
325     uint public received_wei;
326 
327     // Keep track of cumulative ETH funds for which the tokens have been claimed
328     uint public funds_claimed;
329 
330     uint public token_multiplier;
331 
332     // Total number of Rei (RDN * token_multiplier) that will be auctioned
333     uint public num_tokens_auctioned;
334 
335     // Wei per RDN (Rei * token_multiplier)
336     uint public final_price;
337 
338     // Bidder address => bid value
339     mapping (address => uint) public bids;
340 
341     // Whitelist for addresses that want to bid more than bid_threshold
342     mapping (address => bool) public whitelist;
343 
344     Stages public stage;
345 
346     /*
347      * Enums
348      */
349     enum Stages {
350         AuctionDeployed,
351         AuctionSetUp,
352         AuctionStarted,
353         AuctionEnded,
354         TokensDistributed
355     }
356 
357     /*
358      * Modifiers
359      */
360     modifier atStage(Stages _stage) {
361         require(stage == _stage);
362         _;
363     }
364 
365     modifier isOwner() {
366         require(msg.sender == owner_address);
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
402         uint _price_start,
403         uint _price_constant,
404         uint32 _price_exponent)
405         public
406     {
407         require(_wallet_address != 0x0);
408         wallet_address = _wallet_address;
409 
410         owner_address = msg.sender;
411         stage = Stages.AuctionDeployed;
412         changeSettings(_price_start, _price_constant, _price_exponent);
413         Deployed(_price_start, _price_constant, _price_exponent);
414     }
415 
416     /// @dev Fallback function for the contract, which calls bid() if the auction has started.
417     function () public payable atStage(Stages.AuctionStarted) {
418         bid();
419     }
420 
421     /// @notice Set `_token_address` as the token address to be used in the auction.
422     /// @dev Setup function sets external contracts addresses.
423     /// @param _token_address Token address.
424     function setup(address _token_address) public isOwner atStage(Stages.AuctionDeployed) {
425         require(_token_address != 0x0);
426         token = RaidenToken(_token_address);
427 
428         // Get number of Rei (RDN * token_multiplier) to be auctioned from token auction balance
429         num_tokens_auctioned = token.balanceOf(address(this));
430 
431         // Set the number of the token multiplier for its decimals
432         token_multiplier = 10 ** uint(token.decimals());
433 
434         stage = Stages.AuctionSetUp;
435         Setup();
436     }
437 
438     /// @notice Set `_price_start`, `_price_constant` and `_price_exponent` as
439     /// the new starting price, price divisor constant and price divisor exponent.
440     /// @dev Changes auction price function parameters before auction is started.
441     /// @param _price_start Updated start price.
442     /// @param _price_constant Updated price divisor constant.
443     /// @param _price_exponent Updated price divisor exponent.
444     function changeSettings(
445         uint _price_start,
446         uint _price_constant,
447         uint32 _price_exponent)
448         internal
449     {
450         require(stage == Stages.AuctionDeployed || stage == Stages.AuctionSetUp);
451         require(_price_start > 0);
452         require(_price_constant > 0);
453 
454         price_start = _price_start;
455         price_constant = _price_constant;
456         price_exponent = _price_exponent;
457     }
458 
459     /// @notice Adds account addresses to whitelist.
460     /// @dev Adds account addresses to whitelist.
461     /// @param _bidder_addresses Array of addresses.
462     function addToWhitelist(address[] _bidder_addresses) public isOwner {
463         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
464             whitelist[_bidder_addresses[i]] = true;
465         }
466     }
467 
468     /// @notice Removes account addresses from whitelist.
469     /// @dev Removes account addresses from whitelist.
470     /// @param _bidder_addresses Array of addresses.
471     function removeFromWhitelist(address[] _bidder_addresses) public isOwner {
472         for (uint32 i = 0; i < _bidder_addresses.length; i++) {
473             whitelist[_bidder_addresses[i]] = false;
474         }
475     }
476 
477     /// @notice Start the auction.
478     /// @dev Starts auction and sets start_time.
479     function startAuction() public isOwner atStage(Stages.AuctionSetUp) {
480         stage = Stages.AuctionStarted;
481         start_time = now;
482         start_block = block.number;
483         AuctionStarted(start_time, start_block);
484     }
485 
486     /// @notice Finalize the auction - sets the final RDN token price and changes the auction
487     /// stage after no bids are allowed anymore.
488     /// @dev Finalize auction and set the final RDN token price.
489     function finalizeAuction() public atStage(Stages.AuctionStarted)
490     {
491         // Missing funds should be 0 at this point
492         uint missing_funds = missingFundsToEndAuction();
493         require(missing_funds == 0);
494 
495         // Calculate the final price = WEI / RDN = WEI / (Rei / token_multiplier)
496         // Reminder: num_tokens_auctioned is the number of Rei (RDN * token_multiplier) that are auctioned
497         final_price = token_multiplier * received_wei / num_tokens_auctioned;
498 
499         end_time = now;
500         stage = Stages.AuctionEnded;
501         AuctionEnded(final_price);
502 
503         assert(final_price > 0);
504     }
505 
506     /// --------------------------------- Auction Functions ------------------
507 
508 
509     /// @notice Send `msg.value` WEI to the auction from the `msg.sender` account.
510     /// @dev Allows to send a bid to the auction.
511     function bid()
512         public
513         payable
514         atStage(Stages.AuctionStarted)
515     {
516         require(msg.value > 0);
517         require(bids[msg.sender] + msg.value <= bid_threshold || whitelist[msg.sender]);
518         assert(bids[msg.sender] + msg.value >= msg.value);
519 
520         // Missing funds without the current bid value
521         uint missing_funds = missingFundsToEndAuction();
522 
523         // We require bid values to be less than the funds missing to end the auction
524         // at the current price.
525         require(msg.value <= missing_funds);
526 
527         bids[msg.sender] += msg.value;
528         received_wei += msg.value;
529 
530         // Send bid amount to wallet
531         wallet_address.transfer(msg.value);
532 
533         BidSubmission(msg.sender, msg.value, missing_funds);
534 
535         assert(received_wei >= msg.value);
536     }
537 
538     /// @notice Claim auction tokens for `msg.sender` after the auction has ended.
539     /// @dev Claims tokens for `msg.sender` after auction. To be used if tokens can
540     /// be claimed by beneficiaries, individually.
541     function claimTokens() public atStage(Stages.AuctionEnded) returns (bool) {
542         return proxyClaimTokens(msg.sender);
543     }
544 
545     /// @notice Claim auction tokens for `receiver_address` after the auction has ended.
546     /// @dev Claims tokens for `receiver_address` after auction has ended.
547     /// @param receiver_address Tokens will be assigned to this address if eligible.
548     function proxyClaimTokens(address receiver_address)
549         public
550         atStage(Stages.AuctionEnded)
551         returns (bool)
552     {
553         // Waiting period after the end of the auction, before anyone can claim tokens
554         // Ensures enough time to check if auction was finalized correctly
555         // before users start transacting tokens
556         require(now > end_time + token_claim_waiting_period);
557         require(receiver_address != 0x0);
558 
559         if (bids[receiver_address] == 0) {
560             return false;
561         }
562 
563         // Number of Rei = bid_wei / Rei = bid_wei / (wei_per_RDN * token_multiplier)
564         uint num = (token_multiplier * bids[receiver_address]) / final_price;
565 
566         // Due to final_price floor rounding, the number of assigned tokens may be higher
567         // than expected. Therefore, the number of remaining unassigned auction tokens
568         // may be smaller than the number of tokens needed for the last claimTokens call
569         uint auction_tokens_balance = token.balanceOf(address(this));
570         if (num > auction_tokens_balance) {
571             num = auction_tokens_balance;
572         }
573 
574         // Update the total amount of funds for which tokens have been claimed
575         funds_claimed += bids[receiver_address];
576 
577         // Set receiver bid to 0 before assigning tokens
578         bids[receiver_address] = 0;
579 
580         require(token.transfer(receiver_address, num));
581 
582         ClaimedTokens(receiver_address, num);
583 
584         // After the last tokens are claimed, we change the auction stage
585         // Due to the above logic, rounding errors will not be an issue
586         if (funds_claimed == received_wei) {
587             stage = Stages.TokensDistributed;
588             TokensDistributed();
589         }
590 
591         assert(token.balanceOf(receiver_address) >= num);
592         assert(bids[receiver_address] == 0);
593         return true;
594     }
595 
596     /// @notice Get the RDN price in WEI during the auction, at the time of
597     /// calling this function. Returns `0` if auction has ended.
598     /// Returns `price_start` before auction has started.
599     /// @dev Calculates the current RDN token price in WEI.
600     /// @return Returns WEI per RDN (token_multiplier * Rei).
601     function price() public constant returns (uint) {
602         if (stage == Stages.AuctionEnded ||
603             stage == Stages.TokensDistributed) {
604             return 0;
605         }
606         return calcTokenPrice();
607     }
608 
609     /// @notice Get the missing funds needed to end the auction,
610     /// calculated at the current RDN price in WEI.
611     /// @dev The missing funds amount necessary to end the auction at the current RDN price in WEI.
612     /// @return Returns the missing funds amount in WEI.
613     function missingFundsToEndAuction() constant public returns (uint) {
614 
615         // num_tokens_auctioned = total number of Rei (RDN * token_multiplier) that is auctioned
616         uint required_wei_at_price = num_tokens_auctioned * price() / token_multiplier;
617         if (required_wei_at_price <= received_wei) {
618             return 0;
619         }
620 
621         // assert(required_wei_at_price - received_wei > 0);
622         return required_wei_at_price - received_wei;
623     }
624 
625     /*
626      *  Private functions
627      */
628 
629     /// @dev Calculates the token price (WEI / RDN) at the current timestamp
630     /// during the auction; elapsed time = 0 before auction starts.
631     /// Based on the provided parameters, the price does not change in the first
632     /// `price_constant^(1/price_exponent)` seconds due to rounding.
633     /// Rounding in `decay_rate` also produces values that increase instead of decrease
634     /// in the beginning; these spikes decrease over time and are noticeable
635     /// only in first hours. This should be calculated before usage.
636     /// @return Returns the token price - Wei per RDN.
637     function calcTokenPrice() constant private returns (uint) {
638         uint elapsed;
639         if (stage == Stages.AuctionStarted) {
640             elapsed = now - start_time;
641         }
642 
643         uint decay_rate = elapsed ** price_exponent / price_constant;
644         return price_start * (1 + elapsed) / (1 + elapsed + decay_rate);
645     }
646 }