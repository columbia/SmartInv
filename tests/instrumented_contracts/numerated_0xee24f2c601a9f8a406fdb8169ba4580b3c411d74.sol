1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/AddressUtils.sol
4 
5 /**
6  * Utility library of inline functions on addresses
7  */
8 library AddressUtils {
9 
10   /**
11    * Returns whether the target address is a contract
12    * @dev This function will return false if invoked during the constructor of a contract,
13    *  as the code is not actually created until after the constructor finishes.
14    * @param addr address to check
15    * @return whether the target address is a contract
16    */
17   function isContract(address addr) internal view returns (bool) {
18     uint256 size;
19     // XXX Currently there is no better way to check if there is a contract in an address
20     // than to check the size of the code at that address.
21     // See https://ethereum.stackexchange.com/a/14016/36603
22     // for more details about how this works.
23     // TODO Check this again before the Serenity release, because all addresses will be
24     // contracts then.
25     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
26     return size > 0;
27   }
28 
29 }
30 
31 // File: zeppelin-solidity/contracts/math/SafeMath.sol
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     if (a == 0) {
44       return 0;
45     }
46     uint256 c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256 balance) {
134     return balances[_owner];
135   }
136 
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public view returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163   mapping (address => mapping (address => uint256)) internal allowed;
164 
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
180     emit Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(address _owner, address _spender) public view returns (uint256) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   /**
227    * @dev Decrease the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
237     uint oldValue = allowed[msg.sender][_spender];
238     if (_subtractedValue > oldValue) {
239       allowed[msg.sender][_spender] = 0;
240     } else {
241       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
242     }
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247 }
248 
249 // File: src/Token/FallBackToken.sol
250 
251 contract Receiver {
252     function tokenFallback(address from, uint value) public;
253 }
254 
255 contract FallBackToken is StandardToken {
256     function transfer(address _to, uint256 _value) public returns (bool) {
257         require(super.transfer(_to, _value));
258         if (AddressUtils.isContract(_to)) {
259             Receiver(_to).tokenFallback(msg.sender, _value);
260         }
261         return true;
262     }
263 }
264 
265 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
266 
267 /**
268  * @title Ownable
269  * @dev The Ownable contract has an owner address, and provides basic authorization control
270  * functions, this simplifies the implementation of "user permissions".
271  */
272 contract Ownable {
273   address public owner;
274 
275 
276   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278 
279   /**
280    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
281    * account.
282    */
283   function Ownable() public {
284     owner = msg.sender;
285   }
286 
287   /**
288    * @dev Throws if called by any account other than the owner.
289    */
290   modifier onlyOwner() {
291     require(msg.sender == owner);
292     _;
293   }
294 
295   /**
296    * @dev Allows the current owner to transfer control of the contract to a newOwner.
297    * @param newOwner The address to transfer ownership to.
298    */
299   function transferOwnership(address newOwner) public onlyOwner {
300     require(newOwner != address(0));
301     emit OwnershipTransferred(owner, newOwner);
302     owner = newOwner;
303   }
304 
305 }
306 
307 // File: src/Token/Freezable.sol
308 
309 /**
310  * @title Freezable
311  */
312 contract Freezable is Ownable {
313     event FrozenFunds(address target, bool freeze);
314 
315     mapping(address => bool) freezeHolders;
316 
317     function isFreezeAccount(address _holderAddress) public view returns (bool) {
318         return freezeHolders[_holderAddress];
319     }
320     /**
321      * @dev Modifier to make a function callable only when the token holder is not frozen.
322      */
323     modifier whenNotFrozen(address _holderAddress) {
324         require(!freezeHolders[_holderAddress]);
325         _;
326     }
327 
328     /**
329      * @dev Modifier to make a function callable only when the token holder is frozen.
330      */
331     modifier whenFrozen(address _holderAddress) {
332         require(freezeHolders[_holderAddress]);
333         _;
334     }
335 
336     /**
337      * @dev called by the owner to freeze token holder
338      */
339     function freezeAccount(address target, bool freeze) onlyOwner public {
340         require(target != address(0));
341         freezeHolders[target] = freeze;
342         emit FrozenFunds(target, freeze);
343     }
344 
345 }
346 
347 // File: src/Token/FreezableToken.sol
348 
349 contract FreezableToken is StandardToken, Freezable {
350 
351     function transfer(address _to, uint256 _value) public  whenNotFrozen(msg.sender) whenNotFrozen(_to) returns (bool) {
352         return super.transfer(_to, _value);
353     }
354 
355     function transferFrom(address _from, address _to, uint256 _value) public whenNotFrozen(msg.sender) whenNotFrozen(_to) whenNotFrozen(_from) returns (bool) {
356         return super.transferFrom(_from, _to, _value);
357     }
358 
359     function approve(address _spender, uint256 _value) public whenNotFrozen(_spender) whenNotFrozen(msg.sender) returns (bool) {
360         return super.approve(_spender, _value);
361     }
362 
363     function increaseApproval(address _spender, uint _addedValue) public whenNotFrozen(msg.sender) whenNotFrozen(_spender) returns (bool success) {
364         return super.increaseApproval(_spender, _addedValue);
365     }
366 
367     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotFrozen(msg.sender) whenNotFrozen(_spender) returns (bool success) {
368         return super.decreaseApproval(_spender, _subtractedValue);
369     }
370 }
371 
372 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
373 
374 /**
375  * @title Mintable token
376  * @dev Simple ERC20 Token example, with mintable token creation
377  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
378  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
379  */
380 contract MintableToken is StandardToken, Ownable {
381   event Mint(address indexed to, uint256 amount);
382   event MintFinished();
383 
384   bool public mintingFinished = false;
385 
386 
387   modifier canMint() {
388     require(!mintingFinished);
389     _;
390   }
391 
392   /**
393    * @dev Function to mint tokens
394    * @param _to The address that will receive the minted tokens.
395    * @param _amount The amount of tokens to mint.
396    * @return A boolean that indicates if the operation was successful.
397    */
398   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
399     totalSupply_ = totalSupply_.add(_amount);
400     balances[_to] = balances[_to].add(_amount);
401     emit Mint(_to, _amount);
402     emit Transfer(address(0), _to, _amount);
403     return true;
404   }
405 
406   /**
407    * @dev Function to stop minting new tokens.
408    * @return True if the operation was successful.
409    */
410   function finishMinting() onlyOwner canMint public returns (bool) {
411     mintingFinished = true;
412     emit MintFinished();
413     return true;
414   }
415 }
416 
417 // File: src/Token/ReleasableToken.sol
418 
419 contract ReleasableToken is MintableToken {
420     bool public released = false;
421 
422     event Release();
423 
424     modifier isReleased () {
425         require(mintingFinished);
426         require(released);
427         _;
428     }
429     function release() public onlyOwner returns (bool) {
430         require(mintingFinished);
431         require(!released);
432         released = true;
433         emit Release();
434 
435         return true;
436     }
437     function transfer(address _to, uint256 _value) public isReleased returns (bool) {
438         return super.transfer(_to, _value);
439     }
440 
441     function transferFrom(address _from, address _to, uint256 _value) public isReleased returns (bool) {
442         return super.transferFrom(_from, _to, _value);
443     }
444 
445     function approve(address _spender, uint256 _value) public isReleased returns (bool) {
446         return super.approve(_spender, _value);
447     }
448 
449     function increaseApproval(address _spender, uint _addedValue) public isReleased returns (bool success) {
450         return super.increaseApproval(_spender, _addedValue);
451     }
452 
453     function decreaseApproval(address _spender, uint _subtractedValue) public isReleased returns (bool success) {
454         return super.decreaseApproval(_spender, _subtractedValue);
455     }
456 }
457 
458 // File: src/Token/StandardTokenWithCall.sol
459 
460 contract ApprovalReceiver {
461     function receiveApproval(address from, uint value, address tokenContract, bytes extraData) public returns (bool);
462 }
463 
464 contract StandardTokenWithCall is StandardToken {
465 
466     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
467         assert(approve(_spender, _value));
468         return ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
469     }
470 
471 }
472 
473 // File: src/Token/BCoinToken.sol
474 
475 contract BCoinToken is StandardTokenWithCall, ReleasableToken, FreezableToken, FallBackToken {
476 
477     string public constant name = "BCOIN";
478 
479     string public constant symbol = "BCOIN";
480 
481     uint256 public constant decimals = 2;
482 
483 }