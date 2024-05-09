1 pragma solidity 0.4.24;
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
35         require(isOwner());
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
195     // address where funds are collected
196     address public wallet;
197 
198     // how many token units a buyer gets per wei
199     uint256 public rate;
200 
201     // amount of raised money in wei
202     uint256 public weiRaised;
203 
204 
205     // event for token purchase logging
206     // purchaser who paid for the tokens
207     // beneficiary who got the tokens
208     // value weis paid for purchase
209     // amount amount of tokens purchased
210     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
211 
212     function initCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
213         require(
214             startTime == 0 && endTime == 0 && rate == 0 && wallet == address(0),
215             "Global variables must be empty when initializing crowdsale!"
216         );
217         require(_startTime >= now, "_startTime must be more than current time!");
218         require(_endTime >= _startTime, "_endTime must be more than _startTime!");
219         require(_wallet != address(0), "_wallet parameter must not be empty!");
220 
221         startTime = _startTime;
222         endTime = _endTime;
223         rate = _rate;
224         wallet = _wallet;
225     }
226 
227     // @return true if crowdsale event has ended
228     function hasEnded() public view returns (bool) {
229         return now > endTime;
230     }
231 
232     // send ether to the fund collection wallet
233     // override to create custom fund forwarding mechanisms
234     function forwardFunds() internal {
235         wallet.transfer(msg.value);
236     }
237 }
238 
239 // File: contracts/lib/FinalizableCrowdsale.sol
240 
241 /**
242  * @title FinalizableCrowdsale
243  * @dev Extension of Crowdsale where an owner can do extra work
244  * after finishing.
245  */
246 contract FinalizableCrowdsale is Crowdsale, Ownable {
247   using SafeMath for uint256;
248 
249   bool public isFinalized = false;
250 
251   event Finalized();
252 
253   /**
254    * @dev Must be called after crowdsale ends, to do some extra finalization
255    * work. Calls the contract's finalization function.
256    */
257   function finalize() onlyOwner public {
258     require(!isFinalized);
259     require(hasEnded());
260 
261     finalization();
262     emit Finalized();
263 
264     isFinalized = true;
265   }
266 
267   /**
268    * @dev Can be overridden to add finalization logic. The overriding function
269    * should call super.finalization() to ensure the chain of finalization is
270    * executed entirely.
271    */
272   function finalization() internal {
273   }
274 }
275 
276 // File: contracts/lib/ERC20Plus.sol
277 
278 /**
279  * @title ERC20 interface with additional functions
280  * @dev it has added functions that deals to minting, pausing token and token information
281  */
282 contract ERC20Plus {
283     function allowance(address owner, address spender) public view returns (uint256);
284     function transferFrom(address from, address to, uint256 value) public returns (bool);
285     function approve(address spender, uint256 value) public returns (bool);
286     function totalSupply() public view returns (uint256);
287     function balanceOf(address who) public view returns (uint256);
288     function transfer(address to, uint256 value) public returns (bool);
289 
290     event Approval(address indexed owner, address indexed spender, uint256 value);
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     // additonal functions
294     function mint(address _to, uint256 _amount) public returns (bool);
295     function owner() public view returns (address);
296     function transferOwnership(address newOwner) public;
297     function name() public view returns (string);
298     function symbol() public view returns (string);
299     function decimals() public view returns (uint8);
300     function paused() public view returns (bool);
301 
302 }
303 
304 // File: contracts/Whitelist.sol
305 
306 /**
307  * @title Whitelist - crowdsale whitelist contract
308  * @author Gustavo Guimaraes - <gustavo@starbase.co>
309  */
310 contract Whitelist is Ownable {
311     mapping(address => bool) public allowedAddresses;
312 
313     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
314 
315     /**
316     * @dev Adds single address to whitelist.
317     * @param _address Address to be added to the whitelist
318     */
319     function addToWhitelist(address _address) external onlyOwner {
320         allowedAddresses[_address] = true;
321         emit WhitelistUpdated(now, "Added", _address);
322     }
323 
324     /**
325      * @dev add various whitelist addresses
326      * @param _addresses Array of ethereum addresses
327      */
328     function addManyToWhitelist(address[] _addresses) external onlyOwner {
329         for (uint256 i = 0; i < _addresses.length; i++) {
330             allowedAddresses[_addresses[i]] = true;
331             emit WhitelistUpdated(now, "Added", _addresses[i]);
332         }
333     }
334 
335     /**
336      * @dev remove whitelist addresses
337      * @param _addresses Array of ethereum addresses
338      */
339     function removeManyFromWhitelist(address[] _addresses) public onlyOwner {
340         for (uint256 i = 0; i < _addresses.length; i++) {
341             allowedAddresses[_addresses[i]] = false;
342             emit WhitelistUpdated(now, "Removed", _addresses[i]);
343         }
344     }
345 }
346 
347 // File: contracts/TokenSaleInterface.sol
348 
349 /**
350  * @title TokenSale contract interface
351  */
352 interface TokenSaleInterface {
353     function init
354     (
355         uint256 _startTime,
356         uint256 _endTime,
357         address _whitelist,
358         address _starToken,
359         address _companyToken,
360         uint256 _rate,
361         uint256 _starRate,
362         address _wallet,
363         uint256 _crowdsaleCap,
364         bool    _isWeiAccepted
365     )
366     external;
367 }
368 
369 // File: contracts/TokenSale.sol
370 
371 /**
372  * @title Token Sale contract - crowdsale of company tokens.
373  * @author Gustavo Guimaraes - <gustavo@starbase.co>
374  */
375 contract TokenSale is FinalizableCrowdsale, Pausable {
376     uint256 public crowdsaleCap;
377     uint256 public tokensSold;
378     // amount of raised money in STAR
379     uint256 public starRaised;
380     uint256 public starRate;
381     address public initialTokenOwner;
382     bool public isWeiAccepted;
383 
384     // external contracts
385     Whitelist public whitelist;
386     ERC20Plus public starToken;
387     // The token being sold
388     ERC20Plus public tokenOnSale;
389 
390     event TokenRateChanged(uint256 previousRate, uint256 newRate);
391     event TokenStarRateChanged(uint256 previousStarRate, uint256 newStarRate);
392     event TokenPurchaseWithStar(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
393 
394     /**
395      * @dev initialization function
396      * @param _startTime The timestamp of the beginning of the crowdsale
397      * @param _endTime Timestamp when the crowdsale will finish
398      * @param _whitelist contract containing the whitelisted addresses
399      * @param _starToken STAR token contract address
400      * @param _companyToken ERC20 contract address that has minting capabilities
401      * @param _rate The token rate per ETH
402      * @param _starRate The token rate per STAR
403      * @param _wallet Multisig wallet that will hold the crowdsale funds.
404      * @param _crowdsaleCap Cap for the token sale
405      * @param _isWeiAccepted Bool for acceptance of ether in token sale
406      */
407     function init(
408         uint256 _startTime,
409         uint256 _endTime,
410         address _whitelist,
411         address _starToken,
412         address _companyToken,
413         uint256 _rate,
414         uint256 _starRate,
415         address _wallet,
416         uint256 _crowdsaleCap,
417         bool    _isWeiAccepted
418     )
419         external
420     {
421         require(
422             whitelist == address(0) &&
423             starToken == address(0) &&
424             rate == 0 &&
425             starRate == 0 &&
426             tokenOnSale == address(0) &&
427             crowdsaleCap == 0,
428             "Global variables should not have been set before!"
429         );
430 
431         require(
432             _whitelist != address(0) &&
433             _starToken != address(0) &&
434             !(_rate == 0 && _starRate == 0) &&
435             _companyToken != address(0) &&
436             _crowdsaleCap != 0,
437             "Parameter variables cannot be empty!"
438         );
439 
440         initCrowdsale(_startTime, _endTime, _rate, _wallet);
441         tokenOnSale = ERC20Plus(_companyToken);
442         whitelist = Whitelist(_whitelist);
443         starToken = ERC20Plus(_starToken);
444         starRate = _starRate;
445         isWeiAccepted = _isWeiAccepted;
446         _owner = tx.origin;
447 
448         initialTokenOwner = ERC20Plus(tokenOnSale).owner();
449         uint256 tokenDecimals = ERC20Plus(tokenOnSale).decimals();
450         crowdsaleCap = _crowdsaleCap.mul(10 ** tokenDecimals);
451 
452         require(ERC20Plus(tokenOnSale).paused(), "Company token must be paused upon initialization!");
453     }
454 
455     modifier isWhitelisted(address beneficiary) {
456         require(whitelist.allowedAddresses(beneficiary), "Beneficiary not whitelisted!");
457         _;
458     }
459 
460     modifier crowdsaleIsTokenOwner() {
461         require(tokenOnSale.owner() == address(this), "The token owner must be contract address!");
462         _;
463     }
464 
465     /**
466      * @dev override fallback function. cannot use it
467      */
468     function () external payable {
469         revert("No fallback function defined!");
470     }
471 
472     /**
473      * @dev change crowdsale ETH rate
474      * @param newRate Figure that corresponds to the new ETH rate per token
475      */
476     function setRate(uint256 newRate) external onlyOwner {
477         require(newRate != 0, "ETH rate must be more than 0");
478 
479         emit TokenRateChanged(rate, newRate);
480         rate = newRate;
481     }
482 
483     /**
484      * @dev change crowdsale STAR rate
485      * @param newStarRate Figure that corresponds to the new STAR rate per token
486      */
487     function setStarRate(uint256 newStarRate) external onlyOwner {
488         require(newStarRate != 0, "Star rate must be more than 0!");
489 
490         emit TokenStarRateChanged(starRate, newStarRate);
491         starRate = newStarRate;
492     }
493 
494     /**
495      * @dev allows sale to receive wei or not
496      */
497     function setIsWeiAccepted(bool _isWeiAccepted) external onlyOwner {
498         require(rate != 0, "When accepting Wei you need to set a conversion rate!");
499         isWeiAccepted = _isWeiAccepted;
500     }
501 
502     /**
503      * @dev function that allows token purchases with STAR
504      * @param beneficiary Address of the purchaser
505      */
506     function buyTokens(address beneficiary)
507         public
508         payable
509         whenNotPaused
510         isWhitelisted(beneficiary)
511         crowdsaleIsTokenOwner
512     {
513         require(beneficiary != address(0));
514         require(validPurchase() && tokensSold < crowdsaleCap);
515 
516         if (!isWeiAccepted) {
517             require(msg.value == 0);
518         } else if (msg.value > 0) {
519             buyTokensWithWei(beneficiary);
520         }
521 
522         // beneficiary must allow TokenSale address to transfer star tokens on its behalf
523         uint256 starAllocationToTokenSale = starToken.allowance(beneficiary, this);
524         if (starAllocationToTokenSale > 0) {
525             // calculate token amount to be created
526             uint256 tokens = starAllocationToTokenSale.mul(starRate);
527 
528             //remainder logic
529             if (tokensSold.add(tokens) > crowdsaleCap) {
530                 tokens = crowdsaleCap.sub(tokensSold);
531 
532                 starAllocationToTokenSale = tokens.div(starRate);
533             }
534 
535             // update state
536             starRaised = starRaised.add(starAllocationToTokenSale);
537 
538             tokensSold = tokensSold.add(tokens);
539             tokenOnSale.mint(beneficiary, tokens);
540             emit TokenPurchaseWithStar(msg.sender, beneficiary, starAllocationToTokenSale, tokens);
541 
542             // forward funds
543             starToken.transferFrom(beneficiary, wallet, starAllocationToTokenSale);
544         }
545     }
546 
547     /**
548      * @dev function that allows token purchases with Wei
549      * @param beneficiary Address of the purchaser
550      */
551     function buyTokensWithWei(address beneficiary)
552         internal
553     {
554         uint256 weiAmount = msg.value;
555         uint256 weiRefund = 0;
556 
557         // calculate token amount to be created
558         uint256 tokens = weiAmount.mul(rate);
559 
560         //remainder logic
561         if (tokensSold.add(tokens) > crowdsaleCap) {
562             tokens = crowdsaleCap.sub(tokensSold);
563             weiAmount = tokens.div(rate);
564 
565             weiRefund = msg.value.sub(weiAmount);
566         }
567 
568         // update state
569         weiRaised = weiRaised.add(weiAmount);
570 
571         tokensSold = tokensSold.add(tokens);
572         tokenOnSale.mint(beneficiary, tokens);
573         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
574 
575         wallet.transfer(weiAmount);
576         if (weiRefund > 0) {
577             msg.sender.transfer(weiRefund);
578         }
579     }
580 
581     // override Crowdsale#hasEnded to add cap logic
582     // @return true if crowdsale event has ended
583     function hasEnded() public view returns (bool) {
584         if (tokensSold >= crowdsaleCap) {
585             return true;
586         }
587 
588         return super.hasEnded();
589     }
590 
591     /**
592      * @dev override Crowdsale#validPurchase
593      * @return true if the transaction can buy tokens
594      */
595     function validPurchase() internal view returns (bool) {
596         return now >= startTime && now <= endTime;
597     }
598 
599     /**
600      * @dev finalizes crowdsale
601      */
602     function finalization() internal {
603         if (crowdsaleCap > tokensSold) {
604             uint256 remainingTokens = crowdsaleCap.sub(tokensSold);
605 
606             tokenOnSale.mint(wallet, remainingTokens);
607         }
608 
609         tokenOnSale.transferOwnership(initialTokenOwner);
610         super.finalization();
611     }
612 }