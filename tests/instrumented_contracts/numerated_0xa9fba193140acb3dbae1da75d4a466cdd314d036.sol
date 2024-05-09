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
13 // Enjoy. (c) JonnyLatte & BokkyPooBah 2016. The MIT licence.
14 // ------------------------------------------------------------------------
15 
16 // https://github.com/ethereum/EIPs/issues/20
17 contract ERC20 {
18     function totalSupply() constant returns (uint totalSupply);
19     function balanceOf(address _owner) constant returns (uint balance);
20     function transfer(address _to, uint _value) returns (bool success);
21     function transferFrom(address _from, address _to, uint _value) returns (bool success);
22     function approve(address _spender, uint _value) returns (bool success);
23     function allowance(address _owner, address _spender) constant returns (uint remaining);
24     event Transfer(address indexed _from, address indexed _to, uint _value);
25     event Approval(address indexed _owner, address indexed _spender, uint _value);
26 }
27 
28 contract Owned {
29     address public owner;
30     event OwnershipTransferred(address indexed _from, address indexed _to);
31 
32     function Owned() {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         if (msg.sender != owner) throw;
38         _;
39     }
40 
41     modifier onlyOwnerOrTokenTraderWithSameOwner {
42         if (msg.sender != owner && TokenTrader(msg.sender).owner() != owner) throw;
43         _;
44     }
45 
46     function transferOwnership(address newOwner) onlyOwner {
47         OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50 }
51 
52 // contract can buy or sell tokens for ETH
53 // prices are in amount of wei per batch of token units
54 
55 contract TokenTrader is Owned {
56 
57     address public asset;       // address of token
58     uint256 public buyPrice;    // contract buys lots of token at this price
59     uint256 public sellPrice;   // contract sells lots at this price
60     uint256 public units;       // lot size (token-wei)
61 
62     bool public buysTokens;     // is contract buying
63     bool public sellsTokens;    // is contract selling
64 
65     event ActivatedEvent(bool buys, bool sells);
66     event MakerDepositedEther(uint256 amount);
67     event MakerWithdrewAsset(uint256 tokens);
68     event MakerTransferredAsset(address toTokenTrader, uint256 tokens);
69     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
70     event MakerWithdrewEther(uint256 ethers);
71     event MakerTransferredEther(address toTokenTrader, uint256 ethers);
72     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
73         uint256 ethersReturned, uint256 tokensBought);
74     event TakerSoldAsset(address indexed seller, uint256 etherValueOfTokensToSell,
75         uint256 tokensSold, uint256 etherValueOfTokensSold);
76 
77     // Constructor - only to be called by the TokenTraderFactory contract
78     function TokenTrader (
79         address _asset,
80         uint256 _buyPrice,
81         uint256 _sellPrice,
82         uint256 _units,
83         bool    _buysTokens,
84         bool    _sellsTokens
85     ) internal {
86         asset       = _asset;
87         buyPrice    = _buyPrice;
88         sellPrice   = _sellPrice;
89         units       = _units;
90         buysTokens  = _buysTokens;
91         sellsTokens = _sellsTokens;
92         ActivatedEvent(buysTokens, sellsTokens);
93     }
94 
95     // Maker can activate or deactivate this contract's buying and
96     // selling status
97     //
98     // The ActivatedEvent() event is logged with the following
99     // parameter:
100     //   buysTokens   this contract can buy asset tokens
101     //   sellsTokens  this contract can sell asset tokens
102     //
103     function activate (
104         bool _buysTokens,
105         bool _sellsTokens
106     ) onlyOwner {
107         buysTokens  = _buysTokens;
108         sellsTokens = _sellsTokens;
109         ActivatedEvent(buysTokens, sellsTokens);
110     }
111 
112     // Maker can deposit ethers to this contract so this contract
113     // can buy asset tokens.
114     //
115     // Maker deposits asset tokens to this contract by calling the
116     // asset's transfer() method with the following parameters
117     //   _to     is the address of THIS contract
118     //   _value  is the number of asset tokens to be transferred
119     //
120     // Taker MUST NOT send tokens directly to this contract. Takers
121     // MUST use the takerSellAsset() method to sell asset tokens
122     // to this contract
123     //
124     // Maker can also transfer ethers from one TokenTrader contract
125     // to another TokenTrader contract, both owned by the Maker
126     //
127     // The MakerDepositedEther() event is logged with the following
128     // parameter:
129     //   ethers  is the number of ethers deposited by the maker
130     //
131     // This method was called deposit() in the old version
132     //
133     function makerDepositEther() payable onlyOwnerOrTokenTraderWithSameOwner {
134         MakerDepositedEther(msg.value);
135     }
136 
137     // Maker can withdraw asset tokens from this contract, with the
138     // following parameter:
139     //   tokens  is the number of asset tokens to be withdrawn
140     //
141     // The MakerWithdrewAsset() event is logged with the following
142     // parameter:
143     //   tokens  is the number of tokens withdrawn by the maker
144     //
145     // This method was called withdrawAsset() in the old version
146     //
147     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) {
148         MakerWithdrewAsset(tokens);
149         return ERC20(asset).transfer(owner, tokens);
150     }
151 
152     // Maker can transfer asset tokens from this contract to another
153     // TokenTrader contract, with the following parameter:
154     //   toTokenTrader  Another TokenTrader contract owned by the
155     //                  same owner and with the same asset
156     //   tokens         is the number of asset tokens to be moved
157     //
158     // The MakerTransferredAsset() event is logged with the following
159     // parameters:
160     //   toTokenTrader  The other TokenTrader contract owned by
161     //                  the same owner and with the same asset
162     //   tokens         is the number of tokens transferred
163     //
164     // The asset Transfer() event is also logged from this contract
165     // to the other contract
166     //
167     function makerTransferAsset(
168         TokenTrader toTokenTrader,
169         uint256 tokens
170     ) onlyOwner returns (bool ok) {
171         if (owner != toTokenTrader.owner() || asset != toTokenTrader.asset()) {
172             throw;
173         }
174         MakerTransferredAsset(toTokenTrader, tokens);
175         return ERC20(asset).transfer(toTokenTrader, tokens);
176     }
177 
178     // Maker can withdraw any ERC20 asset tokens from this contract
179     //
180     // This method is included in the case where this contract receives
181     // the wrong tokens
182     //
183     // The MakerWithdrewERC20Token() event is logged with the following
184     // parameter:
185     //   tokenAddress  is the address of the tokens withdrawn by the maker
186     //   tokens        is the number of tokens withdrawn by the maker
187     //
188     // This method was called withdrawToken() in the old version
189     //
190     function makerWithdrawERC20Token(
191         address tokenAddress,
192         uint256 tokens
193     ) onlyOwner returns (bool ok) {
194         MakerWithdrewERC20Token(tokenAddress, tokens);
195         return ERC20(tokenAddress).transfer(owner, tokens);
196     }
197 
198     // Maker can withdraw ethers from this contract
199     //
200     // The MakerWithdrewEther() event is logged with the following parameter
201     //   ethers  is the number of ethers withdrawn by the maker
202     //
203     // This method was called withdraw() in the old version
204     //
205     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {
206         if (this.balance >= ethers) {
207             MakerWithdrewEther(ethers);
208             return owner.send(ethers);
209         }
210     }
211 
212     // Maker can transfer ethers from this contract to another TokenTrader
213     // contract, with the following parameters:
214     //   toTokenTrader  Another TokenTrader contract owned by the
215     //                  same owner and with the same asset
216     //   ethers         is the number of ethers to be moved
217     //
218     // The MakerTransferredEther() event is logged with the following parameter
219     //   toTokenTrader  The other TokenTrader contract owned by the
220     //                  same owner and with the same asset
221     //   ethers         is the number of ethers transferred
222     //
223     // The MakerDepositedEther() event is logged on the other
224     // contract with the following parameter:
225     //   ethers  is the number of ethers deposited by the maker
226     //
227     function makerTransferEther(
228         TokenTrader toTokenTrader,
229         uint256 ethers
230     ) onlyOwner returns (bool ok) {
231         if (owner != toTokenTrader.owner() || asset != toTokenTrader.asset()) {
232             throw;
233         }
234         if (this.balance >= ethers) {
235             MakerTransferredEther(toTokenTrader, ethers);
236             toTokenTrader.makerDepositEther.value(ethers)();
237         }
238     }
239 
240     // Taker buys asset tokens by sending ethers
241     //
242     // The TakerBoughtAsset() event is logged with the following parameters
243     //   buyer           is the buyer's address
244     //   ethersSent      is the number of ethers sent by the buyer
245     //   ethersReturned  is the number of ethers sent back to the buyer as
246     //                   change
247     //   tokensBought    is the number of asset tokens sent to the buyer
248     //
249     // This method was called buy() in the old version
250     //
251     function takerBuyAsset() payable {
252         if (sellsTokens || msg.sender == owner) {
253             // Note that sellPrice has already been validated as > 0
254             uint order    = msg.value / sellPrice;
255             // Note that units has already been validated as > 0
256             uint can_sell = ERC20(asset).balanceOf(address(this)) / units;
257             uint256 change = 0;
258             if (order > can_sell) {
259                 change = msg.value - (can_sell * sellPrice);
260                 order = can_sell;
261                 if (!msg.sender.send(change)) throw;
262             }
263             if (order > 0) {
264                 if(!ERC20(asset).transfer(msg.sender, order * units)) throw;
265             }
266             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
267         }
268         // Return user funds if the contract is not selling
269         else if (!msg.sender.send(msg.value)) throw;
270     }
271 
272     // Taker sells asset tokens for ethers by:
273     // 1. Calling the asset's approve() method with the following parameters
274     //    _spender            is the address of this contract
275     //    _value              is the number of tokens to be sold
276     // 2. Calling this takerSellAsset() method with the following parameter
277     //    etherValueOfTokens  is the ether value of the asset tokens to be sold
278     //                        by the taker
279     //
280     // The TakerSoldAsset() event is logged with the following parameters
281     //   seller                    is the seller's address
282     //   etherValueOfTokensToSell  is the ether value of the asset tokens being
283     //                             sold by the taker
284     //   tokensSold                is the number of the asset tokens sold
285     //   etherValueOfTokensSold    is the ether value of the asset tokens sold
286     //
287     // This method was called sell() in the old version
288     //
289     function takerSellAsset(uint256 etherValueOfTokensToSell) {
290         if (buysTokens || msg.sender == owner) {
291             // Maximum number of token the contract can buy
292             // Note that buyPrice has already been validated as > 0
293             uint256 can_buy = this.balance / buyPrice;
294             // Token lots available
295             // Note that units has already been validated as > 0
296             uint256 order = etherValueOfTokensToSell / units;
297             // Adjust order for funds available
298             if (order > can_buy) order = can_buy;
299             if (order > 0) {
300                 // Extract user tokens
301                 if(!ERC20(asset).transferFrom(msg.sender, address(this), order * units)) throw;
302                 // Pay user
303                 if(!msg.sender.send(order * buyPrice)) throw;
304             }
305             TakerSoldAsset(msg.sender, etherValueOfTokensToSell, order * units, order * buyPrice);
306         }
307     }
308 
309     // Taker buys tokens by sending ethers
310     function () payable {
311         takerBuyAsset();
312     }
313 }
314 
315 // This contract deploys TokenTrader contracts and logs the event
316 contract TokenTraderFactory is Owned {
317 
318     event TradeListing(address indexed ownerAddress, address indexed tokenTraderAddress,
319         address indexed asset, uint256 buyPrice, uint256 sellPrice, uint256 units,
320         bool buysTokens, bool sellsTokens);
321     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
322 
323     mapping(address => bool) _verify;
324 
325     // Anyone can call this method to verify the settings of a
326     // TokenTrader contract. The parameters are:
327     //   tradeContract  is the address of a TokenTrader contract
328     //
329     // Return values:
330     //   valid        did this TokenTraderFactory create the TokenTrader contract?
331     //   owner        is the owner of the TokenTrader contract
332     //   asset        is the ERC20 asset address
333     //   buyPrice     is the buy price in ethers per `units` of asset tokens
334     //   sellPrice    is the sell price in ethers per `units` of asset tokens
335     //   units        is the number of units of asset tokens
336     //   buysTokens   is the TokenTrader contract buying tokens?
337     //   sellsTokens  is the TokenTrader contract selling tokens?
338     //
339     function verify(address tradeContract) constant returns (
340         bool    valid,
341         address owner,
342         address asset,
343         uint256 buyPrice,
344         uint256 sellPrice,
345         uint256 units,
346         bool    buysTokens,
347         bool    sellsTokens
348     ) {
349         valid = _verify[tradeContract];
350         if (valid) {
351             TokenTrader t = TokenTrader(tradeContract);
352             owner         = t.owner();
353             asset         = t.asset();
354             buyPrice      = t.buyPrice();
355             sellPrice     = t.sellPrice();
356             units         = t.units();
357             buysTokens    = t.buysTokens();
358             sellsTokens   = t.sellsTokens();
359         }
360     }
361 
362     // Maker can call this method to create a new TokenTrader contract
363     // with the maker being the owner of this new contract
364     //
365     // Parameters:
366     //   asset        is the ERC20 asset address
367     //   buyPrice     is the buy price in ethers per `units` of asset tokens
368     //   sellPrice    is the sell price in ethers per `units` of asset tokens
369     //   units        is the number of units of asset tokens
370     //   buysTokens   is the TokenTrader contract buying tokens?
371     //   sellsTokens  is the TokenTrader contract selling tokens?
372     //
373     // For example, listing a TokenTrader contract on the REP Augur token where
374     // the contract will buy REP tokens at a rate of 39000/100000 = 0.39 ETH
375     // per REP token and sell REP tokens at a rate of 41000/100000 = 0.41 ETH
376     // per REP token:
377     //   asset        0x48c80f1f4d53d5951e5d5438b54cba84f29f32a5
378     //   buyPrice     39000
379     //   sellPrice    41000
380     //   units        100000
381     //   buysTokens   true
382     //   sellsTokens  true
383     //
384     // The TradeListing() event is logged with the following parameters
385     //   ownerAddress        is the Maker's address
386     //   tokenTraderAddress  is the address of the newly created TokenTrader contract
387     //   asset               is the ERC20 asset address
388     //   buyPrice            is the buy price in ethers per `units` of asset tokens
389     //   sellPrice           is the sell price in ethers per `units` of asset tokens
390     //   unit                is the number of units of asset tokens
391     //   buysTokens          is the TokenTrader contract buying tokens?
392     //   sellsTokens         is the TokenTrader contract selling tokens?
393     //
394     function createTradeContract(
395         address asset,
396         uint256 buyPrice,
397         uint256 sellPrice,
398         uint256 units,
399         bool    buysTokens,
400         bool    sellsTokens
401     ) returns (address trader) {
402         // Cannot have invalid asset
403         if (asset == 0x0) throw;
404         // Cannot set zero or negative price
405         if (buyPrice <= 0 || sellPrice <= 0) throw;
406         // Must make profit on spread
407         if (buyPrice >= sellPrice) throw;
408         // Cannot buy or sell zero or negative units
409         if (units <= 0) throw;
410         trader = new TokenTrader(
411             asset,
412             buyPrice,
413             sellPrice,
414             units,
415             buysTokens,
416             sellsTokens);
417         // Record that this factory created the trader
418         _verify[trader] = true;
419         // Set the owner to whoever called the function
420         TokenTrader(trader).transferOwnership(msg.sender);
421         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, units, buysTokens, sellsTokens);
422     }
423 
424     // Factory owner can withdraw any ERC20 asset tokens from this contract
425     //
426     // This method is included in the case where this contract receives
427     // the wrong tokens
428     //
429     // The OwnerWithdrewERC20Token() event is logged with the following
430     // parameter:
431     //   tokenAddress  is the address of the tokens withdrawn by the maker
432     //   tokens        is the number of tokens withdrawn by the maker
433     //
434     function ownerWithdrawERC20Token(address tokenAddress, uint256 tokens) onlyOwner returns (bool ok) {
435         OwnerWithdrewERC20Token(tokenAddress, tokens);
436         return ERC20(tokenAddress).transfer(owner, tokens);
437     }
438 
439     // Prevents accidental sending of ether to the factory
440     function () {
441         throw;
442     }
443 }