1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 /**
25  * @title SafeMath
26  * @dev Unsigned math operations with safety checks that revert on error
27  */
28 library SafeMath {
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Adds two unsigned integers, reverts on overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     /**
79      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80      * reverts when dividing by zero.
81      */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0);
84         return a % b;
85     }
86 }
87 
88 /**
89  * @title SafeERC20
90  * @dev Wrappers around ERC20 operations that throw on failure.
91  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
92  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
93  */
94 library SafeERC20 {
95     using SafeMath for uint256;
96 
97     function safeTransfer(IERC20 token, address to, uint256 value) internal {
98         require(token.transfer(to, value));
99     }
100 
101     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
102         require(token.transferFrom(from, to, value));
103     }
104 
105     function safeApprove(IERC20 token, address spender, uint256 value) internal {
106         // safeApprove should only be called when setting an initial allowance,
107         // or when resetting it to zero. To increase and decrease it, use
108         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
109         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
110         require(token.approve(spender, value));
111     }
112 
113     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
114         uint256 newAllowance = token.allowance(address(this), spender).add(value);
115         require(token.approve(spender, newAllowance));
116     }
117 
118     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
119         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
120         require(token.approve(spender, newAllowance));
121     }
122 }
123 /**
124  * @title Helps contracts guard against reentrancy attacks.
125  * @author Remco Bloemen <remco@2?.com>, Eenae <alexey@mixbytes.io>
126  * @dev If you mark a function `nonReentrant`, you should also
127  * mark it `external`.
128  */
129 contract ReentrancyGuard {
130     /// @dev counter to allow mutex lock with only one SSTORE operation
131     uint256 private _guardCounter;
132 
133     constructor () internal {
134         // The counter starts at one to prevent changing it from zero to a non-zero
135         // value, which is a more expensive operation.
136         _guardCounter = 1;
137     }
138 
139     /**
140      * @dev Prevents a contract from calling itself, directly or indirectly.
141      * Calling a `nonReentrant` function from another `nonReentrant`
142      * function is not supported. It is possible to prevent this from happening
143      * by making the `nonReentrant` function external, and make it call a
144      * `private` function that does the actual work.
145      */
146     modifier nonReentrant() {
147         _guardCounter += 1;
148         uint256 localCounter = _guardCounter;
149         _;
150         require(localCounter == _guardCounter);
151     }
152 }
153 
154 /**
155  * @title Ownable
156  * @dev The Ownable contract has an owner address, and provides basic authorization control
157  * functions, this simplifies the implementation of "user permissions".
158  */
159 contract Ownable {
160     address private _owner;
161 
162     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164     /**
165      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
166      * account.
167      */
168     constructor () internal {
169         _owner = msg.sender;
170         emit OwnershipTransferred(address(0), _owner);
171     }
172 
173     /**
174      * @return the address of the owner.
175      */
176     function owner() public view returns (address) {
177         return _owner;
178     }
179 
180     /**
181      * @dev Throws if called by any account other than the owner.
182      */
183     modifier onlyOwner() {
184         require(isOwner());
185         _;
186     }
187 
188     /**
189      * @return true if `msg.sender` is the owner of the contract.
190      */
191     function isOwner() public view returns (bool) {
192         return msg.sender == _owner;
193     }
194 
195     /**
196      * @dev Allows the current owner to relinquish control of the contract.
197      * @notice Renouncing to ownership will leave the contract without an owner.
198      * It will not be possible to call the functions with the `onlyOwner`
199      * modifier anymore.
200      */
201     function renounceOwnership() public onlyOwner {
202         emit OwnershipTransferred(_owner, address(0));
203         _owner = address(0);
204     }
205 
206     /**
207      * @dev Allows the current owner to transfer control of the contract to a newOwner.
208      * @param newOwner The address to transfer ownership to.
209      */
210     function transferOwnership(address newOwner) public onlyOwner {
211         _transferOwnership(newOwner);
212     }
213 
214     /**
215      * @dev Transfers control of the contract to a newOwner.
216      * @param newOwner The address to transfer ownership to.
217      */
218     function _transferOwnership(address newOwner) internal {
219         require(newOwner != address(0));
220         emit OwnershipTransferred(_owner, newOwner);
221         _owner = newOwner;
222     }
223 }
224 
225 
226 /**
227  * @title Crowdsale
228  * @dev Crowdsale is a base contract for managing a token crowdsale,
229  * allowing investors to purchase tokens with ether. This contract implements
230  * such functionality in its most fundamental form and can be extended to provide additional
231  * functionality and/or custom behavior.
232  * The external interface represents the basic interface for purchasing tokens, and conform
233  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
234  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
235  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
236  * behavior.
237  */
238 contract Crowdsale is ReentrancyGuard, Ownable {
239     using SafeMath for uint256;
240     using SafeERC20 for IERC20;
241     
242     // The token being sold
243     IERC20 private _token;
244     // start ICO
245     uint256 public _startStage1;
246     uint256 public _startStage2;
247     // Address where funds are collected
248     address payable private _wallet;
249     uint256 public _maxPay;
250     uint256 public _minPay;
251 
252     // How many token units a buyer gets per wei.
253     // The rate is the conversion between wei and the smallest and indivisible token unit.
254     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
255     // 1 wei will give you 1 unit, or 0.001 TOK.
256     // token - EUR
257     uint256 private _rate; // 6 decimals
258 
259     // Amount of wei raised
260     uint256 private _weiRaised;     
261     //whitelist
262     //for startStage1	
263     mapping (address => uint32) public whitelist;
264 	mapping(address => uint256)   _investors;
265     //for startStage2
266     uint256   _totalNumberPayments = 0;
267     uint256   _numberPaidPayments = 0;
268     mapping(uint256 => address)  _paymentAddress;
269     mapping(uint256 => uint256)  _paymentDay;
270     mapping(uint256 => uint256)   _paymentValue;
271     mapping(uint256 => uint256)   _totalAmountDay;
272     mapping(uint256 => uint8)   _paymentFlag;
273     uint256 public  _amountTokensPerDay;
274     /**
275      * Event for token purchase logging
276      * @param purchaser who paid for the tokens
277      * @param beneficiary who got the tokens
278      * @param value weis paid for purchase
279      * @param amount amount of tokens purchased
280      */
281     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
282 
283     constructor () public {
284 	  // You need to change the parameter values to yours
285         _startStage1 = 1555732800;
286         _startStage2 = 1557028801;
287         _rate = 231;
288         _wallet = 0x68A924EA85c96e74A05cf12465cB53702a560811;
289         _token = IERC20(0xC0D766017141dd4866738C1e704Be6feDc97B904);
290         _amountTokensPerDay = 2000000000000000000000000;
291         _maxPay = 100 * 1 ether;
292         _minPay = 1 * 200000000000000000;
293       //////////
294         require(_rate > 0);
295         require(_wallet != address(0));
296         require(address(_token) != address(0));
297         require(_startStage2 > _startStage1 + 15 * 1 days);
298     }
299     //  1 - allow, 0 - denied 
300     function setWhiteList(address _address, uint32 _flag) public onlyOwner  {
301       whitelist[_address] = _flag;
302     }
303     // 1 - allow
304     function addAddressToWhiteList(address[] memory _addr) public onlyOwner {
305       for(uint256 i = 0; i < _addr.length; i++) {
306        whitelist[_addr[i]] = 1;
307       }
308     }
309     // 0 - denied 
310     function subAddressToWhiteList(address[] memory _addr) public onlyOwner {
311       for(uint256 i = 0; i < _addr.length; i++) {
312         whitelist[_addr[i]] = 0;
313       }
314     } 
315     
316     function setRate(uint256 rate) public onlyOwner  {
317         _rate = rate;
318     } 
319     function setMaxPay(uint256 maxPay) public onlyOwner  {
320         _maxPay = maxPay;
321     }     
322     function setMinPay(uint256 minPay) public onlyOwner  {
323         _minPay = minPay;
324     }      
325     function _returnTokens(address wallet, uint256 value) public onlyOwner {
326         _token.transfer(wallet, value);
327     }  
328     /**
329      * @dev fallback function ***DO NOT OVERRIDE***
330      * Note that other contracts will transfer fund with a base gas stipend
331      * of 2300, which is not enough to call buyTokens. Consider calling
332      * buyTokens directly when purchasing tokens from a contract.
333      */
334     function () external payable {
335         buyTokens(msg.sender);
336     }
337 
338     /**
339      * @return the token being sold.
340      */
341     function token() public view returns (IERC20) {
342         return _token;
343     }
344 
345     /**
346      * @return the address where funds are collected.
347      */
348     function wallet() public view returns (address payable) {
349         return _wallet;
350     }
351 
352     /**
353      * @return the number of token units a buyer gets per wei.
354      */
355     function rate() public view returns (uint256) {
356         return _rate;
357     }
358 
359     /**
360      * @return the amount of wei raised.
361      */
362     function weiRaised() public view returns (uint256) {
363         return _weiRaised;
364     }
365 
366     /**
367      * @dev low level token purchase ***DO NOT OVERRIDE***
368      * This function has a non-reentrancy guard, so it shouldn't be called by
369      * another `nonReentrant` function.
370      * @param beneficiary Recipient of the token purchase
371      */
372     function buyTokens(address beneficiary) public nonReentrant payable {
373         uint256 weiAmount;
374         uint256 tokens;
375         
376         weiAmount = msg.value;
377         
378         _preValidatePurchase(beneficiary, weiAmount);   
379       
380         if (now >= _startStage1 && now < _startStage2){
381           require(whitelist[msg.sender] == 1);		  
382 		  require(weiAmount >= _minPay); 
383 		  _investors[msg.sender] = _investors[msg.sender] + weiAmount;
384           require(_investors[msg.sender] <= _maxPay);
385 		  
386           // calculate token amount to be created
387           tokens = _getTokenAmount(weiAmount);
388 
389           // update state
390           _weiRaised = _weiRaised.add(weiAmount);
391 
392           _processPurchase(beneficiary, tokens);
393           emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
394 
395           _forwardFunds();
396         }
397         if (now >= _startStage2 && now < _startStage2 + 241 * 1 days){
398           _totalNumberPayments = _totalNumberPayments + 1; 
399           _paymentAddress[_totalNumberPayments] = msg.sender;
400           _paymentValue[_totalNumberPayments] = msg.value;
401           _paymentDay[_totalNumberPayments] = _getDayNumber();
402           _totalAmountDay[_getDayNumber()] = _totalAmountDay[_getDayNumber()] + msg.value;
403           _forwardFunds();
404         }
405         
406     }
407     function makePayment(uint256 numberPayments) public onlyOwner{
408         address addressParticipant;
409         uint256 paymentValue;
410         uint256 dayNumber; 
411         uint256 totalPaymentValue;
412         uint256 tokensAmount;
413         if (numberPayments > _totalNumberPayments.sub(_numberPaidPayments)){
414           numberPayments = _totalNumberPayments.sub(_numberPaidPayments);  
415         }
416         uint256 startNumber = _numberPaidPayments.add(1);
417         uint256 endNumber = _numberPaidPayments.add(numberPayments);
418         for (uint256 i = startNumber; i <= endNumber; ++i) {
419           if (_paymentFlag[i] != 1){
420             dayNumber = _paymentDay[i];
421             if (_getDayNumber() > dayNumber){   
422               addressParticipant = _paymentAddress[i];
423               paymentValue = _paymentValue[i];
424               totalPaymentValue = _totalAmountDay[dayNumber];
425               tokensAmount = _amountTokensPerDay.mul(paymentValue).div(totalPaymentValue);
426               _token.safeTransfer(addressParticipant, tokensAmount);
427               _paymentFlag[i] = 1;
428               _numberPaidPayments = _numberPaidPayments + 1;
429             }
430           }
431         }    
432     }
433     /**
434      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
435      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
436      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
437      *     super._preValidatePurchase(beneficiary, weiAmount);
438      *     require(weiRaised().add(weiAmount) <= cap);
439      * @param beneficiary Address performing the token purchase
440      * @param weiAmount Value in wei involved in the purchase
441      */ 
442     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
443         require(beneficiary != address(0));
444         require(weiAmount != 0);
445         require(now >= _startStage1 && now <= _startStage2 + 241 * 1 days);
446         
447     }
448     function _getAmountUnpaidPayments() public view returns (uint256){
449         return _totalNumberPayments.sub(_numberPaidPayments);
450     }    
451     function _getDayNumber() internal view returns (uint256){
452         return ((now.add(1 days)).sub(_startStage2)).div(1 days);
453     }
454 
455     /**
456      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
457      * its tokens.
458      * @param beneficiary Address performing the token purchase
459      * @param tokenAmount Number of tokens to be emitted
460      */
461     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
462         _token.safeTransfer(beneficiary, tokenAmount);
463     }
464 
465     /**
466      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
467      * tokens.
468      * @param beneficiary Address receiving the tokens
469      * @param tokenAmount Number of tokens to be purchased
470      */
471     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
472         _deliverTokens(beneficiary, tokenAmount);
473     }
474 
475     /**
476      * @dev Override to extend the way in which ether is converted to tokens.
477      * @param weiAmount Value in wei to be converted into tokens
478      * @return Number of tokens that can be purchased with the specified _weiAmount
479      */
480     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
481         // tokensAmount = weiAmount.mul(_rateETHEUR).mul(10000).div(_rate);
482        // return weiAmount.mul(_rate);
483            uint256 bonus;
484     if (now >= _startStage1 && now < _startStage1 + 5 * 1 days){
485       bonus = 20;    
486     }
487     if (now >= _startStage1 + 5 * 1 days && now < _startStage1 + 10 * 1 days){
488       bonus = 10;    
489     }   
490     if (now >= _startStage1 + 10 * 1 days && now < _startStage1 + 15 * 1 days){
491       bonus = 5;    
492     }       
493       return weiAmount.mul(1000000).div(_rate) + (weiAmount.mul(1000000).mul(bonus).div(_rate)).div(100);
494     }
495 
496     /**
497      * @dev Determines how ETH is stored/forwarded on purchases.
498      */
499     function _forwardFunds() internal {
500         _wallet.transfer(msg.value);
501     }
502 }