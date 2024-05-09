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
16 
17 
18 /// @title Kyber Reserve contract
19 /// @author Yaron Velner
20 
21 contract KyberReserve {
22     address public reserveOwner;
23     address public kyberNetwork;
24     ERC20 constant public ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
25     uint  constant PRECISION = (10**18);
26     bool public tradeEnabled;
27 
28     struct ConversionRate {
29         uint rate;
30         uint expirationBlock;
31     }
32 
33     mapping(bytes32=>ConversionRate) pairConversionRate;
34 
35     /// @dev c'tor.
36     /// @param _kyberNetwork The address of kyber network
37     /// @param _reserveOwner Address of the reserve owner
38     function KyberReserve( address _kyberNetwork, address _reserveOwner ) {
39         kyberNetwork = _kyberNetwork;
40         reserveOwner = _reserveOwner;
41         tradeEnabled = true;
42     }
43 
44 
45     /// @dev check if a pair is listed for trading.
46     /// @param source Source token
47     /// @param dest Destination token
48     /// @param blockNumber Current block number
49     /// @return true iff pair is listed
50     function isPairListed( ERC20 source, ERC20 dest, uint blockNumber ) internal constant returns(bool) {
51         ConversionRate memory rateInfo = pairConversionRate[sha3(source,dest)];
52         if( rateInfo.rate == 0 ) return false;
53         return rateInfo.expirationBlock >= blockNumber;
54     }
55 
56     /// @dev get current conversion rate
57     /// @param source Source token
58     /// @param dest Destination token
59     /// @param blockNumber Current block number
60     /// @return conversion rate with PRECISION precision
61 
62     function getConversionRate( ERC20 source, ERC20 dest, uint blockNumber ) internal constant returns(uint) {
63         ConversionRate memory rateInfo = pairConversionRate[sha3(source,dest)];
64         if( rateInfo.rate == 0 ) return 0;
65         if( rateInfo.expirationBlock < blockNumber ) return 0;
66         return rateInfo.rate * (10 ** getDecimals(dest)) / (10**getDecimals(source));
67     }
68 
69     event ErrorReport( address indexed origin, uint error, uint errorInfo );
70     event DoTrade( address indexed origin, address source, uint sourceAmount, address destToken, uint destAmount, address destAddress );
71 
72     function getDecimals( ERC20 token ) constant returns(uint) {
73       if( token == ETH_TOKEN_ADDRESS ) return 18;
74       return token.decimals();
75     }
76 
77     /// @dev do a trade
78     /// @param sourceToken Source token
79     /// @param sourceAmount Amount of source token
80     /// @param destToken Destination token
81     /// @param destAddress Destination address to send tokens to
82     /// @param validate If true, additional validations are applicable
83     /// @return true iff trade is succesful
84     function doTrade( ERC20 sourceToken,
85                       uint sourceAmount,
86                       ERC20 destToken,
87                       address destAddress,
88                       bool validate ) internal returns(bool) {
89 
90         // can skip validation if done at kyber network level
91         if( validate ) {
92             if( ! isPairListed( sourceToken, destToken, block.number ) ) {
93                 // pair is not listed
94                 ErrorReport( tx.origin, 0x800000001, 0 );
95                 return false;
96 
97             }
98             if( sourceToken == ETH_TOKEN_ADDRESS ) {
99                 if( msg.value != sourceAmount ) {
100                     // msg.value != sourceAmmount
101                     ErrorReport( tx.origin, 0x800000002, msg.value );
102                     return false;
103                 }
104             }
105             else if( msg.value > 0 ) {
106                 // msg.value must be 0
107                 ErrorReport( tx.origin, 0x800000003, msg.value );
108                 return false;
109             }
110             else if( sourceToken.allowance(msg.sender, this ) < sourceAmount ) {
111                 // allowance is not enough
112                 ErrorReport( tx.origin, 0x800000004, sourceToken.allowance(msg.sender, this ) );
113                 return false;
114             }
115         }
116 
117         uint conversionRate = getConversionRate( sourceToken, destToken, block.number );
118         // TODO - safe multiplication
119         uint destAmount = (conversionRate * sourceAmount) / PRECISION;
120 
121         // sanity check
122         if( destAmount == 0 ) {
123             // unexpected error: dest amount is 0
124             ErrorReport( tx.origin, 0x800000005, 0 );
125             return false;
126         }
127 
128         // check for sufficient balance
129         if( destToken == ETH_TOKEN_ADDRESS ) {
130             if( this.balance < destAmount ) {
131                 // insufficient ether balance
132                 ErrorReport( tx.origin, 0x800000006, destAmount );
133                 return false;
134             }
135         }
136         else {
137             if( destToken.balanceOf(this) < destAmount ) {
138                 // insufficient token balance
139                 ErrorReport( tx.origin, 0x800000007, uint(destToken) );
140                 return false;
141             }
142         }
143 
144         // collect source tokens
145         if( sourceToken != ETH_TOKEN_ADDRESS ) {
146             if( ! sourceToken.transferFrom(msg.sender,this,sourceAmount) ) {
147                 // transfer from source token failed
148                 ErrorReport( tx.origin, 0x800000008, uint(sourceToken) );
149                 return false;
150             }
151         }
152 
153         // send dest tokens
154         if( destToken == ETH_TOKEN_ADDRESS ) {
155             if( ! destAddress.send(destAmount) ) {
156                 // transfer ether to dest failed
157                 ErrorReport( tx.origin, 0x800000009, uint(destAddress) );
158                 return false;
159             }
160         }
161         else {
162             if( ! destToken.transfer(destAddress, destAmount) ) {
163                 // transfer token to dest failed
164                 ErrorReport( tx.origin, 0x80000000a, uint(destAddress) );
165                 return false;
166             }
167         }
168 
169         DoTrade( tx.origin, sourceToken, sourceAmount, destToken, destAmount, destAddress );
170 
171         return true;
172     }
173 
174     /// @dev trade
175     /// @param sourceToken Source token
176     /// @param sourceAmount Amount of source token
177     /// @param destToken Destination token
178     /// @param destAddress Destination address to send tokens to
179     /// @param validate If true, additional validations are applicable
180     /// @return true iff trade is succesful
181     function trade( ERC20 sourceToken,
182                     uint sourceAmount,
183                     ERC20 destToken,
184                     address destAddress,
185                     bool validate ) payable returns(bool) {
186 
187         if( ! tradeEnabled ) {
188             // trade is not enabled
189             ErrorReport( tx.origin, 0x810000000, 0 );
190             if( msg.value > 0 ) {
191                 if( ! msg.sender.send(msg.value) ) throw;
192             }
193             return false;
194         }
195 
196         if( msg.sender != kyberNetwork ) {
197             // sender must be kyber network
198             ErrorReport( tx.origin, 0x810000001, uint(msg.sender) );
199             if( msg.value > 0 ) {
200                 if( ! msg.sender.send(msg.value) ) throw;
201             }
202 
203             return false;
204         }
205 
206         if( ! doTrade( sourceToken, sourceAmount, destToken, destAddress, validate ) ) {
207             // do trade failed
208             ErrorReport( tx.origin, 0x810000002, 0 );
209             if( msg.value > 0 ) {
210                 if( ! msg.sender.send(msg.value) ) throw;
211             }
212             return false;
213         }
214 
215         ErrorReport( tx.origin, 0, 0 );
216         return true;
217     }
218 
219     event SetRate( ERC20 source, ERC20 dest, uint rate, uint expiryBlock );
220 
221     /// @notice can be called only by owner
222     /// @dev set rate of pair of tokens
223     /// @param sources an array contain source tokens
224     /// @param dests an array contain dest tokens
225     /// @param conversionRates an array with rates
226     /// @param expiryBlocks array of expiration blocks
227     /// @param validate If true, additional validations are applicable
228     /// @return true iff trade is succesful
229     function setRate( ERC20[] sources, ERC20[] dests, uint[] conversionRates, uint[] expiryBlocks, bool validate ) returns(bool) {
230         if( msg.sender != reserveOwner ) {
231             // sender must be reserve owner
232             ErrorReport( tx.origin, 0x820000000, uint(msg.sender) );
233             return false;
234         }
235 
236         if( validate ) {
237             if( ( sources.length != dests.length ) ||
238                 ( sources.length != conversionRates.length ) ||
239                 ( sources.length != expiryBlocks.length ) ) {
240                 // arrays length are not identical
241                 ErrorReport( tx.origin, 0x820000001, 0 );
242                 return false;
243             }
244         }
245 
246         for( uint i = 0 ; i < sources.length ; i++ ) {
247             SetRate( sources[i], dests[i], conversionRates[i], expiryBlocks[i] );
248             pairConversionRate[sha3(sources[i],dests[i])] = ConversionRate( conversionRates[i], expiryBlocks[i] );
249         }
250 
251         ErrorReport( tx.origin, 0, 0 );
252         return true;
253     }
254 
255     event EnableTrade( bool enable );
256 
257     /// @notice can be called only by owner
258     /// @dev enable of disable trade
259     /// @param enable if true trade is enabled, otherwise disabled
260     /// @return true iff trade is succesful
261     function enableTrade( bool enable ) returns(bool){
262         if( msg.sender != reserveOwner ) {
263             // sender must be reserve owner
264             ErrorReport( tx.origin, 0x830000000, uint(msg.sender) );
265             return false;
266         }
267 
268         tradeEnabled = enable;
269         ErrorReport( tx.origin, 0, 0 );
270         EnableTrade( enable );
271 
272         return true;
273     }
274 
275     event DepositToken( ERC20 token, uint amount );
276     function() payable {
277         DepositToken( ETH_TOKEN_ADDRESS, msg.value );
278     }
279 
280     /// @notice ether could also be deposited without calling this function
281     /// @dev an auxilary function that allows ether deposits
282     /// @return true iff deposit is succesful
283     function depositEther( ) payable returns(bool) {
284         ErrorReport( tx.origin, 0, 0 );
285 
286         DepositToken( ETH_TOKEN_ADDRESS, msg.value );
287         return true;
288     }
289 
290     /// @notice tokens could also be deposited without calling this function
291     /// @dev an auxilary function that allows token deposits
292     /// @param token Token address
293     /// @param amount Amount of tokens to deposit
294     /// @return true iff deposit is succesful
295     function depositToken( ERC20 token, uint amount ) returns(bool) {
296         if( token.allowance( msg.sender, this ) < amount ) {
297             // allowence is smaller then amount
298             ErrorReport( tx.origin, 0x850000001, token.allowance( msg.sender, this ) );
299             return false;
300         }
301 
302         if( ! token.transferFrom(msg.sender, this, amount ) ) {
303             // transfer from failed
304             ErrorReport( tx.origin, 0x850000002, uint(token) );
305             return false;
306         }
307 
308         DepositToken( token, amount );
309         return true;
310     }
311 
312 
313     event Withdraw( ERC20 token, uint amount, address destination );
314 
315     /// @notice can only be called by owner.
316     /// @dev withdaw tokens or ether from contract
317     /// @param token Token address
318     /// @param amount Amount of tokens to deposit
319     /// @param destination address that get withdrewed funds
320     /// @return true iff withdrawal is succesful
321     function withdraw( ERC20 token, uint amount, address destination ) returns(bool) {
322         if( msg.sender != reserveOwner ) {
323             // sender must be reserve owner
324             ErrorReport( tx.origin, 0x860000000, uint(msg.sender) );
325             return false;
326         }
327 
328         if( token == ETH_TOKEN_ADDRESS ) {
329             if( ! destination.send(amount) ) throw;
330         }
331         else if( ! token.transfer(destination,amount) ) {
332             // transfer to reserve owner failed
333             ErrorReport( tx.origin, 0x860000001, uint(token) );
334             return false;
335         }
336 
337         ErrorReport( tx.origin, 0, 0 );
338         Withdraw( token, amount, destination );
339     }
340 
341     function changeOwner( address newOwner ) {
342       if( msg.sender != reserveOwner ) throw;
343       reserveOwner = newOwner;
344     }
345 
346     ////////////////////////////////////////////////////////////////////////////
347     /// status functions ///////////////////////////////////////////////////////
348     ////////////////////////////////////////////////////////////////////////////
349 
350     /// @notice use token address ETH_TOKEN_ADDRESS for ether
351     /// @dev information on conversion rate from source to dest
352     /// @param source Source token
353     /// @param dest   Destinatoin token
354     /// @return (conversion rate,experation block,dest token balance of reserve)
355     function getPairInfo( ERC20 source, ERC20 dest ) constant returns(uint rate, uint expBlock, uint balance) {
356         ConversionRate memory rateInfo = pairConversionRate[sha3(source,dest)];
357         balance = 0;
358         if( dest == ETH_TOKEN_ADDRESS ) balance = this.balance;
359         else balance = dest.balanceOf(this);
360 
361         expBlock = rateInfo.expirationBlock;
362         rate = rateInfo.rate;
363     }
364 
365     /// @notice a debug function
366     /// @dev get the balance of the reserve
367     /// @param token The token type
368     /// @return The balance
369     function getBalance( ERC20 token ) constant returns(uint){
370         if( token == ETH_TOKEN_ADDRESS ) return this.balance;
371         else return token.balanceOf(this);
372     }
373 }
374 
375 
376 ////////////////////////////////////////////////////////////////////////////////////////////////////////
377 
378 /// @title Kyber Network main contract
379 /// @author Yaron Velner
380 
381 contract KyberNetwork {
382     address admin;
383     ERC20 constant public ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
384     uint  constant PRECISION = (10**18);
385     uint  constant EPSILON = (10);
386     KyberReserve[] public reserves;
387 
388     mapping(address=>mapping(bytes32=>bool)) perReserveListedPairs;
389 
390     event ErrorReport( address indexed origin, uint error, uint errorInfo );
391 
392     /// @dev c'tor.
393     /// @param _admin The address of the administrator
394     function KyberNetwork( address _admin ) {
395         admin = _admin;
396     }
397 
398 
399     struct KyberReservePairInfo {
400         uint rate;
401         uint reserveBalance;
402         KyberReserve reserve;
403     }
404 
405 
406     /// @dev returns number of reserves
407     /// @return number of reserves
408     function getNumReserves() constant returns(uint){
409         return reserves.length;
410     }
411 
412     /// @notice use token address ETH_TOKEN_ADDRESS for ether
413     /// @dev information on conversion rate from source to dest in specific reserve manager
414     /// @param source Source token
415     /// @param dest   Destinatoin token
416     /// @return (conversion rate,experation block,dest token balance of reserve)
417     function getRate( ERC20 source, ERC20 dest, uint reserveIndex ) constant returns(uint rate, uint expBlock, uint balance){
418         (rate,expBlock, balance) = reserves[reserveIndex].getPairInfo(source,dest);
419     }
420 
421     /// @notice use token address ETH_TOKEN_ADDRESS for ether
422     /// @dev information on conversion rate to a front end application
423     /// @param source Source token
424     /// @param dest   Destinatoin token
425     /// @return rate. If not available returns 0.
426 
427     function getPrice( ERC20 source, ERC20 dest ) constant returns(uint) {
428       uint rate; uint expBlock; uint balance;
429       (rate, expBlock, balance) = getRate( source, dest, 0 );
430       if( expBlock <= block.number ) return 0; // TODO - consider add 1
431       if( balance == 0 ) return 0; // TODO - decide on minimal qty
432       return rate;
433     }
434 
435     function getDecimals( ERC20 token ) constant returns(uint) {
436       if( token == ETH_TOKEN_ADDRESS ) return 18;
437       return token.decimals();
438     }
439 
440     /// @notice use token address ETH_TOKEN_ADDRESS for ether
441     /// @dev best conversion rate for a pair of tokens
442     /// @param source Source token
443     /// @param dest   Destinatoin token
444     /// @return KyberReservePairInfo structure
445     function findBestRate( ERC20 source, ERC20 dest ) internal constant returns(KyberReservePairInfo) {
446         uint bestRate;
447         uint bestReserveBalance = 0;
448         uint numReserves = reserves.length;
449 
450         KyberReservePairInfo memory output;
451         KyberReserve bestReserve = KyberReserve(0);
452 
453         for( uint i = 0 ; i < numReserves ; i++ ) {
454             var (rate,expBlock,balance) = reserves[i].getPairInfo(source,dest);
455 
456             if( (expBlock >= block.number) && (balance > 0) && (rate > bestRate ) ) {
457                 bestRate = rate;
458                 bestReserveBalance = balance;
459                 bestReserve = reserves[i];
460             }
461         }
462 
463         output.rate = bestRate;
464         output.reserveBalance = bestReserveBalance;
465         output.reserve = bestReserve;
466 
467         return output;
468     }
469 
470 
471     /// @notice use token address ETH_TOKEN_ADDRESS for ether
472     /// @dev do one trade with a reserve
473     /// @param source Source token
474     /// @param amount amount of source tokens
475     /// @param dest   Destinatoin token
476     /// @param destAddress Address to send tokens to
477     /// @param reserve Reserve to use
478     /// @param validate If true, additional validations are applicable
479     /// @return true if trade is succesful
480     function doSingleTrade( ERC20 source, uint amount,
481                             ERC20 dest, address destAddress,
482                             KyberReserve reserve,
483                             bool validate ) internal returns(bool) {
484 
485         uint callValue = 0;
486         if( source == ETH_TOKEN_ADDRESS ) callValue = amount;
487         else {
488             // take source tokens to this contract
489             source.transferFrom(msg.sender, this, amount);
490 
491             // let reserve use network tokens
492             source.approve( reserve, amount);
493         }
494 
495         if( ! reserve.trade.value(callValue)(source, amount, dest, destAddress, validate ) ) {
496             if( source != ETH_TOKEN_ADDRESS ) {
497                 // reset tokens for reserve
498                 if( ! source.approve( reserve, 0) ) throw;
499 
500                 // send tokens back to sender
501                 if( ! source.transfer(msg.sender, amount) ) throw;
502             }
503 
504             return false;
505         }
506 
507         if( source != ETH_TOKEN_ADDRESS ) {
508             source.approve( reserve, 0);
509         }
510 
511         return true;
512     }
513 
514     /// @notice use token address ETH_TOKEN_ADDRESS for ether
515     /// @dev checks that user sent ether/tokens to contract before trade
516     /// @param source Source token
517     /// @param srcAmount amount of source tokens
518     /// @return true if input is valid
519     function validateTradeInput( ERC20 source, uint srcAmount ) constant internal returns(bool) {
520         if( source != ETH_TOKEN_ADDRESS && msg.value > 0 ) {
521             // shouldn't send ether for token exchange
522             ErrorReport( tx.origin, 0x85000000, 0 );
523             return false;
524         }
525         else if( source == ETH_TOKEN_ADDRESS && msg.value != srcAmount ) {
526             // amount of sent ether is wrong
527             ErrorReport( tx.origin, 0x85000001, msg.value );
528             return false;
529         }
530         else if( source != ETH_TOKEN_ADDRESS ) {
531             if( source.allowance(msg.sender,this) < srcAmount ) {
532                 // insufficient allowane
533                 ErrorReport( tx.origin, 0x85000002, msg.value );
534                 return false;
535             }
536         }
537 
538         return true;
539 
540     }
541 
542     event Trade( address indexed sender, ERC20 source, ERC20 dest, uint actualSrcAmount, uint actualDestAmount );
543 
544     struct ReserveTokenInfo {
545         uint rate;
546         KyberReserve reserve;
547         uint reserveBalance;
548     }
549 
550     struct TradeInfo {
551         uint convertedDestAmount;
552         uint remainedSourceAmount;
553 
554         bool tradeFailed;
555     }
556 
557     /// @notice use token address ETH_TOKEN_ADDRESS for ether
558     /// @dev makes a trade between source and dest token and send dest token to
559     /// destAddress and record wallet id for later payment
560     /// @param source Source token
561     /// @param srcAmount amount of source tokens
562     /// @param dest   Destinatoin token
563     /// @param destAddress Address to send tokens to
564     /// @param maxDestAmount A limit on the amount of dest tokens
565     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
566     /// @param throwOnFailure if true and trade is not completed, then function throws.
567     /// @return amount of actual dest tokens
568     function walletTrade( ERC20 source, uint srcAmount,
569                     ERC20 dest, address destAddress, uint maxDestAmount,
570                     uint minConversionRate,
571                     bool throwOnFailure,
572                     bytes32 walletId ) payable returns(uint) {
573        // TODO - log wallet id
574        return trade( source, srcAmount, dest, destAddress, maxDestAmount,
575                      minConversionRate, throwOnFailure );
576     }
577 
578 
579     function isNegligable( uint currentValue, uint originalValue ) constant returns(bool){
580       return (currentValue < (originalValue / 1000)) || (currentValue == 0);
581     }
582     /// @notice use token address ETH_TOKEN_ADDRESS for ether
583     /// @dev makes a trade between source and dest token and send dest token to destAddress
584     /// @param source Source token
585     /// @param srcAmount amount of source tokens
586     /// @param dest   Destinatoin token
587     /// @param destAddress Address to send tokens to
588     /// @param maxDestAmount A limit on the amount of dest tokens
589     /// @param minConversionRate The minimal conversion rate. If actual rate is lower, trade is canceled.
590     /// @param throwOnFailure if true and trade is not completed, then function throws.
591     /// @return amount of actual dest tokens
592     function trade( ERC20 source, uint srcAmount,
593                     ERC20 dest, address destAddress, uint maxDestAmount,
594                     uint minConversionRate,
595                     bool throwOnFailure ) payable returns(uint) {
596 
597         if( ! validateTradeInput( source, srcAmount ) ) {
598             // invalid input
599             ErrorReport( tx.origin, 0x86000000, 0 );
600             if( msg.value > 0 ) {
601                 if( ! msg.sender.send(msg.value) ) throw;
602             }
603             if( throwOnFailure ) throw;
604             return 0;
605         }
606 
607         TradeInfo memory tradeInfo = TradeInfo(0,srcAmount,false);
608 
609         while( !isNegligable(maxDestAmount-tradeInfo.convertedDestAmount, maxDestAmount)
610                && !isNegligable(tradeInfo.remainedSourceAmount, srcAmount)) {
611             KyberReservePairInfo memory reserveInfo = findBestRate(source,dest);
612 
613             if( reserveInfo.rate == 0 || reserveInfo.rate < minConversionRate ) {
614                 tradeInfo.tradeFailed = true;
615                 // no more available funds
616                 ErrorReport( tx.origin, 0x86000001, tradeInfo.remainedSourceAmount );
617                 break;
618             }
619 
620             reserveInfo.rate = (reserveInfo.rate * (10 ** getDecimals(dest))) /
621                                                       (10**getDecimals(source));
622 
623             uint actualSrcAmount = tradeInfo.remainedSourceAmount;
624             // TODO - overflow check
625             uint actualDestAmount = (actualSrcAmount * reserveInfo.rate) / PRECISION;
626             if( actualDestAmount > reserveInfo.reserveBalance ) {
627                 actualDestAmount = reserveInfo.reserveBalance;
628             }
629             if( actualDestAmount + tradeInfo.convertedDestAmount > maxDestAmount ) {
630                 actualDestAmount = maxDestAmount - tradeInfo.convertedDestAmount;
631             }
632 
633             // TODO - check overflow
634             actualSrcAmount = (actualDestAmount * PRECISION)/reserveInfo.rate;
635 
636             // do actual trade
637             if( ! doSingleTrade( source,actualSrcAmount, dest, destAddress, reserveInfo.reserve, true ) ) {
638                 tradeInfo.tradeFailed = true;
639                 // trade failed in reserve
640                 ErrorReport( tx.origin, 0x86000002, tradeInfo.remainedSourceAmount );
641                 break;
642             }
643 
644             // todo - check overflow
645             tradeInfo.remainedSourceAmount -= actualSrcAmount;
646             tradeInfo.convertedDestAmount += actualDestAmount;
647         }
648 
649         if( tradeInfo.tradeFailed ) {
650             if( throwOnFailure ) throw;
651             if( msg.value > 0 ) {
652                 if( ! msg.sender.send(msg.value) ) throw;
653             }
654 
655             return 0;
656         }
657         else {
658             ErrorReport( tx.origin, 0, 0 );
659             if( tradeInfo.remainedSourceAmount > 0 && source == ETH_TOKEN_ADDRESS ) {
660                 if( ! msg.sender.send(tradeInfo.remainedSourceAmount) ) throw;
661             }
662 
663 
664 
665             ErrorReport( tx.origin, 0, 0 );
666             Trade( msg.sender, source, dest, srcAmount-tradeInfo.remainedSourceAmount, tradeInfo.convertedDestAmount );
667             return tradeInfo.convertedDestAmount;
668         }
669     }
670 
671     event AddReserve( KyberReserve reserve, bool add );
672 
673     /// @notice can be called only by admin
674     /// @dev add or deletes a reserve to/from the network.
675     /// @param reserve The reserve address.
676     /// @param add If true, the add reserve. Otherwise delete reserve.
677     function addReserve( KyberReserve reserve, bool add ) {
678         if( msg.sender != admin ) {
679             // only admin can add to reserve
680             ErrorReport( msg.sender, 0x87000000, 0 );
681             return;
682         }
683 
684         if( add ) {
685             reserves.push(reserve);
686             AddReserve( reserve, true );
687         }
688         else {
689             // will have truble if more than 50k reserves...
690             for( uint i = 0 ; i < reserves.length ; i++ ) {
691                 if( reserves[i] == reserve ) {
692                     if( reserves.length == 0 ) return;
693                     reserves[i] = reserves[--reserves.length];
694                     AddReserve( reserve, false );
695                     break;
696                 }
697             }
698         }
699 
700         ErrorReport( msg.sender, 0, 0 );
701     }
702 
703     event ListPairsForReserve( address reserve, ERC20 source, ERC20 dest, bool add );
704 
705     /// @notice can be called only by admin
706     /// @dev allow or prevent a specific reserve to trade a pair of tokens
707     /// @param reserve The reserve address.
708     /// @param source Source token
709     /// @param dest Destination token
710     /// @param add If true then enable trade, otherwise delist pair.
711     function listPairForReserve(address reserve, ERC20 source, ERC20 dest, bool add ) {
712         if( msg.sender != admin ) {
713             // only admin can add to reserve
714             ErrorReport( msg.sender, 0x88000000, 0 );
715             return;
716         }
717 
718         (perReserveListedPairs[reserve])[sha3(source,dest)] = add;
719         ListPairsForReserve( reserve, source, dest, add );
720         ErrorReport( tx.origin, 0, 0 );
721     }
722 
723     /// @notice can be called only by admin. still not implemented
724     /// @dev upgrade network to a new contract
725     /// @param newAddress The address of the new network
726     function upgrade( address newAddress ) {
727         // TODO
728         newAddress; // unused warning
729         throw;
730     }
731 
732     /// @notice should be called off chain with as much gas as needed
733     /// @dev get an array of all reserves
734     /// @return An array of all reserves
735     function getReserves( ) constant returns(KyberReserve[]) {
736         return reserves;
737     }
738 
739 
740     /// @notice a debug function
741     /// @dev get the balance of the network. It is expected to be 0 all the time.
742     /// @param token The token type
743     /// @return The balance
744     function getBalance( ERC20 token ) constant returns(uint){
745         if( token == ETH_TOKEN_ADDRESS ) return this.balance;
746         else return token.balanceOf(this);
747     }
748 }