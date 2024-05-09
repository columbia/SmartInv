1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    */
211   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 // File: zeppelin-solidity/contracts/token/MintableToken.sol
231 
232 /**
233  * @title Mintable token
234  * @dev Simple ERC20 Token example, with mintable token creation
235  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
236  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
237  */
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   /**
252    * @dev Function to mint tokens
253    * @param _to The address that will receive the minted tokens.
254    * @param _amount The amount of tokens to mint.
255    * @return A boolean that indicates if the operation was successful.
256    */
257   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
258     totalSupply = totalSupply.add(_amount);
259     balances[_to] = balances[_to].add(_amount);
260     Mint(_to, _amount);
261     Transfer(address(0), _to, _amount);
262     return true;
263   }
264 
265   /**
266    * @dev Function to stop minting new tokens.
267    * @return True if the operation was successful.
268    */
269   function finishMinting() onlyOwner canMint public returns (bool) {
270     mintingFinished = true;
271     MintFinished();
272     return true;
273   }
274 }
275 
276 // File: contracts/MziToken.sol
277 
278 contract MziToken is MintableToken {
279     string public constant name = "MziToken";
280     string public constant symbol = "MZI";
281     uint8 public constant decimals = 18;
282 }
283 
284 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
285 
286 /**
287  * @title Crowdsale
288  * @dev Crowdsale is a base contract for managing a token crowdsale.
289  * Crowdsales have a start and end timestamps, where investors can make
290  * token purchases and the crowdsale will assign them tokens based
291  * on a token per ETH rate. Funds collected are forwarded to a wallet
292  * as they arrive.
293  */
294 contract Crowdsale {
295   using SafeMath for uint256;
296 
297   // The token being sold
298   MintableToken public token;
299 
300   // start and end timestamps where investments are allowed (both inclusive)
301   uint256 public startTime;
302   uint256 public endTime;
303 
304   // address where funds are collected
305   address public wallet;
306 
307   // how many token units a buyer gets per wei
308   uint256 public rate;
309 
310   // amount of raised money in wei
311   uint256 public weiRaised;
312 
313   /**
314    * event for token purchase logging
315    * @param purchaser who paid for the tokens
316    * @param beneficiary who got the tokens
317    * @param value weis paid for purchase
318    * @param amount amount of tokens purchased
319    */
320   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
321 
322 
323   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
324     require(_startTime >= now);
325     require(_endTime >= _startTime);
326     require(_rate > 0);
327     require(_wallet != address(0));
328 
329     token = createTokenContract();
330     startTime = _startTime;
331     endTime = _endTime;
332     rate = _rate;
333     wallet = _wallet;
334   }
335 
336   // creates the token to be sold.
337   // override this method to have crowdsale of a specific mintable token.
338   function createTokenContract() internal returns (MintableToken) {
339     return new MintableToken();
340   }
341 
342 
343   // fallback function can be used to buy tokens
344   function () external payable {
345     buyTokens(msg.sender);
346   }
347 
348   // low level token purchase function
349   function buyTokens(address beneficiary) public payable {
350     require(beneficiary != address(0));
351     require(validPurchase());
352 
353     uint256 weiAmount = msg.value;
354 
355     // calculate token amount to be created
356     uint256 tokens = weiAmount.mul(rate);
357 
358     // update state
359     weiRaised = weiRaised.add(weiAmount);
360 
361     token.mint(beneficiary, tokens);
362     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
363 
364     forwardFunds();
365   }
366 
367   // send ether to the fund collection wallet
368   // override to create custom fund forwarding mechanisms
369   function forwardFunds() internal {
370     wallet.transfer(msg.value);
371   }
372 
373   // @return true if the transaction can buy tokens
374   function validPurchase() internal view returns (bool) {
375     bool withinPeriod = now >= startTime && now <= endTime;
376     bool nonZeroPurchase = msg.value != 0;
377     return withinPeriod && nonZeroPurchase;
378   }
379 
380   // @return true if crowdsale event has ended
381   function hasEnded() public view returns (bool) {
382     return now > endTime;
383   }
384 
385 
386 }
387 
388 // File: contracts/Moozicore.sol
389 
390 contract Moozicore is Crowdsale {
391 
392     uint256 constant CAP =  1000000000000000000000000000;
393     uint256 constant CAP_PRE_SALE = 166000000000000000000000000;
394     uint256 constant CAP_ICO_SALE = 498000000000000000000000000;
395 
396     uint256 constant RATE_PRE_SALE_WEEK1 = 100000;
397     uint256 constant RATE_PRE_SALE_WEEK2 = 95000;
398     uint256 constant RATE_PRE_SALE_WEEK3 = 90000;
399     uint256 constant RATE_PRE_SALE_WEEK4 = 85000;
400 
401     uint256 constant RATE_ICO_SALE_WEEK1 = 80000;
402     uint256 constant RATE_ICO_SALE_WEEK2 = 75000;
403     uint256 constant RATE_ICO_SALE_WEEK3 = 72500;
404     uint256 constant RATE_ICO_SALE_WEEK4 = 70000;
405 
406     uint256 public startTime;
407     uint256 public endTime;
408 
409     uint256 public totalSupplyIco;
410 
411     function Moozicore (
412         uint256 _startTime,
413         uint256 _endTime,
414         uint256 _rate,
415         address _wallet
416     ) public 
417         Crowdsale(_startTime, _endTime, _rate, _wallet)
418     {
419         startTime = _startTime;
420         endTime = _endTime;
421     }
422 
423     function createTokenContract() internal returns (MintableToken) {
424         return new MziToken();
425     }
426 
427     // overriding Crowdsale#validPurchase
428     function validPurchase() internal constant returns (bool) {
429 
430         if (msg.value < 50000000000000000) {
431             return false;
432         }
433 
434         if (token.totalSupply().add(msg.value.mul(getRate())) >= CAP) {
435             return false;
436         }
437         
438         if (now >= 1517266799 && now < 1533110400) {
439             return false;
440         }
441 
442         if (now <= 1517266799) {
443             if (token.totalSupply().add(msg.value.mul(getRate())) >= CAP_PRE_SALE) {
444                 return false;
445             }
446         }
447 
448         if (now >= 1533110400) {
449             if (totalSupplyIco.add(msg.value.mul(getRate())) >= CAP_ICO_SALE) {
450                 return false;
451             }
452         }
453 
454         return super.validPurchase();
455     }
456 
457      function buyTokens(address beneficiary) payable public {
458         require(beneficiary != address(0));
459         require(validPurchase());
460 
461         uint256 weiAmount = msg.value;
462         uint256 tokens = weiAmount.mul(getRate());
463         weiRaised = weiRaised.add(weiAmount);
464 
465         token.mint(beneficiary, tokens);
466         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
467 
468         if (now >= 1533110400) {
469             totalSupplyIco = totalSupplyIco.add(tokens);
470         }
471 
472         forwardFunds();
473     }
474 
475     function getRate() public constant returns (uint256) {
476         uint256 currentRate = RATE_ICO_SALE_WEEK4;
477 
478         if (now <= 1515452399) {
479             currentRate = RATE_PRE_SALE_WEEK1;
480         } else if (now <= 1516057199) {
481             currentRate = RATE_PRE_SALE_WEEK2;
482         } else if (now <= 1516661999) {
483             currentRate = RATE_PRE_SALE_WEEK3;
484         } else if (now <= 1517266799) {
485             currentRate = RATE_PRE_SALE_WEEK4;
486         } else if (now <= 1533679199) {
487             currentRate = RATE_ICO_SALE_WEEK1;
488         } else if (now <= 1534283999) {
489             currentRate = RATE_ICO_SALE_WEEK2;
490         } else if (now <= 1534888799) {
491             currentRate = RATE_ICO_SALE_WEEK3;
492         } else if (now <= 1535493599) {
493             currentRate = RATE_ICO_SALE_WEEK4;
494         }
495 
496         return currentRate;
497     }
498 
499     function mintTokens(address walletToMint, uint256 t) payable public {
500         require(msg.sender == wallet);
501         require(token.totalSupply().add(t) < CAP);
502         
503         if (now <= 1517266799) {
504             require(token.totalSupply().add(t) < CAP_PRE_SALE);
505         }
506 
507         if (now > 1517266799) {
508             require(totalSupplyIco.add(t) < CAP_ICO_SALE);
509             totalSupplyIco = totalSupplyIco.add(t);
510         }
511 
512         token.mint(walletToMint, t);
513     }
514 }