1 pragma solidity ^0.5.2;
2 
3 
4 /**
5  *  URA Mraket contract
6  *  web site: ura.market
7  *
8  *  URA.market  is a decentralized trade and investment platform, created by Ethereum net.
9  *
10  *  URA.market is controlled without human participation,
11  *  and by automated smart contracts with refusal from ownership activated function.
12  *
13  * Gas limit: 150 000 (only the first time, average ~ 50 000)
14  * Gas price: https://ethgasstation.info/
15  *
16  * github: https://github.com/bigdaddy777/URA-MARKET-COIN
17  */
18 
19 
20 library ToAddress {
21     function toAddr(uint _source) internal pure returns(address payable) {
22         return address(_source);
23     }
24 
25     function toAddr(bytes memory _source) internal pure returns(address payable addr) {
26         // solium-disable security/no-inline-assembly
27         assembly { addr := mload(add(_source,0x14)) }
28         return addr;
29     }
30 
31     function isNotContract(address addr) internal view returns(bool) {
32         // solium-disable security/no-inline-assembly
33         uint256 length;
34         assembly { length := extcodesize(addr) }
35         return length == 0;
36     }
37 }
38 
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46     /**
47     * @dev Multiplies two numbers, reverts on overflow.
48     */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b);
59 
60         return c;
61     }
62 
63     /**
64     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65     */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b > 0); // Solidity only automatically asserts when dividing by 0
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76     */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b <= a);
79         uint256 c = a - b;
80 
81         return c;
82     }
83 
84     /**
85     * @dev Adds two numbers, reverts on overflow.
86     */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90 
91         return c;
92     }
93 
94     /**
95     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96     * reverts when dividing by zero.
97     */
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b != 0);
100         return a % b;
101     }
102 }
103 
104 
105 // ----------------------------------------------------------------------------
106 // ERC Token Standard #20 Interface
107 // @wiki: https://theethereum.wiki/w/index.php/ERC20_Token_Standard
108 // ----------------------------------------------------------------------------
109 contract ERC20Interface {
110     function tokensOwner() public view returns (uint256);
111     function contracBalance() public view returns (uint256);
112     function balanceOf(address _tokenOwner) public view returns (uint256 balanceOwner);
113 
114     event Transfer(address indexed from, address indexed to, uint256 tokens);
115     event EtherTransfer(address indexed from, address indexed to, uint256 etherAmount);
116 }
117 
118 
119 // ----------------------------------------------------------------------------
120 // ERC20 Token, with the addition of symbol.
121 // ----------------------------------------------------------------------------
122 contract ERC20 is ERC20Interface {
123     using SafeMath for uint;
124     using ToAddress for *;
125 
126     string constant public symbol = "URA";
127     string constant public  name = "URA market coin";
128     uint8 constant internal decimals = 18;
129     uint256 public totalSupply;
130 
131     mapping(address => uint256) balances;
132 
133 
134     // ------------------------------------------------------------------------
135     // Get balance on contract
136     // ------------------------------------------------------------------------
137     function contracBalance() public view returns (uint256 contractBalance) {
138         contractBalance = address(this).balance;
139     }
140 
141 
142     // ------------------------------------------------------------------------
143     // Get the token balance for account `tokenOwner`
144     // ------------------------------------------------------------------------
145     function balanceOf(address _tokenOwner) public view returns (uint256 balanceOwner) {
146         return balances[_tokenOwner];
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Addon shows caller tokens.
152     // ------------------------------------------------------------------------
153     function tokensOwner() public view returns (uint256 tokens) {
154         tokens = balances[msg.sender];
155     }
156 
157 }
158 
159 
160 // ----------------------------------------------------------------------------
161 // Bookeeper contract that holds the amount of dividents in Ether.
162 // ----------------------------------------------------------------------------
163 contract Dividend is ERC20 {
164 
165     uint8 public constant dividendsCosts = 10; // Dividends 10%.
166     uint16 public constant day = 6000;
167     uint256 public dividendes; // storage for Dividends.
168 
169     mapping(address => uint256) bookKeeper;
170 
171 
172     event SendOnDividend(address indexed customerAddress, uint256 dividendesAmount);
173     event WithdrawDividendes(address indexed customerAddress, uint256 dividendesAmount);
174 
175     constructor() public {}
176 
177 
178     // ------------------------------------------------------------------------
179     // Withdraw dividendes.
180     // ------------------------------------------------------------------------
181     function withdrawDividendes() external payable returns(bool success) {
182         require(msg.sender.isNotContract(),
183                 "the contract can not hold tokens");
184 
185         uint256 _tokensOwner = balanceOf(msg.sender);
186 
187         require(_tokensOwner > 0, "cannot pass 0 value");
188         require(bookKeeper[msg.sender] > 0,
189                 "to withdraw dividends, please wait");
190 
191         uint256 _dividendesAmount = dividendesCalc(_tokensOwner);
192 
193         require(_dividendesAmount > 0, "dividendes amount > 0");
194 
195         bookKeeper[msg.sender] = block.number;
196         dividendes = dividendes.sub(_dividendesAmount);
197 
198         msg.sender.transfer(_dividendesAmount);
199 
200         emit WithdrawDividendes(msg.sender, _dividendesAmount);
201 
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Get value of dividendes.
208     // ------------------------------------------------------------------------
209     function dividendesOf(address _owner)
210         public
211         view
212         returns(uint256 dividendesAmount) {
213         uint256 _tokens = balanceOf(_owner);
214 
215         dividendesAmount = dividendesCalc(_tokens);
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Count percent of dividendes from ether.
221     // ------------------------------------------------------------------------
222     function onDividendes(uint256 _value, uint8 _dividendsCosts)
223         internal
224         pure
225         returns(uint256 forDividendes) {
226         return _value.mul(_dividendsCosts).div(100);
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Get number of dividendes in ether
232     // * @param _tokens: Amount customer tokens.
233     // * @param _dividendesPercent: Customer tokens percent in 10e18.
234     // *
235     // * @retunrs dividendesReceived: amount of dividendes in ether.
236     // ------------------------------------------------------------------------
237     function dividendesCalc(uint256 _tokensAmount)
238         internal
239         view
240         returns(uint256 dividendesReceived) {
241         if (_tokensAmount == 0) {
242             return 0;
243         }
244 
245         uint256 _tokens = _tokensAmount.mul(10e18);
246         uint256 _dividendesPercent = dividendesPercent(_tokens); // Get % from tokensOwner.
247 
248         dividendesReceived = dividendes.mul(_dividendesPercent).div(100);
249         dividendesReceived = dividendesReceived.div(10e18);
250     }
251 
252 
253     // ------------------------------------------------------------------------
254     // Get number of dividendes in percent
255     // * @param _tokens: Amount of (tokens * 10e18).
256     // * returns: tokens % in 10e18.
257     // ------------------------------------------------------------------------
258     function dividendesPercent(uint256 _tokens)
259         internal
260         view
261         returns(uint256 percent) {
262         if (_tokens == 0) {
263             return 0;
264         }
265 
266         uint256 _interest = accumulatedInterest();
267 
268         if (_interest > 100) {
269             _interest = 100;
270         }
271 
272         percent = _tokens.mul(_interest).div(totalSupply);
273     }
274 
275 
276     // ------------------------------------------------------------------------
277     // Block value when buying.
278     // ------------------------------------------------------------------------
279     function accumulatedInterest() private view returns(uint256 interest) {
280         if (bookKeeper[msg.sender] == 0) {
281             interest = 0;
282         } else {
283             interest = block.number.sub(bookKeeper[msg.sender]).div(day);
284         }
285     }
286 
287 }
288 
289 
290 // ----------------------------------------------------------------------------
291 // URA.market main contract.
292 // ----------------------------------------------------------------------------
293 contract URA is ERC20, Dividend {
294 
295     // The initial cost of the token, it can not be less. //
296     uint128 constant tokenPriceInit = 0.00000000001 ether;
297     uint128 public constant limiter = 15 ether;
298 
299     uint8 public constant advertisingCosts = 5; // 5% for transfer advertising.
300     uint8 public constant forReferralCosts = 2; // 2% for transfer to referral.
301     uint8 public constant forWithdrawCosts = 3; // 3% for the withdraw of tokens.
302 
303     // For advertising. //
304     address payable constant advertising = 0x4d332E1f9d55d9B89dc2a8457B693Beaa7b36b2e;
305 
306 
307     event WithdrawTokens(address indexed customerAddress, uint256 ethereumWithdrawn);
308     event ReverseAccess(uint256 etherAmount);
309     event ForReferral(uint256 etherAmount);
310 
311 
312     // ------------------------------------------------------------------------
313     // Constructor
314     // ------------------------------------------------------------------------
315     constructor() public { }
316 
317 
318     // ------------------------------------------------------------------------
319     // Purchase
320     // * @param _reverseAccessOfLimiter: Excess value.
321     // * @param _aTokenPrice: Price For one token.
322     // * @param _forAdvertising: Advertising victim.
323     // * @param _forDividendes: Dividend sacrifice.
324     // * @param _amountOfTokens: Ether to tokens amount.
325     // * @param _reverseAccess: Change remainder in ether.
326     // ------------------------------------------------------------------------
327     function () external payable {
328         require(msg.sender.isNotContract(),
329                 "the contract can not hold tokens");
330 
331         address payable _referralAddress = msg.data.toAddr();
332         uint256 _incomingEthereum = msg.value;
333 
334         uint256 _forReferral;
335         uint256 _reverseAccessOfLimiter;
336 
337         if (_incomingEthereum > limiter) {
338             _reverseAccessOfLimiter = _incomingEthereum.sub(limiter);
339             _incomingEthereum = limiter;
340         }
341 
342         uint256 _aTokenPrice = tokenPrice();
343         uint256 _dividendesOwner = dividendesOf(msg.sender);
344         uint256 _forAdvertising = _incomingEthereum.mul(advertisingCosts).div(100);
345         uint256 _forDividendes = onDividendes(_incomingEthereum, dividendsCosts);
346 
347         if (_referralAddress != address(0)) {
348             _forReferral = _incomingEthereum.mul(forReferralCosts).div(100);
349             _forAdvertising = _forAdvertising.sub(_forReferral);
350         }
351 
352         _incomingEthereum = _incomingEthereum.sub(
353             _forDividendes
354         ).sub(
355             _forAdvertising
356         ).sub(
357             _forReferral
358         );
359 
360         require(_incomingEthereum >= _aTokenPrice,
361                 "the amount of ether is not enough");
362 
363         (uint256 _amountOfTokens,
364          uint256 _reverseAccess) = ethereumToTokens(_incomingEthereum, _aTokenPrice);
365 
366         advertising.transfer(_forAdvertising);
367 
368         _reverseAccessOfLimiter = _reverseAccessOfLimiter.add(_reverseAccess);
369 
370         if (_reverseAccessOfLimiter > 0) {
371             // If there are leftovers, then return to customer. //
372             msg.sender.transfer(_reverseAccessOfLimiter);
373             emit ReverseAccess(_reverseAccessOfLimiter);
374         }
375         if (_forReferral > 0 && _referralAddress != address(0)) {
376             _referralAddress.transfer(_forReferral);
377             emit ForReferral(_forReferral);
378         }
379         if (_dividendesOwner > _aTokenPrice) {
380             reinvest();
381         }
382 
383         bookKeeper[msg.sender] = block.number;
384         balances[msg.sender] = balances[msg.sender].add(_amountOfTokens);
385         totalSupply = totalSupply.add(_amountOfTokens);
386         dividendes = dividendes.add(_forDividendes);
387 
388         emit EtherTransfer(msg.sender, advertising, _forAdvertising);
389         emit Transfer(address(0), msg.sender, _amountOfTokens);
390         emit SendOnDividend(msg.sender, _forDividendes);
391     }
392 
393 
394     // ------------------------------------------------------------------------
395     // Increment for token cost
396     // - Dynamic property that is responsible for
397     // - the rise and fall of the price of the token.
398     // ------------------------------------------------------------------------
399     function tokenPrice() public view returns(uint256 priceForToken) {
400         uint256 _contracBalance = contracBalance();
401 
402         if (totalSupply == 0 || _contracBalance == 0) {
403             return tokenPriceInit;
404         }
405 
406         return _contracBalance.div(totalSupply).mul(4).div(3);
407     }
408 
409 
410     // ------------------------------------------------------------------------
411     // Burning tokens function
412     // * @param _valueTokens: Amount tokens for burning.
413     // * @param _aTokenPrice: One token price.
414     // * @param _etherForTokens: Calculate the ether for burning tokens.
415     // * @param _forDividendes: Calculate the are common Dividendes.
416     // * @param _contracBalance: Get contract balance.
417     // * @param _dividendesAmount: Get the percentage of dividends burned tokens.
418     // ------------------------------------------------------------------------
419     function withdraw(uint256 _valueTokens) external payable returns(bool success) {
420         require(msg.sender.isNotContract(),
421                 "the contract can not hold tokens");
422 
423         uint256 _tokensOwner = balanceOf(msg.sender);
424 
425         require(_valueTokens > 0, "cannot pass 0 value");
426         require(_tokensOwner >= _valueTokens,
427                 "you do not have so many tokens");
428 
429         uint256 _aTokenPrice = tokenPrice();
430         uint256 _etherForTokens = tokensToEthereum(_valueTokens, _aTokenPrice);
431         uint256 _contracBalance = contracBalance();
432         uint256 _forDividendes = onDividendes(_etherForTokens, forWithdrawCosts);
433         uint256 _dividendesAmount = dividendesCalc(_tokensOwner);
434 
435         _etherForTokens = _etherForTokens.sub(_forDividendes);
436         totalSupply = totalSupply.sub(_valueTokens);
437 
438         if (_dividendesAmount > 0) {
439             dividendes = dividendes.sub(_dividendesAmount);
440             _etherForTokens = _etherForTokens.add(_dividendesAmount);
441             emit WithdrawDividendes(msg.sender, _dividendesAmount);
442         }
443         if (_tokensOwner == _valueTokens) {
444             // if the owner out of system //
445             bookKeeper[msg.sender] = 0;
446             balances[msg.sender] = 0;
447         } else {
448            bookKeeper[msg.sender] = block.number;
449            balances[msg.sender] = balances[msg.sender].sub(_valueTokens);
450         }
451         if (_etherForTokens > _contracBalance) {
452             _etherForTokens = _contracBalance;
453         }
454 
455         msg.sender.transfer(_etherForTokens);
456 
457         emit WithdrawTokens(msg.sender, _etherForTokens);
458         emit SendOnDividend(address(0), _forDividendes);
459 
460         return true;
461     }
462 
463 
464     // ------------------------------------------------------------------------
465     // Reinvest dividends into tokens
466     // ------------------------------------------------------------------------
467     function reinvest() public payable returns(bool success) {
468         require(msg.sender.isNotContract(),
469                 "the contract can not hold tokens");
470 
471         uint256 _dividendes = dividendesOf(msg.sender);
472         uint256 _aTokenPrice = tokenPrice();
473 
474         require(_dividendes >= _aTokenPrice, "not enough dividends");
475 
476         (uint256 _amountOfTokens,
477          uint256 _reverseAccess) = ethereumToTokens(_dividendes, _aTokenPrice);
478 
479         require(_amountOfTokens > 0, "tokens amount not zero");
480 
481         dividendes = dividendes.sub(_dividendes.sub(_reverseAccess));
482         balances[msg.sender] = balances[msg.sender].add(_amountOfTokens);
483         totalSupply = totalSupply.add(_amountOfTokens);
484         bookKeeper[msg.sender] = block.number;
485 
486         emit Transfer(address(0), msg.sender, _amountOfTokens);
487 
488         return true;
489     }
490 
491 
492 
493     // ------------------------------------------------------------------------
494     // ether conversion to token
495     // ------------------------------------------------------------------------
496     function ethereumToTokens(uint256 _incomingEthereum, uint256 _aTokenPrice)
497         private
498         pure
499         returns(uint256 tokensReceived, uint256 reverseAccess) {
500         require(_incomingEthereum >= _aTokenPrice,
501                 "input ether > a token price");
502 
503         tokensReceived = _incomingEthereum.div(_aTokenPrice);
504 
505         require(tokensReceived > 0, "you can not buy 0 tokens");
506 
507         reverseAccess = _incomingEthereum.sub(tokensReceived.mul(_aTokenPrice));
508     }
509 
510 
511     // ------------------------------------------------------------------------
512     // Inverse function ethereumToTokens (Token conversion to ether).
513     // ------------------------------------------------------------------------
514     function tokensToEthereum(uint256 _tokens, uint256 _aTokenPrice)
515         private
516         pure
517         returns(uint256 etherReceived) {
518         require(_tokens > 0, "0 tokens cannot be counted");
519 
520         etherReceived = _aTokenPrice.mul(_tokens);
521     }
522 
523 }