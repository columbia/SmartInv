1 pragma solidity ^0.4.4;
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
18 //
19 // Enjoy. (c) JonnyLatte & BokkyPooBah 2017. The MIT licence.
20 // ------------------------------------------------------------------------
21 
22 // https://github.com/ethereum/EIPs/issues/20
23 contract ERC20 {
24     function totalSupply() constant returns (uint totalSupply);
25     function balanceOf(address _owner) constant returns (uint balance);
26     function transfer(address _to, uint _value) returns (bool success);
27     function transferFrom(address _from, address _to, uint _value) returns (bool success);
28     function approve(address _spender, uint _value) returns (bool success);
29     function allowance(address _owner, address _spender) constant returns (uint remaining);
30     event Transfer(address indexed _from, address indexed _to, uint _value);
31     event Approval(address indexed _owner, address indexed _spender, uint _value);
32 }
33 
34 contract Owned {
35     address public owner;
36     event OwnershipTransferred(address indexed _from, address indexed _to);
37 
38     function Owned() {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner {
43         if (msg.sender != owner) throw;
44         _;
45     }
46 
47     modifier onlyOwnerOrTokenTraderWithSameOwner {
48         if (msg.sender != owner && TokenTrader(msg.sender).owner() != owner) throw;
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner {
53         OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 }
57 
58 // contract can buy or sell tokens for ETH
59 // prices are in amount of wei per batch of token units
60 
61 contract TokenTrader is Owned {
62 
63     address public asset;       // address of token
64     uint256 public buyPrice;    // contract buys lots of token at this price
65     uint256 public sellPrice;   // contract sells lots at this price
66     uint256 public units;       // lot size (token-wei)
67 
68     bool public buysTokens;     // is contract buying
69     bool public sellsTokens;    // is contract selling
70 
71     event ActivatedEvent(bool buys, bool sells);
72     event MakerDepositedEther(uint256 amount);
73     event MakerWithdrewAsset(uint256 tokens);
74     event MakerTransferredAsset(address toTokenTrader, uint256 tokens);
75     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
76     event MakerWithdrewEther(uint256 ethers);
77     event MakerTransferredEther(address toTokenTrader, uint256 ethers);
78     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
79         uint256 ethersReturned, uint256 tokensBought);
80     event TakerSoldAsset(address indexed seller, uint256 etherValueOfTokensToSell,
81         uint256 tokensSold, uint256 etherValueOfTokensSold);
82 
83     // Constructor - only to be called by the TokenTraderFactory contract
84     function TokenTrader (
85         address _asset,
86         uint256 _buyPrice,
87         uint256 _sellPrice,
88         uint256 _units,
89         bool    _buysTokens,
90         bool    _sellsTokens
91     ) {
92         asset       = _asset;
93         buyPrice    = _buyPrice;
94         sellPrice   = _sellPrice;
95         units       = _units;
96         buysTokens  = _buysTokens;
97         sellsTokens = _sellsTokens;
98         ActivatedEvent(buysTokens, sellsTokens);
99     }
100 
101     // Maker can activate or deactivate this contract's buying and
102     // selling status
103     //
104     // The ActivatedEvent() event is logged with the following
105     // parameter:
106     //   buysTokens   this contract can buy asset tokens
107     //   sellsTokens  this contract can sell asset tokens
108     //
109     function activate (
110         bool _buysTokens,
111         bool _sellsTokens
112     ) onlyOwner {
113         buysTokens  = _buysTokens;
114         sellsTokens = _sellsTokens;
115         ActivatedEvent(buysTokens, sellsTokens);
116     }
117 
118     // Maker can deposit ethers to this contract so this contract
119     // can buy asset tokens.
120     //
121     // Maker deposits asset tokens to this contract by calling the
122     // asset's transfer() method with the following parameters
123     //   _to     is the address of THIS contract
124     //   _value  is the number of asset tokens to be transferred
125     //
126     // Taker MUST NOT send tokens directly to this contract. Takers
127     // MUST use the takerSellAsset() method to sell asset tokens
128     // to this contract
129     //
130     // Maker can also transfer ethers from one TokenTrader contract
131     // to another TokenTrader contract, both owned by the Maker
132     //
133     // The MakerDepositedEther() event is logged with the following
134     // parameter:
135     //   ethers  is the number of ethers deposited by the maker
136     //
137     // This method was called deposit() in the old version
138     //
139     function makerDepositEther() payable onlyOwnerOrTokenTraderWithSameOwner {
140         MakerDepositedEther(msg.value);
141     }
142 
143     // Maker can withdraw asset tokens from this contract, with the
144     // following parameter:
145     //   tokens  is the number of asset tokens to be withdrawn
146     //
147     // The MakerWithdrewAsset() event is logged with the following
148     // parameter:
149     //   tokens  is the number of tokens withdrawn by the maker
150     //
151     // This method was called withdrawAsset() in the old version
152     //
153     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) {
154         MakerWithdrewAsset(tokens);
155         return ERC20(asset).transfer(owner, tokens);
156     }
157 
158     // Maker can transfer asset tokens from this contract to another
159     // TokenTrader contract, with the following parameter:
160     //   toTokenTrader  Another TokenTrader contract owned by the
161     //                  same owner and with the same asset
162     //   tokens         is the number of asset tokens to be moved
163     //
164     // The MakerTransferredAsset() event is logged with the following
165     // parameters:
166     //   toTokenTrader  The other TokenTrader contract owned by
167     //                  the same owner and with the same asset
168     //   tokens         is the number of tokens transferred
169     //
170     // The asset Transfer() event is also logged from this contract
171     // to the other contract
172     //
173     function makerTransferAsset(
174         TokenTrader toTokenTrader,
175         uint256 tokens
176     ) onlyOwner returns (bool ok) {
177         if (owner != toTokenTrader.owner() || asset != toTokenTrader.asset()) {
178             throw;
179         }
180         MakerTransferredAsset(toTokenTrader, tokens);
181         return ERC20(asset).transfer(toTokenTrader, tokens);
182     }
183 
184     // Maker can withdraw any ERC20 asset tokens from this contract
185     //
186     // This method is included in the case where this contract receives
187     // the wrong tokens
188     //
189     // The MakerWithdrewERC20Token() event is logged with the following
190     // parameter:
191     //   tokenAddress  is the address of the tokens withdrawn by the maker
192     //   tokens        is the number of tokens withdrawn by the maker
193     //
194     // This method was called withdrawToken() in the old version
195     //
196     function makerWithdrawERC20Token(
197         address tokenAddress,
198         uint256 tokens
199     ) onlyOwner returns (bool ok) {
200         MakerWithdrewERC20Token(tokenAddress, tokens);
201         return ERC20(tokenAddress).transfer(owner, tokens);
202     }
203 
204     // Maker can withdraw ethers from this contract
205     //
206     // The MakerWithdrewEther() event is logged with the following parameter
207     //   ethers  is the number of ethers withdrawn by the maker
208     //
209     // This method was called withdraw() in the old version
210     //
211     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {
212         if (this.balance >= ethers) {
213             MakerWithdrewEther(ethers);
214             return owner.send(ethers);
215         }
216     }
217 
218     // Maker can transfer ethers from this contract to another TokenTrader
219     // contract, with the following parameters:
220     //   toTokenTrader  Another TokenTrader contract owned by the
221     //                  same owner and with the same asset
222     //   ethers         is the number of ethers to be moved
223     //
224     // The MakerTransferredEther() event is logged with the following parameter
225     //   toTokenTrader  The other TokenTrader contract owned by the
226     //                  same owner and with the same asset
227     //   ethers         is the number of ethers transferred
228     //
229     // The MakerDepositedEther() event is logged on the other
230     // contract with the following parameter:
231     //   ethers  is the number of ethers deposited by the maker
232     //
233     function makerTransferEther(
234         TokenTrader toTokenTrader,
235         uint256 ethers
236     ) onlyOwner returns (bool ok) {
237         if (owner != toTokenTrader.owner() || asset != toTokenTrader.asset()) {
238             throw;
239         }
240         if (this.balance >= ethers) {
241             MakerTransferredEther(toTokenTrader, ethers);
242             toTokenTrader.makerDepositEther.value(ethers)();
243         }
244     }
245 
246     // Taker buys asset tokens by sending ethers
247     //
248     // The TakerBoughtAsset() event is logged with the following parameters
249     //   buyer           is the buyer's address
250     //   ethersSent      is the number of ethers sent by the buyer
251     //   ethersReturned  is the number of ethers sent back to the buyer as
252     //                   change
253     //   tokensBought    is the number of asset tokens sent to the buyer
254     //
255     // This method was called buy() in the old version
256     //
257     function takerBuyAsset() payable {
258         if (sellsTokens || msg.sender == owner) {
259             // Note that sellPrice has already been validated as > 0
260             uint order    = msg.value / sellPrice;
261             // Note that units has already been validated as > 0
262             uint can_sell = ERC20(asset).balanceOf(address(this)) / units;
263             uint256 change = 0;
264             if (msg.value > (can_sell * sellPrice)) {
265                 change  = msg.value - (can_sell * sellPrice);
266                 order = can_sell;
267             }
268             if (change > 0) {
269                 if (!msg.sender.send(change)) throw;
270             }
271             if (order > 0) {
272                 if (!ERC20(asset).transfer(msg.sender, order * units)) throw;
273             }
274             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
275         }
276         // Return user funds if the contract is not selling
277         else if (!msg.sender.send(msg.value)) throw;
278     }
279 
280     // Taker sells asset tokens for ethers by:
281     // 1. Calling the asset's approve() method with the following parameters
282     //    _spender            is the address of this contract
283     //    _value              is the number of tokens to be sold
284     // 2. Calling this takerSellAsset() method with the following parameter
285     //    etherValueOfTokens  is the ether value of the asset tokens to be sold
286     //                        by the taker
287     //
288     // The TakerSoldAsset() event is logged with the following parameters
289     //   seller                    is the seller's address
290     //   etherValueOfTokensToSell  is the ether value of the asset tokens being
291     //                             sold by the taker
292     //   tokensSold                is the number of the asset tokens sold
293     //   etherValueOfTokensSold    is the ether value of the asset tokens sold
294     //
295     // This method was called sell() in the old version
296     //
297     function takerSellAsset(uint256 etherValueOfTokensToSell) {
298         if (buysTokens || msg.sender == owner) {
299             // Maximum number of token the contract can buy
300             // Note that buyPrice has already been validated as > 0
301             uint256 can_buy = this.balance / buyPrice;
302             // Token lots available
303             // Note that units has already been validated as > 0
304             uint256 order = etherValueOfTokensToSell / units;
305             // Adjust order for funds available
306             if (order > can_buy) order = can_buy;
307             if (order > 0) {
308                 // Extract user tokens
309                 if (!ERC20(asset).transferFrom(msg.sender, address(this), order * units)) throw;
310                 // Pay user
311                 if (!msg.sender.send(order * buyPrice)) throw;
312             }
313             TakerSoldAsset(msg.sender, etherValueOfTokensToSell, order * units, order * buyPrice);
314         }
315     }
316 
317     // Taker buys tokens by sending ethers
318     function () payable {
319         takerBuyAsset();
320     }
321 }
322 
323 // This contract deploys TokenTrader contracts and logs the event
324 contract TokenTraderFactory is Owned {
325 
326     event TradeListing(address indexed ownerAddress, address indexed tokenTraderAddress,
327         address indexed asset, uint256 buyPrice, uint256 sellPrice, uint256 units,
328         bool buysTokens, bool sellsTokens);
329     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
330 
331     mapping(address => bool) _verify;
332 
333     // Anyone can call this method to verify the settings of a
334     // TokenTrader contract. The parameters are:
335     //   tradeContract  is the address of a TokenTrader contract
336     //
337     // Return values:
338     //   valid        did this TokenTraderFactory create the TokenTrader contract?
339     //   owner        is the owner of the TokenTrader contract
340     //   asset        is the ERC20 asset address
341     //   buyPrice     is the buy price in ethers per `units` of asset tokens
342     //   sellPrice    is the sell price in ethers per `units` of asset tokens
343     //   units        is the number of units of asset tokens
344     //   buysTokens   is the TokenTrader contract buying tokens?
345     //   sellsTokens  is the TokenTrader contract selling tokens?
346     //
347     function verify(address tradeContract) constant returns (
348         bool    valid,
349         address owner,
350         address asset,
351         uint256 buyPrice,
352         uint256 sellPrice,
353         uint256 units,
354         bool    buysTokens,
355         bool    sellsTokens
356     ) {
357         valid = _verify[tradeContract];
358         if (valid) {
359             TokenTrader t = TokenTrader(tradeContract);
360             owner         = t.owner();
361             asset         = t.asset();
362             buyPrice      = t.buyPrice();
363             sellPrice     = t.sellPrice();
364             units         = t.units();
365             buysTokens    = t.buysTokens();
366             sellsTokens   = t.sellsTokens();
367         }
368     }
369 
370     // Maker can call this method to create a new TokenTrader contract
371     // with the maker being the owner of this new contract
372     //
373     // Parameters:
374     //   asset        is the ERC20 asset address
375     //   buyPrice     is the buy price in ethers per `units` of asset tokens
376     //   sellPrice    is the sell price in ethers per `units` of asset tokens
377     //   units        is the number of units of asset tokens
378     //   buysTokens   is the TokenTrader contract buying tokens?
379     //   sellsTokens  is the TokenTrader contract selling tokens?
380     //
381     // For example, listing a TokenTrader contract on the REP Augur token where
382     // the contract will buy REP tokens at a rate of 39000/100000 = 0.39 ETH
383     // per REP token and sell REP tokens at a rate of 41000/100000 = 0.41 ETH
384     // per REP token:
385     //   asset        0x48c80f1f4d53d5951e5d5438b54cba84f29f32a5
386     //   buyPrice     39000
387     //   sellPrice    41000
388     //   units        100000
389     //   buysTokens   true
390     //   sellsTokens  true
391     //
392     // The TradeListing() event is logged with the following parameters
393     //   ownerAddress        is the Maker's address
394     //   tokenTraderAddress  is the address of the newly created TokenTrader contract
395     //   asset               is the ERC20 asset address
396     //   buyPrice            is the buy price in ethers per `units` of asset tokens
397     //   sellPrice           is the sell price in ethers per `units` of asset tokens
398     //   unit                is the number of units of asset tokens
399     //   buysTokens          is the TokenTrader contract buying tokens?
400     //   sellsTokens         is the TokenTrader contract selling tokens?
401     //
402     function createTradeContract(
403         address asset,
404         uint256 buyPrice,
405         uint256 sellPrice,
406         uint256 units,
407         bool    buysTokens,
408         bool    sellsTokens
409     ) returns (address trader) {
410         // Cannot have invalid asset
411         if (asset == 0x0) throw;
412         // Cannot set zero or negative price
413         if (buyPrice <= 0 || sellPrice <= 0) throw;
414         // Must make profit on spread
415         if (buyPrice >= sellPrice) throw;
416         // Cannot buy or sell zero or negative units
417         if (units <= 0) throw;
418         trader = new TokenTrader(
419             asset,
420             buyPrice,
421             sellPrice,
422             units,
423             buysTokens,
424             sellsTokens);
425         // Record that this factory created the trader
426         _verify[trader] = true;
427         // Set the owner to whoever called the function
428         TokenTrader(trader).transferOwnership(msg.sender);
429         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, units, buysTokens, sellsTokens);
430     }
431 
432     // Factory owner can withdraw any ERC20 asset tokens from this contract
433     //
434     // This method is included in the case where this contract receives
435     // the wrong tokens
436     //
437     // The OwnerWithdrewERC20Token() event is logged with the following
438     // parameter:
439     //   tokenAddress  is the address of the tokens withdrawn by the maker
440     //   tokens        is the number of tokens withdrawn by the maker
441     //
442     function ownerWithdrawERC20Token(address tokenAddress, uint256 tokens) onlyOwner returns (bool ok) {
443         OwnerWithdrewERC20Token(tokenAddress, tokens);
444         return ERC20(tokenAddress).transfer(owner, tokens);
445     }
446 
447     // Prevents accidental sending of ether to the factory
448     function () {
449         throw;
450     }
451 }