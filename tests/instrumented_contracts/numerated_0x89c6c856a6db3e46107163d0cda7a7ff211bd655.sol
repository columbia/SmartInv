1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67 
68   /**
69   * @dev Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72     if (a == 0) {
73       return 0;
74     }
75     uint256 c = a * b;
76     assert(c / a == b);
77     return c;
78   }
79 
80   /**
81   * @dev Integer division of two numbers, truncating the quotient.
82   */
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   /**
91   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
92   */
93   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97 
98   /**
99   * @dev Adds two numbers, throws on overflow.
100   */
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     assert(c >= a);
104     return c;
105   }
106 }
107 
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   uint256 totalSupply_;
127 
128   /**
129   * @dev total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133   }
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance.
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public view returns (uint256 balance) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 
163 
164 /**
165  * @title Burnable Token
166  * @dev Token that can be irreversibly burned (destroyed).
167  */
168 contract BurnableToken is BasicToken {
169 
170   event Burn(address indexed burner, uint256 value);
171 
172   /**
173    * @dev Burns a specific amount of tokens.
174    * @param _value The amount of token to be burned.
175    */
176   function burn(uint256 _value) public {
177     require(_value <= balances[msg.sender]);
178     // no need to require value <= totalSupply, since that would imply the
179     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
180 
181     address burner = msg.sender;
182     balances[burner] = balances[burner].sub(_value);
183     totalSupply_ = totalSupply_.sub(_value);
184     Burn(burner, _value);
185   }
186 }
187 
188 
189 
190 
191 
192 
193 
194 
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address owner, address spender) public view returns (uint256);
202   function transferFrom(address from, address to, uint256 value) public returns (bool);
203   function approve(address spender, uint256 value) public returns (bool);
204   event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 
208 
209 /**
210  * @title Standard ERC20 token
211  *
212  * @dev Implementation of the basic standard token.
213  * @dev https://github.com/ethereum/EIPs/issues/20
214  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
215  */
216 contract StandardToken is ERC20, BasicToken {
217 
218   mapping (address => mapping (address => uint256)) internal allowed;
219 
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amount of tokens to be transferred
226    */
227   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
228     require(_to != address(0));
229     require(_value <= balances[_from]);
230     require(_value <= allowed[_from][msg.sender]);
231 
232     balances[_from] = balances[_from].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
235     Transfer(_from, _to, _value);
236     return true;
237   }
238 
239   /**
240    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
241    *
242    * Beware that changing an allowance with this method brings the risk that someone may use both the old
243    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
244    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
245    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifying the amount of tokens still available for the spender.
260    */
261   function allowance(address _owner, address _spender) public view returns (uint256) {
262     return allowed[_owner][_spender];
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    */
275   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
276     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281   /**
282    * @dev Decrease the amount of tokens that an owner allowed to a spender.
283    *
284    * approve should be called when allowed[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
292     uint oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 
305 
306 
307 
308 /**
309 * @title Allowable
310 * @dev The Allowable contract provides basic functionality to authorize
311 * only allowed addresses to action.
312 */
313 contract Allowable is Ownable {
314 
315     // Contains details regarding allowed addresses
316     mapping (address => bool) public permissions;
317 
318     /**
319     * @dev Reverts if an address is not allowed. Can be used when extending this contract.
320     */
321     modifier isAllowed(address _operator) {
322         require(permissions[_operator] || _operator == owner);
323         _;
324     }
325 
326     /**
327     * @dev Adds single address to the permissions list. Allowed only for contract owner.
328     * @param _operator Address to be added to the permissions list
329     */
330     function allow(address _operator) external onlyOwner {
331         permissions[_operator] = true;
332     }
333 
334     /**
335     * @dev Removes single address from an permissions list. Allowed only for contract owner.  
336     * @param _operator Address to be removed from the permissions list
337     */
338     function deny(address _operator) external onlyOwner {
339         permissions[_operator] = false;
340     }
341 }
342 
343 
344 
345 
346 /**
347  * @title Operable
348  * @dev The Operable contract has an operator address, and provides basic authorization control
349  * functions, this simplifies the implementation of "user permissions".
350  */
351 contract Operable is Ownable {
352     address public operator;
353 
354     event OperatorRoleTransferred(address indexed previousOperator, address indexed newOperator);
355 
356 
357     /**
358     * @dev The Operable constructor sets the original `operator` of the contract to the sender
359     * account.
360     */
361     function Operable() public {
362         operator = msg.sender;
363     }
364 
365     /**
366     * @dev Throws if called by any account other than the owner.
367     */
368     modifier onlyOperator() {
369         require(msg.sender == operator || msg.sender == owner);
370         _;
371     }
372 
373     /**
374     * @dev Allows the current owner to transfer operator role to a newOperator.
375     * @param newOperator The address to transfer Operator role to.
376     */
377     function transferOperatorRole(address newOperator) public onlyOwner {
378         require(newOperator != address(0));
379         OperatorRoleTransferred(operator, newOperator);
380         operator = newOperator;
381     }
382 }
383 
384 
385 /**
386 * @title DaricoEcosystemToken
387 * @dev The DaricoEcosystemToken (DEC) is a ERC20 token.
388 * DEC volume is pre-minted and distributed to a set of pre-configurred wallets according the following rules:
389 *   120000000 - total tokens
390 *   72000000 - tokens for sale
391 *   18000000 - reserved tokens
392 *   18000000 - tokens for the team
393 *   12000000 - tokens for marketing needs
394 * DEC supports burn functionality to destroy tokens left after sale. 
395 * Burn functionality is limited to Operator role that belongs to sale contract
396 * DEC is disactivated by default, which means initially token transfers are allowed to a limited set of addresses. 
397 * Activation functionality is limited to Owner role. After activation token transfers are not limited
398 */
399 contract DaricoEcosystemToken is BurnableToken, StandardToken, Allowable, Operable {
400     using SafeMath for uint256;
401 
402     // token name
403     string public constant name= "Darico Ecosystem Coin";
404     // token symbol
405     string public constant symbol= "DEC";
406     // supported decimals
407     uint256 public constant decimals = 18;
408 
409     //initially tokens locked for any transfers
410     bool public isActive = false;
411 
412     /**
413     * @param _saleWallet Wallet to hold tokens for sale 
414     * @param _reserveWallet Wallet to hold tokens for reserve 
415     * @param _teamWallet Wallet to hold tokens for team 
416     * @param _otherWallet Wallet to hold tokens for other needs  
417     */
418     function DaricoEcosystemToken(address _saleWallet, 
419                                   address _reserveWallet, 
420                                   address _teamWallet, 
421                                   address _otherWallet) public {
422         totalSupply_ = uint256(120000000).mul(10 ** decimals);
423 
424         configureWallet(_saleWallet, uint256(72000000).mul(10 ** decimals));
425         configureWallet(_reserveWallet, uint256(18000000).mul(10 ** decimals));
426         configureWallet(_teamWallet, uint256(18000000).mul(10 ** decimals));
427         configureWallet(_otherWallet, uint256(12000000).mul(10 ** decimals));
428     }
429 
430     /**
431     * @dev checks if address is able to perform token operations
432     * @param _from The address that owns tokens, to check over permissions list
433     */ 
434     modifier whenActive(address _from){
435         if (!permissions[_from]) {            
436             require(isActive);            
437         }
438         _;
439     }
440 
441     /**
442     * @dev Activate tokens. Can be executed by contract Owner only.
443     */
444     function activate() onlyOwner public {
445         isActive = true;
446     }
447 
448     /**
449     * @dev transfer token for a specified address, validates if there are enough unlocked tokens
450     * @param _to The address to transfer to.
451     * @param _value The amount to be transferred.
452     */
453     function transfer(address _to, uint256 _value) public whenActive(msg.sender) returns (bool) {
454         return super.transfer(_to, _value);
455     }
456 
457     /**
458     * @dev Transfer tokens from one address to another, validates if there are enough unlocked tokens
459     * @param _from address The address which you want to send tokens from
460     * @param _to address The address which you want to transfer to
461     * @param _value uint256 the amount of tokens to be transferred
462     */
463     function transferFrom(address _from, address _to, uint256 _value) public whenActive(_from) returns (bool) {        
464         return super.transferFrom(_from, _to, _value);
465     }
466 
467     /**
468     * @dev Burns a specific amount of tokens. Can be executed by contract Operator only.
469     * @param _value The amount of token to be burned.
470     */
471     function burn(uint256 _value) public onlyOperator {
472         super.burn(_value);
473     }
474 
475     /**
476     * @dev Sends tokens to a specified wallet
477     */
478     function configureWallet(address _wallet, uint256 _amount) private {
479         require(_wallet != address(0));
480         permissions[_wallet] = true;
481         balances[_wallet] = _amount;
482         Transfer(address(0), _wallet, _amount);
483     }
484 }