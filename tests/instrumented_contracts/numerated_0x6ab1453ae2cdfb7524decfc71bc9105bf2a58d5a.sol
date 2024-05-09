1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41   
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() internal {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     emit OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 }
70 
71 contract tokenInterface {
72 	function balanceOf(address _owner) public constant returns (uint256 balance);
73 	function transfer(address _to, uint256 _value) public returns (bool);
74 }
75 
76 contract rateInterface {
77     function readRate(string _currency) public view returns (uint256 oneEtherValue);
78 }
79 
80 contract ICOEngineInterface {
81 
82     // false if the ico is not started, true if the ico is started and running, true if the ico is completed
83     function started() public view returns(bool);
84 
85     // false if the ico is not started, false if the ico is started and running, true if the ico is completed
86     function ended() public view returns(bool);
87 
88     // time stamp of the starting time of the ico, must return 0 if it depends on the block number
89     function startTime() public view returns(uint);
90 
91     // time stamp of the ending time of the ico, must retrun 0 if it depends on the block number
92     function endTime() public view returns(uint);
93 
94     // Optional function, can be implemented in place of startTime
95     // Returns the starting block number of the ico, must return 0 if it depends on the time stamp
96     // function startBlock() public view returns(uint);
97 
98     // Optional function, can be implemented in place of endTime
99     // Returns theending block number of the ico, must retrun 0 if it depends on the time stamp
100     // function endBlock() public view returns(uint);
101 
102     // returns the total number of the tokens available for the sale, must not change when the ico is started
103     function totalTokens() public view returns(uint);
104 
105     // returns the number of the tokens available for the ico. At the moment that the ico starts it must be equal to totalTokens(),
106     // then it will decrease. It is used to calculate the percentage of sold tokens as remainingTokens() / totalTokens()
107     function remainingTokens() public view returns(uint);
108 
109     // return the price as number of tokens released for each ether
110     function price() public view returns(uint);
111 }
112 
113 contract KYCBase {
114     using SafeMath for uint256;
115 
116     mapping (address => bool) public isKycSigner;
117     mapping (uint64 => uint256) public alreadyPayed;
118 
119     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
120 
121     function KYCBase(address [] kycSigners) internal {
122         for (uint i = 0; i < kycSigners.length; i++) {
123             isKycSigner[kycSigners[i]] = true;
124         }
125     }
126 
127     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
128     function releaseTokensTo(address buyer) internal returns(bool);
129 
130     // This method can be overridden to enable some sender to buy token for a different address
131     function senderAllowedFor(address buyer)
132         internal view returns(bool)
133     {
134         return buyer == msg.sender;
135     }
136 
137     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
138         public payable returns (bool)
139     {
140         require(senderAllowedFor(buyerAddress));
141         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
142     }
143 
144     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
145         public payable returns (bool)
146     {
147         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
148     }
149 
150     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
151         private returns (bool)
152     {
153         // check the signature
154         bytes32 hash = sha256("Eidoo icoengine authorization", address(0), buyerAddress, buyerId, maxAmount); //replaced this with address(0);
155         address signer = ecrecover(hash, v, r, s);
156         if (!isKycSigner[signer]) {
157             revert();
158         } else {
159             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
160             require(totalPayed <= maxAmount);
161             alreadyPayed[buyerId] = totalPayed;
162             emit KycVerified(signer, buyerAddress, buyerId, maxAmount);
163             return releaseTokensTo(buyerAddress);
164         }
165     }
166 }
167 
168 contract RC is ICOEngineInterface, KYCBase {
169     using SafeMath for uint256;
170     TokenSale tokenSaleContract;
171     uint256 public startTime;
172     uint256 public endTime;
173     
174     uint256 public etherMinimum;
175     uint256 public soldTokens;
176     uint256 public remainingTokens;
177     
178     uint256 public oneTokenInFiatWei;
179 	
180 	
181 	mapping(address => uint256) public etherUser; // address => ether amount
182 	mapping(address => uint256) public pendingTokenUser; // address => token amount that will be claimed
183 	mapping(address => uint256) public tokenUser; // address => token amount owned
184 	uint256[] public tokenThreshold; // array of token threshold reached in wei of token
185     uint256[] public bonusThreshold; // array of bonus of each tokenThreshold reached - 20% = 20
186 
187     function RC(address _tokenSaleContract, uint256 _oneTokenInFiatWei, uint256 _remainingTokens, uint256 _etherMinimum, uint256 _startTime , uint256 _endTime, address [] kycSigner, uint256[] _tokenThreshold, uint256[] _bonusThreshold ) public KYCBase(kycSigner) {
188         require ( _tokenSaleContract != 0 );
189         require ( _oneTokenInFiatWei != 0 );
190         require( _remainingTokens != 0 );
191         require ( _tokenThreshold.length != 0 );
192         require ( _tokenThreshold.length == _bonusThreshold.length );
193         bonusThreshold = _bonusThreshold;
194         tokenThreshold = _tokenThreshold;
195         
196         
197         tokenSaleContract = TokenSale(_tokenSaleContract);
198         
199         tokenSaleContract.addMeByRC();
200         
201         soldTokens = 0;
202         remainingTokens = _remainingTokens;
203         oneTokenInFiatWei = _oneTokenInFiatWei;
204         etherMinimum = _etherMinimum;
205         
206         setTimeRC( _startTime, _endTime );
207     }
208     
209     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
210         if( _startTime == 0 ) {
211             startTime = tokenSaleContract.startTime();
212         } else {
213             startTime = _startTime;
214         }
215         if( _endTime == 0 ) {
216             endTime = tokenSaleContract.endTime();
217         } else {
218             endTime = _endTime;
219         }
220     }
221     
222     modifier onlyTokenSaleOwner() {
223         require(msg.sender == tokenSaleContract.owner() );
224         _;
225     }
226     
227     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
228         if ( _newStart != 0 ) startTime = _newStart;
229         if ( _newEnd != 0 ) endTime = _newEnd;
230     }
231     
232     function changeMinimum(uint256 _newEtherMinimum) public onlyTokenSaleOwner {
233         etherMinimum = _newEtherMinimum;
234     }
235     
236     function releaseTokensTo(address buyer) internal returns(bool) {
237         if( msg.value > 0 ) takeEther(buyer);
238         giveToken(buyer);
239         return true;
240     }
241     
242     function started() public view returns(bool) {
243         return now > startTime || remainingTokens == 0;
244     }
245     
246     function ended() public view returns(bool) {
247         return now > endTime || remainingTokens == 0;
248     }
249     
250     function startTime() public view returns(uint) {
251         return startTime;
252     }
253     
254     function endTime() public view returns(uint) {
255         return endTime;
256     }
257     
258     function totalTokens() public view returns(uint) {
259         return remainingTokens.add(soldTokens);
260     }
261     
262     function remainingTokens() public view returns(uint) {
263         return remainingTokens;
264     }
265     
266     function price() public view returns(uint) {
267         uint256 oneEther = 10**18;
268         return oneEther.mul(10**18).div( tokenSaleContract.tokenValueInEther(oneTokenInFiatWei) );
269     }
270 	
271 	function () public payable{
272 	    require( now > startTime );
273 	    if(now < endTime) {
274 	        takeEther(msg.sender);
275 	    } else {
276 	        claimTokenBonus(msg.sender);
277 	    }
278 
279 	}
280 	
281 	event Buy(address buyer, uint256 value, uint256 soldToken, uint256 valueTokenInUsdWei );
282 	
283 	function takeEther(address _buyer) internal {
284 	    require( now > startTime );
285         require( now < endTime );
286         require( msg.value >= etherMinimum); 
287         require( remainingTokens > 0 );
288         
289         uint256 oneToken = 10 ** uint256(tokenSaleContract.decimals());
290         uint256 tokenValue = tokenSaleContract.tokenValueInEther(oneTokenInFiatWei);
291         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
292         
293         uint256 unboughtTokens = tokenInterface(tokenSaleContract.tokenContract()).balanceOf(tokenSaleContract);
294         if ( unboughtTokens > remainingTokens ) {
295             unboughtTokens = remainingTokens;
296         }
297         
298         uint256 refund = 0;
299         if ( unboughtTokens < tokenAmount ) {
300             refund = (tokenAmount - unboughtTokens).mul(tokenValue).div(oneToken);
301             tokenAmount = unboughtTokens;
302 			remainingTokens = 0; // set remaining token to 0
303             _buyer.transfer(refund);
304         } else {
305 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
306         }
307         
308         etherUser[_buyer] = etherUser[_buyer].add(msg.value.sub(refund));
309         pendingTokenUser[_buyer] = pendingTokenUser[_buyer].add(tokenAmount);	
310         
311         emit Buy( _buyer, msg.value, tokenAmount, oneTokenInFiatWei );
312 	}
313 	
314 	function giveToken(address _buyer) internal {
315 	    require( pendingTokenUser[_buyer] > 0 );
316 
317 		tokenUser[_buyer] = tokenUser[_buyer].add(pendingTokenUser[_buyer]);
318 	
319 		tokenSaleContract.claim(_buyer, pendingTokenUser[_buyer]);
320 		soldTokens = soldTokens.add(pendingTokenUser[_buyer]);
321 		pendingTokenUser[_buyer] = 0;
322 		
323 		tokenSaleContract.wallet().transfer(etherUser[_buyer]);
324 		etherUser[_buyer] = 0;
325 	}
326 
327     function claimTokenBonus(address _buyer) internal {
328         require( now > endTime );
329         require( tokenUser[_buyer] > 0 );
330         uint256 bonusApplied = 0;
331         for (uint i = 0; i < tokenThreshold.length; i++) {
332             if ( soldTokens > tokenThreshold[i] ) {
333                 bonusApplied = bonusThreshold[i];
334 			}
335 		}    
336 		require( bonusApplied > 0 );
337 		
338 		uint256 addTokenAmount = tokenUser[_buyer].mul( bonusApplied ).div(10**2);
339 		tokenUser[_buyer] = 0; 
340 		
341 		tokenSaleContract.claim(_buyer, addTokenAmount);
342 		_buyer.transfer(msg.value);
343     }
344     
345     function refundEther(address to) public onlyTokenSaleOwner {
346         to.transfer(etherUser[to]);
347         etherUser[to] = 0;
348         pendingTokenUser[to] = 0;
349     }
350     
351     function withdraw(address to, uint256 value) public onlyTokenSaleOwner { 
352         to.transfer(value);
353     }
354 	
355 	function userBalance(address _user) public view returns( uint256 _pendingTokenUser, uint256 _tokenUser, uint256 _etherUser ) {
356 		return (pendingTokenUser[_user], tokenUser[_user], etherUser[_user]);
357 	}
358 }
359 
360 contract RCpro is ICOEngineInterface, KYCBase {
361     using SafeMath for uint256;
362     TokenSale tokenSaleContract;
363     uint256 public startTime;
364     uint256 public endTime;
365     
366     uint256 public etherMinimum;
367     uint256 public soldTokens;
368     uint256 public remainingTokens;
369     
370     uint256[] public oneTokenInFiatWei;
371     uint256[] public sendThreshold;
372 	
373 	
374 	mapping(address => uint256) public etherUser; // address => ether amount
375 	mapping(address => uint256) public pendingTokenUser; // address => token amount that will be claimed
376 	mapping(address => uint256) public tokenUser; // address => token amount owned
377 	uint256[] public tokenThreshold; // array of token threshold reached in wei of token
378     uint256[] public bonusThreshold; // array of bonus of each tokenThreshold reached - 20% = 20
379 
380     function RCpro(address _tokenSaleContract, uint256[] _oneTokenInFiatWei, uint256[] _sendThreshold, uint256 _remainingTokens, uint256 _etherMinimum, uint256 _startTime , uint256 _endTime, address [] kycSigner, uint256[] _tokenThreshold, uint256[] _bonusThreshold ) public KYCBase(kycSigner) {
381         require ( _tokenSaleContract != 0 );
382         require ( _oneTokenInFiatWei[0] != 0 );
383         require ( _oneTokenInFiatWei.length == _sendThreshold.length );
384         require( _remainingTokens != 0 );
385         require ( _tokenThreshold.length != 0 );
386         require ( _tokenThreshold.length == _bonusThreshold.length );
387         bonusThreshold = _bonusThreshold;
388         tokenThreshold = _tokenThreshold;
389         
390         
391         tokenSaleContract = TokenSale(_tokenSaleContract);
392         
393         tokenSaleContract.addMeByRC();
394         
395         soldTokens = 0;
396         remainingTokens = _remainingTokens;
397         oneTokenInFiatWei = _oneTokenInFiatWei;
398         sendThreshold = _sendThreshold;
399         etherMinimum = _etherMinimum;
400         
401         setTimeRC( _startTime, _endTime );
402     }
403     
404     function setTimeRC(uint256 _startTime, uint256 _endTime ) internal {
405         if( _startTime == 0 ) {
406             startTime = tokenSaleContract.startTime();
407         } else {
408             startTime = _startTime;
409         }
410         if( _endTime == 0 ) {
411             endTime = tokenSaleContract.endTime();
412         } else {
413             endTime = _endTime;
414         }
415     }
416     
417     modifier onlyTokenSaleOwner() {
418         require(msg.sender == tokenSaleContract.owner() );
419         _;
420     }
421     
422     function setTime(uint256 _newStart, uint256 _newEnd) public onlyTokenSaleOwner {
423         if ( _newStart != 0 ) startTime = _newStart;
424         if ( _newEnd != 0 ) endTime = _newEnd;
425     }
426     
427     function changeMinimum(uint256 _newEtherMinimum) public onlyTokenSaleOwner {
428         etherMinimum = _newEtherMinimum;
429     }
430     
431     function releaseTokensTo(address buyer) internal returns(bool) {
432         if( msg.value > 0 ) takeEther(buyer);
433         giveToken(buyer);
434         return true;
435     }
436     
437     function started() public view returns(bool) {
438         return now > startTime || remainingTokens == 0;
439     }
440     
441     function ended() public view returns(bool) {
442         return now > endTime || remainingTokens == 0;
443     }
444     
445     function startTime() public view returns(uint) {
446         return startTime;
447     }
448     
449     function endTime() public view returns(uint) {
450         return endTime;
451     }
452     
453     function totalTokens() public view returns(uint) {
454         return remainingTokens.add(soldTokens);
455     }
456     
457     function remainingTokens() public view returns(uint) {
458         return remainingTokens;
459     }
460     
461     function price() public view returns(uint) {
462         uint256 oneEther = 10**18;
463         return oneEther.mul(10**18).div( tokenSaleContract.tokenValueInEther(oneTokenInFiatWei[0]) );
464     }
465 	
466 	function () public payable{
467 	    require( now > startTime );
468 	    if(now < endTime) {
469 	        takeEther(msg.sender);
470 	    } else {
471 	        claimTokenBonus(msg.sender);
472 	    }
473 
474 	}
475 	
476 	event Buy(address buyer, uint256 value, uint256 soldToken, uint256 valueTokenInFiatWei );
477 	
478 	function takeEther(address _buyer) internal {
479 	    require( now > startTime );
480         require( now < endTime );
481         require( msg.value >= etherMinimum); 
482         require( remainingTokens > 0 );
483         
484         uint256 oneToken = 10 ** uint256(tokenSaleContract.decimals());
485 		
486 		uint256 tknPriceApplied = 0;
487         for (uint i = 0; i < sendThreshold.length; i++) {
488             if ( msg.value >= sendThreshold[i] ) {
489                 tknPriceApplied = oneTokenInFiatWei[i];
490 			}
491 		}    
492 		require( tknPriceApplied > 0 );
493 		
494         uint256 tokenValue = tokenSaleContract.tokenValueInEther(tknPriceApplied);
495         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
496         
497         uint256 unboughtTokens = tokenInterface(tokenSaleContract.tokenContract()).balanceOf(tokenSaleContract);
498         if ( unboughtTokens > remainingTokens ) {
499             unboughtTokens = remainingTokens;
500         }
501         
502         uint256 refund = 0;
503         if ( unboughtTokens < tokenAmount ) {
504             refund = (tokenAmount - unboughtTokens).mul(tokenValue).div(oneToken);
505             tokenAmount = unboughtTokens;
506 			remainingTokens = 0; // set remaining token to 0
507             _buyer.transfer(refund);
508         } else {
509 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
510         }
511         
512         etherUser[_buyer] = etherUser[_buyer].add(msg.value.sub(refund));
513         pendingTokenUser[_buyer] = pendingTokenUser[_buyer].add(tokenAmount);	
514         
515         emit Buy( _buyer, msg.value, tokenAmount, tknPriceApplied );
516 	}
517 	
518 	function giveToken(address _buyer) internal {
519 	    require( pendingTokenUser[_buyer] > 0 );
520 
521 		tokenUser[_buyer] = tokenUser[_buyer].add(pendingTokenUser[_buyer]);
522 	
523 		tokenSaleContract.claim(_buyer, pendingTokenUser[_buyer]);
524 		soldTokens = soldTokens.add(pendingTokenUser[_buyer]);
525 		pendingTokenUser[_buyer] = 0;
526 		
527 		tokenSaleContract.wallet().transfer(etherUser[_buyer]);
528 		etherUser[_buyer] = 0;
529 	}
530 
531     function claimTokenBonus(address _buyer) internal {
532         require( now > endTime );
533         require( tokenUser[_buyer] > 0 );
534         uint256 bonusApplied = 0;
535         for (uint i = 0; i < tokenThreshold.length; i++) {
536             if ( soldTokens > tokenThreshold[i] ) {
537                 bonusApplied = bonusThreshold[i];
538 			}
539 		}    
540 		require( bonusApplied > 0 );
541 		
542 		uint256 addTokenAmount = tokenUser[_buyer].mul( bonusApplied ).div(10**2);
543 		tokenUser[_buyer] = 0; 
544 		
545 		tokenSaleContract.claim(_buyer, addTokenAmount);
546 		_buyer.transfer(msg.value);
547     }
548     
549     function refundEther(address to) public onlyTokenSaleOwner {
550         to.transfer(etherUser[to]);
551         etherUser[to] = 0;
552         pendingTokenUser[to] = 0;
553     }
554     
555     function withdraw(address to, uint256 value) public onlyTokenSaleOwner { 
556         to.transfer(value);
557     }
558 	
559 	function userBalance(address _user) public view returns( uint256 _pendingTokenUser, uint256 _tokenUser, uint256 _etherUser ) {
560 		return (pendingTokenUser[_user], tokenUser[_user], etherUser[_user]);
561 	}
562 }
563 
564 contract TokenSale is Ownable {
565     using SafeMath for uint256;
566     tokenInterface public tokenContract;
567     rateInterface public rateContract;
568     
569     address public wallet;
570     address public advisor;
571     uint256 public advisorFee; // 1 = 0,1%
572     
573 	uint256 public constant decimals = 18;
574     
575     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
576     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
577 
578     mapping(address => bool) public rc;
579 
580 
581     function TokenSale(address _tokenAddress, address _rateAddress, uint256 _startTime, uint256 _endTime) public {
582         tokenContract = tokenInterface(_tokenAddress);
583         rateContract = rateInterface(_rateAddress);
584         setTime(_startTime, _endTime); 
585         wallet = msg.sender;
586         advisor = msg.sender;
587         advisorFee = 0 * 10**3;
588     }
589     
590     function tokenValueInEther(uint256 _oneTokenInFiatWei) public view returns(uint256 tknValue) {
591         uint256 oneEtherInUsd = rateContract.readRate("usd");
592         tknValue = _oneTokenInFiatWei.mul(10 ** uint256(decimals)).div(oneEtherInUsd);
593         return tknValue;
594     } 
595     
596     modifier isBuyable() {
597         require( now > startTime ); // check if started
598         require( now < endTime ); // check if ended
599         require( msg.value > 0 );
600 		
601 		uint256 remainingTokens = tokenContract.balanceOf(this);
602         require( remainingTokens > 0 ); // Check if there are any remaining tokens 
603         _;
604     }
605     
606     event Buy(address buyer, uint256 value, address indexed ambassador);
607     
608     modifier onlyRC() {
609         require( rc[msg.sender] ); //check if is an authorized rcContract
610         _;
611     }
612     
613     function buyFromRC(address _buyer, uint256 _rcTokenValue, uint256 _remainingTokens) onlyRC isBuyable public payable returns(uint256) {
614         uint256 oneToken = 10 ** uint256(decimals);
615         uint256 tokenValue = tokenValueInEther(_rcTokenValue);
616         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
617         address _ambassador = msg.sender;
618         
619         
620         uint256 remainingTokens = tokenContract.balanceOf(this);
621         if ( _remainingTokens < remainingTokens ) {
622             remainingTokens = _remainingTokens;
623         }
624         
625         if ( remainingTokens < tokenAmount ) {
626             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneToken);
627             tokenAmount = remainingTokens;
628             forward(msg.value-refund);
629 			remainingTokens = 0; // set remaining token to 0
630              _buyer.transfer(refund);
631         } else {
632 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
633             forward(msg.value);
634         }
635         
636         tokenContract.transfer(_buyer, tokenAmount);
637         emit Buy(_buyer, tokenAmount, _ambassador);
638 		
639         return tokenAmount; 
640     }
641     
642     function forward(uint256 _amount) internal {
643         uint256 advisorAmount = _amount.mul(advisorFee).div(10**3);
644         uint256 walletAmount = _amount - advisorAmount;
645         advisor.transfer(advisorAmount);
646         wallet.transfer(walletAmount);
647     }
648 
649     event NewRC(address contr);
650     
651     function addMeByRC() public {
652         require(tx.origin == owner);
653         
654         rc[ msg.sender ]  = true;
655         
656         emit NewRC(msg.sender);
657     }
658     
659     function setTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
660         if ( _newStart != 0 ) startTime = _newStart;
661         if ( _newEnd != 0 ) endTime = _newEnd;
662     }
663 
664     function withdraw(address to, uint256 value) public onlyOwner {
665         to.transfer(value);
666     }
667     
668     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
669         return tokenContract.transfer(to, value);
670     }
671     
672     function setTokenContract(address _tokenContract) public onlyOwner {
673         tokenContract = tokenInterface(_tokenContract);
674     }
675 
676     function setWalletAddress(address _wallet) public onlyOwner {
677         wallet = _wallet;
678     }
679     
680     function setAdvisorAddress(address _advisor) public onlyOwner {
681             advisor = _advisor;
682     }
683     
684     function setAdvisorFee(uint256 _advisorFee) public onlyOwner {
685             advisorFee = _advisorFee;
686     }
687     
688     function setRateContract(address _rateAddress) public onlyOwner {
689         rateContract = rateInterface(_rateAddress);
690     }
691 	
692 	function claim(address _buyer, uint256 _amount) onlyRC public returns(bool) {
693         return tokenContract.transfer(_buyer, _amount);
694     }
695 
696     function () public payable {
697         revert();
698     }
699 }