1 pragma solidity 0.4.18;
2 
3 /// @title Math operations with safety checks
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         // require(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // require(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 
29     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30         return a >= b ? a : b;
31     }
32 
33     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
34         return a < b ? a : b;
35     }
36 
37     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
38         return a >= b ? a : b;
39     }
40 
41     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a < b ? a : b;
43     }
44 
45     function toPower2(uint256 a) internal pure returns (uint256) {
46         return mul(a, a);
47     }
48 
49     function sqrt(uint256 a) internal pure returns (uint256) {
50         uint256 c = (a + 1) / 2;
51         uint256 b = a;
52         while (c < b) {
53             b = c;
54             c = (a / c + c) / 2;
55         }
56         return b;
57     }
58 }
59 
60 /// @title ERC223Receiver Interface
61 /// @dev Based on the specs form: https://github.com/ethereum/EIPs/issues/223
62 contract ERC223Receiver {
63     function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok);
64 }
65 
66 
67 
68 /// @title Market Maker Interface.
69 /// @author Tal Beja.
70 contract MarketMaker is ERC223Receiver {
71 
72   function getCurrentPrice() public constant returns (uint _price);
73   function change(address _fromToken, uint _amount, address _toToken) public returns (uint _returnAmount);
74   function change(address _fromToken, uint _amount, address _toToken, uint _minReturn) public returns (uint _returnAmount);
75   function change(address _toToken) public returns (uint _returnAmount);
76   function change(address _toToken, uint _minReturn) public returns (uint _returnAmount);
77   function quote(address _fromToken, uint _amount, address _toToken) public constant returns (uint _returnAmount);
78   function openForPublicTrade() public returns (bool success);
79   function isOpenForPublic() public returns (bool success);
80 
81   event Change(address indexed fromToken, uint inAmount, address indexed toToken, uint returnAmount, address indexed account);
82 }
83 
84 
85 
86 
87 
88 /// @title Ellipse Market Maker Interfase
89 /// @author Tal Beja
90 contract IEllipseMarketMaker is MarketMaker {
91 
92     // precision for price representation (as in ether or tokens).
93     uint256 public constant PRECISION = 10 ** 18;
94 
95     // The tokens pair.
96     ERC20 public token1;
97     ERC20 public token2;
98 
99     // The tokens reserves.
100     uint256 public R1;
101     uint256 public R2;
102 
103     // The tokens full suplly.
104     uint256 public S1;
105     uint256 public S2;
106 
107     // State flags.
108     bool public operational;
109     bool public openForPublic;
110 
111     // Library contract address.
112     address public mmLib;
113 
114     function supportsToken(address token) public constant returns (bool);
115 
116     function calcReserve(uint256 _R1, uint256 _S1, uint256 _S2) public pure returns (uint256);
117 
118     function validateReserves() public view returns (bool);
119 
120     function withdrawExcessReserves() public returns (uint256);
121 
122     function initializeAfterTransfer() public returns (bool);
123 
124     function initializeOnTransfer() public returns (bool);
125 
126     function getPrice(uint256 _R1, uint256 _R2, uint256 _S1, uint256 _S2) public constant returns (uint256);
127 }
128 
129 
130 /// @title ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/issues/20)
131 contract ERC20 {
132     uint public totalSupply;
133     function balanceOf(address _owner) constant public returns (uint balance);
134     function transfer(address _to, uint _value) public returns (bool success);
135     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
136     function approve(address _spender, uint _value) public returns (bool success);
137     function allowance(address _owner, address _spender) public constant returns (uint remaining);
138     event Transfer(address indexed from, address indexed to, uint value);
139     event Approval(address indexed owner, address indexed spender, uint value);
140 }
141 
142 /// @title Ownable
143 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions,
144 /// this simplifies the implementation of "user permissions".
145 /// @dev Based on OpenZeppelin's Ownable.
146 
147 contract Ownable {
148     address public owner;
149     address public newOwnerCandidate;
150 
151     event OwnershipRequested(address indexed _by, address indexed _to);
152     event OwnershipTransferred(address indexed _from, address indexed _to);
153 
154     /// @dev Constructor sets the original `owner` of the contract to the sender account.
155     function Ownable() public {
156         owner = msg.sender;
157     }
158 
159     /// @dev Reverts if called by any account other than the owner.
160     modifier onlyOwner() {
161         require(msg.sender == owner);
162         _;
163     }
164 
165     modifier onlyOwnerCandidate() {
166         require(msg.sender == newOwnerCandidate);
167         _;
168     }
169 
170     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
171     /// @param _newOwnerCandidate address The address to transfer ownership to.
172     function requestOwnershipTransfer(address _newOwnerCandidate) external onlyOwner {
173         require(_newOwnerCandidate != address(0));
174 
175         newOwnerCandidate = _newOwnerCandidate;
176 
177         OwnershipRequested(msg.sender, newOwnerCandidate);
178     }
179 
180     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
181     function acceptOwnership() external onlyOwnerCandidate {
182         address previousOwner = owner;
183 
184         owner = newOwnerCandidate;
185         newOwnerCandidate = address(0);
186 
187         OwnershipTransferred(previousOwner, owner);
188     }
189 }
190 
191 
192 
193  /// @title Standard ERC223 Token Receiver implementing tokenFallback function and tokenPayable modifier
194 
195 contract Standard223Receiver is ERC223Receiver {
196   Tkn tkn;
197 
198   struct Tkn {
199     address addr;
200     address sender; // the transaction caller
201     uint256 value;
202   }
203 
204   bool __isTokenFallback;
205 
206   modifier tokenPayable {
207     require(__isTokenFallback);
208     _;
209   }
210 
211   /// @dev Called when the receiver of transfer is contract
212   /// @param _sender address the address of tokens sender
213   /// @param _value uint256 the amount of tokens to be transferred.
214   /// @param _data bytes data that can be attached to the token transation
215   function tokenFallback(address _sender, uint _value, bytes _data) external returns (bool ok) {
216     if (!supportsToken(msg.sender)) {
217       return false;
218     }
219 
220     // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
221     // Solution: Remove the the data
222     tkn = Tkn(msg.sender, _sender, _value);
223     __isTokenFallback = true;
224     if (!address(this).delegatecall(_data)) {
225       __isTokenFallback = false;
226       return false;
227     }
228     // avoid doing an overwrite to .token, which would be more expensive
229     // makes accessing .tkn values outside tokenPayable functions unsafe
230     __isTokenFallback = false;
231 
232     return true;
233   }
234 
235   function supportsToken(address token) public constant returns (bool);
236 }
237 
238 
239 
240 
241 
242 /// @title TokenOwnable
243 /// @dev The TokenOwnable contract adds a onlyTokenOwner modifier as a tokenReceiver with ownable addaptation
244 
245 contract TokenOwnable is Standard223Receiver, Ownable {
246     /// @dev Reverts if called by any account other than the owner for token sending.
247     modifier onlyTokenOwner() {
248         require(tkn.sender == owner);
249         _;
250     }
251 }
252 
253 
254 
255 
256 
257 
258 /// @title Ellipse Market Maker Library.
259 /// @dev market maker, using ellipse equation.
260 /// @dev for more information read the appendix of the CLN white paper: https://cln.network/pdf/cln_whitepaper.pdf
261 /// @author Tal Beja.
262 contract EllipseMarketMakerLib is TokenOwnable, IEllipseMarketMaker {
263   using SafeMath for uint256;
264 
265   // temp reserves
266   uint256 private l_R1;
267   uint256 private l_R2;
268 
269   modifier notConstructed() {
270     require(mmLib == address(0));
271     _;
272   }
273 
274   /// @dev Reverts if not operational
275   modifier isOperational() {
276     require(operational);
277     _;
278   }
279 
280   /// @dev Reverts if operational
281   modifier notOperational() {
282     require(!operational);
283     _;
284   }
285 
286   /// @dev Reverts if msg.sender can't trade
287   modifier canTrade() {
288     require(openForPublic || msg.sender == owner);
289     _;
290   }
291 
292   /// @dev Reverts if tkn.sender can't trade
293   modifier canTrade223() {
294     require (openForPublic || tkn.sender == owner);
295     _;
296   }
297 
298   /// @dev The Market Maker constructor
299   /// @param _mmLib address address of the market making lib contract
300   /// @param _token1 address contract of the first token for marker making (CLN)
301   /// @param _token2 address contract of the second token for marker making (CC)
302   function constructor(address _mmLib, address _token1, address _token2) public onlyOwner notConstructed returns (bool) {
303     require(_mmLib != address(0));
304     require(_token1 != address(0));
305     require(_token2 != address(0));
306     require(_token1 != _token2);
307 
308     mmLib = _mmLib;
309     token1 = ERC20(_token1);
310     token2 = ERC20(_token2);
311     R1 = 0;
312     R2 = 0;
313     S1 = token1.totalSupply();
314     S2 = token2.totalSupply();
315 
316     operational = false;
317     openForPublic = false;
318 
319     return true;
320   }
321 
322   /// @dev open the Market Maker for public trade.
323   function openForPublicTrade() public onlyOwner isOperational returns (bool) {
324     openForPublic = true;
325     return true;
326   }
327 
328   /// @dev returns true iff the contract is open for public trade.
329   function isOpenForPublic() public onlyOwner returns (bool) {
330     return (openForPublic && operational);
331   }
332 
333   /// @dev returns true iff token is supperted by this contract (for erc223/677 tokens calls)
334   /// @param _token address adress of the contract to check
335   function supportsToken(address _token) public constant returns (bool) {
336       return (token1 == _token || token2 == _token);
337   }
338 
339   /// @dev initialize the contract after transfering all of the tokens form the pair
340   function initializeAfterTransfer() public notOperational onlyOwner returns (bool) {
341     require(initialize());
342     return true;
343   }
344 
345   /// @dev initialize the contract during erc223/erc677 transfer of all of the tokens form the pair
346   function initializeOnTransfer() public notOperational onlyTokenOwner tokenPayable returns (bool) {
347     require(initialize());
348     return true;
349   }
350 
351   /// @dev initialize the contract.
352   function initialize() private returns (bool success) {
353     R1 = token1.balanceOf(this);
354     R2 = token2.balanceOf(this);
355     // one reserve should be full and the second should be empty
356     success = ((R1 == 0 && R2 == S2) || (R2 == 0 && R1 == S1));
357     if (success) {
358       operational = true;
359     }
360   }
361 
362   /// @dev the price of token1 in terms of token2, represented in 18 decimals.
363   function getCurrentPrice() public constant isOperational returns (uint256) {
364     return getPrice(R1, R2, S1, S2);
365   }
366 
367   /// @dev the price of token1 in terms of token2, represented in 18 decimals.
368   /// price = (S1 - R1) / (S2 - R2) * (S2 / S1)^2
369   /// @param _R1 uint256 reserve of the first token
370   /// @param _R2 uint256 reserve of the second token
371   /// @param _S1 uint256 total supply of the first token
372   /// @param _S2 uint256 total supply of the second token
373   function getPrice(uint256 _R1, uint256 _R2, uint256 _S1, uint256 _S2) public constant returns (uint256 price) {
374     price = PRECISION;
375     price = price.mul(_S1.sub(_R1));
376     price = price.div(_S2.sub(_R2));
377     price = price.mul(_S2);
378     price = price.div(_S1);
379     price = price.mul(_S2);
380     price = price.div(_S1);
381   }
382 
383   /// @dev get a quote for exchanging and update temporary reserves.
384   /// @param _fromToken the token to sell from
385   /// @param _inAmount the amount to sell
386   /// @param _toToken the token to buy
387   /// @return the return amount of the buying token
388   function quoteAndReserves(address _fromToken, uint256 _inAmount, address _toToken) private isOperational returns (uint256 returnAmount) {
389     // if buying token2 from token1
390     if (token1 == _fromToken && token2 == _toToken) {
391       // add buying amount to the temp reserve
392       l_R1 = R1.add(_inAmount);
393       // calculate the other reserve
394       l_R2 = calcReserve(l_R1, S1, S2);
395       if (l_R2 > R2) {
396         return 0;
397       }
398       // the returnAmount is the other reserve difference
399       returnAmount = R2.sub(l_R2);
400     }
401     // if buying token1 from token2
402     else if (token2 == _fromToken && token1 == _toToken) {
403       // add buying amount to the temp reserve
404       l_R2 = R2.add(_inAmount);
405       // calculate the other reserve
406       l_R1 = calcReserve(l_R2, S2, S1);
407       if (l_R1 > R1) {
408         return 0;
409       }
410       // the returnAmount is the other reserve difference
411       returnAmount = R1.sub(l_R1);
412     } else {
413       return 0;
414     }
415   }
416 
417   /// @dev get a quote for exchanging.
418   /// @param _fromToken the token to sell from
419   /// @param _inAmount the amount to sell
420   /// @param _toToken the token to buy
421   /// @return the return amount of the buying token
422   function quote(address _fromToken, uint256 _inAmount, address _toToken) public constant isOperational returns (uint256 returnAmount) {
423     uint256 _R1;
424     uint256 _R2;
425     // if buying token2 from token1
426     if (token1 == _fromToken && token2 == _toToken) {
427       // add buying amount to the temp reserve
428       _R1 = R1.add(_inAmount);
429       // calculate the other reserve
430       _R2 = calcReserve(_R1, S1, S2);
431       if (_R2 > R2) {
432         return 0;
433       }
434       // the returnAmount is the other reserve difference
435       returnAmount = R2.sub(_R2);
436     }
437     // if buying token1 from token2
438     else if (token2 == _fromToken && token1 == _toToken) {
439       // add buying amount to the temp reserve
440       _R2 = R2.add(_inAmount);
441       // calculate the other reserve
442       _R1 = calcReserve(_R2, S2, S1);
443       if (_R1 > R1) {
444         return 0;
445       }
446       // the returnAmount is the other reserve difference
447       returnAmount = R1.sub(_R1);
448     } else {
449       return 0;
450     }
451   }
452 
453   /// @dev calculate second reserve from the first reserve and the supllies.
454   /// @dev formula: R2 = S2 * (S1 - sqrt(R1 * S1 * 2  - R1 ^ 2)) / S1
455   /// @dev the equation is simetric, so by replacing _S1 and _S2 and _R1 with _R2 we can calculate the first reserve from the second reserve
456   /// @param _R1 the first reserve
457   /// @param _S1 the first total supply
458   /// @param _S2 the second total supply
459   /// @return _R2 the second reserve
460   function calcReserve(uint256 _R1, uint256 _S1, uint256 _S2) public pure returns (uint256 _R2) {
461     _R2 = _S2
462       .mul(
463         _S1
464         .sub(
465           _R1
466           .mul(_S1)
467           .mul(2)
468           .sub(
469             _R1
470             .toPower2()
471           )
472           .sqrt()
473         )
474       )
475       .div(_S1);
476   }
477 
478   /// @dev change tokens.
479   /// @param _fromToken the token to sell from
480   /// @param _inAmount the amount to sell
481   /// @param _toToken the token to buy
482   /// @return the return amount of the buying token
483   function change(address _fromToken, uint256 _inAmount, address _toToken) public canTrade returns (uint256 returnAmount) {
484     return change(_fromToken, _inAmount, _toToken, 0);
485   }
486 
487   /// @dev change tokens.
488   /// @param _fromToken the token to sell from
489   /// @param _inAmount the amount to sell
490   /// @param _toToken the token to buy
491   /// @param _minReturn the munimum token to buy
492   /// @return the return amount of the buying token
493   function change(address _fromToken, uint256 _inAmount, address _toToken, uint256 _minReturn) public canTrade returns (uint256 returnAmount) {
494     // pull transfer the selling token
495     require(ERC20(_fromToken).transferFrom(msg.sender, this, _inAmount));
496     // exchange the token
497     returnAmount = exchange(_fromToken, _inAmount, _toToken, _minReturn);
498     if (returnAmount == 0) {
499       // if no return value revert
500       revert();
501     }
502     // transfer the buying token
503     ERC20(_toToken).transfer(msg.sender, returnAmount);
504     // validate the reserves
505     require(validateReserves());
506     Change(_fromToken, _inAmount, _toToken, returnAmount, msg.sender);
507   }
508 
509   /// @dev change tokens using erc223\erc677 transfer.
510   /// @param _toToken the token to buy
511   /// @return the return amount of the buying token
512   function change(address _toToken) public canTrade223 tokenPayable returns (uint256 returnAmount) {
513     return change(_toToken, 0);
514   }
515 
516   /// @dev change tokens using erc223\erc677 transfer.
517   /// @param _toToken the token to buy
518   /// @param _minReturn the munimum token to buy
519   /// @return the return amount of the buying token
520   function change(address _toToken, uint256 _minReturn) public canTrade223 tokenPayable returns (uint256 returnAmount) {
521     // get from token and in amount from the tkn object
522     address fromToken = tkn.addr;
523     uint256 inAmount = tkn.value;
524     // exchange the token
525     returnAmount = exchange(fromToken, inAmount, _toToken, _minReturn);
526     if (returnAmount == 0) {
527       // if no return value revert
528       revert();
529     }
530     // transfer the buying token
531     ERC20(_toToken).transfer(tkn.sender, returnAmount);
532     // validate the reserves
533     require(validateReserves());
534     Change(fromToken, inAmount, _toToken, returnAmount, tkn.sender);
535   }
536 
537   /// @dev exchange tokens.
538   /// @param _fromToken the token to sell from
539   /// @param _inAmount the amount to sell
540   /// @param _toToken the token to buy
541   /// @param _minReturn the munimum token to buy
542   /// @return the return amount of the buying token
543   function exchange(address _fromToken, uint256 _inAmount, address _toToken, uint256 _minReturn) private returns (uint256 returnAmount) {
544     // get quote and update temp reserves
545     returnAmount = quoteAndReserves(_fromToken, _inAmount, _toToken);
546     // if the return amount is lower than minimum return, don't buy
547     if (returnAmount == 0 || returnAmount < _minReturn) {
548       return 0;
549     }
550 
551     // update reserves from temp values
552     updateReserve();
553   }
554 
555   /// @dev update token reserves from temp values
556   function updateReserve() private {
557     R1 = l_R1;
558     R2 = l_R2;
559   }
560 
561   /// @dev validate that the tokens balances don't goes below reserves
562   function validateReserves() public view returns (bool) {
563     return (token1.balanceOf(this) >= R1 && token2.balanceOf(this) >= R2);
564   }
565 
566   /// @dev allow admin to withraw excess tokens accumulated due to precision
567   function withdrawExcessReserves() public onlyOwner returns (uint256 returnAmount) {
568     // if there is excess of token 1, transfer it to the owner
569     if (token1.balanceOf(this) > R1) {
570       returnAmount = returnAmount.add(token1.balanceOf(this).sub(R1));
571       token1.transfer(msg.sender, token1.balanceOf(this).sub(R1));
572     }
573     // if there is excess of token 2, transfer it to the owner
574     if (token2.balanceOf(this) > R2) {
575       returnAmount = returnAmount.add(token2.balanceOf(this).sub(R2));
576       token2.transfer(msg.sender, token2.balanceOf(this).sub(R2));
577     }
578   }
579 }