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
64 /// @title Standard token contract - Standard token implementation.
65 contract StandardToken is Token {
66 
67     /*
68      * Data structures
69      */
70     mapping (address => uint256) balances;
71     mapping (address => mapping (address => uint256)) allowed;
72 
73     /*
74      * Public functions
75      */
76     /// @notice Send `_value` tokens to `_to` from `msg.sender`.
77     /// @dev Transfers sender's tokens to a given address. Returns success.
78     /// @param _to Address of token receiver.
79     /// @param _value Number of tokens to transfer.
80     /// @return Returns success of function call.
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         require(_to != 0x0);
83         require(_to != address(this));
84         require(balances[msg.sender] >= _value);
85         require(balances[_to] + _value >= balances[_to]);
86 
87         balances[msg.sender] -= _value;
88         balances[_to] += _value;
89 
90         Transfer(msg.sender, _to, _value);
91 
92         return true;
93     }
94 
95     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
96     /// tokenFallback if sender is a contract.
97     /// @dev Function that is called when a user or another contract wants to transfer funds.
98     /// @param _to Address of token receiver.
99     /// @param _value Number of tokens to transfer.
100     /// @param _data Data to be sent to tokenFallback
101     /// @return Returns success of function call.
102     function transfer(
103         address _to,
104         uint256 _value,
105         bytes _data)
106         public
107         returns (bool)
108     {
109         require(transfer(_to, _value));
110 
111         uint codeLength;
112 
113         assembly {
114             // Retrieve the size of the code on target address, this needs assembly.
115             codeLength := extcodesize(_to)
116         }
117 
118         if (codeLength > 0) {
119             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
120             receiver.tokenFallback(msg.sender, _value, _data);
121         }
122 
123         return true;
124     }
125 
126     /// @notice Transfer `_value` tokens from `_from` to `_to` if `msg.sender` is allowed.
127     /// @dev Allows for an approved third party to transfer tokens from one
128     /// address to another. Returns success.
129     /// @param _from Address from where tokens are withdrawn.
130     /// @param _to Address to where tokens are sent.
131     /// @param _value Number of tokens to transfer.
132     /// @return Returns success of function call.
133     function transferFrom(address _from, address _to, uint256 _value)
134         public
135         returns (bool)
136     {
137         require(_from != 0x0);
138         require(_to != 0x0);
139         require(_to != address(this));
140         require(balances[_from] >= _value);
141         require(allowed[_from][msg.sender] >= _value);
142         require(balances[_to] + _value >= balances[_to]);
143 
144         balances[_to] += _value;
145         balances[_from] -= _value;
146         allowed[_from][msg.sender] -= _value;
147 
148         Transfer(_from, _to, _value);
149 
150         return true;
151     }
152 
153     /// @notice Allows `_spender` to transfer `_value` tokens from `msg.sender` to any address.
154     /// @dev Sets approved amount of tokens for spender. Returns success.
155     /// @param _spender Address of allowed account.
156     /// @param _value Number of approved tokens.
157     /// @return Returns success of function call.
158     function approve(address _spender, uint256 _value) public returns (bool) {
159         require(_spender != 0x0);
160 
161         // To change the approve amount you first have to reduce the addresses`
162         // allowance to zero by calling `approve(_spender, 0)` if it is not
163         // already 0 to mitigate the race condition described here:
164         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165         require(_value == 0 || allowed[msg.sender][_spender] == 0);
166 
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /*
173      * Read functions
174      */
175     /// @dev Returns number of allowed tokens that a spender can transfer on
176     /// behalf of a token owner.
177     /// @param _owner Address of token owner.
178     /// @param _spender Address of token spender.
179     /// @return Returns remaining allowance for spender.
180     function allowance(address _owner, address _spender)
181         constant
182         public
183         returns (uint256)
184     {
185         return allowed[_owner][_spender];
186     }
187 
188     /// @dev Returns number of tokens owned by the given address.
189     /// @param _owner Address of token owner.
190     /// @return Returns balance of owner.
191     function balanceOf(address _owner) constant public returns (uint256) {
192         return balances[_owner];
193     }
194 }
195 
196 /// @title xChainge Token
197 contract xChaingeToken is StandardToken {
198 
199     /*
200      *  Terminology:
201      *  1 token unit = Xei
202      *  1 token = XCH = Xei * multiplier
203      *  multiplier set from token's number of decimals (i.e. 10 ** decimals)
204      */
205 
206     /*
207      *  Token metadata
208      */
209     string constant public name = "xChainge Token";
210     string constant public symbol = "XCH";
211     uint8 constant public decimals = 18;
212     uint constant multiplier = 10 ** uint(decimals);
213 
214     event Deployed(uint indexed _totalSupply);
215     event Burnt(address indexed _receiver, uint indexed _num, uint indexed _totalSupply);
216 
217     /*
218      *  Public functions
219      */
220     /// @dev Contract constructor function sets dutch auction contract address
221     /// and assigns all tokens to dutch auction.
222     /// @param auctionAddress Address of dutch auction contract.
223     /// @param walletAddress Address of wallet.
224     function xChaingeToken(address auctionAddress, address walletAddress) public
225     {
226         // Auction address should not be null.
227         require(auctionAddress != 0x0);
228         require(walletAddress != 0x0);
229 
230         // Total supply of Xei at deployment
231         totalSupply = 23529412000000000000000000;
232 
233         balances[auctionAddress] = 20000000000000000000000000;
234         balances[walletAddress] = 3529412000000000000000000;
235 
236         Transfer(0x0, auctionAddress, balances[auctionAddress]);
237         Transfer(0x0, walletAddress, balances[walletAddress]);
238 
239         Deployed(totalSupply);
240 
241         assert(totalSupply == balances[auctionAddress] + balances[walletAddress]);
242     }
243 
244     /// @notice Allows `msg.sender` to simply destroy `num` token units (Xei). This means the total
245     /// token supply will decrease.
246     /// @dev Allows to destroy token units (Xei).
247     /// @param num Number of token units (Xei) to burn.
248     function burn(uint num) public {
249         require(num > 0);
250         require(balances[msg.sender] >= num);
251         require(totalSupply >= num);
252 
253         uint preBalance = balances[msg.sender];
254 
255         balances[msg.sender] -= num;
256         totalSupply -= num;
257         Burnt(msg.sender, num, totalSupply);
258         Transfer(msg.sender, 0x0, num);
259 
260         assert(balances[msg.sender] == preBalance - num);
261     }
262 }
263 
264 /// @title Dutch auction contract - distribution of a fixed number of tokens using an auction.
265 /// The contract code is inspired by the Gnosis and Raiden auction contract. 
266 /// Auction ends if a fixed number of tokens was sold.
267 contract DutchAuction {
268     /*
269      * Auction for the XCH Token.
270      *
271      * Terminology:
272      * 1 token unit = Xei
273      * 1 token = XCH = Xei * multiplier
274      * multiplier set from token's number of decimals (i.e. 10 ** decimals)
275      */
276 
277     // Wait 10 days after the end of the auction, before anyone can claim tokens
278     uint constant public tokenClaimWaitingPeriod = 10 days;
279 
280     /*
281      * Storage
282      */
283 
284     xChaingeToken public token;
285     address public ownerAddress;
286     address public walletAddress;
287 
288     // Price decay function parameters to be changed depending on the desired outcome
289 
290     // Starting price in WEI;
291     uint constant public priceStart = 50000000000000000;    
292     uint constant public minPrice = 5000000000000000;
293     uint constant public softCap = 10000000000000000000000;
294 
295     // For calculating elapsed time for price
296     uint public startTime;
297     uint public endTime;
298     uint public startBlock;
299 
300     // Keep track of all ETH received in the bids
301     uint public receivedWei;
302 
303     // Keep track of cumulative ETH funds for which the tokens have been claimed
304     uint public fundsClaimed;
305 
306     uint public tokenMultiplier;
307 
308     // Total number of Xei (XCH * multiplier) that will be auctioned
309     uint public numTokensAuctioned;
310 
311     // Wei per XCH (Xei * multiplier)
312     uint public finalPrice;
313 
314     // Bidder address => bid value
315     mapping (address => uint) public bids;
316 
317     Stages public stage;
318 
319     /*
320      * Enums
321      */
322     enum Stages {
323         AuctionDeployed,
324         AuctionSetUp,
325         AuctionStarted,
326         AuctionEnded,
327         AuctionCanceled,
328         TokensDistributed
329     }
330 
331     /*
332      * Modifiers
333      */
334     modifier atStage(Stages _stage) {
335         require(stage == _stage);
336         _;
337     }
338 
339     modifier isOwner() {
340         require(msg.sender == ownerAddress);
341         _;
342     }
343 
344     /*
345      * Events
346      */
347 
348     event Deployed();
349     event Setup();
350     event AuctionStarted(uint indexed _startTime, uint indexed _blockNumber);
351     event BidSubmission(address indexed _sender, uint _amount, uint _missingFunds);
352     event ClaimedTokens(address indexed _recipient, uint _sentAmount);
353     event AuctionEnded(uint _finalPrice);
354     event TokensDistributed();
355     event AuctionCanceled();
356 
357     /*
358      * Public functions
359      */
360 
361     /// @dev Contract constructor function sets the starting price, divisor constant and
362     /// divisor exponent for calculating the Dutch Auction price.
363     /// @param _walletAddress Wallet address
364     function DutchAuction(address _walletAddress) public
365     {
366         require(_walletAddress != 0x0);
367         walletAddress = _walletAddress;
368 
369         ownerAddress = msg.sender;
370         stage = Stages.AuctionDeployed;
371         Deployed();
372     }
373 
374     /// @dev Fallback function for the contract, which calls bid() if the auction has started.
375     function () public payable atStage(Stages.AuctionStarted) {
376         bid();
377     }
378 
379     /// @notice Set `_tokenAddress` as the token address to be used in the auction.
380     /// @dev Setup function sets external contracts addresses.
381     /// @param _tokenAddress Token address.
382     function setup(address _tokenAddress) public isOwner atStage(Stages.AuctionDeployed) {
383         require(_tokenAddress != 0x0);
384         token = xChaingeToken(_tokenAddress);
385 
386         // Get number of Xei (XCH * multiplier) to be auctioned from token auction balance
387         numTokensAuctioned = token.balanceOf(address(this));
388 
389         // Set the number of the token multiplier for its decimals
390         tokenMultiplier = 10 ** uint(token.decimals());
391 
392         stage = Stages.AuctionSetUp;
393         Setup();
394     }
395 
396     /// @notice Start the auction.
397     /// @dev Starts auction and sets startTime.
398     function startAuction() public isOwner atStage(Stages.AuctionSetUp) {
399         stage = Stages.AuctionStarted;
400         startTime = now;
401         startBlock = block.number;
402         AuctionStarted(startTime, startBlock);
403     }
404 
405     /// @notice Finalize the auction - sets the final XCH token price and changes the auction
406     /// stage after no bids are allowed anymore.
407     /// @dev Finalize auction and set the final XCH token price.
408     function finalizeAuction() public atStage(Stages.AuctionStarted)
409     {
410         require(price() == minPrice);
411 
412         endTime = now;
413 
414         if (receivedWei < softCap)
415         {
416             token.transfer(walletAddress, numTokensAuctioned);
417             stage = Stages.AuctionCanceled;
418             AuctionCanceled();
419             return;
420         }
421 
422         // Send ETH to wallet
423         walletAddress.transfer(receivedWei);
424 
425         uint missingFunds = missingFundsToEndAuction();
426         if (missingFunds > 0){
427             uint soldTokens = tokenMultiplier * receivedWei / price();
428             uint burnTokens = numTokensAuctioned - soldTokens;
429             token.burn(burnTokens);
430             numTokensAuctioned -= burnTokens;
431         }
432 
433         // Calculate the final price = WEI / XCH = WEI / (Xei / multiplier)
434         // Reminder: numTokensAuctioned is the number of Xei (XCH * multiplier) that are auctioned
435         finalPrice = tokenMultiplier * receivedWei / numTokensAuctioned;
436 
437         stage = Stages.AuctionEnded;
438         AuctionEnded(finalPrice);
439 
440         assert(finalPrice > 0);
441     }
442 
443     /// @notice Canceled the auction
444     function CancelAuction() public isOwner atStage(Stages.AuctionStarted)
445     {
446         token.transfer(walletAddress, numTokensAuctioned);
447         stage = Stages.AuctionCanceled;
448         AuctionCanceled();
449     }
450 
451     /// --------------------------------- Auction Functions ------------------
452 
453 
454     /// @notice Send `msg.value` WEI to the auction from the `msg.sender` account.
455     /// @dev Allows to send a bid to the auction.
456     function bid() public payable atStage(Stages.AuctionStarted)
457     {
458         require(msg.value > 0);
459         assert(bids[msg.sender] + msg.value >= msg.value);
460 
461         // Missing funds without the current bid value
462         uint missingFunds = missingFundsToEndAuction();
463 
464         // We require bid values to be less than the funds missing to end the auction
465         // at the current price.
466         require(msg.value <= missingFunds);
467 
468         bids[msg.sender] += msg.value;
469         receivedWei += msg.value;
470 
471         BidSubmission(msg.sender, msg.value, missingFunds);
472 
473         assert(receivedWei >= msg.value);
474     }
475 
476     /// @notice Claim auction tokens for `msg.sender` after the auction has ended.
477     /// @dev Claims tokens for `msg.sender` after auction. To be used if tokens can
478     /// be claimed by beneficiaries, individually.
479     function claimTokens() public atStage(Stages.AuctionEnded) returns (bool) {
480         return proxyClaimTokens(msg.sender);
481     }
482 
483     /// @notice Claim auction tokens for `receiverAddress` after the auction has ended.
484     /// @dev Claims tokens for `receiverAddress` after auction has ended.
485     /// @param receiverAddress Tokens will be assigned to this address if eligible.
486     function proxyClaimTokens(address receiverAddress) public atStage(Stages.AuctionEnded) returns (bool)
487     {
488         // Waiting period after the end of the auction, before anyone can claim tokens
489         // Ensures enough time to check if auction was finalized correctly
490         // before users start transacting tokens
491         require(now > endTime + tokenClaimWaitingPeriod);
492         require(receiverAddress != 0x0);
493 
494         if (bids[receiverAddress] == 0) {
495             return false;
496         }
497 
498         // Number of Xei = bid wei / Xei = bid wei / (wei per XCH * multiplier)
499         uint num = (tokenMultiplier * bids[receiverAddress]) / finalPrice;
500 
501         // Due to finalPrice floor rounding, the number of assigned tokens may be higher
502         // than expected. Therefore, the number of remaining unassigned auction tokens
503         // may be smaller than the number of tokens needed for the last claimTokens call
504         uint auctionTokensBalance = token.balanceOf(address(this));
505         if (num > auctionTokensBalance) {
506             num = auctionTokensBalance;
507         }
508 
509         // Update the total amount of funds for which tokens have been claimed
510         fundsClaimed += bids[receiverAddress];
511 
512         // Set receiver bid to 0 before assigning tokens
513         bids[receiverAddress] = 0;
514 
515         require(token.transfer(receiverAddress, num));
516 
517         ClaimedTokens(receiverAddress, num);
518 
519         // After the last tokens are claimed, we change the auction stage
520         // Due to the above logic, rounding errors will not be an issue
521         if (fundsClaimed == receivedWei) {
522             stage = Stages.TokensDistributed;
523             TokensDistributed();
524         }
525 
526         assert(token.balanceOf(receiverAddress) >= num);
527         assert(bids[receiverAddress] == 0);
528         return true;
529     }
530 
531     /// @notice Withdraw ETH for `msg.sender` after the auction has canceled.
532     function withdraw() public atStage(Stages.AuctionCanceled) returns (bool) {
533         return proxyWithdraw(msg.sender);
534     }
535 
536     /// @notice Withdraw ETH for `receiverAddress` after the auction has canceled.
537     /// @param receiverAddress ETH will be assigned to this address if eligible.
538     function proxyWithdraw(address receiverAddress) public atStage(Stages.AuctionCanceled) returns (bool) {
539         require(receiverAddress != 0x0);
540         
541         if (bids[receiverAddress] == 0) {
542             return false;
543         }
544 
545         uint amount = bids[receiverAddress];
546         bids[receiverAddress] = 0;
547         
548         receiverAddress.transfer(amount);
549 
550         assert(bids[receiverAddress] == 0);
551         return true;
552     }
553 
554     /// @notice Get the XCH price in WEI during the auction, at the time of
555     /// calling this function. Returns `0` if auction has ended.
556     /// Returns `priceStart` before auction has started.
557     /// @dev Calculates the current XCH token price in WEI.
558     /// @return Returns WEI per XCH (Xei * multiplier).
559     function price() public constant returns (uint) {
560         if (stage == Stages.AuctionEnded ||
561             stage == Stages.AuctionCanceled ||
562             stage == Stages.TokensDistributed) {
563             return 0;
564         }
565         return calcTokenPrice();
566     }
567 
568     /// @notice Get the missing funds needed to end the auction,
569     /// calculated at the current XCH price in WEI.
570     /// @dev The missing funds amount necessary to end the auction at the current XCH price in WEI.
571     /// @return Returns the missing funds amount in WEI.
572     function missingFundsToEndAuction() constant public returns (uint) {
573 
574         // numTokensAuctioned = total number of Xei (XCH * multiplier) that is auctioned
575         uint requiredWeiAtPrice = numTokensAuctioned * price() / tokenMultiplier;
576         if (requiredWeiAtPrice <= receivedWei) {
577             return 0;
578         }
579 
580         // assert(requiredWeiAtPrice - receivedWei > 0);
581         return requiredWeiAtPrice - receivedWei;
582     }
583 
584     /*
585      *  Private functions
586      */
587 
588     /// @dev Calculates the token price (WEI / XCH) at the current timestamp
589     /// during the auction; elapsed time = 0 before auction starts.
590     /// Based on the provided parameters, the price does not change in the first
591     /// `priceConstant^(1/priceExponent)` seconds due to rounding.
592     /// Rounding in `decayRate` also produces values that increase instead of decrease
593     /// in the beginning; these spikes decrease over time and are noticeable
594     /// only in first hours. This should be calculated before usage.
595     /// @return Returns the token price - Wei per XCH.
596     function calcTokenPrice() constant private returns (uint) {
597         uint elapsed;
598         if (stage == Stages.AuctionStarted) {
599             elapsed = now - startTime;
600         }
601 
602         uint decayRate = elapsed ** 3 / 541000000000;
603         uint currentPrice = priceStart * (1 + elapsed) / (1 + elapsed + decayRate);
604         return minPrice > currentPrice ? minPrice : currentPrice;
605     }
606 }