1 pragma solidity 0.4.25;
2 
3 // File: contracts\lib\ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: contracts\lib\SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: contracts\lib\BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0), 'Receiving address cannot be 0!');
92     require(_value <= balances[msg.sender], 'Not enough token funds for sender!');
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: contracts\lib\ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 {
119     function allowance(address owner, address spender) public view returns (uint256);
120     function transferFrom(address from, address to, uint256 value) public returns (bool);
121     function approve(address spender, uint256 value) public returns (bool);
122     function totalSupply() public view returns (uint256);
123     function balanceOf(address who) public view returns (uint256);
124     function transfer(address to, uint256 value) public returns (bool);
125 
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 // File: contracts\lib\StandardToken.sol
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
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
184   function allowance(address _owner, address _spender) public view returns (uint256) {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189    * @dev Increase the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _addedValue The amount of tokens to increase the allowance by.
197    */
198   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   /**
205    * @dev Decrease the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To decrement
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 // File: contracts\lib\Ownable.sol
228 
229 /**
230  * @title Ownable
231  * @dev The Ownable contract has an owner address, and provides basic authorization control
232  * functions, this simplifies the implementation of "user permissions".
233  */
234 contract Ownable {
235     address public _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
241      * account.
242      */
243     constructor () internal {
244         _owner = msg.sender;
245         emit OwnershipTransferred(address(0), _owner);
246     }
247 
248     /**
249      * @return the address of the owner.
250      */
251     function owner() public view returns (address) {
252         return _owner;
253     }
254 
255     /**
256      * @dev Throws if called by any account other than the owner.
257      */
258     modifier onlyOwner() {
259         require(isOwner(), "only owner is able call this function");
260         _;
261     }
262 
263     /**
264      * @return true if `msg.sender` is the owner of the contract.
265      */
266     function isOwner() public view returns (bool) {
267         return msg.sender == _owner;
268     }
269 
270     /**
271      * @dev Allows the current owner to relinquish control of the contract.
272      * @notice Renouncing to ownership will leave the contract without an owner.
273      * It will not be possible to call the functions with the `onlyOwner`
274      * modifier anymore.
275      */
276     function renounceOwnership() public onlyOwner {
277         emit OwnershipTransferred(_owner, address(0));
278         _owner = address(0);
279     }
280 
281     /**
282      * @dev Allows the current owner to transfer control of the contract to a newOwner.
283      * @param newOwner The address to transfer ownership to.
284      */
285     function transferOwnership(address newOwner) public onlyOwner {
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers control of the contract to a newOwner.
291      * @param newOwner The address to transfer ownership to.
292      */
293     function _transferOwnership(address newOwner) internal {
294         require(newOwner != address(0));
295         emit OwnershipTransferred(_owner, newOwner);
296         _owner = newOwner;
297     }
298 }
299 
300 // File: contracts\lib\MintableToken.sol
301 
302 /**
303  * @title Mintable token
304  * @dev Simple ERC20 Token example, with mintable token creation
305  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 contract MintableToken is StandardToken, Ownable {
309   event Mint(address indexed to, uint256 amount);
310   event MintFinished();
311 
312   bool public mintingFinished = false;
313 
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320   /**
321    * @dev Function to mint tokens
322    * @param _to The address that will receive the minted tokens.
323    * @param _amount The amount of tokens to mint.
324    * @return A boolean that indicates if the operation was successful.
325    */
326   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
327     totalSupply_ = totalSupply_.add(_amount);
328     balances[_to] = balances[_to].add(_amount);
329     emit Mint(_to, _amount);
330     emit Transfer(address(0), _to, _amount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    * @return True if the operation was successful.
337    */
338   function finishMinting() onlyOwner canMint public returns (bool) {
339     mintingFinished = true;
340     emit MintFinished();
341     return true;
342   }
343 }
344 
345 // File: contracts\lib\Pausable.sol
346 
347 /**
348  * @title Pausable
349  * @dev Base contract which allows children to implement an emergency stop mechanism.
350  */
351 contract Pausable is Ownable {
352     event Pause();
353     event Unpause();
354 
355     bool private _paused;
356 
357     constructor () internal {
358         _paused = false;
359     }
360 
361     /**
362      * @return true if the contract is paused, false otherwise.
363      */
364     function paused() public view returns (bool) {
365         return _paused;
366     }
367 
368     /**
369      * @dev Modifier to make a function callable only when the contract is not paused.
370      */
371     modifier whenNotPaused() {
372         require(!_paused, "must not be paused");
373         _;
374     }
375 
376     /**
377      * @dev Modifier to make a function callable only when the contract is paused.
378      */
379     modifier whenPaused() {
380         require(_paused, "must be paused");
381         _;
382     }
383 
384     /**
385      * @dev called by the owner to pause, triggers stopped state
386      */
387     function pause() public onlyOwner whenNotPaused {
388         _paused = true;
389         emit Pause();
390     }
391 
392     /**
393      * @dev called by the owner to unpause, returns to normal state
394      */
395     function unpause() onlyOwner whenPaused public {
396         _paused = false;
397         emit Unpause();
398     }
399 }
400 
401 // File: contracts\lib\PausableToken.sol
402 
403 /**
404  * @title Pausable token
405  * @dev StandardToken modified with pausable transfers.
406  **/
407 contract PausableToken is StandardToken, Pausable {
408 
409   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
410     return super.transfer(_to, _value);
411   }
412 
413   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
414     return super.transferFrom(_from, _to, _value);
415   }
416 
417   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
418     return super.approve(_spender, _value);
419   }
420 
421   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
422     return super.increaseApproval(_spender, _addedValue);
423   }
424 
425   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
426     return super.decreaseApproval(_spender, _subtractedValue);
427   }
428 }
429 
430 // File: contracts\CompanyToken.sol
431 
432 /**
433  * @title CompanyToken contract - ERC20 compatible token contract with customized token parameters.
434  * @author Gustavo Guimaraes - <gustavo@starbase.co>
435  */
436 contract CompanyToken is PausableToken, MintableToken {
437     string private _name;
438     string private _symbol;
439     uint8 constant private _decimals = 18;
440 
441     /**
442      * @dev Contract constructor function
443      * @param name Token name
444      * @param symbol Token symbol - up to 4 characters
445      */
446     constructor(string name, string symbol) public {
447         _name = name;
448         _symbol = symbol;
449 
450         pause();
451     }
452 
453     /**
454      * @return the name of the token.
455      */
456     function name() public view returns (string) {
457         return _name;
458     }
459 
460     /**
461      * @return the symbol of the token.
462      */
463     function symbol() public view returns (string) {
464         return _symbol;
465     }
466 
467     /**
468      * @return the number of decimals of the token.
469      */
470     function decimals() public pure returns (uint8) {
471         return _decimals;
472     }
473 }