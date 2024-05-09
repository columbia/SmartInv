1 pragma solidity 0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev revert()s if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to. 
33    */
34   function transferOwnership(address newOwner) onlyOwner public {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 
43 
44 /**
45  * Math operations with safety checks
46  */
47 library SafeMath {
48   
49   
50   function mul256(uint256 a, uint256 b) internal returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55 
56   function div256(uint256 a, uint256 b) internal returns (uint256) {
57     require(b > 0); // Solidity automatically revert()s when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub256(uint256 a, uint256 b) internal returns (uint256) {
64     require(b <= a);
65     return a - b;
66   }
67 
68   function add256(uint256 a, uint256 b) internal returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }  
73   
74 
75   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
76     return a >= b ? a : b;
77   }
78 
79   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
80     return a < b ? a : b;
81   }
82 
83   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
84     return a >= b ? a : b;
85   }
86 
87   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
88     return a < b ? a : b;
89   }
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  */
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) constant public returns (uint256);
100   function transfer(address to, uint256 value) public;
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev ERC20 interface with allowances. 
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) constant public returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public;
114   function approve(address spender, uint256 value) public;
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances. 
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   /**
131    * @dev Fix for the ERC20 short address attack.
132    */
133   modifier onlyPayloadSize(uint size) {
134      require(msg.data.length >= size + 4);
135      _;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public {
144     balances[msg.sender] = balances[msg.sender].sub256(_value);
145     balances[_to] = balances[_to].add256(_value);
146     Transfer(msg.sender, _to, _value);
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of. 
152   * @return An uint representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) constant public returns (uint256 balance) {
155     return balances[_owner];
156   }
157 
158 }
159 
160 
161 
162 
163 /**
164  * @title Standard ERC20 token
165  * @dev Implemantation of the basic standart token.
166  */
167 contract StandardToken is BasicToken, ERC20 {
168 
169   mapping (address => mapping (address => uint256)) allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint the amout of tokens to be transfered
177    */
178   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public {
179     var _allowance = allowed[_from][msg.sender];
180 
181     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
182     // if (_value > _allowance) revert();
183 
184     balances[_to] = balances[_to].add256(_value);
185     balances[_from] = balances[_from].sub256(_value);
186     allowed[_from][msg.sender] = _allowance.sub256(_value);
187     Transfer(_from, _to, _value);
188   }
189 
190   /**
191    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public {
196 
197     //  To change the approve amount you first have to reduce the addresses
198     //  allowance to zero by calling `approve(_spender, 0)` if it is not
199     //  already 0 to mitigate the race condition described here:
200     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
202 
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens than an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint specifing the amount of tokens still avaible for the spender.
212    */
213   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
214     return allowed[_owner][_spender];
215   }
216 
217 
218 }
219 
220 
221 
222 /**
223  * @title TeuToken
224  * @dev The main TEU token contract
225  * 
226  */
227  
228 contract TeuToken is StandardToken, Ownable{
229   string public name = "20-footEqvUnit";
230   string public symbol = "TEU";
231   uint public decimals = 18;
232 
233   event TokenBurned(uint256 value);
234   
235   function TeuToken() public {
236     totalSupply = (10 ** 8) * (10 ** decimals);
237     balances[msg.sender] = totalSupply;
238   }
239 
240   /**
241    * @dev Allows the owner to burn the token
242    * @param _value number of tokens to be burned.
243    */
244   function burn(uint _value) onlyOwner public {
245     require(balances[msg.sender] >= _value);
246     balances[msg.sender] = balances[msg.sender].sub256(_value);
247     totalSupply = totalSupply.sub256(_value);
248     TokenBurned(_value);
249   }
250 
251 }
252 
253 /**
254  * @title teuInitialTokenSale 
255  * @dev The TEU token ICO contract
256  * 
257  */
258 contract teuInitialTokenSale is Ownable {
259 	using SafeMath for uint256;
260 
261     event LogContribution(address indexed _contributor, uint256 _etherAmount, uint256 _basicTokenAmount, uint256 _timeBonusTokenAmount, uint256 _volumeBonusTokenAmount);
262     event LogContributionBitcoin(address indexed _contributor, uint256 _bitcoinAmount, uint256 _etherAmount, uint256 _basicTokenAmount, uint256 _timeBonusTokenAmount, uint256 _volumeBonusTokenAmount, uint _contributionDatetime);
263     event LogOffChainContribution(address indexed _contributor, uint256 _etherAmount, uint256 _tokenAmount);
264     event LogReferralAward(address indexed _refereeWallet, address indexed _referrerWallet, uint256 _referralBonusAmount);
265     event LogTokenCollected(address indexed _contributor, uint256 _collectedTokenAmount);
266     event LogClientIdentRejectListChange(address indexed _contributor, uint8 _newValue);
267 
268 
269     TeuToken			                constant private		token = TeuToken(0xeEAc3F8da16bb0485a4A11c5128b0518DaC81448); // hard coded due to token already deployed
270     address		                        constant private		etherHolderWallet = 0x00222EaD2D0F83A71F645d3d9634599EC8222830; // hard coded due to deployment for once only
271     uint256		                        constant private 	    minContribution = 100 finney;
272     uint                                         public         saleStart = 1523498400;
273     uint                                         public         saleEnd = 1526090400;
274     uint                                constant private        etherToTokenConversionRate = 400;
275     uint                                constant private        referralAwardPercent = 20;
276     uint256                             constant private        maxCollectableToken = 20 * 10 ** 6 * 10 ** 18;
277 
278     mapping (address => uint256)                private     referralContribution;  // record the referral contribution amount in ether for claiming of referral bonus
279     mapping (address => uint)                   private     lastContribitionDate;  // record the last contribution date/time for valid the referral bonus claiming period
280 
281     mapping (address => uint256)                private     collectableToken;  // record the token amount to be collected of each contributor
282     mapping (address => uint8)                  private     clientIdentRejectList;  // record a list of contributors who do not pass the client identification process
283     bool                                        public      isCollectTokenStart = false;  // flag to indicate if token collection is started
284     bool                                        public      isAllowContribution = true; // flag to enable/disable contribution.
285     uint256                                     public      totalCollectableToken;  // the total amount of token will be colleceted after considering all the contribution and bonus
286 
287     //  ***** private helper functions ***************
288 
289     
290 
291     /**
292     * @dev get the current datetime
293     */   
294     function getCurrentDatetime() private constant returns (uint) {
295         return now; 
296     }
297 
298     /**
299     * @dev get the current sale day
300     */   
301     function getCurrentSaleDay() private saleIsOn returns (uint) {
302         return getCurrentDatetime().sub256(saleStart).div256(86400).add256(1);
303     }
304 
305     /**
306     * @dev to get the time bonus Percentage based on the no. of sale day(s)
307     * @param _days no of sale day to calculate the time bonus
308     */      
309     function getTimeBonusPercent(uint _days) private pure returns (uint) {
310         if (_days <= 10)
311             return 50;
312         return 0;
313     }
314 
315     /**
316     * @dev to get the volumne bonus percentage based on the ether amount contributed
317     * @param _etherAmount ether amount contributed.
318     */          
319     function getVolumeBonusPercent(uint256 _etherAmount) private pure returns (uint) {
320 
321         if (_etherAmount < 1 ether)
322             return 0;
323         if (_etherAmount < 2 ether)
324             return 35;
325         if (_etherAmount < 3 ether)
326             return 40;
327         if (_etherAmount < 4 ether)
328             return 45;
329         if (_etherAmount < 5 ether)
330             return 50;
331         if (_etherAmount < 10 ether)
332             return 55;
333         if (_etherAmount < 20 ether)
334             return 60;
335         if (_etherAmount < 30 ether)
336             return 65;
337         if (_etherAmount < 40 ether)
338             return 70;
339         if (_etherAmount < 50 ether)
340             return 75;
341         if (_etherAmount < 100 ether)
342             return 80;
343         if (_etherAmount < 200 ether)
344             return 90;
345         if (_etherAmount >= 200 ether)
346             return 100;
347         return 0;
348     }
349     
350     /**
351     * @dev to get the time bonus amount given the token amount to be collected from contribution
352     * @param _tokenAmount token amount to be collected from contribution
353     */ 
354     function getTimeBonusAmount(uint256 _tokenAmount) private returns (uint256) {
355         return _tokenAmount.mul256(getTimeBonusPercent(getCurrentSaleDay())).div256(100);
356     }
357     
358     /**
359     * @dev to get the volume bonus amount given the token amount to be collected from contribution and the ether amount contributed
360     * @param _tokenAmount token amount to be collected from contribution
361     * @param _etherAmount ether amount contributed
362     */
363     function getVolumeBonusAmount(uint256 _tokenAmount, uint256 _etherAmount) private returns (uint256) {
364         return _tokenAmount.mul256(getVolumeBonusPercent(_etherAmount)).div256(100);
365     }
366     
367     /**
368     * @dev to get the referral bonus amount given the ether amount contributed
369     * @param _etherAmount ether amount contributed
370     */
371     function getReferralBonusAmount(uint256 _etherAmount) private returns (uint256) {
372         return _etherAmount.mul256(etherToTokenConversionRate).mul256(referralAwardPercent).div256(100);
373     }
374     
375     /**
376     * @dev to get the basic amount of token to be collected given the ether amount contributed
377     * @param _etherAmount ether amount contributed
378     */
379     function getBasicTokenAmount(uint256 _etherAmount) private returns (uint256) {
380         return _etherAmount.mul256(etherToTokenConversionRate);
381     }
382   
383   
384     // ****** modifiers  ************
385 
386     /**
387     * @dev modifier to allow contribution only when the sale is ON
388     */
389     modifier saleIsOn() {
390         require(getCurrentDatetime() >= saleStart && getCurrentDatetime() < saleEnd);
391         _;
392     }
393 
394     /**
395     * @dev modifier to check if the sale is ended
396     */    
397     modifier saleIsEnd() {
398         require(getCurrentDatetime() >= saleEnd);
399         _;
400     }
401 
402     /**
403     * @dev modifier to check if token is collectable
404     */    
405     modifier tokenIsCollectable() {
406         require(isCollectTokenStart);
407         _;
408     }
409     
410     /**
411     * @dev modifier to check if contribution is over the min. contribution amount
412     */    
413     modifier overMinContribution(uint256 _etherAmount) {
414         require(_etherAmount >= minContribution);
415         _;
416     }
417     
418     /**
419     * @dev modifier to check if max. token pool is not reached
420     */
421     modifier underMaxTokenPool() {
422         require(maxCollectableToken > totalCollectableToken);
423         _;
424     }
425 
426     /**
427     * @dev modifier to check if contribution is allowed
428     */
429     modifier contributionAllowed() {
430         require(isAllowContribution);
431         _;
432     }
433 
434 
435     //  ***** public transactional functions ***************
436     /**
437     * @dev called by owner to set the new sale start date/time 
438     * @param _newStart new start date/time
439     */
440     function setNewStart(uint _newStart) public onlyOwner {
441 	require(saleStart > getCurrentDatetime());
442         require(_newStart > getCurrentDatetime());
443 	require(saleEnd > _newStart);
444         saleStart = _newStart;
445     }
446 
447     /**
448     * @dev called by owner to set the new sale end date/time 
449     * @param _newEnd new end date/time
450     */
451     function setNewEnd(uint _newEnd) public onlyOwner {
452 	require(saleEnd < getCurrentDatetime());
453         require(_newEnd < getCurrentDatetime());
454 	require(_newEnd > saleStart);
455         saleEnd = _newEnd;
456     }
457 
458     /**
459     * @dev called by owner to enable / disable contribution 
460     * @param _isAllow true - allow contribution; false - disallow contribution
461     */
462     function enableContribution(bool _isAllow) public onlyOwner {
463         isAllowContribution = _isAllow;
464     }
465 
466 
467     /**
468     * @dev called by contributors to record a contribution 
469     */
470     function contribute() public payable saleIsOn overMinContribution(msg.value) underMaxTokenPool contributionAllowed {
471         uint256 _basicToken = getBasicTokenAmount(msg.value);
472         uint256 _timeBonus = getTimeBonusAmount(_basicToken);
473         uint256 _volumeBonus = getVolumeBonusAmount(_basicToken, msg.value);
474         uint256 _totalToken = _basicToken.add256(_timeBonus).add256(_volumeBonus);
475         
476         lastContribitionDate[msg.sender] = getCurrentDatetime();
477         referralContribution[msg.sender] = referralContribution[msg.sender].add256(msg.value);
478         
479         collectableToken[msg.sender] = collectableToken[msg.sender].add256(_totalToken);
480         totalCollectableToken = totalCollectableToken.add256(_totalToken);
481         assert(etherHolderWallet.send(msg.value));
482 
483         LogContribution(msg.sender, msg.value, _basicToken, _timeBonus, _volumeBonus);
484     }
485 
486     /**
487     * @dev called by contract owner to record a off chain contribution by Bitcoin. The token collection process is the same as those ether contributors
488     * @param _bitcoinAmount bitcoin amount contributed
489     * @param _etherAmount ether equivalent amount contributed
490     * @param _contributorWallet wallet address of contributor which will be used for token collection
491     * @param _contributionDatetime date/time of contribution. For calculating time bonus and claiming referral bonus.
492     */
493     function contributeByBitcoin(uint256 _bitcoinAmount, uint256 _etherAmount, address _contributorWallet, uint _contributionDatetime) public overMinContribution(_etherAmount) onlyOwner contributionAllowed {
494         require(_contributionDatetime <= getCurrentDatetime());
495 
496         uint256 _basicToken = getBasicTokenAmount(_etherAmount);
497         uint256 _timeBonus = getTimeBonusAmount(_basicToken);
498         uint256 _volumeBonus = getVolumeBonusAmount(_basicToken, _etherAmount);
499         uint256 _totalToken = _basicToken.add256(_timeBonus).add256(_volumeBonus);
500         
501 	    if (_contributionDatetime > lastContribitionDate[_contributorWallet])
502             lastContribitionDate[_contributorWallet] = _contributionDatetime;
503         referralContribution[_contributorWallet] = referralContribution[_contributorWallet].add256(_etherAmount);
504     
505         collectableToken[_contributorWallet] = collectableToken[_contributorWallet].add256(_totalToken);
506         totalCollectableToken = totalCollectableToken.add256(_totalToken);
507         LogContributionBitcoin(_contributorWallet, _bitcoinAmount, _etherAmount, _basicToken, _timeBonus, _volumeBonus, _contributionDatetime);
508     }
509     
510     /**
511     * @dev called by contract owner to record a off chain contribution by Ether. The token are distributed off chain already.  The contributor can only entitle referral bonus through this smart contract
512     * @param _etherAmount ether equivalent amount contributed
513     * @param _contributorWallet wallet address of contributor which will be used for referral bonus collection
514     * @param _tokenAmount amunt of token distributed to the contributor. For reference only in the event log
515     */
516     function recordOffChainContribute(uint256 _etherAmount, address _contributorWallet, uint256 _tokenAmount) public overMinContribution(_etherAmount) onlyOwner {
517 
518         lastContribitionDate[_contributorWallet] = getCurrentDatetime();
519         LogOffChainContribution(_contributorWallet, _etherAmount, _tokenAmount);
520     }    
521 
522     /**
523     * @dev called by contributor to claim the referral bonus
524     * @param _referrerWallet wallet address of referrer.  Referrer must also be a contributor
525     */
526     function referral(address _referrerWallet) public {
527 	require (msg.sender != _referrerWallet);
528         require (referralContribution[msg.sender] > 0);
529         require (lastContribitionDate[_referrerWallet] > 0);
530         require (getCurrentDatetime() - lastContribitionDate[msg.sender] <= (4 * 24 * 60 * 60));
531         
532         uint256 _referralBonus = getReferralBonusAmount(referralContribution[msg.sender]);
533         referralContribution[msg.sender] = 0;
534         
535         collectableToken[msg.sender] = collectableToken[msg.sender].add256(_referralBonus);
536         collectableToken[_referrerWallet] = collectableToken[_referrerWallet].add256(_referralBonus);
537         totalCollectableToken = totalCollectableToken.add256(_referralBonus).add256(_referralBonus);
538         LogReferralAward(msg.sender, _referrerWallet, _referralBonus);
539     }
540     
541     /**
542     * @dev called by contract owener to register a list of rejected clients who cannot pass the client identification process.
543     * @param _clients an array of wallet address clients to be set
544     * @param _valueToSet  1 - add to reject list, 0 - remove from reject list
545     */
546     function setClientIdentRejectList(address[] _clients, uint8 _valueToSet) public onlyOwner {
547         for (uint i = 0; i < _clients.length; i++) {
548             if (_clients[i] != address(0) && clientIdentRejectList[_clients[i]] != _valueToSet) {
549                 clientIdentRejectList[_clients[i]] = _valueToSet;
550                 LogClientIdentRejectListChange(_clients[i], _valueToSet);
551             }
552         }
553     }
554     
555     /**
556     * @dev called by contract owner to enable / disable token collection process
557     * @param _enable true - enable collection; false - disable collection
558     */
559     function setTokenCollectable(bool _enable) public onlyOwner saleIsEnd {
560         isCollectTokenStart = _enable;
561     }
562     
563     /**
564     * @dev called by contributor to collect tokens.  If they are rejected by the client identification process, error will be thrown
565     */
566     function collectToken() public tokenIsCollectable {
567 	uint256 _collToken = collectableToken[msg.sender];
568 
569 	require(clientIdentRejectList[msg.sender] <= 0);
570         require(_collToken > 0);
571 
572         collectableToken[msg.sender] = 0;
573 
574         token.transfer(msg.sender, _collToken);
575         LogTokenCollected(msg.sender, _collToken);
576     }
577 
578     /**
579     * @dev Allow owner to transfer out the token left in the contract
580     * @param _to address to transfer to
581     * @param _amount amount to transfer
582     */  
583     function transferTokenOut(address _to, uint256 _amount) public onlyOwner {
584         token.transfer(_to, _amount);
585     }
586     
587     /**
588     * @dev Allow owner to transfer out the ether left in the contract
589     * @param _to address to transfer to
590     * @param _amount amount to transfer
591     */  
592     function transferEtherOut(address _to, uint256 _amount) public onlyOwner {
593         assert(_to.send(_amount));
594     }  
595     
596 
597     //  ***** public constant functions ***************
598 
599     /**
600     * @dev to get the amount of token collectable by any contributor
601     * @param _contributor contributor to get amont
602     */  
603     function collectableTokenOf(address _contributor) public constant returns (uint256) {
604         return collectableToken[_contributor] ;
605     }
606     
607     /**
608     * @dev to get the amount of token collectable by any contributor
609     * @param _contributor contributor to get amont
610     */  
611     function isClientIdentRejectedOf(address _contributor) public constant returns (uint8) {
612         return clientIdentRejectList[_contributor];
613     }    
614     
615     /**
616     * @dev Fallback function which receives ether and create the appropriate number of tokens for the 
617     * msg.sender.
618     */
619     function() external payable {
620         contribute();
621     }
622 
623 }