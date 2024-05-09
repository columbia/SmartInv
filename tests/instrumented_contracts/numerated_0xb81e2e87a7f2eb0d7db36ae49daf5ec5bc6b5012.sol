1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20 interface (only needed methods)
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 {
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63 }
64 
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipRenounced(address indexed previousOwner);
76   event OwnershipTransferred(
77     address indexed previousOwner,
78     address indexed newOwner
79   );
80 
81 
82   /**
83    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84    * account.
85    */
86   constructor() public {
87     owner = msg.sender;
88   }
89 
90   /**
91    * @dev Throws if called by any account other than the owner.
92    */
93   modifier onlyOwner() {
94     require(msg.sender == owner);
95     _;
96   }
97 
98   /**
99    * @dev Allows the current owner to transfer control of the contract to a newOwner.
100    * @param newOwner The address to transfer ownership to.
101    */
102   function transferOwnership(address newOwner) public onlyOwner {
103     require(newOwner != address(0));
104     emit OwnershipTransferred(owner, newOwner);
105     owner = newOwner;
106   }
107 
108   /**
109    * @dev Allows the current owner to relinquish control of the contract.
110    */
111   function renounceOwnership() public onlyOwner {
112     emit OwnershipRenounced(owner);
113     owner = address(0);
114   }
115 }
116 
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123   event Pause();
124   event Unpause();
125 
126   bool public paused = false;
127 
128 
129   /**
130    * @dev Modifier to make a function callable only when the contract is not paused.
131    */
132   modifier whenNotPaused() {
133     require(!paused);
134     _;
135   }
136 
137   /**
138    * @dev Modifier to make a function callable only when the contract is paused.
139    */
140   modifier whenPaused() {
141     require(paused);
142     _;
143   }
144 
145   /**
146    * @dev called by the owner to pause, triggers stopped state
147    */
148   function pause() onlyOwner whenNotPaused public {
149     paused = true;
150     emit Pause();
151   }
152 
153   /**
154    * @dev called by the owner to unpause, returns to normal state
155    */
156   function unpause() onlyOwner whenPaused public {
157     paused = false;
158     emit Unpause();
159   }
160 }
161 
162 
163 /**
164  * @title QWoodDAOTokenSale
165  * @dev The QWoodDAOTokenSale contract receive ether and other foreign tokens and exchange them to set tokens.
166  */
167 contract QWoodDAOTokenSale is Pausable {
168   using SafeMath for uint256;
169 
170 
171   // Represents data of foreign token which can be exchange to token
172   struct ReceivedToken {
173     // name of foreign token
174     string name;
175 
176     // number of token units a buyer gets per foreign token unit
177     uint256 rate;
178 
179     // amount of raised foreign tokens
180     uint256 raised;
181   }
182 
183 
184   // The token being sold
185   ERC20 public token;
186 
187   // Address where funds are collected
188   address public wallet;
189 
190   // How many token units a buyer gets per wei.
191   // The rate is the conversion between wei and the smallest and indivisible token unit.
192   // So, if you are using a rate of 1 with a ERC20 token with 3 decimals called TOK
193   // 1 wei will give you 1 unit, or 0.001 TOK.
194   uint256 public rate;
195 
196   // Amount of wei raised
197   uint256 public weiRaised;
198 
199   // Map from token address to token data
200   mapping (address => ReceivedToken) public receivedTokens;
201 
202 
203   /**
204    * Event for token purchase logging
205    * @param purchaser who paid for the tokens
206    * @param beneficiary who got the tokens
207    * @param value weis paid for purchase
208    * @param amount amount of tokens purchased
209    */
210   event TokenPurchase(
211     address indexed purchaser,
212     address indexed beneficiary,
213     uint256 value,
214     uint256 amount
215   );
216 
217   /**
218    * Event for token purchase for token logging
219    * @param purchaser who paid for the tokens
220    * @param beneficiary who got the tokens
221    * @param value foreign tokens units paid for purchase
222    * @param amount amount of tokens purchased
223    */
224   event TokenForTokenPurchase(
225     address indexed purchaser,
226     address indexed beneficiary,
227     uint256 value,
228     uint256 amount
229   );
230 
231   /**
232    * Event for change rate logging
233    * @param newRate new number of token units a buyer gets per wei
234    */
235   event ChangeRate(uint256 newRate);
236 
237   /**
238    * Event for add received token logging
239    * @param tokenAddress address of added foreign token
240    * @param name name of added token
241    * @param rate number of token units a buyer gets per added foreign token unit
242    */
243   event AddReceivedToken(
244     address indexed tokenAddress,
245     string name,
246     uint256 rate
247   );
248 
249   /**
250    * Event for remove received token logging
251    * @param tokenAddress address of removed foreign token
252    */
253   event RemoveReceivedToken(address indexed tokenAddress);
254 
255   /**
256    * Event for set new received token rate logging
257    * @param tokenAddress address of foreign token
258    * @param newRate new number of token units a buyer gets per added foreign token unit
259    */
260   event SetReceivedTokenRate(
261     address indexed tokenAddress,
262     uint256 newRate
263   );
264 
265   /**
266    * Event for send excess ether logging
267    * @param beneficiary who gets excess ether
268    * @param value excess weis
269    */
270   event SendEtherExcess(
271     address indexed beneficiary,
272     uint256 value
273   );
274 
275   /**
276    * Event for send tokens excess logging
277    * @param beneficiary who gets tokens excess
278    * @param value excess token units
279    */
280   event SendTokensExcess(
281     address indexed beneficiary,
282     uint256 value
283   );
284 
285   /**
286    * Event for logging received tokens from approveAndCall function
287    * @param from who send tokens
288    * @param amount amount of received purchased
289    * @param tokenAddress address of token contract
290    * @param extraData data attached to payment
291    */
292   event ReceivedTokens(
293     address indexed from,
294     uint256 amount,
295     address indexed tokenAddress,
296     bytes extraData
297   );
298 
299 
300   /**
301    * @param _rate Number of token units a buyer gets per wei
302    * @param _wallet Address where collected funds will be forwarded to
303    * @param _token Address of the token being sold
304    */
305   constructor (
306     uint256 _rate,
307     address _wallet,
308     ERC20 _token
309   )
310     public
311   {
312     require(_rate > 0);
313     require(_wallet != address(0));
314     require(_token != address(0));
315 
316     rate = _rate;
317     wallet = _wallet;
318     token = _token;
319   }
320 
321 
322   // -----------------------------------------
323   // External interface
324   // -----------------------------------------
325 
326   /**
327  * @dev fallback function ***DO NOT OVERRIDE***
328  */
329   function () whenNotPaused external payable {
330     buyTokens(msg.sender);
331   }
332 
333   /**
334    * @dev low level token purchase ***DO NOT OVERRIDE***
335    * @param _beneficiary Address performing the token purchase
336    */
337   function buyTokens(address _beneficiary) whenNotPaused public payable {
338     require(_beneficiary != address(0));
339 
340     uint256 weiAmount = msg.value;
341     require(weiAmount != 0);
342 
343     uint256 tokenBalance = token.balanceOf(address(this));
344     require(tokenBalance > 0);
345 
346     uint256 tokens = _getTokenAmount(address(0), weiAmount);
347 
348     if (tokens > tokenBalance) {
349       tokens = tokenBalance;
350       weiAmount = _inverseGetTokenAmount(address(0), tokens);
351 
352       uint256 senderExcess = msg.value.sub(weiAmount);
353       msg.sender.transfer(senderExcess);
354 
355       emit SendEtherExcess(
356         msg.sender,
357         senderExcess
358       );
359     }
360 
361     weiRaised = weiRaised.add(weiAmount);
362 
363     _processPurchase(_beneficiary, tokens);
364     emit TokenPurchase(
365       msg.sender,
366       _beneficiary,
367       weiAmount,
368       tokens
369     );
370   }
371 
372   /**
373    * @dev Sets new rate.
374    * @param _newRate New number of token units a buyer gets per wei
375    */
376   function setRate(uint256 _newRate) onlyOwner external {
377     require(_newRate > 0);
378     rate = _newRate;
379 
380     emit ChangeRate(_newRate);
381   }
382 
383   /**
384    * @dev Set new wallet address.
385    * @param _newWallet New address where collected funds will be forwarded to
386    */
387   function setWallet(address _newWallet) onlyOwner external {
388     require(_newWallet != address(0));
389     wallet = _newWallet;
390   }
391 
392   /**
393    * @dev Set new token address.
394    * @param _newToken New address of the token being sold
395    */
396   function setToken(ERC20 _newToken) onlyOwner external {
397     require(_newToken != address(0));
398     token = _newToken;
399   }
400 
401   /**
402    * @dev Withdraws any tokens from this contract to wallet.
403    * @param _tokenContract The address of the foreign token
404    */
405   function withdrawTokens(ERC20 _tokenContract) onlyOwner external {
406     require(_tokenContract != address(0));
407 
408     uint256 amount = _tokenContract.balanceOf(address(this));
409     _tokenContract.transfer(wallet, amount);
410   }
411 
412   /**
413    * @dev Withdraws all ether from this contract to wallet.
414    */
415   function withdraw() onlyOwner external {
416     wallet.transfer(address(this).balance);
417   }
418 
419   /**
420    * @dev Adds received foreign token.
421    * @param _tokenAddress Address of the foreign token being added
422    * @param _tokenName Name of the foreign token
423    * @param _tokenRate Number of token units a buyer gets per foreign token unit
424    */
425   function addReceivedToken(
426     ERC20 _tokenAddress,
427     string _tokenName,
428     uint256 _tokenRate
429   )
430     onlyOwner
431     external
432   {
433     require(_tokenAddress != address(0));
434     require(_tokenRate > 0);
435 
436     ReceivedToken memory _token = ReceivedToken({
437       name: _tokenName,
438       rate: _tokenRate,
439       raised: 0
440     });
441 
442     receivedTokens[_tokenAddress] = _token;
443 
444     emit AddReceivedToken(
445       _tokenAddress,
446       _token.name,
447       _token.rate
448     );
449   }
450 
451   /**
452    * @dev Removes received foreign token.
453    * @param _tokenAddress Address of the foreign token being removed
454    */
455   function removeReceivedToken(ERC20 _tokenAddress) onlyOwner external {
456     require(_tokenAddress != address(0));
457 
458     delete receivedTokens[_tokenAddress];
459 
460     emit RemoveReceivedToken(_tokenAddress);
461   }
462 
463   /**
464    * @dev Sets new rate for received foreign token.
465    * @param _tokenAddress Address of the foreign token
466    * @param _newTokenRate New number of token units a buyer gets per foreign token unit
467    */
468   function setReceivedTokenRate(
469     ERC20 _tokenAddress,
470     uint256 _newTokenRate
471   )
472     onlyOwner
473     external
474   {
475     require(_tokenAddress != address(0));
476     require(receivedTokens[_tokenAddress].rate > 0);
477     require(_newTokenRate > 0);
478 
479     receivedTokens[_tokenAddress].rate = _newTokenRate;
480 
481     emit SetReceivedTokenRate(
482       _tokenAddress,
483       _newTokenRate
484     );
485   }
486 
487   /**
488    * @dev Receives approved foreign tokens and exchange them to tokens.
489    * @param _from Address of foreign tokens sender
490    * @param _amount Amount of the foreign tokens
491    * @param _tokenAddress Address of the foreign token contract
492    * @param _extraData Data attached to payment
493    */
494   function receiveApproval(
495     address _from,
496     uint256 _amount,
497     address _tokenAddress,
498     bytes _extraData
499   )
500     whenNotPaused external
501   {
502 
503     require(_from != address(0));
504     require(_tokenAddress != address(0));
505     require(receivedTokens[_tokenAddress].rate > 0); // check: token in receivedTokens
506     require(_amount > 0);
507 
508     require(msg.sender == _tokenAddress);
509 
510     emit ReceivedTokens(
511       _from,
512       _amount,
513       _tokenAddress,
514       _extraData
515     );
516 
517     _exchangeTokens(ERC20(_tokenAddress), _from, _amount);
518   }
519 
520   /**
521    * @dev Deposits foreign token and exchange them to tokens.
522    * @param _tokenAddress Address of the foreign token
523    * @param _amount Amount of the foreign tokens
524    */
525   function depositToken(
526     ERC20 _tokenAddress,
527     uint256 _amount
528   )
529     whenNotPaused external
530   {
531     // Remember to call ERC20(address).approve(this, amount)
532     // or this contract will not be able to do the transfer on your behalf
533     require(_tokenAddress != address(0));
534 
535     require(receivedTokens[_tokenAddress].rate > 0);
536     require(_amount > 0);
537 
538     _exchangeTokens(_tokenAddress, msg.sender, _amount);
539   }
540 
541 
542   // -----------------------------------------
543   // Internal interface
544   // -----------------------------------------
545 
546   /**
547    * @dev Exchanges foreign tokens to self token. Low-level exchange method.
548    * @param _tokenAddress Address of the foreign token contract
549    * @param _sender Sender address
550    * @param _amount Number of tokens for exchange
551    */
552   function _exchangeTokens(
553     ERC20 _tokenAddress,
554     address _sender,
555     uint256 _amount
556   )
557     internal
558   {
559     uint256 foreignTokenAmount = _amount;
560 
561     require(_tokenAddress.transferFrom(_sender, address(this), foreignTokenAmount));
562 
563     uint256 tokenBalance = token.balanceOf(address(this));
564     require(tokenBalance > 0);
565 
566     uint256 tokens = _getTokenAmount(_tokenAddress, foreignTokenAmount);
567 
568     if (tokens > tokenBalance) {
569       tokens = tokenBalance;
570       foreignTokenAmount = _inverseGetTokenAmount(_tokenAddress, tokens);
571 
572       uint256 senderForeignTokenExcess = _amount.sub(foreignTokenAmount);
573       _tokenAddress.transfer(_sender, senderForeignTokenExcess);
574 
575       emit SendTokensExcess(
576         _sender,
577         senderForeignTokenExcess
578       );
579     }
580 
581     receivedTokens[_tokenAddress].raised = receivedTokens[_tokenAddress].raised.add(foreignTokenAmount);
582 
583     _processPurchase(_sender, tokens);
584     emit TokenForTokenPurchase(
585       _sender,
586       _sender,
587       foreignTokenAmount,
588       tokens
589     );
590   }
591 
592   /**
593    * @dev Source of tokens.
594    * @param _beneficiary Address performing the token purchase
595    * @param _tokenAmount Number of tokens to be emitted
596    */
597   function _deliverTokens(
598     address _beneficiary,
599     uint256 _tokenAmount
600   )
601     internal
602   {
603     token.transfer(_beneficiary, _tokenAmount);
604   }
605 
606   /**
607    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
608    * @param _beneficiary Address receiving the tokens
609    * @param _tokenAmount Number of tokens to be purchased
610    */
611   function _processPurchase(
612     address _beneficiary,
613     uint256 _tokenAmount
614   )
615     internal
616   {
617     _deliverTokens(_beneficiary, _tokenAmount);
618   }
619 
620   /**
621    * @dev Override to extend the way in which ether or foreign token unit is converted to tokens.
622    * @param _tokenAddress Address of foreign token or 0 if ether to tokens
623    * @param _amount Value in wei or foreign token units to be converted into tokens
624    * @return Number of tokens that can be purchased with the specified _amount (wei or foreign token units)
625    */
626   function _getTokenAmount(address _tokenAddress, uint256 _amount)
627     internal view returns (uint256)
628   {
629     uint256 _rate;
630 
631     if (_tokenAddress == address(0)) {
632       _rate = rate;
633     } else {
634       _rate = receivedTokens[_tokenAddress].rate;
635     }
636 
637     return _amount.mul(_rate);
638   }
639 
640   /**
641    * @dev Get wei or foreign tokens amount. Inverse _getTokenAmount method.
642    */
643   function _inverseGetTokenAmount(address _tokenAddress, uint256 _tokenAmount)
644     internal view returns (uint256)
645   {
646     uint256 _rate;
647 
648     if (_tokenAddress == address(0)) {
649       _rate = rate;
650     } else {
651       _rate = receivedTokens[_tokenAddress].rate;
652     }
653 
654     return _tokenAmount.div(_rate);
655   }
656 }