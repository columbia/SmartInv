1 /**
2  * Smart contract - piggy bank.
3  * Contributions are not limited.
4  * If you withdraw your deposit quickly, you lose a commission of 10%
5  * If you keep a deposit for a long time - you will receive income from the increase of the value of the token.
6  * Tokens are fully compatible with the ERC20 standard.
7  */ 
8  
9  
10 
11 
12 pragma solidity ^0.4.25;
13 
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 interface IERC20 {
20   function totalSupply() external view returns (uint256);
21 
22   function balanceOf(address _who) external view returns (uint256);
23 
24   function allowance(address _owner, address _spender) external view returns (uint256);
25 
26   function transfer(address _to, uint256 _value) external returns (bool);
27 
28   function approve(address _spender, uint256 _value) external returns (bool);
29 
30   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
31 
32   event Transfer(
33     address indexed from,
34     address indexed to,
35     uint256 value
36   );
37 
38   event Approval(
39     address indexed owner,
40     address indexed spender,
41     uint256 value
42   );
43 }
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that revert on error
49  */
50 library SafeMath {
51 
52     /**
53     * @dev Multiplies two numbers, reverts on overflow.
54     */
55     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
56         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
57         // benefit is lost if 'b' is also tested.
58         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
59         if (_a == 0) {
60             return 0;
61         }
62 
63         uint256 c = _a * _b;
64         require(c / _a == _b,"Math error");
65 
66         return c;
67     }
68 
69     /**
70     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
71     */
72     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
73         require(_b > 0,"Math error"); // Solidity only automatically asserts when dividing by 0
74         uint256 c = _a / _b;
75         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
82     */
83     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
84         require(_b <= _a,"Math error");
85         uint256 c = _a - _b;
86 
87         return c;
88     }
89 
90     /**
91     * @dev Adds two numbers, reverts on overflow.
92     */
93     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
94         uint256 c = _a + _b;
95         require(c >= _a,"Math error");
96 
97         return c;
98     }
99 
100     /**
101     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
102     * reverts when dividing by zero.
103     */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0,"Math error");
106         return a % b;
107     }
108 }
109 
110 
111 /**
112  * @title Standard ERC20 token
113  * @dev Implementation of the basic standard token.
114  */
115 contract ERC20 is IERC20 {
116     using SafeMath for uint256;
117 
118     mapping (address => uint256) internal balances_;
119 
120     mapping (address => mapping (address => uint256)) private allowed_;
121 
122     uint256 private totalSupply_;
123 
124     /**
125     * @dev Total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }
130 
131     /**
132     * @dev Gets the balance of the specified address.
133     * @param _owner The address to query the the balance of.
134     * @return An uint256 representing the amount owned by the passed address.
135     */
136     function balanceOf(address _owner) public view returns (uint256) {
137         return balances_[_owner];
138     }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146     function allowance(
147         address _owner,
148         address _spender
149     )
150       public
151       view
152       returns (uint256)
153     {
154         return allowed_[_owner][_spender];
155     }
156 
157     /**
158     * @dev Transfer token for a specified address
159     * @param _to The address to transfer to.
160     * @param _value The amount to be transferred.
161     */
162     function transfer(address _to, uint256 _value) public returns (bool) {
163         require(_value <= balances_[msg.sender],"Invalid value");
164         require(_to != address(0),"Invalid address");
165 
166         balances_[msg.sender] = balances_[msg.sender].sub(_value);
167         balances_[_to] = balances_[_to].add(_value);
168         emit Transfer(msg.sender, _to, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174     * Beware that changing an allowance with this method brings the risk that someone may use both the old
175     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178     * @param _spender The address which will spend the funds.
179     * @param _value The amount of tokens to be spent.
180     */
181     function approve(address _spender, uint256 _value) public returns (bool) {
182         allowed_[msg.sender][_spender] = _value;
183         emit Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     /**
188     * @dev Transfer tokens from one address to another
189     * @param _from address The address which you want to send tokens from
190     * @param _to address The address which you want to transfer to
191     * @param _value uint256 the amount of tokens to be transferred
192     */
193     function transferFrom(
194         address _from,
195         address _to,
196         uint256 _value
197     )
198       public
199       returns (bool)
200     {
201         require(_value <= balances_[_from],"Value is more than balance");
202         require(_value <= allowed_[_from][msg.sender],"Value is more than alloved");
203         require(_to != address(0),"Invalid address");
204 
205         balances_[_from] = balances_[_from].sub(_value);
206         balances_[_to] = balances_[_to].add(_value);
207         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
208         emit Transfer(_from, _to, _value);
209         return true;
210     }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    * approve should be called when allowed_[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221     function increaseApproval(
222         address _spender,
223         uint256 _addedValue
224     )
225       public
226       returns (bool)
227     {
228         allowed_[msg.sender][_spender] = (allowed_[msg.sender][_spender].add(_addedValue));
229         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234     * @dev Decrease the amount of tokens that an owner allowed to a spender.
235     * approve should be called when allowed_[_spender] == 0. To decrement
236     * allowed value is better to use this function to avoid 2 calls (and wait until
237     * the first transaction is mined)
238     * From MonolithDAO Token.sol
239     * @param _spender The address which will spend the funds.
240     * @param _subtractedValue The amount of tokens to decrease the allowance by.
241     */
242     function decreaseApproval(
243         address _spender,
244         uint256 _subtractedValue
245     )
246       public
247       returns (bool)
248     {
249         uint256 oldValue = allowed_[msg.sender][_spender];
250         if (_subtractedValue >= oldValue) {
251             allowed_[msg.sender][_spender] = 0;
252         } else {
253             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254         }
255         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
256         return true;
257     }
258 
259     /**
260     * @dev Internal function that mints an amount of the token and assigns it to
261     * an account. This encapsulates the modification of balances such that the
262     * proper events are emitted.
263     * @param _account The account that will receive the created tokens.
264     * @param _amount The amount that will be created.
265     */
266     function _mint(address _account, uint256 _amount) internal returns (bool) {
267         require(_account != 0,"Invalid address");
268         totalSupply_ = totalSupply_.add(_amount);
269         balances_[_account] = balances_[_account].add(_amount);
270         emit Transfer(address(0), _account, _amount);
271         return true;
272     }
273 
274     /**
275     * @dev Internal function that burns an amount of the token of a given
276     * account.
277     * @param _account The account whose tokens will be burnt.
278     * @param _amount The amount that will be burnt.
279     */
280     function _burn(address _account, uint256 _amount) internal returns (bool) {
281         require(_account != 0,"Invalid address");
282         require(_amount <= balances_[_account],"Amount is more than balance");
283 
284         totalSupply_ = totalSupply_.sub(_amount);
285         balances_[_account] = balances_[_account].sub(_amount);
286         emit Transfer(_account, address(0), _amount);
287     }
288 
289 }
290 
291 
292 
293 /**
294  * @title Contract Piggytoken
295  * @dev ERC20 compatible token contract
296  */
297 contract PiggyToken is ERC20 {
298     string public constant name = "PiggyBank Token";
299     string public constant symbol = "Piggy";
300     uint32 public constant decimals = 18;
301     uint256 public INITIAL_SUPPLY = 0; // no tokens on start
302     address public piggyBankAddress;
303     
304 
305 
306     constructor(address _piggyBankAddress) public {
307         piggyBankAddress = _piggyBankAddress;
308     }
309 
310 
311     modifier onlyPiggyBank() {
312         require(msg.sender == piggyBankAddress,"Only PiggyBank contract can run this");
313         _;
314     }
315     
316     modifier validDestination( address to ) {
317         require(to != address(0x0),"Empty address");
318         require(to != address(this),"PiggyBank Token address");
319         _;
320     }
321     
322 
323     /**
324      * @dev Override for testing address destination
325      */
326     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
327         return super.transfer(_to, _value);
328     }
329 
330     /**
331      * @dev Override for testing address destination
332      */
333     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
334         return super.transferFrom(_from, _to, _value);
335     }
336     
337     /**
338      * @dev Override for running only from PiggyBank contract
339      */
340     function mint(address _to, uint256 _value) public onlyPiggyBank returns (bool) {
341         return super._mint(_to, _value);
342     }
343 
344     /**
345      * @dev Override for running only from PiggyBank contract
346      */
347     function burn(address _to, uint256 _value) public onlyPiggyBank returns (bool) {
348         return super._burn(_to, _value);
349     }
350 
351     function() external payable {
352         revert("The token contract don`t receive ether");
353     }  
354 }
355 
356 
357 
358 
359 
360 /**
361  * @title PiggyBank
362  * @dev PiggyBank is a base contract for managing a token buying and selling
363  */
364 contract PiggyBank {
365     using SafeMath for uint256;
366     address public owner;
367     address creator;
368 
369 
370 
371     address myAddress = this;
372     PiggyToken public token = new PiggyToken(myAddress);
373 
374 
375     // How many token units a buyer gets per wei.
376     uint256 public rate;
377 
378     // Amount of wei raised
379     uint256 public weiRaised;
380 
381     event Invest(
382         address indexed investor, 
383         uint256 tokens,
384         uint256 weiAmount,
385         uint256 rate
386     );
387 
388     event Withdraw(
389         address indexed to, 
390         uint256 tokens,
391         uint256 weiAmount,
392         uint256 rate
393     );
394 
395     event TokenPrice(
396         uint256 value
397     );
398 
399     constructor() public {
400         owner = 0x0;
401         creator = msg.sender;
402         rate = 1 ether;
403     }
404 
405     // -----------------------------------------
406     // External interface
407     // -----------------------------------------
408 
409     /**
410     * @dev fallback function
411     */
412     function () external payable {
413         if (msg.value > 0) {
414             _buyTokens(msg.sender);
415         } else {
416             require(msg.data.length == 0,"Only for simple payments");
417             _takeProfit(msg.sender);
418         }
419 
420     }
421 
422     /**
423     * @dev low level token purchase ***DO NOT OVERRIDE***
424     * @param _beneficiary Address performing the token purchase
425     */
426     function _buyTokens(address _beneficiary) internal {
427         uint256 weiAmount = msg.value.mul(9).div(10);
428         uint256 creatorBonus = msg.value.div(100);
429         require(_beneficiary != address(0),"Invalid address");
430 
431         // calculate token amount to be created
432         uint256 tokens = _getTokenAmount(weiAmount);
433         uint256 creatorTokens = _getTokenAmount(creatorBonus);
434 
435         // update state
436         weiRaised = weiRaised.add(weiAmount);
437         //rate = myAddress.balance.div(weiRaised);
438 
439         _processPurchase(_beneficiary, tokens);
440         _processPurchase(creator, creatorTokens);
441         
442         emit Invest(_beneficiary, tokens, msg.value, rate);
443 
444     }
445 
446 
447     // -----------------------------------------
448     // Internal interface (extensible)
449     // -----------------------------------------
450 
451     function _takeProfit(address _beneficiary) internal {
452         uint256 tokens = token.balanceOf(_beneficiary);
453         uint256 weiAmount = tokens.mul(rate).div(1 ether);
454         token.burn(_beneficiary, tokens);
455         _beneficiary.transfer(weiAmount);
456         _updatePrice();
457         
458         emit Withdraw(_beneficiary, tokens, weiAmount, rate);
459     }
460 
461 
462     function _updatePrice() internal {
463         uint256 oldPrice = rate;
464         if (token.totalSupply()>0){
465             rate = myAddress.balance.mul(1 ether).div(token.totalSupply());
466             if (rate != oldPrice){
467                 emit TokenPrice(rate);
468             }
469         }
470     }
471 
472 
473     /**
474     * @dev internal function
475     * @param _beneficiary Address performing the token purchase
476     * @param _tokenAmount Number of tokens to be emitted
477     */
478     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
479         token.mint(_beneficiary, _tokenAmount);
480     }
481 
482 
483     /**
484     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
485     * @param _beneficiary Address receiving the tokens
486     * @param _tokenAmount Number of tokens to be purchased
487     */
488     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
489         _deliverTokens(_beneficiary, _tokenAmount);
490     }
491 
492 
493     /**
494     * @dev this function is ether converted to tokens.
495     * @param _weiAmount Value in wei to be converted into tokens
496     * @return Number of tokens that can be purchased with the specified _weiAmount
497     */
498     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
499         uint256 resultAmount = _weiAmount;
500         return resultAmount.mul(1 ether).div(rate);
501     }
502 
503 }