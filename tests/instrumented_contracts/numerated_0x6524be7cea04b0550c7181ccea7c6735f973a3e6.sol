1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56   function approve(address spender, uint256 value) public returns (bool);
57   event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   uint256 totalSupply_;
70 
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     emit Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   function balanceOf(address _owner) public view returns (uint256 balance) {
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
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105     require(_value <= balances[_from]);
106     require(_value <= allowed[_from][msg.sender]);
107 
108     balances[_from] = balances[_from].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111     emit Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   function approve(address _spender, uint256 _value) public returns (bool) {
116     allowed[msg.sender][_spender] = _value;
117     emit Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   function allowance(address _owner, address _spender) public view returns (uint256) {
122     return allowed[_owner][_spender];
123   }
124 
125   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
126     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
132     uint oldValue = allowed[msg.sender][_spender];
133     if (_subtractedValue > oldValue) {
134       allowed[msg.sender][_spender] = 0;
135     } else {
136       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137     }
138     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142 }
143 
144 /**
145  * @title Ownable
146  * @dev The Ownable contract has an owner address, and provides basic authorization control
147  * functions, this simplifies the implementation of "user permissions".
148  */
149 contract Ownable {
150   address public owner;
151 
152 
153   event OwnershipRenounced(address indexed previousOwner);
154   event OwnershipTransferred(
155     address indexed previousOwner,
156     address indexed newOwner
157   );
158 
159   constructor() public {
160     owner = msg.sender;
161   }
162 
163   modifier onlyOwner() {
164     require(msg.sender == owner);
165     _;
166   }
167 
168   function transferOwnership(address newOwner) public onlyOwner {
169     require(newOwner != address(0));
170     emit OwnershipTransferred(owner, newOwner);
171     owner = newOwner;
172   }
173 
174   function renounceOwnership() public onlyOwner {
175     emit OwnershipRenounced(owner);
176     owner = address(0);
177   }
178 }
179 
180 /**
181  * @title Mintable token
182  * @dev Simple ERC20 Token example, with mintable token creation
183  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
184  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
185  */
186 contract MintableToken is StandardToken, Ownable {
187   event Mint(address indexed to, uint256 amount);
188   event MintFinished();
189 
190   bool public mintingFinished = false;
191 
192 
193   modifier canMint() {
194     require(!mintingFinished);
195     _;
196   }
197 
198   modifier hasMintPermission() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   function mint(
204     address _to,
205     uint256 _amount
206   )
207     hasMintPermission
208     canMint
209     public
210     returns (bool)
211   {
212     totalSupply_ = totalSupply_.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     emit Mint(_to, _amount);
215     emit Transfer(address(0), _to, _amount);
216     return true;
217   }
218 
219   function finishMinting() onlyOwner canMint public returns (bool) {
220     mintingFinished = true;
221     emit MintFinished();
222     return true;
223   }
224 }
225 
226 contract Moheto is MintableToken {
227     
228   string public name;
229   string public symbol;
230   uint8 public decimals;
231   uint256 public initialSupply;
232 
233   constructor() public {
234     name = 'Moheto';
235     symbol = 'MOH';
236     decimals = 18;
237     initialSupply = 40000000 * 10 ** uint256(decimals);
238     totalSupply_ = initialSupply;
239     balances[msg.sender] = initialSupply;
240     emit Transfer(0x0, msg.sender, initialSupply);
241   }
242 }
243 
244 /**
245  * @title Pausable
246  * @dev Base contract which allows children to implement an emergency stop mechanism.
247  */
248 contract Pausable is Ownable {
249   event Pause();
250   event Unpause();
251 
252   bool public paused = false;
253 
254   modifier whenNotPaused() {
255     require(!paused);
256     _;
257   }
258 
259   modifier whenPaused() {
260     require(paused);
261     _;
262   }
263 
264   function pause() onlyOwner whenNotPaused public {
265     paused = true;
266     emit Pause();
267   }
268 
269   function unpause() onlyOwner whenPaused public {
270     paused = false;
271     emit Unpause();
272   }
273 }
274 
275 contract Crowdsale is Pausable {
276   using SafeMath for uint256;
277 
278   // The token being sold
279   ERC20 public token;
280 
281   // Address where funds are collected
282   address public wallet;
283 
284   // How many token units a buyer gets per wei
285   uint256 public rate;
286 
287   // Amount of wei raised
288   uint256 public weiRaised;
289   
290   // Max amount of wei accepted in the crowdsale
291   uint256 public cap;
292   
293   // Min amount of wei an investor can send
294   uint256 public minInvest;
295   
296   // Crowdsale opening time
297   uint256 public openingTime;
298   
299   // Crowdsale closing time
300   uint256 public closingTime;
301 
302   // Crowdsale duration in days
303   uint256 public duration;
304 
305   /**
306    * Event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314   constructor() public {
315     rate = 10000;
316     wallet = 0x4d2777C775D76C5D8a4946b1f59A9282d366cd58;
317     token = ERC20(0x42B0896a47F0a4D856E6D74143f967aaD6f7F460);
318     cap = 5000 * 1 ether;
319     minInvest = 0.1 * 1 ether;
320     duration = 122 days;
321     openingTime = 1529280000;  // Determined by start()
322     closingTime = openingTime + duration;  // Determined by start()
323   }
324   
325   /**
326    * @dev called by the owner to start the crowdsale
327    */
328   function start() public onlyOwner {
329     openingTime = now;       
330     closingTime =  now + duration;
331   }
332   
333     /**
334    * @dev Returns the rate of tokens per wei at the present time.
335    * Note that, as price _increases_ with time, the rate _decreases_.
336    * @return The number of tokens a buyer gets per wei at a given time
337    */
338   function getCurrentRate() public view returns (uint256) {
339         if (now <= openingTime.add(61 days)) return rate.add(rate/2);   // bonus 50%
340         if (now > openingTime.add(61 days) && now <= openingTime.add(75 days)) return rate.add(rate/5);   // bonus 20%
341         if (now > openingTime.add(75 days) && now <= openingTime.add(89 days)) return rate.add(rate/2);   // bonus 10%
342   }
343 
344   // -----------------------------------------
345   // Crowdsale external interface
346   // -----------------------------------------
347 
348   /**
349    * @dev fallback function ***DO NOT OVERRIDE***
350    */
351   function () external payable {
352     buyTokens(msg.sender);
353   }
354 
355   /**
356    * @dev low level token purchase ***DO NOT OVERRIDE***
357    * @param _beneficiary Address performing the token purchase
358    */
359   function buyTokens(address _beneficiary) public payable {
360 
361     uint256 weiAmount = msg.value;
362     _preValidatePurchase(_beneficiary, weiAmount);
363 
364     // calculate token amount to be created
365     uint256 tokens = _getTokenAmount(weiAmount);
366 
367     // update state
368     weiRaised = weiRaised.add(weiAmount);
369 
370     _processPurchase(_beneficiary, tokens);
371     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
372 
373     _forwardFunds();
374   }
375 
376   // -----------------------------------------
377   // Internal interface (extensible)
378   // -----------------------------------------
379 
380   /**
381    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
382    * @param _beneficiary Address performing the token purchase
383    * @param _weiAmount Value in wei involved in the purchase
384    */
385   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
386     require(_beneficiary != address(0));
387     require(_weiAmount >= minInvest);
388     require(weiRaised.add(_weiAmount) <= cap);
389     require(now >= openingTime && now <= closingTime);
390   }
391 
392   /**
393    * @dev Overrides delivery by minting tokens upon purchase.
394    * @param _beneficiary Token purchaser
395    * @param _tokenAmount Number of tokens to be minted
396    */
397   function _deliverTokens(
398     address _beneficiary,
399     uint256 _tokenAmount
400   )
401     internal
402   {
403     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
404   }
405 
406   /**
407    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
408    * @param _beneficiary Address receiving the tokens
409    * @param _tokenAmount Number of tokens to be purchased
410    */
411   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
412     _deliverTokens(_beneficiary, _tokenAmount);
413   }
414 
415   /**
416    * @dev Override to extend the way in which ether is converted to tokens.
417    * @param _weiAmount Value in wei to be converted into tokens
418    * @return Number of tokens that can be purchased with the specified _weiAmount
419    */
420   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
421     uint256 currentRate = getCurrentRate();
422     return currentRate.mul(_weiAmount);
423   }
424 
425   /**
426    * @dev Determines how ETH is stored/forwarded on purchases.
427    */
428   function _forwardFunds() internal {
429     wallet.transfer(msg.value);
430   }
431   
432   /**
433    * @dev Checks whether the cap has been reached. 
434    * @return Whether the cap was reached
435    */
436   function capReached() public view returns (bool) {
437     return weiRaised >= cap;
438   }
439   
440   /**
441    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
442    * @return Whether crowdsale period has elapsed
443    */
444   function hasClosed() public view returns (bool) {
445     return now > closingTime;
446   }
447 }