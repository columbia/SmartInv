1 pragma solidity 0.4.24;
2 
3 // File: contracts\lib\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner, "only owner is able to call this function");
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 // File: contracts\lib\Pausable.sol
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77 
78   /**
79    * @dev Modifier to make a function callable only when the contract is not paused.
80    */
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is paused.
88    */
89   modifier whenPaused() {
90     require(paused);
91     _;
92   }
93 
94   /**
95    * @dev called by the owner to pause, triggers stopped state
96    */
97   function pause() onlyOwner whenNotPaused public {
98     paused = true;
99     emit Pause();
100   }
101 
102   /**
103    * @dev called by the owner to unpause, returns to normal state
104    */
105   function unpause() onlyOwner whenPaused public {
106     paused = false;
107     emit Unpause();
108   }
109 }
110 
111 // File: contracts\lib\SafeMath.sol
112 
113 /**
114  * @title SafeMath
115  * @dev Math operations with safety checks that throw on error
116  */
117 library SafeMath {
118 
119   /**
120   * @dev Multiplies two numbers, throws on overflow.
121   */
122   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
123     if (a == 0) {
124       return 0;
125     }
126     c = a * b;
127     assert(c / a == b);
128     return c;
129   }
130 
131   /**
132   * @dev Integer division of two numbers, truncating the quotient.
133   */
134   function div(uint256 a, uint256 b) internal pure returns (uint256) {
135     // assert(b > 0); // Solidity automatically throws when dividing by 0
136     // uint256 c = a / b;
137     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138     return a / b;
139   }
140 
141   /**
142   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
143   */
144   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145     assert(b <= a);
146     return a - b;
147   }
148 
149   /**
150   * @dev Adds two numbers, throws on overflow.
151   */
152   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
153     c = a + b;
154     assert(c >= a);
155     return c;
156   }
157 }
158 
159 // File: contracts\lib\Crowdsale.sol
160 
161 /**
162  * @title Crowdsale - modified from zeppelin-solidity library
163  * @dev Crowdsale is a base contract for managing a token crowdsale.
164  * Crowdsales have a start and end timestamps, where investors can make
165  * token purchases and the crowdsale will assign them tokens based
166  * on a token per ETH rate. Funds collected are forwarded to a wallet
167  * as they arrive.
168  */
169 contract Crowdsale {
170     // start and end timestamps where investments are allowed (both inclusive)
171     uint256 public startTime;
172     uint256 public endTime;
173 
174     // address where funds are collected
175     address public wallet;
176 
177     // how many token units a buyer gets per wei
178     uint256 public rate;
179 
180     // amount of raised money in wei
181     uint256 public weiRaised;
182 
183 
184     // event for token purchase logging
185     // purchaser who paid for the tokens
186     // beneficiary who got the tokens
187     // value weis paid for purchase
188     // amount amount of tokens purchased
189     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
190 
191     function initCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
192         require(
193             startTime == 0 && endTime == 0 && rate == 0 && wallet == address(0),
194             "Global variables must be empty when initializing crowdsale!"
195         );
196         require(_startTime >= now, "_startTime must be more than current time!");
197         require(_endTime >= _startTime, "_endTime must be more than _startTime!");
198         require(_wallet != address(0), "_wallet parameter must not be empty!");
199 
200         startTime = _startTime;
201         endTime = _endTime;
202         rate = _rate;
203         wallet = _wallet;
204     }
205 
206     // @return true if crowdsale event has ended
207     function hasEnded() public view returns (bool) {
208         return now > endTime;
209     }
210 
211     // send ether to the fund collection wallet
212     // override to create custom fund forwarding mechanisms
213     function forwardFunds() internal {
214         wallet.transfer(msg.value);
215     }
216 }
217 
218 // File: contracts\lib\FinalizableCrowdsale.sol
219 
220 /**
221  * @title FinalizableCrowdsale
222  * @dev Extension of Crowdsale where an owner can do extra work
223  * after finishing.
224  */
225 contract FinalizableCrowdsale is Crowdsale, Ownable {
226   using SafeMath for uint256;
227 
228   bool public isFinalized = false;
229 
230   event Finalized();
231 
232   /**
233    * @dev Must be called after crowdsale ends, to do some extra finalization
234    * work. Calls the contract's finalization function.
235    */
236   function finalize() onlyOwner public {
237     require(!isFinalized);
238     require(hasEnded());
239 
240     finalization();
241     emit Finalized();
242 
243     isFinalized = true;
244   }
245 
246   /**
247    * @dev Can be overridden to add finalization logic. The overriding function
248    * should call super.finalization() to ensure the chain of finalization is
249    * executed entirely.
250    */
251   function finalization() internal {
252   }
253 }
254 
255 // File: contracts\lib\ERC20.sol
256 
257 /**
258  * @title ERC20 interface
259  * @dev see https://github.com/ethereum/EIPs/issues/20
260  */
261 contract ERC20 {
262     function allowance(address owner, address spender) public view returns (uint256);
263     function transferFrom(address from, address to, uint256 value) public returns (bool);
264     function approve(address spender, uint256 value) public returns (bool);
265     function totalSupply() public view returns (uint256);
266     function balanceOf(address who) public view returns (uint256);
267     function transfer(address to, uint256 value) public returns (bool);
268 
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270     event Transfer(address indexed from, address indexed to, uint256 value);
271 }
272 
273 // File: contracts\Whitelist.sol
274 
275 /**
276  * @title Whitelist - crowdsale whitelist contract
277  * @author Gustavo Guimaraes - <gustavo@starbase.co>
278  */
279 contract Whitelist is Ownable {
280     mapping(address => bool) public allowedAddresses;
281 
282     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
283 
284     /**
285     * @dev Adds single address to whitelist.
286     * @param _address Address to be added to the whitelist
287     */
288     function addToWhitelist(address _address) external onlyOwner {
289         allowedAddresses[_address] = true;
290         emit WhitelistUpdated(now, "Added", _address);
291     }
292 
293     /**
294      * @dev add various whitelist addresses
295      * @param _addresses Array of ethereum addresses
296      */
297     function addManyToWhitelist(address[] _addresses) external onlyOwner {
298         for (uint256 i = 0; i < _addresses.length; i++) {
299             allowedAddresses[_addresses[i]] = true;
300             emit WhitelistUpdated(now, "Added", _addresses[i]);
301         }
302     }
303 
304     /**
305      * @dev remove whitelist addresses
306      * @param _addresses Array of ethereum addresses
307      */
308     function removeManyFromWhitelist(address[] _addresses) public onlyOwner {
309         for (uint256 i = 0; i < _addresses.length; i++) {
310             allowedAddresses[_addresses[i]] = false;
311             emit WhitelistUpdated(now, "Removed", _addresses[i]);
312         }
313     }
314 }
315 
316 // File: contracts\TokenSaleInterface.sol
317 
318 /**
319  * @title TokenSale contract interface
320  */
321 interface TokenSaleInterface {
322     function init
323     (
324         uint256 _startTime,
325         uint256 _endTime,
326         address _whitelist,
327         address _starToken,
328         address _companyToken,
329         uint256 _rate,
330         uint256 _starRate,
331         address _wallet,
332         uint256 _crowdsaleCap,
333         bool    _isWeiAccepted
334     )
335     external;
336 }
337 
338 // File: contracts\TokenSaleForAlreadyDeployedERC20Tokens.sol
339 
340 /**
341  * @title Token Sale contract - crowdsale of company tokens.
342  * @author Gustavo Guimaraes - <gustavo@starbase.co>
343  */
344 contract TokenSaleForAlreadyDeployedERC20Tokens is FinalizableCrowdsale, Pausable {
345     uint256 public crowdsaleCap;
346     // amount of raised money in STAR
347     uint256 public starRaised;
348     uint256 public starRate;
349     bool public isWeiAccepted;
350 
351     // external contracts
352     Whitelist public whitelist;
353     ERC20 public starToken;
354     // The token being sold
355     ERC20 public tokenOnSale;
356 
357     event TokenRateChanged(uint256 previousRate, uint256 newRate);
358     event TokenStarRateChanged(uint256 previousStarRate, uint256 newStarRate);
359     event TokenPurchaseWithStar(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
360 
361     /**
362      * @dev initialization function
363      * @param _startTime The timestamp of the beginning of the crowdsale
364      * @param _endTime Timestamp when the crowdsale will finish
365      * @param _whitelist contract containing the whitelisted addresses
366      * @param _starToken STAR token contract address
367      * @param _tokenOnSale ERC20 token for sale
368      * @param _rate The token rate per ETH
369      * @param _starRate The token rate per STAR
370      * @param _wallet Multisig wallet that will hold the crowdsale funds.
371      * @param _crowdsaleCap Cap for the token sale
372      * @param _isWeiAccepted Bool for acceptance of ether in token sale
373      */
374     function init(
375         uint256 _startTime,
376         uint256 _endTime,
377         address _whitelist,
378         address _starToken,
379         address _tokenOnSale,
380         uint256 _rate,
381         uint256 _starRate,
382         address _wallet,
383         uint256 _crowdsaleCap,
384         bool    _isWeiAccepted
385     )
386         external
387     {
388         require(
389             whitelist == address(0) &&
390             starToken == address(0) &&
391             rate == 0 &&
392             starRate == 0 &&
393             tokenOnSale == address(0) &&
394             crowdsaleCap == 0,
395             "Global variables should not have been set before!"
396         );
397 
398         require(
399             _whitelist != address(0) &&
400             _starToken != address(0) &&
401             !(_rate == 0 && _starRate == 0) &&
402             _tokenOnSale != address(0) &&
403             _crowdsaleCap != 0,
404             "Parameter variables cannot be empty!"
405         );
406 
407         initCrowdsale(_startTime, _endTime, _rate, _wallet);
408         tokenOnSale = ERC20(_tokenOnSale);
409         whitelist = Whitelist(_whitelist);
410         starToken = ERC20(_starToken);
411         starRate = _starRate;
412         isWeiAccepted = _isWeiAccepted;
413         owner = tx.origin;
414 
415         crowdsaleCap = _crowdsaleCap;
416     }
417 
418     modifier isWhitelisted(address beneficiary) {
419         require(whitelist.allowedAddresses(beneficiary), "Beneficiary not whitelisted!");
420         _;
421     }
422 
423     /**
424      * @dev override fallback function. cannot use it
425      */
426     function () external payable {
427         revert("No fallback function defined!");
428     }
429 
430     /**
431      * @dev change crowdsale ETH rate
432      * @param newRate Figure that corresponds to the new ETH rate per token
433      */
434     function setRate(uint256 newRate) external onlyOwner {
435         require(newRate != 0, "ETH rate must be more than 0");
436 
437         emit TokenRateChanged(rate, newRate);
438         rate = newRate;
439     }
440 
441     /**
442      * @dev change crowdsale STAR rate
443      * @param newStarRate Figure that corresponds to the new STAR rate per token
444      */
445     function setStarRate(uint256 newStarRate) external onlyOwner {
446         require(newStarRate != 0, "Star rate must be more than 0!");
447 
448         emit TokenStarRateChanged(starRate, newStarRate);
449         starRate = newStarRate;
450     }
451 
452     /**
453      * @dev allows sale to receive wei or not
454      */
455     function setIsWeiAccepted(bool _isWeiAccepted) external onlyOwner {
456         require(rate != 0, "When accepting Wei you need to set a conversion rate!");
457         isWeiAccepted = _isWeiAccepted;
458     }
459 
460     /**
461      * @dev function that allows token purchases with STAR
462      * @param beneficiary Address of the purchaser
463      */
464     function buyTokens(address beneficiary)
465         public
466         payable
467         whenNotPaused
468         isWhitelisted(beneficiary)
469     {
470         require(beneficiary != address(0));
471         require(validPurchase() && tokenOnSale.balanceOf(address(this)) > 0);
472 
473         if (!isWeiAccepted) {
474             require(msg.value == 0);
475         } else if (msg.value > 0) {
476             buyTokensWithWei(beneficiary);
477         }
478 
479         // beneficiary must allow TokenSale address to transfer star tokens on its behalf
480         uint256 starAllocationToTokenSale = starToken.allowance(beneficiary, address(this));
481         if (starAllocationToTokenSale > 0) {
482             // calculate token amount to be created
483             uint256 tokens = starAllocationToTokenSale.mul(starRate);
484 
485             //remainder logic
486             if (tokens > tokenOnSale.balanceOf(address(this))) {
487                 tokens = tokenOnSale.balanceOf(address(this));
488 
489                 starAllocationToTokenSale = tokens.div(starRate);
490             }
491 
492             // update state
493             starRaised = starRaised.add(starAllocationToTokenSale);
494 
495             tokenOnSale.transfer(beneficiary, tokens);
496             emit TokenPurchaseWithStar(msg.sender, beneficiary, starAllocationToTokenSale, tokens);
497 
498             // forward funds
499             starToken.transferFrom(beneficiary, wallet, starAllocationToTokenSale);
500         }
501     }
502 
503     /**
504      * @dev function that allows token purchases with Wei
505      * @param beneficiary Address of the purchaser
506      */
507     function buyTokensWithWei(address beneficiary)
508         internal
509     {
510         uint256 weiAmount = msg.value;
511         uint256 weiRefund = 0;
512 
513         // calculate token amount to be created
514         uint256 tokens = weiAmount.mul(rate);
515 
516         //remainder logic
517         if (tokens > tokenOnSale.balanceOf(address(this))) {
518             tokens = tokenOnSale.balanceOf(address(this));
519             weiAmount = tokens.div(rate);
520 
521             weiRefund = msg.value.sub(weiAmount);
522         }
523 
524         // update state
525         weiRaised = weiRaised.add(weiAmount);
526 
527         tokenOnSale.transfer(beneficiary, tokens);
528         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
529 
530         wallet.transfer(weiAmount);
531         if (weiRefund > 0) {
532             msg.sender.transfer(weiRefund);
533         }
534     }
535 
536     // override Crowdsale#hasEnded to add cap logic
537     // @return true if crowdsale event has ended
538     function hasEnded() public view returns (bool) {
539         if (tokenOnSale.balanceOf(address(this)) == uint(0) && (starRaised > 0 || weiRaised > 0)) {
540             return true;
541         }
542 
543         return super.hasEnded();
544     }
545 
546     /**
547      * @dev override Crowdsale#validPurchase
548      * @return true if the transaction can buy tokens
549      */
550     function validPurchase() internal view returns (bool) {
551         return now >= startTime && now <= endTime;
552     }
553 
554     /**
555      * @dev finalizes crowdsale
556      */
557     function finalization() internal {
558         if (tokenOnSale.balanceOf(address(this)) > 0) {
559             uint256 remainingTokens = tokenOnSale.balanceOf(address(this));
560 
561             tokenOnSale.transfer(wallet, remainingTokens);
562         }
563 
564         super.finalization();
565     }
566 }