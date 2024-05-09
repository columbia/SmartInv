1 pragma solidity 0.4.25;
2 
3 // File: contracts/lib/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner(), "only owner is able call this function");
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/lib/Pausable.sol
77 
78 /**
79  * @title Pausable
80  * @dev Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83     event Pause();
84     event Unpause();
85 
86     bool private _paused;
87 
88     constructor () internal {
89         _paused = false;
90     }
91 
92     /**
93      * @return true if the contract is paused, false otherwise.
94      */
95     function paused() public view returns (bool) {
96         return _paused;
97     }
98 
99     /**
100      * @dev Modifier to make a function callable only when the contract is not paused.
101      */
102     modifier whenNotPaused() {
103         require(!_paused, "must not be paused");
104         _;
105     }
106 
107     /**
108      * @dev Modifier to make a function callable only when the contract is paused.
109      */
110     modifier whenPaused() {
111         require(_paused, "must be paused");
112         _;
113     }
114 
115     /**
116      * @dev called by the owner to pause, triggers stopped state
117      */
118     function pause() public onlyOwner whenNotPaused {
119         _paused = true;
120         emit Pause();
121     }
122 
123     /**
124      * @dev called by the owner to unpause, returns to normal state
125      */
126     function unpause() onlyOwner whenPaused public {
127         _paused = false;
128         emit Unpause();
129     }
130 }
131 
132 // File: contracts/lib/SafeMath.sol
133 
134 /**
135  * @title SafeMath
136  * @dev Math operations with safety checks that throw on error
137  */
138 library SafeMath {
139 
140   /**
141   * @dev Multiplies two numbers, throws on overflow.
142   */
143   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
144     if (a == 0) {
145       return 0;
146     }
147     c = a * b;
148     assert(c / a == b);
149     return c;
150   }
151 
152   /**
153   * @dev Integer division of two numbers, truncating the quotient.
154   */
155   function div(uint256 a, uint256 b) internal pure returns (uint256) {
156     // assert(b > 0); // Solidity automatically throws when dividing by 0
157     // uint256 c = a / b;
158     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159     return a / b;
160   }
161 
162   /**
163   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
164   */
165   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166     assert(b <= a);
167     return a - b;
168   }
169 
170   /**
171   * @dev Adds two numbers, throws on overflow.
172   */
173   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
174     c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 }
179 
180 // File: contracts/lib/Crowdsale.sol
181 
182 /**
183  * @title Crowdsale - modified from zeppelin-solidity library
184  * @dev Crowdsale is a base contract for managing a token crowdsale.
185  * Crowdsales have a start and end timestamps, where investors can make
186  * token purchases and the crowdsale will assign them tokens based
187  * on a token per ETH rate. Funds collected are forwarded to a wallet
188  * as they arrive.
189  */
190 contract Crowdsale {
191     // start and end timestamps where investments are allowed (both inclusive)
192     uint256 public startTime;
193     uint256 public endTime;
194 
195     // how many token units a buyer gets per wei
196     uint256 public rate;
197 
198     // amount of raised money in wei
199     uint256 public weiRaised;
200 
201 
202     // event for token purchase logging
203     // purchaser who paid for the tokens
204     // beneficiary who got the tokens
205     // value weis paid for purchase
206     // amount amount of tokens purchased
207     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
208 
209     function initCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate) public {
210         require(
211             startTime == 0 && endTime == 0 && rate == 0,
212             "Global variables must be empty when initializing crowdsale!"
213         );
214         require(_startTime >= now, "_startTime must be more than current time!");
215         require(_endTime >= _startTime, "_endTime must be more than _startTime!");
216 
217         startTime = _startTime;
218         endTime = _endTime;
219         rate = _rate;
220     }
221 
222     // @return true if crowdsale event has ended
223     function hasEnded() public view returns (bool) {
224         return now > endTime;
225     }
226 }
227 
228 // File: contracts/lib/FinalizableCrowdsale.sol
229 
230 /**
231  * @title FinalizableCrowdsale
232  * @dev Extension of Crowdsale where an owner can do extra work
233  * after finishing.
234  */
235 contract FinalizableCrowdsale is Crowdsale, Ownable {
236   using SafeMath for uint256;
237 
238   bool public isFinalized = false;
239 
240   event Finalized();
241 
242   /**
243    * @dev Must be called after crowdsale ends, to do some extra finalization
244    * work. Calls the contract's finalization function.
245    */
246   function finalize() onlyOwner public {
247     require(!isFinalized);
248     require(hasEnded());
249 
250     finalization();
251     emit Finalized();
252 
253     isFinalized = true;
254   }
255 
256   /**
257    * @dev Can be overridden to add finalization logic. The overriding function
258    * should call super.finalization() to ensure the chain of finalization is
259    * executed entirely.
260    */
261   function finalization() internal {
262   }
263 }
264 
265 // File: contracts/lib/ERC20Plus.sol
266 
267 /**
268  * @title ERC20 interface with additional functions
269  * @dev it has added functions that deals to minting, pausing token and token information
270  */
271 contract ERC20Plus {
272     function allowance(address owner, address spender) public view returns (uint256);
273     function transferFrom(address from, address to, uint256 value) public returns (bool);
274     function approve(address spender, uint256 value) public returns (bool);
275     function totalSupply() public view returns (uint256);
276     function balanceOf(address who) public view returns (uint256);
277     function transfer(address to, uint256 value) public returns (bool);
278 
279     event Approval(address indexed owner, address indexed spender, uint256 value);
280     event Transfer(address indexed from, address indexed to, uint256 value);
281 
282     // additonal functions
283     function mint(address _to, uint256 _amount) public returns (bool);
284     function owner() public view returns (address);
285     function transferOwnership(address newOwner) public;
286     function name() public view returns (string);
287     function symbol() public view returns (string);
288     function decimals() public view returns (uint8);
289     function paused() public view returns (bool);
290 
291 }
292 
293 // File: contracts/Whitelist.sol
294 
295 /**
296  * @title Whitelist - crowdsale whitelist contract
297  * @author Gustavo Guimaraes - <gustavo@starbase.co>
298  */
299 contract Whitelist is Ownable {
300     mapping(address => bool) public allowedAddresses;
301 
302     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
303 
304     /**
305     * @dev Adds single address to whitelist.
306     * @param _address Address to be added to the whitelist
307     */
308     function addToWhitelist(address _address) external onlyOwner {
309         allowedAddresses[_address] = true;
310         emit WhitelistUpdated(now, "Added", _address);
311     }
312 
313     /**
314      * @dev add various whitelist addresses
315      * @param _addresses Array of ethereum addresses
316      */
317     function addManyToWhitelist(address[] _addresses) external onlyOwner {
318         for (uint256 i = 0; i < _addresses.length; i++) {
319             allowedAddresses[_addresses[i]] = true;
320             emit WhitelistUpdated(now, "Added", _addresses[i]);
321         }
322     }
323 
324     /**
325      * @dev remove whitelist addresses
326      * @param _addresses Array of ethereum addresses
327      */
328     function removeManyFromWhitelist(address[] _addresses) public onlyOwner {
329         for (uint256 i = 0; i < _addresses.length; i++) {
330             allowedAddresses[_addresses[i]] = false;
331             emit WhitelistUpdated(now, "Removed", _addresses[i]);
332         }
333     }
334 }
335 
336 // File: contracts/TokenSaleInterface.sol
337 
338 /**
339  * @title TokenSale contract interface
340  */
341 interface TokenSaleInterface {
342     function init
343     (
344         uint256 _startTime,
345         uint256 _endTime,
346         address _whitelist,
347         address _starToken,
348         address _companyToken,
349         address _tokenOwnerAfterSale,
350         uint256 _rate,
351         uint256 _starRate,
352         address _wallet,
353         uint256 _softCap,
354         uint256 _crowdsaleCap,
355         bool    _isWeiAccepted,
356         bool    _isMinting
357     )
358     external;
359 }
360 
361 // File: contracts/FundsSplitterInterface.sol
362 
363 contract FundsSplitterInterface {
364     function splitFunds() public payable;
365     function splitStarFunds() public;
366 }
367 
368 // File: contracts\TokenSale.sol
369 
370 /**
371  * @title Token Sale contract - crowdsale of company tokens.
372  * @author Gustavo Guimaraes - <gustavo@starbase.co>
373  */
374 contract TokenSale is FinalizableCrowdsale, Pausable {
375     uint256 public softCap;
376     uint256 public crowdsaleCap;
377     uint256 public tokensSold;
378     // amount of raised money in STAR
379     uint256 public starRaised;
380     uint256 public starRate;
381     address public tokenOwnerAfterSale;
382     bool public isWeiAccepted;
383     bool public isMinting;
384 
385     // external contracts
386     Whitelist public whitelist;
387     ERC20Plus public starToken;
388     FundsSplitterInterface public wallet;
389 
390     // The token being sold
391     ERC20Plus public tokenOnSale;
392 
393     event TokenRateChanged(uint256 previousRate, uint256 newRate);
394     event TokenStarRateChanged(uint256 previousStarRate, uint256 newStarRate);
395     event TokenPurchaseWithStar(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
396 
397     /**
398      * @dev initialization function
399      * @param _startTime The timestamp of the beginning of the crowdsale
400      * @param _endTime Timestamp when the crowdsale will finish
401      * @param _whitelist contract containing the whitelisted addresses
402      * @param _starToken STAR token contract address
403      * @param _companyToken ERC20 contract address that has minting capabilities
404      * @param _rate The token rate per ETH
405      * @param _starRate The token rate per STAR
406      * @param _wallet FundsSplitter wallet that redirects funds to client and Starbase.
407      * @param _softCap Soft cap of the token sale
408      * @param _crowdsaleCap Cap for the token sale
409      * @param _isWeiAccepted Bool for acceptance of ether in token sale
410      * @param _isMinting Bool that indicates whether token sale mints ERC20 tokens on sale or simply transfers them
411      */
412     function init(
413         uint256 _startTime,
414         uint256 _endTime,
415         address _whitelist,
416         address _starToken,
417         address _companyToken,
418         address _tokenOwnerAfterSale,
419         uint256 _rate,
420         uint256 _starRate,
421         address _wallet,
422         uint256 _softCap,
423         uint256 _crowdsaleCap,
424         bool    _isWeiAccepted,
425         bool    _isMinting
426     )
427         external
428     {
429         require(
430             whitelist == address(0) &&
431             starToken == address(0) &&
432             tokenOwnerAfterSale == address(0) &&
433             rate == 0 &&
434             starRate == 0 &&
435             tokenOnSale == address(0) &&
436             softCap == 0 &&
437             crowdsaleCap == 0 &&
438             wallet == address(0),
439             "Global variables should not have been set before!"
440         );
441 
442         require(
443             _whitelist != address(0) &&
444             _starToken != address(0) &&
445             !(_rate == 0 && _starRate == 0) &&
446             _companyToken != address(0) &&
447             _softCap != 0 &&
448             _crowdsaleCap != 0 &&
449             _wallet != 0,
450             "Parameter variables cannot be empty!"
451         );
452 
453         require(_softCap < _crowdsaleCap, "SoftCap should be smaller than crowdsaleCap!");
454 
455         if (_isWeiAccepted) {
456             require(_rate > 0, "Set a rate for Wei, when it is accepted for purchases!");
457         } else {
458             require(_rate == 0, "Only set a rate for Wei, when it is accepted for purchases!");
459         }
460 
461         initCrowdsale(_startTime, _endTime, _rate);
462         tokenOnSale = ERC20Plus(_companyToken);
463         whitelist = Whitelist(_whitelist);
464         starToken = ERC20Plus(_starToken);
465         wallet = FundsSplitterInterface(_wallet);
466         tokenOwnerAfterSale = _tokenOwnerAfterSale;
467         starRate = _starRate;
468         isWeiAccepted = _isWeiAccepted;
469         isMinting = _isMinting;
470         _owner = tx.origin;
471 
472         softCap = _softCap.mul(10 ** 18);
473         crowdsaleCap = _crowdsaleCap.mul(10 ** 18);
474 
475         if (isMinting) {
476             require(tokenOwnerAfterSale != address(0), "TokenOwnerAftersale cannot be empty when minting tokens!");
477             require(ERC20Plus(tokenOnSale).paused(), "Company token must be paused upon initialization!");
478         } else {
479             require(tokenOwnerAfterSale == address(0), "TokenOwnerAftersale must be empty when minting tokens!");
480         }
481 
482         require(ERC20Plus(tokenOnSale).decimals() == 18, "Only sales for tokens with 18 decimals are supported!");
483     }
484 
485     modifier isWhitelisted(address beneficiary) {
486         require(whitelist.allowedAddresses(beneficiary), "Beneficiary not whitelisted!");
487         _;
488     }
489 
490     /**
491      * @dev override fallback function. cannot use it
492      */
493     function () external payable {
494         revert("No fallback function defined!");
495     }
496 
497     /**
498      * @dev change crowdsale ETH rate
499      * @param newRate Figure that corresponds to the new ETH rate per token
500      */
501     function setRate(uint256 newRate) external onlyOwner {
502         require(isWeiAccepted, "Sale must allow Wei for purchases to set a rate for Wei!");
503         require(newRate != 0, "ETH rate must be more than 0!");
504 
505         emit TokenRateChanged(rate, newRate);
506         rate = newRate;
507     }
508 
509     /**
510      * @dev change crowdsale STAR rate
511      * @param newStarRate Figure that corresponds to the new STAR rate per token
512      */
513     function setStarRate(uint256 newStarRate) external onlyOwner {
514         require(newStarRate != 0, "Star rate must be more than 0!");
515 
516         emit TokenStarRateChanged(starRate, newStarRate);
517         starRate = newStarRate;
518     }
519 
520     /**
521      * @dev allows sale to receive wei or not
522      */
523     function setIsWeiAccepted(bool _isWeiAccepted, uint256 _rate) external onlyOwner {
524         if (_isWeiAccepted) {
525             require(_rate > 0, "When accepting Wei, you need to set a conversion rate!");
526         } else {
527             require(_rate == 0, "When not accepting Wei, you need to set a conversion rate of 0!");
528         }
529 
530         isWeiAccepted = _isWeiAccepted;
531         rate = _rate;
532     }
533 
534     /**
535      * @dev function that allows token purchases with STAR or ETH
536      * @param beneficiary Address of the purchaser
537      */
538     function buyTokens(address beneficiary)
539         public
540         payable
541         whenNotPaused
542         isWhitelisted(beneficiary)
543     {
544         require(beneficiary != address(0));
545         require(validPurchase() && tokensSold < crowdsaleCap);
546         if (isMinting) {
547             require(tokenOnSale.owner() == address(this), "The token owner must be contract address!");
548         }
549 
550         if (!isWeiAccepted) {
551             require(msg.value == 0);
552         } else if (msg.value > 0) {
553             buyTokensWithWei(beneficiary);
554         }
555 
556         // beneficiary must allow TokenSale address to transfer star tokens on its behalf
557         uint256 starAllocationToTokenSale = starToken.allowance(beneficiary, this);
558         if (starAllocationToTokenSale > 0) {
559             // calculate token amount to be created
560             uint256 tokens = starAllocationToTokenSale.mul(starRate).div(1000);
561 
562             // remainder logic
563             if (tokensSold.add(tokens) > crowdsaleCap) {
564                 tokens = crowdsaleCap.sub(tokensSold);
565 
566                 starAllocationToTokenSale = tokens.div(starRate).div(1000);
567             }
568 
569             // update state
570             starRaised = starRaised.add(starAllocationToTokenSale);
571 
572             tokensSold = tokensSold.add(tokens);
573             sendPurchasedTokens(beneficiary, tokens);
574             emit TokenPurchaseWithStar(msg.sender, beneficiary, starAllocationToTokenSale, tokens);
575 
576             // forward funds
577             starToken.transferFrom(beneficiary, wallet, starAllocationToTokenSale);
578             wallet.splitStarFunds();
579         }
580     }
581 
582     /**
583      * @dev function that allows token purchases with Wei
584      * @param beneficiary Address of the purchaser
585      */
586     function buyTokensWithWei(address beneficiary)
587         internal
588     {
589         uint256 weiAmount = msg.value;
590         uint256 weiRefund = 0;
591 
592         // calculate token amount to be created
593         uint256 tokens = weiAmount.mul(rate);
594 
595         // remainder logic
596         if (tokensSold.add(tokens) > crowdsaleCap) {
597             tokens = crowdsaleCap.sub(tokensSold);
598             weiAmount = tokens.div(rate);
599 
600             weiRefund = msg.value.sub(weiAmount);
601         }
602 
603         // update state
604         weiRaised = weiRaised.add(weiAmount);
605 
606         tokensSold = tokensSold.add(tokens);
607         sendPurchasedTokens(beneficiary, tokens);
608         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
609 
610         address(wallet).transfer(weiAmount);
611         wallet.splitFunds();
612 
613         if (weiRefund > 0) {
614             msg.sender.transfer(weiRefund);
615         }
616     }
617 
618     // isMinting checker -- it either mints ERC20 token or transfers them
619     function sendPurchasedTokens(address _beneficiary, uint256 _tokens) internal {
620         isMinting ? tokenOnSale.mint(_beneficiary, _tokens) : tokenOnSale.transfer(_beneficiary, _tokens);
621     }
622 
623     // check for softCap achievement
624     // @return true when softCap is reached
625     function hasReachedSoftCap() public view returns (bool) {
626         if (tokensSold >= softCap) {
627             return true;
628         }
629 
630         return false;
631     }
632 
633     // override Crowdsale#hasEnded to add cap logic
634     // @return true if crowdsale event has ended
635     function hasEnded() public view returns (bool) {
636         if (tokensSold >= crowdsaleCap) {
637             return true;
638         }
639 
640         return super.hasEnded();
641     }
642 
643     /**
644      * @dev override Crowdsale#validPurchase
645      * @return true if the transaction can buy tokens
646      */
647     function validPurchase() internal view returns (bool) {
648         return now >= startTime && now <= endTime;
649     }
650 
651     /**
652      * @dev finalizes crowdsale
653      */
654     function finalization() internal {
655         uint256 remainingTokens = isMinting ? crowdsaleCap.sub(tokensSold) : tokenOnSale.balanceOf(address(this));
656 
657         if (remainingTokens > 0) {
658             sendPurchasedTokens(wallet, remainingTokens);
659         }
660 
661         if (isMinting) tokenOnSale.transferOwnership(tokenOwnerAfterSale);
662 
663         super.finalization();
664     }
665 }