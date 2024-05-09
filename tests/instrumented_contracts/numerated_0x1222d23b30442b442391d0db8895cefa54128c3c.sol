1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @title Math
6  * @dev Assorted math operations
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Calculates the average of two numbers. Since these are integers,
25      * averages of an even and odd number cannot be represented, and will be
26      * rounded down.
27      */
28     function average(uint256 a, uint256 b) internal pure returns (uint256) {
29         // (a + b) / 2 can overflow, so we distribute
30         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
31     }
32 }
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Unsigned math operations with safety checks that revert on error
38  */
39 library SafeMath {
40     /**
41      * @dev Multiplies two unsigned integers, reverts on overflow.
42      */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
59      */
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0);
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         require(b <= a);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Adds two unsigned integers, reverts on overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a);
85 
86         return c;
87     }
88 
89     /**
90      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
91      * reverts when dividing by zero.
92      */
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b != 0);
95         return a % b;
96     }
97 }
98 
99 
100 /**
101  * @title Ownable
102  * @dev The Ownable contract has an owner address, and provides basic authorization control
103  * functions, this simplifies the implementation of "user permissions".
104  */
105 contract Ownable {
106     address private _owner;
107 
108     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
109 
110     /**
111      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112      * account.
113      */
114     constructor () internal {
115         _owner = msg.sender;
116         emit OwnershipTransferred(address(0), _owner);
117     }
118 
119     /**
120      * @return the address of the owner.
121      */
122     function owner() public view returns (address) {
123         return _owner;
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         require(isOwner());
131         _;
132     }
133 
134     /**
135      * @return true if `msg.sender` is the owner of the contract.
136      */
137     function isOwner() public view returns (bool) {
138         return msg.sender == _owner;
139     }
140 
141     /**
142      * @dev Allows the current owner to relinquish control of the contract.
143      * It will not be possible to call the functions with the `onlyOwner`
144      * modifier anymore.
145      * @notice Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public onlyOwner {
149         emit OwnershipTransferred(_owner, address(0));
150         _owner = address(0);
151     }
152 
153     /**
154      * @dev Allows the current owner to transfer control of the contract to a newOwner.
155      * @param newOwner The address to transfer ownership to.
156      */
157     function transferOwnership(address newOwner) public onlyOwner {
158         _transferOwnership(newOwner);
159     }
160 
161     /**
162      * @dev Transfers control of the contract to a newOwner.
163      * @param newOwner The address to transfer ownership to.
164      */
165     function _transferOwnership(address newOwner) internal {
166         require(newOwner != address(0));
167         emit OwnershipTransferred(_owner, newOwner);
168         _owner = newOwner;
169     }
170 }
171 
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 interface IERC20 {
178   function totalSupply() external view returns (uint256);
179 
180   function balanceOf(address who) external view returns (uint256);
181 
182   function allowance(address owner, address spender)
183     external view returns (uint256);
184 
185   function transfer(address to, uint256 value) external returns (bool);
186 
187   function approve(address spender, uint256 value)
188     external returns (bool);
189 
190   function transferFrom(address from, address to, uint256 value)
191     external returns (bool);
192 
193   event Transfer(
194     address indexed from,
195     address indexed to,
196     uint256 value
197   );
198 
199   event Approval(
200     address indexed owner,
201     address indexed spender,
202     uint256 value
203   );
204 }
205 
206 
207 /**
208  * @title SafeERC20
209  * @dev Wrappers around ERC20 operations that throw on failure.
210  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
211  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
212  */
213 library SafeERC20 {
214     using SafeMath for uint256;
215 
216     function safeTransfer(IERC20 token, address to, uint256 value) internal {
217         require(token.transfer(to, value));
218     }
219 
220     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
221         require(token.transferFrom(from, to, value));
222     }
223 
224     function safeApprove(IERC20 token, address spender, uint256 value) internal {
225         // safeApprove should only be called when setting an initial allowance,
226         // or when resetting it to zero. To increase and decrease it, use
227         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
228         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
229         require(token.approve(spender, value));
230     }
231 
232     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
233         uint256 newAllowance = token.allowance(address(this), spender).add(value);
234         require(token.approve(spender, newAllowance));
235     }
236 
237     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
238         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
239         require(token.approve(spender, newAllowance));
240     }
241 }
242 
243 
244 /**
245  * @title TokenSale
246  */
247 contract TokenSale is Ownable {
248     using SafeMath for uint256;
249     using SafeERC20 for IERC20;
250 
251     // token for sale
252     IERC20 public saleToken;
253 
254     // address where funds are collected
255     address public fundCollector;
256 
257     // address where has tokens to sell
258     address public tokenWallet;
259 
260     // use whitelist[user] to get whether the user was allowed to buy
261     mapping(address => bool) public whitelist;
262 
263     // exchangeable token
264     struct ExToken {
265         bool accepted;
266         uint256 rate;
267     }
268 
269     // exchangeable tokens
270     mapping(address => ExToken) private _exTokens;
271 
272     // bonus threshold
273     uint256 public bonusThreshold;
274 
275     // tier-1 bonus
276     uint256 public tierOneBonusTime;
277     uint256 public tierOneBonusRate;
278 
279     // tier-2 bonus
280     uint256 public tierTwoBonusTime;
281     uint256 public tierTwoBonusRate;
282 
283     /**
284      * @param setter who set fund collector
285      * @param fundCollector address of fund collector
286      */
287     event FundCollectorSet(
288         address indexed setter,
289         address indexed fundCollector
290     );
291 
292     /**
293      * @param setter who set sale token
294      * @param saleToken address of sale token
295      */
296     event SaleTokenSet(
297         address indexed setter,
298         address indexed saleToken
299     );
300 
301     /**
302      * @param setter who set token wallet
303      * @param tokenWallet address of token wallet
304      */
305     event TokenWalletSet(
306         address indexed setter,
307         address indexed tokenWallet
308     );
309 
310     /**
311      * @param setter who set bonus threshold
312      * @param bonusThreshold exceed the threshold will get bonus
313      * @param tierOneBonusTime tier one bonus timestamp
314      * @param tierOneBonusRate tier one bonus rate
315      * @param tierTwoBonusTime tier two bonus timestamp
316      * @param tierTwoBonusRate tier two bonus rate
317      */
318     event BonusConditionsSet(
319         address indexed setter,
320         uint256 bonusThreshold,
321         uint256 tierOneBonusTime,
322         uint256 tierOneBonusRate,
323         uint256 tierTwoBonusTime,
324         uint256 tierTwoBonusRate
325     );
326 
327     /**
328      * @param setter who set the whitelist
329      * @param user address of the user
330      * @param allowed whether the user allowed to buy
331      */
332     event WhitelistSet(
333         address indexed setter,
334         address indexed user,
335         bool allowed
336     );
337 
338     /**
339      * event for logging exchangeable token updates
340      * @param setter who set the exchangeable token
341      * @param exToken the exchangeable token
342      * @param accepted whether the exchangeable token was accepted
343      * @param rate exchange rate of the exchangeable token
344      */
345     event ExTokenSet(
346         address indexed setter,
347         address indexed exToken,
348         bool accepted,
349         uint256 rate
350     );
351 
352     /**
353      * event for token purchase logging
354      * @param buyer address of token buyer
355      * @param exToken address of the exchangeable token
356      * @param exTokenAmount amount of the exchangeable tokens
357      * @param amount amount of tokens purchased
358      */
359     event TokensPurchased(
360         address indexed buyer,
361         address indexed exToken,
362         uint256 exTokenAmount,
363         uint256 amount
364     );
365 
366     /**
367      * @param fundCollector address where collected funds will be forwarded to
368      * @param saleToken address of the token being sold
369      * @param tokenWallet address of wallet has tokens to sell
370      */
371     constructor (
372         address fundCollector,
373         address saleToken,
374         address tokenWallet,
375         uint256 bonusThreshold,
376         uint256 tierOneBonusTime,
377         uint256 tierOneBonusRate,
378         uint256 tierTwoBonusTime,
379         uint256 tierTwoBonusRate
380     )
381         public
382     {
383         _setFundCollector(fundCollector);
384         _setSaleToken(saleToken);
385         _setTokenWallet(tokenWallet);
386         _setBonusConditions(
387             bonusThreshold,
388             tierOneBonusTime,
389             tierOneBonusRate,
390             tierTwoBonusTime,
391             tierTwoBonusRate
392         );
393 
394     }
395 
396     /**
397      * @param fundCollector address of the fund collector
398      */
399     function setFundCollector(address fundCollector) external onlyOwner {
400         _setFundCollector(fundCollector);
401     }
402 
403     /**
404      * @param collector address of the fund collector
405      */
406     function _setFundCollector(address collector) private {
407         require(collector != address(0), "fund collector cannot be 0x0");
408         fundCollector = collector;
409         emit FundCollectorSet(msg.sender, collector);
410     }
411 
412     /**
413      * @param saleToken address of the sale token
414      */
415     function setSaleToken(address saleToken) external onlyOwner {
416         _setSaleToken(saleToken);
417     }
418 
419     /**
420      * @param token address of the sale token
421      */
422     function _setSaleToken(address token) private {
423         require(token != address(0), "sale token cannot be 0x0");
424         saleToken = IERC20(token);
425         emit SaleTokenSet(msg.sender, token);
426     }
427 
428     /**
429      * @param tokenWallet address of the token wallet
430      */
431     function setTokenWallet(address tokenWallet) external onlyOwner {
432         _setTokenWallet(tokenWallet);
433     }
434 
435     /**
436      * @param wallet address of the token wallet
437      */
438     function _setTokenWallet(address wallet) private {
439         require(wallet != address(0), "token wallet cannot be 0x0");
440         tokenWallet = wallet;
441         emit TokenWalletSet(msg.sender, wallet);
442     }
443 
444     /**
445      * @param threshold exceed the threshold will get bonus
446      * @param t1BonusTime before t1 bonus timestamp will use t1 bonus rate
447      * @param t1BonusRate tier-1 bonus rate
448      * @param t2BonusTime before t2 bonus timestamp will use t2 bonus rate
449      * @param t2BonusRate tier-2 bonus rate
450      */
451     function setBonusConditions(
452         uint256 threshold,
453         uint256 t1BonusTime,
454         uint256 t1BonusRate,
455         uint256 t2BonusTime,
456         uint256 t2BonusRate
457     )
458         external
459         onlyOwner
460     {
461         _setBonusConditions(
462             threshold,
463             t1BonusTime,
464             t1BonusRate,
465             t2BonusTime,
466             t2BonusRate
467         );
468     }
469 
470     /**
471      * @param threshold exceed the threshold will get bonus
472      */
473     function _setBonusConditions(
474         uint256 threshold,
475         uint256 t1BonusTime,
476         uint256 t1BonusRate,
477         uint256 t2BonusTime,
478         uint256 t2BonusRate
479     )
480         private
481         onlyOwner
482     {
483         require(threshold > 0," threshold cannot be zero.");
484         require(t1BonusTime < t2BonusTime, "invalid bonus time");
485         require(t1BonusRate >= t2BonusRate, "invalid bonus rate");
486 
487         bonusThreshold = threshold;
488         tierOneBonusTime = t1BonusTime;
489         tierOneBonusRate = t1BonusRate;
490         tierTwoBonusTime = t2BonusTime;
491         tierTwoBonusRate = t2BonusRate;
492 
493         emit BonusConditionsSet(
494             msg.sender,
495             threshold,
496             t1BonusTime,
497             t1BonusRate,
498             t2BonusTime,
499             t2BonusRate
500         );
501     }
502 
503     /**
504      * @notice set allowed to ture to add the user into the whitelist
505      * @notice set allowed to false to remove the user from the whitelist
506      * @param user address of user
507      * @param allowed whether allow the user to deposit/withdraw or not
508      */
509     function setWhitelist(address user, bool allowed) external onlyOwner {
510         whitelist[user] = allowed;
511         emit WhitelistSet(msg.sender, user, allowed);
512     }
513 
514     /**
515      * @dev checks the amount of tokens left in the allowance.
516      * @return amount of tokens left in the allowance
517      */
518     function remainingTokens() external view returns (uint256) {
519         return Math.min(
520             saleToken.balanceOf(tokenWallet),
521             saleToken.allowance(tokenWallet, address(this))
522         );
523     }
524 
525     /**
526      * @param exToken address of the exchangeable token
527      * @param accepted true: accepted; false: rejected
528      * @param rate exchange rate
529      */
530     function setExToken(
531         address exToken,
532         bool accepted,
533         uint256 rate
534     )
535         external
536         onlyOwner
537     {
538         _exTokens[exToken].accepted = accepted;
539         _exTokens[exToken].rate = rate;
540         emit ExTokenSet(msg.sender, exToken, accepted, rate);
541     }
542 
543     /**
544      * @param exToken address of the exchangeable token
545      * @return whether the exchangeable token is accepted or not
546      */
547     function accepted(address exToken) public view returns (bool) {
548         return _exTokens[exToken].accepted;
549     }
550 
551     /**
552      * @param exToken address of the exchangeale token
553      * @return amount of sale token a buyer gets per exchangeable token
554      */
555     function rate(address exToken) external view returns (uint256) {
556         return _exTokens[exToken].rate;
557     }
558 
559     /**
560      * @dev get exchangeable sale token amount
561      * @param exToken address of the exchangeable token
562      * @param amount amount of the exchangeable token (how much to pay)
563      * @return purchased sale token amount
564      */
565     function exchangeableAmounts(
566         address exToken,
567         uint256 amount
568     )
569         external
570         view
571         returns (uint256)
572     {
573         return _getTokenAmount(exToken, amount);
574     }
575 
576     /**
577      * @dev buy tokens
578      * @dev buyer must be in whitelist
579      * @param exToken address of the exchangeable token
580      * @param amount amount of the exchangeable token
581      */
582     function buyTokens(
583         address exToken,
584         uint256 amount
585     )
586         external
587     {
588         require(_exTokens[exToken].accepted, "token was not accepted");
589         require(amount != 0, "amount cannot 0");
590         require(whitelist[msg.sender], "buyer must be in whitelist");
591         // calculate token amount to sell
592         uint256 tokens = _getTokenAmount(exToken, amount);
593         require(tokens >= 10**19, "at least buy 10 tokens per purchase");
594         _forwardFunds(exToken, amount);
595         _processPurchase(msg.sender, tokens);
596         emit TokensPurchased(msg.sender, exToken, amount, tokens);
597     }
598 
599     /**
600      * @dev buyer transfers amount of the exchangeable token to fund collector
601      * @param exToken address of the exchangeable token
602      * @param amount amount of the exchangeable token will send to fund collector
603      */
604     function _forwardFunds(address exToken, uint256 amount) private {
605         IERC20(exToken).safeTransferFrom(msg.sender, fundCollector, amount);
606     }
607 
608     /**
609      * @dev calculated purchased sale token amount
610      * @param exToken address of the exchangeable token
611      * @param amount amount of the exchangeable token (how much to pay)
612      * @return amount of purchased sale token
613      */
614     function _getTokenAmount(
615         address exToken,
616         uint256 amount
617     )
618         private
619         view
620         returns (uint256)
621     {
622         // round down value (v) by multiple (m) = (v / m) * m
623         uint256 value = amount
624             .div(100000000000000000)
625             .mul(100000000000000000)
626             .mul(_exTokens[exToken].rate);
627         return _applyBonus(value);
628     }
629 
630     function _applyBonus(
631         uint256 amount
632     )
633         private
634         view
635         returns (uint256)
636     {
637         if (amount < bonusThreshold) {
638             return amount;
639         }
640 
641         if (block.timestamp <= tierOneBonusTime) {
642             return amount.mul(tierOneBonusRate).div(100);
643         } else if (block.timestamp <= tierTwoBonusTime) {
644             return amount.mul(tierTwoBonusRate).div(100);
645         } else {
646             return amount;
647         }
648     }
649 
650     /**
651      * @dev transfer sale token amounts from token wallet to beneficiary
652      * @param beneficiary purchased tokens will transfer to this address
653      * @param tokenAmount purchased token amount
654      */
655     function _processPurchase(
656         address beneficiary,
657         uint256 tokenAmount
658     )
659         private
660     {
661         saleToken.safeTransferFrom(tokenWallet, beneficiary, tokenAmount);
662     }
663 }