1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract BasicToken is ERC20Basic {
18   using SafeMath for uint256;
19 
20   mapping(address => uint256) balances;
21 
22   uint256 totalSupply_;
23 
24   /**
25   * @dev total number of tokens in existence
26   */
27   function totalSupply() public view returns (uint256) {
28     return totalSupply_;
29   }
30 
31   /**
32   * @dev transfer token for a specified address
33   * @param _to The address to transfer to.
34   * @param _value The amount to be transferred.
35   */
36   function transfer(address _to, uint256 _value) public returns (bool) {
37     require(_to != address(0));
38     require(_value <= balances[msg.sender]);
39 
40     // SafeMath.sub will throw if there is not enough balance.
41     balances[msg.sender] = balances[msg.sender].sub(_value);
42     balances[_to] = balances[_to].add(_value);
43     Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 
47   /**
48   * @dev Gets the balance of the specified address.
49   * @param _owner The address to query the the balance of.
50   * @return An uint256 representing the amount owned by the passed address.
51   */
52   function balanceOf(address _owner) public view returns (uint256 balance) {
53     return balances[_owner];
54   }
55 
56 }
57 
58 contract StandardToken is ERC20, BasicToken {
59 
60   mapping (address => mapping (address => uint256)) internal allowed;
61 
62 
63   /**
64    * @dev Transfer tokens from one address to another
65    * @param _from address The address which you want to send tokens from
66    * @param _to address The address which you want to transfer to
67    * @param _value uint256 the amount of tokens to be transferred
68    */
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
70     require(_to != address(0));
71     require(_value <= balances[_from]);
72     require(_value <= allowed[_from][msg.sender]);
73 
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77     Transfer(_from, _to, _value);
78     return true;
79   }
80 
81   /**
82    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
83    *
84    * Beware that changing an allowance with this method brings the risk that someone may use both the old
85    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
86    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
87    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88    * @param _spender The address which will spend the funds.
89    * @param _value The amount of tokens to be spent.
90    */
91   function approve(address _spender, uint256 _value) public returns (bool) {
92     allowed[msg.sender][_spender] = _value;
93     Approval(msg.sender, _spender, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Function to check the amount of tokens that an owner allowed to a spender.
99    * @param _owner address The address which owns the funds.
100    * @param _spender address The address which will spend the funds.
101    * @return A uint256 specifying the amount of tokens still available for the spender.
102    */
103   function allowance(address _owner, address _spender) public view returns (uint256) {
104     return allowed[_owner][_spender];
105   }
106 
107   /**
108    * @dev Increase the amount of tokens that an owner allowed to a spender.
109    *
110    * approve should be called when allowed[_spender] == 0. To increment
111    * allowed value is better to use this function to avoid 2 calls (and wait until
112    * the first transaction is mined)
113    * From MonolithDAO Token.sol
114    * @param _spender The address which will spend the funds.
115    * @param _addedValue The amount of tokens to increase the allowance by.
116    */
117   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
118     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
119     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 
123   /**
124    * @dev Decrease the amount of tokens that an owner allowed to a spender.
125    *
126    * approve should be called when allowed[_spender] == 0. To decrement
127    * allowed value is better to use this function to avoid 2 calls (and wait until
128    * the first transaction is mined)
129    * From MonolithDAO Token.sol
130    * @param _spender The address which will spend the funds.
131    * @param _subtractedValue The amount of tokens to decrease the allowance by.
132    */
133   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
134     uint oldValue = allowed[msg.sender][_spender];
135     if (_subtractedValue > oldValue) {
136       allowed[msg.sender][_spender] = 0;
137     } else {
138       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
139     }
140     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141     return true;
142   }
143 
144 }
145 
146 library SafeMath {
147 
148   /**
149   * @dev Multiplies two numbers, throws on overflow.
150   */
151   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152     if (a == 0) {
153       return 0;
154     }
155     uint256 c = a * b;
156     assert(c / a == b);
157     return c;
158   }
159 
160   /**
161   * @dev Integer division of two numbers, truncating the quotient.
162   */
163   function div(uint256 a, uint256 b) internal pure returns (uint256) {
164     // assert(b > 0); // Solidity automatically throws when dividing by 0
165     uint256 c = a / b;
166     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167     return c;
168   }
169 
170   /**
171   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
172   */
173   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174     assert(b <= a);
175     return a - b;
176   }
177 
178   /**
179   * @dev Adds two numbers, throws on overflow.
180   */
181   function add(uint256 a, uint256 b) internal pure returns (uint256) {
182     uint256 c = a + b;
183     assert(c >= a);
184     return c;
185   }
186 }
187 
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() public {
200     owner = msg.sender;
201   }
202 
203   /**
204    * @dev Throws if called by any account other than the owner.
205    */
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211   /**
212    * @dev Allows the current owner to transfer control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function transferOwnership(address newOwner) public onlyOwner {
216     require(newOwner != address(0));
217     OwnershipTransferred(owner, newOwner);
218     owner = newOwner;
219   }
220 
221 }
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   /**
236    * @dev Function to mint tokens
237    * @param _to The address that will receive the minted tokens.
238    * @param _amount The amount of tokens to mint.
239    * @return A boolean that indicates if the operation was successful.
240    */
241   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
242     totalSupply_ = totalSupply_.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     Transfer(address(0), _to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() onlyOwner canMint public returns (bool) {
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 }
259 
260 contract NectarToken is MintableToken {
261     string public name = "Nectar";
262     string public symbol = "NCT";
263     uint8 public decimals = 18;
264 
265     bool public transfersEnabled = false;
266     event TransfersEnabled();
267 
268     // Disable transfers until after the sale
269     modifier whenTransfersEnabled() {
270         require(transfersEnabled);
271         _;
272     }
273 
274     modifier whenTransfersNotEnabled() {
275         require(!transfersEnabled);
276         _;
277     }
278 
279     function enableTransfers() onlyOwner whenTransfersNotEnabled public {
280         transfersEnabled = true;
281         TransfersEnabled();
282     }
283 
284     function transfer(address to, uint256 value) public whenTransfersEnabled returns (bool) {
285         return super.transfer(to, value);
286     }
287 
288     function transferFrom(address from, address to, uint256 value) public whenTransfersEnabled returns (bool) {
289         return super.transferFrom(from, to, value);
290     }
291 
292     // Approves and then calls the receiving contract
293     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
294         allowed[msg.sender][_spender] = _value;
295         Approval(msg.sender, _spender, _value);
296 
297         // call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
298         // receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
299         // it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
300 
301         // solium-disable-next-line security/no-low-level-calls
302         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
303         return true;
304     }
305 }
306 
307 contract Pausable is Ownable {
308   event Pause();
309   event Unpause();
310 
311   bool public paused = false;
312 
313 
314   /**
315    * @dev Modifier to make a function callable only when the contract is not paused.
316    */
317   modifier whenNotPaused() {
318     require(!paused);
319     _;
320   }
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is paused.
324    */
325   modifier whenPaused() {
326     require(paused);
327     _;
328   }
329 
330   /**
331    * @dev called by the owner to pause, triggers stopped state
332    */
333   function pause() onlyOwner whenNotPaused public {
334     paused = true;
335     Pause();
336   }
337 
338   /**
339    * @dev called by the owner to unpause, returns to normal state
340    */
341   function unpause() onlyOwner whenPaused public {
342     paused = false;
343     Unpause();
344   }
345 }
346 
347 contract NectarCrowdsale is Ownable, Pausable {
348     using SafeMath for uint256;
349 
350     /** Maximum amount to raise in USD based on initial exchange rate */
351     uint256 constant maxCapUsd = 50000000;
352     /** Minumum amount per purchase in USD based on initial exchange rate*/
353     uint256 constant minimumPurchaseUsd = 100;
354 
355     /** Tranche parameters */
356     uint256 constant tranche1ThresholdUsd = 5000000;
357     uint256 constant tranche1Rate = 37604;
358     uint256 constant tranche2ThresholdUsd = 10000000;
359     uint256 constant tranche2Rate = 36038;
360     uint256 constant tranche3ThresholdUsd = 15000000;
361     uint256 constant tranche3Rate = 34471;
362     uint256 constant tranche4ThresholdUsd = 20000000;
363     uint256 constant tranche4Rate = 32904;
364     uint256 constant standardTrancheRate= 31337;
365 
366     /** The token being sold */
367     NectarToken public token;
368 
369     /** Start timestamp when token purchases are allowed, inclusive */
370     uint256 public startTime;
371 
372     /** End timestamp when token purchases are allowed, inclusive */
373     uint256 public endTime;
374 
375     /** Set value of wei/usd used in cap and minimum purchase calculation */
376     uint256 public weiUsdExchangeRate;
377 
378     /** Address where funds are collected */
379     address public wallet;
380 
381     /** Address used to sign purchase authorizations */
382     address public purchaseAuthorizer;
383 
384     /** Total amount of raised money in wei */
385     uint256 public weiRaised;
386 
387     /** Cap in USD */
388     uint256 public capUsd;
389 
390     /** Maximum amount of raised money in wei */
391     uint256 public cap;
392 
393     /** Minumum amount of wei per purchase */
394     uint256 public minimumPurchase;
395 
396     /** Have we canceled the sale? */
397     bool public isCanceled;
398 
399     /** have we finalized the sale? */
400     bool public isFinalized;
401 
402     /** Record of nonces -> purchases */
403     mapping (uint256 => bool) public purchases;
404 
405     /**
406      * Event triggered on presale minting
407      * @param purchaser who paid for the tokens
408      * @param amount amount of tokens minted
409      */
410     event PreSaleMinting(address indexed purchaser, uint256 amount);
411 
412     /**
413      * Event triggered on token purchase
414      * @param purchaser who paid for the tokens
415      * @param value wei paid for purchase
416      * @param amount amount of tokens purchased
417      */
418     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
419 
420     /** Event triggered on sale cancelation */
421     event Canceled();
422 
423     /** Event triggered on sale finalization */
424     event Finalized();
425 
426     /**
427      * NectarCrowdsale constructor
428      * @param _startTime start timestamp when purchases are allowed, inclusive
429      * @param _endTime end timestamp when purchases are allowed, inclusive
430      * @param _initialWeiUsdExchangeRate initial rate of wei/usd used in cap and minimum purchase calculation
431      * @param _wallet wallet in which to collect the funds
432      * @param _purchaseAuthorizer address to verify purchase authorizations from
433      */
434     function NectarCrowdsale(
435         uint256 _startTime,
436         uint256 _endTime,
437         uint256 _initialWeiUsdExchangeRate,
438         address _wallet,
439         address _purchaseAuthorizer
440     )
441         public
442     {
443         require(_startTime >= now);
444         require(_endTime >= _startTime);
445         require(_initialWeiUsdExchangeRate > 0);
446         require(_wallet != address(0));
447         require(_purchaseAuthorizer != address(0));
448 
449         token = createTokenContract();
450         startTime = _startTime;
451         endTime = _endTime;
452         weiUsdExchangeRate = _initialWeiUsdExchangeRate;
453         wallet = _wallet;
454         purchaseAuthorizer = _purchaseAuthorizer;
455 
456         capUsd = maxCapUsd;
457 
458         // Updates cap and minimumPurchase based on capUsd and weiUsdExchangeRate
459         updateCapAndExchangeRate();
460 
461         isCanceled = false;
462         isFinalized = false;
463     }
464 
465     /** Disable usage of the fallback function, only accept eth from buyTokens */
466     function () external payable {
467         revert();
468     }
469 
470     /** Only allow before the sale period */
471     modifier onlyPreSale() {
472         require(now < startTime);
473         _;
474     }
475 
476     /**
477      * Directly mint tokens and assign to presale buyers
478      * @param purchaser Address to assign to
479      * @param tokenAmount amount of tokens to mint
480      */
481     function mintPreSale(address purchaser, uint256 tokenAmount) public onlyOwner onlyPreSale {
482         require(purchaser != address(0));
483         require(tokenAmount > 0);
484 
485         token.mint(purchaser, tokenAmount);
486         PreSaleMinting(purchaser, tokenAmount);
487     }
488 
489     /**
490      * Buy tokens once authorized by the frontend
491      * @param nonce nonce parameter generated by the frontend
492      * @param authorizedAmount maximum purchase amount authorized for this transaction
493      * @param sig the signature generated by the frontned
494      */
495     function buyTokens(uint256 authorizedAmount, uint256 nonce, bytes sig) public payable whenNotPaused {
496         require(msg.sender != address(0));
497         require(validPurchase(authorizedAmount, nonce, sig));
498 
499         uint256 weiAmount = msg.value;
500 
501         // calculate token amount to be created
502         uint256 rate = currentTranche();
503         uint256 tokens = weiAmount.mul(rate);
504 
505         // update state
506         weiRaised = weiRaised.add(weiAmount);
507         purchases[nonce] = true;
508 
509         token.mint(msg.sender, tokens);
510         TokenPurchase(msg.sender, weiAmount, tokens);
511 
512         forwardFunds();
513     }
514 
515     /** Cancel the sale */
516     function cancel() public onlyOwner {
517         require(!isCanceled);
518         require(!hasEnded());
519 
520         Canceled();
521         isCanceled = true;
522     }
523 
524     /** Finalize the sale */
525     function finalize() public onlyOwner {
526         require(!isFinalized);
527         require(hasEnded());
528 
529         finalization();
530         Finalized();
531 
532         isFinalized = true;
533     }
534 
535     /**
536      * Set exchange rate before sale
537      * @param _weiUsdExchangeRate rate of wei/usd used in cap and minimum purchase calculation
538      */
539     function setExchangeRate(uint256 _weiUsdExchangeRate) public onlyOwner onlyPreSale {
540         require(_weiUsdExchangeRate > 0);
541 
542         weiUsdExchangeRate = _weiUsdExchangeRate;
543         updateCapAndExchangeRate();
544     }
545 
546     /**
547      * Set exchange rate before sale
548      * @param _capUsd new cap in USD
549      */
550     function setCapUsd(uint256 _capUsd) public onlyOwner onlyPreSale {
551         require(_capUsd <= maxCapUsd);
552 
553         capUsd = _capUsd;
554         updateCapAndExchangeRate();
555     }
556 
557     /** Enable token sales once sale is completed */
558     function enableTransfers() public onlyOwner {
559         require(isFinalized);
560         require(hasEnded());
561 
562         token.enableTransfers();
563     }
564 
565     /**
566      * Get the rate of tokens/wei in the current tranche
567      * @return the current tokens/wei rate
568      */
569     function currentTranche() public view returns (uint256) {
570         uint256 currentFundingUsd = weiRaised.div(weiUsdExchangeRate);
571         if (currentFundingUsd <= tranche1ThresholdUsd) {
572             return tranche1Rate;
573         } else if (currentFundingUsd <= tranche2ThresholdUsd) {
574             return tranche2Rate;
575         } else if (currentFundingUsd <= tranche3ThresholdUsd) {
576             return tranche3Rate;
577         } else if (currentFundingUsd <= tranche4ThresholdUsd) {
578             return tranche4Rate;
579         } else {
580             return standardTrancheRate;
581         }
582     }
583 
584     /** @return true if crowdsale event has ended */
585     function hasEnded() public view returns (bool) {
586         bool afterEnd = now > endTime;
587         bool capMet = weiRaised >= cap;
588         return afterEnd || capMet || isCanceled;
589     }
590 
591     /** Get the amount collected in USD, needed for WINGS calculation. */
592     function totalCollected() public view returns (uint256) {
593         uint256 presale = maxCapUsd.sub(capUsd);
594         uint256 crowdsale = weiRaised.div(weiUsdExchangeRate);
595         return presale.add(crowdsale);
596     }
597 
598     /** Creates the token to be sold. */
599     function createTokenContract() internal returns (NectarToken) {
600         return new NectarToken();
601     }
602 
603     /** Create the 30% extra token supply at the end of the sale */
604     function finalization() internal {
605         // Create 30% NCT for company use
606         uint256 tokens = token.totalSupply().mul(3).div(10);
607         token.mint(wallet, tokens);
608     }
609 
610     /** Forward ether to the fund collection wallet */
611     function forwardFunds() internal {
612         wallet.transfer(msg.value);
613     }
614 
615     /** Update parameters dependant on capUsd and eiUsdEchangeRate */
616     function updateCapAndExchangeRate() internal {
617         cap = capUsd.mul(weiUsdExchangeRate);
618         minimumPurchase = minimumPurchaseUsd.mul(weiUsdExchangeRate);
619     }
620 
621     /**
622      * Is a purchase transaction valid?
623      * @return true if the transaction can buy tokens
624      */
625     function validPurchase(uint256 authorizedAmount, uint256 nonce, bytes sig) internal view returns (bool) {
626         // 84 = 20 byte address + 32 byte authorized amount + 32 byte nonce
627         bytes memory prefix = "\x19Ethereum Signed Message:\n84";
628         bytes32 hash = keccak256(prefix, msg.sender, authorizedAmount, nonce);
629         bool validAuthorization = ECRecovery.recover(hash, sig) == purchaseAuthorizer;
630 
631         bool validNonce = !purchases[nonce];
632         bool withinPeriod = now >= startTime && now <= endTime;
633         bool aboveMinimum = msg.value >= minimumPurchase;
634         bool belowAuthorized = msg.value <= authorizedAmount;
635         bool belowCap = weiRaised.add(msg.value) <= cap;
636         return validAuthorization && validNonce && withinPeriod && aboveMinimum && belowAuthorized && belowCap;
637     }
638 }
639 
640 library ECRecovery {
641 
642   /**
643    * @dev Recover signer address from a message by using his signature
644    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
645    * @param sig bytes signature, the signature is generated using web3.eth.sign()
646    */
647   function recover(bytes32 hash, bytes sig) public pure returns (address) {
648     bytes32 r;
649     bytes32 s;
650     uint8 v;
651 
652     //Check the signature length
653     if (sig.length != 65) {
654       return (address(0));
655     }
656 
657     // Divide the signature in r, s and v variables
658     assembly {
659       r := mload(add(sig, 32))
660       s := mload(add(sig, 64))
661       v := byte(0, mload(add(sig, 96)))
662     }
663 
664     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
665     if (v < 27) {
666       v += 27;
667     }
668 
669     // If the version is correct return the signer address
670     if (v != 27 && v != 28) {
671       return (address(0));
672     } else {
673       return ecrecover(hash, v, r, s);
674     }
675   }
676 
677 }