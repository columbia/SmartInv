1 pragma solidity ^0.4.8;
2 
3 // https://github.com/ethereum/EIPs/issues/20
4 contract ERC20 {
5     function totalSupply() constant returns (uint totalSupply);
6     function balanceOf(address _owner) constant returns (uint balance);
7     function transfer(address _to, uint _value) returns (bool success);
8     function transferFrom(address _from, address _to, uint _value) returns (bool success);
9     function approve(address _spender, uint _value) returns (bool success);
10     function allowance(address _owner, address _spender) constant returns (uint remaining);
11     function decimals() constant returns(uint digits);
12     event Transfer(address indexed _from, address indexed _to, uint _value);
13     event Approval(address indexed _owner, address indexed _spender, uint _value);
14 }
15 
16 /// @title Kyber Reserve contract
17 /// @author Yaron Velner
18 
19 contract KyberReserve {
20     address public reserveOwner;
21     address public kyberNetwork;
22     ERC20 constant public ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
23     uint  constant PRECISION = (10**18);
24     bool public tradeEnabled;
25 
26     struct ConversionRate {
27         uint rate;
28         uint expirationBlock;
29     }
30 
31     mapping(bytes32=>ConversionRate) pairConversionRate;
32 
33     /// @dev c'tor.
34     /// @param _kyberNetwork The address of kyber network
35     /// @param _reserveOwner Address of the reserve owner
36     function KyberReserve( address _kyberNetwork, address _reserveOwner ) {
37         kyberNetwork = _kyberNetwork;
38         reserveOwner = _reserveOwner;
39         tradeEnabled = true;
40     }
41 
42 
43     /// @dev check if a pair is listed for trading.
44     /// @param source Source token
45     /// @param dest Destination token
46     /// @param blockNumber Current block number
47     /// @return true iff pair is listed
48     function isPairListed( ERC20 source, ERC20 dest, uint blockNumber ) internal constant returns(bool) {
49         ConversionRate memory rateInfo = pairConversionRate[sha3(source,dest)];
50         if( rateInfo.rate == 0 ) return false;
51         return rateInfo.expirationBlock >= blockNumber;
52     }
53 
54     /// @dev get current conversion rate
55     /// @param source Source token
56     /// @param dest Destination token
57     /// @param blockNumber Current block number
58     /// @return conversion rate with PRECISION precision
59 
60     function getConversionRate( ERC20 source, ERC20 dest, uint blockNumber ) internal constant returns(uint) {
61         ConversionRate memory rateInfo = pairConversionRate[sha3(source,dest)];
62         if( rateInfo.rate == 0 ) return 0;
63         if( rateInfo.expirationBlock < blockNumber ) return 0;
64         return rateInfo.rate * (10 ** getDecimals(dest)) / (10**getDecimals(source));
65     }
66 
67     event ErrorReport( address indexed origin, uint error, uint errorInfo );
68     event DoTrade( address indexed origin, address source, uint sourceAmount, address destToken, uint destAmount, address destAddress );
69 
70     function getDecimals( ERC20 token ) constant returns(uint) {
71       if( token == ETH_TOKEN_ADDRESS ) return 18;
72       return token.decimals();
73     }
74 
75     /// @dev do a trade
76     /// @param sourceToken Source token
77     /// @param sourceAmount Amount of source token
78     /// @param destToken Destination token
79     /// @param destAddress Destination address to send tokens to
80     /// @param validate If true, additional validations are applicable
81     /// @return true iff trade is succesful
82     function doTrade( ERC20 sourceToken,
83                       uint sourceAmount,
84                       ERC20 destToken,
85                       address destAddress,
86                       bool validate ) internal returns(bool) {
87 
88         // can skip validation if done at kyber network level
89         if( validate ) {
90             if( ! isPairListed( sourceToken, destToken, block.number ) ) {
91                 // pair is not listed
92                 ErrorReport( tx.origin, 0x800000001, 0 );
93                 return false;
94 
95             }
96             if( sourceToken == ETH_TOKEN_ADDRESS ) {
97                 if( msg.value != sourceAmount ) {
98                     // msg.value != sourceAmmount
99                     ErrorReport( tx.origin, 0x800000002, msg.value );
100                     return false;
101                 }
102             }
103             else if( msg.value > 0 ) {
104                 // msg.value must be 0
105                 ErrorReport( tx.origin, 0x800000003, msg.value );
106                 return false;
107             }
108             else if( sourceToken.allowance(msg.sender, this ) < sourceAmount ) {
109                 // allowance is not enough
110                 ErrorReport( tx.origin, 0x800000004, sourceToken.allowance(msg.sender, this ) );
111                 return false;
112             }
113         }
114 
115         uint conversionRate = getConversionRate( sourceToken, destToken, block.number );
116         // TODO - safe multiplication
117         uint destAmount = (conversionRate * sourceAmount) / PRECISION;
118 
119         // sanity check
120         if( destAmount == 0 ) {
121             // unexpected error: dest amount is 0
122             ErrorReport( tx.origin, 0x800000005, 0 );
123             return false;
124         }
125 
126         // check for sufficient balance
127         if( destToken == ETH_TOKEN_ADDRESS ) {
128             if( this.balance < destAmount ) {
129                 // insufficient ether balance
130                 ErrorReport( tx.origin, 0x800000006, destAmount );
131                 return false;
132             }
133         }
134         else {
135             if( destToken.balanceOf(this) < destAmount ) {
136                 // insufficient token balance
137                 ErrorReport( tx.origin, 0x800000007, uint(destToken) );
138                 return false;
139             }
140         }
141 
142         // collect source tokens
143         if( sourceToken != ETH_TOKEN_ADDRESS ) {
144             if( ! sourceToken.transferFrom(msg.sender,this,sourceAmount) ) {
145                 // transfer from source token failed
146                 ErrorReport( tx.origin, 0x800000008, uint(sourceToken) );
147                 return false;
148             }
149         }
150 
151         // send dest tokens
152         if( destToken == ETH_TOKEN_ADDRESS ) {
153             if( ! destAddress.send(destAmount) ) {
154                 // transfer ether to dest failed
155                 ErrorReport( tx.origin, 0x800000009, uint(destAddress) );
156                 return false;
157             }
158         }
159         else {
160             if( ! destToken.transfer(destAddress, destAmount) ) {
161                 // transfer token to dest failed
162                 ErrorReport( tx.origin, 0x80000000a, uint(destAddress) );
163                 return false;
164             }
165         }
166 
167         DoTrade( tx.origin, sourceToken, sourceAmount, destToken, destAmount, destAddress );
168 
169         return true;
170     }
171 
172     /// @dev trade
173     /// @param sourceToken Source token
174     /// @param sourceAmount Amount of source token
175     /// @param destToken Destination token
176     /// @param destAddress Destination address to send tokens to
177     /// @param validate If true, additional validations are applicable
178     /// @return true iff trade is succesful
179     function trade( ERC20 sourceToken,
180                     uint sourceAmount,
181                     ERC20 destToken,
182                     address destAddress,
183                     bool validate ) payable returns(bool) {
184 
185         if( ! tradeEnabled ) {
186             // trade is not enabled
187             ErrorReport( tx.origin, 0x810000000, 0 );
188             if( msg.value > 0 ) {
189                 if( ! msg.sender.send(msg.value) ) throw;
190             }
191             return false;
192         }
193 
194         if( msg.sender != kyberNetwork ) {
195             // sender must be kyber network
196             ErrorReport( tx.origin, 0x810000001, uint(msg.sender) );
197             if( msg.value > 0 ) {
198                 if( ! msg.sender.send(msg.value) ) throw;
199             }
200 
201             return false;
202         }
203 
204         if( ! doTrade( sourceToken, sourceAmount, destToken, destAddress, validate ) ) {
205             // do trade failed
206             ErrorReport( tx.origin, 0x810000002, 0 );
207             if( msg.value > 0 ) {
208                 if( ! msg.sender.send(msg.value) ) throw;
209             }
210             return false;
211         }
212 
213         ErrorReport( tx.origin, 0, 0 );
214         return true;
215     }
216 
217     event SetRate( ERC20 source, ERC20 dest, uint rate, uint expiryBlock );
218 
219     /// @notice can be called only by owner
220     /// @dev set rate of pair of tokens
221     /// @param sources an array contain source tokens
222     /// @param dests an array contain dest tokens
223     /// @param conversionRates an array with rates
224     /// @param expiryBlocks array of expiration blocks
225     /// @param validate If true, additional validations are applicable
226     /// @return true iff trade is succesful
227     function setRate( ERC20[] sources, ERC20[] dests, uint[] conversionRates, uint[] expiryBlocks, bool validate ) returns(bool) {
228         if( msg.sender != reserveOwner ) {
229             // sender must be reserve owner
230             ErrorReport( tx.origin, 0x820000000, uint(msg.sender) );
231             return false;
232         }
233 
234         if( validate ) {
235             if( ( sources.length != dests.length ) ||
236                 ( sources.length != conversionRates.length ) ||
237                 ( sources.length != expiryBlocks.length ) ) {
238                 // arrays length are not identical
239                 ErrorReport( tx.origin, 0x820000001, 0 );
240                 return false;
241             }
242         }
243 
244         for( uint i = 0 ; i < sources.length ; i++ ) {
245             SetRate( sources[i], dests[i], conversionRates[i], expiryBlocks[i] );
246             pairConversionRate[sha3(sources[i],dests[i])] = ConversionRate( conversionRates[i], expiryBlocks[i] );
247         }
248 
249         ErrorReport( tx.origin, 0, 0 );
250         return true;
251     }
252 
253     event EnableTrade( bool enable );
254 
255     /// @notice can be called only by owner
256     /// @dev enable of disable trade
257     /// @param enable if true trade is enabled, otherwise disabled
258     /// @return true iff trade is succesful
259     function enableTrade( bool enable ) returns(bool){
260         if( msg.sender != reserveOwner ) {
261             // sender must be reserve owner
262             ErrorReport( tx.origin, 0x830000000, uint(msg.sender) );
263             return false;
264         }
265 
266         tradeEnabled = enable;
267         ErrorReport( tx.origin, 0, 0 );
268         EnableTrade( enable );
269 
270         return true;
271     }
272 
273     event DepositToken( ERC20 token, uint amount );
274     function() payable {
275         DepositToken( ETH_TOKEN_ADDRESS, msg.value );
276     }
277 
278     /// @notice ether could also be deposited without calling this function
279     /// @dev an auxilary function that allows ether deposits
280     /// @return true iff deposit is succesful
281     function depositEther( ) payable returns(bool) {
282         ErrorReport( tx.origin, 0, 0 );
283 
284         DepositToken( ETH_TOKEN_ADDRESS, msg.value );
285         return true;
286     }
287 
288     /// @notice tokens could also be deposited without calling this function
289     /// @dev an auxilary function that allows token deposits
290     /// @param token Token address
291     /// @param amount Amount of tokens to deposit
292     /// @return true iff deposit is succesful
293     function depositToken( ERC20 token, uint amount ) returns(bool) {
294         if( token.allowance( msg.sender, this ) < amount ) {
295             // allowence is smaller then amount
296             ErrorReport( tx.origin, 0x850000001, token.allowance( msg.sender, this ) );
297             return false;
298         }
299 
300         if( ! token.transferFrom(msg.sender, this, amount ) ) {
301             // transfer from failed
302             ErrorReport( tx.origin, 0x850000002, uint(token) );
303             return false;
304         }
305 
306         DepositToken( token, amount );
307         return true;
308     }
309 
310 
311     event Withdraw( ERC20 token, uint amount, address destination );
312 
313     /// @notice can only be called by owner.
314     /// @dev withdaw tokens or ether from contract
315     /// @param token Token address
316     /// @param amount Amount of tokens to deposit
317     /// @param destination address that get withdrewed funds
318     /// @return true iff withdrawal is succesful
319     function withdraw( ERC20 token, uint amount, address destination ) returns(bool) {
320         if( msg.sender != reserveOwner ) {
321             // sender must be reserve owner
322             ErrorReport( tx.origin, 0x860000000, uint(msg.sender) );
323             return false;
324         }
325 
326         if( token == ETH_TOKEN_ADDRESS ) {
327             if( ! destination.send(amount) ) throw;
328         }
329         else if( ! token.transfer(destination,amount) ) {
330             // transfer to reserve owner failed
331             ErrorReport( tx.origin, 0x860000001, uint(token) );
332             return false;
333         }
334 
335         ErrorReport( tx.origin, 0, 0 );
336         Withdraw( token, amount, destination );
337     }
338 
339     function changeOwner( address newOwner ) {
340       if( msg.sender != reserveOwner ) throw;
341       reserveOwner = newOwner;
342     }
343 
344     ////////////////////////////////////////////////////////////////////////////
345     /// status functions ///////////////////////////////////////////////////////
346     ////////////////////////////////////////////////////////////////////////////
347 
348     /// @notice use token address ETH_TOKEN_ADDRESS for ether
349     /// @dev information on conversion rate from source to dest
350     /// @param source Source token
351     /// @param dest   Destinatoin token
352     /// @return (conversion rate,experation block,dest token balance of reserve)
353     function getPairInfo( ERC20 source, ERC20 dest ) constant returns(uint rate, uint expBlock, uint balance) {
354         ConversionRate memory rateInfo = pairConversionRate[sha3(source,dest)];
355         balance = 0;
356         if( dest == ETH_TOKEN_ADDRESS ) balance = this.balance;
357         else balance = dest.balanceOf(this);
358 
359         expBlock = rateInfo.expirationBlock;
360         rate = rateInfo.rate;
361     }
362 
363     /// @notice a debug function
364     /// @dev get the balance of the reserve
365     /// @param token The token type
366     /// @return The balance
367     function getBalance( ERC20 token ) constant returns(uint){
368         if( token == ETH_TOKEN_ADDRESS ) return this.balance;
369         else return token.balanceOf(this);
370     }
371 }