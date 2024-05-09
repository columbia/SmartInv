1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
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
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
65 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
112 
113 /**
114  * @title Burnable Token
115  * @dev Token that can be irreversibly burned (destroyed).
116  */
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   /**
122    * @dev Burns a specific amount of tokens.
123    * @param _value The amount of token to be burned.
124    */
125   function burn(uint256 _value) public {
126     _burn(msg.sender, _value);
127   }
128 
129   function _burn(address _who, uint256 _value) internal {
130     require(_value <= balances[_who]);
131     // no need to require value <= totalSupply, since that would imply the
132     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
133 
134     balances[_who] = balances[_who].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Burn(_who, _value);
137     emit Transfer(_who, address(0), _value);
138   }
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     emit Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(address _owner, address _spender) public view returns (uint256) {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
252 
253 /**
254  * @title Ownable
255  * @dev The Ownable contract has an owner address, and provides basic authorization control
256  * functions, this simplifies the implementation of "user permissions".
257  */
258 contract Ownable {
259   address public owner;
260 
261 
262   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
263 
264 
265   /**
266    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
267    * account.
268    */
269   function Ownable() public {
270     owner = msg.sender;
271   }
272 
273   /**
274    * @dev Throws if called by any account other than the owner.
275    */
276   modifier onlyOwner() {
277     require(msg.sender == owner);
278     _;
279   }
280 
281   /**
282    * @dev Allows the current owner to transfer control of the contract to a newOwner.
283    * @param newOwner The address to transfer ownership to.
284    */
285   function transferOwnership(address newOwner) public onlyOwner {
286     require(newOwner != address(0));
287     emit OwnershipTransferred(owner, newOwner);
288     owner = newOwner;
289   }
290 
291 }
292 
293 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
294 
295 /**
296  * @title Mintable token
297  * @dev Simple ERC20 Token example, with mintable token creation
298  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
299  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
300  */
301 contract MintableToken is StandardToken, Ownable {
302   event Mint(address indexed to, uint256 amount);
303   event MintFinished();
304 
305   bool public mintingFinished = false;
306 
307 
308   modifier canMint() {
309     require(!mintingFinished);
310     _;
311   }
312 
313   /**
314    * @dev Function to mint tokens
315    * @param _to The address that will receive the minted tokens.
316    * @param _amount The amount of tokens to mint.
317    * @return A boolean that indicates if the operation was successful.
318    */
319   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
320     totalSupply_ = totalSupply_.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322     emit Mint(_to, _amount);
323     emit Transfer(address(0), _to, _amount);
324     return true;
325   }
326 
327   /**
328    * @dev Function to stop minting new tokens.
329    * @return True if the operation was successful.
330    */
331   function finishMinting() onlyOwner canMint public returns (bool) {
332     mintingFinished = true;
333     emit MintFinished();
334     return true;
335   }
336 }
337 
338 // File: openzeppelin-solidity/contracts/token/ERC20/CappedToken.sol
339 
340 /**
341  * @title Capped token
342  * @dev Mintable token with a token cap.
343  */
344 contract CappedToken is MintableToken {
345 
346   uint256 public cap;
347 
348   function CappedToken(uint256 _cap) public {
349     require(_cap > 0);
350     cap = _cap;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
360     require(totalSupply_.add(_amount) <= cap);
361 
362     return super.mint(_to, _amount);
363   }
364 
365 }
366 
367 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
368 
369 /**
370  * @title Pausable
371  * @dev Base contract which allows children to implement an emergency stop mechanism.
372  */
373 contract Pausable is Ownable {
374   event Pause();
375   event Unpause();
376 
377   bool public paused = false;
378 
379 
380   /**
381    * @dev Modifier to make a function callable only when the contract is not paused.
382    */
383   modifier whenNotPaused() {
384     require(!paused);
385     _;
386   }
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is paused.
390    */
391   modifier whenPaused() {
392     require(paused);
393     _;
394   }
395 
396   /**
397    * @dev called by the owner to pause, triggers stopped state
398    */
399   function pause() onlyOwner whenNotPaused public {
400     paused = true;
401     emit Pause();
402   }
403 
404   /**
405    * @dev called by the owner to unpause, returns to normal state
406    */
407   function unpause() onlyOwner whenPaused public {
408     paused = false;
409     emit Unpause();
410   }
411 }
412 
413 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
414 
415 /**
416  * @title Pausable token
417  * @dev StandardToken modified with pausable transfers.
418  **/
419 contract PausableToken is StandardToken, Pausable {
420 
421   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
422     return super.transfer(_to, _value);
423   }
424 
425   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
426     return super.transferFrom(_from, _to, _value);
427   }
428 
429   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
430     return super.approve(_spender, _value);
431   }
432 
433   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
434     return super.increaseApproval(_spender, _addedValue);
435   }
436 
437   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
438     return super.decreaseApproval(_spender, _subtractedValue);
439   }
440 }
441 
442 // File: contracts/CarryToken.sol
443 
444 // The Carry token and the tokensale contracts
445 // Copyright (C) 2018 Carry Protocol
446 //
447 // This program is free software: you can redistribute it and/or modify
448 // it under the terms of the GNU General Public License as published by
449 // the Free Software Foundation, either version 3 of the License, or
450 // (at your option) any later version.
451 //
452 // This program is distributed in the hope that it will be useful,
453 // but WITHOUT ANY WARRANTY; without even the implied warranty of
454 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
455 // GNU General Public License for more details.
456 //
457 // You should have received a copy of the GNU General Public License
458 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
459 pragma solidity ^0.4.23;
460 
461 
462 
463 
464 contract CarryToken is PausableToken, CappedToken, BurnableToken {
465     string public name = "CarryToken";
466     string public symbol = "CRE";
467     uint8 public decimals = 18;
468 
469     // See also <https://carryprotocol.io/#section-token-distribution>.
470     //                10 billion <---------|   |-----------------> 10^18
471     uint256 constant TOTAL_CAP = 10000000000 * 1000000000000000000;
472 
473     // FIXME: Here we've wanted to use constructor() keyword instead,
474     // but solium/solhint lint softwares don't parse it properly as of
475     // April 2018.
476     function CarryToken() public CappedToken(TOTAL_CAP) {
477     }
478 }