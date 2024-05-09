1 pragma solidity 0.4.21;
2 
3 // File: contracts/ERC677Receiver.sol
4 
5 contract ERC677Receiver {
6   function onTokenTransfer(address _from, uint _value, bytes _data) external returns(bool);
7 }
8 
9 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
10 
11 /**
12  * @title ERC20Basic
13  * @dev Simpler version of ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/179
15  */
16 contract ERC20Basic {
17   function totalSupply() public view returns (uint256);
18   function balanceOf(address who) public view returns (uint256);
19   function transfer(address to, uint256 value) public returns (bool);
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 }
22 
23 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender) public view returns (uint256);
31   function transferFrom(address from, address to, uint256 value) public returns (bool);
32   function approve(address spender, uint256 value) public returns (bool);
33   event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 // File: contracts/ERC677.sol
37 
38 contract ERC677 is ERC20 {
39     event Transfer(address indexed from, address indexed to, uint value, bytes data);
40 
41     function transferAndCall(address, uint, bytes) public returns (bool);
42 
43 }
44 
45 // File: contracts/IBurnableMintableERC677Token.sol
46 
47 contract IBurnableMintableERC677Token is ERC677 {
48     function mint(address, uint256) public returns (bool);
49     function burn(uint256 _value) public;
50 }
51 
52 // File: zeppelin-solidity/contracts/math/SafeMath.sol
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   /**
83   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
148 
149 /**
150  * @title Burnable Token
151  * @dev Token that can be irreversibly burned (destroyed).
152  */
153 contract BurnableToken is BasicToken {
154 
155   event Burn(address indexed burner, uint256 value);
156 
157   /**
158    * @dev Burns a specific amount of tokens.
159    * @param _value The amount of token to be burned.
160    */
161   function burn(uint256 _value) public {
162     require(_value <= balances[msg.sender]);
163     // no need to require value <= totalSupply, since that would imply the
164     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
165 
166     address burner = msg.sender;
167     balances[burner] = balances[burner].sub(_value);
168     totalSupply_ = totalSupply_.sub(_value);
169     Burn(burner, _value);
170   }
171 }
172 
173 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
174 
175 contract DetailedERC20 is ERC20 {
176   string public name;
177   string public symbol;
178   uint8 public decimals;
179 
180   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
181     name = _name;
182     symbol = _symbol;
183     decimals = _decimals;
184   }
185 }
186 
187 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
188 
189 /**
190  * @title Ownable
191  * @dev The Ownable contract has an owner address, and provides basic authorization control
192  * functions, this simplifies the implementation of "user permissions".
193  */
194 contract Ownable {
195   address public owner;
196 
197 
198   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200 
201   /**
202    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203    * account.
204    */
205   function Ownable() public {
206     owner = msg.sender;
207   }
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217   /**
218    * @dev Allows the current owner to transfer control of the contract to a newOwner.
219    * @param newOwner The address to transfer ownership to.
220    */
221   function transferOwnership(address newOwner) public onlyOwner {
222     require(newOwner != address(0));
223     OwnershipTransferred(owner, newOwner);
224     owner = newOwner;
225   }
226 
227 }
228 
229 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
230 
231 /**
232  * @title Standard ERC20 token
233  *
234  * @dev Implementation of the basic standard token.
235  * @dev https://github.com/ethereum/EIPs/issues/20
236  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
237  */
238 contract StandardToken is ERC20, BasicToken {
239 
240   mapping (address => mapping (address => uint256)) internal allowed;
241 
242 
243   /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
250     require(_to != address(0));
251     require(_value <= balances[_from]);
252     require(_value <= allowed[_from][msg.sender]);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
263    *
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     allowed[msg.sender][_spender] = _value;
273     Approval(msg.sender, _spender, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint256 specifying the amount of tokens still available for the spender.
282    */
283   function allowance(address _owner, address _spender) public view returns (uint256) {
284     return allowed[_owner][_spender];
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To increment
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _addedValue The amount of tokens to increase the allowance by.
296    */
297   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
298     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
299     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    *
306    * approve should be called when allowed[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param _spender The address which will spend the funds.
311    * @param _subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
314     uint oldValue = allowed[msg.sender][_spender];
315     if (_subtractedValue > oldValue) {
316       allowed[msg.sender][_spender] = 0;
317     } else {
318       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
319     }
320     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321     return true;
322   }
323 
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
327 
328 /**
329  * @title Mintable token
330  * @dev Simple ERC20 Token example, with mintable token creation
331  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
332  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
333  */
334 contract MintableToken is StandardToken, Ownable {
335   event Mint(address indexed to, uint256 amount);
336   event MintFinished();
337 
338   bool public mintingFinished = false;
339 
340 
341   modifier canMint() {
342     require(!mintingFinished);
343     _;
344   }
345 
346   /**
347    * @dev Function to mint tokens
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
353     totalSupply_ = totalSupply_.add(_amount);
354     balances[_to] = balances[_to].add(_amount);
355     Mint(_to, _amount);
356     Transfer(address(0), _to, _amount);
357     return true;
358   }
359 
360   /**
361    * @dev Function to stop minting new tokens.
362    * @return True if the operation was successful.
363    */
364   function finishMinting() onlyOwner canMint public returns (bool) {
365     mintingFinished = true;
366     MintFinished();
367     return true;
368   }
369 }
370 
371 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
372 
373 /**
374  * @title Pausable
375  * @dev Base contract which allows children to implement an emergency stop mechanism.
376  */
377 contract Pausable is Ownable {
378   event Pause();
379   event Unpause();
380 
381   bool public paused = false;
382 
383 
384   /**
385    * @dev Modifier to make a function callable only when the contract is not paused.
386    */
387   modifier whenNotPaused() {
388     require(!paused);
389     _;
390   }
391 
392   /**
393    * @dev Modifier to make a function callable only when the contract is paused.
394    */
395   modifier whenPaused() {
396     require(paused);
397     _;
398   }
399 
400   /**
401    * @dev called by the owner to pause, triggers stopped state
402    */
403   function pause() onlyOwner whenNotPaused public {
404     paused = true;
405     Pause();
406   }
407 
408   /**
409    * @dev called by the owner to unpause, returns to normal state
410    */
411   function unpause() onlyOwner whenPaused public {
412     paused = false;
413     Unpause();
414   }
415 }
416 
417 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
418 
419 /**
420  * @title Pausable token
421  * @dev StandardToken modified with pausable transfers.
422  **/
423 contract PausableToken is StandardToken, Pausable {
424 
425   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
426     return super.transfer(_to, _value);
427   }
428 
429   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
430     return super.transferFrom(_from, _to, _value);
431   }
432 
433   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
434     return super.approve(_spender, _value);
435   }
436 
437   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
438     return super.increaseApproval(_spender, _addedValue);
439   }
440 
441   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
442     return super.decreaseApproval(_spender, _subtractedValue);
443   }
444 }
445 
446 // File: contracts/POA20.sol
447 
448 contract POA20 is
449     IBurnableMintableERC677Token,
450     DetailedERC20,
451     BurnableToken,
452     MintableToken,
453     PausableToken {
454     function POA20(
455         string _name,
456         string _symbol,
457         uint8 _decimals)
458     public DetailedERC20(_name, _symbol, _decimals) {}
459 
460     modifier validRecipient(address _recipient) {
461         require(_recipient != address(0) && _recipient != address(this));
462         _;
463     }
464 
465     function transferAndCall(address _to, uint _value, bytes _data)
466         public validRecipient(_to) returns (bool)
467     {
468         super.transfer(_to, _value);
469         Transfer(msg.sender, _to, _value, _data);
470         if (isContract(_to)) {
471             contractFallback(_to, _value, _data);
472         }
473         return true;
474     }
475 
476     function contractFallback(address _to, uint _value, bytes _data)
477         private
478     {
479         ERC677Receiver receiver = ERC677Receiver(_to);
480         receiver.onTokenTransfer(msg.sender, _value, _data);
481     }
482 
483     function isContract(address _addr)
484         private
485         returns (bool hasCode)
486     {
487         uint length;
488         assembly { length := extcodesize(_addr) }
489         return length > 0;
490     }
491 }