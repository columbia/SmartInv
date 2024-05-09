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
262     mapping (address => uint32) public whitelist;
263     //for startStage2
264     uint256   _totalNumberPayments = 0;
265     uint256   _numberPaidPayments = 0;
266     mapping(uint256 => address)  _paymentAddress;
267     mapping(uint256 => uint256)  _paymentDay;
268     mapping(uint256 => uint256)   _paymentValue;
269     mapping(uint256 => uint256)   _totalAmountDay;
270     mapping(uint256 => uint8)   _paymentFlag;
271     uint256 public  _amountTokensPerDay;
272     /**
273      * Event for token purchase logging
274      * @param purchaser who paid for the tokens
275      * @param beneficiary who got the tokens
276      * @param value weis paid for purchase
277      * @param amount amount of tokens purchased
278      */
279     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
280 
281     constructor () public {
282         _startStage1 = 1554737400;
283         _startStage2 = 1555601401;
284         _rate = 224;
285         _wallet = 0x68A924EA85c96e74A05cf12465cB53702a560811;
286         _token = IERC20(0xC0D766017141dd4866738C1e704Be6feDc97B904);
287         _amountTokensPerDay = 1000000000000000000;
288         _maxPay = 1 * 280 ether;
289         _minPay = 1 * 5.6 ether;
290 
291         require(_rate > 0);
292         require(_wallet != address(0));
293         require(address(_token) != address(0));
294         require(_startStage2 > _startStage1 + 1 * 10 days);
295     }
296     //  1 - allow, 0 - denied 
297     function setWhiteList(address _address, uint32 _flag) public onlyOwner  {
298       whitelist[_address] = _flag;
299     }
300     // 1 - allow
301     function addAddressToWhiteList(address[] memory _addr) public onlyOwner {
302       for(uint256 i = 0; i < _addr.length; i++) {
303        whitelist[_addr[i]] = 1;
304       }
305     }
306     // 0 - denied 
307     function subAddressToWhiteList(address[] memory _addr) public onlyOwner {
308       for(uint256 i = 0; i < _addr.length; i++) {
309         whitelist[_addr[i]] = 0;
310       }
311     } 
312     
313     function setRate(uint256 rate) public onlyOwner  {
314         _rate = rate;
315     } 
316     function setMaxPay(uint256 maxPay) public onlyOwner  {
317         _maxPay = maxPay;
318     }     
319     function setMinPay(uint256 minPay) public onlyOwner  {
320         _minPay = minPay;
321     }      
322     function _returnTokens(address wallet, uint256 value) public onlyOwner {
323         _token.transfer(wallet, value);
324     }  
325     /**
326      * @dev fallback function ***DO NOT OVERRIDE***
327      * Note that other contracts will transfer fund with a base gas stipend
328      * of 2300, which is not enough to call buyTokens. Consider calling
329      * buyTokens directly when purchasing tokens from a contract.
330      */
331     function () external payable {
332         buyTokens(msg.sender);
333     }
334 
335     /**
336      * @return the token being sold.
337      */
338     function token() public view returns (IERC20) {
339         return _token;
340     }
341 
342     /**
343      * @return the address where funds are collected.
344      */
345     function wallet() public view returns (address payable) {
346         return _wallet;
347     }
348 
349     /**
350      * @return the number of token units a buyer gets per wei.
351      */
352     function rate() public view returns (uint256) {
353         return _rate;
354     }
355 
356     /**
357      * @return the amount of wei raised.
358      */
359     function weiRaised() public view returns (uint256) {
360         return _weiRaised;
361     }
362 
363     /**
364      * @dev low level token purchase ***DO NOT OVERRIDE***
365      * This function has a non-reentrancy guard, so it shouldn't be called by
366      * another `nonReentrant` function.
367      * @param beneficiary Recipient of the token purchase
368      */
369     function buyTokens(address beneficiary) public nonReentrant payable {
370         uint256 weiAmount;
371         uint256 tokens;
372         
373         weiAmount = msg.value;
374         
375         _preValidatePurchase(beneficiary, weiAmount);   
376       
377         if (now >= _startStage1 && now < _startStage2){
378           require(whitelist[msg.sender] == 1);
379           // calculate token amount to be created
380           tokens = _getTokenAmount(weiAmount);
381 
382           // update state
383           _weiRaised = _weiRaised.add(weiAmount);
384 
385           _processPurchase(beneficiary, tokens);
386           emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
387 
388           _forwardFunds();
389         }
390         if (now >= _startStage2 && now < _startStage2 + 1 * 1 seconds){
391           _totalNumberPayments = _totalNumberPayments + 1; 
392           _paymentAddress[_totalNumberPayments] = msg.sender;
393           _paymentValue[_totalNumberPayments] = msg.value;
394           _paymentDay[_totalNumberPayments] = _getDayNumber();
395           _totalAmountDay[_getDayNumber()] = _totalAmountDay[_getDayNumber()] + msg.value;
396           _forwardFunds();
397         }
398         
399     }
400     function makePayment(uint256 numberPayments) public onlyOwner{
401         address addressParticipant;
402         uint256 paymentValue;
403         uint256 dayNumber; 
404         uint256 totalPaymentValue;
405         uint256 tokensAmount;
406         if (numberPayments > _totalNumberPayments.sub(_numberPaidPayments)){
407           numberPayments = _totalNumberPayments.sub(_numberPaidPayments);  
408         }
409         uint256 startNumber = _numberPaidPayments.add(1);
410         uint256 endNumber = _numberPaidPayments.add(numberPayments);
411         for (uint256 i = startNumber; i <= endNumber; ++i) {
412           if (_paymentFlag[i] != 1){
413             dayNumber = _paymentDay[i];
414             if (_getDayNumber() > dayNumber){   
415               addressParticipant = _paymentAddress[i];
416               paymentValue = _paymentValue[i];
417               totalPaymentValue = _totalAmountDay[dayNumber];
418               tokensAmount = _amountTokensPerDay.mul(paymentValue).div(totalPaymentValue);
419               _token.safeTransfer(addressParticipant, tokensAmount);
420               _paymentFlag[i] = 1;
421               _numberPaidPayments = _numberPaidPayments + 1;
422             }
423           }
424         }    
425     }
426     /**
427      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
428      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
429      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
430      *     super._preValidatePurchase(beneficiary, weiAmount);
431      *     require(weiRaised().add(weiAmount) <= cap);
432      * @param beneficiary Address performing the token purchase
433      * @param weiAmount Value in wei involved in the purchase
434      */ 
435     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
436         require(beneficiary != address(0));
437         require(weiAmount != 0);
438         require(weiAmount >= _minPay); 
439         require(weiAmount <= _maxPay);
440         require(now >= _startStage1 && now <= _startStage2 + 1 * 1 seconds);
441         
442     }
443     function _getAmountUnpaidPayments() public view returns (uint256){
444         return _totalNumberPayments.sub(_numberPaidPayments);
445     }    
446     function _getDayNumber() internal view returns (uint256){
447         return ((now.add(1 seconds)).sub(_startStage2)).div(1 seconds);
448     }
449 
450     /**
451      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
452      * its tokens.
453      * @param beneficiary Address performing the token purchase
454      * @param tokenAmount Number of tokens to be emitted
455      */
456     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
457         _token.safeTransfer(beneficiary, tokenAmount);
458     }
459 
460     /**
461      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
462      * tokens.
463      * @param beneficiary Address receiving the tokens
464      * @param tokenAmount Number of tokens to be purchased
465      */
466     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
467         _deliverTokens(beneficiary, tokenAmount);
468     }
469 
470     /**
471      * @dev Override to extend the way in which ether is converted to tokens.
472      * @param weiAmount Value in wei to be converted into tokens
473      * @return Number of tokens that can be purchased with the specified _weiAmount
474      */
475     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
476         // tokensAmount = weiAmount.mul(_rateETHEUR).mul(10000).div(_rate);
477        // return weiAmount.mul(_rate);
478            uint256 bonus;
479     if (now >= _startStage1 && now < _startStage1 + 1 * 10 days){
480       bonus = 40;    
481     }
482       return weiAmount.mul(1000000).div(_rate) + (weiAmount.mul(1000000).mul(bonus).div(_rate)).div(100);
483     }
484 
485     /**
486      * @dev Determines how ETH is stored/forwarded on purchases.
487      */
488     function _forwardFunds() internal {
489         _wallet.transfer(msg.value);
490     }
491 }