1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers, truncating the quotient.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         // uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return a / b;
34     }
35 
36     /**
37     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38     */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     /**
45     * @dev Adds two numbers, throws on overflow.
46     */
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract Ownable {
55     mapping(address => bool) owners;
56 
57     event OwnerAdded(address indexed newOwner);
58     event OwnerDeleted(address indexed owner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor() public {
65         owners[msg.sender] = true;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(isOwner(msg.sender));
73         _;
74     }
75 
76     function addOwner(address _newOwner) external onlyOwner {
77         require(_newOwner != address(0));
78         owners[_newOwner] = true;
79         emit OwnerAdded(_newOwner);
80     }
81 
82     function delOwner(address _owner) external onlyOwner {
83         require(owners[_owner]);
84         owners[_owner] = false;
85         emit OwnerDeleted(_owner);
86     }
87 
88     function isOwner(address _owner) public view returns (bool) {
89         return owners[_owner];
90     }
91 
92 }
93 
94 
95 contract ERC20 {
96     function allowance(address owner, address spender) public view returns (uint256);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address who) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     function ownerTransfer(address to, uint256 value) public returns (bool);
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     function approve(address spender, uint256 value) public returns (bool);
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 
107 }
108 
109 
110 library SafeERC20 {
111     function safeTransfer(ERC20 token, address to, uint256 value) internal {
112         require(token.transfer(to, value));
113     }
114 
115     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
116         require(token.transferFrom(from, to, value));
117     }
118 
119     function safeApprove(ERC20 token, address spender, uint256 value) internal {
120         require(token.approve(spender, value));
121     }
122 }
123 
124 
125 
126 /**
127  * @title Crowdsale
128  * @dev Crowdsale is a base contract for managing a token crowdsale,
129  * allowing investors to purchase tokens with ether. This contract implements
130  * such functionality in its most fundamental form and can be extended to provide additional
131  * functionality and/or custom behavior.
132  * The external interface represents the basic interface for purchasing tokens, and conform
133  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
134  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
135  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
136  * behavior.
137  */
138 contract Crowdsale is Ownable {
139     using SafeMath for uint256;
140     using SafeERC20 for ERC20;
141 
142     // The token being sold
143     ERC20 public token;
144     address public wallet;
145 
146     uint256 public openingTime;
147 
148     uint256 public cap;                 //кап в токенах
149     uint256 public tokensSold;          //кол-во проданных токенов
150     uint256 public tokenPriceInWei;     //цена токена в веях
151 
152     bool public isFinalized = false;
153 
154     // Amount of wei raised
155     uint256 public weiRaised;
156 
157 
158     struct Stage {
159         uint stopDay;       //день окончания этапа
160         uint bonus;         //бонус в процентах
161         uint tokens;        //кол-во токенов для продажи (без 18 нулей, нули добавляем перед отправкой и без учета бонусных токенов).
162         uint minPurchase;   //минимальная сумма покупки
163     }
164 
165     mapping (uint => Stage) public stages;
166     uint public stageCount;
167     uint public currentStage;
168 
169     mapping (address => uint) public refs;
170     uint public buyerRefPercent = 500;
171     uint public referrerPercent = 500;
172     uint public minWithdrawValue = 200000000000000000;
173     uint public globalMinWithdrawValue = 1000 ether;
174 
175     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens, uint256 bonus);
176     event Finalized();
177 
178 
179     /**
180      * @dev Reverts if not in crowdsale time range.
181      */
182     modifier onlyWhileOpen {
183         // solium-disable-next-line security/no-block-members
184         require(block.timestamp >= openingTime);
185         _;
186     }
187 
188 
189     constructor(address _wallet, ERC20 _token) public {
190         require(_wallet != address(0));
191         require(_token != address(0));
192 
193         wallet = _wallet;
194         token = _token;
195 
196         cap = 32500000;
197         openingTime = now;
198         tokenPriceInWei = 1000000000000000;
199 
200         currentStage = 1;
201 
202         addStage(openingTime + 61    days, 10000, 2500000,  200000000000000000);
203         addStage(openingTime + 122   days, 5000,  5000000,  200000000000000000);
204         addStage(openingTime + 183   days, 1000,  10000000, 1000000000000000);
205         //addStage(openingTime + 1000  days, 0,     9000000000000000000000000,  1000000000000000);
206     }
207 
208     // -----------------------------------------
209     // Crowdsale external interface
210     // -----------------------------------------
211 
212     /**
213      * @dev fallback function ***DO NOT OVERRIDE***
214      */
215     function () external payable {
216         buyTokens(address(0));
217     }
218 
219     function setTokenPrice(uint _price) onlyOwner public {
220         tokenPriceInWei = _price;
221     }
222 
223     function addStage(uint _stopDay, uint _bonus, uint _tokens, uint _minPurchase) onlyOwner public {
224         require(_stopDay > stages[stageCount].stopDay);
225         stageCount++;
226         stages[stageCount].stopDay = _stopDay;
227         stages[stageCount].bonus = _bonus;
228         stages[stageCount].tokens = _tokens;
229         stages[stageCount].minPurchase = _minPurchase;
230     }
231 
232     function editStage(uint _stage, uint _stopDay, uint _bonus,  uint _tokens, uint _minPurchase) onlyOwner public {
233         stages[_stage].stopDay = _stopDay;
234         stages[_stage].bonus = _bonus;
235         stages[_stage].tokens = _tokens;
236         stages[_stage].minPurchase = _minPurchase;
237     }
238 
239 
240     function buyTokens(address _ref) public payable {
241 
242         uint256 weiAmount = msg.value;
243 
244         if (stages[currentStage].stopDay <= now && currentStage < stageCount) {
245             _updateCurrentStage();
246         }
247 
248         _preValidatePurchase(msg.sender, weiAmount);
249 
250         uint tokens = 0;
251         uint bonusTokens = 0;
252         uint totalTokens = 0;
253         uint diff = 0;
254 
255         (tokens, bonusTokens, totalTokens, diff) = _getTokenAmount(weiAmount);
256 
257         _validatePurchase(tokens);
258 
259         weiAmount = weiAmount.sub(diff);
260 
261         if (_ref != address(0) && _ref != msg.sender) {
262             uint refBonus = valueFromPercent(weiAmount, referrerPercent);
263             uint buyerBonus = valueFromPercent(weiAmount, buyerRefPercent);
264 
265             refs[_ref] = refs[_ref].add(refBonus);
266             diff = diff.add(buyerBonus);
267 
268             weiAmount = weiAmount.sub(buyerBonus).sub(refBonus);
269         }
270 
271         if (diff > 0) {
272             msg.sender.transfer(diff);
273         }
274 
275         _processPurchase(msg.sender, totalTokens);
276         emit TokenPurchase(msg.sender, msg.sender, msg.value, tokens, bonusTokens);
277 
278         _updateState(weiAmount, totalTokens);
279 
280         _forwardFunds(weiAmount);
281     }
282 
283     // -----------------------------------------
284     // Internal interface (extensible)
285     // -----------------------------------------
286 
287     /**
288      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
289      * @param _beneficiary Address performing the token purchase
290      * @param _weiAmount Value in wei involved in the purchase
291      */
292     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) onlyWhileOpen internal view{
293         require(_beneficiary != address(0));
294         require(_weiAmount >= stages[currentStage].minPurchase);
295         require(tokensSold < cap);
296     }
297 
298 
299     function _validatePurchase(uint256 _tokens) internal view {
300         require(tokensSold.add(_tokens) <= cap);
301     }
302 
303 
304     /**
305      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
306      * @param _beneficiary Address performing the token purchase
307      * @param _tokenAmount Number of tokens to be emitted
308      */
309     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
310         token.safeTransfer(_beneficiary, _tokenAmount.mul(1 ether));
311     }
312 
313     /**
314      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
315      * @param _beneficiary Address receiving the tokens
316      * @param _tokenAmount Number of tokens to be purchased
317      */
318     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
319         _deliverTokens(_beneficiary, _tokenAmount);
320     }
321 
322 
323     /**
324      * @dev Override to extend the way in which ether is converted to tokens.
325      */
326     function _getTokenAmount(uint256 _weiAmount) internal returns (uint,uint,uint,uint) {
327         uint _tokens;
328         uint _tokens_price;
329 
330         //если все этапы прошли, то продаем токены без бонусов.
331         if (currentStage == stageCount && (stages[stageCount].stopDay <= now || stages[currentStage].tokens == 0)) {
332             _tokens = _weiAmount.div(tokenPriceInWei);
333             _tokens_price = _tokens.mul(tokenPriceInWei);
334             uint _diff = _weiAmount.sub(_tokens_price);
335             return (_tokens, 0, _tokens, _diff);
336         }
337 
338         uint _bonus = 0;
339         uint _current_tokens = 0;
340         uint _current_bonus = 0;
341 
342         for (uint i = currentStage; i <= stageCount && _weiAmount >= tokenPriceInWei; i++) {
343             if (stages[i].tokens > 0 ) {
344                 uint _limit = stages[i].tokens.mul(tokenPriceInWei);
345                 //если лимит больше чем _weiAmount, тогда считаем все из расчета что вписываемся в лимит
346                 //и выходим из цикла
347                 if (_limit > _weiAmount) {
348                     //количество токенов по текущему прайсу (останется остаток если прислали  больше чем на точное количество монет)
349                     _current_tokens = _weiAmount.div(tokenPriceInWei);
350                     //цена всех монет, чтобы определить остаток неизрасходованных wei
351                     _tokens_price = _current_tokens.mul(tokenPriceInWei);
352                     //получаем остаток
353                     _weiAmount = _weiAmount.sub(_tokens_price);
354                     //добавляем токены текущего стэйджа к общему количеству
355                     _tokens = _tokens.add(_current_tokens);
356                     //обновляем лимиты
357                     stages[i].tokens = stages[i].tokens.sub(_current_tokens);
358 
359                     _current_bonus = _current_tokens.mul(stages[i].bonus).div(10000);
360                     _bonus = _bonus.add(_current_bonus);
361 
362                 } else { //лимит меньше чем количество wei
363                     //получаем все оставшиеся токены в стейдже
364                     _current_tokens = stages[i].tokens;
365                     _tokens_price = _current_tokens.mul(tokenPriceInWei);
366                     _weiAmount = _weiAmount.sub(_tokens_price);
367                     _tokens = _tokens.add(_current_tokens);
368                     stages[i].tokens = 0;
369 
370                     _current_bonus = _current_tokens.mul(stages[i].bonus).div(10000);
371                     _bonus = _bonus.add(_current_bonus);
372 
373                     _updateCurrentStage();
374                 }
375             }
376         }
377 
378         //Если в последнем стейндже закончились токены, то добираем из тех что без бонусов продаются
379         if (_weiAmount >= tokenPriceInWei) {
380             _current_tokens = _weiAmount.div(tokenPriceInWei);
381             _tokens_price = _current_tokens.mul(tokenPriceInWei);
382             _weiAmount = _weiAmount.sub(_tokens_price);
383             _tokens = _tokens.add(_current_tokens);
384         }
385 
386         return (_tokens, _bonus, _tokens.add(_bonus), _weiAmount);
387     }
388 
389 
390     function _updateCurrentStage() internal {
391         for (uint i = currentStage; i <= stageCount; i++) {
392             if (stages[i].stopDay > now && stages[i].tokens > 0) {
393                 currentStage = i;
394                 break;
395             }
396         }
397     }
398 
399 
400     function _updateState(uint256 _weiAmount, uint256 _tokens) internal {
401         weiRaised = weiRaised.add(_weiAmount);
402         tokensSold = tokensSold.add(_tokens);
403     }
404 
405 
406     function getRefPercent() public {
407         require(refs[msg.sender] >= minWithdrawValue);
408         require(weiRaised >= globalMinWithdrawValue);
409         uint _val = refs[msg.sender];
410         refs[msg.sender] = 0;
411         msg.sender.transfer(_val);
412     }
413 
414     /**
415      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
416      */
417     function _forwardFunds(uint _weiAmount) internal {
418         wallet.transfer(_weiAmount);
419     }
420 
421     /**
422     * @dev Checks whether the cap has been reached.
423     * @return Whether the cap was reached
424     */
425     function capReached() public view returns (bool) {
426         return tokensSold >= cap;
427     }
428 
429 
430     /**
431      * @dev Must be called after crowdsale ends, to do some extra finalization
432      * work. Calls the contract's finalization function.
433      */
434     function finalize() onlyOwner public {
435         require(!isFinalized);
436         //require(hasClosed() || capReached());
437 
438         finalization();
439         emit Finalized();
440 
441         isFinalized = true;
442     }
443 
444     /**
445      * @dev Can be overridden to add finalization logic. The overriding function
446      * should call super.finalization() to ensure the chain of finalization is
447      * executed entirely.
448      */
449     function finalization() internal {
450         if (token.balanceOf(this) > 0) {
451             token.safeTransfer(wallet, token.balanceOf(this));
452         }
453     }
454 
455 
456     //1% - 100, 10% - 1000 50% - 5000
457     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
458         uint _amount = _value.mul(_percent).div(10000);
459         return (_amount);
460     }
461 
462 
463     function setBuyerRefPercent(uint _buyerRefPercent) onlyOwner public {
464         buyerRefPercent = _buyerRefPercent;
465     }
466 
467     function setReferrerPercent(uint _referrerPercent) onlyOwner public {
468         referrerPercent = _referrerPercent;
469     }
470 
471     function setMinWithdrawValue(uint _minWithdrawValue) onlyOwner public {
472         minWithdrawValue = _minWithdrawValue;
473     }
474 
475     function setGlobalMinWithdrawValue(uint _globalMinWithdrawValue) onlyOwner public {
476         globalMinWithdrawValue = _globalMinWithdrawValue;
477     }
478 
479 
480 
481     /// @notice This method can be used by the owner to extract mistakenly
482     ///  sent tokens to this contract.
483     /// @param _token The address of the token contract that you want to recover
484     ///  set to 0 in case you want to extract ether.
485     function claimTokens(address _token, address _to) external onlyOwner {
486         require(_to != address(0));
487         if (_token == 0x0) {
488             _to.transfer(address(this).balance);
489             return;
490         }
491 
492         ERC20 t = ERC20(_token);
493         uint balance = t.balanceOf(this);
494         t.safeTransfer(_to, balance);
495     }
496 
497 }