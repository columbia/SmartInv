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
41     function transferOwnership(address newOwner) onlyOwner {
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 // contract can buy or sell tokens for ETH
48 // prices are in amount of wei per batch of token units
49 
50 contract TokenTrader is Owned {
51 
52     address public asset;       // address of token
53     uint256 public buyPrice;    // contract buys lots of token at this price
54     uint256 public sellPrice;   // contract sells lots at this price
55     uint256 public units;       // lot size (token-wei)
56 
57     bool public buysTokens;     // is contract buying
58     bool public sellsTokens;    // is contract selling
59 
60     event ActivatedEvent(bool buys, bool sells);
61     event MakerDepositedEther(uint256 amount);
62     event MakerWithdrewAsset(uint256 tokens);
63     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
64     event MakerWithdrewEther(uint256 ethers);
65     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
66         uint256 ethersReturned, uint256 tokensBought);
67     event TakerSoldAsset(address indexed seller, uint256 tokensToSell,
68         uint256 tokensSold, uint256 ethers);
69 
70     // Constructor - only to be called by the TokenTraderFactory contract
71     function TokenTrader (
72         address _asset,
73         uint256 _buyPrice,
74         uint256 _sellPrice,
75         uint256 _units,
76         bool    _buysTokens,
77         bool    _sellsTokens
78     ) internal {
79         asset       = _asset;
80         buyPrice    = _buyPrice;
81         sellPrice   = _sellPrice;
82         units       = _units;
83         buysTokens  = _buysTokens;
84         sellsTokens = _sellsTokens;
85         ActivatedEvent(buysTokens, sellsTokens);
86     }
87 
88     // Maker can activate or deactivate this contract's buying and
89     // selling status
90     //
91     // The ActivatedEvent() event is logged with the following
92     // parameter:
93     //   buysTokens   this contract can buy asset tokens
94     //   sellsTokens  this contract can sell asset tokens
95     //
96     function activate (
97         bool _buysTokens,
98         bool _sellsTokens
99     ) onlyOwner {
100         buysTokens  = _buysTokens;
101         sellsTokens = _sellsTokens;
102         ActivatedEvent(buysTokens, sellsTokens);
103     }
104 
105     // Maker can deposit ethers to this contract so this contract
106     // can buy asset tokens.
107     //
108     // Maker deposits asset tokens to this contract by calling the
109     // asset's transfer() method with the following parameters
110     //   _to     is the address of THIS contract
111     //   _value  is the number of asset tokens to be transferred
112     //
113     // Taker MUST NOT send tokens directly to this contract. Takers
114     // MUST use the takerSellAsset() method to sell asset tokens
115     // to this contract
116     //
117     // The MakerDepositedEther() event is logged with the following
118     // parameter:
119     //   ethers  is the number of ethers deposited by the maker
120     //
121     // This method was called deposit() in the old version
122     //
123     function makerDepositEther() payable onlyOwner {
124         MakerDepositedEther(msg.value);
125     }
126 
127     // Maker can withdraw asset tokens from this contract, with the
128     // following parameter:
129     //   tokens  is the number of asset tokens to be withdrawn
130     //
131     // The MakerWithdrewAsset() event is logged with the following
132     // parameter:
133     //   tokens  is the number of tokens withdrawn by the maker
134     //
135     // This method was called withdrawAsset() in the old version
136     //
137     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) {
138         MakerWithdrewAsset(tokens);
139         return ERC20(asset).transfer(owner, tokens);
140     }
141 
142     // Maker can withdraw any ERC20 asset tokens from this contract
143     //
144     // This method is included in the case where this contract receives
145     // the wrong tokens
146     //
147     // The MakerWithdrewERC20Token() event is logged with the following
148     // parameter:
149     //   tokenAddress  is the address of the tokens withdrawn by the maker
150     //   tokens        is the number of tokens withdrawn by the maker
151     //
152     // This method was called withdrawToken() in the old version
153     //
154     function makerWithdrawERC20Token(
155         address tokenAddress,
156         uint256 tokens
157     ) onlyOwner returns (bool ok) {
158         MakerWithdrewERC20Token(tokenAddress, tokens);
159         return ERC20(tokenAddress).transfer(owner, tokens);
160     }
161 
162     // Maker can withdraw ethers from this contract
163     //
164     // The MakerWithdrewEther() event is logged with the following parameter
165     //   ethers  is the number of ethers withdrawn by the maker
166     //
167     // This method was called withdraw() in the old version
168     //
169     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {
170         if (this.balance >= ethers) {
171             MakerWithdrewEther(ethers);
172             return owner.send(ethers);
173         }
174     }
175 
176     // Taker buys asset tokens by sending ethers
177     //
178     // The TakerBoughtAsset() event is logged with the following parameters
179     //   buyer           is the buyer's address
180     //   ethersSent      is the number of ethers sent by the buyer
181     //   ethersReturned  is the number of ethers sent back to the buyer as
182     //                   change
183     //   tokensBought    is the number of asset tokens sent to the buyer
184     //
185     // This method was called buy() in the old version
186     //
187     function takerBuyAsset() payable {
188         if (sellsTokens || msg.sender == owner) {
189             uint order    = msg.value / sellPrice;
190             uint can_sell = ERC20(asset).balanceOf(address(this)) / units;
191             uint256 change = 0;
192             if (order > can_sell) {
193                 change = msg.value - (can_sell * sellPrice);
194                 order = can_sell;
195                 if (!msg.sender.send(change)) throw;
196             }
197             if (order > 0) {
198                 if(!ERC20(asset).transfer(msg.sender, order * units)) throw;
199             }
200             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
201         }
202         // Return user funds if the contract is not selling
203         else if (!msg.sender.send(msg.value)) throw;
204     }
205 
206     // Taker sells asset tokens for ethers by:
207     // 1. Calling the asset's approve() method with the following parameters
208     //    _spender  is the address of this contract
209     //    _value    is the number of tokens to be sold
210     // 2. Calling this takerSellAsset() method with the following parameter
211     //    tokens    is the number of asset tokens to be sold
212     //
213     // The TakerSoldAsset() event is logged with the following parameters
214     //   seller        is the seller's address
215     //   tokensToSell  is the number of asset tokens offered by the seller
216     //   tokensSold    is the number of asset tokens sold
217     //   ethers        is the number of ethers sent to the seller
218     //
219     // This method was called sell() in the old version
220     //
221     function takerSellAsset(uint256 tokens) {
222         if (buysTokens || msg.sender == owner) {
223             // Maximum number of token the contract can buy
224             uint256 can_buy = this.balance / buyPrice;
225             // Token lots available
226             uint256 order = tokens / units;
227             // Adjust order for funds available
228             if (order > can_buy) order = can_buy;
229             if (order > 0) {
230                 // Extract user tokens
231                 if(!ERC20(asset).transferFrom(msg.sender, address(this), order * units)) throw;
232                 // Pay user
233                 if(!msg.sender.send(order * buyPrice)) throw;
234             }
235             TakerSoldAsset(msg.sender, tokens, order * units, order * buyPrice);
236         }
237     }
238 
239     // Taker buys tokens by sending ethers
240     function () payable {
241         takerBuyAsset();
242     }
243 }
244 
245 // This contract deploys TokenTrader contracts and logs the event
246 contract TokenTraderFactory is Owned {
247 
248     event TradeListing(address ownerAddress, address tokenTraderAddress, address asset,
249         uint256 buyPrice, uint256 sellPrice, uint256 units,
250         bool buysTokens, bool sellsTokens);
251     event OwnerWithdrewERC20Token(address tokenAddress, uint256 tokens);
252 
253     mapping(address => bool) _verify;
254 
255     // Anyone can call this method to verify the settings of a
256     // TokenTrader contract. The parameters are:
257     //   tradeContract  is the address of a TokenTrader contract
258     //
259     // Return values:
260     //   valid        did this TokenTraderFactory create the TokenTrader contract?
261     //   owner        is the owner of the TokenTrader contract
262     //   asset        is the ERC20 asset address
263     //   buyPrice     is the buy price in ethers per `units` of asset tokens
264     //   sellPrice    is the sell price in ethers per `units` of asset tokens
265     //   units        is the number of units of asset tokens
266     //   buysTokens   is the TokenTrader contract buying tokens?
267     //   sellsTokens  is the TokenTrader contract selling tokens?
268     //
269     function verify(address tradeContract) constant returns (
270         bool    valid,
271         address owner,
272         address asset,
273         uint256 buyPrice,
274         uint256 sellPrice,
275         uint256 units,
276         bool    buysTokens,
277         bool    sellsTokens
278     ) {
279         valid = _verify[tradeContract];
280         if (valid) {
281             TokenTrader t = TokenTrader(tradeContract);
282             owner         = t.owner();
283             asset         = t.asset();
284             buyPrice      = t.buyPrice();
285             sellPrice     = t.sellPrice();
286             units         = t.units();
287             buysTokens    = t.buysTokens();
288             sellsTokens   = t.sellsTokens();
289         }
290     }
291 
292     // Maker can call this method to create a new TokenTrader contract
293     // with the maker being the owner of this new contract
294     //
295     // Parameters:
296     //   asset        is the ERC20 asset address
297     //   buyPrice     is the buy price in ethers per `units` of asset tokens
298     //   sellPrice    is the sell price in ethers per `units` of asset tokens
299     //   units        is the number of units of asset tokens
300     //   buysTokens   is the TokenTrader contract buying tokens?
301     //   sellsTokens  is the TokenTrader contract selling tokens?
302     //
303     // For example, listing a TokenTrader contract on the REP Augur token where
304     // the contract will buy REP tokens at a rate of 39000/100000 = 0.39 ETH
305     // per REP token and sell REP tokens at a rate of 41000/100000 = 0.41 ETH
306     // per REP token:
307     //   asset        0x48c80f1f4d53d5951e5d5438b54cba84f29f32a5
308     //   buyPrice     39000
309     //   sellPrice    41000
310     //   units        100000
311     //   buysTokens   true
312     //   sellsTokens  true
313     //
314     // The TradeListing() event is logged with the following parameters
315     //   ownerAddress        is the Maker's address
316     //   tokenTraderAddress  is the address of the newly created TokenTrader contract
317     //   asset               is the ERC20 asset address
318     //   buyPrice            is the buy price in ethers per `units` of asset tokens
319     //   sellPrice           is the sell price in ethers per `units` of asset tokens
320     //   unit                is the number of units of asset tokens
321     //   buysTokens          is the TokenTrader contract buying tokens?
322     //   sellsTokens         is the TokenTrader contract selling tokens?
323     //
324     function createTradeContract(
325         address asset,
326         uint256 buyPrice,
327         uint256 sellPrice,
328         uint256 units,
329         bool    buysTokens,
330         bool    sellsTokens
331     ) returns (address trader) {
332         // Cannot set negative price
333         if (buyPrice < 0 || sellPrice < 0) throw;
334         // Must make profit on spread
335         if (buyPrice > sellPrice) throw;
336         // Cannot buy or sell zero or negative units
337         if (units <= 0) throw;
338         trader = new TokenTrader(
339             asset,
340             buyPrice,
341             sellPrice,
342             units,
343             buysTokens,
344             sellsTokens);
345         // Record that this factory created the trader
346         _verify[trader] = true;
347         // Set the owner to whoever called the function
348         TokenTrader(trader).transferOwnership(msg.sender);
349         TradeListing(msg.sender, trader, asset, buyPrice, sellPrice, units, buysTokens, sellsTokens);
350     }
351 
352     // Factory owner can withdraw any ERC20 asset tokens from this contract
353     //
354     // This method is included in the case where this contract receives
355     // the wrong tokens
356     //
357     // The OwnerWithdrewERC20Token() event is logged with the following
358     // parameter:
359     //   tokenAddress  is the address of the tokens withdrawn by the maker
360     //   tokens        is the number of tokens withdrawn by the maker
361     //
362     function ownerWithdrawERC20Token(address tokenAddress, uint256 tokens) onlyOwner returns (bool ok) {
363         OwnerWithdrewERC20Token(tokenAddress, tokens);
364         return ERC20(tokenAddress).transfer(owner, tokens);
365     }
366 
367     // Prevents accidental sending of ether to the factory
368     function () {
369         throw;
370     }
371 }