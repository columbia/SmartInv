1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(
144     address _from,
145     address _to,
146     uint256 _value
147   )
148     public
149     returns (bool)
150   {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to transfer control of the contract to a newOwner.
281    * @param newOwner The address to transfer ownership to.
282    */
283   function transferOwnership(address newOwner) public onlyOwner {
284     require(newOwner != address(0));
285     emit OwnershipTransferred(owner, newOwner);
286     owner = newOwner;
287   }
288 
289   /**
290    * @dev Allows the current owner to relinquish control of the contract.
291    */
292   function renounceOwnership() public onlyOwner {
293     emit OwnershipRenounced(owner);
294     owner = address(0);
295   }
296 }
297 
298 /**
299  * @title Mintable token
300  * @dev Simple ERC20 Token example, with mintable token creation
301  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
302  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
303  */
304 contract MintableToken is StandardToken, Ownable {
305   event Mint(address indexed to, uint256 amount);
306   event MintFinished();
307 
308   bool public mintingFinished = false;
309 
310 
311   modifier canMint() {
312     require(!mintingFinished);
313     _;
314   }
315 
316   modifier hasMintPermission() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Function to mint tokens
323    * @param _to The address that will receive the minted tokens.
324    * @param _amount The amount of tokens to mint.
325    * @return A boolean that indicates if the operation was successful.
326    */
327   function mint(
328     address _to,
329     uint256 _amount
330   )
331     hasMintPermission
332     canMint
333     public
334     returns (bool)
335   {
336     totalSupply_ = totalSupply_.add(_amount);
337     balances[_to] = balances[_to].add(_amount);
338     emit Mint(_to, _amount);
339     emit Transfer(address(0), _to, _amount);
340     return true;
341   }
342 
343   /**
344    * @dev Function to stop minting new tokens.
345    * @return True if the operation was successful.
346    */
347   function finishMinting() onlyOwner canMint public returns (bool) {
348     mintingFinished = true;
349     emit MintFinished();
350     return true;
351   }
352 }
353 
354 contract CrowdsaleToken is MintableToken {
355   uint256 public totalTokens = uint256(300000000).mul(1e4); // FEON
356   uint256 public crowdSaleCap = uint256(210000000).mul(1e4); // FEON
357   uint256 public hardCap = uint256(12000).mul(1 ether); // wei
358   uint256 public softCap = uint256(1000).mul(1 ether); // wei
359   uint256 public weiRaised; // wei
360   uint256 public basePrice = 330000000000000; // wei per 1 token
361   uint256 public refundPercent = 90; // %
362   uint256 public preIcoStartDate = 1534291200; // 15.08.2018 00:00:00
363   uint256 public preIcoEndDate = 1537919999; // 25.09.2018 23:59:59
364   uint256 public icoStartDate = 1539561600; // 15.10.2018 00:00:00
365   uint256 public icoEndDate = 1543622399; // 30.11.2018 23:59:59
366   uint256 public refundEndDate = 1543881599; // 03.12.2018 23:59:59
367   uint256 public bonusPeriod = 432000; // 5 days
368   uint256 public bonusLimit1 = uint256(45000).mul(1e4); //with decimals
369   uint256 public bonusLimit2 = uint256(30000).mul(1e4); //with decimals
370   uint256 public bonusLimit3 = uint256(10000).mul(1e4); //with decimals
371   uint256 public bonusLimit4 = uint256(3000).mul(1e4); //with decimals
372   uint256 public bonusLimit5 = uint256(25).mul(1e4); //with decimals
373   address public newOwner = 0x67f00b9B121ab98CF102c5892c14A5e696eA2CC0;
374   address public wallet = 0x3840428703BaA6C614E85CaE6167c59d8922C0FE;
375   mapping(address => uint256) contribution;
376 
377   constructor() public {
378     owner = newOwner;
379     uint256 teamTokens = totalTokens.sub(crowdSaleCap);
380     balances[owner] = teamTokens;
381     totalSupply_ = teamTokens;
382     emit Transfer(address(this), owner, teamTokens);
383   } 
384 
385   function getBonuses (uint256 _tokens) public view returns (uint256) {
386     if (now >= preIcoStartDate && now <= preIcoEndDate) {
387       if (_tokens >= bonusLimit1) return 30;
388       if (_tokens >= bonusLimit2) return 25;
389       if (_tokens >= bonusLimit3) return 20;
390       if (_tokens >= bonusLimit4) return 15;
391       if (_tokens >= bonusLimit5) return 10;
392     }
393     if (now >= icoStartDate && now <= icoEndDate) {
394       if (now <= icoStartDate + bonusPeriod) return 25;
395       if (now <= icoStartDate + bonusPeriod.mul(2)) return 20;
396       if (now <= icoStartDate + bonusPeriod.mul(3)) return 15;
397       if (now <= icoStartDate + bonusPeriod.mul(4)) return 10;
398       return 5;
399     }
400     return 0;
401   }
402 
403   function mint (address _to, uint256 _amount) public returns (bool) {
404     _amount = _amount.mul(1e4);
405     require(totalSupply_.add(_amount) <= totalTokens);
406     return super.mint(_to, _amount);
407   }
408 
409   function () public payable {
410     require(now >= preIcoStartDate);
411     uint256 tokens = msg.value.mul(1e4).div(basePrice);
412     uint256 bonuses = getBonuses(tokens);
413     uint256 extraTokens = tokens.mul(bonuses).div(100);
414     tokens = tokens.add(extraTokens);
415     require(totalSupply_.add(tokens) <= totalTokens);
416     balances[msg.sender] = balances[msg.sender].add(tokens);
417     totalSupply_ = totalSupply_.add(tokens);
418     contribution[msg.sender] = contribution[msg.sender].add(msg.value);
419     weiRaised = weiRaised.add(msg.value);
420     require(weiRaised <= hardCap);
421     if (now > icoEndDate || weiRaised > hardCap) {
422       wallet.transfer(msg.value);
423     } else if (weiRaised >= softCap) {
424       owner.transfer(msg.value);
425     }
426     emit Transfer(address(this), msg.sender, tokens);
427   }
428 
429   function getEther () public onlyOwner {
430     require(now > refundEndDate || weiRaised >= softCap);
431     require(address(this).balance > 0);
432     owner.transfer(address(this).balance);
433   }
434 
435   function setRefundPercent (uint256 _percent) public onlyOwner {
436     require(_percent > 0);
437     require(_percent <= 100);
438     refundPercent = _percent;
439   }
440 
441   function getRefund () public {
442     require(balances[msg.sender] > 0);
443     require(contribution[msg.sender] > 0);
444     require(address(this).balance >= contribution[msg.sender]);
445     require(now > icoEndDate);
446     require(now < refundEndDate);
447     require(weiRaised < softCap);
448     uint256 refund = contribution[msg.sender].mul(refundPercent).div(100);
449     contribution[msg.sender] = 0;
450     balances[msg.sender] = 0;
451     msg.sender.transfer(refund);
452   }
453 }
454 
455 contract FBC is CrowdsaleToken {
456   string public constant name = "Feon Bank Coin";
457   string public constant symbol = "FBC";
458   uint32 public constant decimals = 4;
459 }