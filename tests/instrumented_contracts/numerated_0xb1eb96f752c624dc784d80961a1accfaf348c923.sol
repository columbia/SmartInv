1 pragma solidity ^0.4.4;
2 
3 // ------------------------------------------------------------------------
4 // TokenSellerFactory
5 //
6 // Decentralised trustless ERC20-partially-compliant token to ETH exchange
7 // contract on the Ethereum blockchain.
8 //
9 // This caters for the Golem Network Token which does not implement the
10 // ERC20 transferFrom(...), approve(...) and allowance(...) methods
11 //
12 // History:
13 //   Jan 25 2017 - BPB Added makerTransferAsset(...)
14 //   Feb 05 2017 - BPB Bug fix in the change calculation for the Unicorn
15 //                     token with natural number 1
16 //
17 // Enjoy. (c) JonnyLatte, Cintix & BokkyPooBah 2017. The MIT licence.
18 // ------------------------------------------------------------------------
19 
20 // https://github.com/ethereum/EIPs/issues/20
21 contract ERC20Partial {
22     function totalSupply() constant returns (uint totalSupply);
23     function balanceOf(address _owner) constant returns (uint balance);
24     function transfer(address _to, uint _value) returns (bool success);
25     // function transferFrom(address _from, address _to, uint _value) returns (bool success);
26     // function approve(address _spender, uint _value) returns (bool success);
27     // function allowance(address _owner, address _spender) constant returns (uint remaining);
28     event Transfer(address indexed _from, address indexed _to, uint _value);
29     // event Approval(address indexed _owner, address indexed _spender, uint _value);
30 }
31 
32 contract Owned {
33     address public owner;
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     function Owned() {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         if (msg.sender != owner) throw;
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner {
46         OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 }
50 
51 // contract can sell tokens for ETH
52 // prices are in amount of wei per batch of token units
53 
54 contract TokenSeller is Owned {
55 
56     address public asset;       // address of token
57     uint256 public sellPrice;   // contract sells lots of tokens at this price
58     uint256 public units;       // lot size (token-wei)
59 
60     bool public sellsTokens;    // is contract selling
61 
62     event ActivatedEvent(bool sells);
63     event MakerWithdrewAsset(uint256 tokens);
64     event MakerTransferredAsset(address toTokenSeller, uint256 tokens);
65     event MakerWithdrewERC20Token(address tokenAddress, uint256 tokens);
66     event MakerWithdrewEther(uint256 ethers);
67     event TakerBoughtAsset(address indexed buyer, uint256 ethersSent,
68         uint256 ethersReturned, uint256 tokensBought);
69 
70     // Constructor - only to be called by the TokenSellerFactory contract
71     function TokenSeller (
72         address _asset,
73         uint256 _sellPrice,
74         uint256 _units,
75         bool    _sellsTokens
76     ) {
77         asset       = _asset;
78         sellPrice   = _sellPrice;
79         units       = _units;
80         sellsTokens = _sellsTokens;
81         ActivatedEvent(sellsTokens);
82     }
83 
84     // Maker can activate or deactivate this contract's
85     // selling status
86     //
87     // The ActivatedEvent() event is logged with the following
88     // parameter:
89     //   sellsTokens  this contract can sell asset tokens
90     function activate (
91         bool _sellsTokens
92     ) onlyOwner {
93         sellsTokens = _sellsTokens;
94         ActivatedEvent(sellsTokens);
95     }
96 
97     // Maker can withdraw asset tokens from this contract, with the
98     // following parameter:
99     //   tokens  is the number of asset tokens to be withdrawn
100     //
101     // The MakerWithdrewAsset() event is logged with the following
102     // parameter:
103     //   tokens  is the number of tokens withdrawn by the maker
104     //
105     // This method was called withdrawAsset() in the old version
106     function makerWithdrawAsset(uint256 tokens) onlyOwner returns (bool ok) {
107         MakerWithdrewAsset(tokens);
108         return ERC20Partial(asset).transfer(owner, tokens);
109     }
110 
111     // Maker can transfer asset tokens from this contract to another
112     // TokenSeller contract, with the following parameter:
113     //   toTokenSeller  Another TokenSeller contract owned by the
114     //                  same owner
115     //   tokens         is the number of asset tokens to be moved
116     //
117     // The MakerTransferredAsset() event is logged with the following
118     // parameters:
119     //   toTokenSeller  The other TokenSeller contract owned by
120     //                  the same owner
121     //   tokens         is the number of tokens transferred
122     //
123     // The asset Transfer() event is logged from this contract to
124     // the other contract
125     //
126     function makerTransferAsset(
127         TokenSeller toTokenSeller,
128         uint256 tokens
129     ) onlyOwner returns (bool ok) {
130         if (owner != toTokenSeller.owner() || asset != toTokenSeller.asset()) {
131             throw;
132         }
133         MakerTransferredAsset(toTokenSeller, tokens);
134         return ERC20Partial(asset).transfer(toTokenSeller, tokens);
135     }
136 
137     // Maker can withdraw any ERC20 asset tokens from this contract
138     //
139     // This method is included in the case where this contract receives
140     // the wrong tokens
141     //
142     // The MakerWithdrewERC20Token() event is logged with the following
143     // parameter:
144     //   tokenAddress  is the address of the tokens withdrawn by the maker
145     //   tokens        is the number of tokens withdrawn by the maker
146     //
147     // This method was called withdrawToken() in the old version
148     function makerWithdrawERC20Token(
149         address tokenAddress,
150         uint256 tokens
151     ) onlyOwner returns (bool ok) {
152         MakerWithdrewERC20Token(tokenAddress, tokens);
153         return ERC20Partial(tokenAddress).transfer(owner, tokens);
154     }
155 
156     // Maker withdraws ethers from this contract
157     //
158     // The MakerWithdrewEther() event is logged with the following parameter
159     //   ethers  is the number of ethers withdrawn by the maker
160     //
161     // This method was called withdraw() in the old version
162     function makerWithdrawEther(uint256 ethers) onlyOwner returns (bool ok) {
163         if (this.balance >= ethers) {
164             MakerWithdrewEther(ethers);
165             return owner.send(ethers);
166         }
167     }
168 
169     // Taker buys asset tokens by sending ethers
170     //
171     // The TakerBoughtAsset() event is logged with the following parameters
172     //   buyer           is the buyer's address
173     //   ethersSent      is the number of ethers sent by the buyer
174     //   ethersReturned  is the number of ethers sent back to the buyer as
175     //                   change
176     //   tokensBought    is the number of asset tokens sent to the buyer
177     //
178     // This method was called buy() in the old version
179     function takerBuyAsset() payable {
180         if (sellsTokens || msg.sender == owner) {
181             // Note that sellPrice has already been validated as > 0
182             uint order    = msg.value / sellPrice;
183             // Note that units has already been validated as > 0
184             uint can_sell = ERC20Partial(asset).balanceOf(address(this)) / units;
185             uint256 change = 0;
186             if (msg.value > (can_sell * sellPrice)) {
187                 change  = msg.value - (can_sell * sellPrice);
188                 order = can_sell;
189             }
190             if (change > 0) {
191                 if (!msg.sender.send(change)) throw;
192             }
193             if (order > 0) {
194                 if (!ERC20Partial(asset).transfer(msg.sender, order * units)) throw;
195             }
196             TakerBoughtAsset(msg.sender, msg.value, change, order * units);
197         }
198         // Return user funds if the contract is not selling
199         else if (!msg.sender.send(msg.value)) throw;
200     }
201 
202     // Taker buys tokens by sending ethers
203     function () payable {
204         takerBuyAsset();
205     }
206 }
207 
208 // This contract deploys TokenSeller contracts and logs the event
209 contract TokenSellerFactory is Owned {
210 
211     event TradeListing(address indexed ownerAddress, address indexed tokenSellerAddress,
212         address indexed asset, uint256 sellPrice, uint256 units, bool sellsTokens);
213     event OwnerWithdrewERC20Token(address indexed tokenAddress, uint256 tokens);
214 
215     mapping(address => bool) _verify;
216 
217     // Anyone can call this method to verify the settings of a
218     // TokenSeller contract. The parameters are:
219     //   tradeContract  is the address of a TokenSeller contract
220     //
221     // Return values:
222     //   valid        did this TokenTraderFactory create the TokenTrader contract?
223     //   owner        is the owner of the TokenTrader contract
224     //   asset        is the ERC20 asset address
225     //   sellPrice    is the sell price in ethers per `units` of asset tokens
226     //   units        is the number of units of asset tokens
227     //   sellsTokens  is the TokenTrader contract selling tokens?
228     //
229     function verify(address tradeContract) constant returns (
230         bool    valid,
231         address owner,
232         address asset,
233         uint256 sellPrice,
234         uint256 units,
235         bool    sellsTokens
236     ) {
237         valid = _verify[tradeContract];
238         if (valid) {
239             TokenSeller t = TokenSeller(tradeContract);
240             owner         = t.owner();
241             asset         = t.asset();
242             sellPrice     = t.sellPrice();
243             units         = t.units();
244             sellsTokens   = t.sellsTokens();
245         }
246     }
247 
248     // Maker can call this method to create a new TokenSeller contract
249     // with the maker being the owner of this new contract
250     //
251     // Parameters:
252     //   asset        is the ERC20 asset address
253     //   sellPrice    is the sell price in ethers per `units` of asset tokens
254     //   units        is the number of units of asset tokens
255     //   sellsTokens  is the TokenSeller contract selling tokens?
256     //
257     // For example, listing a TokenSeller contract on the GNT Golem Network Token
258     // where the contract will sell GNT tokens at a rate of 170/100000 = 0.0017 ETH
259     // per GNT token:
260     //   asset        0xa74476443119a942de498590fe1f2454d7d4ac0d
261     //   sellPrice    170
262     //   units        100000
263     //   sellsTokens  true
264     //
265     // The TradeListing() event is logged with the following parameters
266     //   ownerAddress        is the Maker's address
267     //   tokenSellerAddress  is the address of the newly created TokenSeller contract
268     //   asset               is the ERC20 asset address
269     //   sellPrice           is the sell price in ethers per `units` of asset tokens
270     //   unit                is the number of units of asset tokens
271     //   sellsTokens         is the TokenSeller contract selling tokens?
272     //
273     // This method was called createTradeContract() in the old version
274     //
275     function createSaleContract(
276         address asset,
277         uint256 sellPrice,
278         uint256 units,
279         bool    sellsTokens
280     ) returns (address seller) {
281         // Cannot have invalid asset
282         if (asset == 0x0) throw;
283         // Cannot set zero or negative price
284         if (sellPrice <= 0) throw;
285         // Cannot sell zero or negative units
286         if (units <= 0) throw;
287         seller = new TokenSeller(
288             asset,
289             sellPrice,
290             units,
291             sellsTokens);
292         // Record that this factory created the trader
293         _verify[seller] = true;
294         // Set the owner to whoever called the function
295         TokenSeller(seller).transferOwnership(msg.sender);
296         TradeListing(msg.sender, seller, asset, sellPrice, units, sellsTokens);
297     }
298 
299     // Factory owner can withdraw any ERC20 asset tokens from this contract
300     //
301     // This method is included in the case where this contract receives
302     // the wrong tokens
303     //
304     // The OwnerWithdrewERC20Token() event is logged with the following
305     // parameter:
306     //   tokenAddress  is the address of the tokens withdrawn by the maker
307     //   tokens        is the number of tokens withdrawn by the maker
308     function ownerWithdrawERC20Token(address tokenAddress, uint256 tokens) onlyOwner returns (bool ok) {
309         OwnerWithdrewERC20Token(tokenAddress, tokens);
310         return ERC20Partial(tokenAddress).transfer(owner, tokens);
311     }
312 
313     // Prevents accidental sending of ether to the factory
314     function () {
315         throw;
316     }
317 }