1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     function totalSupply() public view returns (uint256);
11 
12     function balanceOf(address who) public view returns (uint256);
13 
14     function transfer(address to, uint256 value) public returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25     function allowance(address owner, address spender)
26     public view returns (uint256);
27 
28     function transferFrom(address from, address to, uint256 value)
29     public returns (bool);
30 
31     function approve(address spender, uint256 value) public returns (bool);
32 
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39 
40 
41 /**
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46 
47     /**
48     * @dev Multiplies two numbers, throws on overflow.
49     */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
51         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
52         // benefit is lost if 'b' is also tested.
53         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
54         if (a == 0) {
55             return 0;
56         }
57 
58         c = a * b;
59         assert(c / a == b);
60         return c;
61     }
62 
63     /**
64     * @dev Integer division of two numbers, truncating the quotient.
65     */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // assert(b > 0); // Solidity automatically throws when dividing by 0
68         // uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70         return a / b;
71     }
72 
73     /**
74     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         assert(b <= a);
78         return a - b;
79     }
80 
81     /**
82     * @dev Adds two numbers, throws on overflow.
83     */
84     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85         c = a + b;
86         assert(c >= a);
87         return c;
88     }
89 }
90 
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105     using SafeMath for uint256;
106 
107     // The token being sold
108     ERC20 public token;
109 
110     // Address where funds are collected
111     address public wallet;
112 
113     // How many token units a buyer gets per wei.
114     // The rate is the conversion between wei and the smallest and indivisible token unit.
115     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116     // 1 wei will give you 1 unit, or 0.001 TOK.
117     uint256 public rate;
118 
119     // Amount of wei raised
120     uint256 public weiRaised;
121 
122     /**
123      * Event for token purchase logging
124      * @param purchaser who paid for the tokens
125      * @param beneficiary who got the tokens
126      * @param value weis paid for purchase
127      * @param amount amount of tokens purchased
128      */
129     event TokenPurchase(
130         address indexed purchaser,
131         address indexed beneficiary,
132         uint256 value,
133         uint256 amount
134     );
135 
136     /**
137      * @param _rate Number of token units a buyer gets per wei
138      * @param _wallet Address where collected funds will be forwarded to
139      * @param _token Address of the token being sold
140      */
141     constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142         require(_rate > 0);
143         require(_wallet != address(0));
144         require(_token != address(0));
145 
146         rate = _rate;
147         wallet = _wallet;
148         token = _token;
149     }
150 
151     // -----------------------------------------
152     // Crowdsale external interface
153     // -----------------------------------------
154 
155     /**
156      * @dev fallback function ***DO NOT OVERRIDE***
157      */
158     function() external payable {
159         buyTokens(msg.sender);
160     }
161 
162     /**
163      * @dev low level token purchase ***DO NOT OVERRIDE***
164      * @param _beneficiary Address performing the token purchase
165      */
166     function buyTokens(address _beneficiary) public payable {
167 
168         uint256 weiAmount = msg.value;
169         _preValidatePurchase(_beneficiary, weiAmount);
170 
171         // calculate token amount to be created
172         uint256 tokens = _getTokenAmount(weiAmount);
173 
174         // update state
175         weiRaised = weiRaised.add(weiAmount);
176 
177         _processPurchase(_beneficiary, tokens);
178         emit TokenPurchase(
179             msg.sender,
180             _beneficiary,
181             weiAmount,
182             tokens
183         );
184 
185         _processBonusStateSave(_beneficiary, weiAmount);
186 
187         _forwardFunds();
188     }
189 
190     // -----------------------------------------
191     // Internal interface (extensible)
192     // -----------------------------------------
193 
194     /**
195      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
196      * @param _beneficiary Address performing the token purchase
197      * @param _weiAmount Value in wei involved in the purchase
198      */
199     function _preValidatePurchase(
200         address _beneficiary,
201         uint256 _weiAmount
202     )
203     internal
204     {
205         require(_beneficiary != address(0));
206         require(_weiAmount != 0);
207     }
208 
209     /**
210      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
211      * @param _beneficiary Address performing the token purchase
212      * @param _tokenAmount Number of tokens to be emitted
213      */
214     function _deliverTokens(
215         address _beneficiary,
216         uint256 _tokenAmount
217     )
218     internal
219     {
220         token.transfer(_beneficiary, _tokenAmount);
221     }
222 
223     /**
224      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
225      * @param _beneficiary Address receiving the tokens
226      * @param _tokenAmount Number of tokens to be purchased
227      */
228     function _processPurchase(
229         address _beneficiary,
230         uint256 _tokenAmount
231     )
232     internal
233     {
234         _deliverTokens(_beneficiary, _tokenAmount);
235     }
236 
237     /**
238      * @dev Override to extend the way in which ether is converted to tokens.
239      * @param _weiAmount Value in wei to be converted into tokens
240      * @return Number of tokens that can be purchased with the specified _weiAmount
241      */
242     function _getTokenAmount(uint256 _weiAmount)
243     internal view returns (uint256)
244     {
245         return _weiAmount.mul(rate);
246     }
247 
248     function _processBonusStateSave(
249         address _beneficiary,
250         uint256 _weiAmount
251     )
252     internal
253     {
254     }
255 
256     /**
257      * @dev Determines how ETH is stored/forwarded on purchases.
258      */
259     function _forwardFunds() internal {
260         wallet.transfer(msg.value);
261     }
262 }
263 
264 
265 /**
266  * @title SafeERC20
267  * @dev Wrappers around ERC20 operations that throw on failure.
268  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
269  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
270  */
271 library SafeERC20 {
272     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
273         require(token.transfer(to, value));
274     }
275 
276     function safeTransferFrom(
277         ERC20 token,
278         address from,
279         address to,
280         uint256 value
281     )
282     internal
283     {
284         require(token.transferFrom(from, to, value));
285     }
286 
287     function safeApprove(ERC20 token, address spender, uint256 value) internal {
288         require(token.approve(spender, value));
289     }
290 }
291 
292 
293 /**
294  * @title AllowanceCrowdsale
295  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
296  */
297 contract AllowanceCrowdsale is Crowdsale {
298     using SafeMath for uint256;
299     using SafeERC20 for ERC20;
300 
301     address public tokenWallet;
302 
303     /**
304      * @dev Constructor, takes token wallet address.
305      * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
306      */
307     constructor(address _tokenWallet) public {
308         require(_tokenWallet != address(0));
309         tokenWallet = _tokenWallet;
310     }
311 
312     /**
313      * @dev Checks the amount of tokens left in the allowance.
314      * @return Amount of tokens left in the allowance
315      */
316     function remainingTokens() public view returns (uint256) {
317         return token.allowance(tokenWallet, this);
318     }
319 
320     /**
321      * @dev Overrides parent behavior by transferring tokens from wallet.
322      * @param _beneficiary Token purchaser
323      * @param _tokenAmount Amount of tokens purchased
324      */
325     function _deliverTokens(
326         address _beneficiary,
327         uint256 _tokenAmount
328     )
329     internal
330     {
331         token.safeTransferFrom(tokenWallet, _beneficiary, _tokenAmount);
332     }
333 }
334 
335 
336 /**
337  * @title TimedCrowdsale
338  * @dev Crowdsale accepting contributions only within a time frame.
339  */
340 contract TimedCrowdsale is Crowdsale {
341     using SafeMath for uint256;
342 
343     uint256 public openingTime;
344 
345     /**
346      * @dev Reverts if not in crowdsale time range.
347      */
348     modifier onlyWhileOpen {
349         // solium-disable-next-line security/no-block-members
350         require(isOpen());
351         _;
352     }
353 
354     /**
355      * @dev Constructor, takes crowdsale opening and closing times.
356      * @param _openingTime Crowdsale opening time
357      */
358     constructor(uint256 _openingTime) public {
359         // solium-disable-next-line security/no-block-members
360         require(_openingTime >= block.timestamp);
361 
362         openingTime = _openingTime;
363     }
364 
365     /**
366      * @return true if the crowdsale is open, false otherwise.
367      */
368     function isOpen() public view returns (bool) {
369         // solium-disable-next-line security/no-block-members
370         return block.timestamp >= openingTime;
371     }
372 
373     /**
374      * @dev Extend parent behavior requiring to be within contributing period
375      * @param _beneficiary Token purchaser
376      * @param _weiAmount Amount of wei contributed
377      */
378     function _preValidatePurchase(
379         address _beneficiary,
380         uint256 _weiAmount
381     )
382     internal
383     onlyWhileOpen
384     {
385         super._preValidatePurchase(_beneficiary, _weiAmount);
386     }
387 
388 }
389 
390 
391 /**
392  * @title CappedCrowdsale
393  * @dev Crowdsale with a limit for total contributions.
394  */
395 contract CappedCrowdsale is Crowdsale {
396     using SafeMath for uint256;
397 
398     uint256 public cap;
399 
400     /**
401      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
402      * @param _cap Max amount of wei to be contributed
403      */
404     constructor(uint256 _cap) public {
405         require(_cap > 0);
406         cap = _cap;
407     }
408 
409     /**
410      * @dev Checks whether the cap has been reached.
411      * @return Whether the cap was reached
412      */
413     function capReached() public view returns (bool) {
414         return weiRaised >= cap;
415     }
416 
417     /**
418      * @dev Extend parent behavior requiring purchase to respect the funding cap.
419      * @param _beneficiary Token purchaser
420      * @param _weiAmount Amount of wei contributed
421      */
422     function _preValidatePurchase(
423         address _beneficiary,
424         uint256 _weiAmount
425     )
426     internal
427     {
428         super._preValidatePurchase(_beneficiary, _weiAmount);
429         require(weiRaised.add(_weiAmount) <= cap);
430     }
431 }
432 
433 
434 /**
435  * @title Ownable
436  * @dev The Ownable contract has an owner address, and provides basic authorization control
437  * functions, this simplifies the implementation of "user permissions".
438  */
439 contract Ownable {
440     address public owner;
441 
442 
443     event OwnershipRenounced(address indexed previousOwner);
444     event OwnershipTransferred(
445         address indexed previousOwner,
446         address indexed newOwner
447     );
448 
449 
450     /**
451      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
452      * account.
453      */
454     constructor() public {
455         owner = msg.sender;
456     }
457 
458     /**
459      * @dev Throws if called by any account other than the owner.
460      */
461     modifier onlyOwner() {
462         require(msg.sender == owner);
463         _;
464     }
465 
466     /**
467      * @dev Allows the current owner to relinquish control of the contract.
468      * @notice Renouncing to ownership will leave the contract without an owner.
469      * It will not be possible to call the functions with the `onlyOwner`
470      * modifier anymore.
471      */
472     function renounceOwnership() public onlyOwner {
473         emit OwnershipRenounced(owner);
474         owner = address(0);
475     }
476 
477     /**
478      * @dev Allows the current owner to transfer control of the contract to a newOwner.
479      * @param _newOwner The address to transfer ownership to.
480      */
481     function transferOwnership(address _newOwner) public onlyOwner {
482         _transferOwnership(_newOwner);
483     }
484 
485     /**
486      * @dev Transfers control of the contract to a newOwner.
487      * @param _newOwner The address to transfer ownership to.
488      */
489     function _transferOwnership(address _newOwner) internal {
490         require(_newOwner != address(0));
491         emit OwnershipTransferred(owner, _newOwner);
492         owner = _newOwner;
493     }
494 }
495 
496 
497 contract TecoIco is Crowdsale, AllowanceCrowdsale, TimedCrowdsale, CappedCrowdsale, Ownable {
498     using SafeMath for uint256;
499 
500     uint256 public bonusPercent;
501 
502     mapping(address => uint256) bonuses;
503 
504     constructor(uint256 _rate, address _wallet, ERC20 _token, address _tokenWallet, uint256 _openingTime, uint256 _cap)
505     Crowdsale(_rate, _wallet, _token)
506     AllowanceCrowdsale(_tokenWallet)
507     TimedCrowdsale(_openingTime)
508     CappedCrowdsale(_cap)
509     public
510     {
511         require(_rate > 0);
512         require(_wallet != address(0));
513         require(_token != address(0));
514 
515         rate = _rate;
516         wallet = _wallet;
517         token = _token;
518     }
519 
520     function setRate(uint256 _rate)
521     public
522     onlyOwner
523     {
524         rate = _rate;
525     }
526 
527     function setBonusPercent(uint256 _bonusPercent)
528     public
529     onlyOwner
530     {
531         bonusPercent = _bonusPercent;
532     }
533 
534     function getBonusTokenAmount(uint256 _weiAmount)
535     public
536     view
537     returns (uint256)
538     {
539         if (bonusPercent > 0) {
540             return _weiAmount.mul(rate).mul(bonusPercent).div(100);
541         }
542         return 0;
543     }
544 
545     function _getTokenAmount(uint256 _weiAmount)
546     internal
547     view
548     returns (uint256)
549     {
550         if (bonusPercent > 0) {
551             return _weiAmount.mul(rate).mul(100 + bonusPercent).div(100);
552         }
553         return _weiAmount.mul(rate);
554     }
555 
556     function _processBonusStateSave(
557         address _beneficiary,
558         uint256 _weiAmount
559     )
560     internal
561     {
562         bonuses[_beneficiary] = bonuses[_beneficiary].add(getBonusTokenAmount(_weiAmount));
563         super._processBonusStateSave(_beneficiary, _weiAmount);
564     }
565 
566     function bonusOf(address _owner) public view returns (uint256) {
567         return bonuses[_owner];
568     }
569 }