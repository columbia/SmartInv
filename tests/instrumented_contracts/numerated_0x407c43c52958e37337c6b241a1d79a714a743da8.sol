1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 /**
216  * @title Mintable token
217  * @dev Simple ERC20 Token example, with mintable token creation
218  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
219  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
220  */
221 
222 contract MintableToken is StandardToken, Ownable {
223   event Mint(address indexed to, uint256 amount);
224   event MintFinished();
225 
226   bool public mintingFinished = false;
227 
228 
229   modifier canMint() {
230     require(!mintingFinished);
231     _;
232   }
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will receive the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     Transfer(address(0), _to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner public returns (bool) {
253     mintingFinished = true;
254     MintFinished();
255     return true;
256   }
257 }
258 
259 contract SimpleCoinToken is MintableToken {
260     
261   string public constant name = "AntiqMall";
262    
263   string public constant symbol = "AMT";
264     
265   uint32 public constant decimals = 18;
266     
267 }
268 
269 /**
270  * @title Crowdsale
271  * @dev Crowdsale is a base contract for managing a token crowdsale.
272  * Crowdsales have a start and end timestamps, where investors can make
273  * token purchases and the crowdsale will assign them tokens based
274  * on a token per ETH rate. Funds collected are forwarded to a wallet
275  * as they arrive.
276  */
277 contract Crowdsale is Ownable {
278   using SafeMath for uint256;
279 
280   // The token being sold
281   SimpleCoinToken public token;
282 
283   // address where funds are collected
284   address public wallet;
285 
286   // amount of raised in wei
287   uint256 public weiRaised;
288   
289   uint256 public tokensCount;
290   
291   uint256 public bountyTokensCount;
292   
293   enum State {
294     early_pre_ico,  
295     pre_ico,
296     ico_w1,
297     ico_w2,
298     ico_w3,
299     ico_w4,
300     ico,
301     paused,
302     finished
303   }
304   
305   State public currentState;
306   
307   uint256 constant MIN_WEI_VALUE = 1 * 1e16;
308   
309   uint256 constant PRE_ICO_SALE_VALUE = 10;
310   uint256 constant EARLY_PRE_ICO_SALE_VALUE_1 = 4;
311   uint256 constant EARLY_PRE_ICO_SALE_VALUE_2 = 8;
312   uint256 constant EARLY_PRE_ICO_SALE_VALUE_3 = 15;
313   
314   uint256 constant EARLY_PRE_ICO_SALE_BONUS_0 = 50;
315   uint256 constant EARLY_PRE_ICO_SALE_BONUS_1 = 65;
316   uint256 constant EARLY_PRE_ICO_SALE_BONUS_2 = 75;
317   uint256 constant EARLY_PRE_ICO_SALE_BONUS_3 = 85;
318   uint256 constant EARLY_PRE_ICO_SALE_BONUS_4 = 100;
319   
320   uint256 constant PRE_ICO_SALE_BONUS = 100;
321   uint256 constant PRE_ICO_BONUS = 50;
322   uint256 constant ICO_BONUS_W1 = 30;
323   uint256 constant ICO_BONUS_W2 = 20;
324   uint256 constant ICO_BONUS_W3 = 10;
325   uint256 constant ICO_BONUS_W4 =  0;
326   uint256 constant ICO_DEFAULT_BONUS = 0;
327   uint256 constant PRICE = 1000;
328   uint256 constant ICO_TOKENS_LIMIT = 7.5 * 1e6 * 1e18;
329   uint256 constant PRE_ICO_TOKENS_LIMIT = 0.6 * 1e6 * 1e18;
330   
331   uint256 constant RESERVED_TOKENS_PERCENT = 20;
332 
333 
334   /**
335    * event for token purchase logging
336    * @param purchaser who paid for the tokens
337    * @param beneficiary who got the tokens
338    * @param value weis paid for purchase
339    * @param amount amount of tokens purchased
340    */
341   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
342   
343   modifier saleIsOn() {
344     require(currentState <= State.ico);
345     _;
346   }
347 
348   function Crowdsale() {
349     token = createTokenContract();
350     currentState = State.paused;
351     wallet = msg.sender;
352     tokensCount = 0;
353     bountyTokensCount = 0;
354   }
355 
356   // creates the token to be sold.
357   // override this method to have crowdsale of a specific mintable token.
358   function createTokenContract() internal returns (SimpleCoinToken) {
359     return new SimpleCoinToken();
360   }
361 
362   function setIcoState(State _newState) public onlyOwner {
363     currentState = _newState;
364   }
365   
366   function mintBountyTokens(address _wallet) public onlyOwner payable {
367     uint256 tokens = tokensCount.sub(bountyTokensCount);
368     tokens = tokens.mul(25).div(100);
369     tokens = tokens.sub(bountyTokensCount);
370     
371     require(tokens >= 1);
372       
373     // update state
374     tokensCount = tokensCount.add(tokens);
375     bountyTokensCount = bountyTokensCount.add(tokens);
376 
377     token.mint(_wallet, tokens);
378   }
379 
380   // fallback function can be used to buy tokens
381   function () payable {
382     buyTokens(msg.sender);
383   }
384 
385   // low level token purchase function
386   function buyTokens(address beneficiary) public saleIsOn payable {
387     require(beneficiary != address(0));
388     require(msg.value != 0);
389     require(msg.value >= MIN_WEI_VALUE);
390     
391     uint256 limit = getLimit();
392     
393     uint256 weiAmount = msg.value;
394     
395     // calculate token amount to be created
396     uint256 tokens = weiAmount.mul(PRICE);
397     uint256 bonusTokens = getBonusTokens(tokens, weiAmount);
398     
399     tokens = tokens.add(bonusTokens);
400     
401     require(limit >= tokensCount.add(tokens).sub(bountyTokensCount));
402 
403     // update state
404     weiRaised = weiRaised.add(weiAmount);
405     tokensCount = tokensCount.add(tokens);
406 
407     token.mint(beneficiary, tokens);
408     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
409 
410     forwardFunds();
411   }
412   
413   function getBonusTokens(uint256 _tokens, uint256 _weiAmount) private returns(uint256 _bonusTokens) {
414     uint256 bonusTokens = ICO_DEFAULT_BONUS;
415     if(currentState == State.pre_ico) {
416       bonusTokens = _tokens.div(100).mul(PRE_ICO_BONUS);
417       
418       if(_weiAmount >= PRE_ICO_SALE_VALUE.mul(1e18)) {
419         bonusTokens = _tokens.div(100).mul(PRE_ICO_SALE_BONUS);
420       }
421     }
422     if(currentState == State.ico_w1) {
423       bonusTokens = _tokens.div(100).mul(ICO_BONUS_W1);
424     }
425     if(currentState == State.ico_w2) {
426       bonusTokens = _tokens.div(100).mul(ICO_BONUS_W2);
427     }
428     if(currentState == State.ico_w3) {
429       bonusTokens = _tokens.div(100).mul(ICO_BONUS_W3);
430     }
431     if(currentState == State.ico_w4) {
432       bonusTokens = _tokens.div(100).mul(ICO_BONUS_W4);
433     }
434     
435     if(currentState == State.early_pre_ico) {
436         
437         bonusTokens = _tokens.div(100).mul(EARLY_PRE_ICO_SALE_BONUS_0);
438         
439         if(_weiAmount >= 0.5*1e18 && _weiAmount < EARLY_PRE_ICO_SALE_VALUE_1.mul(1e18)) {
440             bonusTokens = _tokens.div(100).mul(EARLY_PRE_ICO_SALE_BONUS_1);
441         }
442         if(_weiAmount >= EARLY_PRE_ICO_SALE_VALUE_1.mul(1e18) && _weiAmount < EARLY_PRE_ICO_SALE_VALUE_2.mul(1e18)) {
443             bonusTokens = _tokens.div(100).mul(EARLY_PRE_ICO_SALE_BONUS_2);
444         }
445         if(_weiAmount >= EARLY_PRE_ICO_SALE_VALUE_2.mul(1e18) && _weiAmount < EARLY_PRE_ICO_SALE_VALUE_3.mul(1e18)) {
446             bonusTokens = _tokens.div(100).mul(EARLY_PRE_ICO_SALE_BONUS_3);
447         }
448         if(_weiAmount >= EARLY_PRE_ICO_SALE_VALUE_3.mul(1e18)) {
449             bonusTokens = _tokens.div(100).mul(EARLY_PRE_ICO_SALE_BONUS_4);
450         }
451     }
452     
453     return bonusTokens;
454   }
455   
456   function getLimit() private returns(uint256 _limit) {
457     if(currentState <= State.pre_ico) {
458       return PRE_ICO_TOKENS_LIMIT;
459     }
460     
461     return ICO_TOKENS_LIMIT.sub(ICO_TOKENS_LIMIT.mul(RESERVED_TOKENS_PERCENT).div(100));
462   }
463 
464   // send ether to the fund collection wallet
465   // override to create custom fund forwarding mechanisms
466   function forwardFunds() internal {
467     wallet.transfer(msg.value);
468   }
469 
470 }