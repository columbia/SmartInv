1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
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
91 }
92 
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 {
99     function allowance(address owner, address spender) public view returns (uint256);
100     function transferFrom(address from, address to, uint256 value) public returns (bool);
101     function totalSupply() public view returns (uint256);
102     function balanceOf(address who) public view returns (uint256);
103     function transfer(address to, uint256 value) public returns (bool);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     function approve(address spender, uint256 value) public returns (bool);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://github.com/ethereum/EIPs/issues/20
117  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, Ownable{
120     using SafeMath for uint256;
121 
122     mapping (address => mapping (address => uint256)) internal allowed;
123     mapping(address => uint256) balances;
124 
125     uint256 _totalSupply;
126 
127 
128     /**
129     * @dev Total number of tokens in existence
130     */
131     function totalSupply() public view returns (uint256) {
132         return _totalSupply;
133     }
134 
135     /**
136     * @dev Transfer token for a specified address
137     * @param _to The address to transfer to.
138     * @param _value The amount to be transferred.
139     */
140     function transfer(address _to, uint256 _value)  public returns (bool) {
141         require(_to != address(0));
142         require(_value <= balances[msg.sender]);
143 
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151     * @dev Gets the balance of the specified address.
152     * @param _owner The address to query the the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155     function balanceOf(address _owner) public view returns (uint256) {
156         return balances[_owner];
157     }
158 
159 
160     /**
161      * @dev Transfer tokens from one address to another
162      * @param _from address The address which you want to send tokens from
163      * @param _to address The address which you want to transfer to
164      * @param _value uint256 the amount of tokens to be transferred
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170 
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         emit Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      * Beware that changing an allowance with this method brings the risk that someone may use both the old
181      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      * @param _spender The address which will spend the funds.
185      * @param _value The amount of tokens to be spent.
186      */
187     function approve(address _spender, uint256 _value) public returns (bool) {
188         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189         allowed[msg.sender][_spender] = _value;
190         emit Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * Set allowance for other address and notify
196      *
197      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
198      *
199      * @param _spender The address authorized to spend
200      * @param _value the max amount they can spend
201      * @param _extraData some extra information to send to the approved contract
202      */
203     function approveAndCall(address _spender, uint256 _value, bytes _extraData)  public returns (bool success) {
204         tokenRecipient spender = tokenRecipient(_spender);
205         if (approve(_spender, _value)) {
206             spender.receiveApproval(msg.sender, _value, this, _extraData);
207             return true;
208         }
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param _owner address The address which owns the funds.
214      * @param _spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222      * @dev Increase the amount of tokens that an owner allowed to a spender.
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      * @param _spender The address which will spend the funds.
228      * @param _addedValue The amount of tokens to increase the allowance by.
229      */
230     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
231         allowed[msg.sender][_spender] = (
232         allowed[msg.sender][_spender].add(_addedValue));
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237     /**
238      * @dev Decrease the amount of tokens that an owner allowed to a spender.
239      * approve should be called when allowed[_spender] == 0. To decrement
240      * allowed value is better to use this function to avoid 2 calls (and wait until
241      * the first transaction is mined)
242      * From MonolithDAO Token.sol
243      * @param _spender The address which will spend the funds.
244      * @param _subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
247         uint256 oldValue = allowed[msg.sender][_spender];
248         if (_subtractedValue > oldValue) {
249             allowed[msg.sender][_spender] = 0;
250         } else {
251             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252         }
253         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254         return true;
255     }
256 
257 
258     function burn(uint256 value) onlyOwner external {
259         _totalSupply = _totalSupply.sub(value);
260         balances[msg.sender] = balances[msg.sender].sub(value);
261         emit Transfer(msg.sender, address(0), value);
262     }
263 
264 }
265 
266 
267 /**
268  * @title SimpleToken
269  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
270  * Note they can later distribute these tokens as they wish using `transfer` and other
271  * `StandardToken` functions.
272  */
273 contract ErbNToken is StandardToken {
274     string public constant name = "Erbauer Netz"; // solium-disable-line uppercase
275     string public constant symbol = "ErbN"; // solium-disable-line uppercase
276     uint8 public constant decimals = 18; // solium-disable-line uppercase
277 
278     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
279 
280 
281     constructor() public {
282         _totalSupply = INITIAL_SUPPLY;
283         balances[msg.sender] = INITIAL_SUPPLY;
284         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
285     }
286 
287 }
288 
289 
290 
291 
292 /**
293  * @title SafeERC20
294  * @dev Wrappers around ERC20 operations that throw on failure.
295  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
296  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
297  */
298 library SafeERC20 {
299     function safeTransfer(ERC20 token, address to, uint256 value) internal {
300         require(token.transfer(to, value));
301     }
302 
303     function safeTransferFrom(
304         ERC20 token,
305         address from,
306         address to,
307         uint256 value
308     )
309     internal
310     {
311         require(token.transferFrom(from, to, value));
312     }
313 
314     function safeApprove(ERC20 token, address spender, uint256 value) internal {
315         require(token.approve(spender, value));
316     }
317 }
318 
319 
320 /**
321  * @title Crowdsale
322  * @dev Crowdsale is a base contract for managing a token crowdsale,
323  * allowing investors to purchase tokens with ether. This contract implements
324  * such functionality in its most fundamental form and can be extended to provide additional
325  * functionality and/or custom behavior.
326  * The external interface represents the basic interface for purchasing tokens, and conform
327  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
328  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
329  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
330  * behavior.
331  */
332 contract Crowdsale is Ownable {
333     using SafeMath for uint256;
334     using SafeERC20 for ERC20;
335 
336     // The token being sold
337     ERC20 public token;
338 
339     // Address where funds are collected
340     address public wallet;
341 
342     // How many token units a buyer gets per wei.
343     // The rate is the conversion between wei and the smallest and indivisible token unit.
344     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
345     // 1 wei will give you 1 unit, or 0.001 TOK.
346     uint256 public rate;
347     uint256 public preSaleRate;
348     uint256 minPurchase = 10000000000000000;
349     uint256 tokenSold;
350 
351     // Amount of wei raised
352     uint256 public weiRaised;
353 
354     bool public isPreSale = false;
355     bool public isICO = false;
356 
357     /**
358      * Event for token purchase logging
359      * @param purchaser who paid for the tokens
360      * @param beneficiary who got the tokens
361      * @param value weis paid for purchase
362      * @param amount amount of tokens purchased
363      */
364     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
365     event Finalized();
366     /**
367      * @dev Reverts if not in crowdsale time range.
368      */
369     modifier onlyWhileOpen {
370         // solium-disable-next-line security/no-block-members
371         require(isPreSale || isICO);
372         _;
373     }
374 
375 
376     constructor(uint256 _rate, uint256 _preSaleRate, address _wallet, address _token) public {
377         require(_rate > 0);
378         require(_preSaleRate > 0);
379         require(_wallet != address(0));
380         require(_token != address(0));
381 
382         preSaleRate = _preSaleRate;
383         rate = _rate;
384         wallet = _wallet;
385         token = ERC20(_token);
386     }
387 
388     // -----------------------------------------
389     // Crowdsale external interface
390     // -----------------------------------------
391 
392     /**
393      * @dev fallback function ***DO NOT OVERRIDE***
394      */
395     function () external payable {
396         buyTokens(msg.sender);
397     }
398 
399     /**
400      * @dev low level token purchase ***DO NOT OVERRIDE***
401      * @param _beneficiary Address performing the token purchase
402      */
403     function buyTokens(address _beneficiary) public payable {
404         uint256 weiAmount = msg.value;
405         _preValidatePurchase(_beneficiary, weiAmount);
406 
407         // calculate token amount to be created
408         uint256 tokens = _getTokenAmount(weiAmount);
409         _postValidatePurchase(tokens);
410 
411         // update state
412         tokenSold = tokenSold.add(tokens);
413 
414         _processPurchase(_beneficiary, tokens);
415         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
416 
417         _forwardFunds();
418     }
419 
420 
421     function manualSale(address _beneficiary, uint256 _amount) onlyOwner external {
422         _processPurchase(_beneficiary, _amount);
423     }
424 
425     // -----------------------------------------
426     // Internal interface (extensible)
427     // -----------------------------------------
428 
429     /**
430      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
431      * @param _beneficiary Address performing the token purchase
432      * @param _weiAmount Value in wei involved in the purchase
433      */
434     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) onlyWhileOpen internal view {
435         require(_beneficiary != address(0));
436         require(_weiAmount >= minPurchase);
437     }
438 
439 
440     function _postValidatePurchase(uint256 _tokens) internal view {
441         if (isPreSale) {
442             require(tokenSold.add(_tokens) <= 200000000 ether);
443         }
444 
445     }
446 
447     /**
448      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
449      * @param _beneficiary Address performing the token purchase
450      * @param _tokenAmount Number of tokens to be emitted
451      */
452     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
453         token.safeTransfer(_beneficiary, _tokenAmount);
454     }
455 
456     /**
457      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
458      * @param _beneficiary Address receiving the tokens
459      * @param _tokenAmount Number of tokens to be purchased
460      */
461     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
462         _deliverTokens(_beneficiary, _tokenAmount);
463     }
464 
465     /**
466      * @dev Override to extend the way in which ether is converted to tokens.
467      * @param _weiAmount Value in wei to be converted into tokens
468      * @return Number of tokens that can be purchased with the specified _weiAmount
469      */
470     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
471         if (isPreSale) return _weiAmount.mul(preSaleRate);
472         if (isICO) return _weiAmount.mul(rate);
473         return 0;
474     }
475 
476     /**
477      * @dev Determines how ETH is stored/forwarded on purchases.
478      */
479     function _forwardFunds() internal {
480         wallet.transfer(msg.value);
481     }
482 
483     /**
484      * @dev Must be called after crowdsale ends, to do some extra finalization
485      * work. Calls the contract's finalization function.
486      */
487     function finalize() onlyOwner public {
488         finalization();
489         emit Finalized();
490     }
491 
492     /**
493      * @dev Can be overridden to add finalization logic. The overriding function
494      * should call super.finalization() to ensure the chain of finalization is
495      * executed entirely.
496      */
497     function finalization() internal {
498         token.safeTransfer(msg.sender, token.balanceOf(this));
499     }
500 
501 
502     function setRate(uint _rate) onlyOwner external {
503         rate = _rate;
504     }
505 
506     function setPreSaleRate(uint _rate) onlyOwner external {
507         preSaleRate = _rate;
508     }
509 
510 
511     function setPresaleStatus(bool _status) onlyOwner external {
512         isPreSale = _status;
513     }
514 
515     function setICOStatus(bool _status) onlyOwner external {
516         isICO = _status;
517     }
518 
519     function setMinPurchase(uint _val) onlyOwner external {
520         minPurchase = _val;
521     }
522 }
523 
524 
525 /**
526  * @title TokenTimelock
527  * @dev TokenTimelock is a token holder contract that will allow a
528  * beneficiary to extract the tokens after a given release time
529  */
530 contract TokenTimelock is Ownable {
531     using SafeERC20 for ERC20;
532     using SafeMath for uint256;
533 
534     // ERC20 basic token contract being held
535     ERC20 public token;
536     uint releaseTime;
537 
538     mapping(address => uint256) public balances;
539 
540     constructor(ERC20 _token) public {
541         token = _token;
542         releaseTime = now + 375 days;
543     }
544 
545     function addTokens(address _owner, uint256 _value) onlyOwner external returns (bool) {
546         require(_owner != address(0));
547         //SEND tokens to contract address!!!
548         //token.safeTransferFrom(msg.sender, this, _value);
549         balances[_owner] = balances[_owner].add(_value);
550         return true;
551     }
552 
553 
554     function getTokens() external {
555         require(balances[msg.sender] > 0);
556         require(releaseTime < now);
557 
558         token.safeTransfer(msg.sender, balances[msg.sender]);
559         balances[msg.sender] = 0;
560     }
561 }