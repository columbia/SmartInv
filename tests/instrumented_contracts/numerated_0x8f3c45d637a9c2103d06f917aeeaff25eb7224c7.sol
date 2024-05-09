1 pragma solidity ^0.4.11;
2 
3 // ------------------------------------------------------------------------
4 // TokenTraderFactory
5 //
6 // Decentralised trustless ERC20-compliant token to ETH exchange contract
7 // on the Ethereum blockchain.
8 //
9 // Note that this TokenTrader cannot be used with the Golem Network Token
10 // directly as the token does not implement the ERC20
11 // transferFrom(...), approve(...) and allowance(...) methods
12 //
13 // History:
14 //   Jan 25 2017 - BPB Added makerTransferAsset(...) and
15 //                     makerTransferEther(...)
16 //   Feb 05 2017 - BPB Bug fix in the change calculation for the Unicorn
17 //                     token with natural number 1
18 //   Feb 08 2017 - BPB/JL Renamed etherValueOfTokensToSell to
19 //                     amountOfTokensToSell in takerSellAsset(...) to
20 //                     better describe the parameter
21 //                     Added check in createTradeContract(...) to prevent
22 //                     GNTs from being used with this contract. The asset
23 //                     token will need to have an allowance(...) function.
24 //
25 // Enjoy. (c) JonnyLatte & BokkyPooBah 2017. The MIT licence.
26 // ------------------------------------------------------------------------
27 
28 // https://github.com/ethereum/EIPs/issues/20
29 contract ERC20 {
30     function totalSupply() constant returns (uint totalSupply);
31     function balanceOf(address _owner) constant returns (uint balance);
32     function transfer(address _to, uint _value) returns (bool success);
33     function transferFrom(address _from, address _to, uint _value) returns (bool success);
34     function approve(address _spender, uint _value) returns (bool success);
35     function allowance(address _owner, address _spender) constant returns (uint remaining);
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 }
39 
40 contract Owned {
41     address public owner;
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     function Owned() {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         if (msg.sender != owner) throw;
50         _;
51     }
52 
53     modifier onlyOwnerOrTokenTraderWithSameOwner {
54         if (msg.sender != owner && TokenTrader(msg.sender).owner() != owner) throw;
55         _;
56     }
57 
58     function transferOwnership(address newOwner) onlyOwner {
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 }
63 
64 // contract can buy or sell tokens for ETH
65 // prices are in amount of wei per batch of token units
66 
67 contract TokenTrader is Owned {
68 
69     address public asset;       // address of token
70     uint256 public buyPrice;    // contract buys lots of token at this price
71     uint256 public sellPrice;   // contract sells lots at this price
72     uint256 public units;       // lot size (token-wei)
73 
74     bool public buysTokens;     // is contract buying
75     bool public sellsTokens;    // is contract selling
76 
77     event ActivatedEvent(bool buys, bool sells);
78     event MakerDepositedEther(uint256 amount);
79     event MakerWithdrewAsset(uint256 tokens);
80     event MakerTransferredAsset(address toTokenTrader, uint256 tokens);
81     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
82     event MakerWithdrewEther(uint256 ethers);
83     event MakerTransferredEther(address toTokenTrader, uint256 ethers);
84     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
85         uint256 ethersReturned, uint256 tokensBought);
86     event TakerSoldAsset(address indexed seller, uint256 amountOfTokensToSell,
87         uint256 tokensSold, uint256 etherValueOfTokensSold);
88 
89     // Constructor - only to be called by the TokenTraderFactory contract
90     function TokenTrader (
91         address _asset,
92         uint256 _buyPrice,
93         uint256 _sellPrice,
94         uint256 _units,
95         bool    _buysTokens,
96         bool    _sellsTokens
97     ) {
98         asset       = _asset;
99         buyPrice    = _buyPrice;
100         sellPrice   = _sellPrice;
101         units       = _units;
102         buysTokens  = _buysTokens;
103         sellsTokens = _sellsTokens;
104         ActivatedEvent(buysTokens, sellsTokens);
105     }
106 
107     // Maker can activate or deactivate this contract's buying and
108     // selling status
109     //
110     // The ActivatedEvent() event is logged with the following
111     // parameter:
112     //   buysTokens   this contract can buy asset tokens
113     //   sellsTokens  this contract can sell asset tokens
114     //
115     function activate (
116         bool _buysTokens,
117         bool _sellsTokens
118     ) onlyOwner {
119         buysTokens  = _buysTokens;
120         sellsTokens = _sellsTokens;
121         ActivatedEvent(buysTokens, sellsTokens);
122     }
123 
124     // Maker can deposit ethers to this contract so this contract
125     // can buy asset tokens.
126     //
127     // Maker deposits asset tokens to this contract by calling the
128     // asset's transfer() method with the following parameters
129     //   _to     is the address of THIS contract
130     //   _value  is the number of asset tokens to be transferred
131     //
132     // Taker MUST NOT send tokens directly to this contract. Takers
133     // MUST use the takerSellAsset() method to sell asset tokens
134     // to this contract
135     //
136     // Maker can also transfer ethers from one TokenTrader contract
137     // to another TokenTrader contract, both owned by the Maker
138     //
139     // The MakerDepositedEther() event is logged with the following
140     // parameter:
141     //   ethers  is the number of ethers deposited by the maker
142     //
143     // This method was called deposit() in the old version
144     //
145     function makerDepositEther() payable onlyOwnerOrTokenTraderWithSameOwner {
146         MakerDepositedEther(msg.value);
147     }
148 
149     // Maker can withdraw asset tokens from this contract, with the
150     // following parameter:
151     //   tokens  is the number of asset tokens to be withdrawn
152     //
153     // The MakerWithdrewAsset() event is logged with the following
154     // parameter:
155     //   tokens  is the number of tokens withdrawn by the maker
156     //
157     // This method was called withdrawAsset() in the old version
158     //
159     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) {
160         MakerWithdrewAsset(tokens);
161         return ERC20(asset).transfer(owner, tokens);
162     }
163 
164     // Maker can transfer asset tokens from this contract to another
165     // TokenTrader contract, with the following parameter:
166     //   toTokenTrader  Another TokenTrader contract owned by the
167     //                  same owner and with the same asset
168     //   tokens         is the number of asset tokens to be moved
169     //
170     // The MakerTransferredAsset() event is logged with the following
171     // parameters:
172     //   toTokenTrader  The other TokenTrader contract owned by
173     //                  the same owner and with the same asset
174     //   tokens         is the number of tokens transferred
175     //
176     // The asset Transfer() event is also logged from this contract
177     // to the other contract
178     //
179     function makerTransferAsset(
180         TokenTrader toTokenTrader,
181         uint256 tokens
182     ) onlyOwner returns (bool ok) {
183         if (owner != toTokenTrader.owner() || asset != toTokenTrader.asset()) {
184             throw;
185         }
186         MakerTransferredAsset(toTokenTrader, tokens);
187         return ERC20(asset).transfer(toTokenTrader, tokens);
188     }
189 
190     // Maker can withdraw any ERC20 asset tokens from this contract
191     //
192     // This method is included in the case where this contract receives
193     // the wrong tokens
194     //
195     // The MakerWithdrewERC20Token() event is logged with the following
196     // parameter:
197     //   tokenAddress  is the address of the tokens withdrawn by the maker
198     //   tokens        is the number of tokens withdrawn by the maker
199     //
200     // This method was called withdrawToken() in the old version
201     //
202     function makerWithdrawERC20Token(
203         address tokenAddress,
204         uint256 tokens
205     ) onlyOwner returns (bool ok) {
206         MakerWithdrewERC20Token(tokenAddress, tokens);
207         return ERC20(tokenAddress).transfer(owner, tokens);
208     }
209 
210     // Maker can withdraw ethers from this contract
211     //
212     // The MakerWithdrewEther() event is logged with the following parameter
213     //   ethers  is the number of ethers withdrawn by the maker
214     //
215     // This method was called withdraw() in the old version
216     //
217     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {
218         if (this.balance >= ethers) {
219             MakerWithdrewEther(ethers);
220             return owner.send(ethers);
221         }
222     }
223 
224     // Maker can transfer ethers from this contract to another TokenTrader
225     // contract, with the following parameters:
226     //   toTokenTrader  Another TokenTrader contract owned by the
227     //                  same owner and with the same asset
228     //   ethers         is the number of ethers to be moved
229     //
230     // The MakerTransferredEther() event is logged with the following parameter
231     //   toTokenTrader  The other TokenTrader contract owned by the
232     //                  same owner and with the same asset
233     //   ethers         is the number of ethers transferred
234     //
235     // The MakerDepositedEther() event is logged on the other
236     // contract with the following parameter:
237     //   ethers  is the number of ethers deposited by the maker
238     //
239     function makerTransferEther(
240         TokenTrader toTokenTrader,
241         uint256 ethers
242     ) onlyOwner returns (bool ok) {
243         if (owner != toTokenTrader.owner() || asset != toTokenTrader.asset()) {
244             throw;
245         }
246         if (this.balance >= ethers) {
247             MakerTransferredEther(toTokenTrader, ethers);
248             toTokenTrader.makerDepositEther.value(ethers)();
249         }
250     }
251 
252     // Taker buys asset tokens by sending ethers
253     //
254     // The TakerBoughtAsset() event is logged with the following parameters
255     //   buyer           is the buyer's address
256     //   ethersSent      is the number of ethers sent by the buyer
257     //   ethersReturned  is the number of ethers sent back to the buyer as
258     //                   change
259     //   tokensBought    is the number of asset tokens sent to the buyer
260     //
261     // This method was called buy() in the old version
262     //
263     function takerBuyAsset() payable {
264         if (sellsTokens || msg.sender == owner) {
265             // Note that sellPrice has already been validated as > 0
266             uint order    = msg.value / sellPrice;
267             // Note that units has already been validated as > 0
268             uint can_sell = ERC20(asset).balanceOf(address(this)) / units;
269             uint256 change = 0;
270             if (msg.value > (can_sell * sellPrice)) {
271                 change  = msg.value - (can_sell * sellPrice);
272                 order = can_sell;
273             }
274             if (change > 0) {
275                 if (!msg.sender.send(change)) throw;
276             }
277             if (order > 0) {
278                 if (!ERC20(asset).transfer(msg.sender, order * units)) throw;
279             }
280             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
281         }
282         // Return user funds if the contract is not selling
283         else if (!msg.sender.send(msg.value)) throw;
284     }
285 
286     // Taker sells asset tokens for ethers by:
287     // 1. Calling the asset's approve() method with the following parameters
288     //    _spender            is the address of this contract
289     //    _value              is the number of tokens to be sold
290     // 2. Calling this takerSellAsset() method with the following parameter
291     //    etherValueOfTokens  is the ether value of the asset tokens to be sold
292     //                        by the taker
293     //
294     // The TakerSoldAsset() event is logged with the following parameters
295     //   seller                  is the seller's address
296     //   amountOfTokensToSell    is the amount of the asset tokens being
297     //                           sold by the taker
298     //   tokensSold              is the number of the asset tokens sold
299     //   etherValueOfTokensSold  is the ether value of the asset tokens sold
300     //
301     // This method was called sell() in the old version
302     //
303     function takerSellAsset(uint256 amountOfTokensToSell) {
304         if (buysTokens || msg.sender == owner) {
305             // Maximum number of token the contract can buy
306             // Note that buyPrice has already been validated as > 0
307             uint256 can_buy = this.balance / buyPrice;
308             // Token lots available
309             // Note that units has already been validated as > 0
310             uint256 order = amountOfTokensToSell / units;
311             // Adjust order for funds available
312             if (order > can_buy) order = can_buy;
313             if (order > 0) {
314                 // Extract user tokens
315                 if (!ERC20(asset).transferFrom(msg.sender, address(this), order * units)) throw;
316                 // Pay user
317                 if (!msg.sender.send(order * buyPrice)) throw;
318             }
319             TakerSoldAsset(msg.sender, amountOfTokensToSell, order * units, order * buyPrice);
320         }
321     }
322 
323     // Taker buys tokens by sending ethers
324     function () payable {
325         takerBuyAsset();
326     }
327 }
328 
329 // This contract deploys TokenTrader contracts and logs the event
330 contract TokenTraderFactory is Owned {
331 
332     event TradeListing(address indexed ownerAddress, address indexed tokenTraderAddress,
333         address indexed asset, uint256 buyPrice, uint256 sellPrice, uint256 units,
334         bool buysTokens, bool sellsTokens);
335     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
336 
337     mapping(address => bool) _verify;
338 
339     // Anyone can call this method to verify the settings of a
340     // TokenTrader contract. The parameters are:
341     //   tradeContract  is the address of a TokenTrader contract
342     //
343     // Return values:
344     //   valid        did this TokenTraderFactory create the TokenTrader contract?
345     //   owner        is the owner of the TokenTrader contract
346     //   asset        is the ERC20 asset address
347     //   buyPrice     is the buy price in ethers per `units` of asset tokens
348     //   sellPrice    is the sell price in ethers per `units` of asset tokens
349     //   units        is the number of units of asset tokens
350     //   buysTokens   is the TokenTrader contract buying tokens?
351     //   sellsTokens  is the TokenTrader contract selling tokens?
352     //
353     function verify(address tradeContract) constant returns (
354         bool    valid,
355         address owner,
356         address asset,
357         uint256 buyPrice,
358         uint256 sellPrice,
359         uint256 units,
360         bool    buysTokens,
361         bool    sellsTokens
362     ) {
363         valid = _verify[tradeContract];
364         if (valid) {
365             TokenTrader t = TokenTrader(tradeContract);
366             owner         = t.owner();
367             asset         = t.asset();
368             buyPrice      = t.buyPrice();
369             sellPrice     = t.sellPrice();
370             units         = t.units();
371             buysTokens    = t.buysTokens();
372             sellsTokens   = t.sellsTokens();
373         }
374     }
375 
376     // Maker can call this method to create a new TokenTrader contract
377     // with the maker being the owner of this new contract
378     //
379     // Parameters:
380     //   asset        is the ERC20 asset address
381     //   buyPrice     is the buy price in ethers per `units` of asset tokens
382     //   sellPrice    is the sell price in ethers per `units` of asset tokens
383     //   units        is the number of units of asset tokens
384     //   buysTokens   is the TokenTrader contract buying tokens?
385     //   sellsTokens  is the TokenTrader contract selling tokens?
386     //
387     // For example, listing a TokenTrader contract on the REP Augur token where
388     // the contract will buy REP tokens at a rate of 39000/100000 = 0.39 ETH
389     // per REP token and sell REP tokens at a rate of 41000/100000 = 0.41 ETH
390     // per REP token:
391     //   asset        0x48c80f1f4d53d5951e5d5438b54cba84f29f32a5
392     //   buyPrice     39000
393     //   sellPrice    41000
394     //   units        100000
395     //   buysTokens   true
396     //   sellsTokens  true
397     //
398     // The TradeListing() event is logged with the following parameters
399     //   ownerAddress        is the Maker's address
400     //   tokenTraderAddress  is the address of the newly created TokenTrader contract
401     //   asset               is the ERC20 asset address
402     //   buyPrice            is the buy price in ethers per `units` of asset tokens
403     //   sellPrice           is the sell price in ethers per `units` of asset tokens
404     //   unit                is the number of units of asset tokens
405     //   buysTokens          is the TokenTrader contract buying tokens?
406     //   sellsTokens         is the TokenTrader contract selling tokens?
407     //
408     function createTradeContract(
409         address asset,
410         uint256 buyPrice,
411         uint256 sellPrice,
412         uint256 units,
413         bool    buysTokens,
414         bool    sellsTokens
415     ) returns (address trader) {
416         // Cannot have invalid asset
417         if (asset == 0x0) throw;
418         // Check for ERC20 allowance function
419         // This will throw an error if the allowance function
420         // is undefined to prevent GNTs from being used
421         // with this factory
422         uint256 allowance = ERC20(asset).allowance(msg.sender, this);
423         // Cannot set zero or negative price
424         if (buyPrice <= 0 || sellPrice <= 0) throw;
425         // Must make profit on spread
426         if (buyPrice >= sellPrice) throw;
427         // Cannot buy or sell zero or negative units
428         if (units <= 0) throw;
429 
430         trader = new TokenTrader(
431             asset,
432             buyPrice,
433             sellPrice,
434             units,
435             buysTokens,
436             sellsTokens);
437         // Record that this factory created the trader
438         _verify[trader] = true;
439         // Set the owner to whoever called the function
440         TokenTrader(trader).transferOwnership(msg.sender);
441         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, units, buysTokens, sellsTokens);
442     }
443 
444     // Factory owner can withdraw any ERC20 asset tokens from this contract
445     //
446     // This method is included in the case where this contract receives
447     // the wrong tokens
448     //
449     // The OwnerWithdrewERC20Token() event is logged with the following
450     // parameter:
451     //   tokenAddress  is the address of the tokens withdrawn by the maker
452     //   tokens        is the number of tokens withdrawn by the maker
453     //
454     function ownerWithdrawERC20Token(address tokenAddress, uint256 tokens) onlyOwner returns (bool ok) {
455         OwnerWithdrewERC20Token(tokenAddress, tokens);
456         return ERC20(tokenAddress).transfer(owner, tokens);
457     }
458 
459     // Prevents accidental sending of ether to the factory
460     function () {
461         throw;
462     }
463 }
464 
465 contract FixedSupplyToken is ERC20 {
466     string public name;
467     string public symbol;
468     uint256 _totalSupply;
469     uint8 public decimals;
470 
471     // Balances for each account
472     mapping(address => uint256) balances;
473 
474     // Owner of account approves the transfer of an amount to another account
475     mapping(address => mapping (address => uint256)) allowed;
476 
477     // Constructor
478     function FixedSupplyToken(
479       string _name,
480       string _symbol,
481       uint256 _supply,
482       uint8 _decimals
483     ) {
484         name = _name;
485         symbol = _symbol;
486         _totalSupply = _supply;
487         decimals = _decimals;
488         balances[msg.sender] = _totalSupply;
489     }
490 
491     function totalSupply() constant returns (uint256 totalSupply) {
492         totalSupply = _totalSupply;
493     }
494 
495     // What is the balance of a particular account?
496     function balanceOf(address _owner) constant returns (uint256 balance) {
497         return balances[_owner];
498     }
499 
500     // Transfer the balance from owner's account to another account
501     function transfer(address _to, uint256 _amount) returns (bool success) {
502         if (balances[msg.sender] >= _amount
503             && _amount > 0
504             && balances[_to] + _amount > balances[_to]) {
505             balances[msg.sender] -= _amount;
506             balances[_to] += _amount;
507             Transfer(msg.sender, _to, _amount);
508             return true;
509         } else {
510             return false;
511         }
512     }
513 
514     // Send _value amount of tokens from address _from to address _to
515     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
516     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
517     // fees in sub-currencies; the command should fail unless the _from account has
518     // deliberately authorized the sender of the message via some mechanism; we propose
519     // these standardized APIs for approval:
520     function transferFrom(
521         address _from,
522         address _to,
523         uint256 _amount
524     ) returns (bool success) {
525         if (balances[_from] >= _amount
526             && allowed[_from][msg.sender] >= _amount
527             && _amount > 0
528             && balances[_to] + _amount > balances[_to]) {
529             balances[_from] -= _amount;
530             allowed[_from][msg.sender] -= _amount;
531             balances[_to] += _amount;
532             Transfer(_from, _to, _amount);
533             return true;
534         } else {
535             return false;
536         }
537     }
538 
539     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
540     // If this function is called again it overwrites the current allowance with _value.
541     function approve(address _spender, uint256 _amount) returns (bool success) {
542         allowed[msg.sender][_spender] = _amount;
543         Approval(msg.sender, _spender, _amount);
544         return true;
545     }
546 
547     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
548         return allowed[_owner][_spender];
549     }
550 }
551 
552 contract TokenToken is FixedSupplyToken{
553   TokenTrader[] public tokenExchanges;
554   uint256[] public tokenRatios; // Measured in per 1e18, e.g.g 5e17 = 50%
555                                 // TokenRatios MUST ADD TO 1 (1e18)
556   uint256 tokensBought = 0;
557 
558   address public owner;
559   event OwnershipTransferred(address indexed _from, address indexed _to);
560 
561   /* This generates a public event on the blockchain that will notify clients */
562   //event Transfer(address indexed from, address indexed to, uint256 value);
563 
564   /* Initializes contract with initial supply tokens to the creator of the contract */
565 
566   function TokenToken(
567     string _name,
568     string _symbol,
569     uint256 _supply,
570     uint8 _decimals,
571     TokenTrader[] initialTokenExchanges,
572     uint256[] initialTokenRatios
573     ) FixedSupplyToken(
574       _name,
575       _symbol,
576       _supply,
577       _decimals
578     ) {
579     tokenExchanges = initialTokenExchanges;
580     tokenRatios = initialTokenRatios;
581     owner = msg.sender;
582   }
583 
584   modifier onlyOwner {
585       if (msg.sender != owner) throw;
586       _;
587   }
588 
589   function transferOwnership(address newOwner) onlyOwner {
590       OwnershipTransferred(owner, newOwner);
591       owner = newOwner;
592   }
593 
594   function setPurchaseRatios (
595     TokenTrader[] newTokenExchanges,
596     uint256[] newTokenRatios
597   ) onlyOwner returns (bool success) {
598       // Should have a lot of assertions
599       // TODO: Assert newTokenRatios.length == tokenRatios.length
600       // TODO: Assert newTokenRatios add to 1
601       tokenExchanges = newTokenExchanges;
602       tokenRatios = newTokenRatios;
603       return true;
604   }
605 
606   function buyPrice() constant returns (uint256 totalPrice) {
607     totalPrice = 0;
608     for (uint i = 0; i < tokenExchanges.length; ++i) {
609       totalPrice += tokenExchanges[i].buyPrice() * tokenRatios[i] / 1e18;
610     }
611     return totalPrice;
612   }
613 
614   function sellPrice() constant returns (uint256 totalPrice) {
615     totalPrice = 0;
616     for (uint i = 0; i < tokenExchanges.length; ++i) {
617       totalPrice += tokenExchanges[i].sellPrice() * tokenRatios[i] / 1e18;
618     }
619     return totalPrice;
620   }
621 
622   function () { // Sending ether to it buys coins automatically
623     buy();
624   }
625   function buy() payable returns (uint256 amount){        // Buy in ETH
626 
627     amount = msg.value / buyPrice();
628     for (uint i = 0; i < tokenExchanges.length; ++i) {
629       TokenTrader tokenExchange = tokenExchanges[i];
630       tokenExchange.transfer(msg.value * tokenRatios[i] / 1e18);
631     }
632     tokensBought += amount;
633     balances[msg.sender] += amount;                   // adds the amount to buyer's balance
634     balances[this] -= amount;                         // subtracts amount from seller's balance
635     Transfer(this, msg.sender, amount);                // execute an event reflecting the change
636     return amount;                                     // ends function and returns
637   }
638 
639   function sell(uint amount) returns (uint256 revenue){   // Sell in tokens
640     if (balances[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
641     balances[this] += amount;                         // adds the amount to owner's balance
642     balances[msg.sender] -= amount;                   // subtracts the amount from seller's balance
643 
644     uint256 subTokensToSell = 0;
645     revenue = 0;
646     for (uint i = 0; i < tokenExchanges.length; ++i) { // Unsafe code: what if the loop errors halfway?
647       TokenTrader tokenExchange = tokenExchanges[i];
648       subTokensToSell = ERC20(tokenExchange.asset()).balanceOf(this)*amount/tokensBought;
649 
650       revenue += subTokensToSell * tokenExchange.sellPrice();
651       ERC20(tokenExchange.asset()).approve(address(tokenExchange), subTokensToSell); // Approve sale
652       tokenExchange.takerSellAsset(subTokensToSell); // Make Sale
653     }
654 
655     tokensBought -= amount;
656     msg.sender.transfer(revenue);
657     Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
658     return revenue;                                // ends function and returns
659   }
660 
661   function breakdown(uint256 amount) {   // Breakdown in tokens
662     if (balances[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
663     balances[this] += amount;                         // adds the amount to owner's balance
664     balances[msg.sender] -= amount;                   // subtracts the amount from seller's balance
665 
666     uint256 subTokensToSell = 0;
667     for (uint i = 0; i < tokenExchanges.length; ++i) { // Unsafe code: what if the loop errors halfway?
668       TokenTrader tokenExchange = tokenExchanges[i];
669       subTokensToSell = ERC20(tokenExchange.asset()).balanceOf(this)*amount/tokensBought;
670       ERC20(tokenExchange.asset()).transfer(msg.sender, subTokensToSell);
671     }
672 
673     tokensBought -= amount;
674     Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
675   }
676 
677   function rebalance(TokenTrader fromExchange, TokenTrader toExchange, uint256 fromPercent) onlyOwner {
678     uint256 subTokensToSell = ERC20(fromExchange.asset()).balanceOf(this) * fromPercent / 1e18;
679 
680     uint256 revenue = subTokensToSell * fromExchange.sellPrice();
681     ERC20(fromExchange.asset()).approve(address(fromExchange), subTokensToSell); // Approve sale
682     fromExchange.takerSellAsset(subTokensToSell); // Make sale
683 
684     toExchange.transfer(revenue); // Make purchase with new contract.
685   }
686 
687   function kill() { if (msg.sender == owner) selfdestruct(owner); }
688 }