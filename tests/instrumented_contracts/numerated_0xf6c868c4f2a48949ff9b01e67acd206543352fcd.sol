1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Maths
5  * A library to make working with numbers in Solidity hurt your brain less.
6  */
7 library Maths {
8   /**
9    * @dev Adds two addends together, returns the sum
10    * @param addendA the first addend
11    * @param addendB the second addend
12    * @return sum the sum of the equation (e.g. addendA + addendB)
13    */
14   function plus(
15     uint256 addendA,
16     uint256 addendB
17   ) public pure returns (uint256 sum) {
18     sum = addendA + addendB;
19   }
20 
21   /**
22    * @dev Subtracts the minuend from the subtrahend, returns the difference
23    * @param minuend the minuend
24    * @param subtrahend the subtrahend
25    * @return difference the difference (e.g. minuend - subtrahend)
26    */
27   function minus(
28     uint256 minuend,
29     uint256 subtrahend
30   ) public pure returns (uint256 difference) {
31     assert(minuend >= subtrahend);
32     difference = minuend - subtrahend;
33   }
34 
35   /**
36    * @dev Multiplies two factors, returns the product
37    * @param factorA the first factor
38    * @param factorB the second factor
39    * @return product the product of the equation (e.g. factorA * factorB)
40    */
41   function mul(
42     uint256 factorA,
43     uint256 factorB
44   ) public pure returns (uint256 product) {
45     if (factorA == 0 || factorB == 0) return 0;
46     product = factorA * factorB;
47     assert(product / factorA == factorB);
48   }
49 
50   /**
51    * @dev Multiplies two factors, returns the product
52    * @param factorA the first factor
53    * @param factorB the second factor
54    * @return product the product of the equation (e.g. factorA * factorB)
55    */
56   function times(
57     uint256 factorA,
58     uint256 factorB
59   ) public pure returns (uint256 product) {
60     return mul(factorA, factorB);
61   }
62 
63   /**
64    * @dev Divides the dividend by divisor, returns the truncated quotient
65    * @param dividend the dividend
66    * @param divisor the divisor
67    * @return quotient the quotient of the equation (e.g. dividend / divisor)
68    */
69   function div(
70     uint256 dividend,
71     uint256 divisor
72   ) public pure returns (uint256 quotient) {
73     quotient = dividend / divisor;
74     assert(quotient * divisor == dividend);
75   }
76 
77   /**
78    * @dev Divides the dividend by divisor, returns the truncated quotient
79    * @param dividend the dividend
80    * @param divisor the divisor
81    * @return quotient the quotient of the equation (e.g. dividend / divisor)
82    */
83   function dividedBy(
84     uint256 dividend,
85     uint256 divisor
86   ) public pure returns (uint256 quotient) {
87     return div(dividend, divisor);
88   }
89 
90   /**
91    * @dev Divides the dividend by divisor, returns the quotient and remainder
92    * @param dividend the dividend
93    * @param divisor the divisor
94    * @return quotient the quotient of the equation (e.g. dividend / divisor)
95    * @return remainder the remainder of the equation (e.g. dividend % divisor)
96    */
97   function divideSafely(
98     uint256 dividend,
99     uint256 divisor
100   ) public pure returns (uint256 quotient, uint256 remainder) {
101     quotient = div(dividend, divisor);
102     remainder = dividend % divisor;
103   }
104 
105   /**
106    * @dev Returns the lesser of two values.
107    * @param a the first value
108    * @param b the second value
109    * @return result the lesser of the two values
110    */
111   function min(
112     uint256 a,
113     uint256 b
114   ) public pure returns (uint256 result) {
115     result = a <= b ? a : b;
116   }
117 
118   /**
119    * @dev Returns the greater of two values.
120    * @param a the first value
121    * @param b the second value
122    * @return result the greater of the two values
123    */
124   function max(
125     uint256 a,
126     uint256 b
127   ) public pure returns (uint256 result) {
128     result = a >= b ? a : b;
129   }
130 
131   /**
132    * @dev Determines whether a value is less than another.
133    * @param a the first value
134    * @param b the second value
135    * @return isTrue whether a is less than b
136    */
137   function isLessThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
138     isTrue = a < b;
139   }
140 
141   /**
142    * @dev Determines whether a value is equal to or less than another.
143    * @param a the first value
144    * @param b the second value
145    * @return isTrue whether a is less than or equal to b
146    */
147   function isAtMost(uint256 a, uint256 b) public pure returns (bool isTrue) {
148     isTrue = a <= b;
149   }
150 
151   /**
152    * @dev Determines whether a value is greater than another.
153    * @param a the first value
154    * @param b the second value
155    * @return isTrue whether a is greater than b
156    */
157   function isGreaterThan(uint256 a, uint256 b) public pure returns (bool isTrue) {
158     isTrue = a > b;
159   }
160 
161   /**
162    * @dev Determines whether a value is equal to or greater than another.
163    * @param a the first value
164    * @param b the second value
165    * @return isTrue whether a is less than b
166    */
167   function isAtLeast(uint256 a, uint256 b) public pure returns (bool isTrue) {
168     isTrue = a >= b;
169   }
170 }
171 
172 /**
173  * @title Manageable
174  */
175 contract Manageable {
176   address public owner;
177   address public manager;
178 
179   event OwnershipChanged(address indexed previousOwner, address indexed newOwner);
180   event ManagementChanged(address indexed previousManager, address indexed newManager);
181 
182   /**
183    * @dev The Manageable constructor sets the original `owner` of the contract to the sender
184    * account.
185    */
186   function Manageable() public {
187     owner = msg.sender;
188     manager = msg.sender;
189   }
190 
191   /**
192    * @dev Throws if called by any account other than the owner or manager.
193    */
194   modifier onlyManagement() {
195     require(msg.sender == owner || msg.sender == manager);
196     _;
197   }
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     emit OwnershipChanged(owner, newOwner);
214     owner = newOwner;
215   }
216 
217   /**
218    * @dev Allows the owner or manager to replace the current manager
219    * @param newManager The address to give contract management rights.
220    */
221   function replaceManager(address newManager) public onlyManagement {
222     require(newManager != address(0));
223     emit ManagementChanged(manager, newManager);
224     manager = newManager;
225   }
226 }
227 
228 /**
229  * @title ERC20Basic
230  * @dev Simpler version of ERC20 interface
231  * @dev see https://github.com/ethereum/EIPs/issues/179
232  */
233 contract ERC20Basic {
234   function totalSupply() public view returns (uint256);
235   function balanceOf(address who) public view returns (uint256);
236   function transfer(address to, uint256 value) public returns (bool);
237   event Transfer(address indexed from, address indexed to, uint256 value);
238 }
239 
240 /**
241  * @title ERC20 interface
242  * @dev see https://github.com/ethereum/EIPs/issues/20
243  */
244 contract ERC20 is ERC20Basic {
245   function allowance(address owner, address spender) public view returns (uint256);
246   function transferFrom(address from, address to, uint256 value) public returns (bool);
247   function approve(address spender, uint256 value) public returns (bool);
248   event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 /**
252  * @title Basic token
253  * @dev Basic version of StandardToken, with no allowances.
254  */
255 contract BasicToken is ERC20Basic {
256   using Maths for uint256;
257 
258   mapping(address => uint256) balances;
259 
260   uint256 totalSupply_;
261 
262   /**
263   * @dev total number of tokens in existence
264   */
265   function totalSupply() public view returns (uint256) {
266     return totalSupply_;
267   }
268 
269   /**
270   * @dev transfer token for a specified address
271   * @param _to The address to transfer to.
272   * @param _value The amount to be transferred.
273   */
274   function transfer(address _to, uint256 _value) public returns (bool) {
275     require(_to != address(0));
276     require(_value <= balances[msg.sender]);
277 
278     balances[msg.sender] = balances[msg.sender].minus(_value);
279     balances[_to] = balances[_to].plus(_value);
280     emit Transfer(msg.sender, _to, _value);
281     return true;
282   }
283 
284   /**
285   * @dev Gets the balance of the specified address.
286   * @param _owner The address to query the the balance of.
287   * @return An uint256 representing the amount owned by the passed address.
288   */
289   function balanceOf(address _owner) public view returns (uint256) {
290     return balances[_owner];
291   }
292 
293 }
294 
295 /**
296  * @title Standard ERC20 token
297  *
298  * @dev Implementation of the basic standard token.
299  * @dev https://github.com/ethereum/EIPs/issues/20
300  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
301  */
302 contract StandardToken is ERC20, BasicToken {
303   using Maths for uint256;
304 
305   mapping (address => mapping (address => uint256)) internal allowed;
306 
307 
308   /**
309    * @dev Transfer tokens from one address to another
310    * @param _from address The address which you want to send tokens from
311    * @param _to address The address which you want to transfer to
312    * @param _value uint256 the amount of tokens to be transferred
313    */
314   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
315     require(_to != address(0));
316     require(_value <= balances[_from]);
317     require(_value <= allowed[_from][msg.sender]);
318 
319     balances[_from] = balances[_from].minus(_value);
320     balances[_to] = balances[_to].plus(_value);
321     allowed[_from][msg.sender] = allowed[_from][msg.sender].minus(_value);
322     emit Transfer(_from, _to, _value);
323     return true;
324   }
325 
326   /**
327    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
328    *
329    * Beware that changing an allowance with this method brings the risk that someone may use both the old
330    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
331    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
332    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
333    * @param _spender The address which will spend the funds.
334    * @param _value The amount of tokens to be spent.
335    */
336   function approve(address _spender, uint256 _value) public returns (bool) {
337     allowed[msg.sender][_spender] = _value;
338     emit Approval(msg.sender, _spender, _value);
339     return true;
340   }
341 
342   /**
343    * @dev Function to check the amount of tokens that an owner allowed to a spender.
344    * @param _owner address The address which owns the funds.
345    * @param _spender address The address which will spend the funds.
346    * @return A uint256 specifying the amount of tokens still available for the spender.
347    */
348   function allowance(address _owner, address _spender) public view returns (uint256) {
349     return allowed[_owner][_spender];
350   }
351 
352   /**
353    * @dev Increase the amount of tokens that an owner allowed to a spender.
354    *
355    * approve should be called when allowed[_spender] == 0. To increment
356    * allowed value is better to use this function to avoid 2 calls (and wait until
357    * the first transaction is mined)
358    * From MonolithDAO Token.sol
359    * @param _spender The address which will spend the funds.
360    * @param _addedValue The amount of tokens to increase the allowance by.
361    */
362   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
363     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].plus(_addedValue);
364     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
365     return true;
366   }
367 
368   /**
369    * @dev Decrease the amount of tokens that an owner allowed to a spender.
370    *
371    * approve should be called when allowed[_spender] == 0. To decrement
372    * allowed value is better to use this function to avoid 2 calls (and wait until
373    * the first transaction is mined)
374    * From MonolithDAO Token.sol
375    * @param _spender The address which will spend the funds.
376    * @param _subtractedValue The amount of tokens to decrease the allowance by.
377    */
378   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
379     uint oldValue = allowed[msg.sender][_spender];
380     if (_subtractedValue > oldValue) {
381       allowed[msg.sender][_spender] = 0;
382     } else {
383       allowed[msg.sender][_spender] = oldValue.minus(_subtractedValue);
384     }
385     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 
389 }
390 
391 /**
392  * @title Mintable token
393  * @dev Simple ERC20 Token example, with mintable token creation
394  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
395  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
396  */
397 contract MintableToken is StandardToken, Manageable {
398   using Maths for uint256;
399 
400   event Mint(address indexed to, uint256 amount);
401   event MintFinished();
402 
403   bool public mintingFinished = false;
404 
405 
406   modifier canMint() {
407     require(!mintingFinished);
408     _;
409   }
410 
411   /**
412    * @dev Function to mint tokens
413    * @param _to The address that will receive the minted tokens.
414    * @param _amount The amount of tokens to mint.
415    * @return A boolean that indicates if the operation was successful.
416    */
417   function mint(address _to, uint256 _amount) onlyManagement canMint public returns (bool) {
418     totalSupply_ = totalSupply_.plus(_amount);
419     balances[_to] = balances[_to].plus(_amount);
420     emit Mint(_to, _amount);
421     emit Transfer(address(0), _to, _amount);
422     return true;
423   }
424 
425   /**
426    * @dev Function to stop minting new tokens.
427    * @return True if the operation was successful.
428    */
429   function finishMinting() onlyManagement canMint public returns (bool) {
430     mintingFinished = true;
431     emit MintFinished();
432     return true;
433   }
434 }
435 
436 contract MythexToken is MintableToken {
437   using Maths for uint256;
438 
439   string public constant name     = "Mythex";
440   string public constant symbol   = "MX";
441   uint8  public constant decimals = 0;
442 
443   event Burn(address indexed burner, uint256 value);
444 
445   /**
446    * @dev Burns a specific amount of tokens assigned to a given address
447    * @param _burner The owner of the tokens to be burned
448    * @param _value The amount of token to be burned
449    * @return True if the operation was successful.
450    */
451   function burn(address _burner, uint256 _value) public onlyManagement returns (bool) {
452     require(_value <= balances[_burner]);
453     balances[_burner] = balances[_burner].minus(_value);
454     totalSupply_ = totalSupply_.minus(_value);
455     emit Burn(_burner, _value);
456     return true;
457   }
458 }