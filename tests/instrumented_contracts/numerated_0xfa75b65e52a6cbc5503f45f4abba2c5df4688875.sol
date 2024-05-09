1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 
217 
218 
219 /**
220  * @title Ownable
221  * @dev The Ownable contract has an owner address, and provides basic authorization control
222  * functions, this simplifies the implementation of "user permissions".
223  */
224 contract Ownable {
225   address public owner;
226 
227 
228   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230 
231   /**
232    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
233    * account.
234    */
235   function Ownable() public {
236     owner = msg.sender;
237   }
238 
239   /**
240    * @dev Throws if called by any account other than the owner.
241    */
242   modifier onlyOwner() {
243     require(msg.sender == owner);
244     _;
245   }
246 
247   /**
248    * @dev Allows the current owner to transfer control of the contract to a newOwner.
249    * @param newOwner The address to transfer ownership to.
250    */
251   function transferOwnership(address newOwner) public onlyOwner {
252     require(newOwner != address(0));
253     OwnershipTransferred(owner, newOwner);
254     owner = newOwner;
255   }
256 
257 }
258 
259 
260 /**
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 contract MintableToken is StandardToken, Ownable {
267   event Mint(address indexed to, uint256 amount);
268   event MintFinished();
269 
270   bool public mintingFinished = false;
271 
272 
273   modifier canMint() {
274     require(!mintingFinished);
275     _;
276   }
277 
278   /**
279    * @dev Function to mint tokens
280    * @param _to The address that will receive the minted tokens.
281    * @param _amount The amount of tokens to mint.
282    * @return A boolean that indicates if the operation was successful.
283    */
284   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
285     totalSupply_ = totalSupply_.add(_amount);
286     balances[_to] = balances[_to].add(_amount);
287     Mint(_to, _amount);
288     Transfer(address(0), _to, _amount);
289     return true;
290   }
291 
292   /**
293    * @dev Function to stop minting new tokens.
294    * @return True if the operation was successful.
295    */
296   function finishMinting() onlyOwner canMint public returns (bool) {
297     mintingFinished = true;
298     MintFinished();
299     return true;
300   }
301 }
302 
303 
304 /*
305     Utilities & Common Modifiers
306 */
307 contract Utils {
308     /**
309         constructor
310     */
311     function Utils() {
312     }
313 
314     // verifies that an amount is greater than zero
315     modifier greaterThanZero(uint256 _amount) {
316         require(_amount > 0);
317         _;
318     }
319 
320     // validates an address - currently only checks that it isn't null
321     modifier validAddress(address _address) {
322         require(_address != 0x0);
323         _;
324     }
325 
326     // verifies that the address is different than this contract address
327     modifier notThis(address _address) {
328         require(_address != address(this));
329         _;
330     }
331 }
332 
333 
334 /*
335     Smart Token interface
336 */
337 contract ISmartToken {
338 
339     string public version = "0.3";
340 
341     // =================================================================================================================
342     //                                      Members
343     // =================================================================================================================
344 
345     bool public transfersEnabled = false;
346 
347     // =================================================================================================================
348     //                                      Event
349     // =================================================================================================================
350 
351     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
352     event NewSmartToken(address _token);
353     // triggered when the total supply is increased
354     event Issuance(uint256 _amount);
355     // triggered when the total supply is decreased
356     event Destruction(uint256 _amount);
357 
358     // =================================================================================================================
359     //                                      Functions
360     // =================================================================================================================
361 
362     function disableTransfers(bool _disable) public;
363     function issue(address _to, uint256 _amount) public;
364     function destroy(address _from, uint256 _amount) public;
365 }
366 
367 
368 contract SmartToken is ISmartToken, Utils, Ownable, MintableToken {
369 
370     string public standard = "Token 0.1";
371     string public name = "";
372     string public symbol = "";
373     uint8 public decimals = 0;
374     bool public transfersEnabled = false;
375     bool public destroyEnabled = false;
376 
377     // allows execution only when transfers aren't disabled
378     modifier transfersAllowed {
379         assert(transfersEnabled);
380         _;
381     }
382 
383     modifier canDestroy() {
384         require(destroyEnabled);
385         _;
386     }
387 
388     function SmartToken(string _name, string _symbol, uint8 _decimals) public {
389         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
390         name = _name;
391         symbol = _symbol;
392         decimals = _decimals;
393     }
394 
395     function setDestroyEnabled(bool _enable) public onlyOwner {
396         destroyEnabled = _enable;
397     }
398 
399     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
400         return super.transfer(_to, _value);
401     }
402 
403     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
404         return super.transferFrom(_from, _to, _value);
405     }
406 
407     /**
408     *
409     */
410     //@Override
411     function disableTransfers(bool _disable) public onlyOwner {
412         transfersEnabled = !_disable;
413     }
414 
415     //@Override
416     function issue(address _to, uint256 _amount) public transfersAllowed onlyOwner canMint validAddress(_to) notThis(_to) {
417         totalSupply_ = totalSupply_.add(_amount);
418         balances[_to] = balances[_to].add(_amount);
419 
420         emit Issuance(_amount);
421         emit Transfer(this, _to, _amount);
422     }
423 
424     //@Override
425     function destroy(address _from, uint256 _amount) public transfersAllowed canDestroy {
426         require(msg.sender == _from || msg.sender == owner);
427         balances[_from] = balances[_from].sub(_amount);
428         totalSupply_ = totalSupply_.sub(_amount);
429         emit Destruction(_amount);
430         emit Transfer(_from, 0x0, _amount);
431     }
432 }
433 
434 
435 
436 
437 contract SwytchToken is SmartToken {
438 
439     /**
440     * @dev Contract Name
441     */
442     string public name = "Swytch Energy Token";
443 
444     /**
445     * @dev Contract Symbol
446     */
447     string public symbol = "SET";
448 
449     /**
450     * @dev Number of decimals
451     */
452     uint8 public decimals = 18;
453 
454     /**
455     * @dev Initial Supply
456     */
457     //    uint256 public INITIAL_SUPPLY = 2.03e8 * (10 ** uint256(decimals));
458     uint256 public initialSupply = 0;
459 
460     uint256 public MAXIMUM_SUPPLY = 3.65e9 * (10 ** uint256(decimals));
461 
462     /**
463      * @dev Constructor that gives msg.sender all of existing tokens.
464      */
465     function SwytchToken()
466     public
467     SmartToken(name, symbol, decimals) {
468         owner = msg.sender;
469         totalSupply_ = initialSupply;
470         balances[msg.sender] = initialSupply;
471         emit Transfer(0x0, owner, initialSupply);
472         emit NewSmartToken(address(this));
473     }
474 
475 
476     /** Mintable overrides */
477     /**
478        * @dev Override function to mint tokens
479        * @param _to The address that will receive the minted tokens.
480        * @param _amount The amount of tokens to mint.
481        * @return A boolean that indicates if the operation was successful.
482        */
483     function mint(address _to, uint256 _amount) public transfersAllowed onlyOwner canMint returns (bool) {
484         var current = totalSupply();
485         assert(current.add(_amount) <= MAXIMUM_SUPPLY);
486         return super.mint(_to, _amount);
487     }
488 
489     function finishMinting() public onlyOwner canMint returns (bool) {
490         return super.finishMinting();
491     }
492 }